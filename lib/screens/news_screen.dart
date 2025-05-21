import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/app_data.dart';
import '../utils/theme.dart';
import '../widgets/footer_widget.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  NewsItem? _selectedNewsItem;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    if (_selectedNewsItem != null) {
      return _buildNewsDetailView(context, _selectedNewsItem!);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroSection(context),
          _buildNewsSection(context, isMobile),
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
              'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?ixlib=rb-4.0.3'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black45,
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'LATEST NEWS',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.accentColor,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'STAY UPDATED',
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

  Widget _buildNewsSection(BuildContext context, bool isMobile) {
    final newsItems = NewsItem.getNewsItems();

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 20 : 60,
      ),
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Text(
            'WHATS NEW',
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
          SizedBox(
            width: isMobile ? double.infinity : 800,
            child: Text(
              'Keep up with the latest happenings at Elegant Cuisine. From new menu items to special events, we have so much to share with you.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.8,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 60),
          // Improved news display for both mobile and desktop
          // Fixed news items layout with SizedBox container to avoid rendering issues
          SizedBox(
            width: double.infinity,
            child: isMobile
                ? Column(
                    children: newsItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: _buildNewsCard(context, item),
                      );
                    }).toList(),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                    ),
                    itemCount: newsItems.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildNewsCard(context, newsItems[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, NewsItem item) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: item.isClickable
            ? () {
                setState(() {
                  _selectedNewsItem = item;
                });
              }
            : null,
        borderRadius: BorderRadius.circular(15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: 320, // Fixed total height
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Fixed-height image container to prevent rendering issues
                SizedBox(
                  height: 160,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppTheme.primaryColor,
                          child: const Center(
                            child: CircularProgressIndicator(color: AppTheme.accentColor),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.primaryColor,
                          child: const Icon(
                            Icons.newspaper,
                            color: AppTheme.accentColor,
                            size: 50,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.date,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Fixed-height content container
                SizedBox(
                  height: 160,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            item.summary,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (item.isClickable)
                          Text(
                            'Read more...',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsDetailView(BuildContext context, NewsItem item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'NEWS',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.accentColor),
          onPressed: () {
            setState(() {
              _selectedNewsItem = null;
            });
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CachedNetworkImage(
              imageUrl: item.imageUrl,
              height: 300,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppTheme.primaryColor,
                height: 300,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.accentColor,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppTheme.primaryColor,
                height: 300,
                child: const Icon(
                  Icons.newspaper,
                  color: AppTheme.accentColor,
                  size: 100,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: isMobile ? 20 : 60,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.date,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 60,
                    height: 3,
                    color: AppTheme.accentColor,
                  ),
                  const SizedBox(height: 30),
                  if (item.fullContent != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: MarkdownBody(
                        data: item.fullContent!,
                        styleSheet: MarkdownStyleSheet(
                          h1: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                          h2: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                          p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.8,
                              ),
                          listBullet:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.accentColor,
                                  ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedNewsItem = null;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      label: Text(
                        'BACK TO NEWS',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}
