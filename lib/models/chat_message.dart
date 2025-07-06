class ChatMessage {
  final String text;
  final bool fromUser; // true = 使用者, false = AI （誰發訊息）
  final List<String>? subTopics;
  final List<String>? visualKeywords;
  final String? moodboardUrl;

  ChatMessage({
    required this.text,
    required this.fromUser,
    this.subTopics,
    this.visualKeywords,
    this.moodboardUrl,
  });
}