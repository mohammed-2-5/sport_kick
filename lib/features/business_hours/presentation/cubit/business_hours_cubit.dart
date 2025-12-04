import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/get_field_business_hours_usecase.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/initialize_default_business_hours_usecase.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/is_field_currently_open_usecase.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/update_business_hours_usecase.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/validate_booking_time_usecase.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_strings.dart';
import 'package:spo_kick/features/business_hours/presentation/cubit/business_hours_state.dart';

/// Cubit for managing business hours state and operations.
///
/// Orchestrates use cases and manages state transitions for business hours feature.
/// Handles loading, updating, and validating business hours.
class BusinessHoursCubit extends Cubit<BusinessHoursState> {
  final GetFieldBusinessHoursUseCase _getFieldBusinessHoursUseCase;
  final UpdateBusinessHoursUseCase _updateBusinessHoursUseCase;
  final InitializeDefaultBusinessHoursUseCase
  _initializeDefaultBusinessHoursUseCase;
  final ValidateBookingTimeUseCase _validateBookingTimeUseCase;
  final IsFieldCurrentlyOpenUseCase _isFieldCurrentlyOpenUseCase;

  BusinessHoursCubit({
    required GetFieldBusinessHoursUseCase getFieldBusinessHoursUseCase,
    required UpdateBusinessHoursUseCase updateBusinessHoursUseCase,
    required InitializeDefaultBusinessHoursUseCase
    initializeDefaultBusinessHoursUseCase,
    required ValidateBookingTimeUseCase validateBookingTimeUseCase,
    required IsFieldCurrentlyOpenUseCase isFieldCurrentlyOpenUseCase,
  }) : _getFieldBusinessHoursUseCase = getFieldBusinessHoursUseCase,
       _updateBusinessHoursUseCase = updateBusinessHoursUseCase,
       _initializeDefaultBusinessHoursUseCase =
           initializeDefaultBusinessHoursUseCase,
       _validateBookingTimeUseCase = validateBookingTimeUseCase,
       _isFieldCurrentlyOpenUseCase = isFieldCurrentlyOpenUseCase,
       super(const BusinessHoursInitial());

  /// Current field ID being managed
  String? _currentFieldId;

  /// Gets business hours for a specific field.
  ///
  /// Emits [BusinessHoursLoading] while loading.
  /// Emits [BusinessHoursLoaded] on success with business hours data.
  /// Emits [BusinessHoursError] on failure.
  Future<void> getFieldBusinessHours({
    required String fieldId,
    bool checkCurrentStatus = false,
  }) async {
    _currentFieldId = fieldId;
    emit(const BusinessHoursLoading());

    final result = await _getFieldBusinessHoursUseCase(fieldId);

    result.fold(
      (failure) {
        emit(BusinessHoursError(message: failure.message));
      },
      (businessHours) async {
        // Optionally check if field is currently open
        bool? isCurrentlyOpen;
        if (checkCurrentStatus) {
          final statusResult = await _isFieldCurrentlyOpenUseCase(fieldId);
          statusResult.fold(
            (_) => isCurrentlyOpen = null,
            (isOpen) => isCurrentlyOpen = isOpen,
          );
        }

        emit(
          BusinessHoursLoaded(
            businessHours: businessHours,
            isCurrentlyOpen: isCurrentlyOpen,
          ),
        );
      },
    );
  }

  /// Updates business hours for a specific day.
  ///
  /// Emits [BusinessHoursUpdating] while updating.
  /// Emits [BusinessHoursUpdated] on success.
  /// Emits [BusinessHoursError] on failure.
  /// Automatically reloads the full business hours after update.
  Future<void> updateBusinessHours({
    required String fieldId,
    required int dayOfWeek,
    required bool isOpen,
    String? openingTime,
    String? closingTime,
  }) async {
    _currentFieldId = fieldId;

    // Get current hours to show optimistic UI
    final currentState = state;
    if (currentState is BusinessHoursLoaded) {
      emit(BusinessHoursUpdating(currentState.businessHours));
    }

    final params = UpdateBusinessHoursParams(
      fieldId: fieldId,
      dayOfWeek: dayOfWeek,
      isOpen: isOpen,
      openingTime: openingTime,
      closingTime: closingTime,
    );

    final result = await _updateBusinessHoursUseCase(params);

    result.fold(
      (failure) {
        // Restore previous state on error
        if (currentState is BusinessHoursLoaded) {
          emit(
            BusinessHoursError(
              message: failure.message,
              businessHours: currentState.businessHours,
            ),
          );
        } else {
          emit(BusinessHoursError(message: failure.message));
        }
      },
      (updatedHours) {
        // Emit success state with current hours list if available
        final currentBusinessHours = currentState is BusinessHoursLoaded
            ? currentState.businessHours
            : <BusinessHoursEntity>[];

        emit(
          BusinessHoursUpdated(
            businessHours: currentBusinessHours,
            message: BusinessHoursStrings.hoursUpdatedSuccess,
          ),
        );

        // Reload full business hours after brief delay
        Future.delayed(const Duration(milliseconds: 500), () {
          getFieldBusinessHours(fieldId: fieldId);
        });
      },
    );
  }

  /// Updates business hours for multiple days at once.
  ///
  /// Useful for "Apply to All Days" functionality.
  Future<void> updateMultipleDays({
    required String fieldId,
    required List<int> daysOfWeek,
    required bool isOpen,
    String? openingTime,
    String? closingTime,
  }) async {
    _currentFieldId = fieldId;

    // Get current hours to show optimistic UI
    final currentState = state;
    if (currentState is BusinessHoursLoaded) {
      emit(BusinessHoursUpdating(currentState.businessHours));
    }

    // Update each day sequentially
    for (final dayOfWeek in daysOfWeek) {
      final params = UpdateBusinessHoursParams(
        fieldId: fieldId,
        dayOfWeek: dayOfWeek,
        isOpen: isOpen,
        openingTime: openingTime,
        closingTime: closingTime,
      );

      final result = await _updateBusinessHoursUseCase(params);

      // If any update fails, stop and show error
      if (result.isLeft()) {
        result.fold((failure) {
          if (currentState is BusinessHoursLoaded) {
            emit(
              BusinessHoursError(
                message: failure.message,
                businessHours: currentState.businessHours,
              ),
            );
          } else {
            emit(BusinessHoursError(message: failure.message));
          }
        }, (_) {});
        return;
      }
    }

    // All updates successful - reload full business hours
    emit(
      const BusinessHoursUpdated(
        businessHours: [],
        message: BusinessHoursStrings.hoursUpdatedSuccess,
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      getFieldBusinessHours(fieldId: fieldId);
    });
  }

  /// Initializes default business hours (24/7 operation) for a field.
  ///
  /// Typically called when a new field is created.
  /// Emits [BusinessHoursInitializing] while initializing.
  /// Emits [BusinessHoursInitialized] on success.
  /// Emits [BusinessHoursError] on failure.
  Future<void> initializeDefaultBusinessHours(String fieldId) async {
    _currentFieldId = fieldId;
    emit(const BusinessHoursInitializing());

    final result = await _initializeDefaultBusinessHoursUseCase(fieldId);

    result.fold(
      (failure) {
        emit(BusinessHoursError(message: failure.message));
      },
      (_) {
        // Successfully initialized - reload business hours
        getFieldBusinessHours(fieldId: fieldId);
      },
    );
  }

  /// Validates if a booking time is within business hours.
  ///
  /// Returns true if the booking time is valid, false otherwise.
  /// Emits [BusinessHoursValidating] while validating.
  /// Emits [BusinessHoursValidated] with result.
  Future<void> validateBookingTime({
    required String fieldId,
    required DateTime bookingTime,
  }) async {
    emit(const BusinessHoursValidating());

    final params = ValidateBookingTimeParams(
      fieldId: fieldId,
      bookingTime: bookingTime,
    );

    final result = await _validateBookingTimeUseCase(params);

    result.fold(
      (failure) {
        emit(BusinessHoursValidated(isValid: false, message: failure.message));
      },
      (isValid) {
        emit(
          BusinessHoursValidated(
            isValid: isValid,
            message: isValid ? null : 'Time is outside business hours',
          ),
        );
      },
    );
  }

  /// Checks if a field is currently open.
  ///
  /// Does not emit loading states - used for quick status checks.
  /// Updates the current loaded state with open/closed status.
  Future<void> checkCurrentStatus(String fieldId) async {
    final currentState = state;
    if (currentState is! BusinessHoursLoaded) {
      return;
    }

    final result = await _isFieldCurrentlyOpenUseCase(fieldId);

    result.fold(
      (_) {
        // Ignore errors for status checks
      },
      (isOpen) {
        emit(currentState.copyWith(isCurrentlyOpen: isOpen));
      },
    );
  }

  /// Resets to initial state.
  void reset() {
    _currentFieldId = null;
    emit(const BusinessHoursInitial());
  }

  /// Gets the current field ID.
  String? get currentFieldId => _currentFieldId;

  /// Checks if there are unsaved changes.
  bool get hasUnsavedChanges {
    final currentState = state;
    return currentState is BusinessHoursUpdated;
  }
}
