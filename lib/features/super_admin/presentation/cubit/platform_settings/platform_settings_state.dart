import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_settings_entity.dart';

/// Platform Settings State
///
/// Represents the state of platform settings.
sealed class PlatformSettingsState extends Equatable {
  const PlatformSettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded.
class PlatformSettingsInitial extends PlatformSettingsState {
  const PlatformSettingsInitial();
}

/// Loading state while fetching data.
class PlatformSettingsLoading extends PlatformSettingsState {
  const PlatformSettingsLoading();
}

/// State when platform settings are loaded successfully.
class PlatformSettingsLoaded extends PlatformSettingsState {
  final PlatformSettingsEntity settings;
  final bool isSaving;
  final String? successMessage;

  const PlatformSettingsLoaded({
    required this.settings,
    this.isSaving = false,
    this.successMessage,
  });

  @override
  List<Object?> get props => [settings, isSaving, successMessage];

  PlatformSettingsLoaded copyWith({
    PlatformSettingsEntity? settings,
    bool? isSaving,
    String? successMessage,
    bool clearMessage = false,
  }) {
    return PlatformSettingsLoaded(
      settings: settings ?? this.settings,
      isSaving: isSaving ?? this.isSaving,
      successMessage: clearMessage
          ? null
          : successMessage ?? this.successMessage,
    );
  }
}

/// Error state when something goes wrong.
class PlatformSettingsError extends PlatformSettingsState {
  final String message;

  const PlatformSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
