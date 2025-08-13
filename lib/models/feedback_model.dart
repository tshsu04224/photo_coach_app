class FeedbackInput {
  final List<String> observation;
  final Map<String, List<String>> techniques;

  FeedbackInput({
    required this.observation,
    required this.techniques,
  });

  Map<String, dynamic> toJson() {
    return {
      'observation': observation,
      'techniques': techniques,
    };
  }
}
