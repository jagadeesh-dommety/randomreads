import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:randomreads/models/user_activity.dart';

class ActivityStorageService {
  static const _storage = FlutterSecureStorage();

  // Keys
  static const _userActivityKey = 'user_activity';

  /// Save activities (overwrite)
  static Future<void> saveUserActivity(
      List<UserActivity> activities) async {
    final encoded = jsonEncode(
      activities.map((e) => e.toJson()).toList(),
    );

    await _storage.write(
      key: _userActivityKey,
      value: encoded,
    );
  }

  /// Read activities
  static Future<List<UserActivity>> getUserActivity() async {
    final activityRead =
        await _storage.read(key: _userActivityKey);

    if (activityRead == null || activityRead.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(activityRead);

    return decoded
        .map((e) => UserActivity.fromJson(e))
        .toList();
  }

  /// Clear after sending to backend
  static Future<void> clearUserActivity() async {
    await _storage.delete(key: _userActivityKey);
  }
}
