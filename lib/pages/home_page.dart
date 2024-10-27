import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import '../services/home_service.dart';
import '../widgets/category_card.dart';
import '../widgets/product_grid_card.dart';
import '../widgets/store_card.dart';
import '../widgets/section_title.dart';
import '../utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeService _homeService = HomeService();
  bool _isLoading = true;
  String? _error;

  List<CategoryModel> _topCategories = [];
  List<ProductModel> _discountedProducts = [];
  List<StoreModel> _topStores = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final futures = await Future.wait([
        _homeService.getTopCategories(),
        _homeService.getDiscountedProducts(),
        _homeService.getTopStores(),
      ]);

      setState(() {
        _topCategories = futures[0] as List<CategoryModel>;
        _discountedProducts = futures[1] as List<ProductModel>;
        _topStores = futures[2] as List<StoreModel>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar los datos. Por favor, intenta de nuevo.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            const SizedBox(height: AppSizes.paddingM),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            title: const Text('Delivery App'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Implementar búsqueda
                },
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Implementar carrito
                },
              ),
            ],
          ),

          // Contenido principal
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Banner promocional
                _buildPromotionalBanner(),

                // Categorías más pedidas
                SectionTitle(
                  title: 'Categorías Populares',
                  onSeeAll: () {
                    // Navegar a todas las categorías
                  },
                ),
                _buildCategoriesSection(),

                // Ofertas y descuentos
                SectionTitle(
                  title: 'Ofertas Especiales',
                  onSeeAll: () {
                    // Navegar a todas las ofertas
                  },
                ),
                _buildDiscountedProductsSection(),

                // Tiendas destacadas
                SectionTitle(
                  title: 'Tiendas Destacadas',
                  onSeeAll: () {
                    // Navegar a todas las tiendas
                  },
                ),
                _buildTopStoresSection(),

                // Sección de recomendados
                SectionTitle(
                  title: 'Recomendados para ti',
                  onSeeAll: () {
                    // Navegar a recomendados
                  },
                ),
                _buildRecommendedSection(),

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
          colors: [AppColors.primary, Color(0xFF7C4DFF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              child: Image.network(
                'https://example.com/banner.jpg', // Cambiar por tu imagen
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: AppSizes.paddingL,
            bottom: AppSizes.paddingL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¡Ofertas Especiales!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingS),
                ElevatedButton(
                  onPressed: () {
                    // Navegar a ofertas especiales
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('Ver Ofertas'),
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
        itemBuilder: (context, index) {
          return CategoryCard(
            category: _topCategories[index],
            onTap: () {
              // Navegar a la categoría
            },
          );
        },
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
          return ProductGridCard(
            product: _discountedProducts[index],
            onTap: () {
              // Navegar al producto
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
        return StoreCard(
          store: _topStores[index],
          onTap: () {
            // Navegar a la tienda
          },
        );
      },
    );
  }

  Widget _buildRecommendedSection() {
    // Usando los productos con descuento como ejemplo
    return SizedBox(
      height: 280,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
        scrollDirection: Axis.horizontal,
        itemCount: _discountedProducts.length,
        itemBuilder: (context, index) {
          return ProductGridCard(
            product: _discountedProducts[index],
            onTap: () {
              // Navegar al producto
            },
          );
        },
      ),
    );
  }
}