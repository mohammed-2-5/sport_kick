import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

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

  /// Revenue trends chart title
  static const String revenueTrendsTitle = 'Revenue Trends';

  /// Revenue by field chart title
  static const String revenueByFieldTitle = 'Revenue by Field';

  /// Booking status chart title
  static const String bookingStatusTitle = 'Booking Status Breakdown';

  /// Revenue trends subtitle
  static const String revenueTrendsSubtitle = 'Track revenue over time';

  /// Revenue by field subtitle
  static const String revenueByFieldSubtitle = 'Top performing fields';

  /// Booking status subtitle
  static const String bookingStatusSubtitle =
      'Distribution of booking statuses';

  // ==================== METRICS LABELS ====================

  /// Total revenue label
  static const String totalRevenueLabel = 'Total Revenue';

  /// Monthly revenue label
  static const String monthlyRevenueLabel = 'Monthly Revenue';

  /// Average booking value label
  static const String averageBookingLabel = 'Avg. Booking';

  /// Total bookings label
  static const String totalBookingsLabel = 'Total Bookings';

  /// Pending bookings label
  static const String pendingBookingsLabel = 'Pending';

  /// Revenue growth label
  static const String revenueGrowthLabel = 'Growth Rate';

  // ==================== DATE RANGE OPTION LABELS ====================

  /// Last 7 days label
  static const String last7DaysLabel = 'Last 7 Days';

  /// Last 30 days label
  static const String last30DaysLabel = 'Last 30 Days';

  /// Last 90 days label
  static const String last90DaysLabel = 'Last 90 Days';

  /// Last year label
  static const String lastYearLabel = 'Last Year';

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
  static const double leftAxisReservedSize = 60.0;

  // ==================== EMPTY STATE ====================

  /// Empty state message for no data
  static const String noDataMessage = 'No data available for selected period';

  /// Empty state icon size
  static const double emptyStateIconSize = 64.0;

  // ==================== MONTH ABBREVIATIONS ====================

  /// Month abbreviations for chart labels
  static const List<String> monthAbbreviations = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  // ==================== HELPER METHODS ====================

  /// Get date range label by days
  static String getDateRangeLabel(int days) {
    switch (days) {
      case last7Days:
        return last7DaysLabel;
      case last30Days:
        return last30DaysLabel;
      case last90Days:
        return last90DaysLabel;
      case lastYear:
        return lastYearLabel;
      default:
        return last30DaysLabel;
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
}
