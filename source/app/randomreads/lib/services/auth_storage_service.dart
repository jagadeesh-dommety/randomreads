import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class AuthStorageService {
  static const _storage = FlutterSecureStorage(
  );
  // Keys
  static const _keyUserId = 'user_id';
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyAccessTokenExpiry = 'access_token_expiry';
  static const _keyUserProfile = 'user_profile';
  
    /* ---------------------------
     USER ID
  ---------------------------- */

  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }
  /* ---------------------------
     TOKENS
  ---------------------------- */

  static Future<void> saveTokens({
    required String accessToken,
    required DateTime accessTokenExpiry,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(
      key: _keyAccessTokenExpiry,
      value: accessTokenExpiry.toIso8601String(),
    );
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  static Future<DateTime?> getAccessTokenExpiry() async {
    final value = await _storage.read(key: _keyAccessTokenExpiry);
    return value != null ? DateTime.tryParse(value) : null;
  }

  static Future<bool> isAccessTokenExpired() async {
    final expiry = await getAccessTokenExpiry();
    if (expiry == null) return true;
    return DateTime.now().isAfter(expiry);
  }
/* ---------------------------
     USER PROFILE
  ---------------------------- */

  static Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    await _storage.write(
      key: _keyUserProfile,
      value: jsonEncode(profile),
    );
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    final json = await _storage.read(key: _keyUserProfile);
    return json != null ? jsonDecode(json) : null;
  }

  static Future<bool> isUserVerified() async {
    final profile = await getUserProfile();
    return profile?['isVerified'] == true;
  }


  /* ---------------------------
     LOGOUT / CLEAR
  ---------------------------- */

  static Future<void> clearAuthData() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyAccessTokenExpiry);
    await _storage.delete(key: _keyUserProfile);
    // ⚠️ Do NOT delete userId unless full reset
  }

  static Future<void> fullReset() async {
    await _storage.deleteAll();
  }
  }
