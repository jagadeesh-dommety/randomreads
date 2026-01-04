// ============================================
// FILE: lib/pages/story_feed_screen.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randomreads/common/activity_manager.dart';
import 'package:randomreads/models/read.dart';
import 'package:randomreads/models/read_stats.dart';
import 'package:randomreads/models/readitem.dart';
import 'package:randomreads/appbars/randomreads_app_bar.dart';
import 'package:randomreads/pagewidgets/reading_content.dart';
import 'package:randomreads/pagewidgets/reading_progress_indicator.dart';
import 'package:randomreads/pagewidgets/snackbar_helper.dart';
import 'package:randomreads/appbars/topic_app_bar.dart';
import 'package:randomreads/services/auth_storage_service.dart';
import 'package:randomreads/services/getreadsservice.dart';

class StoryFeedScreen extends StatefulWidget {
  final String title;
  final String? topic;  // null for random/all; non-null for topic-specific
  final VoidCallback? toggleTheme;

  const StoryFeedScreen({
    super.key,
    required this.title,
    this.topic,
    this.toggleTheme,
  });

  @override
  State<StoryFeedScreen> createState() => _StoryFeedScreenState();
}

class _StoryFeedScreenState extends State<StoryFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  final Getreadsservice _readsService = Getreadsservice();
  final ActivityManager _activityManager = ActivityManager(); // New modular class for activity
  
  // State variables
  List<Read> _readsList = [];
  int _currentReadIndex = 0;
  double _scrollProgress = 0.0;
  bool _isLoading = true;
  int _fontSizeIndex = 1; // 0: Small, 1: Medium, 2: Large
  String _currentSort = 'newest';  // Default sort for topics (or 'relevance' if preferred)

  // Constants
  static const List<double> _fontSizes = [14.0, 16.0, 18.0];
  static const List<double> _lineHeights = [1.8, 1.9,2.0];
  static const List<String> _fontSizeLabels = ['Small', 'Medium', 'Large'];
  static const double _swipeThreshold = 100.0;
  static const double _completionThreshold = 0.6; // 60% scroll for completion
  SwipeDirection _swipeDirection = SwipeDirection.left;

  ReadItem? get _currentReadItem =>
      _readsList.isNotEmpty ? _readsList[_currentReadIndex].readitem : null;
  ReadStats? get _currentReadStats => 
     _readsList.isNotEmpty ? _readsList[_currentReadIndex].readstats : null;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollProgress);
    _swipeDirection = SwipeDirection.left;
    _loadReads();
  }

  @override
  void dispose() {
    _activityManager.dispose(); // Clean up manager
    _scrollController.removeListener(_updateScrollProgress);
    _scrollController.dispose();
    super.dispose();
  }

  // ============================================
  // Data Loading (Parameterized for Topic)
  // ============================================
  
  Future<void> _loadReads() async {
    try {
      List<Read> reads;
      if (widget.topic != null) {
        // Topic-specific fetch (implement in service)
        reads = await _readsService.fetchReadsByTopic(widget.topic!);
      } else {
        // Random/all fetch
        reads = await _readsService.fetchHomeFeed();
      }
      if (mounted) {
        
        
        setState(() {
          _readsList = reads;
          _isLoading = false;
        });
       _startNewActivity(reads[_currentReadIndex].readitem);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        SnackbarHelper.showError(context, 'Failed to load articles');
      }
    }
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.mediumImpact();
    await _loadReads();
    if (mounted) {
      setState(() {
        _currentReadIndex = 0;
      });
    }
  }

  Future<void> _startNewActivity(ReadItem item) async {
    String? userid = await AuthStorageService.getUserId();
    if (userid != null) {
      _activityManager.startNewActivity(
        userid: userid,
        topic: item.topic,
        readId: item.id,
        isLiked: _activityManager.isLiked, // Carry over if needed
      );
    }
  }

  // ============================================
  // Scroll Management
  // ============================================
  
  void _updateScrollProgress() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll > 0) {
      final progress = (currentScroll / maxScroll).clamp(0.0, 1.0);
      setState(() => _scrollProgress = progress);
      _activityManager.updateCompletion(progress >= _completionThreshold);
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // ============================================
  // Interaction Handlers
  // ============================================
  
  void _handleSingleTap() {
    HapticFeedback.lightImpact();
    setState(() {
      _fontSizeIndex = (_fontSizeIndex + 1) % _fontSizes.length;
    });
    SnackbarHelper.showQuick(
      context,
      'Font: ${_fontSizeLabels[_fontSizeIndex]}',
    );
  }



  // ============================================
  // Navigation Handlers (Swipe)
  // ============================================
  
  Future<void> _handleSwipeRight() async {
    if (_currentReadIndex > 0) {
      HapticFeedback.mediumImpact();
      await _activityManager.saveCurrentActivity(); // Save before moving
      setState(() {
        _swipeDirection = SwipeDirection.right;
        _currentReadIndex--;
      });
      _startNewActivity(_readsList[_currentReadIndex].readitem); // Start new
      _scrollToTop();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _handleSwipeLeft() async {
    if (_currentReadIndex < _readsList.length - 1) {
      HapticFeedback.mediumImpact();
      await _activityManager.saveCurrentActivity(); // Save before moving
      if (_currentReadIndex > _readsList.length - 2) {
        await _loadMoreReads();
      }
      setState(() {
        _swipeDirection = SwipeDirection.left;
        _currentReadIndex++;
      });
      _startNewActivity(_readsList[_currentReadIndex].readitem); // Start new
      _scrollToTop();
    } else {
      HapticFeedback.lightImpact();
      final message = widget.topic != null ? 'No more in ${widget.title}' : 'No more articles';
      SnackbarHelper.showInfo(context, message);
    }
  }

  Future<void> _loadMoreReads() async {
    try {
      List<Read> moreReads;
      if (widget.topic != null) {
        moreReads = await _readsService.fetchReadsByTopic(widget.topic!);
      } else {
        moreReads = await _readsService.fetchHomeFeed();
      }
      if (mounted && moreReads.isNotEmpty) {
        setState(() {
          _readsList.addAll(moreReads);
        });
      }
    } catch (e) {
      // Silent fail or log
    }
  }

    void _handleDoubleTap() {
    HapticFeedback.mediumImpact();
            setState(() {
          _currentReadStats?.hasliked = !_currentReadStats!.hasliked;
          if (_currentReadStats!.hasliked){
            _currentReadStats!.likescount += 1;
          } else {
            _currentReadStats!.likescount -= 1;
          }
          _activityManager.setLiked(_currentReadStats!.hasliked);
        });
    SnackbarHelper.showWithIcon(
      context,
      _currentReadStats!.hasliked ? 'Liked!' : 'Unliked',
      _currentReadStats!.hasliked ? Icons.favorite : Icons.favorite_border,
      
    );
  }

  void _handleHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity! > _swipeThreshold) {
      _handleSwipeRight();
    } else if (details.primaryVelocity! < -_swipeThreshold) {
      _handleSwipeLeft();
    }
  }

  // ============================================
  // Build Method
  // ============================================
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth > 800 ? 700.0 : screenWidth * 0.95;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentReadItem == null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No articles available',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _handleRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          RefreshIndicator(
            displacement: 80,
            onRefresh: _handleRefresh,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Reusable SliverAppBar (replace with RandomreadsAppBar if updated to take title/toggleTheme)
                (widget.topic == null || widget.topic!.isEmpty) ? 
                RandomreadsAppBar(theme: theme) :
                TopicAppBar(title: widget.topic!, theme: theme, onSortSelected: (sorttype) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _currentSort = sorttype;
                  });
                  _loadReads();
                },),
                SliverToBoxAdapter(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 700),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final offsetAnimation = Tween<Offset>(
                          begin: Offset(_swipeDirection == SwipeDirection.left ? 1.0 : -1.0, 0),
                          end: Offset.zero,
                        ).animate(animation);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: FadeTransition(opacity: animation, child: child),
                        );
                      },
                      child: ReadingContent(
                        key: ValueKey(_currentReadIndex),
                        contentWidth: contentWidth,
                        currentReadItem: _currentReadItem!,
                        currentReadStats: _currentReadStats!,
                        fontSize: _fontSizes[_fontSizeIndex],
                        lineHeight: _lineHeights[_fontSizeIndex],
                        theme: theme,
                        activityManager: _activityManager,
                        onDoubleTap : _handleDoubleTap,
                        onSingleTap: _handleSingleTap,
                        onHorizontalDragEnd: _handleHorizontalDrag,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ReadingProgressIndicator(
            progress: _scrollProgress,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

enum SwipeDirection { left, right }
