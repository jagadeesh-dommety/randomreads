import 'package:flutter/material.dart';
import 'package:randomreads/models/topic.dart';
import 'package:randomreads/pagewidgets/randomreads_app_bar.dart';

class SearchTopicScreen extends StatefulWidget{
  const SearchTopicScreen({super.key});
  @override
  State<SearchTopicScreen> createState() => _SearchTopicScreenState();
}

class _SearchTopicScreenState extends State<SearchTopicScreen>{
  final TextEditingController _searchController = TextEditingController();
  late List<String> _allTopics;
  late List<String> _filteredTopics;
  
  @override
  void initState() {
    super.initState();
    // Initialize _allTopics with all available topics
    _allTopics = TopicUtils.getAllTopicNames(); // Replace with actual topic list retrieval
    _filteredTopics = List.from(_allTopics);
    _searchController.addListener(_filterTopics);
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTopics() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTopics = List.from(_allTopics);
      } else {
        _filteredTopics = _allTopics
            .where((topic) => topic.toLowerCase().contains(query))
            .toList();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Search Topics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Topics',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
              ),
              
            ),
            ),
            Expanded(child: _filteredTopics.isEmpty 
            ? const Center(child: Text('No topics found.', style:  TextStyle(fontStyle: FontStyle.italic)),
            ) : ListView.builder(
              itemCount: _filteredTopics.length,
              itemBuilder: (context, index) {
                final topicName = _filteredTopics[index];
                      return ListTile(
                        leading: const Icon(Icons.topic), // Simple icon since no images
                        title: Text(topicName),
                        subtitle: Text('Explore stories on $topicName'), // Optional teaser
                        onTap: () {
                          // Navigate to topic-specific screen/feed
                          Navigator.of(context).pop(topicName); // Or push to TopicFeedScreen(topicName)
                        },
                );
              }, 
            )
            )
        ],
      ),
    );
  }
}