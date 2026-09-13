import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class CustomDatePickerField extends StatelessWidget {
  final DateTime? date;
  final String? hintText;
  final Function(DateTime) onPick;

  const CustomDatePickerField({
    super.key,
    required this.date,
    required this.onPick,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final resolvedHint = hintText ?? l10n.selectDateHint;

    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now().add(const Duration(days: 30)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 17,
                color: date != null ? const Color(0xFF2563EB) : const Color(0xFF94A3B8)),
            const SizedBox(width: 10),
            Text(
              date != null
                  ? '${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}'
                  : resolvedHint,
              style: TextStyle(
                fontSize: 14,
                color: date != null ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}