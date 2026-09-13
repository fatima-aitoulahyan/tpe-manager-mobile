import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../../../../l10n/app_localizations.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  static const Color _primaryColor  = Color(0xFF2563EB);
  static const Color _bgColor       = Color(0xFFF8FAFC);
  static const Color _textColor     = Color(0xFF0F172A);
  static const Color _subtitleColor = Color(0xFF475569);

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
          ForgotPasswordRequested(_emailCtrl.text.trim()));
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordEmailSent) {
            context.push('/verify-code', extra: _emailCtrl.text.trim());
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
                        color: _primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_reset_outlined,
                          color: _primaryColor, size: 32),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      l10n.forgotPasswordTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.forgotPasswordSubtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: _subtitleColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    AuthTextField(
                      label:        l10n.emailLabel,
                      hint:         l10n.emailHint,
                      controller:   _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon:   Icons.mail_outline_rounded,
                      validator: (v) {
                        if (v == null || v.isEmpty) return l10n.emailRequired;
                        if (!v.contains('@')) return l10n.emailInvalid;
                        return null;
                      },
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
                          l10n.sendCode,
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