import 'dart:convert';

import 'package:randomreads/common/constants.dart';
import 'package:randomreads/models/user_activity.dart';
import 'package:randomreads/services/http_service.dart';

class UserActivityService {
    Future<bool> updateUserActivity(List<UserActivity> userActivity) async {
        const url = Constants.updateuseractivity;

    final response = await HttpService.post(url, body: jsonEncode(userActivity.map((x) => x.toJson()).toList()));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}