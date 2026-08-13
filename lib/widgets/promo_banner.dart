import 'package:flutter/material.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({
    super.key,
  });

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'category': 'Popular',
      'title': 'Sisa Rasa',
      'artist': 'Mahalini',
      'image': 'lib/assets/sisa_rasa.png',
      'color': Color(0xFFC86B83),
    },
    {
      'category': 'Trending',
      'title': 'Residual',
      'artist': 'Chris Brown',
      'image': 'lib/assets/chris_brown_residual.png',
      'color': Color(0xFFB73535),
    },
    {
      'category': 'Popular',
      'title': 'TEA',
      'artist': 'Rema',
      'image': 'lib/assets/rema_bg.png',
      'color': Color(0xFF315C8C),
    },
  ];

  void _nextPage() {
    if (_currentPage < _banners.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        _banners.length - 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 145,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = _banners[index];

              return GestureDetector(
                onTap: () {
                  // Add your action here
                },
                child: _buildBanner(banner),
              );
            },
          ),

          // Left arrow
          Positioned(
            left: 8,
            top: 59,
            child: GestureDetector(
              onTap: _previousPage,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white.withOpacity(0.8),
                  size: 26,
                ),
              ),
            ),
          ),

          // Right arrow
          Positioned(
            right: 8,
            top: 59,
            child: GestureDetector(
              onTap: _nextPage,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.8),
                  size: 26,
                ),
              ),
            ),
          ),

          // Page indicators
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                    (index) {
                  final isSelected = _currentPage == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isSelected ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(Map<String, dynamic> banner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background
          Positioned(
            left: 0,
            right: 0,
            top: 10,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: banner['color'],
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          // Text
          Positioned(
            left: 45,
            top: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner['category'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  banner['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  banner['artist'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Image
          Positioned(
            right: 20,
            top: -40,
            bottom: -2,
            child: Image.asset(
              banner['image'],
              width: 144,
              height: 152,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}