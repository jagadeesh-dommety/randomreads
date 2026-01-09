import 'package:flutter/material.dart';

import 'package:randomreads/appbars/search_topic_sliver_app_bar.dart';
import 'package:randomreads/models/topic.dart';

class SearchTopicScreen extends StatefulWidget {
  const SearchTopicScreen({super.key});

  @override
  State<SearchTopicScreen> createState() => _SearchTopicScreenState();
}

class _SearchTopicScreenState extends State<SearchTopicScreen> {
  final TextEditingController _searchController = TextEditingController();

  late List<String> _allTopics;
  late List<String> _filteredTopics;

  @override
  void initState() {
    super.initState();
    _allTopics = TopicUtils.getAllTopicNames();
    _filteredTopics = List.from(_allTopics);
    _searchController.addListener(_filterTopics);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTopics);
    _searchController.dispose();
    super.dispose();
  }

  void _filterTopics() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredTopics = query.isEmpty
          ? List.from(_allTopics)
          : _allTopics
              .where((topic) => topic.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // 🔹 Sliver App Bar
          SearchTopicSliverAppBar(
            controller: _searchController,
            onClear: () => _searchController.clear(),
          ),

          // 🔹 Empty State
          if (_filteredTopics.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'No topics found.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            )

          // 🔹 Topic List
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final topicName = _filteredTopics[index];

                  return ListTile(
                    leading: const Icon(Icons.topic),
                    title: Text(topicName),
                    subtitle: Text('Explore stories on $topicName'),
                    onTap: () {
                      Navigator.of(context).pop(topicName);
                    },
                  );
                },
                childCount: _filteredTopics.length,
              ),
            ),
        ],
      ),
    );
  }
}
