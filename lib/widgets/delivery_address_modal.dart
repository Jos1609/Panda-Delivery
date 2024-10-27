import 'package:flutter/material.dart';
import 'package:panda/models/delivery_address.dart';
import 'package:panda/widgets/add_address_form.dart';

class DeliveryAddressModal extends StatefulWidget {
  final Function(DeliveryAddress) onAddressSelected;

  const DeliveryAddressModal({
    Key? key,
    required this.onAddressSelected,
  }) : super(key: key);

  @override
  State<DeliveryAddressModal> createState() => _DeliveryAddressModalState();
}

class _DeliveryAddressModalState extends State<DeliveryAddressModal> {
  DeliveryAddress? selectedAddress;
  final List<DeliveryAddress> addresses = [
    // Aquí irían tus direcciones guardadas
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selecciona una dirección',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...addresses.map((address) => _buildAddressItem(address)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showAddAddressForm(context),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                SizedBox(width: 8),
                Text('Agregar nueva dirección'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(DeliveryAddress address) {
    return RadioListTile<DeliveryAddress>(
      title: Text(address.name),
      subtitle: Text(address.address),
      value: address,
      groupValue: selectedAddress,
      onChanged: (value) {
        setState(() => selectedAddress = value);
        if (value != null) {
          widget.onAddressSelected(value);
        }
      },
    );
  }

  void _showAddAddressForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddAddressForm(
        onSave: (newAddress) {
          // Aquí irá la lógica para guardar la nueva dirección
          setState(() {
            addresses.add(newAddress);
            selectedAddress = newAddress;
          });
          widget.onAddressSelected(newAddress);
          Navigator.pop(context);
        },
      ),
    );
  }
}
