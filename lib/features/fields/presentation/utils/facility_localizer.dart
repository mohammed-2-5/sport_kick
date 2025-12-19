import 'package:flutter/widgets.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Helper to localize common facility/amenity names while keeping unknown
/// values as-is.
class FacilityLocalizer {
  const FacilityLocalizer._();

  static String localize(BuildContext context, String facility) {
    final normalized = facility.trim().toLowerCase();
    final l10n = context.l10n;

    switch (normalized) {
      case 'parking':
        return l10n.parking;
      case 'changing room':
      case 'changing rooms':
      case 'locker room':
        return l10n.changingRooms;
      case 'locker':
      case 'lockers':
        return l10n.lockers;
      case 'shower':
      case 'showers':
        return l10n.showers;
      case 'toilet':
      case 'toilets':
      case 'restrooms':
        return l10n.toilets;
      case 'lighting':
      case 'lights':
        return l10n.lighting;
      case 'seating':
      case 'seats':
        return l10n.seating;
      case 'scoreboard':
        return l10n.scoreboard;
      case 'wifi':
      case 'wi-fi':
        return l10n.wifi;
      case 'cafeteria':
      case 'cafe':
        return l10n.cafeteria;
      case 'refreshments':
      case 'snacks':
        return l10n.refreshments;
      case 'first aid':
        return l10n.firstAid;
      case 'equipment rental':
      case 'rental':
        return l10n.equipmentRental;
      default:
        return facility;
    }
  }
}
