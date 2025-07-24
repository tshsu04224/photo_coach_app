import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/capture_sheet.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../views/widgets/chat_bubble.dart';
import '../controllers/chat_controller.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatController>(context);
    final messages = chatController.messages;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/camera.png', width: 24, height: 24),
            const SizedBox(width: 8),
            const Text('拍攝主題生成'),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.error_outline),
            onPressed: () {/* TODO: 回報問題 */},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, idx) {
                final msg = messages[messages.length - 1 - idx];
                return ChatBubble(
                  text: msg.text,
                  fromUser: msg.fromUser,
                  subTopics: msg.subTopics,
                  moodboardUrl: msg.moodboardUrl,
                  onEditSubTopic: (topicIndex, newValue) =>
                      chatController.editSubTopic(messages.length - 1 - idx, topicIndex, newValue),
                  onDeleteSubTopic: (topicIndex) =>
                      chatController.deleteSubTopic(messages.length - 1 - idx, topicIndex),
                  onGenerateMoodboardPressed: msg.onGenerateMoodboardPressed,
                  onUserDeclineMoodboard: msg.onUserDeclineMoodboard,
                  onGenerateTasksPressed: msg.onGenerateTasksPressed,
                  onUserDeclineTasks: msg.onUserDeclineTasks,
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    color: Colors.grey.shade600,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.image_outlined),
                    color: Colors.grey.shade600,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => const CaptureSheet(),
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: chatController.inputController,
                      decoration: InputDecoration(
                        hintText: '輸入訊息…',
                        filled: true,
                        fillColor: const Color(0x75DFDEDE),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.grey.shade600,
                    onPressed: () => chatController.sendMessage(
                      chatController.inputController.text,
                      context,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
