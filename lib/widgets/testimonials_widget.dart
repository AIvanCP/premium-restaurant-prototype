import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../models/testimonial.dart';
import '../utils/theme.dart';
import '../utils/responsive_view.dart';

class TestimonialsWidget extends StatefulWidget {
  const TestimonialsWidget({Key? key}) : super(key: key);

  @override
  State<TestimonialsWidget> createState() => _TestimonialsWidgetState();
}

class _TestimonialsWidgetState extends State<TestimonialsWidget> {
  final List<Testimonial> _testimonials = Testimonial.getTestimonials();
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;
  bool _userInteracting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.95, // Increased to reduce gap on small screens
      initialPage: 0
    );
    
    // Wait for proper initialization before starting autoplay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoPlay();
    });
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }
    void _startAutoPlay() {
    if (_userInteracting) return;
    
    // Cancel any existing timer first
    _stopAutoPlay();
    
    // Create a new timer that advances the carousel every 5 seconds
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients && mounted && !_userInteracting) {
        final nextPage = (_currentPage + 1) % _testimonials.length;
        
        // Use a shorter animation duration to reduce lag
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300), // Faster animation
          curve: Curves.fastLinearToSlowEaseIn,
        );
      }
    });
  }
  
  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final screenType = ResponsiveView.getScreenSizeType(context);
    final isMobile = screenType == ScreenSizeType.mobile;
    final isTablet = screenType == ScreenSizeType.tablet;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      color: AppTheme.primaryColor,
      child: Column(
        children: [
          Text(
            'WHAT OUR GUESTS SAY',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Experiences from our esteemed clientele',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                  letterSpacing: 1,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),          // Testimonial cards with PageView - optimized for performance
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate adaptive height based on screen width and content needs
              double cardHeight = isMobile 
                ? constraints.maxWidth < 350 ? 450 : 400  // Taller on very small screens
                : (isTablet ? 320 : 260);
                
              return SizedBox(
                height: cardHeight,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    // Start/stop autoplay based on user interaction
                    if (notification is ScrollStartNotification) {
                      _userInteracting = true;
                      _stopAutoPlay();
                    } else if (notification is ScrollEndNotification) {
                      _userInteracting = false;
                      _startAutoPlay();
                    }
                    return true;
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _testimonials.length,
                    onPageChanged: (int page) {
                      // Update current page without unnecessary rebuilds
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    // Optimize physics for better performance
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final testimonial = _testimonials[index];
                      
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: _currentPage == index ? 0.0 : 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Quote icon
                              Icon(
                                Icons.format_quote,
                                color: AppTheme.accentColor,
                                size: isMobile ? 32 : 40,
                              ),
                              SizedBox(height: isMobile ? 12 : 16),
                              
                              // Testimonial content - with scrollable capability for small screens
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      testimonial.content,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            color: AppTheme.textPrimaryColor,
                                            fontStyle: FontStyle.italic,
                                            height: 1.5,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: isMobile ? 12 : 16),
                              
                              // Rating stars
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < testimonial.rating ? Icons.star : Icons.star_border,
                                    color: AppTheme.accentColor,
                                    size: 18,
                                  );
                                }),
                              ),
                              SizedBox(height: isMobile ? 12 : 16),
                              
                              // User info
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 16,
                                children: [
                                  if (testimonial.avatarUrl != null)
                                    CircleAvatar(
                                      backgroundImage: CachedNetworkImageProvider(
                                        testimonial.avatarUrl!,
                                      ),
                                      radius: 24,
                                    ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        testimonial.customerName,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: AppTheme.accentColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        testimonial.role,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: AppTheme.textSecondaryColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),          SizedBox(height: isMobile ? 20 : 30),
          
          // Combined responsive navigation controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Left navigation arrow (visible on all devices)
                IconButton(
                  onPressed: () {
                    final previousPage = _currentPage > 0 ? _currentPage - 1 : _testimonials.length - 1;
                    _pageController.animateToPage(
                      previousPage,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastLinearToSlowEaseIn,
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded, 
                    color: AppTheme.accentColor,
                    size: isMobile ? 20 : 24,
                  ),
                  padding: EdgeInsets.all(isMobile ? 8 : 12),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                    ),
                  ),
                ),
                
                // Carousel indicators - adaptive size
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _testimonials.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            entry.key,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.fastLinearToSlowEaseIn,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: _currentPage == entry.key ? 12.0 : 8.0,
                          height: _currentPage == entry.key ? 12.0 : 8.0,
                          margin: EdgeInsets.symmetric(
                            horizontal: isMobile ? 3.0 : 4.0,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == entry.key
                                ? AppTheme.accentColor
                                : AppTheme.accentColor.withOpacity(0.3),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                // Right navigation arrow (visible on all devices)
                IconButton(
                  onPressed: () {
                    final nextPage = _currentPage < _testimonials.length - 1 ? _currentPage + 1 : 0;
                    _pageController.animateToPage(
                      nextPage,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastLinearToSlowEaseIn,
                    );
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded, 
                    color: AppTheme.accentColor,
                    size: isMobile ? 20 : 24,
                  ),
                  padding: EdgeInsets.all(isMobile ? 8 : 12),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
