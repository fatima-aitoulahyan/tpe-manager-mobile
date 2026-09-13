import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../../../../l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey      = GlobalKey<FormState>();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePass   = true;

  static const Color _primaryColor  = Color(0xFF2563EB);
  static const Color _bgColor       = Color(0xFFF8FAFC);
  static const Color _textColor     = Color(0xFF0F172A);
  static const Color _subtitleColor = Color(0xFF475569);
  static const Color _borderColor   = Color(0xFFE2E8F0);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(LoginRequested(
        email:    _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _bgColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go('/dashboard');
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    Text(
                      l10n.loginTitle,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.loginSubtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: _subtitleColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 36),

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

                    AuthTextField(
                      label:       l10n.passwordLabel,
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
                        onPressed: () =>
                            setState(() => _obscurePass = !_obscurePass),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return l10n.passwordRequired;
                        if (v.length < 8) return l10n.passwordMinLength;
                        return null;
                      },
                    ),

                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () {
                          context.push('/forgot-password');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                        ),
                        child: Text(
                          l10n.forgotPassword,
                          style: const TextStyle(
                            color: _primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading ? null : _onLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          disabledBackgroundColor: _primaryColor.withOpacity(0.6),
                          elevation: 0,
                          shadowColor: _primaryColor.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: state is AuthLoading
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.4,
                          ),
                        )
                            : Text(
                          l10n.loginButton,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    Row(
                      children: [
                        const Expanded(child: Divider(color: _borderColor, thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            l10n.orDivider,
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                          ),
                        ),
                        const Expanded(child: Divider(color: _borderColor, thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.noAccount,
                            style: const TextStyle(color: _subtitleColor, fontSize: 13.5),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/register'),
                            child: Text(
                              l10n.createAccount,
                              style: const TextStyle(
                                color: _primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ],
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