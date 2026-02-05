import 'package:flutter/material.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String selected;
  final Function(String) onSelect;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: sizes.map((s) => s == selected).toList(),
      onPressed: (index) => onSelect(sizes[index]),
      children: sizes.map((s) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(s),
      )).toList(),
    );
  }
}
