import 'package:flutter/foundation.dart';
import 'package:panda/models/cart_item_model.dart';

class CarritoProvider with ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);

  void addToCart(CartItemModel item) {
    final existingIndex = _items.indexWhere(
      (element) => element.product.id == item.product.id,
    );

    if (existingIndex != -1) {
      // Si el producto ya existe, actualizamos la cantidad
      final newQuantity = _items[existingIndex].quantity + item.quantity;
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: newQuantity,
      );
    } else {
      // Si no existe, añadimos el nuevo item
      _items.add(item);
    }
    
    notifyListeners();
  }

  void updateQuantity(CartItemModel item, int newQuantity) {
    if (newQuantity < 1) return; // Evitar cantidades negativas
    
    final index = _items.indexWhere(
      (element) => element.product.id == item.product.id
    );
    
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        quantity: newQuantity,
      );
      notifyListeners();
    }
  }

  void toggleItemSelection(CartItemModel item, bool isSelected) {
    final index = _items.indexWhere(
      (element) => element.product.id == item.product.id
    );
    
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        isSelected: isSelected,
      );
      notifyListeners();
    }
  }

  void removeFromCart(CartItemModel item) {
    _items.removeWhere((element) => element.product.id == item.product.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get total {
    return _items
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  int get itemCount {
    return _items.where((item) => item.isSelected).length;
  }
  void removeSelectedItems(List<CartItemModel> itemsToRemove) {
    // Crear un Set de IDs de productos a eliminar para búsqueda eficiente
    final itemIdsToRemove = itemsToRemove.map((item) => item.product.id).toSet();
    
    // Eliminar los items que coincidan con los IDs
    _items.removeWhere((item) => itemIdsToRemove.contains(item.product.id));
    
    notifyListeners();
  }
}