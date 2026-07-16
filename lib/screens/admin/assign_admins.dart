import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/model/hostel.dart';
import 'package:room_mates/model/user_profile.dart';
import 'package:room_mates/utils/app_role.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/strings.dart';

class AssignAdminsScreen extends StatefulWidget {
  const AssignAdminsScreen({super.key});

  @override
  State<AssignAdminsScreen> createState() => _AssignAdminsScreenState();
}

class _AssignAdminsScreenState extends State<AssignAdminsScreen> {
  List<UserProfile> _profiles = [];
  List<Hostel> _hostels = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final profiles = await adminService.fetchProfiles();
    final hostels = await adminService.fetchAllHostels();
    if (!mounted) return;
    setState(() {
      _profiles = profiles;
      _hostels = hostels;
      _loading = false;
    });
  }

  Future<void> _editRole(UserProfile profile) async {
    // App can only assign resident/admin. Super admin is Supabase-only.
    var role = profile.role == AppRole.admin ? AppRole.admin : AppRole.resident;
    var hostelId = profile.hostelId.isNotEmpty
        ? profile.hostelId
        : (_hostels.isNotEmpty ? _hostels.first.id : '');

    final assignableRoles = [AppRole.resident, AppRole.admin];

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModal) => AlertDialog(
          title: Text(profile.fullName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (profile.role.isSuperAdmin)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'This user is a Super Admin. Change that only in Supabase.',
                    style: TextStyle(color: AppColors.bodyText, fontSize: 13),
                  ),
                ),
              DropdownButtonFormField<AppRole>(
                // ignore: deprecated_member_use
                value: role,
                decoration: const InputDecoration(labelText: 'Role'),
                items: assignableRoles
                    .map(
                      (r) => DropdownMenuItem(value: r, child: Text(r.label)),
                    )
                    .toList(),
                onChanged: profile.role.isSuperAdmin
                    ? null
                    : (v) {
                        if (v != null) setModal(() => role = v);
                      },
              ),
              if (role == AppRole.admin && _hostels.isNotEmpty)
                DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: hostelId.isEmpty ? _hostels.first.id : hostelId,
                  decoration: const InputDecoration(labelText: 'Hostel'),
                  items: _hostels
                      .map(
                        (h) =>
                            DropdownMenuItem(value: h.id, child: Text(h.name)),
                      )
                      .toList(),
                  onChanged: profile.role.isSuperAdmin
                      ? null
                      : (v) {
                          if (v != null) setModal(() => hostelId = v);
                        },
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(Strings.cancel),
            ),
            TextButton(
              onPressed: profile.role.isSuperAdmin
                  ? null
                  : () => Navigator.pop(context, true),
              child: const Text(Strings.saveChanges),
            ),
          ],
        ),
      ),
    );

    if (saved != true) return;
    try {
      await adminService.assignAdmin(
        userId: profile.id,
        hostelId: hostelId,
        role: role,
      );
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Strings.savedSuccessfully)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          Strings.assignAdmins,
          style: TextStyle(color: AppColors.white, fontSize: fontSize(context) * 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: EdgeInsets.all(width(context) * 16),
                itemCount: _profiles.length,
                separatorBuilder: (_, __) => SizedBox(height: height(context) * 8),
                itemBuilder: (context, index) {
                  final profile = _profiles[index];
                  return ListTile(
                    tileColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text(profile.fullName),
                    subtitle: Text(
                      '${profile.email}\n${profile.role.label}'
                      '${profile.hostelName.isNotEmpty ? ' · ${profile.hostelName}' : ''}',
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.manage_accounts_outlined),
                      onPressed: () => _editRole(profile),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
