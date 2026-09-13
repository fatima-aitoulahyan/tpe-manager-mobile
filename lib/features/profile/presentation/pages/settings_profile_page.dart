import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/language_selector.dart';
import '../../data/datasources/preferences_remote_datasource.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/models/preferences_model.dart';
import '../../data/models/user_model.dart';
import '../bloc/PreferencesBloc.dart';
import '../bloc/preferences_event.dart';
import '../bloc/preferences_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/avatar_section_widget.dart';
import '../widgets/password_dialog_widget.dart';
import '../../../../l10n/app_localizations.dart';

class SettingsProfilePage extends StatelessWidget {
  const SettingsProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(ProfileRemoteDataSource())..add(LoadProfile()),
        ),
        BlocProvider<PreferencesBloc>(
          create: (_) => PreferencesBloc(PreferencesRemoteDataSource())..add(LoadPreferences()),
        ),
      ],
      child: const _SettingsProfileView(),
    );
  }
}

class _SettingsProfileView extends StatefulWidget {
  const _SettingsProfileView();

  @override
  State<_SettingsProfileView> createState() => _SettingsProfileViewState();
}

class _SettingsProfileViewState extends State<_SettingsProfileView> {
  final _formKey = GlobalKey<FormState>();

  final _nomController        = TextEditingController();
  final _prenomController     = TextEditingController();
  final _emailController      = TextEditingController();
  final _phoneController      = TextEditingController();
  final _iceController        = TextEditingController();

  final _emailConfigController    = TextEditingController();
  final _passwordConfigController = TextEditingController();
  bool _showEmailPassword         = false;
  bool _emailConfigSaving         = false;

  String? _selectedStatut;
  bool _isProfileInitialized = false;

  PreferencesModel? _localPreferences;

  // Design System
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color textColor = Color(0xFF0F172A);
  static const Color subtitleColor = Color(0xFF475569);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _iceController.dispose();
    _emailConfigController.dispose();
    _passwordConfigController.dispose();
    super.dispose();
  }

  void _initProfileFieldsOnce(UserModel user) {
    if (!_isProfileInitialized) {
      _nomController.text    = user.nom;
      _prenomController.text = user.prenom;
      _emailController.text  = user.email;
      _phoneController.text  = user.telephone;
      _iceController.text    = user.ice ?? '';
      _selectedStatut        = user.statutFiscal;
      _isProfileInitialized  = true;
    }
  }

  void _updatePreferences(PreferencesModel Function(PreferencesModel) updater) {
    if (_localPreferences == null) return;
    final newPrefs = updater(_localPreferences!);
    setState(() => _localPreferences = newPrefs);
    context.read<PreferencesBloc>().add(UpdatePreferences(newPrefs));
  }

  Future<void> _saveEmailConfig() async {
    final l10n = AppLocalizations.of(context)!;
    if (_emailConfigController.text.isEmpty || _passwordConfigController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fillAllEmailFieldsError), backgroundColor: Colors.orange),
      );
      return;
    }
    setState(() => _emailConfigSaving = true);
    try {
      await ProfileRemoteDataSource().saveEmailConfig(
        emailAddress: _emailConfigController.text.trim(),
        emailPassword: _passwordConfigController.text.replaceAll(' ', ''),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.emailConfigSavedSuccess), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorPrefix(e.toString())), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _emailConfigSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.profileUpdatedSuccess), backgroundColor: Colors.green),
              );
            }
            if (state is PasswordChangeSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.passwordChangedSuccess), backgroundColor: Colors.green),
              );
            }
            if (state is LogoutSuccess) context.go('/login');
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
        ),
        BlocListener<PreferencesBloc, PreferencesState>(
          listener: (context, state) {
            if (state is PreferencesLoaded) {
              _localPreferences = state.preferences;
            }
          },
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: Text(l10n.settingsTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            bottom: const TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              tabs: [
                Tab(icon: Icon(Icons.person, size: 20, color: Colors.white)),
                Tab(icon: Icon(Icons.notifications_active, size: 20, color: Colors.white)),
              ],
            ),
          ),
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              return BlocBuilder<PreferencesBloc, PreferencesState>(
                builder: (context, prefsState) {

                  if ((profileState is ProfileLoading && !_isProfileInitialized) || prefsState is PreferencesLoading) {
                    return const Center(child: CircularProgressIndicator(color: primaryColor));
                  }

                  final user = (profileState is ProfileLoaded) ? profileState.user : null;
                  if (user != null) _initProfileFieldsOnce(user);

                  final isSavingPrefs = prefsState is PreferencesSaving;

                  return Stack(
                    children: [
                      TabBarView(
                        physics: const BouncingScrollPhysics(),
                        children: [

                          SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (user != null) Center(child: AvatarSectionWidget(user: user)),
                                  const SizedBox(height: 24),
                                  _buildSectionHeader(Icons.person_outline, l10n.editCoordinatesHeader),
                                  const SizedBox(height: 12),
                                  _buildCardContainer([
                                    Row(
                                      children: [
                                        Expanded(child: _buildTextField(l10n.firstNameLabel, _prenomController, Icons.badge_outlined)),
                                        const SizedBox(width: 12),
                                        Expanded(child: _buildTextField(l10n.lastNameLabel, _nomController, Icons.badge_outlined)),
                                      ],
                                    ),
                                    _buildTextField(l10n.emailAddressLabel, _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                                    _buildTextField(l10n.phoneLabel, _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
                                    _buildTextField(l10n.iceLabel, _iceController, Icons.description_outlined, required: false),
                                    DropdownButtonFormField<String>(
                                      value: _selectedStatut,
                                      dropdownColor: Colors.white,
                                      style: const TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w500),
                                      decoration: _inputDecoration(l10n.fiscalStatusLabel, Icons.business_center_outlined),
                                      items: [
                                        DropdownMenuItem(value: 'auto_entrepreneur', child: Text(l10n.statusAutoEntrepreneur)),
                                        DropdownMenuItem(value: 'tpe', child: Text(l10n.statusTpe)),
                                        DropdownMenuItem(value: 'artisan', child: Text(l10n.statusArtisan)),
                                        DropdownMenuItem(value: 'freelance', child: Text(l10n.statusFreelance)),
                                        DropdownMenuItem(value: 'commercant', child: Text(l10n.statusCommercant)),
                                      ],
                                      onChanged: (value) => _selectedStatut = value,
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            final updatedUser = UserModel(
                                              id: user?.id ?? 0,
                                              email: _emailController.text.trim(),
                                              nom: _nomController.text.trim(),
                                              prenom: _prenomController.text.trim(),
                                              telephone: _phoneController.text.trim(),
                                              ice: _iceController.text.isEmpty ? null : _iceController.text.trim(),
                                              statutFiscal: _selectedStatut,
                                            );
                                            context.read<ProfileBloc>().add(UpdateProfile(updatedUser));
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child: Text(l10n.saveProfileButton, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ]),
                                  const SizedBox(height: 24),
                                  _buildSectionHeader(Icons.mail_outline, l10n.smtpConfigHeader),
                                  const SizedBox(height: 12),
                                  _buildCardContainer([
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: const Color(0xFFF0F6FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFD1E4FF))),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.lightbulb_outline, color: primaryColor, size: 18),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              l10n.smtpGoogleInfoHint,
                                              style: const TextStyle(fontSize: 12, color: Color(0xFF1E40AF), height: 1.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(controller: _emailConfigController, keyboardType: TextInputType.emailAddress, decoration: _inputDecoration(l10n.profGmailLabel, Icons.alternate_email)),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: _passwordConfigController,
                                      obscureText: !_showEmailPassword,
                                      decoration: _inputDecoration(l10n.googleAppPasswordLabel, Icons.lock_open_outlined).copyWith(
                                        suffixIcon: IconButton(
                                          icon: Icon(_showEmailPassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF94A3B8)),
                                          onPressed: () => setState(() => _showEmailPassword = !_showEmailPassword),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: OutlinedButton.icon(
                                        onPressed: _emailConfigSaving ? null : _saveEmailConfig,
                                        icon: _emailConfigSaving
                                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor))
                                            : const Icon(Icons.sync_alt, size: 16, color: primaryColor),
                                        label: Text(_emailConfigSaving ? l10n.linkingButton : l10n.linkGmailButton, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
                                        style: OutlinedButton.styleFrom(side: const BorderSide(color: primaryColor, width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                      ),
                                    ),
                                  ]),
                                  const SizedBox(height: 24),
                                  _buildSectionHeader(Icons.language_outlined, l10n.languageLabel),
                                  const SizedBox(height: 12),
                                  _buildCardContainer([
                                    const LanguageSelector(),
                                  ]),
                                  const SizedBox(height: 24),
                                  _buildAccountActionButtons(context, l10n),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),

                          SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_localPreferences != null) ...[
                                  _buildSectionHeader(Icons.alarm_on_outlined, l10n.autoRemindersHeader),
                                  const SizedBox(height: 12),
                                  _buildCardContainer([
                                    _buildSwitchTile(
                                      title: l10n.unpaidInvoiceReminderTitle,
                                      subtitle: l10n.unpaidInvoiceReminderSubtitle,
                                      icon: Icons.receipt_long_outlined,
                                      iconColor: Colors.red,
                                      value: _localPreferences!.rappelFactureImpayee,
                                      onChanged: (v) => _updatePreferences((p) => p.copyWith(rappelFactureImpayee: v)),
                                    ),
                                    if (_localPreferences!.rappelFactureImpayee)
                                      _buildDaysSelector(
                                        label: l10n.reminderAfterLabel,
                                        value: _localPreferences!.rappelFactureJours,
                                        onChanged: (v) => _updatePreferences((p) => p.copyWith(rappelFactureJours: v)),
                                      ),
                                    const Divider(height: 24, color: borderColor),
                                    _buildSwitchTile(
                                      title: l10n.expiringQuoteReminderTitle,
                                      subtitle: l10n.expiringQuoteReminderSubtitle,
                                      icon: Icons.description_outlined,
                                      iconColor: Colors.orange,
                                      value: _localPreferences!.rappelDevisExpirant,
                                      onChanged: (v) => _updatePreferences((p) => p.copyWith(rappelDevisExpirant: v)),
                                    ),
                                    if (_localPreferences!.rappelDevisExpirant)
                                      _buildDaysSelector(
                                        label: l10n.warnBeforeExpirationLabel,
                                        value: _localPreferences!.rappelDevisJoursAvant,
                                        onChanged: (v) => _updatePreferences((p) => p.copyWith(rappelDevisJoursAvant: v)),
                                      ),
                                    const Divider(height: 24, color: borderColor),
                                    _buildSwitchTile(
                                      title: l10n.taxDeclarationReminderTitle,
                                      subtitle: l10n.taxDeclarationReminderSubtitle,
                                      icon: Icons.account_balance_outlined,
                                      iconColor: primaryColor,
                                      value: _localPreferences!.rappelDeclarationFiscale,
                                      onChanged: (v) => _updatePreferences((p) => p.copyWith(rappelDeclarationFiscale: v)),
                                    ),
                                    const Divider(height: 24, color: borderColor),
                                    _buildSwitchTile(
                                      title: l10n.cnssReminderTitle,
                                      subtitle: l10n.cnssReminderSubtitle,
                                      icon: Icons.health_and_safety_outlined,
                                      iconColor: Colors.teal,
                                      value: _localPreferences!.rappelCotisationCnss,
                                      onChanged: (v) => _updatePreferences((p) => p.copyWith(rappelCotisationCnss: v)),
                                    ),
                                    const Divider(height: 24, color: borderColor),
                                    _buildSwitchTile(
                                      title: l10n.creditRequestNotifTitle,
                                      subtitle: l10n.creditRequestNotifSubtitle,
                                      icon: Icons.monetization_on_outlined,
                                      iconColor: Colors.purple,
                                      value: _localPreferences!.notificationDemandeCredit,
                                      onChanged: (v) => _updatePreferences((p) => p.copyWith(notificationDemandeCredit: v)),
                                    ),
                                  ]),
                                  const SizedBox(height: 24),
                                  _buildSectionHeader(Icons.toggle_on_outlined, l10n.receptionModesHeader),
                                  const SizedBox(height: 12),
                                  _buildCardContainer([
                                    _buildSwitchTile(
                                      title: l10n.inAppNotifTitle,
                                      icon: Icons.notifications_outlined,
                                      iconColor: primaryColor,
                                      value: _localPreferences!.canalInApp,
                                      onChanged: (v) => _updatePreferences((p) => p.copyWith(canalInApp: v)),
                                    ),
                                    const Divider(height: 24, color: borderColor),
                                    _buildSwitchTile(
                                      title: l10n.pushNotifTitle,
                                      icon: Icons.phone_iphone_outlined,
                                      iconColor: Colors.green,
                                      value: _localPreferences!.canalPush,
                                      onChanged: (v) => _updatePreferences((p) => p.copyWith(canalPush: v)),
                                    ),
                                    const Divider(height: 24, color: borderColor),
                                    _buildSwitchTile(
                                      title: l10n.smsNotifTitle,
                                      subtitle: l10n.smsNotifSubtitle,
                                      icon: Icons.sms_outlined,
                                      iconColor: Colors.orange,
                                      value: _localPreferences!.canalSms,
                                      onChanged: (v) => _updatePreferences((p) => p.copyWith(canalSms: v)),
                                    ),
                                  ]),
                                ] else ...[
                                  Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(l10n.noPreferencesFound))),
                                ],
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isSavingPrefs)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))], border: Border.all(color: borderColor)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2.5, color: primaryColor)),
                                const SizedBox(width: 10),
                                Text(l10n.savingLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor)),
      ],
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.01), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4))]),
      child: Material(
        type: MaterialType.card,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: borderColor)),
        child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children)),
      ),
    );
  }

  Widget _buildAccountActionButtons(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              final bloc = context.read<ProfileBloc>();
              showDialog(
                context: context,
                builder: (_) => PasswordDialogWidget(
                  onConfirm: (oldPwd, newPwd) => bloc.add(ChangePasswordRequested(oldPassword: oldPwd, newPassword: newPwd)),
                ),
              );
            },
            icon: const Icon(Icons.key_outlined, size: 18, color: textColor),
            label: Text(l10n.securityButton, style: const TextStyle(color: textColor, fontWeight: FontWeight.w500)),
            style: OutlinedButton.styleFrom(fixedSize: const Size.fromHeight(48), side: const BorderSide(color: borderColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => context.read<ProfileBloc>().add(LogoutRequested()),
            icon: const Icon(Icons.logout, size: 18, color: Colors.white),
            label: Text(l10n.logoutButton, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
            style: ElevatedButton.styleFrom(fixedSize: const Size.fromHeight(48), backgroundColor: Colors.red.shade600, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: textColor)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: subtitleColor)),
              ],
            ],
          ),
        ),
        Switch.adaptive(value: value, onChanged: onChanged, activeColor: primaryColor),
      ],
    );
  }

  Widget _buildDaysSelector({required String label, required int value, required Function(int) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 38),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: subtitleColor))),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 14, color: subtitleColor),
                  onPressed: value > 1 ? () => onChanged(value - 1) : null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
                SizedBox(
                  width: 32,
                  child: Text('$value j', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 14, color: subtitleColor),
                  onPressed: value < 30 ? () => onChanged(value + 1) : null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon,
      {bool required = true, TextInputType keyboardType = TextInputType.text}) {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
            decoration: _inputDecoration(label, icon),
            validator: required ? (value) => value == null || value.isEmpty ? l10n.fieldRequiredError : null : null,
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 18),
      labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w400),
      floatingLabelStyle: const TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryColor, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red.shade400, width: 1)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red.shade600, width: 2)),
    );
  }
}