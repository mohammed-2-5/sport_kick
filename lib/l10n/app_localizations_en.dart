// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Sport Kick';

  @override
  String get appTagline => 'Book Your Football Field Instantly';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get submit => 'Submit';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get done => 'Done';

  @override
  String get loading => 'Loading...';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get noData => 'No data available';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmationMessage => 'Are you sure you want to logout?';

  @override
  String get email => 'Email';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get phone => 'Phone Number';

  @override
  String get phoneOptional => 'Phone Number (Optional)';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signIn => 'Sign In';

  @override
  String get createAccount => 'Create Account';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get getStarted => 'Get Started';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get or => 'OR';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get google => 'Google';

  @override
  String get facebook => 'Facebook';

  @override
  String get user => 'User';

  @override
  String get fieldOwner => 'Field Owner';

  @override
  String get loginAsUser => 'Login as User';

  @override
  String get loginAsAdmin => 'Login as Admin';

  @override
  String get adminPortalTitle => 'Admin Portal';

  @override
  String get adminPortalSubtitle => 'Field Owner & Administrator Access';

  @override
  String get adminPortalLoginSubtitle => 'Sign in to access the dashboard';

  @override
  String get notAnAdmin => 'Not an admin?';

  @override
  String get userLogin => 'User Login';

  @override
  String get loggingIn => 'Logging in...';

  @override
  String get currentSession => 'Current';

  @override
  String get loginSuccess => 'Logged in successfully';

  @override
  String get registerSuccess => 'Account created successfully';

  @override
  String get logoutSuccess => 'Logged out successfully';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get emailAlreadyExists => 'Email already registered';

  @override
  String get weakPassword => 'Password is too weak';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get invalidPhone => 'Invalid phone number';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get nameTooShort => 'Name must be at least 2 characters';

  @override
  String get invalidInput => 'Invalid input';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get passwordMinChars => 'Password must be at least 6 characters';

  @override
  String get enterValidEmail => 'Please enter a valid email';

  @override
  String get enterName => 'Please enter your name';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get enterFullName => 'Enter your full name';

  @override
  String get enterPhoneNumber => 'Enter your phone number';

  @override
  String get createPassword => 'Create a password';

  @override
  String get reenterPassword => 'Re-enter your password';

  @override
  String get passwordRequirementText =>
      'Password must be at least 6 characters';

  @override
  String get termsAndPrivacyNote =>
      'By creating an account, you agree to our Terms of Service and Privacy Policy';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordTitle => 'Forgot Password';

  @override
  String get resetPasswordSubtitle =>
      'Enter your email address and we will send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get recoverAccount => 'Recover your account';

  @override
  String get sendingResetLink => 'Sending reset link...';

  @override
  String get resetEmailSentTitle => 'Check Your Email';

  @override
  String get resetEmailSentMessage =>
      'We\'ve sent a password reset link to your email address. Please check your inbox and follow the instructions.';

  @override
  String get resetLinkExpires =>
      'Please check your inbox and use the link to reset your password. The link will expire in 1 hour.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get backToUserLogin => 'Back to User Login';

  @override
  String get checkSpamFolder =>
      'Didn\'t receive the email? Check your spam folder.';

  @override
  String passwordTooLong(Object max) {
    return 'Password must be less than $max characters';
  }

  @override
  String get passwordNeedUppercase =>
      'Password must contain at least one uppercase letter';

  @override
  String get passwordNeedLowercase =>
      'Password must contain at least one lowercase letter';

  @override
  String get passwordNeedNumber => 'Password must contain at least one number';

  @override
  String get passwordNeedSpecial =>
      'Password must contain at least one special character';

  @override
  String get passwordStrength => 'Password strength';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthFair => 'Fair';

  @override
  String get passwordStrengthGood => 'Good';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String nameTooLong(Object max) {
    return 'Name must be less than $max characters';
  }

  @override
  String get nameLettersOnly => 'Name can only contain letters and spaces';

  @override
  String get phoneMustBe11Digits => 'Phone number must be 11 digits';

  @override
  String get phoneDigitsOnly => 'Phone number can only contain digits';

  @override
  String get phoneMustStartWith01 => 'Phone number must start with 01';

  @override
  String get enterValidNumber => 'Please enter a valid number';

  @override
  String numberAtLeast(Object min) {
    return 'Number must be at least $min';
  }

  @override
  String numberAtMost(Object max) {
    return 'Number must be at most $max';
  }

  @override
  String get enterValidInteger => 'Please enter a valid whole number';

  @override
  String minLengthChars(Object length) {
    return 'Must be at least $length characters';
  }

  @override
  String maxLengthChars(Object length) {
    return 'Must be at most $length characters';
  }

  @override
  String exactLengthChars(Object length) {
    return 'Must be exactly $length characters';
  }

  @override
  String get enterValidUrl => 'Please enter a valid URL';

  @override
  String get fields => 'Fields';

  @override
  String get fieldDetails => 'Field Details';

  @override
  String get searchFields => 'Search fields...';

  @override
  String get filterFields => 'Filter';

  @override
  String get noFieldsFound => 'No fields found';

  @override
  String get pricePerHour => 'Price per hour';

  @override
  String get location => 'Location';

  @override
  String get facilities => 'Facilities';

  @override
  String get surfaceType => 'Surface Type';

  @override
  String get fieldSize => 'Field Size';

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get bookNow => 'Book Now';

  @override
  String get fieldNotFound => 'Field not found';

  @override
  String get loadingFields => 'Loading fields...';

  @override
  String get refreshFields => 'Refresh';

  @override
  String get browseFields => 'Browse Fields';

  @override
  String get searchFieldsTitle => 'Search Fields';

  @override
  String get searchByNameCityAddress => 'Search by name, city, or address...';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get filtersApplied => 'Filters applied!';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String activeFiltersCount(Object count) {
    return '$count active';
  }

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get reset => 'Reset';

  @override
  String get amenities => 'Amenities';

  @override
  String get priceRange => 'Price Range';

  @override
  String get perHour => 'per hour';

  @override
  String get sortBy => 'Sort By';

  @override
  String get sortRelevance => 'Relevance';

  @override
  String get sortPriceLowToHigh => 'Price: Low to High';

  @override
  String get sortPriceHighToLow => 'Price: High to Low';

  @override
  String get sortRating => 'Highest Rated';

  @override
  String get sortNewest => 'Newest First';

  @override
  String get sortPopular => 'Most Popular';

  @override
  String noFieldsFoundForQuery(Object query) {
    return 'No fields found for \"$query\"';
  }

  @override
  String get searchTryDifferentKeywords =>
      'Try searching with different keywords';

  @override
  String searchResultsForQuery(num count, Object query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results for \"$query\"',
      one: '$count result for \"$query\"',
    );
    return '$_temp0';
  }

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get clearAll => 'Clear All';

  @override
  String get all => 'All';

  @override
  String get searchForFields => 'Search for fields';

  @override
  String get searchByNameCityAddressDescription =>
      'Find fields by name, city, or address';

  @override
  String get searchTipFieldNameTitle => 'Field Name';

  @override
  String get searchTipFieldNameExample =>
      'e.g., \"Cairo Stadium\", \"Zamalek Arena\"';

  @override
  String get searchTipCityTitle => 'City';

  @override
  String get searchTipCityExample =>
      'e.g., \"Cairo\", \"Alexandria\", \"Giza\"';

  @override
  String get searchTipAddressTitle => 'Address';

  @override
  String get searchTipAddressExample => 'e.g., \"Nasr City\", \"Zamalek\"';

  @override
  String get category => 'Category';

  @override
  String get fieldsMapTitle => 'Fields Map';

  @override
  String get fieldsMapSubtitle => 'Explore nearby football fields';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get favoritesSubtitle => 'Fields you love';

  @override
  String get noFavoritesYet => 'No favorites yet';

  @override
  String get favoritesHint =>
      'Tap the heart icon on any field to save it here for quick access later';

  @override
  String get exploreFields => 'Explore Fields';

  @override
  String favoritesSavedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fields saved',
      one: '$count field saved',
    );
    return '$_temp0';
  }

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get removeFromFavorites => 'Remove from Favorites';

  @override
  String get shareField => 'Share';

  @override
  String shareFieldSubject(Object fieldName) {
    return 'Check out $fieldName on SpoKick';
  }

  @override
  String shareFieldMessage(
    Object address,
    Object city,
    Object description,
    Object fieldName,
    Object price,
    Object rating,
  ) {
    return 'Check out $fieldName!\n\n$description\n📍 $address, $city\n💰 $price\n⭐ $rating\n\nBook now on SpoKick!';
  }

  @override
  String get seeAll => 'See all';

  @override
  String get recentReviews => 'Recent Reviews';

  @override
  String get failedToLoadReviews => 'Failed to load reviews';

  @override
  String reviewsSummary(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '$count review',
    );
    return '$_temp0';
  }

  @override
  String get feature => 'Feature';

  @override
  String get image => 'Image';

  @override
  String get surface => 'Surface';

  @override
  String get city => 'City';

  @override
  String get popularity => 'Popularity';

  @override
  String get noneListed => 'None listed';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get removeFromFavoritesQuestion => 'Remove from favorites?';

  @override
  String removeFromFavoritesBody(Object name) {
    return 'Are you sure you want to remove \"$name\" from your favorites?';
  }

  @override
  String get manageFields => 'Manage Fields';

  @override
  String get manageFieldsSubtitle => 'View and manage all your fields';

  @override
  String get searchFieldsHint => 'Search by name or location...';

  @override
  String get total => 'Total';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get failedToLoadFields => 'Failed to load fields';

  @override
  String get addField => 'Add Field';

  @override
  String get noFieldsMatchSearch => 'No fields match your search';

  @override
  String get noActiveFields => 'No active fields';

  @override
  String get noInactiveFields => 'No inactive fields';

  @override
  String get noFields => 'No fields yet';

  @override
  String get addFirstField => 'Add your first field to get started';

  @override
  String get deleteFieldTitle => 'Delete Field';

  @override
  String deleteFieldMessage(Object fieldName) {
    return 'Are you sure you want to delete \"$fieldName\"? This action cannot be undone.';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Customize your experience';

  @override
  String get accountSection => 'Account';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get businessHours => 'Business Hours';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get emailNotificationsDesc => 'Receive notifications via email';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get pushNotificationsDesc =>
      'Receive push notifications on your device';

  @override
  String get bookingAlerts => 'Booking Alerts';

  @override
  String get bookingAlertsDesc => 'Get notified for new bookings';

  @override
  String get instantNotifications => 'Instant Notifications';

  @override
  String get instantNotificationsDesc => 'Receive notifications immediately';

  @override
  String get bookingPreferencesSection => 'Booking Preferences';

  @override
  String get autoApproveBookings => 'Auto-Approve Bookings';

  @override
  String get autoApproveBookingsDesc => 'Automatically confirm new bookings';

  @override
  String get bookingRules => 'Booking Rules';

  @override
  String get pricingSettings => 'Pricing Settings';

  @override
  String get securitySection => 'Security';

  @override
  String get loginActivity => 'Login Activity';

  @override
  String get activeSessions => 'Active Sessions';

  @override
  String get aboutSection => 'About';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get appVersion => 'App Version';

  @override
  String get configure => 'Configure';

  @override
  String get manage => 'Manage';

  @override
  String get viewHistory => 'View history';

  @override
  String get businessHoursSheetTitle => 'Business Hours';

  @override
  String get businessHoursSheetSubtitle => 'Set your operating hours';

  @override
  String get businessHoursPerField => 'Business Hours per Field';

  @override
  String get businessHoursPerFieldDesc =>
      'Business Hours are set individually for each field. Go to your Fields list and select a field to manage its operating hours.';

  @override
  String get goToMyFields => 'Go to My Fields';

  @override
  String get addFieldTitle => 'Add Field';

  @override
  String get addFieldSubtitle => 'Create a new football field';

  @override
  String get createFieldRestrictedMessage =>
      'Creating new fields is currently restricted to Admins.';

  @override
  String get editFieldTitle => 'Edit Field';

  @override
  String updateFieldTitle(Object fieldName) {
    return 'Update $fieldName';
  }

  @override
  String get updatingFieldMessage => 'Updating field...';

  @override
  String updateFieldDetailsSubtitle(Object fieldName) {
    return 'Update details for $fieldName';
  }

  @override
  String get bookingTableTitle => 'Booking Table';

  @override
  String get initializing => 'Initializing...';

  @override
  String get businessHoursMissingTitle => 'Business hours missing';

  @override
  String businessHoursMissingBody(Object fieldName) {
    return 'Set hours for $fieldName to enable booking slots.';
  }

  @override
  String get setUp => 'Set up';

  @override
  String get failedToLoad => 'Failed to load';

  @override
  String get myLocation => 'My Location';

  @override
  String get mapCenteredOnLocation => 'Centered on your location';

  @override
  String get noFieldsMatchFilters => 'No fields match your filters';

  @override
  String get noFieldsWithLocation => 'No fields with location data available';

  @override
  String get filtered => 'Filtered';

  @override
  String get verifiedFieldsOnly => 'Verified Fields Only';

  @override
  String get verifiedFieldsDescription => 'Show only verified fields';

  @override
  String get sortByDistance => 'Sort by Distance';

  @override
  String get sortByDistanceDescription => 'Show nearest fields first';

  @override
  String get minimumRating => 'Minimum Rating';

  @override
  String get anyOption => 'Any';

  @override
  String get maximumPricePerHour => 'Maximum Price (per hour)';

  @override
  String get surfaceGrass => 'Grass';

  @override
  String get surfaceTurf => 'Turf';

  @override
  String get indoor => 'Indoor';

  @override
  String get outdoor => 'Outdoor';

  @override
  String fieldsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fields',
      one: '$count Field',
    );
    return '$_temp0';
  }

  @override
  String get viewDetails => 'View Details';

  @override
  String get verified => 'Verified';

  @override
  String get newLabel => 'New';

  @override
  String get popular => 'Popular';

  @override
  String get trending => 'Trending';

  @override
  String get noImage => 'No Image';

  @override
  String get parking => 'Parking';

  @override
  String get changingRooms => 'Changing Rooms';

  @override
  String get lockers => 'Lockers';

  @override
  String get showers => 'Showers';

  @override
  String get toilets => 'Toilets';

  @override
  String get lighting => 'Lighting';

  @override
  String get seating => 'Seating';

  @override
  String get scoreboard => 'Scoreboard';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get cafeteria => 'Cafeteria';

  @override
  String get refreshments => 'Refreshments';

  @override
  String get firstAid => 'First Aid';

  @override
  String get equipmentRental => 'Equipment Rental';

  @override
  String get bookings => 'Bookings';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get trackBookingsSubtitle => 'Track your upcoming and past bookings';

  @override
  String get createBooking => 'Create Booking';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectTime => 'Select time';

  @override
  String get availableSlots => 'Available Time Slots';

  @override
  String get noSlotsAvailable => 'No slots available';

  @override
  String get bookingDate => 'Booking Date';

  @override
  String get bookingTime => 'Booking Time';

  @override
  String get dateTimeLabel => 'Date & Time';

  @override
  String get timeSlot => 'Time Slot';

  @override
  String get field => 'Field';

  @override
  String get totalPrice => 'Total Price';

  @override
  String get bookingStatus => 'Status';

  @override
  String get bookingTimeline => 'Booking Timeline';

  @override
  String get bookingNotes => 'Notes (Optional)';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get view => 'View';

  @override
  String emailClientUnavailable(Object email) {
    return 'Could not open email client. Please contact $email';
  }

  @override
  String get emailClientOpenFailed => 'Failed to open email client';

  @override
  String get noBookingsYet => 'No bookings yet';

  @override
  String get chooseAnotherDate => 'Choose Another Date';

  @override
  String get bookingCreated => 'Booking created successfully';

  @override
  String get bookingConfirmedTitle => 'Booking Confirmed!';

  @override
  String get bookingConfirmedDescription =>
      'Your booking has been successfully placed.\nYou will receive a confirmation shortly.';

  @override
  String get bookingCancelled => 'Booking cancelled';

  @override
  String get cancelBookingConfirm =>
      'Are you sure you want to cancel this booking?';

  @override
  String get cannotCancelBooking => 'Cannot cancel this booking';

  @override
  String get bookingAlreadyCancelled => 'Booking already cancelled';

  @override
  String get cancellationReason => 'Cancellation Reason';

  @override
  String get copy => 'Copy';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get bookFieldTitle => 'Book Field';

  @override
  String get chooseTime => 'Choose Time';

  @override
  String get selectDateFirstMessage => 'Please select a date first';

  @override
  String get selectTimeSlotFirstMessage => 'Please select a time slot';

  @override
  String get reviewBooking => 'Review Booking';

  @override
  String get continueLabel => 'Continue';

  @override
  String get selectTimeSlotPrompt => 'Select a Time Slot';

  @override
  String get creatingBooking => 'Creating your booking...';

  @override
  String get pleaseWaitMoment => 'Please wait a moment';

  @override
  String get loadingSubscriptions => 'Loading subscriptions...';

  @override
  String totalWithHours(Object hours) {
    return 'Total (${hours}h)';
  }

  @override
  String get confirmYourBooking => 'Confirm Your Booking';

  @override
  String get reviewBookingDetails =>
      'Please review your booking details before confirming.';

  @override
  String get bookingTermsNotice =>
      'By confirming, you agree to our booking terms and cancellation policy.';

  @override
  String get footballField => 'Football Field';

  @override
  String get durationLabel => 'Duration';

  @override
  String durationHours(num hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours',
      one: '$hours hour',
    );
    return '$_temp0';
  }

  @override
  String get ratePerHour => 'Rate per hour';

  @override
  String get priceBreakdown => 'Price Breakdown';

  @override
  String selectedDateLabel(Object date) {
    return 'Selected: $date';
  }

  @override
  String get change => 'Change';

  @override
  String get bookingDuration => 'Booking Duration';

  @override
  String get durationRecommended => 'Recommended';

  @override
  String get durationBestValue => 'Best Value';

  @override
  String get durationUnavailable => 'Not available for this time slot';

  @override
  String get sendPaymentToNumber => 'Send payment to this number';

  @override
  String get paymentPhone => 'Payment Phone';

  @override
  String get paymentPhoneMissing =>
      'Payment phone not configured. Please contact the field owner.';

  @override
  String get paymentInstructions => 'Payment Instructions';

  @override
  String phoneCopied(Object phone) {
    return 'Phone number copied: $phone';
  }

  @override
  String get paymentProof => 'Payment Proof';

  @override
  String get selectPaymentProof => 'Select Payment Proof';

  @override
  String get choosePaymentUploadMethod =>
      'Choose how to upload your payment screenshot';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get capturePaymentScreenshot => 'Capture payment screenshot';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get selectExistingScreenshot => 'Select existing screenshot';

  @override
  String get uploadPaymentScreenshot => 'Upload Payment Screenshot';

  @override
  String get paymentUploadHint => 'Tap to take a photo or select from gallery';

  @override
  String get upload => 'Upload';

  @override
  String get uploadedLabel => 'Uploaded';

  @override
  String get tapToView => 'Tap to view';

  @override
  String uploadedOn(Object date) {
    return 'Uploaded on $date';
  }

  @override
  String get uploadingPaymentProof => 'Uploading Payment Proof...';

  @override
  String get paymentUploadWait => 'Please wait while we upload your screenshot';

  @override
  String get paymentAwaitingVerification => 'Awaiting Verification';

  @override
  String get paymentRejected => 'Payment Rejected';

  @override
  String get paymentRequired => 'Payment Required';

  @override
  String get paymentStatusLabel => 'Payment Status';

  @override
  String get paymentStatusPending => 'Pending';

  @override
  String get paymentStatusUploaded => 'Awaiting Verification';

  @override
  String get paymentStatusVerified => 'Verified';

  @override
  String get paymentStatusRejected => 'Rejected';

  @override
  String get paymentProofSubmittedMessage =>
      'Your payment proof has been submitted. The field owner will verify it shortly.';

  @override
  String get paymentVerified => 'Payment Verified';

  @override
  String get paymentVerifiedMessage =>
      'Your payment has been verified by the field owner. Enjoy your game!';

  @override
  String verifiedOn(Object date) {
    return 'Verified on $date';
  }

  @override
  String get invoiceTitle => 'Invoice';

  @override
  String get invoiceDetails => 'Invoice Details';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String invoiceCopied(Object number) {
    return 'Invoice number copied: $number';
  }

  @override
  String get viewInvoiceAndPay => 'View Invoice & Pay';

  @override
  String get viewMyBookings => 'View My Bookings';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get noUpcomingBookings => 'No upcoming bookings';

  @override
  String get noBookingHistory => 'No booking history';

  @override
  String get bookingId => 'Booking ID';

  @override
  String get bookingIdCopied => 'Booking ID copied to clipboard';

  @override
  String get availableTimeSlots => 'Available Time Slots';

  @override
  String get allSlotsBookedMessage =>
      'All time slots for this date are booked. Try selecting a different date.';

  @override
  String get morning => 'Morning';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get evening => 'Evening';

  @override
  String get lateNight => 'Late Night';

  @override
  String availableCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count available',
      one: '$count available',
    );
    return '$_temp0';
  }

  @override
  String get bookedLabel => 'Booked';

  @override
  String get cancelReasonOptional => 'Reason (optional)';

  @override
  String get cancelReasonPlaceholder => 'Why are you cancelling?';

  @override
  String get keepBooking => 'Keep Booking';

  @override
  String get noRecurringSubscriptions => 'No recurring subscriptions';

  @override
  String get recurringSlotHint =>
      'Reserve a weekly slot and never miss a game!';

  @override
  String get createSubscription => 'Create Subscription';

  @override
  String get activeStatus => 'Active';

  @override
  String get pendingApproval => 'Pending Approval';

  @override
  String get cancelSubscriptionTitle => 'Cancel Subscription?';

  @override
  String get cancelSubscriptionBody =>
      'Bookings within the next 7 days will still be honored. Only future bookings will be canceled.';

  @override
  String get canceledByUser => 'Canceled by user';

  @override
  String get slotAlreadyBooked => 'This time slot is already booked';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String get historyTab => 'History';

  @override
  String get recurringTab => 'Recurring';

  @override
  String get profile => 'Profile';

  @override
  String get myProfile => 'My Profile';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get passwordChanged => 'Password changed successfully';

  @override
  String get reviews => 'Reviews';

  @override
  String get rating => 'Rating';

  @override
  String get writeReview => 'Write Review';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get yourReview => 'Your Review';

  @override
  String get rateField => 'Rate this field';

  @override
  String get noReviews => 'No reviews yet';

  @override
  String get reviewSubmitted => 'Review submitted successfully';

  @override
  String get selectRating => 'Please select a rating';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get favorites => 'Favorites';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get bookingConfirmations => 'Booking Confirmations';

  @override
  String get bookingReminders => 'Booking Reminders';

  @override
  String get statusUpdates => 'Status Updates';

  @override
  String get fieldOwnerMessages => 'Field Owner Messages';

  @override
  String get bookingConfirmationsDesc =>
      'Get notified when bookings are confirmed';

  @override
  String get bookingRemindersDesc => 'Get reminded 1 hour before your booking';

  @override
  String get statusUpdatesDesc => 'Get notified of booking status changes';

  @override
  String get fieldOwnerMessagesDesc =>
      'Get notified of messages from field owners';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System Default';

  @override
  String get appearance => 'Appearance';

  @override
  String get aboutUs => 'About Us';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get helpSupportDesc => 'Email us your questions';

  @override
  String get version => 'Version';

  @override
  String get dateFormat => 'Date Format';

  @override
  String get currency => 'Currency';

  @override
  String get bookingsSettings => 'Bookings';

  @override
  String get appearanceSettings => 'Appearance';

  @override
  String get notificationsSettings => 'Notifications';

  @override
  String get privacySettings => 'Privacy';

  @override
  String get securitySettings => 'Security';

  @override
  String get accountSettings => 'Account';

  @override
  String get aboutSettings => 'About';

  @override
  String get noPreferencesLoaded => 'No preferences loaded';

  @override
  String get settingsUpdatedSuccess => 'Settings updated successfully';

  @override
  String get weeklySubscriptions => 'Weekly Subscriptions';

  @override
  String get weeklySubscriptionsDesc => 'Manage your recurring bookings';

  @override
  String get bookingsHistory => 'My Bookings';

  @override
  String get bookingsHistoryDesc => 'View your booking history';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesDesc => 'View your favorite fields';

  @override
  String get privacy => 'Privacy';

  @override
  String get showProfilePicture => 'Show Profile Picture';

  @override
  String get showProfilePictureDesc =>
      'Display your profile picture to field owners';

  @override
  String get showPhoneNumber => 'Show Phone Number';

  @override
  String get showPhoneNumberDesc => 'Display your phone number to field owners';

  @override
  String get showEmail => 'Show Email';

  @override
  String get showEmailDesc => 'Display your email to field owners';

  @override
  String get security => 'Security';

  @override
  String get loginActivityDesc => 'View your recent login history';

  @override
  String get activeSessionsDesc => 'Manage your logged-in devices';

  @override
  String get account => 'Account';

  @override
  String get editProfileDesc => 'Update your personal information';

  @override
  String get changePasswordDesc => 'Update your account password';

  @override
  String get passwordRequirementsTitle => 'Password must contain:';

  @override
  String get requirement8Chars => 'At least 8 characters';

  @override
  String get requirementUppercase => 'One uppercase letter';

  @override
  String get requirementLowercase => 'One lowercase letter';

  @override
  String get requirementNumber => 'One number';

  @override
  String get requirementSpecialChar => 'One special character';

  @override
  String get about => 'About';

  @override
  String get couldNotOpenLink => 'Could not open the link';

  @override
  String errorOpeningLink(Object error) {
    return 'Error opening link: $error';
  }

  @override
  String get noLoginActivityTitle => 'No Login Activity';

  @override
  String get noLoginActivitySubtitle => 'Your login history will appear here';

  @override
  String get loginStatusSuccess => 'Success';

  @override
  String get loginStatusFailed => 'Failed';

  @override
  String get loginStatusBlocked => 'Blocked';

  @override
  String get deviceTypeMobile => 'Mobile';

  @override
  String get deviceTypeWeb => 'Web';

  @override
  String get deviceTypeDesktop => 'Desktop';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes min ago';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours hours ago';
  }

  @override
  String daysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String loginDateTimeFormat(Object date, Object time) {
    return '$date • $time';
  }

  @override
  String get adminAccessDenied =>
      'Access Denied: You don\'t have admin privileges. Redirecting to user dashboard.';

  @override
  String get signInSubtitle => 'Sign in to continue';

  @override
  String get welcomeBackHeader => 'Welcome Back';

  @override
  String get loggingInMessage => 'Logging in...';

  @override
  String get joinNow => 'Join Now';

  @override
  String get createYourAccount => 'Create your account';

  @override
  String get creatingAccount => 'Creating account...';

  @override
  String get loginActivityTitle => 'Login Activity';

  @override
  String get loginActivitySubtitle => 'Your recent login history';

  @override
  String get memberSince => 'Member Since';

  @override
  String get roleUser => 'User';

  @override
  String get roleAdmin => 'Field Owner';

  @override
  String get roleSuperAdmin => 'Super Admin';

  @override
  String get firstLoginMessage =>
      'Welcome! Please change your password to continue.';

  @override
  String get pleaseLoginToViewProfile => 'Please login to view your profile';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get networkError => 'No internet connection';

  @override
  String get serverError => 'Server error. Please try again';

  @override
  String get authError => 'Authentication failed';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get notFound => 'Not found';

  @override
  String get timeoutError => 'Request timed out';

  @override
  String get unknownError => 'Unknown error occurred';

  @override
  String get operationSuccessful => 'Operation completed successfully';

  @override
  String get dataSaved => 'Data saved successfully';

  @override
  String get dataDeleted => 'Data deleted successfully';

  @override
  String get dataUpdated => 'Data updated successfully';

  @override
  String get noResults => 'No results found';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get noFavorites => 'No favorites yet';

  @override
  String get emptyList => 'List is empty';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get now => 'Now';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get sunday => 'Sunday';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get todayBookings => 'Today\'s Bookings';

  @override
  String get upcomingBookings => 'Upcoming Bookings';

  @override
  String get revenue => 'Revenue';

  @override
  String get statistics => 'Statistics';

  @override
  String get confirmBookingTitle => 'Confirm Booking';

  @override
  String get rejectBooking => 'Reject Booking';

  @override
  String get totalBookings => 'Total Bookings';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get payment => 'Payment';

  @override
  String get payNow => 'Pay Now';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get cvv => 'CVV';

  @override
  String get paymentSuccessful => 'Payment successful';

  @override
  String get paymentFailed => 'Payment failed';

  @override
  String get processingPayment => 'Processing payment...';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Information';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get welcome => 'Welcome';

  @override
  String get onboardingTitle1 => 'Find Your Perfect Field';

  @override
  String get onboardingDesc1 => 'Browse hundreds of football fields near you';

  @override
  String get onboardingTitle2 => 'Book Instantly';

  @override
  String get onboardingDesc2 => 'No more phone calls. Book in seconds';

  @override
  String get onboardingTitle3 => 'Play Football';

  @override
  String get onboardingDesc3 => 'Show up and enjoy your game';

  @override
  String get accessibilityMenu => 'Menu';

  @override
  String get accessibilityClose => 'Close';

  @override
  String get accessibilityBack => 'Go back';

  @override
  String get accessibilitySearch => 'Search';

  @override
  String get accessibilityFilter => 'Filter';

  @override
  String get accessibilitySort => 'Sort';

  @override
  String get ownerDashboard => 'Owner Dashboard';

  @override
  String get ownerProfile => 'My Profile';

  @override
  String get overview => 'Overview';

  @override
  String get myFields => 'My Fields';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get forWalkInCustomers => 'For walk-in customers';

  @override
  String get manageBookings => 'Manage Bookings';

  @override
  String get analytics => 'Analytics';

  @override
  String get revenueAnalytics => 'Revenue Analytics';

  @override
  String get trackPerformance => 'Track your performance';

  @override
  String get customizeExperience => 'Customize your experience';

  @override
  String get reviewManageBookings => 'Review and manage all bookings';

  @override
  String get viewManageFields => 'View and manage all your fields';

  @override
  String get updateYourInformation => 'Update your information';

  @override
  String get tabAll => 'ALL';

  @override
  String get noBookingsFound => 'No bookings found';

  @override
  String get noFieldsAvailable => 'No fields available';

  @override
  String get addYourFirstField => 'Add Your First Field';

  @override
  String get editField => 'Edit Field';

  @override
  String get deleteField => 'Delete Field';

  @override
  String get createNewField => 'Create a new football field';

  @override
  String updateFieldDetails(Object fieldName) {
    return 'Update details for $fieldName';
  }

  @override
  String get fieldActive => 'Field Active';

  @override
  String get manageBusinessHours => 'Manage Business Hours';

  @override
  String get setWorkingHours => 'Set working hours for each day of the week';

  @override
  String get setOperatingHours => 'Set your operating hours';

  @override
  String get businessHoursMissing => 'Business hours missing';

  @override
  String get bookingTable => 'Booking Table';

  @override
  String get goToToday => 'Go to Today';

  @override
  String get fieldIsClosed => 'Field is closed at this time';

  @override
  String get cannotCreatePastBookings =>
      'Cannot create bookings for past dates';

  @override
  String get selectFieldToSeePrice => 'Select field to see price';

  @override
  String get chooseAField => 'Choose a field';

  @override
  String get createManualBooking => 'Create Manual Booking';

  @override
  String get manualBooking => 'MANUAL';

  @override
  String get bookingSummary => 'Booking Summary';

  @override
  String get customerInformation => 'Customer Information';

  @override
  String get customerName => 'Customer';

  @override
  String get customerNameRequired => 'Customer name is required';

  @override
  String get enterCustomerName => 'Enter customer name';

  @override
  String get enterEmailAddress => 'Enter email address';

  @override
  String get invalidEmailFormat => 'Invalid email format';

  @override
  String get phoneNumberRequired => 'Phone number is required';

  @override
  String get addAnyNotes => 'Add any special notes';

  @override
  String get chooseDate => 'Choose a date';

  @override
  String get addTimeSlot => 'Add Time Slot';

  @override
  String get approveBooking => 'Approve Booking';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get verifyPayment => 'Verify Payment';

  @override
  String get rejectPayment => 'Reject Payment';

  @override
  String get viewPaymentProof => 'View Payment Proof';

  @override
  String get paymentVerifiedSuccess => 'Payment verified successfully';

  @override
  String get paymentRejectedMessage => 'Payment rejected';

  @override
  String get bookingApprovedSuccess => 'Booking approved successfully';

  @override
  String get bookingRejectedMessage => 'Booking rejected';

  @override
  String get revenueTrendsTitle => 'Revenue Trends';

  @override
  String get revenueTrendsSubtitle => 'Track revenue over time';

  @override
  String get revenueByFieldTitle => 'Revenue by Field';

  @override
  String get revenueByFieldSubtitle => 'Top performing fields';

  @override
  String get bookingStatusTitle => 'Booking Status Breakdown';

  @override
  String get bookingStatusSubtitle => 'Distribution of booking statuses';

  @override
  String get totalRevenueLabel => 'Total Revenue';

  @override
  String get monthlyRevenueLabel => 'Monthly Revenue';

  @override
  String get averageBookingLabel => 'Avg. Booking';

  @override
  String get totalBookingsLabel => 'Total Bookings';

  @override
  String get pendingBookingsLabel => 'Pending';

  @override
  String get revenueGrowthLabel => 'Growth Rate';

  @override
  String get topPerformingFields => 'Top Performing Fields';

  @override
  String get thisMonth => 'This Month';

  @override
  String get last7Days => 'Last 7 Days';

  @override
  String get last30Days => 'Last 30 Days';

  @override
  String get last90Days => 'Last 90 Days';

  @override
  String get lastYear => 'Last Year';

  @override
  String get noDataAvailablePeriod => 'No data available for selected period';

  @override
  String get createdBy => 'Created By';

  @override
  String get unknownField => 'Unknown Field';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get createBookingTitle => 'Create Booking';

  @override
  String get createBookingSubtitle => 'Add a manual booking';

  @override
  String get bookingStepDetails => 'Details';

  @override
  String get bookingStepCustomer => 'Customer';

  @override
  String get bookingStepConfirm => 'Confirm';

  @override
  String get fieldLabel => 'Field';

  @override
  String get selectField => 'Select Field';

  @override
  String get priceLabel => 'Price';

  @override
  String get totalPriceLabel => 'Total Price';

  @override
  String get enterPriceHint => 'Enter price';

  @override
  String get customerInfoTitle => 'Customer Information';

  @override
  String get customerNameLabel => 'Customer Name';

  @override
  String get enterCustomerNameHint => 'Enter customer name';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get enterPhoneHint => 'Enter phone number';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get emailOptionalLabel => 'Email (Optional)';

  @override
  String get enterEmailHint => 'Enter email address';

  @override
  String get notesOptionalLabel => 'Notes (Optional)';

  @override
  String get addNotesHint => 'Add any special notes';

  @override
  String get notSelected => 'Not selected';

  @override
  String get notEntered => 'Not entered';

  @override
  String get bookingConfirmationMessage =>
      'Please review the booking details before confirming. This action cannot be undone.';

  @override
  String get loginToViewProfile => 'Please login to view your profile';

  @override
  String get loadingStatistics => 'Loading statistics...';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutMessage => 'Are you sure you want to logout?';
}
