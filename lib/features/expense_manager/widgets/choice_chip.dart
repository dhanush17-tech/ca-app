import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/material.dart';

class ExpenseTypeChoiceChip extends StatelessWidget {
  final List<String> labels;
  final String selectedLabel;
  final ValueChanged<String> onSelected;

  const ExpenseTypeChoiceChip({
    super.key,
    required this.labels,
    required this.selectedLabel,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      children: labels.map((label) {
        final bool isSelected =
            selectedLabel.toLowerCase() == label.toLowerCase();
        return ChoiceChip(
          
          label: Text(label),
          selected: isSelected,
          onSelected: (bool selected) {
            onSelected(label);
          },
          showCheckmark: false,
          selectedColor: AppPalates.primary,
          checkmarkColor: AppPalates.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }
}
