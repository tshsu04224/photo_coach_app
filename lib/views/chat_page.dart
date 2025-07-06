import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../widgets/chat_bubble.dart';
import '../services/api_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(text: '哈囉，今天想要拍什麼呢？', fromUser: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                return ChatBubble(text: msg.text, fromUser: msg.fromUser, subTopics: msg.subTopics, moodboardUrl: msg.moodboardUrl,);
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
          visualKeywords: aiResp.visualKeywords,
        ));
      });

      // mooodboard
      if (aiResp.visualKeywords.isNotEmpty) {
        final url = await ApiService.generateMoodboard(aiResp.visualKeywords);
        setState(() {
          _messages.add(ChatMessage(
            text: "這是根據你想拍的主題產生的風格參考圖：",
            fromUser: false,
            moodboardUrl: url,
          ));
        });
      }

    } catch (e) {
      setState(() => _messages.add(ChatMessage(text: '錯誤：$e', fromUser: false)));
    }
  }
}
