import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';

class HomeService {
  static const String baseUrl = 'https://api.example.com'; // Cambia esto

  Future<List<CategoryModel>> getTopCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories/top'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
      throw Exception('Error al cargar categorías');
    } catch (e) {
      throw Exception('Error de conexión');
    }
  }

  Future<List<ProductModel>> getDiscountedProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/discounted'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }
      throw Exception('Error al cargar productos');
    } catch (e) {
      throw Exception('Error de conexión');
    }
  }

  Future<List<StoreModel>> getTopStores() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/stores/top'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => StoreModel.fromJson(json)).toList();
      }
      throw Exception('Error al cargar tiendas');
    } catch (e) {
      throw Exception('Error de conexión');
    }
  }
}
