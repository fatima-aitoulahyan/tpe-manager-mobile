import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class PasswordDialogWidget extends StatefulWidget {
  final Function(String oldPassword, String newPassword) onConfirm;
  const PasswordDialogWidget({super.key, required this.onConfirm});

  @override
  State<PasswordDialogWidget> createState() => _PasswordDialogWidgetState();
}

class _PasswordDialogWidgetState extends State<PasswordDialogWidget> {
  final _oldPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmCtrl     = TextEditingController();
  final _formKey         = GlobalKey<FormState>();

  bool _showOld     = false;
  bool _showNew     = false;
  bool _showConfirm = false;

  static const Color primaryColor = Color(0xFF2563EB);
  static const Color textColor    = Color(0xFF0F172A);
  static const Color borderColor  = Color(0xFFE2E8F0);

  @override
  void dispose() {
    _oldPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_newPasswordCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.passwordsDoNotMatchError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    widget.onConfirm(_oldPasswordCtrl.text, _newPasswordCtrl.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_outline,
                    color: primaryColor, size: 22),
              ),
              const SizedBox(height: 14),
              Text(l10n.changePasswordTitle,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.changePasswordSubtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),

              _passwordField(
                label: l10n.oldPasswordLabel,
                controller: _oldPasswordCtrl,
                obscure: !_showOld,
                onToggle: () => setState(() => _showOld = !_showOld),
                validator: (v) =>
                v == null || v.isEmpty ? l10n.requiredFieldError : null,
              ),
              const SizedBox(height: 12),

              _passwordField(
                label: l10n.newPasswordLabel,
                controller: _newPasswordCtrl,
                obscure: !_showNew,
                onToggle: () => setState(() => _showNew = !_showNew),
                validator: (v) {
                  if (v == null || v.isEmpty) return l10n.requiredFieldError;
                  if (v.length < 8) return l10n.minCharactersError(8);
                  return null;
                },
              ),
              const SizedBox(height: 12),

              _passwordField(
                label: l10n.confirmNewPasswordLabel,
                controller: _confirmCtrl,
                obscure: !_showConfirm,
                onToggle: () =>
                    setState(() => _showConfirm = !_showConfirm),
                validator: (v) =>
                v == null || v.isEmpty ? l10n.requiredFieldError : null,
              ),
              const SizedBox(height: 24),

              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: borderColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(l10n.cancelButton,
                      style: const TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(l10n.validateButton,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            fontSize: 12, color: Color(0xFF64748B)),
        prefixIcon: const Icon(Icons.lock_outline,
            size: 18, color: Color(0xFF94A3B8)),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            size: 18,
            color: const Color(0xFF94A3B8),
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 14, horizontal: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
      ),
    );
  }
}