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
  String get apply => 'Apply';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get refresh => 'Refresh';

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
  String get enterFullName => 'Enter full name';

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
  String get favoritesEmptySubtitle =>
      'Tap the heart icon on any field to add it to your favorites';

  @override
  String get favoritesEmpty => 'No favorite fields yet';

  @override
  String get beFirstReview => 'Be the first to review this field';

  @override
  String get notAvailable => 'Not Available';

  @override
  String get available => 'Available';

  @override
  String get price => 'Price';

  @override
  String get reviewsTitleFull => 'Reviews & Ratings';

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
  String get open => 'Open';

  @override
  String get closed => 'Closed';

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
  String get autoApproveEnabledTitle => 'Auto-Approve Enabled';

  @override
  String get autoApproveEnabledMessage =>
      'All new booking requests will be automatically approved.';

  @override
  String get autoApproveDisabledTitle => 'Auto-Approve Disabled';

  @override
  String get autoApproveDisabledMessage =>
      'You will need to manually approve each booking request.';

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
  String get businessHoursLoading => 'Loading business hours...';

  @override
  String get businessHoursSetDefaultHours => 'Set Default Hours';

  @override
  String get businessHoursApplyToAllDays => 'Apply to All Days';

  @override
  String get businessHoursApplyToAllDescription =>
      'This will set the same hours for all 7 days of the week.';

  @override
  String get businessHoursHelpText =>
      'Set when your field is available for bookings. You can set different hours for each day of the week.';

  @override
  String get businessHoursHelpTimeSelection =>
      'Select opening and closing times in 15-minute intervals.';

  @override
  String get businessHoursOpeningTime => 'Opening Time';

  @override
  String get businessHoursClosingTime => 'Closing Time';

  @override
  String get businessHoursOpen24Hours => 'Open 24 Hours';

  @override
  String get businessHoursClosedAllDay => 'Closed All Day';

  @override
  String get businessHoursCurrentlyOpen => 'Currently Open';

  @override
  String get businessHoursCurrentlyClosed => 'Currently Closed';

  @override
  String get businessHoursAcceptingBookings =>
      'Your field is currently accepting bookings';

  @override
  String get businessHoursClosedForBookings =>
      'Your field is currently closed for bookings';

  @override
  String get businessHoursUpdatedSuccess =>
      'Business hours updated successfully';

  @override
  String get businessHoursDefaultHoursSet =>
      'Default hours (24/7) set for all days';

  @override
  String get businessHoursInvalidTimeRange =>
      'Opening time must be before closing time';

  @override
  String get businessHoursNoHoursSet => 'No business hours set';

  @override
  String get businessHoursNoHoursSetDescription =>
      'Set your field operating hours to allow users to make bookings.';

  @override
  String get businessHoursTimeOutsideRange => 'Time is outside business hours';

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
  String get viewAll => 'View All';

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
  String get selectTime => 'Select Time';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String hoursLabel(num count, Object countFormatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hours',
      one: 'hour',
    );
    return '$countFormatted $_temp0';
  }

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
  String get bookingStatusTitle => 'Booking Status Breakdown';

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
  String get failedToLoadBookings => 'Failed to load bookings';

  @override
  String get contact => 'Contact';

  @override
  String get noContactInfoAvailable => 'No contact info available';

  @override
  String emailClientUnavailable(Object email) {
    return 'Could not open email client. Please contact $email';
  }

  @override
  String get emailClientOpenFailed => 'Failed to open email client';

  @override
  String get noBookingsYet => 'No bookings yet';

  @override
  String get bookingsWillAppearMessage =>
      'Bookings will appear here once customers start booking your fields';

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
  String get notificationsEmptySubtitle =>
      'You\'ll see booking updates and alerts here';

  @override
  String get notificationJustNow => 'Just now';

  @override
  String notificationMinutesAgo(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String notificationHoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String notificationDaysAgo(Object days) {
    return '${days}d ago';
  }

  @override
  String get markAllRead => 'Mark all read';

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
  String get vsLastMonth => 'vs last month';

  @override
  String bookingsCount(num count, Object countFormatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bookings',
      one: 'booking',
    );
    return '$countFormatted $_temp0';
  }

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
  String get noImagesAvailable => 'No images available';

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
  String get customerNameLabel => 'Customer Name *';

  @override
  String get enterCustomerNameHint => 'Enter customer name';

  @override
  String get phoneLabel => 'Phone Number *';

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

  @override
  String get pleaseLoginToManageBusinessHours =>
      'Please log in to manage business hours';

  @override
  String get youHaveNoFields => 'You have no fields';

  @override
  String get fieldInactive => 'Field Inactive';

  @override
  String get verify => 'Verify';

  @override
  String get description => 'Description';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get changePhoto => 'Change Photo';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get createManualBookingTitle => 'Create Manual Booking';

  @override
  String manualBookingCreatedSuccess(Object customerName) {
    return 'Manual booking created successfully for $customerName';
  }

  @override
  String get manualBookingSelectField => 'Please select a field';

  @override
  String get manualBookingSelectDate => 'Please select a date';

  @override
  String get manualBookingSelectTimeSlot => 'Please select a time slot';

  @override
  String get manualBookingEnterValidPrice => 'Please enter a valid price';

  @override
  String get manualBookingEnterCustomerName => 'Please enter customer name';

  @override
  String get manualBookingEnterCustomerPhone => 'Please enter customer phone';

  @override
  String get bookingDetailsTitle => 'Booking Details';

  @override
  String get bookingDetailsSubtitle => 'Select field, date, time, and price';

  @override
  String get chooseField => 'Choose a field';

  @override
  String endTimeLabel(num hours, Object time) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'hours',
      one: 'hour',
    );
    return 'End time: $time ($hours $_temp0)';
  }

  @override
  String priceCalculation(num hours, Object price) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'hours',
      one: 'hour',
    );
    return '$price EGP/hour × $hours $_temp0';
  }

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get enterFieldName => 'Enter field name';

  @override
  String get fieldNameExample => 'e.g., Premium Soccer Field';

  @override
  String get enterDescription => 'Enter description';

  @override
  String get enterAddress => 'Enter address';

  @override
  String get enterCity => 'Enter city';

  @override
  String get citySelectionTitle => 'Select Your City';

  @override
  String get citySelectionSubtitle =>
      'Choose your city to see available football fields';

  @override
  String get cityChangeCity => 'Change City';

  @override
  String get citySelectCity => 'Select City';

  @override
  String get citySelectPrompt => 'Please select a city';

  @override
  String get cityNoCitiesAvailable => 'No cities available';

  @override
  String get cityErrorLoading => 'Failed to load cities';

  @override
  String get cityLoading => 'Loading cities...';

  @override
  String get citySavingSelection => 'Saving your selection...';

  @override
  String get citySelectedSuccess => 'City selected successfully';

  @override
  String get cityContactSupport => 'Please contact support for assistance';

  @override
  String get citySearchHint => 'Search cities...';

  @override
  String get homeWelcomeBack => 'Welcome back!';

  @override
  String get homeGoodMorning => 'Good Morning,';

  @override
  String get homeGoodAfternoon => 'Good Afternoon,';

  @override
  String get homeGoodEvening => 'Good Evening,';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get homeGuest => 'Guest';

  @override
  String get homeProfileTooltip => 'Profile';

  @override
  String get homeQuickActionsTitle => 'Quick Actions';

  @override
  String get homeComingSoonTitle => 'Coming Soon';

  @override
  String get homeMyProfileTitle => 'My Profile';

  @override
  String get homeMyProfileSubtitle => 'View & edit';

  @override
  String get homeBrowseFieldsTitle => 'Browse Fields';

  @override
  String get homeBrowseFieldsSubtitle => 'Find fields';

  @override
  String get homeMyBookingsTitle => 'My Bookings';

  @override
  String get homeMyBookingsSubtitle => 'View & manage';

  @override
  String get homeFavoritesTitle => 'Favorites';

  @override
  String get homeFavoritesSubtitle => 'Coming soon';

  @override
  String get homeFavoritesComingSoonMessage => 'Favorites feature coming soon!';

  @override
  String get homeExploreTitle => 'Explore Fields';

  @override
  String get homeViewAll => 'View All';

  @override
  String get homeNoFieldsAvailable => 'No fields available';

  @override
  String get homeNearbyFieldsTitle => 'Nearby Fields';

  @override
  String get homeViewMap => 'View Map';

  @override
  String get homeNoFieldsNearby => 'No fields nearby';

  @override
  String get homeTapToViewOnMap => 'Tap to view on map';

  @override
  String get homeShortcutBrowseTitle => 'Browse\nFields';

  @override
  String get homeShortcutBrowseSubtitle => 'Find venues';

  @override
  String get homeShortcutBookingsTitle => 'My\nBookings';

  @override
  String get homeShortcutBookingsSubtitle => 'View history';

  @override
  String get homeShortcutFavoritesTitle => 'Favorite\nFields';

  @override
  String get homeShortcutFavoritesSubtitle => 'Your picks';

  @override
  String get homeShortcutProfileTitle => 'Profile';

  @override
  String get homeShortcutProfileSubtitle => 'Settings';

  @override
  String get homeUpcomingMatch => 'Upcoming Match';

  @override
  String get homeDirections => 'Directions';

  @override
  String get homeInvite => 'Invite';

  @override
  String get homeAddToCalendar => 'Add to Calendar';

  @override
  String get homeNoUpcomingMatches => 'No upcoming matches';

  @override
  String get homeErrorLoadingBookings => 'Error loading bookings';

  @override
  String get homeBookNextGame => 'Book your next game now!';

  @override
  String get homeErrorOpenMaps => 'Could not open maps';

  @override
  String get homeErrorAddCalendar => 'Could not add to calendar';

  @override
  String homeCalendarTitle(Object fieldName) {
    return 'Football at $fieldName';
  }

  @override
  String get homeCalendarDetails => 'Booked via Sport Kick';

  @override
  String homeBookingShareTitle(Object fieldName) {
    return 'Football at $fieldName';
  }

  @override
  String get homeBookingShareDescription => 'Booked via Sport Kick';

  @override
  String get homeNavHome => 'Home';

  @override
  String get homeNavExplore => 'Explore';

  @override
  String get homeNavBookings => 'Bookings';

  @override
  String get homeNavSettings => 'Settings';

  @override
  String get sportFootball => 'Football';

  @override
  String get sportTennis => 'Tennis';

  @override
  String get sportBasketball => 'Basketball';

  @override
  String get sportPadel => 'Padel';

  @override
  String get sportVolleyball => 'Volleyball';

  @override
  String get homeFeaturePayments => 'Secure online payments';

  @override
  String get ownerWelcomeBack => 'Welcome Back!';

  @override
  String get ownerManageFieldsTagline => 'Manage your football fields';

  @override
  String get ownerNoFieldsYet => 'No Fields Yet';

  @override
  String get ownerStartByAddingField =>
      'Start by adding your first football field';

  @override
  String get ownerAddFirstField => 'Add Your First Field';

  @override
  String get ownerEditProfile => 'Edit Profile';

  @override
  String get ownerVerifyPayment => 'Verify Payment';

  @override
  String get ownerVerifyPaymentMessage =>
      'Are you sure you want to verify this payment? This will confirm that the customer has paid for the booking.';

  @override
  String get ownerRejectPayment => 'Reject Payment';

  @override
  String get ownerRejectPaymentMessage =>
      'Please provide a reason for rejecting this payment. The customer will be notified.';

  @override
  String get ownerRejectReasonHint =>
      'Enter rejection reason (min 10 characters)';

  @override
  String ownerRejectCounter(Object count) {
    return '$count/10 characters minimum';
  }

  @override
  String get fieldOwnerRole => 'Field Owner';

  @override
  String bookingShortId(Object id) {
    return 'Booking #$id';
  }

  @override
  String get paymentProofLoadFailed => 'Failed to load image';

  @override
  String get paymentProofTryLater => 'Please try again later';

  @override
  String get ownerApproveBookingConfirm =>
      'Are you sure you want to approve this booking?';

  @override
  String get ownerRejectBookingConfirm =>
      'Are you sure you want to reject this booking?';

  @override
  String get rejectedByOwner => 'Rejected by owner';

  @override
  String get workingSchedule => 'Working schedule';

  @override
  String get closedSlotMessage => 'Field is closed at this time';

  @override
  String get pastSlotMessage => 'Cannot create bookings for past dates';

  @override
  String get paymentRejectedSuccess => 'Payment rejected';

  @override
  String get bookingRejectedSuccess => 'Booking rejected';

  @override
  String get walkInCustomer => 'Walk-in Customer';

  @override
  String get nameLabel => 'Name';

  @override
  String get admin => 'Admin';

  @override
  String get paymentInformation => 'Payment Information';

  @override
  String get paymentStatusPendingTitle => 'Awaiting Payment';

  @override
  String get paymentStatusPendingDesc =>
      'Customer has not yet uploaded payment proof';

  @override
  String get paymentProofUploadedTitle => 'Payment Proof Uploaded';

  @override
  String get paymentProofUploadedDesc =>
      'Review the payment proof and verify or reject';

  @override
  String get paymentVerifiedTitle => 'Payment Verified';

  @override
  String get paymentVerifiedDesc => 'Payment has been confirmed';

  @override
  String get paymentRejectedTitle => 'Payment Rejected';

  @override
  String get paymentRejectedDesc => 'Payment was rejected, awaiting new proof';

  @override
  String get rejectionReason => 'Rejection Reason';

  @override
  String copyValueMessage(Object value) {
    return 'Copied: $value';
  }

  @override
  String get enterPrice => 'Enter price';

  @override
  String get updateField => 'Update Field';

  @override
  String get saveField => 'Save Field';

  @override
  String get setWorkingHoursDesc =>
      'Set working hours for each day of the week';

  @override
  String get surfaceHybrid => 'Hybrid';

  @override
  String get fieldType => 'Field Type';

  @override
  String thousandsAbbreviation(Object value) {
    return '${value}K';
  }

  @override
  String millionsAbbreviation(Object value) {
    return '${value}M';
  }

  @override
  String get currencyEgp => 'EGP';

  @override
  String get recentBookings => 'Recent Bookings';

  @override
  String get unknownCustomer => 'Unknown Customer';

  @override
  String get fieldVisibleToCustomers => 'Field is visible to customers';

  @override
  String get fieldHiddenFromCustomers => 'Field is hidden from customers';

  @override
  String get enterCustomerDetails =>
      'Enter customer details for walk-in booking';

  @override
  String get customerNameTooShort => 'Name must be at least 2 characters';

  @override
  String get phoneHint => '01XXXXXXXXX';

  @override
  String get invalidEgyPhone => 'Invalid Egyptian phone number';

  @override
  String get emailLabel => 'Email (Optional)';

  @override
  String get emailHint => 'customer@example.com';

  @override
  String get notesLabel => 'Notes (Optional)';

  @override
  String get notesHint => 'Any special requests or notes...';

  @override
  String get selectDay => 'Select Day';

  @override
  String get selectDaySubtitle =>
      'Choose the day you want to reserve every week';

  @override
  String availableSlotsForDay(Object day) {
    return 'Available time slots for $day';
  }

  @override
  String get selectDayFirst => 'Select a day first';

  @override
  String fieldClosedOnDay(Object day) {
    return 'Field is closed on $day';
  }

  @override
  String get selectDifferentDay => 'Please select a different day';

  @override
  String get noAvailableSlots => 'No available slots';

  @override
  String reservedBy(Object name) {
    return 'Reserved by $name';
  }

  @override
  String get reservedByAnotherUser => 'another user';

  @override
  String get recurringDurationTitle => 'Duration';

  @override
  String get recurringDurationSubtitle =>
      'How long do you want to play each week?';

  @override
  String recurringHoursLabel(num hours, Object hoursFormatted) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hoursFormatted hours',
      many: '$hoursFormatted hours',
      few: '$hoursFormatted hours',
      two: '$hoursFormatted hours',
      one: '$hoursFormatted hour',
    );
    return '$_temp0';
  }

  @override
  String recurringHoursShort(Object hoursFormatted) {
    return '${hoursFormatted}h';
  }

  @override
  String get perWeek => 'per week';

  @override
  String get weekly => 'Weekly';

  @override
  String get weeklyReservationSummaryTitle => 'Your Weekly Reservation';

  @override
  String get dayLabel => 'Day';

  @override
  String get weeklyCostLabel => 'Weekly Cost';

  @override
  String get weeklyPriceLabel => 'Weekly Price';

  @override
  String get weeklyLabel => 'Weekly';

  @override
  String get everyLabel => 'Every';

  @override
  String get reserveWeeklySlot => 'Reserve Weekly Slot';

  @override
  String get recurringRequestSubmittedTitle => 'Request Submitted!';

  @override
  String get recurringRequestSubmittedBody =>
      'Your recurring booking request has been sent to the field owner. You\'ll be notified once it\'s approved.';

  @override
  String get viewMySubscriptions => 'View My Subscriptions';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get submittingRequest => 'Submitting Request...';

  @override
  String get submittingRequestDescription =>
      'Please wait while we process your request';

  @override
  String everyDay(Object day) {
    return 'Every $day';
  }

  @override
  String get completedSessionsLabel => 'Completed Sessions';

  @override
  String get nextBooking => 'Next Booking';

  @override
  String get paidLabel => 'Paid';

  @override
  String get cancelingSubscription => 'Canceling...';

  @override
  String get cancelSubscriptionQuestion =>
      'Are you sure you want to cancel this recurring booking?';

  @override
  String get pendingApprovalMessage =>
      'Waiting for owner approval. You\'ll be notified once approved.';

  @override
  String get requestRejected => 'Request Rejected';

  @override
  String get activeSubscription => 'Active Subscription';

  @override
  String remainingBookings(Object count) {
    return '$count left';
  }

  @override
  String get unknownUser => 'Unknown User';

  @override
  String get sinceLabel => 'Since';

  @override
  String get weeklyLabelShort => 'Weekly';

  @override
  String get generatingBooking => 'Generating...';

  @override
  String completedCount(Object count) {
    return '$count completed';
  }

  @override
  String get mySubscriptions => 'My Subscriptions';

  @override
  String get newSubscription => 'New Subscription';

  @override
  String get subscriptionCanceled => 'Subscription canceled successfully';

  @override
  String get subscriptionCancelFailed => 'Failed to cancel subscription';

  @override
  String get activeSubscriptions => 'Active Subscriptions';

  @override
  String get pending => 'Pending';

  @override
  String get history => 'History';

  @override
  String get weeklyReservations => 'Weekly Reservations';

  @override
  String recurringSummaryCounts(Object active, Object pending) {
    return '$active active • $pending pending';
  }

  @override
  String get noSubscriptionsYet => 'No Subscriptions Yet';

  @override
  String get noSubscriptionsSubtitle =>
      'Reserve your favorite weekly slot and never miss a game!';

  @override
  String get guaranteedWeeklySlot => 'Guaranteed weekly slot';

  @override
  String get autoRenewsWeekly => 'Auto-renews every week';

  @override
  String get paymentReminders => 'Payment reminders';

  @override
  String get statusActive => 'Active';

  @override
  String get statusPendingApproval => 'Pending Approval';

  @override
  String get statusCanceled => 'Canceled';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get newRecurringRequest => 'New Recurring Request';

  @override
  String get processingRequest => 'Processing...';

  @override
  String get pendingRequests => 'Pending Requests';

  @override
  String get totalLabel => 'Total';

  @override
  String get completedLabel => 'Completed';

  @override
  String get upcomingLabel => 'Upcoming';

  @override
  String progressCompleted(Object percent) {
    return '$percent% completed';
  }

  @override
  String get scheduleTitle => 'Schedule';

  @override
  String get recurringRequestsEmptySubtitle =>
      'When users request weekly recurring bookings, they\'ll appear here for your approval.';

  @override
  String get keepSubscription => 'Keep Subscription';

  @override
  String get cancelSubscription => 'Cancel Subscription';

  @override
  String get recurringRequestsTitle => 'Recurring Subscriptions';

  @override
  String get recurringRequestApproved => 'Request approved successfully';

  @override
  String get recurringRequestApproveFailed => 'Failed to approve request';

  @override
  String get recurringRequestRejected => 'Request rejected';

  @override
  String get recurringRequestRejectFailed => 'Failed to reject request';

  @override
  String get rejectRequestTitle => 'Reject Request';

  @override
  String get rejectRequestPrompt =>
      'Please provide a reason for rejecting this recurring booking request:';

  @override
  String get rejectRequestHint => 'e.g., Slot not available, time conflict...';

  @override
  String get loadingRequests => 'Loading requests...';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicySubtitle => 'How we protect your data';

  @override
  String get privacyHeaderTitle => 'Your Privacy Matters';

  @override
  String get privacyHeaderDescription =>
      'Sport Kick is committed to protecting your privacy and personal information. This policy explains how we collect, use, and safeguard your data.';

  @override
  String get privacyInfoCollectTitle => 'Information We Collect';

  @override
  String get privacyCollectAccountInfo =>
      'Account information (name, email, phone number)';

  @override
  String get privacyCollectProfileInfo => 'Profile information you provide';

  @override
  String get privacyCollectBookingHistory => 'Booking history and preferences';

  @override
  String get privacyCollectLocation => 'Location data when using the app';

  @override
  String get privacyCollectDevice => 'Device information and usage data';

  @override
  String get privacyCollectPayment =>
      'Payment information (processed securely by our payment provider)';

  @override
  String get privacyUseInfoTitle => 'How We Use Your Information';

  @override
  String get privacyUseProvideService =>
      'To provide and maintain our booking services';

  @override
  String get privacyUseProcessPayments =>
      'To process your bookings and payments';

  @override
  String get privacyUseCommunicate =>
      'To communicate with you about bookings and updates';

  @override
  String get privacyUseImprove => 'To improve our services and user experience';

  @override
  String get privacyUseSecurity => 'To prevent fraud and ensure security';

  @override
  String get privacyUseLegal => 'To comply with legal obligations';

  @override
  String get privacyStorageTitle => 'Data Storage and Security';

  @override
  String get privacyStorageSecure =>
      'Your data is stored securely using Supabase (PostgreSQL database)';

  @override
  String get privacyStorageEncryption =>
      'We use industry-standard encryption for data transmission';

  @override
  String get privacyStoragePayment =>
      'Payment information is handled by certified payment processors';

  @override
  String get privacyStorageUpdates =>
      'We implement regular security updates and monitoring';

  @override
  String get privacyStorageAccess =>
      'Access to personal data is restricted to authorized personnel only';

  @override
  String get privacySharingTitle => 'Data Sharing';

  @override
  String get privacySharingNoSell =>
      'We do NOT sell your personal information to third parties';

  @override
  String get privacySharingOwners =>
      'Field owners can see your booking details (name, phone) for confirmed bookings';

  @override
  String get privacySharingProviders =>
      'We may share data with service providers (payment processors, analytics)';

  @override
  String get privacySharingLegal =>
      'We will share data if required by law or to protect rights and safety';

  @override
  String get privacyRightsTitle => 'Your Rights';

  @override
  String get privacyRightsAccess =>
      'Access your personal data at any time through your profile';

  @override
  String get privacyRightsUpdate => 'Update or correct your information';

  @override
  String get privacyRightsDelete => 'Delete your account and associated data';

  @override
  String get privacyRightsOptOut => 'Opt-out of marketing communications';

  @override
  String get privacyRightsExport => 'Export your booking history';

  @override
  String get privacyRightsWithdraw =>
      'Withdraw consent for data processing (may limit service availability)';

  @override
  String get privacyCookiesTitle => 'Cookies and Tracking';

  @override
  String get privacyCookiesUse =>
      'We use cookies and similar technologies to improve user experience';

  @override
  String get privacyCookiesAnalytics =>
      'Analytics cookies help us understand app usage';

  @override
  String get privacyCookiesDisable =>
      'You can disable cookies in your device settings';

  @override
  String get privacyCookiesImpact =>
      'Some features may not work without cookies';

  @override
  String get privacyChildrenTitle => 'Children\'s Privacy';

  @override
  String get privacyChildrenNotFor =>
      'Our service is not intended for children under 13';

  @override
  String get privacyChildrenNoCollect =>
      'We do not knowingly collect data from children';

  @override
  String get privacyChildrenDelete =>
      'If we learn we have collected child data, we will delete it';

  @override
  String get privacyChildrenParents =>
      'Parents can contact us to request data deletion';

  @override
  String get privacyChangesTitle => 'Changes to This Policy';

  @override
  String get privacyChangesMayUpdate =>
      'We may update this privacy policy from time to time';

  @override
  String get privacyChangesNotify =>
      'We will notify you of significant changes via email or app notification';

  @override
  String get privacyChangesAccept =>
      'Continued use of the app after changes constitutes acceptance';

  @override
  String privacyChangesLastUpdated(Object date) {
    return 'Last updated: $date';
  }

  @override
  String get termsTitle => 'Terms of Service';

  @override
  String get termsSubtitle => 'Rules and guidelines';

  @override
  String get termsDescription =>
      'Please read these terms carefully before using Sport Kick. These terms govern your use of our platform and services.';

  @override
  String get termsAcceptanceTitle => 'Acceptance of Terms';

  @override
  String get termsAcceptanceAgree =>
      'By using Sport Kick, you agree to these Terms of Service';

  @override
  String get termsAcceptanceDisagree =>
      'If you do not agree, please do not use our services';

  @override
  String get termsAcceptanceModify =>
      'We reserve the right to modify these terms at any time';

  @override
  String get termsAcceptanceContinuedUse =>
      'Continued use after changes constitutes acceptance';

  @override
  String get termsAccountsTitle => 'User Accounts';

  @override
  String get termsAccountsAccurateInfo =>
      'You must provide accurate and complete information when registering';

  @override
  String get termsAccountsSecurity =>
      'You are responsible for maintaining the security of your account';

  @override
  String get termsAccountsAge =>
      'You must be at least 13 years old to use our services';

  @override
  String get termsAccountsSingle => 'One person or business per account';

  @override
  String get termsAccountsNoShare =>
      'You must not share your account credentials';

  @override
  String get termsAccountsNotify =>
      'Notify us immediately of any unauthorized account access';

  @override
  String get termsBookingTitle => 'Booking Policies';

  @override
  String get termsBookingAvailability =>
      'All bookings are subject to field availability';

  @override
  String get termsBookingApproval =>
      'Bookings may require owner approval before confirmation';

  @override
  String get termsBookingArrival => 'You must arrive on time for your booking';

  @override
  String get termsBookingLate =>
      'Late arrivals may result in reduced playing time';

  @override
  String get termsBookingNoShow =>
      'No-shows may result in account restrictions';

  @override
  String get termsBookingPrices =>
      'Prices are set by field owners and may vary';

  @override
  String get termsCancellationTitle => 'Cancellation and Refunds';

  @override
  String get termsCancellationPolicy =>
      'Users can cancel bookings according to the cancellation policy';

  @override
  String get termsCancellationFullRefund =>
      'Cancellations made 24+ hours in advance may be eligible for full refund';

  @override
  String get termsCancellationLateFees =>
      'Cancellations made less than 24 hours may incur fees';

  @override
  String get termsCancellationNoShow => 'No-shows are not eligible for refunds';

  @override
  String get termsCancellationRefundTime =>
      'Refunds are processed according to payment method (3-7 business days)';

  @override
  String get termsCancellationOwnerCancel =>
      'Field owners reserve the right to cancel bookings due to maintenance or weather';

  @override
  String get termsConductTitle => 'User Conduct';

  @override
  String get termsConductRules => 'You must follow field rules and guidelines';

  @override
  String get termsConductNoAbuse =>
      'No harassment, discrimination, or abuse towards staff or players';

  @override
  String get termsConductDamage =>
      'You are responsible for any damage caused during your booking';

  @override
  String get termsConductProhibited =>
      'Prohibited activities include fraudulent bookings or misuse of the platform';

  @override
  String get termsLiabilityTitle => 'Liability and Disclaimers';

  @override
  String get termsLiabilityPlatform =>
      'Sport Kick is a platform that connects users with field owners';

  @override
  String get termsLiabilityCondition =>
      'We are not responsible for the condition of fields or equipment';

  @override
  String get termsLiabilityInjuries =>
      'We are not liable for injuries, accidents, or losses during use of the services';

  @override
  String get termsLiabilityOwner =>
      'Field owners are responsible for their facilities and adherence to safety standards';

  @override
  String get termsPaymentsTitle => 'Payment and Fees';

  @override
  String get termsPaymentsProcessed =>
      'Payments are processed securely via our payment provider';

  @override
  String get termsPaymentsFees => 'Service fees may apply to bookings';

  @override
  String get termsPaymentsDisplay => 'Prices are displayed before checkout';

  @override
  String get termsPaymentsRefunds => 'Refunds follow the cancellation policy';

  @override
  String get termsPaymentsCurrency =>
      'Currency and taxes are displayed during checkout';

  @override
  String get termsIPTitle => 'Intellectual Property';

  @override
  String get termsIPProtected =>
      'All content on Sport Kick is protected by copyright and trademarks';

  @override
  String get termsIPBrand => 'You may not use our branding without permission';

  @override
  String get termsIPUserContent =>
      'User-generated content remains your property, but you grant us a license to display it';

  @override
  String get termsTerminationTitle => 'Termination';

  @override
  String get termsTerminationSuspend =>
      'We may suspend or terminate accounts for violations of these terms';

  @override
  String get termsTerminationDelete =>
      'Users may delete their accounts at any time';

  @override
  String get termsTerminationDisputes =>
      'Outstanding payments or disputes may delay account deletion';

  @override
  String get termsLawTitle => 'Governing Law';

  @override
  String get termsLawGoverning =>
      'These terms are governed by applicable local laws';

  @override
  String get termsLawDisputes =>
      'Any disputes will be resolved in the appropriate jurisdiction';

  @override
  String get supportContactTitle => 'Contact Us';

  @override
  String get supportContactDescription =>
      'If you have questions about our policies or need assistance, please contact us:';
}
