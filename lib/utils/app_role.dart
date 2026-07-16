/// Application roles for hostel management access.
enum AppRole {
  resident,
  admin,
  superAdmin;

  static AppRole fromString(String? value) {
    switch ((value ?? '').toLowerCase()) {
      case 'admin':
        return AppRole.admin;
      case 'super_admin':
      case 'superadmin':
        return AppRole.superAdmin;
      default:
        return AppRole.resident;
    }
  }

  String get dbValue {
    switch (this) {
      case AppRole.resident:
        return 'resident';
      case AppRole.admin:
        return 'admin';
      case AppRole.superAdmin:
        return 'super_admin';
    }
  }

  String get label {
    switch (this) {
      case AppRole.resident:
        return 'Resident';
      case AppRole.admin:
        return 'Admin';
      case AppRole.superAdmin:
        return 'Super Admin';
    }
  }

  bool get canManageHostel =>
      this == AppRole.admin || this == AppRole.superAdmin;

  bool get isSuperAdmin => this == AppRole.superAdmin;
}
