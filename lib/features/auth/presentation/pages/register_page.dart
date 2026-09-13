import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../../../../l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey       = GlobalKey<FormState>();
  final _nomCtrl       = TextEditingController();
  final _prenomCtrl    = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _telephoneCtrl = TextEditingController();
  final _iceCtrl       = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  final _confirmCtrl   = TextEditingController();
  bool _obscurePass    = true;
  bool _obscureConfirm = true;
  String? _statutFiscal;

  static const Color _primaryColor  = Color(0xFF2563EB);
  static const Color _textColor     = Color(0xFF0F172A);
  static const Color _subtitleColor = Color(0xFF475569);
  static const Color _borderColor   = Color(0xFFE2E8F0);

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _emailCtrl.dispose();
    _telephoneCtrl.dispose();
    _iceCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _onRegister() {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      if (_passwordCtrl.text != _confirmCtrl.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.passwordsDontMatch),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }
      context.read<AuthBloc>().add(RegisterRequested(
        nom:             _nomCtrl.text.trim(),
        prenom:          _prenomCtrl.text.trim(),
        email:           _emailCtrl.text.trim(),
        telephone:       _telephoneCtrl.text.trim(),
        password:        _passwordCtrl.text,
        passwordConfirm: _confirmCtrl.text,
        statutFiscal:    _statutFiscal,
        ice:             _iceCtrl.text.trim().isEmpty ? null : _iceCtrl.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Map<String, String>> statuts = [
      {'value': 'auto_entrepreneur', 'label': l10n.statusAutoEntrepreneur},
      {'value': 'tpe',               'label': l10n.statusTpe},
      {'value': 'artisan',           'label': l10n.statusArtisan},
      {'value': 'freelance',         'label': l10n.statusFreelance},
      {'value': 'commercant',        'label': l10n.statusCommercant},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          l10n.registerAppBarTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.registerSuccessMessage),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
            context.go('/login');
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message, style: const TextStyle(height: 1.5)),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.registerWelcomeTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.registerWelcomeSubtitle,
                    style: const TextStyle(color: _subtitleColor, fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  Row(children: [
                    Expanded(child: AuthTextField(
                      label: l10n.lastNameLabel,
                      hint: l10n.lastNameHint,
                      controller: _nomCtrl,
                      prefixIcon: Icons.badge_outlined,
                      validator: (v) => v == null || v.isEmpty ? l10n.fieldRequired : null,
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: AuthTextField(
                      label: l10n.firstNameLabel,
                      hint: l10n.firstNameHint,
                      controller: _prenomCtrl,
                      prefixIcon: Icons.badge_outlined,
                      validator: (v) => v == null || v.isEmpty ? l10n.fieldRequired : null,
                    )),
                  ]),

                  AuthTextField(
                    label: l10n.emailLabel,
                    hint: l10n.emailHint,
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail_outline_rounded,
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.fieldRequired;
                      if (!v.contains('@')) return l10n.emailInvalid;
                      return null;
                    },
                  ),

                  AuthTextField(
                    label: l10n.phoneLabel,
                    hint: l10n.phoneHint,
                    controller: _telephoneCtrl,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    validator: (v) => v == null || v.isEmpty ? l10n.fieldRequired : null,
                  ),

                  AuthTextField(
                    label: l10n.iceLabel,
                    hint: l10n.iceHint,
                    controller: _iceCtrl,
                    prefixIcon: Icons.description_outlined,
                  ),

                  Text(
                    l10n.fiscalStatusLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _statutFiscal,
                    hint: Text(
                      l10n.fiscalStatusHint,
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    ),
                    dropdownColor: Colors.white,
                    style: const TextStyle(
                      color: _textColor,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _subtitleColor),
                    items: statuts.map((s) => DropdownMenuItem(
                      value: s['value'],
                      child: Text(s['label']!),
                    )).toList(),
                    onChanged: (v) => setState(() => _statutFiscal = v),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.business_center_outlined, size: 19, color: _subtitleColor),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _primaryColor, width: 1.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  AuthTextField(
                    label: l10n.newPasswordLabel,
                    hint: '••••••••',
                    controller: _passwordCtrl,
                    obscureText: _obscurePass,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 19,
                        color: _subtitleColor,
                      ),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.fieldRequired;
                      if (v.length < 8) return l10n.passwordMinLength;
                      return null;
                    },
                  ),

                  AuthTextField(
                    label: l10n.confirmPasswordLabel,
                    hint: '••••••••',
                    controller: _confirmCtrl,
                    obscureText: _obscureConfirm,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 19,
                        color: _subtitleColor,
                      ),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.fieldRequired;
                      if (v != _passwordCtrl.text) return l10n.passwordsDontMatch;
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading ? null : _onRegister,
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
                        width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4),
                      )
                          : Text(
                        l10n.registerButton,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.alreadyHaveAccount, style: const TextStyle(color: _subtitleColor, fontSize: 13.5)),
                        GestureDetector(
                          onTap: () => context.push('/login'),
                          child: Text(
                            l10n.loginAction,
                            style: const TextStyle(color: _primaryColor, fontWeight: FontWeight.w700, fontSize: 13.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}