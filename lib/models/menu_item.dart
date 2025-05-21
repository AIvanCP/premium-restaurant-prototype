class MenuItem {
  final String id;
  final String name;
  final String description;
  final List<String> ingredients;
  final String imageUrl;
  final double price;
  final String category; // "food" or "beverage"

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.imageUrl,
    required this.price,
    required this.category,
  });

  static List<MenuItem> getFoodItems() {
    return [
      MenuItem(
        id: 'f1',
        name: 'Truffle Infused Wagyu Burger',
        description: 'Premium Wagyu beef patty topped with black truffle aioli, caramelized onions, and aged cheddar on a brioche bun.',
        ingredients: ['Wagyu beef', 'Black truffle', 'Aged cheddar', 'Brioche bun', 'Caramelized onions'],
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3',
        price: 28.99,
        category: 'food',
      ),      MenuItem(
        id: 'f2',
        name: 'Lobster Risotto',
        description: 'Creamy Arborio rice slowly cooked with lobster broth, finished with butter-poached Maine lobster and fresh herbs.',
        ingredients: ['Arborio rice', 'Maine lobster', 'Shallots', 'White wine', 'Parmesan'],
        imageUrl: 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?ixlib=rb-4.0.3',
        price: 34.99,
        category: 'food',
      ),
      MenuItem(
        id: 'f3',
        name: 'Japanese A5 Wagyu Steak',
        description: 'Perfectly seared A5 Japanese Wagyu beef served with truffle mashed potatoes and seasonal vegetables.',
        ingredients: ['A5 Wagyu beef', 'Black truffle', 'Yukon gold potatoes', 'Seasonal vegetables', 'Demi-glace'],
        imageUrl: 'https://images.unsplash.com/photo-1504973960431-1c467e159aa4?ixlib=rb-4.0.3',
        price: 85.99,
        category: 'food',
      ),
      MenuItem(
        id: 'f4',
        name: 'Seared Sea Scallops',
        description: 'Pan-seared Hokkaido scallops with cauliflower purée, pancetta, and a brown butter sauce.',
        ingredients: ['Hokkaido scallops', 'Cauliflower', 'Pancetta', 'Brown butter', 'Microgreens'],
        imageUrl: 'https://images.unsplash.com/photo-1533777857889-4be7c70b33f7?ixlib=rb-4.0.3',
        price: 39.99,
        category: 'food',
      ),
      MenuItem(
        id: 'f5',
        name: 'Black Truffle Pasta',
        description: 'Handmade tagliatelle pasta with fresh black truffle, mascarpone cream sauce, and aged Parmigiano-Reggiano.',
        ingredients: ['Tagliatelle pasta', 'Black truffle', 'Mascarpone', 'Parmigiano-Reggiano', 'White wine'],
        imageUrl: 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?ixlib=rb-4.0.3',
        price: 32.99,
        category: 'food',
      ),
    ];
  }

  static List<MenuItem> getBeverageItems() {
    return [
      MenuItem(
        id: 'b1',
        name: 'Signature Gold Martini',
        description: 'Premium vodka infused with 24k gold flakes, dry vermouth, and an edible gold-dusted olive.',
        ingredients: ['Premium vodka', '24k gold flakes', 'Dry vermouth', 'Gold-dusted olive'],
        imageUrl: 'https://images.unsplash.com/photo-1536935338788-846bb9981813?ixlib=rb-4.0.3',
        price: 24.99,
        category: 'beverage',
      ),
      MenuItem(
        id: 'b2',
        name: 'Black Truffle Old Fashioned',
        description: 'Aged bourbon, truffle-infused maple syrup, and aromatic bitters, served with a smoked ice sphere.',
        ingredients: ['Aged bourbon', 'Truffle-infused maple syrup', 'Aromatic bitters', 'Orange peel', 'Smoked ice'],
        imageUrl: 'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?ixlib=rb-4.0.3',
        price: 19.99,
        category: 'beverage',
      ),      MenuItem(
        id: 'b3',
        name: 'Rare Vintage Champagne',
        description: 'Exclusive vintage champagne from one of France\'s most prestigious houses, served in a crystal flute.',
        ingredients: ['Vintage champagne', 'Edible flower'],
        imageUrl: 'https://images.unsplash.com/photo-1578911373434-0cb395d2cbfb?ixlib=rb-4.0.3',
        price: 48.99,
        category: 'beverage',
      ),      MenuItem(
        id: 'b4',
        name: 'Artisanal Espresso Martini',
        description: 'Single-origin espresso, premium vodka, and house-made coffee liqueur, shaken to perfection.',
        ingredients: ['Single-origin espresso', 'Premium vodka', 'House-made coffee liqueur', 'Coffee beans'],
        imageUrl: 'https://images.unsplash.com/photo-1575023782549-62ca0d244b39?ixlib=rb-4.0.3',
        price: 18.99,
        category: 'beverage',
      ),
      MenuItem(
        id: 'b5',
        name: 'Botanical Infused Gin & Tonic',
        description: 'Small-batch gin infused with rare botanicals, premium tonic water, and seasonal aromatics.',
        ingredients: ['Small-batch gin', 'Premium tonic water', 'Rare botanicals', 'Citrus peel', 'Edible flowers'],
        imageUrl: 'https://images.unsplash.com/photo-1527661591475-527312dd65f5?ixlib=rb-4.0.3',
        price: 17.99,
        category: 'beverage',
      ),
    ];
  }
}
