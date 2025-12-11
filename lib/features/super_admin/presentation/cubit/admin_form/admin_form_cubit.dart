import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_admin_account_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_form/admin_form_state.dart';

/// Cubit for managing admin creation form state.
///
/// Handles:
/// - Field value updates
/// - Real-time validation
/// - Form submission
/// - Success/error states
class AdminFormCubit extends Cubit<AdminFormState> {
  final CreateAdminAccountUseCase _createAdminAccountUseCase;

  AdminFormCubit({required CreateAdminAccountUseCase createAdminAccountUseCase})
    : _createAdminAccountUseCase = createAdminAccountUseCase,
      super(const AdminFormData());

  /// Email regex pattern for validation.
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  /// Phone regex pattern for validation.
  static final _phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');

  /// Update email field and validate.
  void updateEmail(String value) {
    final currentState = state;
    if (currentState is! AdminFormData) return;

    String? error;
    if (value.trim().isEmpty) {
      error = 'Email is required';
    } else if (!_emailRegex.hasMatch(value.trim())) {
      error = 'Please enter a valid email';
    }

    final newState = currentState.copyWith(
      email: value,
      emailError: error,
      clearEmailError: error == null,
      isValid: _validateForm(
        email: value,
        fullName: currentState.fullName,
        phone: currentState.phone,
      ),
    );
    emit(newState);
  }

  /// Update full name field and validate.
  void updateFullName(String value) {
    final currentState = state;
    if (currentState is! AdminFormData) return;

    String? error;
    if (value.trim().isEmpty) {
      error = 'Full name is required';
    } else if (value.trim().length < 3) {
      error = 'Name must be at least 3 characters';
    }

    final newState = currentState.copyWith(
      fullName: value,
      nameError: error,
      clearNameError: error == null,
      isValid: _validateForm(
        email: currentState.email,
        fullName: value,
        phone: currentState.phone,
      ),
    );
    emit(newState);
  }

  /// Update phone field and validate.
  void updatePhone(String value) {
    final currentState = state;
    if (currentState is! AdminFormData) return;

    String? error;
    if (value.trim().isNotEmpty && !_phoneRegex.hasMatch(value.trim())) {
      error = 'Please enter a valid phone number';
    }

    final newState = currentState.copyWith(
      phone: value,
      phoneError: error,
      clearPhoneError: error == null,
      isValid: _validateForm(
        email: currentState.email,
        fullName: currentState.fullName,
        phone: value,
      ),
    );
    emit(newState);
  }

  /// Validate all form fields.
  bool _validateForm({
    required String email,
    required String fullName,
    required String phone,
  }) {
    final emailValid =
        email.trim().isNotEmpty && _emailRegex.hasMatch(email.trim());
    final nameValid = fullName.trim().length >= 3;
    final phoneValid =
        phone.trim().isEmpty || _phoneRegex.hasMatch(phone.trim());

    return emailValid && nameValid && phoneValid;
  }

  /// Submit the form to create admin account.
  Future<void> submit() async {
    final currentState = state;
    if (currentState is! AdminFormData || !currentState.isValid) return;

    emit(
      AdminFormSubmitting(
        email: currentState.email,
        fullName: currentState.fullName,
        phone: currentState.phone,
      ),
    );

    final result = await _createAdminAccountUseCase(
      email: currentState.email.trim(),
      fullName: currentState.fullName.trim(),
      phone: currentState.phone.trim().isEmpty
          ? null
          : currentState.phone.trim(),
    );

    result.fold(
      (failure) => emit(
        AdminFormError(
          message: failure.message,
          email: currentState.email,
          fullName: currentState.fullName,
          phone: currentState.phone,
        ),
      ),
      (invitation) => emit(AdminFormSuccess(invitation)),
    );
  }

  /// Reset form to initial state.
  void reset() {
    emit(const AdminFormData());
  }

  /// Restore form data after error.
  void restoreFromError() {
    final currentState = state;
    if (currentState is AdminFormError) {
      emit(
        AdminFormData(
          email: currentState.email,
          fullName: currentState.fullName,
          phone: currentState.phone,
          isValid: _validateForm(
            email: currentState.email,
            fullName: currentState.fullName,
            phone: currentState.phone,
          ),
        ),
      );
    }
  }
}
