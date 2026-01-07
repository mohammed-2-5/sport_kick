import 'package:flutter/material.dart';

/// Model class representing a filter group in the advanced filter bottom sheet.
///
/// A filter group contains a title and a widget that represents the filter controls
/// for that group. Used by [AdvancedFilterBottomSheet] to organize filters
/// into logical sections.
///
/// Example:
/// ```dart
/// FilterGroup(
///   title: 'Date Range',
///   widget: DateRangeFilterWidget(
///     dateRange: selectedRange,
///     onChanged: (range) { ... },
///   ),
/// )
/// ```
class FilterGroup {
  /// Display title for this filter group.
  final String title;

  /// The widget containing filter controls for this group.
  final Widget widget;

  /// Creates a filter group.
  ///
  /// Both [title] and [widget] are required.
  FilterGroup({required this.title, required this.widget});
}
