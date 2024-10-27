import 'package:flutter/material.dart';
import 'package:panda/models/delivery_address.dart';
import 'package:panda/models/product_model.dart';
import 'package:panda/pages/checkout_page.dart';
import 'package:panda/widgets/delivery_address_modal.dart';

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
                _buildDeliverySection(),
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

  Widget _buildDeliverySection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            title: const Text('Dirección de entrega'),
            trailing: TextButton(
              onPressed: _showAddressModal,
              child: const Text('Cambiar'),
            ),
          ),
          if (selectedAddress != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(selectedAddress!.name),
                  const SizedBox(height: 4),
                  Text(selectedAddress!.address),
                  const SizedBox(height: 8),
                  Text(
                    'Tiempo estimado de entrega: 30-45 min',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    final subtotal = widget.product.price * quantity;
    final delivery = 5.0; // Ejemplo de costo de delivery
    final total = subtotal + delivery;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPriceRow('Subtotal', subtotal),
            const SizedBox(height: 8),
            _buildPriceRow('Delivery', delivery),
            const Divider(),
            _buildPriceRow('Total', total, isTotal: true),
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
        child: ElevatedButton(
          onPressed: selectedAddress != null ? _proceedToCheckout : null,
          child: const Text('Proceder al pago'),
        ),
      ),
    );
  }

  void _showAddressModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DeliveryAddressModal(
        onAddressSelected: (address) {
          setState(() => selectedAddress = address);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _proceedToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          product: widget.product,
          quantity: quantity,
          address: selectedAddress!,
        ),
      ),
    );
  }
}