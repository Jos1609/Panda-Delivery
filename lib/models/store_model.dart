class StoreModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final double rating;
  final int ratingCount;
  final String deliveryTime;
  final double deliveryFee;

  StoreModel({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.rating,
    required this.ratingCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      category: json['category'],
      rating: json['rating'].toDouble(),
      ratingCount: json['ratingCount'],
      deliveryTime: json['deliveryTime'],
      deliveryFee: json['deliveryFee'].toDouble(),
    );
  }
}