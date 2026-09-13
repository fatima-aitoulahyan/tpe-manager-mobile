import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/locale/locale_provider.dart';
import '../../l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  static const Color _primaryColor  = Color(0xFF2563EB);
  static const Color _textColor     = Color(0xFF0F172A);
  static const Color _subtitleColor = Color(0xFF475569);
  static const Color _borderColor   = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = context.watch<LocaleProvider>().locale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.languageLabel,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _LanguageOption(
                label: 'Français',
                flag: '🇫🇷',
                selected: currentLocale.languageCode == 'fr',
                onTap: () => context.read<LocaleProvider>().setLocale(const Locale('fr')),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _LanguageOption(
                label: 'العربية',
                flag: '🇲🇦',
                selected: currentLocale.languageCode == 'ar',
                onTap: () => context.read<LocaleProvider>().setLocale(const Locale('ar')),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final String flag;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.flag,
    required this.selected,
    required this.onTap,
  });

  static const Color _primaryColor  = Color(0xFF2563EB);
  static const Color _textColor     = Color(0xFF0F172A);
  static const Color _borderColor   = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? _primaryColor.withOpacity(0.08) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? _primaryColor : _borderColor,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? _primaryColor : _textColor,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.check_circle, size: 16, color: _primaryColor),
            ],
          ],
        ),
      ),
    );
  }
}