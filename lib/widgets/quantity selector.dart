import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onRemove, icon: const Icon(Icons.remove)),
        Text(quantity.toString()),
        IconButton(onPressed: onAdd, icon: const Icon(Icons.add)),
      ],
    );
  }
}
