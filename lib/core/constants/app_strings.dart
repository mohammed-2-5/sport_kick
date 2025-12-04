/// Application string constants.
///
/// Contains all user-facing strings used throughout the app.
/// Centralized for easy localization and consistency.
///
/// Organization:
/// - Grouped by feature/screen
/// - Use descriptive variable names
/// - Keep strings in English (will be localized later)
class AppStrings {
  // Prevent instantiation
  AppStrings._();

  // ==================== GENERAL ====================

  static const String appName = 'Sport Kick';
  static const String appTagline = 'Book Your Football Field Instantly';
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String save = 'Save';
  static const String submit = 'Submit';
  static const String retry = 'Retry';
  static const String close = 'Close';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String skip = 'Skip';
  static const String done = 'Done';
  static const String loading = 'Loading...';
  static const String pleaseWait = 'Please wait...';
  static const String noData = 'No data available';
  static const String somethingWentWrong = 'Something went wrong';
  static const String tryAgain = 'Try again';

  // ==================== AUTHENTICATION ====================

  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String phone = 'Phone Number';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = 'Don\'t have an account?';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';
  static const String createAccount = 'Create Account';
  static const String welcomeBack = 'Welcome Back!';
  static const String getStarted = 'Get Started';

  // Auth Messages
  static const String loginSuccess = 'Logged in successfully';
  static const String registerSuccess = 'Account created successfully';
  static const String logoutSuccess = 'Logged out successfully';
  static const String invalidCredentials = 'Invalid email or password';
  static const String emailAlreadyExists = 'Email already registered';
  static const String weakPassword = 'Password is too weak';

  // ==================== VALIDATION ====================

  static const String fieldRequired = 'This field is required';
  static const String invalidEmail = 'Invalid email address';
  static const String invalidPhone = 'Invalid phone number';
  static const String passwordTooShort =
      'Password must be at least 8 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String nameTooShort = 'Name must be at least 2 characters';
  static const String invalidInput = 'Invalid input';

  // ==================== FIELDS ====================

  static const String fields = 'Fields';
  static const String fieldDetails = 'Field Details';
  static const String searchFields = 'Search fields...';
  static const String filterFields = 'Filter';
  static const String noFieldsFound = 'No fields found';
  static const String pricePerHour = 'Price per hour';
  static const String location = 'Location';
  static const String facilities = 'Facilities';
  static const String surfaceType = 'Surface Type';
  static const String fieldSize = 'Field Size';
  static const String viewOnMap = 'View on Map';
  static const String bookNow = 'Book Now';
  static const String fieldNotFound = 'Field not found';
  static const String loadingFields = 'Loading fields...';
  static const String refreshFields = 'Refresh';

  // ==================== BOOKINGS ====================

  static const String bookings = 'Bookings';
  static const String myBookings = 'My Bookings';
  static const String createBooking = 'Create Booking';
  static const String bookingDetails = 'Booking Details';
  static const String selectDate = 'Select Date';
  static const String selectTime = 'Select Time';
  static const String availableSlots = 'Available Time Slots';
  static const String noSlotsAvailable = 'No slots available';
  static const String bookingDate = 'Booking Date';
  static const String bookingTime = 'Booking Time';
  static const String totalPrice = 'Total Price';
  static const String bookingStatus = 'Status';
  static const String bookingNotes = 'Notes (Optional)';
  static const String confirmBooking = 'Confirm Booking';
  static const String cancelBooking = 'Cancel Booking';
  static const String noBookingsYet = 'No bookings yet';
  static const String bookingCreated = 'Booking created successfully';
  static const String bookingCancelled = 'Booking cancelled';
  static const String cancelBookingConfirm =
      'Are you sure you want to cancel this booking?';
  static const String cannotCancelBooking = 'Cannot cancel this booking';
  static const String bookingAlreadyCancelled = 'Booking already cancelled';
  static const String slotAlreadyBooked = 'This time slot is already booked';

  // Booking Status
  static const String statusPending = 'Pending';
  static const String statusConfirmed = 'Confirmed';
  static const String statusCancelled = 'Cancelled';
  static const String statusCompleted = 'Completed';

  // ==================== PROFILE ====================

  static const String profile = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String myProfile = 'My Profile';
  static const String updateProfile = 'Update Profile';
  static const String profileUpdated = 'Profile updated successfully';
  static const String changePassword = 'Change Password';
  static const String currentPassword = 'Current Password';
  static const String newPassword = 'New Password';
  static const String passwordChanged = 'Password changed successfully';

  // ==================== REVIEWS & RATINGS ====================

  static const String reviews = 'Reviews';
  static const String rating = 'Rating';
  static const String writeReview = 'Write a Review';
  static const String submitReview = 'Submit Review';
  static const String yourReview = 'Your Review';
  static const String rateField = 'Rate this field';
  static const String noReviews = 'No reviews yet';
  static const String reviewSubmitted = 'Review submitted successfully';
  static const String selectRating = 'Please select a rating';

  // ==================== NAVIGATION ====================

  static const String home = 'Home';
  static const String search = 'Search';
  static const String favorites = 'Favorites';
  static const String settings = 'Settings';

  // ==================== SETTINGS ====================

  static const String notifications = 'Notifications';
  static const String language = 'Language';
  static const String theme = 'Theme';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';
  static const String aboutUs = 'About Us';
  static const String contactUs = 'Contact Us';
  static const String helpSupport = 'Help & Support';
  static const String version = 'Version';

  // ==================== ERRORS ====================

  static const String errorOccurred = 'An error occurred';
  static const String networkError = 'No internet connection';
  static const String serverError = 'Server error. Please try again';
  static const String authError = 'Authentication failed';
  static const String permissionDenied = 'Permission denied';
  static const String notFound = 'Not found';
  static const String timeoutError = 'Request timed out';
  static const String unknownError = 'Unknown error occurred';

  // ==================== SUCCESS MESSAGES ====================

  static const String operationSuccessful = 'Operation completed successfully';
  static const String dataSaved = 'Data saved successfully';
  static const String dataDeleted = 'Data deleted successfully';
  static const String dataUpdated = 'Data updated successfully';

  // ==================== EMPTY STATES ====================

  static const String noResults = 'No results found';
  static const String noNotifications = 'No notifications';
  static const String noFavorites = 'No favorites yet';
  static const String emptyList = 'List is empty';

  // ==================== TIME & DATE ====================

  static const String today = 'Today';
  static const String tomorrow = 'Tomorrow';
  static const String yesterday = 'Yesterday';
  static const String now = 'Now';
  static const String am = 'AM';
  static const String pm = 'PM';

  // Days of week
  static const String sunday = 'Sunday';
  static const String monday = 'Monday';
  static const String tuesday = 'Tuesday';
  static const String wednesday = 'Wednesday';
  static const String thursday = 'Thursday';
  static const String friday = 'Friday';
  static const String saturday = 'Saturday';

  // Months
  static const String january = 'January';
  static const String february = 'February';
  static const String march = 'March';
  static const String april = 'April';
  static const String may = 'May';
  static const String june = 'June';
  static const String july = 'July';
  static const String august = 'August';
  static const String september = 'September';
  static const String october = 'October';
  static const String november = 'November';
  static const String december = 'December';

  // ==================== OWNER DASHBOARD ====================

  static const String dashboard = 'Dashboard';
  static const String todayBookings = 'Today\'s Bookings';
  static const String upcomingBookings = 'Upcoming Bookings';
  static const String manageFields = 'Manage Fields';
  static const String revenue = 'Revenue';
  static const String statistics = 'Statistics';
  static const String confirmBookingTitle = 'Confirm Booking';
  static const String rejectBooking = 'Reject Booking';
  static const String totalBookings = 'Total Bookings';
  static const String totalRevenue = 'Total Revenue';

  // ==================== PAYMENTS ====================

  static const String payment = 'Payment';
  static const String payNow = 'Pay Now';
  static const String paymentMethod = 'Payment Method';
  static const String cardNumber = 'Card Number';
  static const String expiryDate = 'Expiry Date';
  static const String cvv = 'CVV';
  static const String paymentSuccessful = 'Payment successful';
  static const String paymentFailed = 'Payment failed';
  static const String processingPayment = 'Processing payment...';

  // ==================== DIALOGS & ALERTS ====================

  static const String warning = 'Warning';
  static const String info = 'Information';
  static const String success = 'Success';
  static const String error = 'Error';
  static const String areYouSure = 'Are you sure?';
  static const String thisActionCannotBeUndone = 'This action cannot be undone';
  static const String yes = 'Yes';
  static const String no = 'No';

  // ==================== ONBOARDING ====================

  static const String welcome = 'Welcome';
  static const String onboardingTitle1 = 'Find Your Perfect Field';
  static const String onboardingDesc1 =
      'Browse hundreds of football fields near you';
  static const String onboardingTitle2 = 'Book Instantly';
  static const String onboardingDesc2 = 'No more phone calls. Book in seconds';
  static const String onboardingTitle3 = 'Play Football';
  static const String onboardingDesc3 = 'Show up and enjoy your game';

  // ==================== ACCESSIBILITY ====================

  static const String accessibilityMenu = 'Menu';
  static const String accessibilityClose = 'Close';
  static const String accessibilityBack = 'Go back';
  static const String accessibilitySearch = 'Search';
  static const String accessibilityFilter = 'Filter';
  static const String accessibilitySort = 'Sort';
}
