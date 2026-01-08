import 'package:flutter/material.dart';
import 'package:randomreads/models/topic.dart';
import 'package:randomreads/appbars/randomreads_app_bar.dart';
import 'package:randomreads/pagewidgets/story_feed_screen.dart';

class TopicFeedScreen extends StatefulWidget {
  final String topicName;

  const TopicFeedScreen({super.key, required this.topicName});

  @override
  State<TopicFeedScreen> createState() => _TopicFeedScreenState();
}
class _TopicFeedScreenState extends State<TopicFeedScreen> {
  @override
  Widget build(BuildContext context) {
    String topicName = widget.topicName;
    String enumTopic = TopicUtils.getEnumFromDisplayName(topicName);
    return StoryFeedScreen(title: widget.topicName, topic: enumTopic, likedscreen:false);
  }
}