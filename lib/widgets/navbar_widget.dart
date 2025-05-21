import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'package:animations/animations.dart';

class NavBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBarWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    if (isMobile) {
      return _buildMobileNavBar(context);
    } else {
      return _buildDesktopNavBar(context);
    }
  }

  Widget _buildDesktopNavBar(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLogo(context),
          Row(
            children: [
              _navBarItem(context, 'HOME', 0),
              _navBarItem(context, 'MENU', 1),
              _navBarItem(context, 'GALLERY', 2),
              _navBarItem(context, 'NEWS', 3),
              _navBarItem(context, 'LOCATIONS', 4),
            ],          ),          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/reservation');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'RESERVE NOW',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed('/recent-reservations');
            },
            icon: const Icon(Icons.history, color: AppTheme.accentColor),
            label: Text(
              'MY RESERVATIONS',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNavBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      title: _buildLogo(context),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          height: 1,
          color: AppTheme.accentColor.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.restaurant_menu,
            color: AppTheme.accentColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'ELEGANT CUISINE',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
        ],
      ),
    );
  }
  Widget _navBarItem(BuildContext context, String title, int index) {
    final isActive = currentIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isActive ? AppTheme.accentColor : AppTheme.textPrimaryColor,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 20 : 0,
              height: 2,
              decoration: BoxDecoration(
                color: AppTheme.accentColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MobileDrawer({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.backgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.accentColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: AppTheme.accentColor,
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  'ELEGANT CUISINE',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                ),
              ],
            ),
          ),
          _drawerItem(context, 'HOME', Icons.home, 0),
          _drawerItem(context, 'MENU', Icons.restaurant_menu, 1),
          _drawerItem(context, 'GALLERY', Icons.photo_library, 2),
          _drawerItem(context, 'NEWS', Icons.article, 3),
          _drawerItem(context, 'LOCATIONS', Icons.location_on, 4),          const Divider(color: AppTheme.accentColor, thickness: 0.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Close the drawer first
                Navigator.of(context).pushNamed('/reservation');
              },
              icon: const Icon(Icons.bookmark, color: Colors.black),
              label: Text(
                'RESERVE NOW',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context); // Close the drawer first
                Navigator.of(context).pushNamed('/recent-reservations');
              },
              icon: const Icon(Icons.history, color: AppTheme.accentColor),
              label: Text(
                'MY RESERVATIONS',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _drawerItem(BuildContext context, String title, IconData icon, int index) {
    final isActive = currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.cardColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppTheme.accentColor : AppTheme.textPrimaryColor,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isActive ? AppTheme.accentColor : AppTheme.textPrimaryColor,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),        onTap: () {
          onTap(index);
          Navigator.pop(context);
        },
      ),
    );
  }
}
