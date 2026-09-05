import 'package:flutter/material.dart';

/// صف "تاريخ الانتهاء" — بيعرض التاريخ المختار (لو موجود) مع زرارين
/// لاختيار تاريخ/وقت جديد أو مسح التاريخ الحالي.
class BannerExpiryPicker extends StatelessWidget {
  final DateTime? expiresAt;
  final ValueChanged<DateTime?> onChanged;

  const BannerExpiryPicker({super.key, required this.expiresAt, required this.onChanged});

  Future<void> _pickDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: expiresAt ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate == null || !context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: expiresAt != null
          ? TimeOfDay.fromDateTime(expiresAt!)
          : const TimeOfDay(hour: 23, minute: 59),
    );
    if (pickedTime == null) return;

    onChanged(
      DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        expiresAt == null
            ? 'No expiry date'
            : 'Expires: ${expiresAt!.day}/${expiresAt!.month}/${expiresAt!.year}',
      ),
      trailing: Wrap(
        spacing: 4,
        children: [
          TextButton(onPressed: () => _pickDateTime(context), child: const Text('Set date')),
          if (expiresAt != null)
            TextButton(onPressed: () => onChanged(null), child: const Text('Clear')),
        ],
      ),
    );
  }
}
