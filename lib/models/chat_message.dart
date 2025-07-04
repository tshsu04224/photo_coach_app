class ChatMessage {
  final String text;
  final bool fromUser; // true = 使用者, false = AI
  ChatMessage({required this.text, required this.fromUser});
}