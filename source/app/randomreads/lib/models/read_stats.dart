// ============================================
// FILE: lib/pages/story_feed_screen.dart
// ============================================

class ReadStats {
  String id;
  int likescount = 0;
  int sharecount = 0;
  int reportscount = 0;
  bool hasliked = false;
  bool hasshared = false;
  bool hasreported = false ;

  ReadStats({required this.id, required this.likescount, required this.sharecount, required this.reportscount, required this.hasliked, required this.hasshared, required this.hasreported});
  factory ReadStats.fromJson(Map<String, dynamic> json) {
    return ReadStats(
      id: json['readid'],
      likescount: json['likescount'],
      sharecount: json['shareCount'],
      reportscount: json['reportscount'],
      hasliked: json['hasliked'],
      hasreported: json['hasreported'],
      hasshared: json['hasshared'],
    );
  }
}



