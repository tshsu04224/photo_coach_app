import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../services/api_service.dart';
import '../services/task_service.dart';
import '../views/generated_tasks_page.dart';
import 'task_controller.dart';

class ChatController extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final TextEditingController inputController = TextEditingController();

  final String? initialPrompt;
  final String? placeType;
  bool _hasInit = false;

  List<ChatMessage> get messages => _messages;

  ChatController({this.initialPrompt, this.placeType, required this.taskService});
  final TaskService taskService;

  void init(BuildContext context) {
    if (_hasInit) return;
    _hasInit = true;

    if (initialPrompt == null || initialPrompt!.isEmpty) {
      _addMessage(ChatMessage(text: '哈囉，今天想要拍什麼呢？', fromUser: false));
    } else {
      sendMessage(initialPrompt!, context);
    }
  }

  void _addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  Future<void> sendMessage(String text, BuildContext context) async {
    if (text.trim().isEmpty) return;
    _addMessage(ChatMessage(text: text, fromUser: true));
    inputController.clear();

    try {
      final aiResp = await ApiService.chat(text, type: placeType);

      _addMessage(ChatMessage(
        text: aiResp.reply,
        fromUser: false,
        subTopics: aiResp.subTopics.isNotEmpty ? aiResp.subTopics : null,
        mainTopic: aiResp.mainTopic,
      ));

      if (aiResp.subTopics.isNotEmpty) {
        _addMoodboardPrompt(aiResp, context);
      }
    } catch (e) {
      _addMessage(ChatMessage(text: '錯誤：$e', fromUser: false));
    }
  }

  void _addMoodboardPrompt(aiResp, BuildContext context) {
    _addMessage(ChatMessage(
      text: "是否要根據主題產生風格參考圖？",
      fromUser: false,
      onGenerateMoodboardPressed: () async {
        _addMessage(ChatMessage(text: "好，幫我生成！", fromUser: true));
        _addMessage(ChatMessage(text: "生成中...", fromUser: false));
        final loadingIndex = _messages.length - 1;

        try {
          final visualKeywords = await ApiService.getVisualKeywords(aiResp.reply, aiResp.subTopics);
          final moodboardUrl = await ApiService.generateMoodboard(visualKeywords);

          _messages.removeAt(loadingIndex);
          _addMessage(ChatMessage(
            text: "這是根據你主題生成的風格圖參考：",
            fromUser: false,
            moodboardUrl: moodboardUrl,
          ));
          _addTaskPrompt(aiResp, context);
        } catch (e) {
          _messages.removeAt(loadingIndex);
          _addMessage(ChatMessage(text: '產生風格圖片錯誤：$e', fromUser: false));
        }
      },
      onUserDeclineMoodboard: () {
        _addMessage(ChatMessage(text: "先不用。", fromUser: true));
        _addMessage(ChatMessage(
          text: "好的，這次我不產生風格圖片。\n如果你之後有需要，可以再告訴我喔～",
          fromUser: false,
        ));
        _addTaskPrompt(aiResp, context);
      },
    ));
  }

  void _addTaskPrompt(aiResp, BuildContext context) {
    _addMessage(ChatMessage(
      text: "如果需要的話，我可以根據主題幫你設計拍攝任務。要試試看嗎？",
      fromUser: false,
      onGenerateTasksPressed: () async {
        _addMessage(ChatMessage(text: "好，幫我產生任務", fromUser: true));
        _addMessage(ChatMessage(text: "產生任務中...", fromUser: false));
        final loadingIndex = _messages.length - 1;

        try {
          final generatedTask = await taskService.createTask(aiResp.mainTopic, aiResp.subTopics);
          
          // 將生成的任務添加到 TaskController
          final taskController = Provider.of<TaskController>(context, listen: false);
          taskController.addTask(generatedTask);

          _messages.removeAt(loadingIndex);
          _addMessage(ChatMessage(
            text: "以下是幫你產生的拍攝任務：",
            fromUser: false,
          ));

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GeneratedTasksPage()),
          );
        } catch (e) {
          _messages.removeAt(loadingIndex);
          _addMessage(ChatMessage(text: '產生任務錯誤：$e', fromUser: false));
        }
      },
      onUserDeclineTasks: () {
        _addMessage(ChatMessage(text: "先不用，謝謝", fromUser: true));
        _addMessage(ChatMessage(
          text: "好的，這次我不產生任務。\n如果你之後有需要，可以再告訴我喔～",
          fromUser: false,
        ));
      },
    ));
  }

  void editSubTopic(int messageIndex, int topicIndex, String newValue) {
    final topics = _messages[messageIndex].subTopics!;
    if (topicIndex < topics.length) {
      topics[topicIndex] = newValue;
    } else {
      topics.add(newValue);
    }
    notifyListeners();
  }

  void deleteSubTopic(int messageIndex, int topicIndex) {
    _messages[messageIndex].subTopics!.removeAt(topicIndex);
    notifyListeners();
  }
}
