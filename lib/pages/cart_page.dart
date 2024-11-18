import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:panda/models/cart_item_model.dart';
import 'package:panda/pages/checkout_page.dart';
import 'package:panda/providers/carrito_provider.dart';
import 'package:panda/widgets/cart_item_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CarritoProvider>(
      builder: (context, carritoProvider, child) {
        final cartItems = carritoProvider.items;
        
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Mi Carrito',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            actions: [
              if (cartItems.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    carritoProvider.clearCart();
                  },
                  icon: const Icon(Icons.remove_shopping_cart, size: 20),
                  label: const Text('Limpiar'),
                ),
            ],
          ),
          body: cartItems.isEmpty
              ? _buildEmptyCart()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartItems.length,
                        separatorBuilder: (context, index) => const Divider(height: 32),
                        itemBuilder: (context, index) {
                          return CartItemWidget(item: cartItems[index]);
                        },
                      ),
                    ),
                    if (cartItems.isNotEmpty) _buildOrderSummary(cartItems),
                  ],
                ),
          bottomNavigationBar: cartItems.isEmpty ? null : _buildBottomBar(cartItems),
        );
      },
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Tu carrito está vacío',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega productos para comenzar',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Ir a comprar'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(List<CartItemModel> items) {
    return Consumer<CarritoProvider>(
      builder: (context, carritoProvider, child) {
        final total = carritoProvider.total;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              top: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resumen del pedido',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal'),
                  Text('\S/ ${total.toStringAsFixed(2)}'),
                ],
              ),
              const SizedBox(height: 8),
              
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(List<CartItemModel> items) {
    return Consumer<CarritoProvider>(
      builder: (context, carritoProvider, child) {
        final selectedItems = items.where((item) => item.isSelected).toList();
        final itemCount = selectedItems.length;

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: itemCount > 0 ? () => _proceedToCheckout(selectedItems) : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                itemCount > 0
                    ? 'Pagar ($itemCount ${itemCount == 1 ? 'item' : 'items'})'
                    : 'Selecciona items para pagar',
              ),
            ),
          ),
        );
      },
    );
  }

  void _proceedToCheckout(List<CartItemModel> selectedItems) {
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