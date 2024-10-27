import 'package:flutter/material.dart';
import 'package:panda/models/store_model.dart';
import 'package:panda/models/product_model.dart';
import 'package:panda/pages/product_detail_page.dart';
import 'package:panda/widgets/product_grid_card.dart';

class StoreDetailPage extends StatefulWidget {
  final StoreModel store;
  final List<ProductModel> products;
  final String storeName;

  const StoreDetailPage({
    Key? key,
    required this.store,
    required this.products,
    required this.storeName,
  }) : super(key: key);

  @override
  _StoreDetailPageState createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> 
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  late ScrollController _scrollController;
  
  String searchQuery = '';
  bool _isSearchFocused = false;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _scrollController = ScrollController();
    
    _searchFocusNode.addListener(_onFocusChange);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 0 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  void _onFocusChange() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<ProductModel> _getFilteredProducts() {
    if (searchQuery.isEmpty) return widget.products;
    return widget.products.where((product) {
      final nameMatch = product.name.toLowerCase().contains(searchQuery.toLowerCase());
      final descriptionMatch = product.description.toLowerCase().contains(searchQuery.toLowerCase());
      return nameMatch || descriptionMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Header con información de la tienda
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagen de fondo
                  Hero(
                    tag: 'store-${widget.store.id}',
                    child: Image.network(
                      widget.store.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.surfaceVariant,
                          child: Icon(
                            Icons.store_rounded,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  ),
                  // Gradiente oscuro para mejorar legibilidad
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Información de la tienda
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.store.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            widget.store.deliveryTime,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botón de regreso
                  Positioned(
                    top: MediaQuery.of(context).padding.top,
                    left: 8,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Barra de búsqueda
          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchBarDelegate(
              isSearchFocused: _isSearchFocused,
              searchController: _searchController,
              searchFocusNode: _searchFocusNode,
              onSearchChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              storeName: widget.store.name,
              theme: theme,
            ),
          ),
          // Productos
          if (filteredProducts.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      searchQuery.isEmpty 
                          ? Icons.store_rounded 
                          : Icons.search_off_rounded,
                      size: 64,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      searchQuery.isEmpty
                          ? 'No hay productos disponibles en esta tienda'
                          : 'No se encontraron productos',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    if (searchQuery.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              searchQuery = '';
                            });
                          },
                          child: const Text('Limpiar búsqueda'),
                        ),
                      ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = filteredProducts[index];
                    return Hero(
                      tag: 'product-${product.id}',
                      child: ProductGridCard(
                        product: product,
                        onTap: () => _navigateToProductDetail(context, product),
                      ),
                    );
                  },
                  childCount: filteredProducts.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context, ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }
}

// Delegado para la barra de búsqueda persistente
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final bool isSearchFocused;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final Function(String) onSearchChanged;
  final String storeName;
  final ThemeData theme;

  _SearchBarDelegate({
    required this.isSearchFocused,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchChanged,
    required this.storeName,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Container(
        height: 56.0,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(28.0),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          focusNode: searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Buscar en $storeName...',
            prefixIcon: Icon(
              Icons.search_rounded,
              color: isSearchFocused 
                  ? theme.colorScheme.primary 
                  : theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      onSearchChanged('');
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: isSearchFocused
                ? theme.colorScheme.surface
                : theme.colorScheme.surfaceVariant.withOpacity(0.3),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
          ),
          onChanged: onSearchChanged,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 72.0;

  @override
  double get minExtent => 72.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}