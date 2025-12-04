/// Domain constants for Super Admin feature
class AdminConstants {
  AdminConstants._();

  // User Roles
  static const String roleSuperAdmin = 'super_admin';
  static const String roleFieldOwner = 'field_owner';
  static const String roleUser = 'user';

  static const List<String> allRoles = [
    roleSuperAdmin,
    roleFieldOwner,
    roleUser,
  ];

  // User Status
  static const String statusActive = 'active';
  static const String statusInactive = 'inactive';
  static const String statusPending = 'pending';
  static const String statusSuspended = 'suspended';

  static const List<String> allStatuses = [
    statusActive,
    statusInactive,
    statusPending,
    statusSuspended,
  ];

  // Field Status
  static const String fieldStatusActive = 'active';
  static const String fieldStatusInactive = 'inactive';
  static const String fieldStatusPending = 'pending_approval';
  static const String fieldStatusRejected = 'rejected';

  // Analytics Periods
  static const String periodToday = 'today';
  static const String periodWeek = 'week';
  static const String periodMonth = 'month';
  static const String periodYear = 'year';
  static const String periodAll = 'all';

  static const List<String> analyticsPeriods = [
    periodToday,
    periodWeek,
    periodMonth,
    periodYear,
    periodAll,
  ];

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Search
  static const int minSearchLength = 2;
  static const Duration searchDebounce = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 500;

  // Default Values
  static const String defaultAvatar = 'assets/images/default_avatar.png';
  static const String defaultFieldImage = 'assets/images/default_field.png';
}
