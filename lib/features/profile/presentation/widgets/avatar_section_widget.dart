import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../../../l10n/app_localizations.dart';

class AvatarSectionWidget extends StatelessWidget {
  final UserModel user;
  const AvatarSectionWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: [
        // ── Avatar ──
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
          ),
          child: Center(
            child: Text(
              '${user.prenom.isNotEmpty ? user.prenom[0] : ""}${user.nom.isNotEmpty ? user.nom[0] : ""}'.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        Text('${user.prenom} ${user.nom}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email_outlined,
                size: 13, color: Colors.white70),
            const SizedBox(width: 6),
            Text(user.email,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),

        if (user.telephone.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone_outlined,
                  size: 13, color: Colors.white70),
              const SizedBox(width: 6),
              Text(user.telephone,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],

        if (user.statutFiscal != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _statutLabel(user.statutFiscal!, l10n),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ]),
    );
  }

  String _statutLabel(String statut, AppLocalizations l10n) {
    switch (statut) {
      case 'auto_entrepreneur':
        return l10n.statusAutoEntrepreneur;
      case 'tpe':
        return l10n.statusTpe;
      case 'artisan':
        return l10n.statusArtisan;
      case 'freelance':
        return l10n.statusFreelance;
      case 'commercant':
        return l10n.statusCommercant;
      default:
        return statut;
    }
  }
}