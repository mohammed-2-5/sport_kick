/// @deprecated Use context.l10n for localized strings instead.
/// All strings have been moved to lib/l10n/app_en.arb and lib/l10n/app_ar.arb
///
/// Migration guide:
/// - OwnerStrings.manageBookings → context.l10n.manageBookings
/// - OwnerStrings.tabAll → context.l10n.tabAll
/// - OwnerStrings.tabPending → context.l10n.statusPending
/// - OwnerStrings.tabConfirmed → context.l10n.statusConfirmed
/// - OwnerStrings.tabCanceled → context.l10n.statusCancelled
/// - OwnerStrings.noBookingsTitle → context.l10n.noBookingsFound
@Deprecated('Use context.l10n for localized strings')
class OwnerStrings {
  OwnerStrings._();

  @Deprecated('Use context.l10n.manageBookings')
  static const String manageBookings = 'Manage Bookings';

  @Deprecated('Use context.l10n.tabAll')
  static const String tabAll = 'ALL';

  @Deprecated('Use context.l10n.statusPending')
  static const String tabPending = 'PENDING';

  @Deprecated('Use context.l10n.statusConfirmed')
  static const String tabConfirmed = 'CONFIRMED';

  @Deprecated('Use context.l10n.statusCancelled')
  static const String tabCanceled = 'CANCELED';

  @Deprecated('Use context.l10n.noBookingsFound')
  static const String noBookingsTitle = 'No bookings found';
}
