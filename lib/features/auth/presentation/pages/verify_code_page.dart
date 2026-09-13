import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../l10n/app_localizations.dart';

class VerifyCodePage extends StatefulWidget {
  final String email;
  const VerifyCodePage({super.key, required this.email});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  static const Color _primaryColor  = Color(0xFF2563EB);
  static const Color _bgColor       = Color(0xFFF8FAFC);
  static const Color _textColor     = Color(0xFF0F172A);
  static const Color _subtitleColor = Color(0xFF475569);
  static const Color _borderColor   = Color(0xFFE2E8F0);

  String get _code => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (_code.length == 6) {
      _submit();
    }
  }

  void _submit() {
    if (_code.length == 6) {
      context.read<AuthBloc>().add(
          VerifyResetCodeRequested(widget.email, _code));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
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
          if (state is ResetCodeVerified) {
            context.push('/new-password', extra: {
              'email': widget.email,
              'code':  _code,
            });
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
            for (final c in _controllers) c.clear();
            _focusNodes[0].requestFocus();
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
                    child: const Icon(Icons.mark_email_read_outlined,
                        color: _primaryColor, size: 32),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    l10n.verifyCodeTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                          fontSize: 14, color: _subtitleColor, height: 1.4),
                      children: [
                        TextSpan(
                            text: l10n.verifyCodeSubtitle),
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (i) => SizedBox(
                      width: 46,
                      height: 56,
                      child: TextFormField(
                        controller: _controllers[i],
                        focusNode:  _focusNodes[i],
                        textAlign:  TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength:  1,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: _borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: _primaryColor, width: 1.5),
                          ),
                        ),
                        onChanged: (v) => _onChanged(i, v),
                      ),
                    )),
                  ),
                  const SizedBox(height: 24),

                  if (state is AuthLoading)
                    const Center(
                        child: CircularProgressIndicator(
                            color: _primaryColor)),

                  const SizedBox(height: 16),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                            ForgotPasswordRequested(widget.email));
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(l10n.codeResentSuccess)));
                      },
                      child: Text(
                        l10n.resendCodeAction,
                        style: const TextStyle(
                          color: _primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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