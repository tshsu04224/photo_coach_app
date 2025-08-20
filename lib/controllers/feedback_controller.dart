import 'package:flutter/foundation.dart';
import 'package:photo_coach/models/feedback_model.dart';
import 'package:photo_coach/services/feedback_service.dart';

class FeedbackController extends ChangeNotifier {
  String? feedback;
  bool isLoading = false;


  Future<void> fetchFeedback(FeedbackInput input) async {
    isLoading = true;
    notifyListeners();
    final result = await FeedbackService.getFeedback(input);
    feedback = result;


    try {
      final result = await FeedbackService.getFeedback(input);
      feedback = result;
    } catch (e) {
      feedback = '無法取得回饋：$e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
