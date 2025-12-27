
class TokenResponse {
  final String token;
  final DateTime expiresAt;
  final AppUser user;

  TokenResponse({
    required this.token,
    required this.expiresAt,
    required this.user,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt']),
      user: AppUser.fromJson(json['user']),
    );
  }
}


class AppUser {
  final String id;
  final String? name;
  final String? email;
  final String? profileImageUrl;
  final Gender gender;
  final bool isActive;
  final DateTime joinedAt;

  AppUser({
    required this.id,
    this.name,
    this.email,
    this.profileImageUrl,
    this.gender = Gender.unknown,
    this.isActive = true,
    required this.joinedAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      gender: _parseGender(json['gender']),
      isActive: json['isActive'] ?? true,
      joinedAt: DateTime.parse(json['joinedat']),
    );
  }

  static Gender _parseGender(dynamic value) {
    if (value == null) return Gender.unknown;
    return Gender.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toString().toLowerCase(),
      orElse: () => Gender.unknown,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'gender': gender.name,
      'isActive': isActive,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}
enum Gender {
  unknown,
  male,
  female,
  other,
}