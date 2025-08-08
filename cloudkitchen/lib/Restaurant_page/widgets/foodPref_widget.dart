import 'package:flutter/material.dart';

class FoodPreferenceSelector extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const FoodPreferenceSelector({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        _buildRadioOption('veg', 'Veg'),
        _buildRadioOption('non-veg', 'Non-Veg'),
        _buildRadioOption('both', 'Both'),
      ],
    );
  }

  Widget _buildRadioOption(String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: selectedValue,
          activeColor: Color(0xFF45C3FF),
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }
}