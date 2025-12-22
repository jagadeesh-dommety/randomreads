class ReadItem {
  final String id;
  final String title;
  final String slug;
  final String content;
  String author = "";
  bool isAiGenerated = true;
  final String topic;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReadItem({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    required this.topic,
    required this.createdAt,
    String? author,
    bool? isAiGenerated,
  })  : author = author ?? "",
        isAiGenerated = isAiGenerated ?? true,
        updatedAt = DateTime.now();

  factory ReadItem.fromJson(Map<String, dynamic> json) {
    return ReadItem(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      content: json['content'],
      topic: json['topic'],
      createdAt: DateTime.parse(json['createdAt']),
      author: json['author'],
      isAiGenerated: json['isAiGenerated'],
    );
  }
}
