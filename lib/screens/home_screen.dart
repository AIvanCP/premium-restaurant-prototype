import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/theme.dart';
import '../widgets/footer_widget.dart';
import '../widgets/testimonials_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroSection(context),
          _buildAboutSection(context, isMobile),
          _buildBenefitsSection(context, isMobile),
          const TestimonialsWidget(),
          _buildContactSection(context, isMobile),
          const FooterWidget(),
        ],
      ),
    );
  }
  Widget _buildHeroSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Enhanced breakpoint system for extreme responsiveness
    final useCompactLayout = screenWidth < 650;  // More conservative threshold
    final isNarrow = screenWidth < 450;
    final isVeryNarrow = screenWidth < 350;
    final isMicroScreen = screenWidth < 300;
    final isUltraMicro = screenWidth < 250;  // Extreme case
    
    return Container(
      height: MediaQuery.of(context).size.height * (isMicroScreen ? 0.75 : 0.85),
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with caching
          CachedNetworkImage(
            imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-4.0.3',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppTheme.primaryColor,
              child: const Center(
                child: CircularProgressIndicator(color: AppTheme.accentColor),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppTheme.primaryColor,
              child: const Icon(Icons.restaurant, color: AppTheme.accentColor, size: 50),
            ),
            color: Colors.black45,
            colorBlendMode: BlendMode.darken,
          ),
          // Content overlay
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMicroScreen ? 10.0 : 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ELEGANT CUISINE',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppTheme.accentColor,
                        letterSpacing: isVeryNarrow ? 1 : 3,
                        fontWeight: FontWeight.bold,
                        fontSize: isUltraMicro ? 20 : (isMicroScreen ? 24 : (isVeryNarrow ? 28 : null)),
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMicroScreen ? 10 : 16),
                Text(
                  'THE LEGEND IS BACK!',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        letterSpacing: isVeryNarrow ? 1 : 2,
                        fontSize: isUltraMicro ? 14 : (isMicroScreen ? 16 : (isVeryNarrow ? 18 : null)),
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMicroScreen ? 20 : (isVeryNarrow ? 24 : 40)),
                
                // Ultra-responsive button layout with extreme size handling
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isUltraMicro ? 5.0 : (isMicroScreen ? 10.0 : (isVeryNarrow ? 16.0 : (isNarrow ? 24.0 : 32.0)))
                  ),
                  child: useCompactLayout
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Scroll to menu section
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accentColor,
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                    vertical: isUltraMicro ? 6 : (isMicroScreen ? 8 : (isVeryNarrow ? 10 : 12))
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: isVeryNarrow ? VisualDensity.compact : null,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isUltraMicro ? 9 : (isMicroScreen ? 10 : (isVeryNarrow ? 12 : 14)),
                                  ),
                                ),
                                child: Text(
                                  isUltraMicro ? 'MENU' : (isMicroScreen ? 'VIEW MENU' : (isVeryNarrow ? 'OUR MENU' : 'EXPLORE OUR MENU'))
                                ),
                              ),
                            ),
                            SizedBox(height: isMicroScreen ? 8 : (isVeryNarrow ? 10 : 16)),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/reservation');
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.accentColor,
                                  side: BorderSide(
                                    color: AppTheme.accentColor, 
                                    width: isVeryNarrow ? 1 : 2
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: isUltraMicro ? 6 : (isMicroScreen ? 8 : (isVeryNarrow ? 10 : 12))
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: isVeryNarrow ? VisualDensity.compact : null,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isUltraMicro ? 9 : (isMicroScreen ? 10 : (isVeryNarrow ? 12 : 14)),
                                  ),
                                ),
                                child: Text(
                                  isUltraMicro ? 'BOOK' : (isMicroScreen ? 'RESERVE' : (isVeryNarrow ? 'RESERVE NOW' : 'RESERVE A TABLE'))
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Scroll to menu section
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accentColor,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16, 
                                    vertical: 16,
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: const Text('EXPLORE OUR MENU'),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Flexible(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/reservation');
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.accentColor,
                                  side: const BorderSide(color: AppTheme.accentColor, width: 2),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16, 
                                    vertical: 16,
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: const Text('RESERVE A TABLE'),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 20 : 60,
      ),
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Text(
            'ABOUT US',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.accentColor,
                  letterSpacing: 2,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            width: 60,
            height: 3,
            color: AppTheme.accentColor,
          ),
          const SizedBox(height: 40),
          isMobile
              ? Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: 'https://images.unsplash.com/photo-1581349437898-cebbe9831942?ixlib=rb-4.0.3',
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppTheme.primaryColor,
                          child: const Center(
                            child: CircularProgressIndicator(color: AppTheme.accentColor),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.primaryColor,
                          child: const Icon(Icons.restaurant, color: AppTheme.accentColor, size: 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildAboutContent(context),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: 'https://images.unsplash.com/photo-1581349437898-cebbe9831942?ixlib=rb-4.0.3',
                          width: double.infinity,
                          height: 400,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppTheme.primaryColor,
                            child: const Center(
                              child: CircularProgressIndicator(color: AppTheme.accentColor),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppTheme.primaryColor,
                            child: const Icon(Icons.restaurant, color: AppTheme.accentColor, size: 50),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 60),
                    Expanded(
                      child: _buildAboutContent(context),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildAboutContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A CULINARY JOURNEY OF ELEGANCE',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          'Founded in 2020, Elegant Cuisine has redefined the fine dining experience with an unwavering commitment to culinary excellence and impeccable service.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.8,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Our executive chef brings over two decades of experience from Michelin-starred restaurants across Europe and Asia, crafting unique dishes that blend traditional techniques with contemporary innovation.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.8,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Every ingredient is meticulously sourced, prioritizing local, organic, and sustainable options whenever possible, ensuring not just exceptional flavor but also responsible dining.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.8,
              ),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 20 : 60,
      ),
      color: AppTheme.cardColor,
      child: Column(
        children: [
          Text(
            'WHY CHOOSE US',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.accentColor,
                  letterSpacing: 2,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            width: 60,
            height: 3,
            color: AppTheme.accentColor,
          ),
          const SizedBox(height: 60),
          isMobile
              ? Column(
                  children: _buildBenefitItems(context),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildBenefitItems(context)
                      .map((item) => Expanded(child: item))
                      .toList(),
                ),
        ],
      ),
    );
  }

  List<Widget> _buildBenefitItems(BuildContext context) {
    final benefits = [
      {
        'icon': Icons.star,
        'title': 'PREMIUM QUALITY',
        'description':
            'Only the finest ingredients selected by our expert chefs to create extraordinary dining experiences.',
      },
      {
        'icon': Icons.eco,
        'title': 'ORGANIC & SUSTAINABLE',
        'description':
            'Committed to environmentally-conscious practices and sustainable sourcing from local producers.',
      },
      {
        'icon': Icons.delivery_dining,
        'title': 'EXCLUSIVE DELIVERY',
        'description':
            'Bringing the elegant dining experience to your doorstep with our premium food delivery service.',
      },
    ];

    return benefits.map((benefit) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              benefit['icon'] as IconData,
              color: AppTheme.accentColor,
              size: 48,
            ),
            const SizedBox(height: 24),
            Text(
              benefit['title'] as String,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              benefit['description'] as String,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildContactSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 20 : 60,
      ),
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Text(
            'CONTACT US',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.accentColor,
                  letterSpacing: 2,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            width: 60,
            height: 3,
            color: AppTheme.accentColor,
          ),
          const SizedBox(height: 60),
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactInfo(context),
                    const SizedBox(height: 40),
                    _buildContactForm(context),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildContactInfo(context)),
                    const SizedBox(width: 60),
                    Expanded(child: _buildContactForm(context)),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GET IN TOUCH',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          'Have questions about our menu, private events, or reservations? Our team is ready to assist you with any inquiries.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.8,
              ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: AppTheme.accentColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '123 Elegant Street, Luxury Avenue, CA 90210',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.phone,
              color: AppTheme.accentColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              '+1 (555) 123-4567',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.email,
              color: AppTheme.accentColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              'info@elegantcuisine.com',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context) {
    return Card(
      color: AppTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  prefixIcon: Icon(Icons.message),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process form data
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for your message!'),
                        backgroundColor: AppTheme.accentColor,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    
                    // Clear form
                    _nameController.clear();
                    _emailController.clear();
                    _messageController.clear();
                  }
                },
                icon: const Icon(Icons.send, color: Colors.black),
                label: Text(
                  'SEND MESSAGE',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
