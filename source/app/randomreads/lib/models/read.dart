import 'package:randomreads/models/read_stats.dart';
import 'package:randomreads/models/readitem.dart';
class Read {
  final ReadItem readitem;
  final ReadStats readstats;

  Read({
    required this.readitem,
    required this.readstats,
  });

  factory Read.fromJson(Map<String, dynamic> json) {
    return Read(
      readitem: ReadItem.fromJson(json['readitem']),
      readstats: ReadStats.fromJson(json['readstats']),
    );
  }
}