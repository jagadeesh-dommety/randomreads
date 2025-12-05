import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randomreads/randomreads_app_bar.dart';
import 'package:randomreads/read_footer.dart';
import 'package:randomreads/read_title_widget.dart';
import 'package:randomreads/thememode.dart';

class MyHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const MyHomePage({super.key, required this.toggleTheme});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;
  bool _isSaved = false;
  // Font size options
  final List<double> _fontSizes = [14.0, 16.0, 18.0];
  final List<double> _lineHeights = [1.7, 1.8, 1.9];
  final List<String> _fontSizeLabels = ['Small', 'Medium', 'Large'];
  int _fontSizeIndex = 1; // 0: Small, 1: Medium, 2: Large

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollProgress);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollProgress);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollProgress() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    setState(() {
      _scrollProgress =
          maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;
    });
  }
void _handleDoubleTap() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isSaved = !_isSaved;
    });
  }

  // Single tap to cycle font size
  void _handleSingleTap() {
    HapticFeedback.lightImpact();
    setState(() {
      _fontSizeIndex = (_fontSizeIndex + 1) % _fontSizes.length;
    });
  }
  void _toggleSave() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isSaved = !_isSaved;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isSaved ? "Saved to favorites!" : "Removed from favorites"),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  final String sampleRead = '''
In the misty dawn of 5th-century India, Aryabhata sat under a banyan tree in Pataliputra, scratching ratios on palm leaves. He measured a circle's edge against its width, landing on 3.1416—close enough to chart eclipses and sail the seas, a number he called "the constant" without fanfare. Word traveled west on spice routes, Arabic scholars like Al-Khwarizmi polishing it in Baghdad's House of Wisdom, dubbing it "qanatah" and weaving it into star maps by 800 AD.

Centuries ticked by, and Europe's minds joined the hunt: Archimedes in Sicily sketched polygons around circles, squeezing toward 3.1418 with 96 sides, his triangular method a grueling grind of geometry. By the 1600s, Ludolph van Ceulen etched 35 digits on his tombstone after 10 years of hand-cranking fractions, a badge of obsession. Then came Newton in his Cambridge attic, 1665 plague year, inventing calculus to slice the circle into infinite arcs—his series spat out 15 digits in days, a shortcut that unlocked orbits and engines.

Centuries ticked by, and Europe's minds joined the hunt: Archimedes in Sicily sketched polygons around circles, squeezing toward 3.1418 with 96 sides, his triangular method a grueling grind of geometry. By the 1600s, Ludolph van Ceulen etched 35 digits on his tombstone after 10 years of hand-cranking fractions, a badge of obsession. Then came Newton in his Cambridge attic, 1665 plague year, inventing calculus to slice the circle into infinite arcs—his series spat out 15 digits in days, a shortcut that unlocked orbits and engines.

Centuries ticked by, and Europe's minds joined the hunt: Archimedes in Sicily sketched polygons around circles, squeezing toward 3.1418 with 96 sides, his triangular method a grueling grind of geometry. By the 1600s, Ludolph van Ceulen etched 35 digits on his tombstone after 10 years of hand-cranking fractions, a badge of obsession. Then came Newton in his Cambridge attic, 1665 plague year, inventing calculus to slice the circle into infinite arcs—his series spat out 15 digits in days, a shortcut that unlocked orbits and engines.
''';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth > 800 ? 700.0 : screenWidth * 0.95;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Main Content
          RefreshIndicator(
            displacement: 100,
            onRefresh: () async {
              // Simulate a refresh action
              await Future.delayed(const Duration(seconds: 1));
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar
                RandomreadsAppBar(theme: theme),
            
                // Content
                SliverToBoxAdapter(
                  child: Center(
                    child: GestureDetector(
                        onTap: _handleSingleTap,
                  // Double tap for like
                  onDoubleTap: _handleDoubleTap,
                  // Prevent tap conflicts
                  behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: contentWidth,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReadTitleWidget(theme: theme),
                                  
                            // Main Content with animated font size
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontSize: _fontSizes[_fontSizeIndex],
                            height: _lineHeights[_fontSizeIndex],
                          ),
                          child: Text(
                            sampleRead,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                                  
                            const SizedBox(height: 24),
                                  
                            // Divider
                            Container(
                              height: 1,
                              color: theme.colorScheme.onSurface.withOpacity(0.1),
                            ),
                                  
                            const SizedBox(height: 16),
                                  
                            // Action Section
                            ReadFooter(theme: theme, isSaved: _isSaved),
                            const SizedBox(height: 48),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Reading Progress Indicator
          Positioned(
            bottom: 2,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: _scrollProgress,
              backgroundColor: Colors.transparent,
              minHeight: 5,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
