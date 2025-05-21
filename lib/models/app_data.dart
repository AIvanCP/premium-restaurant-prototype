class GalleryItem {
  final String id;
  final String imageUrl;
  final String title;
  final String location;
  final String description;

  GalleryItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.description,
  });

  static List<GalleryItem> getGalleryItems() {
    return [
      GalleryItem(
        id: 'g1',
        imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3',
        title: 'Main Dining Hall',
        location: 'Downtown Branch',
        description: 'Experience elegance in our grand dining space with high ceilings and ambient lighting.',
      ),
      GalleryItem(
        id: 'g2',
        imageUrl: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?ixlib=rb-4.0.3',
        title: 'VIP Lounge',
        location: 'Riverside Branch',
        description: 'Exclusive lounge area for our premium guests with private service and panoramic views.',
      ),
      GalleryItem(
        id: 'g3',
        imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-4.0.3',
        title: 'Outdoor Terrace',
        location: 'Downtown Branch',
        description: 'Enjoy your meal surrounded by nature on our elegant outdoor terrace.',
      ),
    ];
  }
}

class NewsItem {
  final String id;
  final String title;
  final String summary;
  final String imageUrl;
  final String date;
  final bool isClickable;
  final String? fullContent;

  NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.date,
    required this.isClickable,
    this.fullContent,
  });

  static List<NewsItem> getNewsItems() {
    return [
      NewsItem(
        id: 'n1',
        title: 'World-Renowned Chef Joins Our Team',
        summary: 'We are thrilled to announce the addition of Michelin-starred Chef Julien Blanc to our culinary team.',
        imageUrl: 'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?ixlib=rb-4.0.3',
        date: 'May 10, 2025',
        isClickable: true,
        fullContent: '''
# World-Renowned Chef Joins Our Team

We are excited to announce that Michelin-starred Chef Julien Blanc will be joining our culinary team starting June 1st, 2025.

Chef Blanc brings over 15 years of experience from some of the world's most prestigious restaurants, including Le Ciel in Paris and Azure in New York, both holding multiple Michelin stars.

"I'm thrilled to be joining this innovative team. Together, we'll create unforgettable culinary experiences that blend classic techniques with bold, contemporary flavors," says Chef Blanc.

To celebrate this exciting new chapter, we will be hosting a special tasting event on June 5th. Reservations will open on May 20th and are expected to fill quickly.

Stay tuned for Chef Blanc's exclusive new menu items coming this summer!
        ''',
      ),
      NewsItem(
        id: 'n2',
        title: 'New Signature Cocktail Collection Launching',
        summary: 'Experience our new artisanal cocktail collection featuring rare ingredients and innovative techniques.',
        imageUrl: 'https://images.unsplash.com/photo-1568644396922-5c3bfae12521?ixlib=rb-4.0.3',
        date: 'April 28, 2025',
        isClickable: true,
        fullContent: '''
# New Signature Cocktail Collection Launching

Our master mixologists have spent the past six months perfecting a new signature cocktail collection that will redefine luxury libations.

The new collection features twelve handcrafted cocktails using rare spirits, house-made infusions, and innovative techniques like molecular gastronomy and smoke infusion.

Highlights include:
- The Golden Hour: A sunrise-inspired blend of rare Japanese whisky, yuzu, saffron, and 24k gold flakes
- Truffle Cloud: Grey Goose vodka with black truffle foam and a champagne float
- Smoke & Mirrors: A tableside experience featuring mezcal, aged tequila, and custom smoke infusion

Each cocktail is presented as a complete sensory experience, with custom glassware, aromatics, and garnishes designed to complement the flavors.

The new collection will be available exclusively at both our Downtown and Riverside locations starting May 15th.
        ''',
      ),
      NewsItem(
        id: 'n3',
        title: 'Summer Rooftop Series Announced',
        summary: 'Join us for exclusive dining events under the stars all summer long at our Downtown location.',
        imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-4.0.3',
        date: 'April 15, 2025',
        isClickable: false,
      ),
      NewsItem(
        id: 'n4',
        title: 'Exclusive Wine Tasting Event',
        summary: 'Sample rare vintages guided by our sommelier at this members-only evening on May 25th.',
        imageUrl: 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?ixlib=rb-4.0.3',
        date: 'April 5, 2025',
        isClickable: false,
      ),
      NewsItem(
        id: 'n5',
        title: 'New Seasonal Menu Unveiled',
        summary: 'Our spring-summer menu showcases the finest seasonal ingredients from local artisanal producers.',
        imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?ixlib=rb-4.0.3',
        date: 'March 20, 2025',
        isClickable: false,
      ),
      NewsItem(
        id: 'n6',
        title: 'Riverside Branch Celebrates First Anniversary',
        summary: "Join us for a week of special events and menus to celebrate our newest location's first year.",
        imageUrl: 'https://images.unsplash.com/photo-1559329007-40df8a9345d8?ixlib=rb-4.0.3&auto=format',
        date: 'March 10, 2025',
        isClickable: false,
      ),
    ];
  }
}

class RestaurantLocation {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String imageUrl;
  final String? mapUrl;
  final String hours;
  final bool isClickable;

  RestaurantLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.imageUrl,
    this.mapUrl,
    required this.hours,
    required this.isClickable,
  });

  static List<RestaurantLocation> getLocations() {
    return [
      RestaurantLocation(
        id: 'l1',
        name: 'Downtown Branch',
        address: '123 Luxury Avenue, New York, NY 10001',
        phone: '+1 (212) 555-7890',
        email: 'downtown@elegantcuisine.com',
        imageUrl: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-4.0.3',
        mapUrl: 'https://www.google.com/maps?q=40.7128,-74.0060',
        hours: 'Mon-Thu: 5pm-11pm\nFri-Sat: 5pm-1am\nSun: 5pm-10pm',
        isClickable: true,
      ),      RestaurantLocation(
        id: 'l2',
        name: 'Riverside Branch',
        address: '456 Waterfront Drive, Chicago, IL 60601',
        phone: '+1 (312) 555-4321',
        email: 'riverside@elegantcuisine.com',
        imageUrl: 'https://images.unsplash.com/photo-1514933651103-005eec06c04b?ixlib=rb-4.0.3',
        hours: 'Mon-Thu: 5pm-11pm\nFri-Sat: 5pm-1am\nSun: 5pm-10pm',
        isClickable: false,
      ),
    ];
  }
}
