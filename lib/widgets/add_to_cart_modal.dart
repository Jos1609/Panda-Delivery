import 'package:flutter/material.dart';
import 'package:panda/pages/cart_page.dart';

class AddToCartModal extends StatelessWidget {
  const AddToCartModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 20),
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50,
          ),
          const SizedBox(height: 10),
          const Text(
            '¡Producto añadido!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Seguir comprando'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Ir al carrito'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}