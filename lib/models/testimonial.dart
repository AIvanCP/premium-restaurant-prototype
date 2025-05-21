class Testimonial {
  final String id;
  final String customerName;
  final String role;
  final String content;
  final int rating; // 1-5 stars
  final String? avatarUrl;
  final String? date;

  Testimonial({
    required this.id,
    required this.customerName,
    required this.role,
    required this.content,
    required this.rating,
    this.avatarUrl,
    this.date,
  });

  static List<Testimonial> getTestimonials() {
    return [      Testimonial(
        id: 't1',
        customerName: 'Sophie Anderson',
        role: 'Food Critic',
        content: 'The ambiance is unmatched, and the culinary experience was truly exceptional. Every dish tells a story of premium ingredients and masterful preparation. Elegant Cuisine sets a high bar for fine dining.',
        rating: 5,
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3',
        date: 'April 15, 2025',
      ),      Testimonial(
        id: 't2',
        customerName: 'James Parker',
        role: 'Marketing Executive',
        content: 'A perfect venue for business dinners. The attention to detail and exemplary service made our corporate event truly memorable. The wine selection is particularly impressive.',
        rating: 5,
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3',
        date: 'March 28, 2025',
      ),      Testimonial(
        id: 't3',
        customerName: 'Olivia Martinez',
        role: 'Fashion Designer',
        content: 'The aesthetic of this restaurant is simply stunning. From the decor to the plating, everything exudes luxury. My friends and I had an amazing evening celebrating my birthday here.',
        rating: 4,
        avatarUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-4.0.3',
        date: 'February 14, 2025',
      ),Testimonial(
        id: 't4',
        customerName: 'Daniel Williams',
        role: 'Tech Entrepreneur',
        content: 'Elegant Cuisine delivers a perfect blend of innovation and tradition. The chef\'s tasting menu was a culinary journey worth every penny. Will definitely be returning for more exquisite experiences.',
        rating: 5,
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3',
        date: 'January 7, 2025',
      ),      Testimonial(
        id: 't5',
        customerName: 'Emma Thompson',
        role: 'Social Media Influencer',
        content: 'This place is absolutely Instagram-worthy! The presentation of each dish is a work of art, and the flavors are just as impressive as the aesthetics. My followers loved the content I created here.',
        rating: 5,
        avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3',
        date: 'April 3, 2025',
      ),
    ];
  }
}
