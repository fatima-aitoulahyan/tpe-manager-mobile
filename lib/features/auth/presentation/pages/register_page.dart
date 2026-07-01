import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey       = GlobalKey<FormState>();
  final _nomCtrl        = TextEditingController();
  final _prenomCtrl     = TextEditingController();
  final _emailCtrl      = TextEditingController();
  final _telephoneCtrl  = TextEditingController();
  final _iceCtrl        = TextEditingController();
  final _passwordCtrl   = TextEditingController();
  final _confirmCtrl    = TextEditingController();
  bool _obscurePass     = true;
  bool _obscureConfirm  = true;
  String? _statutFiscal;
  static const Color _primaryColor  = Color(0xFF2563EB);
  static const Color _textColor     = Color(0xFF0F172A);
  static const Color _subtitleColor = Color(0xFF475569);
  static const Color _borderColor   = Color(0xFFE2E8F0);

  final List<Map<String, String>> _statuts = const [
    {'value': 'auto_entrepreneur', 'label': 'Auto-entrepreneur'},
    {'value': 'tpe',               'label': 'TPE'},
    {'value': 'artisan',           'label': 'Artisan'},
    {'value': 'freelance',         'label': 'Freelance'},
    {'value': 'commercant',        'label': 'Commerçant'},
  ];

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
    if (_formKey.currentState!.validate()) {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Créer un compte',
          style: TextStyle(
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
                content: const Text('Compte créé ! Connectez-vous.'),
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
        },        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bienvenue',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Renseignez vos informations pour démarrer',
                    style: TextStyle(color: _subtitleColor, fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  Row(children: [
                    Expanded(child: AuthTextField(
                      label: 'Nom', hint: 'Benali',
                      controller: _nomCtrl,
                      prefixIcon: Icons.badge_outlined,
                      validator: (v) => v == null || v.isEmpty ? 'Obligatoire' : null,
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: AuthTextField(
                      label: 'Prénom', hint: 'Hassan',
                      controller: _prenomCtrl,
                      prefixIcon: Icons.badge_outlined,
                      validator: (v) => v == null || v.isEmpty ? 'Obligatoire' : null,
                    )),
                  ]),

                  AuthTextField(
                    label: 'Adresse email', hint: 'vous@exemple.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail_outline_rounded,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Obligatoire';
                      if (!v.contains('@')) return 'Email invalide';
                      return null;
                    },
                  ),

                  AuthTextField(
                    label: 'Téléphone', hint: '06 12 34 56 78',
                    controller: _telephoneCtrl,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    validator: (v) => v == null || v.isEmpty ? 'Obligatoire' : null,
                  ),

                  AuthTextField(
                    label: 'ICE (optionnel)', hint: '001234567000',
                    controller: _iceCtrl,
                    prefixIcon: Icons.description_outlined,
                  ),

                  Text(
                    'Statut fiscal',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _statutFiscal,
                    hint: const Text(
                      'Sélectionner un statut',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    ),
                    dropdownColor: Colors.white,
                    style: const TextStyle(
                      color: _textColor,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _subtitleColor),
                    items: _statuts.map((s) => DropdownMenuItem(
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
                    label: 'Mot de passe', hint: '••••••••',
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
                      if (v == null || v.isEmpty) return 'Obligatoire';
                      if (v.length < 8) return 'Minimum 8 caractères';
                      return null;
                    },
                  ),

                  AuthTextField(
                    label: 'Confirmer le mot de passe', hint: '••••••••',
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
                      if (v != _passwordCtrl.text) return 'Les mots de passe ne correspondent pas';
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
                          : const Text(
                        'Créer mon compte',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Déjà un compte ? ", style: TextStyle(color: _subtitleColor, fontSize: 13.5)),
                        GestureDetector(
                          onTap: () => context.push('/login'),
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(color: _primaryColor, fontWeight: FontWeight.w700, fontSize: 13.5),
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