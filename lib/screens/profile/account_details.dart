import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/model/user_profile.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/shared_prefs.dart';
import 'package:room_mates/utils/strings.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _jobTitleCtrl = TextEditingController();

  UserProfile? _profile;
  String? _error;
  bool _loading = true;
  bool _saving = false;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _jobTitleCtrl.dispose();
    super.dispose();
  }

  void _fillControllers(UserProfile profile) {
    _firstNameCtrl.text = profile.firstName;
    _lastNameCtrl.text = profile.lastName;
    _phoneCtrl.text = profile.phone;
    _jobTitleCtrl.text = profile.jobTitle ?? '';
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final userId = await AppLocalPrefs.getUserId();
      if (userId == null || userId.isEmpty) {
        setState(() {
          _loading = false;
          _error = Strings.noData;
        });
        return;
      }
      final profile = await profileService.fetchProfile(userId);
      if (profile != null) {
        await AppLocalPrefs.setProfile(profile);
        _fillControllers(profile);
      }
      setState(() {
        _profile = profile;
        _loading = false;
        _editing = false;
        if (profile == null) _error = Strings.noData;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _profile == null) return;

    setState(() => _saving = true);
    try {
      final updated = await profileService.updateOwnProfile(
        firstName: _firstNameCtrl.text,
        lastName: _lastNameCtrl.text,
        phone: _phoneCtrl.text,
        jobTitle: _jobTitleCtrl.text,
      );
      await AppLocalPrefs.setProfile(updated);
      if (!mounted) return;
      setState(() {
        _profile = updated;
        _editing = false;
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Strings.profileUpdated)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _cancelEdit() {
    if (_profile != null) _fillControllers(_profile!);
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: false,
        leading: IconButton(
          color: AppColors.white,
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, size: height(context) * 26),
        ),
        title: Text(
          Strings.accountDetails,
          style: TextStyle(
            fontSize: fontSize(context) * 20,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        actions: [
          if (_profile != null && !_loading && _error == null)
            TextButton(
              onPressed: _saving
                  ? null
                  : () {
                      if (_editing) {
                        _saveProfile();
                      } else {
                        setState(() => _editing = true);
                      }
                    },
              child: Text(
                _editing ? Strings.save : Strings.edit,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: fontSize(context) * 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(
              child: SpinKitWave(
                color: AppColors.primary,
                type: SpinKitWaveType.start,
              ),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(width(context) * 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: fontSize(context) * 15,
                            color: AppColors.bodyText,
                          ),
                        ),
                        SizedBox(height: height(context) * 16),
                        TextButton(
                          onPressed: _loadProfile,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _loadProfile,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(width(context) * 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _sectionCard(
                            title: Strings.personalInfo,
                            children: [
                              if (_editing) ...[
                                _field(
                                  controller: _firstNameCtrl,
                                  label: Strings.firstNameLabel,
                                  icon: Icons.person_outline,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? 'First name is required'
                                          : null,
                                ),
                                _field(
                                  controller: _lastNameCtrl,
                                  label: Strings.lastNameLabel,
                                  icon: Icons.badge_outlined,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? 'Last name is required'
                                          : null,
                                ),
                                _field(
                                  controller: _phoneCtrl,
                                  label: Strings.phoneLabel,
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  validator: (v) =>
                                      (v == null || v.trim().length < 8)
                                          ? 'Enter a valid phone number'
                                          : null,
                                ),
                                _field(
                                  controller: _jobTitleCtrl,
                                  label: Strings.jobLabel,
                                  icon: Icons.work_outline,
                                ),
                                _infoRow(Icons.email_outlined,
                                    Strings.emailLabel, _profile!.email),
                                SizedBox(height: height(context) * 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: _saving ? null : _cancelEdit,
                                        child: const Text(Strings.cancel),
                                      ),
                                    ),
                                    SizedBox(width: width(context) * 10),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed:
                                            _saving ? null : _saveProfile,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: AppColors.white,
                                        ),
                                        child: _saving
                                            ? SizedBox(
                                                height: height(context) * 18,
                                                width: height(context) * 18,
                                                child:
                                                    const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppColors.white,
                                                ),
                                              )
                                            : const Text(Strings.save),
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                _infoRow(Icons.person_outline, 'Name',
                                    _profile!.fullName),
                                _infoRow(Icons.email_outlined,
                                    Strings.emailLabel, _profile!.email),
                                _infoRow(Icons.phone_outlined,
                                    Strings.phoneLabel, _profile!.phone),
                                _infoRow(
                                  Icons.work_outline,
                                  Strings.jobLabel,
                                  _profile!.jobTitle?.isNotEmpty == true
                                      ? _profile!.jobTitle!
                                      : Strings.resident,
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: height(context) * 14),
                          _sectionCard(
                            title: Strings.stayInfo,
                            children: [
                              _infoRow(Icons.apartment_outlined, 'Hostel',
                                  _profile!.hostelName),
                              _infoRow(Icons.bed_outlined, Strings.sharingLabel,
                                  _profile!.sharingLabel),
                              _infoRow(
                                Icons.payments_outlined,
                                Strings.monthlyFee,
                                '₹${_profile!.amount.toStringAsFixed(0)}/-',
                              ),
                              _infoRow(
                                Icons.calendar_today_outlined,
                                Strings.paymentDateLabel,
                                _profile!.paymentDate,
                              ),
                              _infoRow(
                                Icons.location_on_outlined,
                                Strings.addressLabel,
                                _profile!.hostelAddress,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(width(context) * 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize(context) * 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: height(context) * 12),
          ...children,
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: height(context) * 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(
          fontSize: fontSize(context) * 15,
          fontWeight: FontWeight.w600,
          color: AppColors.headerText,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primary),
          filled: true,
          fillColor: AppColors.primarySoft.withValues(alpha: 0.45),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: height(context) * 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: height(context) * 20, color: AppColors.primary),
          SizedBox(width: width(context) * 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize(context) * 12,
                    color: AppColors.bodyText,
                  ),
                ),
                SizedBox(height: height(context) * 2),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: TextStyle(
                    fontSize: fontSize(context) * 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.headerText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
