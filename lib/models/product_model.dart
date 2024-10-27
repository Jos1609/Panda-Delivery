class ProductModel {
  final String id;
  final String name;
  final List<String> images;
  final double price;
  final double? originalPrice;
  final String storeName;
  final double rating;
  final int ratingCount;
  final String description;
  final String category;

  static var length;

  ProductModel({
    required this.id,
    required this.name,
    required this.images,
    required this.price,
    this.originalPrice,
    required this.storeName,
    required this.rating,
    required this.ratingCount,
    required this.description,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      images: json['image'],
      price: json['price'].toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      storeName: json['storeName'],
      rating: json['rating'].toDouble(),
      ratingCount: json['ratingCount'],
      description: json['description'],
      category: json['category'],
    );
  }

  static where(bool Function(dynamic product) param0) {}
}
