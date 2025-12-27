import 'dart:convert';

import 'package:randomreads/common/constants.dart';
import 'package:randomreads/models/TokenResponse.dart';
import 'package:randomreads/services/http_service.dart';

class UserService {
  Future<TokenResponse?> createUser(String userId) async {
    const url = Constants.usersignin;
    final AppUser user = AppUser(id: userId, 
    joinedAt: DateTime.now(),
    name: "Rand${userId.substring(0, 5)}",
    );
    final response = await HttpService.post(url, body: jsonEncode(user.toJson()), authRequired: false);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return TokenResponse.fromJson(data);
    } else {
      return null;
    }
  }
}