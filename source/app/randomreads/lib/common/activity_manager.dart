// ============================================
// FILE: lib/pages/story_feed_screen.dart
// ============================================

import 'package:randomreads/models/user_activity.dart';
import 'package:randomreads/services/activity_storage_service.dart';
import 'package:randomreads/services/user_activity_service.dart';

class ActivityManager {
  Stopwatch? _stopwatch;
  UserActivity? _currentActivity;
  List<UserActivity> _pendingActivities = [];
  static const int _batchSize = 3;

  bool get isLiked => _currentActivity?.isLiked ?? false;
  bool get isCompleted => _currentActivity?.isCompleted ?? false;

  void startNewActivity({
    required String userid,
    required String topic,
    required String readId,
    bool isLiked = false,
  }) {
    _stopwatch?.stop();
    _currentActivity = UserActivity(
      userid: userid,
      topic: topic,
      readid: readId,
      isCompleted: false,
      timeSpent: 0,
      isLiked: isLiked,
      isShared: false,
      isReported: false,
    );
    _stopwatch = Stopwatch()..start();
  }

  void updateCompletion(bool completed) {
    if (_currentActivity != null && completed) {
      _currentActivity!.isCompleted = completed;
    }
  }

  void setLiked(bool liked) {
    if (_currentActivity != null) {
      _currentActivity!.isLiked = liked;
    }
  }

  void setShared(bool shared) {
    if (_currentActivity != null) {
      _currentActivity!.isShared = shared;
    }
  }

  void setReported(bool reported) {
    if (_currentActivity != null) {
      _currentActivity!.isReported = reported;
    }
  }

  Future<void> saveCurrentActivity() async {
    if (_currentActivity == null || !_stopwatch!.isRunning) return;

    _stopwatch!.stop();
    _currentActivity!.timeSpent = _stopwatch!.elapsedMilliseconds ~/ 1000; // Seconds
    if (_currentActivity!.timeSpent > 5){
          _pendingActivities.add(_currentActivity!);
              _saveIfBatchFull(); // Check batch

    }
  }

  Future<void> _saveIfBatchFull() async {
    if (_pendingActivities.length >= _batchSize) {
      // Save batch to service
     bool issuccess = await  UserActivityService().updateUserActivity(_pendingActivities);
     if (issuccess){
            _pendingActivities.clear();
     }
    } else {
      // Save to local storage
      ActivityStorageService.saveUserActivity(_pendingActivities);
    }
  }

  void dispose() {
    _stopwatch?.stop();
    _saveIfBatchFull(); // Flush on dispose
  }
}