import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/model/hostel.dart';
import 'package:room_mates/screens/admin/assign_admins.dart';
import 'package:room_mates/screens/admin/manage_food_menu.dart';
import 'package:room_mates/screens/admin/manage_hostel_info.dart';
import 'package:room_mates/screens/admin/manage_hostels.dart';
import 'package:room_mates/screens/admin/manage_notifications.dart';
import 'package:room_mates/screens/admin/manage_rent_plans.dart';
import 'package:room_mates/screens/admin/manage_service_requests.dart';
import 'package:room_mates/screens/admin/manage_specifications.dart';
import 'package:room_mates/utils/app_role.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/constants.dart';
import 'package:room_mates/utils/shared_prefs.dart';
import 'package:room_mates/utils/strings.dart';
import 'package:room_mates/widgets/profile_tile.dart';

class AdminHub extends StatefulWidget {
  const AdminHub({super.key});

  @override
  State<AdminHub> createState() => _AdminHubState();
}

class _AdminHubState extends State<AdminHub> {
  AppRole _role = AppRole.resident;
  List<Hostel> _hostels = [];
  String? _selectedHostelId;
  String _selectedHostelName = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    setState(() => _loading = true);
    final role = await AppLocalPrefs.getRole();
    final ownHostelId = await AppLocalPrefs.getHostelId();
    final ownHostelName = await AppLocalPrefs.getHostelName() ?? '';

    List<Hostel> hostels = [];
    String? selectedId = ownHostelId;
    String selectedName = ownHostelName;

    if (role.isSuperAdmin) {
      hostels = await adminService.fetchAllHostels();
      if (hostels.isNotEmpty) {
        final match = hostels.where((h) => h.id == ownHostelId);
        final selected = match.isNotEmpty ? match.first : hostels.first;
        selectedId = selected.id;
        selectedName = selected.name;
      }
    } else if (ownHostelId != null && ownHostelId.isNotEmpty) {
      final hostel = await adminService.fetchHostel(ownHostelId);
      if (hostel != null) {
        hostels = [hostel];
        selectedId = hostel.id;
        selectedName = hostel.name;
      }
    }

    if (!mounted) return;
    setState(() {
      _role = role;
      _hostels = hostels;
      _selectedHostelId = selectedId;
      _selectedHostelName = selectedName;
      _loading = false;
    });
  }

  void _open(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page))
        .then((_) => _bootstrap());
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
          _role.isSuperAdmin ? Strings.superAdminConsole : Strings.adminConsole,
          style: TextStyle(
            fontSize: fontSize(context) * 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ListView(
              padding: EdgeInsets.all(width(context) * 16),
              children: [
                Container(
                  padding: EdgeInsets.all(width(context) * 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
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
                      Text(
                        _role.label,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: fontSize(context) * 14,
                        ),
                      ),
                      SizedBox(height: height(context) * 8),
                      if (_role.isSuperAdmin && _hostels.isNotEmpty)
                        DropdownButtonFormField<String>(
                          // ignore: deprecated_member_use
                          value: _selectedHostelId,
                          decoration: InputDecoration(
                            labelText: Strings.selectHostel,
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: _hostels
                              .map(
                                (h) => DropdownMenuItem(
                                  value: h.id,
                                  child: Text(h.name),
                                ),
                              )
                              .toList(),
                          onChanged: (id) {
                            if (id == null) return;
                            final hostel =
                                _hostels.firstWhere((h) => h.id == id);
                            setState(() {
                              _selectedHostelId = hostel.id;
                              _selectedHostelName = hostel.name;
                            });
                          },
                        )
                      else
                        Text(
                          _selectedHostelName.isEmpty
                              ? 'No hostel assigned'
                              : _selectedHostelName,
                          style: TextStyle(
                            fontSize: fontSize(context) * 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.headerText,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: height(context) * 16),
                if (_selectedHostelId == null || _selectedHostelId!.isEmpty)
                  Text(
                    'Assign a hostel to start managing content.',
                    style: TextStyle(color: AppColors.bodyText),
                  )
                else ...[
                  profileTile(
                    context,
                    Constants.myStay,
                    Strings.manageHostelInfo,
                    () => _open(ManageHostelInfoScreen(
                      hostelId: _selectedHostelId!,
                    )),
                  ),
                  profileTile(
                    context,
                    Constants.foodMenu,
                    Strings.manageFoodMenu,
                    () => _open(ManageFoodMenuScreen(
                      hostelId: _selectedHostelId!,
                      hostelName: _selectedHostelName,
                    )),
                  ),
                  profileTile(
                    context,
                    Constants.specifications,
                    Strings.manageSpecifications,
                    () => _open(ManageSpecificationsScreen(
                      hostelId: _selectedHostelId!,
                    )),
                  ),
                  profileTile(
                    context,
                    Constants.notification,
                    Strings.manageNotifications,
                    () => _open(ManageNotificationsScreen(
                      hostelId: _selectedHostelId!,
                    )),
                  ),
                  profileTile(
                    context,
                    Constants.myStay,
                    Strings.manageRentPlans,
                    () => _open(ManageRentPlansScreen(
                      hostelId: _selectedHostelId!,
                      hostelName: _selectedHostelName,
                    )),
                  ),
                  profileTile(
                    context,
                    Constants.getHelp,
                    Strings.manageServiceRequests,
                    () => _open(ManageServiceRequestsScreen(
                      hostelId: _role.isSuperAdmin ? null : _selectedHostelId,
                      titleHostelName: _selectedHostelName,
                    )),
                  ),
                ],
                if (_role.isSuperAdmin) ...[
                  SizedBox(height: height(context) * 8),
                  Text(
                    Strings.superAdminTools,
                    style: TextStyle(
                      fontSize: fontSize(context) * 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bodyText,
                    ),
                  ),
                  SizedBox(height: height(context) * 8),
                  profileTile(
                    context,
                    Constants.home,
                    Strings.manageHostels,
                    () => _open(const ManageHostelsScreen()),
                  ),
                  profileTile(
                    context,
                    Constants.userProfile,
                    Strings.assignAdmins,
                    () => _open(const AssignAdminsScreen()),
                  ),
                ],
              ],
            ),
    );
  }
}
