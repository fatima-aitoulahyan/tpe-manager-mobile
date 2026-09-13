import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tpe_mobile/shared/utils/currency_format.dart';
import '../../../../l10n/app_localizations.dart';

class DocumentActions {
  static void confirmDelete({
    required BuildContext context,
    required String title,
    required VoidCallback onDeleteConfirm,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        content: Text(l10n.deleteConfirmationMessage, style: const TextStyle(color: Color(0xFF94A3B8))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton, style: const TextStyle(color: Color(0xFF94A3B8))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDeleteConfirm();
            },
            child: Text(l10n.deleteButton, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static void showPdfOptions({
    required BuildContext context,
    required String filePath,
    required String numero,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(numero, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.open_in_new, color: Color(0xFF2563EB)),
              title: Text(l10n.openPdfOption, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B))),
              onTap: () {
                Navigator.pop(context);
                OpenFilex.open(filePath);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.green),
              title: Text(l10n.sharePdfOption, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B))),
              onTap: () {
                Navigator.pop(context);
                Share.shareXFiles(
                  [XFile(filePath)],
                  subject: l10n.documentSubject(numero),
                  text: l10n.documentShareText(numero),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static void remindClient({
    required BuildContext context,
    required String docNumero,
    required String clientNom,
    required String? telephone,
    required String? email,
    required double montant,
    required String dateInfo,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.remindClientTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
            Text('$docNumero — $clientNom', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.message, color: Color(0xFF25D366)),
              title: Text(l10n.sendViaWhatsApp, style: const TextStyle(fontSize: 14)),
              subtitle: Text(telephone ?? l10n.noPhoneNumber, style: const TextStyle(fontSize: 11)),
              onTap: () async {
                Navigator.pop(context);
                if (telephone == null || telephone.isEmpty) return;

                final message = Uri.encodeComponent(
                    l10n.whatsappReminderMessage(clientNom, docNumero, montant.toDH as String, dateInfo)
                );
                String phone = telephone.replaceAll(' ', '').replaceAll('-', '');
                if (phone.startsWith('0')) phone = '+212${phone.substring(1)}';

                final url = Uri.parse('https://wa.me/$phone?text=$message');
                if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined, color: Color(0xFF2563EB)),
              title: Text(l10n.sendViaEmail, style: const TextStyle(fontSize: 14)),
              subtitle: Text(email ?? l10n.noEmailAddress, style: const TextStyle(fontSize: 11)),
              onTap: () async {
                Navigator.pop(context);
                if (email == null || email.isEmpty) return;

                final subject = Uri.encodeComponent(l10n.emailReminderSubject(docNumero));
                final body = Uri.encodeComponent(
                    l10n.emailReminderBody(clientNom, docNumero, montant.toDH(), dateInfo)
                );
                final url = Uri.parse('mailto:$email?subject=$subject&body=$body');
                if (await canLaunchUrl(url)) await launchUrl(url);
              },
            ),
          ],
        ),
      ),
    );
  }
}