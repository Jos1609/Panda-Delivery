class ProductDetail {
  final String id;
  final String name;
  final double price;
  final String description;
  final List<String> images;
  final String category;
  final String storeId;
  final Map<String, dynamic> attributes;

  ProductDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
    required this.storeId,
    required this.attributes,
  });
}