import 'package:randomreads/common/constants.dart';
import 'package:randomreads/models/readitem.dart';
import 'dart:convert';

import 'package:randomreads/services/http_service.dart';
// Remove: import 'package:http/http.dart' as http; (no longer needed directly)
// Add: import 'path/to/httpservice.dart'; // Adjust path as needed

class Getreadsservice {
  Future<ReadItem> fetchReadItem(String id) async {
    final url = "${Constants.apiBaseUrl}${Constants.fetchReadbyId}$id";
    final response = await HttpService.get(url);// Optional: pass custom headers if needed
    final data = jsonDecode(response.body);
    return ReadItem.fromJson(data);
  }

  Future<List<ReadItem>> fetchReads() async {
    const url = "https://randomreads-hghhducwbxexbjft.westus3-01.azurewebsites.net/readitems/Mathematics/3";
    final response = await HttpService.get(url);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => ReadItem.fromJson(e)).toList();
  }

  Future<List<ReadItem>> fetchReadsByTopic(String topic) async {
    final url = "${Constants.apiBaseUrl}${Constants.fetchreadsbytopic}$topic";
    final response = await HttpService.get(url);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => ReadItem.fromJson(e)).toList();
  }
}