import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      _scrollProgress = maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;
    });
  }

  void _toggleSave() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isSaved = !_isSaved;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSaved ? "Saved to favorites!" : "Removed from favorites"),
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
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar
              appbar(theme),

              // Content
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    width: contentWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Story Title
                        Text(
                          "The Endless Chase for Pi",
                          style: theme.textTheme.displayLarge,
                        ),

                        const SizedBox(height: 4),

                        // Metadata
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "3 min read",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "History",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Divider
                        Container(
                          height: 1,
                          color: theme.colorScheme.onSurface.withOpacity(0.1),
                        ),

                        const SizedBox(height: 16),

                        // Main Content
                        Text(
                          sampleRead,
                          style: theme.textTheme.bodyLarge,
                        ),

                        const SizedBox(height: 24),

                        // Divider
                        Container(
                          height: 1,
                          color: theme.colorScheme.onSurface.withOpacity(0.1),
                        ),

                        const SizedBox(height: 32),

                        // Action Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Enjoyed this read?",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            IconButton.filled(
                              icon: Icon(
                                _isSaved ? Icons.favorite : Icons.favorite_border,
                              ),
                              onPressed: _toggleSave,
                              style: IconButton.styleFrom(
                                backgroundColor: _isSaved
                                    ? Colors.red.shade400
                                    : theme.colorScheme.primaryContainer,
                                foregroundColor: _isSaved
                                    ? Colors.white
                                    : theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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

  SliverAppBar appbar(ThemeData theme) {
    return SliverAppBar(
              expandedHeight: 0,
              pinned: false,
              backgroundColor: theme.colorScheme.surface.withOpacity(0.95),
              elevation: 0,
              leading: const Icon(Icons.menu),
              centerTitle: true, // Ensures the title is centered
              title: Text(
                "Random Reads",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(onPressed: (){

                }, icon: const Icon(Icons.favorite_border_outlined)),
                IconButton(
                  icon: Icon(
                    theme.brightness == Brightness.dark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                  ),
                  onPressed: widget.toggleTheme,
                  tooltip: "Toggle theme",
                ),
                const SizedBox(width: 4),
              ],
            );
  }
}