import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Formats a user join date as a localized short date string.
String formatMemberSince(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.yMMMd(locale).format(date);
}
