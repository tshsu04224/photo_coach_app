import 'package:flutter/material.dart';
import 'package:photo_coach/themes/app_theme.dart';
import '../models/chat_message.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/capture_sheet.dart';

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
    // 初始 AI 問候
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
            onPressed: () {/* TODO: 警告動作 */},
          ),
        ],
      ),
      body: Column(
        children: [
          // 對話列表
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final msg = _messages[_messages.length - 1 - idx];
                return ChatBubble(text: msg.text, fromUser: msg.fromUser);
              },
            ),
          ),

          // 底部輸入：含 SafeArea
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
                  // 只有這一塊是灰色圓角
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

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, fromUser: true));
      // TODO: 呼叫 AI API，拿到 response 再 add:
      // _messages.add(ChatMessage(text: aiReply, fromUser: false));
    });
    _controller.clear();
  }
}
