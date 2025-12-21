import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:intl/intl.dart';

/// Analytics constants for Owner Revenue Analytics
///
/// Contains all hard-coded values used in analytics page:
/// - Date range options
/// - Chart colors
/// - Dimension values
/// - Labels and strings
class AnalyticsConstants {
  // Prevent instantiation
  AnalyticsConstants._();

  // ==================== DATE RANGE CONSTANTS ====================

  /// Last 7 days option
  static const int last7Days = 7;

  /// Last 30 days option
  static const int last30Days = 30;

  /// Last 90 days option
  static const int last90Days = 90;

  /// Last 365 days (1 year) option
  static const int lastYear = 365;

  /// Default date range selection
  static const int defaultDateRange = last30Days;

  // ==================== CHART DIMENSIONS ====================

  /// Chart height for line charts
  static const double lineChartHeight = 250.0;

  /// Chart height for bar charts
  static const double barChartHeight = 280.0;

  /// Chart height for pie charts
  static const double pieChartHeight = 200.0;

  /// Chart padding
  static const double chartPadding = 16.0;

  /// Chart right padding
  static const double chartRightPadding = 16.0;

  /// Chart top padding
  static const double chartTopPadding = 16.0;

  // ==================== CHART COLORS ====================

  /// Revenue chart line color
  static const Color revenueChartColor = AppColors.success;

  /// Revenue chart area color (with transparency)
  static final Color revenueChartAreaColor = AppColors.success.withValues(
    alpha: 0.2,
  );

  /// Bar chart colors for different fields
  static const List<Color> fieldBarColors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.info,
    AppColors.success,
    AppColors.warning,
    Color(0xFF9C27B0), // Purple
    Color(0xFF00BCD4), // Cyan
    Color(0xFFFF5722), // Deep Orange
  ];

  /// Pie chart colors for booking status
  static const List<Color> statusPieColors = [
    AppColors.bookingConfirmed, // Confirmed - Green
    AppColors.bookingPending, // Pending - Orange
    AppColors.bookingCompleted, // Completed - Grey
    AppColors.bookingCancelled, // Cancelled - Red
  ];

  // ==================== CHART LABELS ====================
  // NOTE: String labels moved to localization (app_en.arb / app_ar.arb)
  // Use context.l10n.revenueTrendsTitle, context.l10n.revenueByFieldTitle, etc.

  // ==================== METRICS LABELS ====================
  // NOTE: Metric labels moved to localization (app_en.arb / app_ar.arb)
  // Use context.l10n.totalRevenueLabel, context.l10n.monthlyRevenueLabel, etc.

  // ==================== DATE RANGE OPTION LABELS ====================
  // NOTE: Date range labels moved to localization (app_en.arb / app_ar.arb)
  // Use context.l10n.last7Days, context.l10n.last30Days, etc.

  // ==================== UI SPACING ====================

  /// Spacing between sections
  static const double sectionSpacing = 24.0;

  /// Spacing between charts
  static const double chartSpacing = 32.0;

  /// Padding around page content
  static const double pageContentPadding = 16.0;

  /// Spacing between metric cards
  static const double metricCardSpacing = 8.0;

  // ==================== CHART CONFIGURATION ====================

  /// Line chart bar width
  static const double lineChartBarWidth = 3.0;

  /// Number of months to show in trends
  static const int monthsToShow = 6;

  /// Font size for chart axis labels
  static const double chartAxisFontSize = 10.0;

  /// Font size for chart titles
  static const double chartTitleFontSize = 16.0;

  /// Maximum number of fields to show in bar chart
  static const int maxFieldsInChart = 8;

  /// Reserved space for left axis titles
  static const double leftAxisReservedSize = 75.0;

  // ==================== EMPTY STATE ====================

  /// Empty state icon size
  static const double emptyStateIconSize = 64.0;

  // NOTE: Empty state message moved to localization
  // Use context.l10n.noDataAvailablePeriod

  // ==================== HELPER METHODS ====================

  /// Get date range value by days
  /// NOTE: For localized labels, use getDateRangeLabelLocalized with BuildContext
  static int getDateRangeValue(int days) {
    switch (days) {
      case last7Days:
        return last7Days;
      case last30Days:
        return last30Days;
      case last90Days:
        return last90Days;
      case lastYear:
        return lastYear;
      default:
        return last30Days;
    }
  }

  /// Get chart color for field by index
  static Color getFieldBarColor(int index) {
    return fieldBarColors[index % fieldBarColors.length];
  }

  /// Get status pie color by index
  static Color getStatusPieColor(int index) {
    return statusPieColors[index % statusPieColors.length];
  }

  /// Localized month abbreviation using current locale.
  static String monthLabel(BuildContext context, int month) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.MMM(locale).format(DateTime(2000, month));
  }
}
