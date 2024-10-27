class CategoryModel {
  final String id;
  final String name;
  final String image;
  final int orderCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.orderCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      orderCount: json['orderCount'],
    );
  }
}
