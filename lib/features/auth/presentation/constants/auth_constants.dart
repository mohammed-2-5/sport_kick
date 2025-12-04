/// Auth constants for authentication pages
///
/// Contains all hard-coded values used in auth pages:
/// - Validation rules
/// - UI dimensions
/// - Labels and messages
class AuthConstants {
  // Prevent instantiation
  AuthConstants._();

  // ==================== VALIDATION CONSTANTS ====================

  /// Minimum password length
  static const int minPasswordLength = 8;

  /// Maximum password length
  static const int maxPasswordLength = 128;

  /// Minimum name length
  static const int minNameLength = 2;

  /// Maximum name length
  static const int maxNameLength = 100;

  /// Email regex pattern
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // ==================== PASSWORD REQUIREMENTS ====================

  /// Requires at least one uppercase letter
  static const bool requireUppercase = true;

  /// Requires at least one lowercase letter
  static const bool requireLowercase = true;

  /// Requires at least one number
  static const bool requireNumber = true;

  /// Requires at least one special character
  static const bool requireSpecialChar = false;

  /// Uppercase regex pattern
  static const String uppercasePattern = r'[A-Z]';

  /// Lowercase regex pattern
  static const String lowercasePattern = r'[a-z]';

  /// Number regex pattern
  static const String numberPattern = r'[0-9]';

  /// Special character regex pattern
  static const String specialCharPattern = r'[!@#$%^&*(),.?":{}|<>]';

  // ==================== VALIDATION MESSAGES ====================

  /// Email is required
  static const String emailRequiredMsg = 'Email is required';

  /// Invalid email format
  static const String emailInvalidMsg = 'Invalid email format';

  /// Password is required
  static const String passwordRequiredMsg = 'Password is required';

  /// Password too short
  static const String passwordTooShortMsg =
      'Password must be at least $minPasswordLength characters';

  /// Password must contain uppercase
  static const String passwordUppercaseMsg =
      'Password must contain at least one uppercase letter';

  /// Password must contain lowercase
  static const String passwordLowercaseMsg =
      'Password must contain at least one lowercase letter';

  /// Password must contain number
  static const String passwordNumberMsg =
      'Password must contain at least one number';

  /// Passwords don't match
  static const String passwordMismatchMsg = 'Passwords do not match';

  /// Name is required
  static const String nameRequiredMsg = 'Full name is required';

  /// Name too short
  static const String nameTooShortMsg =
      'Name must be at least $minNameLength characters';

  /// Current password is required
  static const String currentPasswordRequiredMsg =
      'Current password is required';

  /// New password is required
  static const String newPasswordRequiredMsg = 'New password is required';

  /// Confirm password is required
  static const String confirmPasswordRequiredMsg =
      'Confirm password is required';

  // ==================== UI DIMENSIONS ====================

  /// Logo size
  static const double logoSize = 80.0;

  /// Form padding
  static const double formPadding = 24.0;

  /// Form field spacing
  static const double formFieldSpacing = 16.0;

  /// Button height
  static const double buttonHeight = 50.0;

  /// Border radius
  static const double borderRadius = 12.0;

  /// Top spacing
  static const double topSpacing = 60.0;

  // ==================== LABELS ====================

  /// Login button label
  static const String loginButtonLabel = 'Login';

  /// Register button label
  static const String registerButtonLabel = 'Register';

  /// Forgot password label
  static const String forgotPasswordLabel = 'Forgot Password?';

  /// Don't have account label
  static const String dontHaveAccountLabel = "Don't have an account?";

  /// Already have account label
  static const String alreadyHaveAccountLabel = 'Already have an account?';

  /// Sign up label
  static const String signUpLabel = 'Sign Up';

  /// Login here label
  static const String loginHereLabel = 'Login here';

  /// Email label
  static const String emailLabel = 'Email';

  /// Password label
  static const String passwordLabel = 'Password';

  /// Full name label
  static const String fullNameLabel = 'Full Name';

  /// Current password label
  static const String currentPasswordLabel = 'Current Password';

  /// New password label
  static const String newPasswordLabel = 'New Password';

  /// Confirm password label
  static const String confirmPasswordLabel = 'Confirm Password';

  /// Change password button label
  static const String changePasswordButtonLabel = 'Change Password';

  /// Send reset link label
  static const String sendResetLinkLabel = 'Send Reset Link';

  // ==================== MESSAGES ====================

  /// Loading login message
  static const String loadingLoginMsg = 'Logging in...';

  /// Loading register message
  static const String loadingRegisterMsg = 'Creating account...';

  /// Loading change password message
  static const String loadingChangePasswordMsg = 'Changing password...';

  /// Loading reset password message
  static const String loadingResetPasswordMsg = 'Sending reset link...';

  /// Login success message
  static const String loginSuccessMsg = 'Login successful!';

  /// Register success message
  static const String registerSuccessMsg = 'Account created successfully!';

  /// Change password success message
  static const String changePasswordSuccessMsg =
      'Password changed successfully!';

  /// Reset password success message
  static const String resetPasswordSuccessMsg =
      'Reset link sent to your email!';

  /// First login message
  static const String firstLoginMsg =
      'Welcome! Please change your password to continue.';

  /// Admin access denied message
  static const String adminAccessDeniedMsg =
      'Access Denied: You don\'t have admin privileges.';

  // ==================== ADMIN LOGIN SPECIFIC ====================

  /// Admin login title
  static const String adminLoginTitle = 'Admin Portal';

  /// Admin login subtitle
  static const String adminLoginSubtitle = 'Field Owner & Administrator Access';

  /// User login title
  static const String userLoginTitle = 'Welcome Back';

  /// User login subtitle
  static const String userLoginSubtitle = 'Book your favorite field';

  // ==================== FORGOT PASSWORD ====================

  /// Forgot password title
  static const String forgotPasswordTitle = 'Reset Password';

  /// Forgot password subtitle
  static const String forgotPasswordSubtitle =
      'Enter your email to receive a password reset link';

  /// Back to login label
  static const String backToLoginLabel = 'Back to Login';

  /// Reset email sent title
  static const String resetEmailSentTitle = 'Check Your Email';

  /// Reset email sent message
  static const String resetEmailSentMsg =
      'We\'ve sent a password reset link to your email address. Please check your inbox and follow the instructions.';

  // ==================== CHANGE PASSWORD ====================

  /// Change password title
  static const String changePasswordTitle = 'Change Password';

  /// Change password subtitle
  static const String changePasswordSubtitle =
      'Create a new secure password for your account';

  /// Password requirements title
  static const String passwordRequirementsTitle = 'Password must contain:';

  /// At least 8 characters requirement
  static const String requirement8Chars = 'At least 8 characters';

  /// Uppercase letter requirement
  static const String requirementUppercase = 'One uppercase letter';

  /// Lowercase letter requirement
  static const String requirementLowercase = 'One lowercase letter';

  /// Number requirement
  static const String requirementNumber = 'One number';
}
