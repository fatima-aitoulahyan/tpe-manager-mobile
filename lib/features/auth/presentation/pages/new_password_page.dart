import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../../../../l10n/app_localizations.dart';

class NewPasswordPage extends StatefulWidget {
  final String email;
  final String code;
  const NewPasswordPage({
    super.key, required this.email, required this.code});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey       = GlobalKey<FormState>();
  final _passwordCtrl  = TextEditingController();
  final _confirmCtrl   = TextEditingController();
  bool _obscurePass    = true;
  bool _obscureConfirm = true;

  static const Color _primaryColor  = Color(0xFF2563EB);
  static const Color _bgColor       = Color(0xFFF8FAFC);
  static const Color _textColor     = Color(0xFF0F172A);
  static const Color _subtitleColor = Color(0xFF475569);

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_passwordCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.passwordsDontMatch),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    context.read<AuthBloc>().add(ResetPasswordRequested(
        widget.email, widget.code, _passwordCtrl.text));
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is PasswordResetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.passwordResetSuccess),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
            context.go('/login');
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_outline,
                          color: Colors.green, size: 32),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      l10n.newPasswordTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.newPasswordSubtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: _subtitleColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    AuthTextField(
                      label:       l10n.newPasswordLabel,
                      hint:        '••••••••',
                      controller:  _passwordCtrl,
                      obscureText: _obscurePass,
                      prefixIcon:  Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 19,
                          color: _subtitleColor,
                        ),
                        onPressed: () => setState(
                                () => _obscurePass = !_obscurePass),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return l10n.fieldRequired;
                        if (v.length < 8) return l10n.passwordMinLength;
                        return null;
                      },
                    ),

                    AuthTextField(
                      label:       l10n.confirmPasswordLabel,
                      hint:        '••••••••',
                      controller:  _confirmCtrl,
                      obscureText: _obscureConfirm,
                      prefixIcon:  Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 19,
                          color: _subtitleColor,
                        ),
                        onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                      ),
                      validator: (v) =>
                      v == null || v.isEmpty ? l10n.fieldRequired : null,
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: state is AuthLoading
                            ? const SizedBox(
                            width: 22, height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.4))
                            : Text(
                          l10n.resetButton,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}