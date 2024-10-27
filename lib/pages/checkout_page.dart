import 'package:flutter/material.dart';
import 'package:panda/models/delivery_address.dart';
import 'package:panda/models/product_model.dart';

class CheckoutPage extends StatefulWidget {
  final ProductModel product;
  final int quantity;
  final DeliveryAddress address;

  const CheckoutPage({
    Key? key,
    required this.product,
    required this.quantity,
    required this.address,
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? selectedPaymentMethod;

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
    final subtotal = widget.product.price * widget.quantity;
    final delivery = 5.0;
    final total = subtotal + delivery;

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.product.images[0],
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
                        widget.product.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text('Cantidad: ${widget.quantity}'),
                      Text(
                        '\S/ ${widget.product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
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
            Text(widget.address.name),
            Text(widget.address.address),
            if (widget.address.reference.isNotEmpty) Text(widget.address.reference),
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
          onPressed: selectedPaymentMethod != null ? _confirmOrder : null,
          child: const Text('Confirmar pedido'),
        ),
      ),
    );
  }

  void _confirmOrder() {
    // Aquí irá la lógica para procesar el pedido
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pedido confirmado'),
        content: const Text('Tu pedido ha sido procesado exitosamente'),
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
