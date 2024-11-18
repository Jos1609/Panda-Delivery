import 'package:flutter/material.dart';
import 'package:panda/models/cart_item_model.dart';
import 'package:panda/models/delivery_address.dart';
import 'package:panda/providers/carrito_provider.dart';
import 'package:panda/widgets/delivery_address_modal.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItemModel> cartItems;

  const CheckoutPage({
    Key? key,
    required this.cartItems,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? selectedPaymentMethod;
  DeliveryAddress? selectedAddress;

  void _updateSelectedAddress(DeliveryAddress address) {
    setState(() {
      selectedAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        children: [
          _buildOrderSummary(),
          _buildDeliveryInfo(),
          _buildPaymentMethods(),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
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

  Widget _buildOrderSummary() {
    double subtotal = 0;
    double delivery = 5.0;

    for (var item in widget.cartItems) {
      subtotal += item.product.price * item.quantity;
    }

    double total = subtotal + delivery;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen del pedido',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.product.images[0],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text('Cantidad: ${item.quantity}'),
                            Text(
                              '\S/ ${item.product.price.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(height: 32),
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

  Widget _buildDeliveryInfo() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dirección de entrega',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (selectedAddress != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(selectedAddress!.name),
                  Text(selectedAddress!.address),
                  if (selectedAddress!.reference.isNotEmpty)
                    Text(selectedAddress!.reference),
                ],
              )
            else
              ElevatedButton(
                onPressed: _showAddressModal,
                child: const Text('Seleccionar dirección'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Método de pago',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildPaymentOption('Efectivo', 'cash'),
            _buildPaymentOption('Tarjeta de crédito', 'credit_card'),
            _buildPaymentOption('PayPal', 'paypal'),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, String value) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: selectedPaymentMethod,
      onChanged: (value) {
        setState(() => selectedPaymentMethod = value);
      },
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
              offset: const Offset(0, -4),
              blurRadius: 8,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: selectedPaymentMethod != null && selectedAddress != null
              ? _confirmOrder
              : null,
          child: const Text('Confirmar pedido'),
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
          _updateSelectedAddress(address);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _confirmOrder() {
    final carritoProvider =
        Provider.of<CarritoProvider>(context, listen: false);
    final selectedItems =
        widget.cartItems; // Los items que fueron seleccionados para pago

    // Eliminar solo los productos pagados
    carritoProvider.removeSelectedItems(selectedItems);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pedido confirmado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50,
            ),
            const SizedBox(height: 16),
            const Text('Tu pedido ha sido procesado exitosamente'),
            const SizedBox(height: 8),
            Text(
              '${selectedItems.length} ${selectedItems.length == 1 ? 'producto' : 'productos'} comprados',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Navegar al inicio y limpiar el stack
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
