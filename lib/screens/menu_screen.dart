import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../utils/theme.dart';
import '../utils/app_provider.dart';
import '../widgets/footer_widget.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<MenuItem> _foodItems = MenuItem.getFoodItems();
  final List<MenuItem> _beverageItems = MenuItem.getBeverageItems();
  
 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          _buildMenuSection(context, isMobile),
          const FooterWidget(),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1533777857889-4be7c70b33f7?ixlib=rb-4.0.3',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'OUR MENU',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppTheme.accentColor,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'EXQUISITE OFFERINGS',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, bool isMobile) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 20 : 60,
      ),
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Text(
            'CULINARY EXCELLENCE',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppTheme.accentColor,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(width: 60, height: 3, color: AppTheme.accentColor),
          const SizedBox(height: 40),
          SizedBox(
            width: isMobile ? double.infinity : 800,
            child: Text(
              'Indulge in our carefully curated selection of culinary masterpieces and premium beverages. Each dish and drink is crafted with the finest ingredients and meticulous attention to detail.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.8),
              textAlign: TextAlign.center,
            ),
          ),          SizedBox(height: screenWidth < 400 ? 30 : 60),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(screenWidth < 400 ? 30 : 50),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.accentColor,
                borderRadius: BorderRadius.circular(screenWidth < 400 ? 30 : 50),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: AppTheme.textPrimaryColor,
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.symmetric(
                horizontal: screenWidth < 350 ? 8 : 16,
                vertical: screenWidth < 350 ? 6 : 8,
              ),
              labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth < 350 ? 12 : (screenWidth < 400 ? 14 : null),
              ),
              unselectedLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: screenWidth < 350 ? 12 : (screenWidth < 400 ? 14 : null),
              ),
              tabs: const [Tab(text: 'FOOD'), Tab(text: 'BEVERAGES')],
            ),
          ),
          SizedBox(height: screenWidth < 400 ? 20 : 40), // Responsive spacing
          // This makes the height adapt to the content while allowing scrolling
          SizedBox(
            height:
                MediaQuery.of(context).size.height *
                0.8, // Use percentage of screen height
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _buildMenuItemsGrid(context, _foodItems, isMobile),
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _buildMenuItemsGrid(context, _beverageItems, isMobile),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }  Widget _buildMenuItemsGrid(
    BuildContext context,
    List<MenuItem> items,
    bool isMobile,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowMobile = screenWidth < 400;
    final isVeryNarrowMobile = screenWidth < 350;
    
    // Use fixed height items instead of aspect ratio to prevent overflow
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : (screenWidth > 1200 ? 3 : 2),
        // Carefully calculated aspect ratios based on screen width
        childAspectRatio: isVeryNarrowMobile ? 0.68 : (isNarrowMobile ? 0.72 : (isMobile ? 0.75 : 0.85)),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildMenuItemCard(context, item);
      },
    );
  }

  Widget _buildMenuItemCard(BuildContext context, MenuItem item) {
    final appProvider = Provider.of<AppProvider>(context);
    final isFavorite = appProvider.isFavorite(item.id);
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowMobile = screenWidth < 400;
    final isVeryNarrowMobile = screenWidth < 350;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Fixed height image container instead of flex ratio to prevent overflow
                SizedBox(
                  height: isVeryNarrowMobile ? 120 : (isNarrowMobile ? 140 : 160),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.primaryColor,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.primaryColor,
                      child: const Icon(
                        Icons.restaurant,
                        color: AppTheme.accentColor,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                // Fixed height content container with proper overflow handling
                Container(
                  height: isVeryNarrowMobile ? 180 : (isNarrowMobile ? 200 : 210),
                  padding: EdgeInsets.all(isVeryNarrowMobile ? 12.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              item.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: isVeryNarrowMobile ? 16 : (isNarrowMobile ? 18 : null),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: isVeryNarrowMobile ? 14 : (isNarrowMobile ? 16 : null),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isVeryNarrowMobile ? 6 : (isNarrowMobile ? 8 : 12)),
                      SizedBox(
                        height: isVeryNarrowMobile ? 42 : 54,
                        child: Text(
                          item.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: isVeryNarrowMobile ? 12 : (isNarrowMobile ? 13 : null),
                          ),
                          maxLines: isVeryNarrowMobile ? 3 : 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: isVeryNarrowMobile ? 6 : (isNarrowMobile ? 8 : 10)),
                      // Ingredients text with fixed height
                      SizedBox(
                        height: isVeryNarrowMobile ? 28 : 32,
                        child: Text(
                          'Ingredients: ${item.ingredients.join(', ')}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            fontSize: isVeryNarrowMobile ? 11 : (isNarrowMobile ? 12 : null),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Button row with fixed layout
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isVeryNarrow = constraints.maxWidth < 170;
                          
                          if (isVeryNarrow) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : AppTheme.textSecondaryColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    appProvider.toggleFavorite(item.id);
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                ),
                                SizedBox(
                                  height: 26,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      appProvider.viewMenuItem(item);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: AppTheme.accentColor,
                                        width: 1,
                                      ),
                                      foregroundColor: AppTheme.accentColor,
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                      textStyle: TextStyle(fontSize: 11),
                                    ),
                                    child: Text('VIEW'),
                                  ),
                                ),
                              ],
                            );
                          }
                          
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: isVeryNarrowMobile ? 28 : 32,
                                child: OutlinedButton(
                                  onPressed: () {
                                    appProvider.viewMenuItem(item);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: AppTheme.accentColor,
                                      width: isVeryNarrowMobile ? 1 : 1.5,
                                    ),
                                    foregroundColor: AppTheme.accentColor,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isVeryNarrowMobile ? 8 : 12,
                                      vertical: 0,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    textStyle: TextStyle(
                                      fontSize: isVeryNarrowMobile ? 11 : 12,
                                    ),
                                  ),
                                  child: Text(isVeryNarrowMobile ? 'VIEW' : 'DETAILS'),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : AppTheme.textSecondaryColor,
                                  size: isVeryNarrowMobile ? 20 : 24,
                                ),
                                onPressed: () {
                                  appProvider.toggleFavorite(item.id);
                                },
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                  minWidth: isVeryNarrowMobile ? 24 : 32,
                                  minHeight: isVeryNarrowMobile ? 24 : 32,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Pricing tag (unchanged)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
