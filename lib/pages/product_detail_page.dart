import 'package:flutter/material.dart';
import 'package:panda/models/cart_item_model.dart';
import 'package:panda/models/delivery_address.dart';
import 'package:panda/models/product_model.dart';
import 'package:panda/pages/checkout_page.dart';
import 'package:panda/providers/carrito_provider.dart';
import 'package:panda/widgets/add_to_cart_modal.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  DeliveryAddress? selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageGallery(),
                _buildProductInfo(),
                _buildQuantitySelector(),
                _buildTotalSection(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          widget.product.images[0],
          fit: BoxFit.cover,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildImageGallery() {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: widget.product.images.length,
        itemBuilder: (context, index) {
          return Image.network(
            widget.product.images[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            '\S/ ${widget.product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.product.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Cantidad:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              if (quantity > 1) {
                setState(() => quantity--);
              }
            },
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Text(
            quantity.toString(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            onPressed: () {
              setState(() => quantity++);
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    final subtotal = widget.product.price * quantity;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPriceRow('Subtotal', subtotal),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge
              : Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          '\S/ ${amount.toStringAsFixed(2)}',
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  )
              : Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Agregar al Carrito'),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: ElevatedButton(
                onPressed: _proceedToCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Proceder al pago'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart() {
    final carritoProvider = Provider.of<CarritoProvider>(context, listen: false);
    final cartItem = CartItemModel(
      product: widget.product,
      quantity: quantity,
    );
    carritoProvider.addToCart(cartItem);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddToCartModal(),
    );
  }
  
  void _proceedToCheckout() {
    final carritoProvider =
        Provider.of<CarritoProvider>(context, listen: false);

    final cartItem = CartItemModel(
      product: widget.product,
      quantity: quantity,
    );

    carritoProvider.addToCart(cartItem);

    final selectedItems = [cartItem];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          cartItems: selectedItems,
        ),
      ),
    );
  }
}
