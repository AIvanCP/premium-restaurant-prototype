import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isMicroScreen = screenWidth < 300;
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;

    // Adjust padding based on platform and screen size to prevent overflows
    final verticalPadding = isAndroid
        ? (isMicroScreen ? 20.0 : 30.0)
        : (isMobile ? 30.0 : 40.0);

    final horizontalPadding = isMicroScreen
        ? 10.0
        : (isMobile ? 20.0 : 60.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      color: AppTheme.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'ELEGANT CUISINE',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.accentColor,
                  letterSpacing: 2,
                  // Adjust text size based on screen size
                  fontSize: isMicroScreen ? 20 : null,
                ),
          ),
          SizedBox(height: isAndroid ? 16 : 24),
          isMobile
              ? Column(
                  children: [
                    _buildContactInfo(context),
                    SizedBox(height: isAndroid ? 20 : 30),
                    _buildSocialLinks(context),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildContactInfo(context)),
                    Expanded(child: _buildSocialLinks(context)),
                  ],
                ),
          SizedBox(height: isAndroid ? 30 : 40),
          const Divider(color: AppTheme.accentColor, thickness: 0.5),
          const SizedBox(height: 20),
          Text(
            '© ${DateTime.now().year} Elegant Cuisine. All rights reserved.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: isMicroScreen ? 10 : null,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Designed with ♥ for premium experiences',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: isMicroScreen ? 10 : null,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMicroScreen = screenWidth < 300;
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    
    // Adjust spacing based on screen size and platform
    final sectionSpacing = isMicroScreen || isAndroid ? 12.0 : 16.0;
    final itemSpacing = isMicroScreen || isAndroid ? 8.0 : 12.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'CONTACT US',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.accentColor,
                letterSpacing: 1.5,
                fontSize: isMicroScreen ? 16 : null,
              ),
        ),
        SizedBox(height: sectionSpacing),
        _contactItem(
          context,
          FontAwesomeIcons.phone,
          '+1 (800) ELEGANT',
          'tel:+18003534268',
          isMicroScreen,
        ),
        SizedBox(height: itemSpacing),
        _contactItem(
          context,
          FontAwesomeIcons.envelope,
          'info@elegantcuisine.com',
          'mailto:info@elegantcuisine.com',
          isMicroScreen,
        ),
      ],
    );
  }

  Widget _buildSocialLinks(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMicroScreen = screenWidth < 300;
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    
    // Adjust spacing and size based on screen size and platform
    final sectionSpacing = isMicroScreen || isAndroid ? 12.0 : 16.0;
    final iconSpacing = isMicroScreen ? 16.0 : (isAndroid ? 20.0 : 24.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'FOLLOW US',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.accentColor,
                letterSpacing: 1.5,
                fontSize: isMicroScreen ? 16 : null,
              ),
        ),
        SizedBox(height: sectionSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialIcon(FontAwesomeIcons.instagram, 'https://instagram.com', isMicroScreen),
            SizedBox(width: iconSpacing),
            _socialIcon(FontAwesomeIcons.facebook, 'https://facebook.com', isMicroScreen),
            SizedBox(width: iconSpacing),
            _socialIcon(FontAwesomeIcons.twitter, 'https://twitter.com', isMicroScreen),
          ],
        ),
      ],
    );
  }

  Widget _contactItem(
      BuildContext context, IconData icon, String text, String url, bool isMicroScreen) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isMicroScreen ? 4.0 : 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isMicroScreen ? 14 : 16,
              color: AppTheme.accentColor,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: isMicroScreen ? 12 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, String url, bool isMicroScreen) {
    final iconSize = isMicroScreen ? 38.0 : 40.0;
    
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.accentColor, width: 1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppTheme.accentColor,
          size: isMicroScreen ? 18 : 20,
        ),
      ),
    );
  }
}
