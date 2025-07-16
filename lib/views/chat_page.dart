import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import 'widgets/chat_bubble.dart';
import '../services/api_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(text: '哈囉，今天想要拍什麼呢？', fromUser: false));
  }

  void _editSubTopic(int messageIndex, int topicIndex, String newValue) {
    setState(() {
      final topics = _messages[messageIndex].subTopics!;
      if (topicIndex < topics.length) {
        topics[topicIndex] = newValue; // 編輯
      } else {
        topics.add(newValue); // 新增
      }
    });
  }

  void _deleteSubTopic(int messageIndex, int topicIndex) {
    setState(() {
      _messages[messageIndex].subTopics!.removeAt(topicIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          // 對話區
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final msg = _messages[_messages.length - 1 - idx];
                return ChatBubble(
                  text: msg.text,
                  fromUser: msg.fromUser,
                  subTopics: msg.subTopics,
                  moodboardUrl: msg.moodboardUrl,
                  onEditSubTopic: (topicIndex, newValue) =>
                      _editSubTopic(_messages.length - 1 - idx, topicIndex, newValue),
                  onDeleteSubTopic: (topicIndex) =>
                      _deleteSubTopic(_messages.length - 1 - idx, topicIndex),
                  onGenerateMoodboardPressed: msg.onGenerateMoodboardPressed,
                  onUserDeclineMoodboard: msg.onUserDeclineMoodboard,
                );
              },
            ),
          ),

          // 底部輸入區（include safeArea)
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
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
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
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _messages.add(ChatMessage(text: text, fromUser: true)));
    _controller.clear();

    try {
      final aiResp = await ApiService.chat(text);

      setState(() {
        _messages.add(ChatMessage(
          text: aiResp.reply,
          fromUser: false,
          subTopics: aiResp.subTopics.isNotEmpty ? aiResp.subTopics : null,
        ));
      });

      if (aiResp.subTopics.isNotEmpty) {
        setState(() {
          _messages.add(ChatMessage(
            text: "是否要根據主題產生風格參考圖？",
            fromUser: false,
            onGenerateMoodboardPressed: () async {
              setState(() {
                _messages.add(ChatMessage(
                  text: "好，幫我生成！",
                  fromUser: true,
                ));
              });

              await Future.delayed(const Duration(milliseconds: 400));

              final loadingMsg = ChatMessage(
                text: "生成中...",
                fromUser: false,
              );
              setState(() {
                _messages.add(loadingMsg);
              });

              try {
                final visualKeywords = await ApiService.getVisualKeywords(aiResp.subTopics);
                final moodboardUrl = await ApiService.generateMoodboard(visualKeywords);

                setState(() {
                  _messages.remove(loadingMsg);
                  _messages.add(ChatMessage(
                    text: "這是根據你主題生成的風格圖參考：",
                    fromUser: false,
                    moodboardUrl: moodboardUrl,
                  ));
                });
              } catch (e) {
                setState(() {
                  _messages.remove(loadingMsg);
                  _messages.add(ChatMessage(
                    text: '產生風格圖片錯誤：$e',
                    fromUser: false,
                  ));
                });
              }
            },
            onUserDeclineMoodboard: () async {
              setState(() {
                _messages.add(ChatMessage(
                  text: "先不用。",
                  fromUser: true,
                ));
              });

              await Future.delayed(const Duration(milliseconds: 400));

              setState(() {
                _messages.add(ChatMessage(
                  text: "好的，這次我不產生風格圖片。\n如果你之後有需要，可以再告訴我喔～",
                  fromUser: false,
                ));
              });
            },
          ));
        });
      }

    } catch (e) {
      setState(() => _messages.add(ChatMessage(text: '錯誤：$e', fromUser: false)));
    }
  }
}
