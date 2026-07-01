import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/client_model.dart';
import '../bloc/client_bloc.dart';
import '../bloc/client_event.dart';
import '../bloc/client_state.dart';

class ClientCreatePage extends StatelessWidget {
  final ClientModel? client;

  const ClientCreatePage({super.key, this.client});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientBloc(),
      child: _ClientCreateView(client: client),
    );
  }
}

class _ClientCreateView extends StatefulWidget {
  final ClientModel? client;
  const _ClientCreateView({this.client});

  @override
  State<_ClientCreateView> createState() => _ClientCreateViewState();
}

class _ClientCreateViewState extends State<_ClientCreateView> {
  final _formKey         = GlobalKey<FormState>();
  late final _nomCtrl    = TextEditingController(
      text: widget.client?.nom);
  late final _prenomCtrl = TextEditingController(
      text: widget.client?.prenom);
  late final _entrepriseCtrl = TextEditingController(
      text: widget.client?.nomEntreprise);
  late final _iceCtrl    = TextEditingController(
      text: widget.client?.ice);
  late final _emailCtrl  = TextEditingController(
      text: widget.client?.email);
  late final _telCtrl    = TextEditingController(
      text: widget.client?.telephone);

  bool get _isEditing => widget.client != null;

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'nom':            _nomCtrl.text.trim(),
      'prenom':         _prenomCtrl.text.trim(),
      'nom_entreprise': _entrepriseCtrl.text.trim(),
      'ice':            _iceCtrl.text.trim(),
      'email':          _emailCtrl.text.trim(),
      'telephone':      _telCtrl.text.trim(),
    };

    if (_isEditing) {
      context.read<ClientBloc>().add(UpdateClient(widget.client!.id, data));
    } else {
      context.read<ClientBloc>().add(CreateClient(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier le Client' : 'Nouveau Client',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<ClientBloc, ClientState>(
        listener: (context, state) {
          if (state is ClientCreated) {
            Navigator.pop(context, state.client);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Client créé avec succès !')));
          }
          if (state is ClientUpdated) {
            Navigator.pop(context, state.client);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Client mis à jour !')));
          }
          if (state is ClientError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message),
                    backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor:
                      const Color(0xFF2563EB).withOpacity(0.1),
                      child: Text(
                        '${_nomCtrl.text.isNotEmpty ? _nomCtrl.text[0] : '?'}'
                            '${_prenomCtrl.text.isNotEmpty ? _prenomCtrl.text[0] : ''}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(children: [
                    Expanded(child: _Field(
                      label: 'Nom',
                      hint: 'Benali',
                      controller: _nomCtrl,
                      onChanged: (_) => setState(() {}),
                      validator: (v) => v!.trim().isEmpty ? 'Obligatoire' : null,
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _Field(
                      label: 'Prénom',
                      hint: 'Hassan',
                      controller: _prenomCtrl,
                      onChanged: (_) => setState(() {}),
                    )),
                  ]),

                  _Field(
                    label: 'Nom de l\'entreprise',
                    hint: 'Ma Société (optionnel)',
                    controller: _entrepriseCtrl,
                    icon: Icons.business_outlined,
                  ),

                  _Field(
                    label: 'ICE',
                    hint: '001234567000 (optionnel)',
                    controller: _iceCtrl,
                    icon: Icons.badge_outlined,
                  ),


                  _Field(
                    label: 'Adresse email',
                    hint: 'client@email.com',
                    controller: _emailCtrl,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v!.isNotEmpty && !v.contains('@')) {
                        return 'Adresse email invalide';
                      }
                      return null;
                    },
                  ),

                  _Field(
                    label: 'Téléphone',
                    hint: '0612345678',
                    controller: _telCtrl,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state is ClientLoading
                          ? null
                          : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: state is ClientLoading
                          ? const CircularProgressIndicator(
                          color: Colors.white)
                          : Text(
                        _isEditing ? 'Enregistrer les modifications' : 'Créer le client',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData? icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller:   controller,
          keyboardType: keyboardType,
          validator:    validator,
          onChanged:    onChanged,
          decoration: InputDecoration(
            hintText:   hint,
            prefixIcon: icon != null
                ? Icon(icon, size: 18, color: Colors.grey) : null,
            filled:     true,
            fillColor:  Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}