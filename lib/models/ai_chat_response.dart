class AIChatResponse {
  final String reply;
  final List<String> subTopics;
  final List<String> visualKeywords;
  final String? moodboardUrl;
  final String? itinerary;

  AIChatResponse({
    required this.reply,
    required this.subTopics,
    required this.visualKeywords,
    this.moodboardUrl,
    this.itinerary,
  });

  factory AIChatResponse.fromJson(Map<String, dynamic> json) {
    return AIChatResponse(
      reply: json['reply'] ?? '',
      subTopics: List<String>.from(json['sub_topics'] ?? []),
      visualKeywords: List<String>.from(json['visual_keywords'] ?? []),
      moodboardUrl: json['moodboard_url'],
      itinerary: json['itinerary'],
    );
  }
}

