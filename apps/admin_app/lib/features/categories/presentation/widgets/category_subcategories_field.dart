import 'package:flutter/material.dart';

class CategorySubcategoriesField extends StatelessWidget {
  final Set<String> selectedSubcategories;
  final List<String> suggestedSubcategories;
  final TextEditingController newSubcategoryController;
  final ValueChanged<String> onToggleSuggested;
  final VoidCallback onAddCustom;
  final ValueChanged<String> onRemoveCustom;

  const CategorySubcategoriesField({
    super.key,
    required this.selectedSubcategories,
    required this.suggestedSubcategories,
    required this.newSubcategoryController,
    required this.onToggleSuggested,
    required this.onAddCustom,
    required this.onRemoveCustom,
  });

  @override
  Widget build(BuildContext context) {
    final customSubcategories =
        selectedSubcategories.where((s) => !suggestedSubcategories.contains(s)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subcategories', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        if (suggestedSubcategories.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: suggestedSubcategories.map((sub) {
              final isSelected = selectedSubcategories.contains(sub);
              return FilterChip(
                label: Text(sub, style: const TextStyle(fontSize: 12)),
                selected: isSelected,
                onSelected: (_) => onToggleSuggested(sub),
              );
            }).toList(),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: newSubcategoryController,
                decoration: const InputDecoration(labelText: 'Add new subcategory', isDense: true),
                onFieldSubmitted: (_) => onAddCustom(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: onAddCustom),
          ],
        ),
        if (customSubcategories.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: customSubcategories
                .map(
                  (sub) => Chip(
                    label: Text(sub, style: const TextStyle(fontSize: 12)),
                    onDeleted: () => onRemoveCustom(sub),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
