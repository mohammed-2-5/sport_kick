import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/super_admin/domain/entities/day_hours_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_settings_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_platform_settings_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_platform_settings_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/platform_settings/platform_settings_state.dart';

/// Platform Settings Cubit
///
/// Manages platform settings state for the UI.
class PlatformSettingsCubit extends Cubit<PlatformSettingsState> {
  final GetPlatformSettingsUseCase _getPlatformSettings;
  final UpdatePlatformOperatingHoursUseCase _updateOperatingHours;
  final UpdateEnforceOperatingHoursUseCase _updateEnforceHours;

  PlatformSettingsCubit({
    required GetPlatformSettingsUseCase getPlatformSettings,
    required UpdatePlatformOperatingHoursUseCase updateOperatingHours,
    required UpdateEnforceOperatingHoursUseCase updateEnforceHours,
  }) : _getPlatformSettings = getPlatformSettings,
       _updateOperatingHours = updateOperatingHours,
       _updateEnforceHours = updateEnforceHours,
       super(const PlatformSettingsInitial());

  /// Load platform settings.
  Future<void> loadSettings() async {
    emit(const PlatformSettingsLoading());

    final result = await _getPlatformSettings();

    result.fold(
      (failure) => emit(PlatformSettingsError(failure.message)),
      (settings) => emit(PlatformSettingsLoaded(settings: settings)),
    );
  }

  /// Update hours for a specific day.
  Future<void> updateDayHours(DayOfWeek day, DayHoursEntity hours) async {
    final currentState = state;
    if (currentState is! PlatformSettingsLoaded) return;

    final updatedSettings = currentState.settings.updateDayHours(day, hours);
    emit(currentState.copyWith(settings: updatedSettings, isSaving: true));

    final result = await _updateOperatingHours(updatedSettings);

    result.fold(
      (failure) => emit(PlatformSettingsError(failure.message)),
      (_) => emit(
        currentState.copyWith(
          settings: updatedSettings,
          isSaving: false,
          successMessage: 'Hours updated for ${day.displayName}',
        ),
      ),
    );

    // Clear success message after delay
    await Future.delayed(const Duration(seconds: 2));
    if (state is PlatformSettingsLoaded) {
      emit((state as PlatformSettingsLoaded).copyWith(clearMessage: true));
    }
  }

  /// Toggle day open/closed.
  Future<void> toggleDayOpen(DayOfWeek day) async {
    final currentState = state;
    if (currentState is! PlatformSettingsLoaded) return;

    final currentHours = currentState.settings.getHoursForDay(day);
    final updatedHours = currentHours.copyWith(isOpen: !currentHours.isOpen);

    await updateDayHours(day, updatedHours);
  }

  /// Update open time for a day.
  Future<void> updateOpenTime(DayOfWeek day, String time) async {
    final currentState = state;
    if (currentState is! PlatformSettingsLoaded) return;

    final currentHours = currentState.settings.getHoursForDay(day);
    final updatedHours = currentHours.copyWith(openTime: time);

    await updateDayHours(day, updatedHours);
  }

  /// Update close time for a day.
  Future<void> updateCloseTime(DayOfWeek day, String time) async {
    final currentState = state;
    if (currentState is! PlatformSettingsLoaded) return;

    final currentHours = currentState.settings.getHoursForDay(day);
    final updatedHours = currentHours.copyWith(closeTime: time);

    await updateDayHours(day, updatedHours);
  }

  /// Toggle enforce operating hours.
  Future<void> toggleEnforceHours() async {
    final currentState = state;
    if (currentState is! PlatformSettingsLoaded) return;

    final newValue = !currentState.settings.enforceOperatingHours;
    emit(currentState.copyWith(isSaving: true));

    final result = await _updateEnforceHours(newValue);

    result.fold(
      (failure) => emit(PlatformSettingsError(failure.message)),
      (_) => emit(
        currentState.copyWith(
          settings: currentState.settings.copyWith(
            enforceOperatingHours: newValue,
          ),
          isSaving: false,
          successMessage: newValue
              ? 'Operating hours will be enforced'
              : 'Operating hours enforcement disabled',
        ),
      ),
    );

    // Clear success message after delay
    await Future.delayed(const Duration(seconds: 2));
    if (state is PlatformSettingsLoaded) {
      emit((state as PlatformSettingsLoaded).copyWith(clearMessage: true));
    }
  }

  /// Apply same hours to all weekdays.
  Future<void> applyToAllWeekdays(DayHoursEntity hours) async {
    final currentState = state;
    if (currentState is! PlatformSettingsLoaded) return;

    final weekdays = [
      DayOfWeek.monday,
      DayOfWeek.tuesday,
      DayOfWeek.wednesday,
      DayOfWeek.thursday,
      DayOfWeek.friday,
    ];

    var updatedSettings = currentState.settings;
    for (final day in weekdays) {
      updatedSettings = updatedSettings.updateDayHours(day, hours);
    }

    emit(currentState.copyWith(settings: updatedSettings, isSaving: true));

    final result = await _updateOperatingHours(updatedSettings);

    result.fold(
      (failure) => emit(PlatformSettingsError(failure.message)),
      (_) => emit(
        currentState.copyWith(
          settings: updatedSettings,
          isSaving: false,
          successMessage: 'Hours applied to all weekdays',
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (state is PlatformSettingsLoaded) {
      emit((state as PlatformSettingsLoaded).copyWith(clearMessage: true));
    }
  }

  /// Apply same hours to weekend.
  Future<void> applyToWeekend(DayHoursEntity hours) async {
    final currentState = state;
    if (currentState is! PlatformSettingsLoaded) return;

    final weekend = [DayOfWeek.saturday, DayOfWeek.sunday];

    var updatedSettings = currentState.settings;
    for (final day in weekend) {
      updatedSettings = updatedSettings.updateDayHours(day, hours);
    }

    emit(currentState.copyWith(settings: updatedSettings, isSaving: true));

    final result = await _updateOperatingHours(updatedSettings);

    result.fold(
      (failure) => emit(PlatformSettingsError(failure.message)),
      (_) => emit(
        currentState.copyWith(
          settings: updatedSettings,
          isSaving: false,
          successMessage: 'Hours applied to weekend',
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (state is PlatformSettingsLoaded) {
      emit((state as PlatformSettingsLoaded).copyWith(clearMessage: true));
    }
  }
}
