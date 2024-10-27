// lib/pages/home_page.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:panda/pages/category_detail_page.dart';
import 'package:panda/pages/product_detail_page.dart';
import 'package:panda/pages/store_detail_page%20copy.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import '../widgets/category_card.dart';
import '../widgets/product_grid_card.dart';
import '../widgets/store_card.dart';
import '../widgets/section_title.dart';
import '../utils/constants.dart';
import '../data/mock_data.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key}) : super(key: key);

  @override
  State<HomePage1> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {
  late List<CategoryModel> _topCategories;
  late List<ProductModel> _discountedProducts;
  late List<StoreModel> _topStores;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    _topCategories = MockData.getTopCategories();
    _discountedProducts = MockData.getDiscountedProducts();
    _topStores = MockData.getTopStores();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.white,
            elevation: 2,
            title: const Text(
              'Panda Delivery',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.primary),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: AppColors.primary),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildPromotionalBanner(),
                SectionTitle(
                  title: 'Populares',
                  onSeeAll: () {},
                ),
                _buildCategoriesSection(),
                SectionTitle(
                  title: 'Ofertas Especiales',
                  onSeeAll: () {},
                ),
                _buildDiscountedProductsSection(),
                SectionTitle(
                  title: 'Tiendas Destacadas',
                  onSeeAll: () {},
                ),
                _buildTopStoresSection(),
                SectionTitle(
                  title: 'Recomendados para ti',
                  onSeeAll: () {},
                ),
                _buildDiscountedProductsSection(), 
                const SizedBox(height: AppSizes.paddingL),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalBanner() {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF7C4DFF)],
        ),
      ),
      child: Stack(
        children: [
          // Patrón de fondo
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              child: Opacity(
                opacity: 0.2, // Aplica la opacidad a toda la imagen.
                child: CachedNetworkImage(
                  imageUrl:
                      'https://img.freepik.com/vector-premium/fondo-simple-descuentos-primas-ventas_294571-1037.jpg',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey[400],
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
          // Contenido del banner
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  '¡50% de descuento!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingS),
                const Text(
                  'En tu primer pedido',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),
                Flexible(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingL,
                          vertical: AppSizes.paddingS,
                        ),
                      ),
                      child: const Text(
                        'Ordenar ahora',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildCategoriesSection() {
  return SizedBox(
    height: 120,
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      scrollDirection: Axis.horizontal,
      itemCount: _topCategories.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final category = _topCategories[index];
        final categoryProducts = (_discountedProducts)
            .where((product) => product.category == category.name)
            .toList();
        return CategoryCard(
          category: category,
          onTap: () {
            _navigateToCategoryDetail(context, category, categoryProducts);
          },
        );
      },
    ),
  );
}

void _navigateToCategoryDetail(
    BuildContext context, CategoryModel category, List<ProductModel> products) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CategoryDetailPage(
        category: category,
        categoryName: category.name,
        products: products,
      ),
    ),
  );
}
void _navigateToStoreDetail(
    BuildContext context, StoreModel store, List<ProductModel> products) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => StoreDetailPage(
        store: store,
        storeName: store.name,
        products: products,
      ),
    ),
  );
}

Widget _buildDiscountedProductsSection() {
  return SizedBox(
    height: 280,
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      scrollDirection: Axis.horizontal,
      itemCount: _discountedProducts.length,
      itemBuilder: (context, index) {
        final product = _discountedProducts[index]; 

        return ProductGridCard(
          product: product,
          onTap: () {
            _navigateToProductDetail(context, product); 
          },
        );
      },
    ),
  );
}


Widget _buildTopStoresSection() {
  return ListView.builder(
    padding: EdgeInsets.zero,
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: _topStores.length,
    itemBuilder: (context, index) {
      final store = _topStores[index];

      final storeProducts = _discountedProducts
          .where((product) => product.storeName == store.name)
          .toList();

      return StoreCard(
        store: store,
        onTap: () {
          _navigateToStoreDetail(context, store, storeProducts);
        },
      );
    },
  );
}

}

void _navigateToProductDetail(BuildContext context, ProductModel product) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailPage(product: product),
    ),
  );
}

