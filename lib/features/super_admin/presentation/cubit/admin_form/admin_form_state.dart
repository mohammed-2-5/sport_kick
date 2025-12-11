import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';

/// State for admin creation form.
///
/// Handles form fields, validation, and submission states.
sealed class AdminFormState extends Equatable {
  const AdminFormState();

  @override
  List<Object?> get props => [];
}

/// Initial form state with empty fields.
final class AdminFormInitial extends AdminFormState {
  const AdminFormInitial();
}

/// Form data state containing all field values and validation.
final class AdminFormData extends AdminFormState {
  final String email;
  final String fullName;
  final String phone;
  final String? emailError;
  final String? nameError;
  final String? phoneError;
  final bool isValid;

  const AdminFormData({
    this.email = '',
    this.fullName = '',
    this.phone = '',
    this.emailError,
    this.nameError,
    this.phoneError,
    this.isValid = false,
  });

  AdminFormData copyWith({
    String? email,
    String? fullName,
    String? phone,
    String? emailError,
    String? nameError,
    String? phoneError,
    bool? isValid,
    bool clearEmailError = false,
    bool clearNameError = false,
    bool clearPhoneError = false,
  }) {
    return AdminFormData(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      nameError: clearNameError ? null : (nameError ?? this.nameError),
      phoneError: clearPhoneError ? null : (phoneError ?? this.phoneError),
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [
    email,
    fullName,
    phone,
    emailError,
    nameError,
    phoneError,
    isValid,
  ];
}

/// Form submission in progress.
final class AdminFormSubmitting extends AdminFormState {
  final String email;
  final String fullName;
  final String phone;

  const AdminFormSubmitting({
    required this.email,
    required this.fullName,
    required this.phone,
  });

  @override
  List<Object?> get props => [email, fullName, phone];
}

/// Form submitted successfully.
final class AdminFormSuccess extends AdminFormState {
  final AdminInvitationEntity invitation;

  const AdminFormSuccess(this.invitation);

  String get successMessage =>
      'Admin created successfully!\n\nEmail: ${invitation.email}\nPassword: ${invitation.defaultPassword}';

  @override
  List<Object?> get props => [invitation];
}

/// Form submission failed.
final class AdminFormError extends AdminFormState {
  final String message;
  final String email;
  final String fullName;
  final String phone;

  const AdminFormError({
    required this.message,
    required this.email,
    required this.fullName,
    required this.phone,
  });

  @override
  List<Object?> get props => [message, email, fullName, phone];
}
