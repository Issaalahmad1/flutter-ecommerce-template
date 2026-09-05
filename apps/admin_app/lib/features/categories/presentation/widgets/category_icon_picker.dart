import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CategoryIconPicker extends StatelessWidget {
  final String? selectedIconKey;
  final ValueChanged<String?> onChanged;

  const CategoryIconPicker({super.key, required this.selectedIconKey, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose a ready-made icon:', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: CategoryIconLibrary.icons.entries.map((entry) {
            final isSelected = selectedIconKey == entry.value;
            return GestureDetector(
              onTap: () => onChanged(isSelected ? null : entry.value),
              child: Container(
                width: 64,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.lightGreenAccent : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(CategoryIconLibrary.assetPath(entry.value), height: 28),
                    const SizedBox(height: 4),
                    Text(entry.key, style: const TextStyle(fontSize: 9), textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
