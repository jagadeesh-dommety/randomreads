import 'package:randomreads/common/constants.dart';
import 'package:randomreads/models/read.dart';
import 'package:randomreads/models/readitem.dart';
import 'dart:convert';

import 'package:randomreads/services/http_service.dart';
// Remove: import 'package:http/http.dart' as http; (no longer needed directly)
// Add: import 'path/to/httpservice.dart'; // Adjust path as needed

class Getreadsservice {
  Future<List<Read>> fetchHomeFeed() async {
    const url = Constants.homefeed;
    final response = await HttpService.get(url);

final List<dynamic> list = jsonDecode(response.body);

return list
    .map((e) => Read.fromJson(e as Map<String, dynamic>))
    .toList();
  }

    Future<List<Read>> fetchLikedPosts() async {
    const url = Constants.likedreads;
    final response = await HttpService.get(url);

final List<dynamic> list = jsonDecode(response.body);

return list
    .map((e) => Read.fromJson(e as Map<String, dynamic>))
    .toList();
  }

  Future<Read> fetchReadItem(String id) async {
    final url = "${Constants.apiBaseUrl}${Constants.fetchReadbyId}$id";
    final response =
        await HttpService.get(url); // Optional: pass custom headers if needed
    final data = jsonDecode(response.body);
    return Read.fromJson(data);
  }

  Future<List<Read>> fetchReads() async {
    const url =
        "https://randomreads-hghhducwbxexbjft.westus3-01.azurewebsites.net/readitems/Mathematics/3";
    final response = await HttpService.get(url);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Read.fromJson(e)).toList();
  }

  Future<List<Read>> fetchReadsByTopic(String topic,
      {int count = 5}) async {
    final url = "${Constants.fetchreadsbytopic}$topic/$count";
    final response = await HttpService.get(url);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Read.fromJson(e)).toList();
  }
}
