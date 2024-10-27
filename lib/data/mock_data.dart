// lib/data/mock_data.dart

import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';

class MockData {
  static List<CategoryModel> getTopCategories() {
    return [
      CategoryModel(
        id: '1',
        name: 'Restaurante',
        image: 'https://img.freepik.com/fotos-premium/comida-brasilena-carne-panela-carne-res-stroganoff-pastel-cebolla-filete-carne-espiga-aa-feijoada_848239-158.jpg?w=740',
        orderCount: 150,
      ),
      CategoryModel(
        id: '2',
        name: 'Supermercado',
        image: 'https://ecommercegermany.com/wp-content/uploads/2024/06/EGN-supermarkets.jpg',
        orderCount: 120,
      ),
      CategoryModel(
        id: '3',
        name: 'Farmacia',
        image: 'https://panoramafarmaceutico.com.br/wp-content/webp-express/webp-images/uploads/2023/10/Design-sem-nome-29.jpg.webp',
        orderCount: 90,
      ),
      CategoryModel(
        id: '4',
        name: 'Tecnología',
        image: 'https://www.htw.com.pe/wp-content/uploads/2019/08/venta-equipos-informaticos-repuestos.png',
        orderCount: 80,
      ),
      CategoryModel(
        id: '5',
        name: 'Moda',
        image: 'https://audaces.com/wp-content/uploads/2022/03/estilos-de-moda.webp',
        orderCount: 75,
      ),
    ];
  }

  static List<ProductModel> getDiscountedProducts() {
    return [
      ProductModel(
        id: '1',
        name: 'Pizza Familiar Suprema',
        images: ['https://www.afuegolento.com/img_db/timthumb.php?src=img_db/articles/2020/09/article-5f59eddfad0d8.jpg&w=800&z=1'],
        price: 15.99,
        originalPrice: 19.99,
        storeName: 'EL PADRE CEVICHERIA',
        rating: 4.5,
        ratingCount: 128, 
        description: 'Riquisimo', category: 'Farmacia', 
      ),
      ProductModel(
        id: '2',
        name: 'Hamburguesa Doble con Queso',
        images: ['https://img.freepik.com/fotos-premium/hamburguesa-doble-queso-tomate-cebolla-papas-fritas-sobre-fondo-oscuro_207126-7702.jpg'],
        price: 8.99,
        originalPrice: 11.99,
        storeName: 'Burger King',
        rating: 4.3,
        ratingCount: 95, 
        description: 'delicioso',category: 'Restaurante', 
      ),
      ProductModel(
        id: '3',
        name: 'Combo Familiar Pollo',
        images: ['https://grupochios.com/wp-content/uploads/2022/02/familiar.jpg'],
        price: 24.99,
        originalPrice: 29.99,
        storeName: 'KFC',
        rating: 4.7,
        ratingCount: 156, 
        description: 'Sabroso',category: 'Restaurante', 
      ),
      ProductModel(
        id: '4',
        name: 'Sushi Set 24 piezas',
        images: ['https://tofuu.getjusto.com/orioneat-local/resized2/cu6NesS8H4rqBZ7Zs-800-x.webp'],
        price: 32.99,
        originalPrice: 39.99,
        storeName: 'Sushi Express',
        rating: 4.8,
        ratingCount: 89, description: 'Te desmayas tanta sabrosura',category: 'Restaurante', 
      ),
    ];
  }

  static List<StoreModel> getTopStores() {
    return [
      StoreModel(
        id: '1',
        name: 'EL PADRE CEVICHERIA',
        image: 'https://scontent.flim14-1.fna.fbcdn.net/v/t39.30808-6/448251741_983616773768220_6353627451346607112_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeEye6eORg7RfBy28o6s_Ti15TnovTQPHqnlOei9NA8eqfgQ8NIEtQ8nRBPO5QKadMJtZh89rrcdvQyM1QhVbVwC&_nc_ohc=BJRfk7-pwGUQ7kNvgHs4X3c&_nc_zt=23&_nc_ht=scontent.flim14-1.fna&_nc_gid=Ank6raqo1AJwtiwle_UP4L1&oh=00_AYAduAjBC5ql96Xfq9WRGhIYBy8WAaUwYM81OklPpAS3gQ&oe=6721E979',
        category: 'Restaurante',
        rating: 4.8,
        ratingCount: 1250,
        deliveryTime: '30-45',
        deliveryFee: 2.99,
      ),
      StoreModel(
        id: '2',
        name: 'Farmacia 24/7',
        image: 'https://www.kamaryfarma.com/wp-content/uploads/2021/06/Enterate-de-las-ofertas-en-nuestra-farmacia-virtual-2-768x432.png',
        category: 'Farmacia',
        rating: 4.9,
        ratingCount: 890,
        deliveryTime: '15-30',
        deliveryFee: 1.99,
      ),
      StoreModel(
        id: '3',
        name: 'SisCom',
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsCfehOTaPoZg_hbvHjfHhsRFWQFZ0AjcsJQ&s',
        category: 'Tecnología',
        rating: 4.7,
        ratingCount: 567,
        deliveryTime: '45-60',
        deliveryFee: 4.99,
      ),
    ];
  }
}