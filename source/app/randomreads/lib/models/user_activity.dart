class UserActivity {
  final String userid;
  final String topic;
  final String readid;

  int timeSpent;        // in ms
  bool isCompleted;
  bool isLiked;
  bool isShared;
  bool isReported;

  UserActivity({
    required this.userid,
    required this.topic,
    required this.readid,
    this.timeSpent = 0,
    this.isCompleted = false,
    this.isLiked = false,
    this.isShared = false,
    this.isReported = false
  });

  Map<String, dynamic> toJson() => {
        'userid': userid,
        'topic': topic,
        'readid': readid,
        'timeSpent': timeSpent,
        'isCompleted': isCompleted,
        'islike': isLiked,
        'isshared': isShared,
        'isreported': isReported
      };

  factory UserActivity.fromJson(Map<String, dynamic> json) {
    return UserActivity(
      userid: json['userid'],
      topic: json['topic'],
      readid: json['readid'],
      timeSpent: json['timeSpent'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      isLiked: json['isLiked'] ?? false,
      isShared: json['isShared'] ?? false,
      isReported: json['isReported'] ?? false,
    );
  }
}
