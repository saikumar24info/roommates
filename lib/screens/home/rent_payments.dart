import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/model/user_profile.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/shared_prefs.dart';
import 'package:room_mates/utils/strings.dart';

class RentPaymentsScreen extends StatefulWidget {
  const RentPaymentsScreen({super.key});

  @override
  State<RentPaymentsScreen> createState() => _RentPaymentsScreenState();
}

class _RentPaymentsScreenState extends State<RentPaymentsScreen> {
  UserProfile? _profile;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
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
      setState(() {
        _profile = profile;
        _loading = false;
        if (profile == null) _error = Strings.noData;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
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
          Strings.rentPayments,
          style: TextStyle(
            fontSize: fontSize(context) * 20,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
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
                          onPressed: _load,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _load,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      width(context) * 16,
                      height(context) * 16,
                      width(context) * 16,
                      height(context) * 28,
                    ),
                    children: [
                      _heroCard(),
                      SizedBox(height: height(context) * 16),
                      Text(
                        Strings.paymentOverview,
                        style: TextStyle(
                          fontSize: fontSize(context) * 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.headerText,
                        ),
                      ),
                      SizedBox(height: height(context) * 10),
                      Row(
                        children: [
                          Expanded(
                            child: _statTile(
                              icon: Icons.calendar_month_outlined,
                              label: Strings.dueDate,
                              value: _profile!.paymentDate.isNotEmpty
                                  ? _profile!.paymentDate
                                  : '-',
                            ),
                          ),
                          SizedBox(width: width(context) * 12),
                          Expanded(
                            child: _statTile(
                              icon: Icons.bed_outlined,
                              label: Strings.sharingLabel,
                              value: _profile!.sharingLabel.isNotEmpty
                                  ? _profile!.sharingLabel
                                  : '-',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height(context) * 16),
                      Text(
                        Strings.staySummary,
                        style: TextStyle(
                          fontSize: fontSize(context) * 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.headerText,
                        ),
                      ),
                      SizedBox(height: height(context) * 10),
                      _infoCard([
                        _row(Icons.apartment_outlined, 'Hostel',
                            _profile!.hostelName),
                        _row(Icons.location_on_outlined, Strings.addressLabel,
                            _profile!.hostelAddress),
                        _row(
                          Icons.payments_outlined,
                          Strings.monthlyFee,
                          '₹${_profile!.amount.toStringAsFixed(0)}/-',
                        ),
                      ]),
                      SizedBox(height: height(context) * 16),
                      Container(
                        padding: EdgeInsets.all(width(context) * 16),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: height(context) * 40,
                              width: height(context) * 40,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.info_outline,
                                color: AppColors.primary,
                                size: height(context) * 22,
                              ),
                            ),
                            SizedBox(width: width(context) * 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Strings.payReminder,
                                    style: TextStyle(
                                      fontSize: fontSize(context) * 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: height(context) * 6),
                                  Text(
                                    Strings.rentHint,
                                    style: TextStyle(
                                      fontSize: fontSize(context) * 13,
                                      color: AppColors.bodyText,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _heroCard() {
    return Container(
      padding: EdgeInsets.all(width(context) * 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width(context) * 10,
                  vertical: height(context) * 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  Strings.monthlyRent,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: fontSize(context) * 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.white.withValues(alpha: 0.9),
                size: height(context) * 28,
              ),
            ],
          ),
          SizedBox(height: height(context) * 18),
          Text(
            '₹${_profile!.amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: AppColors.white,
              fontSize: fontSize(context) * 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: height(context) * 6),
          Text(
            'per month · ${_profile!.sharingLabel.isNotEmpty ? _profile!.sharingLabel : 'your plan'}',
            style: TextStyle(
              color: AppColors.mutedOnPrimary,
              fontSize: fontSize(context) * 13,
            ),
          ),
          SizedBox(height: height(context) * 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: width(context) * 14,
              vertical: height(context) * 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.event_outlined,
                  color: AppColors.white,
                  size: height(context) * 20,
                ),
                SizedBox(width: width(context) * 10),
                Expanded(
                  child: Text(
                    '${Strings.dueDate}: ${_profile!.paymentDate.isNotEmpty ? _profile!.paymentDate : '-'}',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: fontSize(context) * 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(width(context) * 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height(context) * 36,
            width: height(context) * 36,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: height(context) * 18),
          ),
          SizedBox(height: height(context) * 12),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize(context) * 12,
              color: AppColors.bodyText,
            ),
          ),
          SizedBox(height: height(context) * 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize(context) * 15,
              fontWeight: FontWeight.w700,
              color: AppColors.headerText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(width(context) * 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: height(context) * 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: height(context) * 20),
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
