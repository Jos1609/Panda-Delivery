import 'package:panda/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  bool isSelected;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.isSelected = true,
  });

  // Método para crear una copia del item con una nueva cantidad
  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
    bool? isSelected,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}