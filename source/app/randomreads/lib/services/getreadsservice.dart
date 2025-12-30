import 'package:randomreads/common/constants.dart';
import 'package:randomreads/models/readitem.dart';
import 'dart:convert';

import 'package:randomreads/services/http_service.dart';
// Remove: import 'package:http/http.dart' as http; (no longer needed directly)
// Add: import 'path/to/httpservice.dart'; // Adjust path as needed

class Getreadsservice {
  Future<List<ReadItem>> fetchHomeFeed() async {
    const url = Constants.homefeed;
    final response = await HttpService.get(url);

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List list = json['result'];

    return list.map((e) => ReadItem.fromJson(e)).toList();
  }

  Future<ReadItem> fetchReadItem(String id) async {
    final url = "${Constants.apiBaseUrl}${Constants.fetchReadbyId}$id";
    final response =
        await HttpService.get(url); // Optional: pass custom headers if needed
    final data = jsonDecode(response.body);
    return ReadItem.fromJson(data);
  }

  Future<List<ReadItem>> fetchReads() async {
    const url =
        "https://randomreads-hghhducwbxexbjft.westus3-01.azurewebsites.net/readitems/Mathematics/3";
    final response = await HttpService.get(url);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => ReadItem.fromJson(e)).toList();
  }

  Future<List<ReadItem>> fetchReadsByTopic(String topic,
      {int count = 5}) async {
    final url = "${Constants.fetchreadsbytopic}$topic/$count";
    final response = await HttpService.get(url);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => ReadItem.fromJson(e)).toList();
  }
}
