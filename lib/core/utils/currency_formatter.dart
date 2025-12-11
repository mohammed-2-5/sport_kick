import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';

/// Currency formatting utility.
///
/// Provides static methods for formatting currency values in consistent formats
/// across the application based on user preferences.
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Currency symbols map.
  static const Map<CurrencyOption, String> _symbols = {
    CurrencyOption.egp: 'E£',
    CurrencyOption.usd: '\$',
    CurrencyOption.eur: '€',
    CurrencyOption.sar: '﷼',
  };

  /// Currency codes map.
  static const Map<CurrencyOption, String> _codes = {
    CurrencyOption.egp: 'EGP',
    CurrencyOption.usd: 'USD',
    CurrencyOption.eur: 'EUR',
    CurrencyOption.sar: 'SAR',
  };

  /// Currency names map.
  static const Map<CurrencyOption, String> _names = {
    CurrencyOption.egp: 'Egyptian Pound',
    CurrencyOption.usd: 'US Dollar',
    CurrencyOption.eur: 'Euro',
    CurrencyOption.sar: 'Saudi Riyal',
  };

  /// Formats amount with currency symbol.
  ///
  /// Example: formatWithSymbol(100.50, CurrencyOption.egp) => "E£100.50"
  static String formatWithSymbol(double amount, CurrencyOption currency) {
    final symbol = _symbols[currency] ?? 'E£';
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Formats amount with currency code.
  ///
  /// Example: formatWithCode(100.50, CurrencyOption.egp) => "100.50 EGP"
  static String formatWithCode(double amount, CurrencyOption currency) {
    final code = _codes[currency] ?? 'EGP';
    return '${amount.toStringAsFixed(2)} $code';
  }

  /// Formats amount as integer with symbol (no decimals).
  ///
  /// Example: formatIntegerWithSymbol(100, CurrencyOption.egp) => "E£100"
  static String formatIntegerWithSymbol(int amount, CurrencyOption currency) {
    final symbol = _symbols[currency] ?? 'E£';
    return '$symbol$amount';
  }

  /// Returns currency symbol.
  static String getSymbol(CurrencyOption currency) {
    return _symbols[currency] ?? 'E£';
  }

  /// Returns currency code.
  static String getCode(CurrencyOption currency) {
    return _codes[currency] ?? 'EGP';
  }

  /// Returns currency name.
  static String getName(CurrencyOption currency) {
    return _names[currency] ?? 'Egyptian Pound';
  }

  /// Returns display label for currency option (code and symbol).
  static String getCurrencyLabel(CurrencyOption currency) {
    final code = _codes[currency] ?? 'EGP';
    final symbol = _symbols[currency] ?? 'E£';
    return '$code ($symbol)';
  }
}
