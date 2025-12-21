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
  String get currentSession => 'Current Session';

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
  String get cancellationReason => 'Cancellation Reason *';

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
  String get activeStatus => 'Active Status';

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
  String get securitySettings => 'security';

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
  String get totalUsers => 'Total Users';

  @override
  String newUsersThisMonth(Object count) {
    return '+$count this month';
  }

  @override
  String get totalAdmins => 'Total Admins';

  @override
  String get fieldOwners => 'Field owners';

  @override
  String get activeFields => 'Active Fields';

  @override
  String inactiveCount(Object count) {
    return '$count inactive';
  }

  @override
  String pendingCount(Object count) {
    return '$count pending';
  }

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

  @override
  String get version100 => '1.0.0';

  @override
  String get version1001 => '1.0.0+1';

  @override
  String get oneHour => '1 Hour';

  @override
  String get phoneExample => '+20 123 456 7890';

  @override
  String get twoHours => '2 Hours';

  @override
  String get accountStatus => 'Account Status';

  @override
  String get activate => 'Activate';

  @override
  String get activateAdmins => 'Activate Admins';

  @override
  String get activateCity => 'Activate City';

  @override
  String get activateSelectedAdmins => 'Activate Selected Admins';

  @override
  String get activateSelectedUsers => 'Activate Selected Users';

  @override
  String get activateUser => 'Activate User?';

  @override
  String get activateUsers => 'Activate Users';

  @override
  String get activatingAdmins => 'Activating admins...';

  @override
  String get activatingUser => 'Activating user...';

  @override
  String get activatingUsers => 'Activating users...';

  @override
  String get active2 => 'active';

  @override
  String get activeNow => 'Active Now';

  @override
  String get addANewFieldOwner => 'Add a new field owner';

  @override
  String get addAnExtraLayerOfSecurity => 'Add an extra layer of security';

  @override
  String get addCity => 'Add City';

  @override
  String get addNewFieldOwner => 'Add new field owner';

  @override
  String get addNewSportsField => 'Add new sports field';

  @override
  String get adminAlerts => 'Admin Alerts';

  @override
  String get adminCreated => 'Admin Created!';

  @override
  String get adminDetails => 'Admin Details';

  @override
  String get adminExampleCom => 'admin@example.com';

  @override
  String get adminsExportedToCsv => 'Admins exported to CSV';

  @override
  String get ahmedMohamed => 'Ahmed Mohamed';

  @override
  String get all2 => 'all';

  @override
  String get allBookings => 'All Bookings';

  @override
  String get allCities => 'All Cities';

  @override
  String get allFields => 'All Fields';

  @override
  String get allSports => 'All Sports';

  @override
  String get allTimeEarnings => 'All time earnings';

  @override
  String get allowRegistrations => 'Allow Registrations';

  @override
  String get and => ' and ';

  @override
  String get applyToWeekdays => 'Apply to Weekdays';

  @override
  String get applyToWeekend => 'Apply to Weekend';

  @override
  String get approveThisBookingRequest => 'Approve this booking request';

  @override
  String get approvingBooking => 'Approving booking...';

  @override
  String areYouSureYouWantToActivateCountAdmins(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Are you sure you want to activate $count admins?',
      one: 'Are you sure you want to activate $count admin?',
    );
    return '$_temp0';
  }

  @override
  String areYouSureYouWantToActivateCountUsers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Are you sure you want to activate $count users?',
      one: 'Are you sure you want to activate $count user?',
    );
    return '$_temp0';
  }

  @override
  String areYouSureYouWantToDeactivateCountAdmins(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Are you sure you want to deactivate $count admins?',
      one: 'Are you sure you want to deactivate $count admin?',
    );
    return '$_temp0';
  }

  @override
  String areYouSureYouWantToDeactivateCountUsers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Are you sure you want to deactivate $count users?',
      one: 'Are you sure you want to deactivate $count user?',
    );
    return '$_temp0';
  }

  @override
  String get assign => 'Assign';

  @override
  String get assignField => 'Assign Field';

  @override
  String get assignFieldToAdmin => 'Assign Field to Admin';

  @override
  String get assignFirstField => 'Assign First Field';

  @override
  String get assignToAdmin => 'Assign to Admin';

  @override
  String get assigningField => 'Assigning field...';

  @override
  String get automaticallyApproveNewBookings =>
      'Automatically approve new bookings';

  @override
  String get averageRating => 'Average Rating';

  @override
  String get avgRating => 'Avg Rating';

  @override
  String get avgRevenue => 'Avg. Revenue';

  @override
  String get beTheFirstToShareYourNexperience =>
      'Be the first to share your\\nexperience!';

  @override
  String get bookYourFirstFieldAndStartNplayingToday =>
      'Book your first field and start\\nplaying today!';

  @override
  String get bookingAnalytics => 'Booking Analytics';

  @override
  String get bookingDistribution => 'Booking Distribution';

  @override
  String get bookingHasBeenFulfilled => 'Booking has been fulfilled';

  @override
  String get bookingNotifications => 'Booking Notifications';

  @override
  String get bookingSettings => 'Booking Settings';

  @override
  String get bookingStatistics => 'Booking Statistics';

  @override
  String get bookingStatus2 => 'Booking Status';

  @override
  String get bookingscountBookings => '\$bookingsCount Bookings';

  @override
  String get bookingscountBookings2 => '\$bookingsCount bookings';

  @override
  String get briefDescription => 'Brief description';

  @override
  String get buildNumber => 'Build Number';

  @override
  String get byNumberOfBookings => 'By number of bookings';

  @override
  String get byStatus => 'By status';

  @override
  String get cancelSelection => 'Cancel selection';

  @override
  String get cancelThisBookingWithReason => 'Cancel this booking with reason';

  @override
  String get cancelingBooking => 'Canceling booking...';

  @override
  String get cancellingBooking => 'Cancelling booking...';

  @override
  String get cardContent => 'Card content';

  @override
  String get categoryDeletedSuccessfully => 'Category deleted successfully';

  @override
  String get categoryNameCreatedSuccessfully =>
      'Category \"\$name\" created successfully';

  @override
  String get categoryUpdatedSuccessfully => 'Category updated successfully';

  @override
  String get chooseCurrency => 'Choose Currency';

  @override
  String get chooseDateFormat => 'Choose Date Format';

  @override
  String get chooseTheme => 'Choose Theme';

  @override
  String get cities => 'Cities';

  @override
  String get compareFields => 'Compare Fields';

  @override
  String get completion => 'Completion';

  @override
  String get configureDefaultPlatformHours =>
      'Configure default platform hours';

  @override
  String get configureLocations => 'Configure locations';

  @override
  String get configurePaymentMethodsAndFees =>
      'Configure payment methods and fees';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get copyAll => 'Copy All';

  @override
  String get copyLabel => 'Copy \$label';

  @override
  String get couldNotDetermineYourLocation =>
      'Could not determine your location';

  @override
  String get create => 'Create';

  @override
  String get createAStrongPassword => 'Create a strong password';

  @override
  String get createAdmin => 'Create Admin';

  @override
  String get createAdminAccount => 'Create Admin Account';

  @override
  String get createField => 'Create Field';

  @override
  String get createNewField2 => 'Create New Field';

  @override
  String get creatingAdminAccount => 'Creating admin account...';

  @override
  String get creatingBooking2 => 'Creating booking...';

  @override
  String get creatingCity => 'Creating city...';

  @override
  String get creatingField => 'Creating field...';

  @override
  String get creatingManualBooking => 'Creating manual booking...';

  @override
  String get creationDate => 'Creation Date';

  @override
  String get credentialsCopiedToClipboard => 'Credentials copied to clipboard';

  @override
  String get csv => 'CSV';

  @override
  String get customersUsers => 'Customers (Users)';

  @override
  String get customizeEmailNotifications => 'Customize email notifications';

  @override
  String get ddMmYyyy => 'DD/MM/YYYY';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get deactivateAdmins => 'Deactivate Admins';

  @override
  String get deactivateCity => 'Deactivate City';

  @override
  String get deactivateOrPermanentlyRemoveThisField =>
      'Deactivate or permanently remove this field';

  @override
  String get deactivateSelectedAdmins => 'Deactivate Selected Admins';

  @override
  String get deactivateSelectedUsers => 'Deactivate Selected Users';

  @override
  String get deactivateSoftDelete => 'Deactivate (Soft Delete)';

  @override
  String get deactivateUser => 'Deactivate User?';

  @override
  String get deactivateUsers => 'Deactivate Users';

  @override
  String get deactivatingAdmins => 'Deactivating admins...';

  @override
  String get deactivatingUser => 'Deactivating user...';

  @override
  String get deactivatingUsers => 'Deactivating users...';

  @override
  String get defaultHoursForNewFields => 'Default hours for new fields';

  @override
  String get deleteCategory => 'Delete Category';

  @override
  String get deleteCity => 'Delete City';

  @override
  String get deleteField2 => 'Delete field';

  @override
  String get deletePermanently => 'Delete Permanently';

  @override
  String get deleteReview => 'Delete Review?';

  @override
  String get deletingCity => 'Deleting city...';

  @override
  String get deletingField => 'Deleting field...';

  @override
  String get descriptionOptional => 'Description (Optional)';

  @override
  String get deselect => 'Deselect';

  @override
  String get deselectAll => 'Deselect all';

  @override
  String get eGFootballBasketball => 'e.g., Football, Basketball';

  @override
  String get editCity => 'Edit City';

  @override
  String get editField2 => 'Edit field';

  @override
  String get editReview => 'Edit Review';

  @override
  String get egp => 'EGP';

  @override
  String get egpEgyptianPound => 'EGP (Egyptian Pound)';

  @override
  String get egyptianPound => 'Egyptian Pound';

  @override
  String get emailTemplates => 'Email Templates';

  @override
  String get emailVerification => 'Email Verification';

  @override
  String get enable => 'Enable';

  @override
  String get enableDisablePlatformAccess => 'Enable/disable platform access';

  @override
  String get enterCityName => 'Enter city name';

  @override
  String get enterReasonForCancellation => 'Enter reason for cancellation...';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get euro => 'Euro';

  @override
  String get exampleEmailCom => 'example@email.com';

  @override
  String get export => 'Export';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get featureWillBeAvailableInAFutureUpdate =>
      '\$feature will be available in a future update.';

  @override
  String get featureWillBeAvailableSoonNstayTuned =>
      '\$feature will be available soon.\\nStay tuned!';

  @override
  String get fieldAssignedSuccessfully => 'Field assigned successfully';

  @override
  String get fieldOwners2 => 'Field Owners';

  @override
  String get fieldOwnersAdmins => 'Field Owners (Admins)';

  @override
  String get fieldPerformance => 'Field Performance';

  @override
  String get fieldscountFields => '\$fieldsCount fields';

  @override
  String get getNotifiedAboutBookings => 'Get notified about bookings';

  @override
  String get glassEffect => 'Glass effect';

  @override
  String get goHome => 'Go Home';

  @override
  String get hello => 'Hello';

  @override
  String get hideThisCityFromUsersCanBeReactivatedLat =>
      'Hide this city from users. Can be reactivated later.';

  @override
  String get inactive2 => 'inactive';

  @override
  String get invalidPrice => 'Invalid price';

  @override
  String get ipAddress => 'IP Address';

  @override
  String get joinDate => 'Join Date';

  @override
  String label(Object label) {
    return '$label: ';
  }

  @override
  String labelCopied(Object label) {
    return '$label copied';
  }

  @override
  String labelCount(Object count, Object label) {
    return '$label ($count)';
  }

  @override
  String get last6Months => 'Last 6 months';

  @override
  String get last6MonthsRevenue => 'Last 6 months revenue';

  @override
  String get loadingAdmins => 'Loading admins...';

  @override
  String get loadingAnalytics => 'Loading analytics...';

  @override
  String get loadingAvailableTimeSlots => 'Loading available time slots...';

  @override
  String get loadingBookingDetails => 'Loading booking details...';

  @override
  String get loadingBookings => 'Loading bookings...';

  @override
  String get loadingDashboard => 'Loading dashboard...';

  @override
  String get loadingPlatformData => 'Loading platform data...';

  @override
  String get loadingRevenueData => 'Loading revenue data...';

  @override
  String get loadingReviews => 'Loading reviews...';

  @override
  String get loadingUsers => 'Loading users...';

  @override
  String get loadingYourBookings => 'Loading your bookings...';

  @override
  String get loadingYourFields => 'Loading your fields...';

  @override
  String get logFailedLogins => 'Log Failed Logins';

  @override
  String get maintenanceMode => 'Maintenance Mode';

  @override
  String get manageCities => 'Manage Cities';

  @override
  String get manageCustomers => 'Manage customers';

  @override
  String get manageFieldOwners => 'Manage field owners';

  @override
  String get managePlatformLocations => 'Manage platform locations';

  @override
  String get managePlatformNotifications => 'Manage platform notifications';

  @override
  String get manageSportTypes => 'Manage sport types';

  @override
  String get manageUsers => 'Manage Users';

  @override
  String get management => 'Management';

  @override
  String get markAsCompleted => 'Mark as Completed';

  @override
  String get memberDays => 'Member Days';

  @override
  String minutesMinutes(num minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '$minutes minute',
    );
    return '$_temp0';
  }

  @override
  String get mmDdYyyy => 'MM/DD/YYYY';

  @override
  String get moderatePlatformReviews => 'Moderate platform reviews';

  @override
  String get monthlyBookings => 'Monthly Bookings';

  @override
  String get mostBookedFields => 'Most booked fields';

  @override
  String get newFields => 'New Fields';

  @override
  String get newNotification => 'New Notification';

  @override
  String get noBookingsYet2 => 'No Bookings Yet';

  @override
  String get noFavoritesYet2 => 'No Favorites Yet';

  @override
  String get noFeaturedFieldsAvailable => 'No featured fields available';

  @override
  String get noFieldsAvailable2 => 'No Fields Available';

  @override
  String get noPastBookings => 'No Past Bookings';

  @override
  String get noResultsFound => 'No Results Found';

  @override
  String get noReviewsYet => 'No Reviews Yet';

  @override
  String get noUpcomingBookings2 => 'No Upcoming Bookings';

  @override
  String get notSet => 'Not set';

  @override
  String get notes => 'Notes';

  @override
  String get operatingHours => 'Operating Hours';

  @override
  String get paymentSettings => 'Payment Settings';

  @override
  String get pdf => 'PDF';

  @override
  String get perBooking => 'Per booking';

  @override
  String get performance => 'Performance';

  @override
  String get performanceMetrics => 'Performance Metrics';

  @override
  String get permanentDelete => 'Permanent Delete';

  @override
  String get permanentlyRemoveThisCity => 'Permanently remove this city';

  @override
  String get phone2 => 'Phone';

  @override
  String get platform => 'Platform';

  @override
  String get platformAnalyticsAndExports => 'Platform analytics & exports';

  @override
  String get platformConfiguration => 'Platform configuration';

  @override
  String get platformDataExportedToCsv => 'Platform data exported to CSV';

  @override
  String get platformInsights => 'Platform insights';

  @override
  String get platformPerformanceMetrics => 'Platform performance metrics';

  @override
  String get platformSecurityMonitoring => 'Platform security monitoring';

  @override
  String get pleaseAcceptTheTermsAndConditions =>
      'Please accept the Terms & Conditions';

  @override
  String get pleaseEnableLocationPermissionsInSetting =>
      'Please enable location permissions in settings';

  @override
  String get pleaseEnterACategoryName => 'Please enter a category name';

  @override
  String get pricePerHourEgp => 'Price per Hour (EGP)';

  @override
  String get pricing => 'Pricing';

  @override
  String get readOurPrivacyPolicy => 'Read our privacy policy';

  @override
  String get readOurTerms => 'Read our terms';

  @override
  String get receivePushNotifications => 'Receive push notifications';

  @override
  String get receiveUpdatesViaEmail => 'Receive updates via email';

  @override
  String get rejectingBooking => 'Rejecting booking...';

  @override
  String get removeCityFromDatabaseCannotBeUndone =>
      'Remove city from database. Cannot be undone.';

  @override
  String get removeVerification => 'Remove Verification';

  @override
  String get removingVerification => 'Removing verification...';

  @override
  String get reports => 'Reports';

  @override
  String get response => 'Response';

  @override
  String get revenueReport => 'Revenue Report';

  @override
  String get role => 'Role';

  @override
  String get satisfaction => 'Satisfaction';

  @override
  String get saudiRiyal => 'Saudi Riyal';

  @override
  String get searchAdmins => 'Search admins...';

  @override
  String get searchAdminsByNameEmailOrPhone =>
      'Search admins by name, email, or phone...';

  @override
  String get searchByCustomerFieldOrId => 'Search by customer, field, or ID...';

  @override
  String get searchByNameEmailOrPhone => 'Search by name, email, or phone...';

  @override
  String get searchByUserFieldOrBookingId =>
      'Search by user, field, or booking ID...';

  @override
  String get searchByUserOrField => 'Search by user or field...';

  @override
  String get searchCustomers => 'Search customers...';

  @override
  String get searchFieldsByNameCityOrOwner =>
      'Search fields by name, city, or owner...';

  @override
  String get searchUsers => 'Search users...';

  @override
  String get searchUsersByNameEmailOrPhone =>
      'Search users by name, email, or phone...';

  @override
  String get selectAll => 'Select all';

  @override
  String get selectFieldLocation => 'Select Field Location';

  @override
  String get selectOnMap => 'Select on map';

  @override
  String get selectSportCategory => 'Select Sport Category';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get sessionTimeout => 'Session Timeout';

  @override
  String get shareYourExperienceWithThisField =>
      'Share your experience with this field...';

  @override
  String get somethingWentWrong2 => 'Something Went Wrong';

  @override
  String get sportCategories => 'Sport Categories';

  @override
  String get sportCategory => 'Sport Category';

  @override
  String get sports => 'Sports';

  @override
  String get startAddingFieldsToYourFavorites =>
      'Start adding fields to your favorites';

  @override
  String get statisticsExportedToPdf => 'Statistics exported to PDF';

  @override
  String get streetAddressOrSelectOnMap => 'Street address or select on map';

  @override
  String get submittingReview => 'Submitting review...';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get success2 => 'Success!';

  @override
  String get successRate => 'Success Rate';

  @override
  String get system => 'System';

  @override
  String get systemAlertsAndUpdates => 'System alerts and updates';

  @override
  String get systemPreferences => 'System Preferences';

  @override
  String get tellOthersAboutYourExperience =>
      'Tell others about your experience...';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get thereAreNoFieldsInYourAreaYetNcheckBackS =>
      'There are no fields in your area yet.\\nCheck back soon!';

  @override
  String get thisWeek => 'This Week';

  @override
  String get title => 'title';

  @override
  String get todayBookings2 => 'Today Bookings';

  @override
  String get todaySActivity => 'Today\'s Activity';

  @override
  String get topFieldsByBookings => 'Top Fields by Bookings';

  @override
  String get total2 => 'total';

  @override
  String get totalCities => 'Total Cities';

  @override
  String get totalFields => 'Total Fields';

  @override
  String get totalLogins => 'Total Logins';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get tryAdjustingYourFiltersOrNsearchWithDiff =>
      'Try adjusting your filters or\\nsearch with different keywords';

  @override
  String get twoFactorAuthentication => 'Two-Factor Authentication';

  @override
  String get unableToConnectToTheServerNpleaseCheckYo =>
      'Unable to connect to the server.\\nPlease check your internet.';

  @override
  String get unableToLoadFields => 'Unable to load fields';

  @override
  String get update => 'Update';

  @override
  String get updateCityName => 'Update city name';

  @override
  String get updateFieldDetailsPricingAndLocation =>
      'Update field details, pricing, and location';

  @override
  String get updateReview => 'Update Review';

  @override
  String get updateYourLoginPassword => 'Update your login password';

  @override
  String get updateYourPassword => 'Update your password';

  @override
  String get updatingBooking => 'Updating booking...';

  @override
  String get updatingBookingStatus => 'Updating booking status...';

  @override
  String get updatingCity => 'Updating city...';

  @override
  String get updatingProfile => 'Updating profile...';

  @override
  String get usDollar => 'US Dollar';

  @override
  String get userActivated => 'User activated';

  @override
  String get userActivityReport => 'User Activity Report';

  @override
  String get userDeactivated => 'User deactivated';

  @override
  String get userDetails => 'User Details';

  @override
  String get users => 'Users';

  @override
  String get usersExportedToCsv => 'Users exported to CSV';

  @override
  String get verifyField => 'Verify Field';

  @override
  String get verifyingField => 'Verifying field...';

  @override
  String get viewAdmins => 'View Admins';

  @override
  String get viewAllReservations => 'View all reservations';

  @override
  String get viewAllSportsFields => 'View all sports fields';

  @override
  String get viewAndManageYourBookings => 'View and manage your bookings';

  @override
  String get viewBookings => 'View Bookings';

  @override
  String get viewFields => 'View Fields';

  @override
  String get viewRecentLoginAttempts => 'View recent login attempts';

  @override
  String get viewUsers => 'View Users';

  @override
  String get viewYourProfileDetails => 'View your profile details';

  @override
  String get vodafoneCash => 'vodafone_cash';

  @override
  String get weeklySchedule => 'Weekly Schedule';

  @override
  String get writeAReview => 'Write a Review';

  @override
  String get youMustBeLoggedInToReview => 'You must be logged in to review';

  @override
  String get yourRating => 'Your Rating *';

  @override
  String get yyyyMmDd => 'YYYY-MM-DD';

  @override
  String get rateYourExperience => 'Rate Your Experience';

  @override
  String get helpOthersMakeInformedDecisions =>
      'Share your experience to help others make informed decisions';

  @override
  String get recentReviewsFromCustomers => 'Recent reviews from our customers';

  @override
  String errorLoadingFieldMessage(Object message) {
    return 'Error loading field: $message';
  }

  @override
  String updateFieldSubtitle(Object fieldName) {
    return 'Update $fieldName';
  }

  @override
  String reviewsSummaryForField(num count, Object fieldName) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$fieldName • $count reviews',
      one: '$fieldName • $count review',
    );
    return '$_temp0';
  }

  @override
  String totalAdminsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count total admins',
      one: '$count total admin',
    );
    return '$_temp0';
  }

  @override
  String totalUsersCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count total users',
      one: '$count total user',
    );
    return '$_temp0';
  }

  @override
  String totalBookingsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count total bookings',
      one: '$count total booking',
    );
    return '$_temp0';
  }

  @override
  String totalFieldsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count total fields',
      one: '$count total field',
    );
    return '$_temp0';
  }

  @override
  String errorWithMessage(Object message) {
    return 'Error: $message';
  }

  @override
  String ownerIdShort(Object id) {
    return 'Owner ID: $id...';
  }

  @override
  String get bookingHistory => 'Booking History';

  @override
  String get advancedFilters => 'Advanced Filters';

  @override
  String get selectDateRange => 'Select Date Range';

  @override
  String get startAddingFavorites =>
      'Start adding fields to your favorites\\nfor quick access anytime';

  @override
  String get bookAField => 'Book a Field';

  @override
  String get userRole => 'user';

  @override
  String get adminRole => 'admin';

  @override
  String get aZ => '[A-Z]';

  @override
  String get aToZ => '[a-z]';

  @override
  String get iAgreeToThe => 'I agree to the ';

  @override
  String get alreadyHaveAnAccount => 'Already have an account? ';

  @override
  String get mybookings => 'myBookings';

  @override
  String get eeeMmmD => 'EEE, MMM d';

  @override
  String get mmmmYyyy => 'MMMM yyyy';

  @override
  String get eee => 'EEE';

  @override
  String get remove => 'Remove';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get verifiedField => 'Verified Field';

  @override
  String get indoorType => 'indoor';

  @override
  String get outdoorType => 'outdoor';

  @override
  String get aboutThisField => 'About This Field';

  @override
  String get readMore => 'Read more';

  @override
  String get showLess => 'Show less';

  @override
  String get autoBookSameTimeEveryWeek => 'Auto-book same time every week';

  @override
  String get getDirections => 'Get Directions';

  @override
  String get recommended => 'recommended';

  @override
  String get priceAsc => 'price_asc';

  @override
  String get priceDesc => 'price_desc';

  @override
  String get ratingField => 'rating';

  @override
  String get profileTab => 'profile';

  @override
  String get fieldslist => 'fieldsList';

  @override
  String get favoritesTab => 'favorites';

  @override
  String get descriptionField => 'description';

  @override
  String get icon => 'icon';

  @override
  String get bookingsWillAppearHere => 'Bookings will appear here';

  @override
  String get manual => 'Manual';

  @override
  String get noBookingsForThisFieldIn =>
      'No bookings for this field in this week';

  @override
  String get scrollRightToSeeAllDays =>
      'Scroll right to see all days (Sat-Fri)';

  @override
  String get verifiedBadge => 'VERIFIED';

  @override
  String get createNewCustomer => 'Create New Customer';

  @override
  String get noFieldDataAvailable => 'No field data available';

  @override
  String get vsLastPeriod => 'vs last period';

  @override
  String get pendingStatus => 'pending';

  @override
  String get confirmed => 'confirmed';

  @override
  String get canceled => 'canceled';

  @override
  String get tryAdjustingYourFiltersOrSearch =>
      'Try adjusting your filters or search';

  @override
  String get ownerbookings => 'ownerBookings';

  @override
  String get sportKickV100 => 'Sport Kick v1.0.0';

  @override
  String get o => 'O';

  @override
  String get noRecentBookings => 'No Recent Bookings';

  @override
  String get yourRecentBookingsWillAppearHere =>
      'Your recent bookings will appear here';

  @override
  String get manageYourPreferences => 'Manage your preferences';

  @override
  String get howWouldYouRateThisField => 'How would you rate this field?';

  @override
  String get shareYourExperienceOptional => 'Share your experience (optional)';

  @override
  String get reviewing => 'Reviewing';

  @override
  String get yourReviewOptional => 'Your Review (Optional)';

  @override
  String get youCanUpdateYourRatingAnd =>
      'You can update your rating and comment';

  @override
  String get noRatingsYet => 'No ratings yet';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get edited => '(edited)';

  @override
  String get recentReview => 'Recent Review';

  @override
  String get filterByRating => 'Filter by Rating';

  @override
  String get clear => 'Clear';

  @override
  String get thisActionCannotBeUndoneAre =>
      'This action cannot be undone. Are you sure you want to delete this review?';

  @override
  String get editedLabel => 'edited';

  @override
  String get editingReviewFor => 'Editing review for';

  @override
  String get shareYourExperienceToHelpOthers =>
      'Share your experience to help others';

  @override
  String get updateRatingPrompt =>
      'You can update your rating and comment anytime';

  @override
  String get shareDetailsAboutYourExperienceN =>
      'Share details about your experience...\\n\\n';

  @override
  String get howWasTheFieldConditionN => '- How was the field condition?\\n';

  @override
  String get reviewUpdated => 'Review Updated!';

  @override
  String get reviewSubmittedSuccess => 'Review Submitted!';

  @override
  String get yourReviewHasBeenUpdatedSuccessfully =>
      'Your review has been updated successfully';

  @override
  String get egpE => 'EGP (E£)';

  @override
  String get eur => 'EUR (€)';

  @override
  String get sar => 'SAR (﷼)';

  @override
  String get eG25122025 => 'e.g., 25/12/2025';

  @override
  String get eG12252025 => 'e.g., 12/25/2025';

  @override
  String get eG20251225 => 'e.g., 2025-12-25';

  @override
  String get loginactivity => 'loginActivity';

  @override
  String get notificationManagementWillBeNavailableIn =>
      'Notification management will be\\navailable in a future update.';

  @override
  String get reviewsModerationWillBeNavailableIn =>
      'Reviews moderation will be\\navailable in a future update.';

  @override
  String get failedToLoadCategories => 'Failed to load categories';

  @override
  String get noCategoriesYet => 'No Categories Yet';

  @override
  String get tapTheButtonToCreateNyour =>
      'Tap the + button to create\\nyour first sport category';

  @override
  String get platformPerformance => 'Platform Performance';

  @override
  String get comprehensiveOverviewOfYourPlatformMetrics =>
      'Comprehensive overview of your platform metrics';

  @override
  String get errorLoadingAnalytics => 'Error loading analytics';

  @override
  String get enforceOperatingHours => 'Enforce Operating Hours';

  @override
  String get applyToAllFieldBookings => 'Apply to all field bookings';

  @override
  String get saving => 'Saving...';

  @override
  String get userRegistrationsAndEngagement =>
      'User registrations and engagement';

  @override
  String get platformWideRevenueAndTransactions =>
      'Platform-wide revenue and transactions';

  @override
  String get bookingTrendsAndFieldUtilization =>
      'Booking trends and field utilization';

  @override
  String get fieldRatingsAndReviewAnalysis =>
      'Field ratings and review analysis';

  @override
  String get quickOverview => 'Quick Overview';

  @override
  String get exportData => 'Export Data';

  @override
  String get generateAndDownloadDetailedReportsIn =>
      'Generate and download detailed reports in CSV or PDF format.';

  @override
  String get activatingAdmin => 'Activating admin...';

  @override
  String get deactivatingAdmin => 'Deactivating admin...';

  @override
  String get permanentlyDeletingField => 'Permanently deleting field...';

  @override
  String get deactivatingField => 'Deactivating field...';

  @override
  String get noAdminsYet => 'No Admins Yet';

  @override
  String get createYourFirstFieldOwnerAccount =>
      'Create your first field owner account';

  @override
  String get errorLoadingAdmins => 'Error loading admins';

  @override
  String get assignedFields => 'Assigned Fields';

  @override
  String get noFieldsAssigned => 'No Fields Assigned';

  @override
  String get thisAdminDoesn => 'This admin doesn\\';

  @override
  String get superAdmin => 'super_admin';

  @override
  String get activeAccount => 'Active Account';

  @override
  String get inactiveAccount => 'Inactive Account';

  @override
  String get formatAdminCreatedat => ').format(admin.createdAt)';

  @override
  String get allAvailableFieldsAssigned => 'All Available Fields Assigned';

  @override
  String get thisAdminAlreadyHasAllAvailable =>
      'This admin already has all available fields assigned.';

  @override
  String get tryAdjustingYourSearchOrFilters =>
      'Try adjusting your search or filters';

  @override
  String get bookingsOverview => 'Bookings Overview';

  @override
  String get mmmDdYyyy => 'MMM dd, yyyy';

  @override
  String get longPressForActions => 'Long press for actions';

  @override
  String get tryAdjustingYourFilters => 'Try adjusting your filters';

  @override
  String get errorLoadingFields => 'Error loading fields';

  @override
  String get fieldsOverview => 'Fields Overview';

  @override
  String get noCitiesFound => 'No cities found';

  @override
  String get tryChangingTheFilter => 'Try changing the filter';

  @override
  String get platformCoverage => 'Platform Coverage';

  @override
  String get createFieldOwnerAccount => 'Create Field Owner Account';

  @override
  String get aSecurePasswordWillBeGenerated =>
      'A secure password will be generated automatically. The admin must change it on first login.';

  @override
  String get adminAccountHasBeenCreatedSuccessfully =>
      'Admin account has been created successfully. Please save these credentials:';

  @override
  String get adminMustChangePasswordOnFirst =>
      'Admin must change password on first login';

  @override
  String get eGChampionsField => 'e.g., Champions Field';

  @override
  String get selectAvailableFacilities => 'Select Available Facilities';

  @override
  String get fillInDetailsAndAssignTo => 'Fill in details and assign to admin';

  @override
  String get indoorField => 'Indoor Field';

  @override
  String get vodafoneCashNumberForReceivingPayments =>
      'Vodafone Cash number for receiving payments';

  @override
  String get instapayNumberForReceivingTransfers =>
      'InstaPay number for receiving transfers';

  @override
  String get sportKickPlatform => 'Sport Kick Platform';

  @override
  String get platformOverview => 'Platform Overview';

  @override
  String get chooseHowToDeleteThisField => 'Choose how to delete this field:';

  @override
  String get fieldWillBeHiddenFromUsers =>
      'Field will be hidden from users but data is preserved. Can be reactivated later.';

  @override
  String get allDataWillBePermanentlyRemoved =>
      'All data will be permanently removed. This action cannot be undone!';

  @override
  String get removeVerifiedBadgeFromThisField =>
      'Remove verified badge from this field';

  @override
  String get addVerifiedBadgeToThisField => 'Add verified badge to this field';

  @override
  String get noAdminsMatchYourFilters => 'No admins match your filters';

  @override
  String get noAdminsFound => 'No admins found';

  @override
  String get noUsersMatchYourFilters => 'No users match your filters';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get areYouSureYouWantTo =>
      'Are you sure you want to enable maintenance mode? ';

  @override
  String get thisWillPreventUsersFromAccessing =>
      'This will prevent users from accessing the platform.';

  @override
  String get changepassword => 'changePassword';

  @override
  String get termsofservice => 'termsOfService';

  @override
  String get privacypolicy => 'privacyPolicy';

  @override
  String get editprofile => 'editProfile';

  @override
  String get dateFormatSettings => 'Date Format Settings';

  @override
  String get currencySettings => 'Currency Settings';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get noUsersYet => 'No Users Yet';

  @override
  String get errorLoadingUsers => 'Error loading users';

  @override
  String get deactivateAccount => 'Deactivate Account';

  @override
  String get activateAccount => 'Activate Account';

  @override
  String get mmmDY => 'MMM d, y';

  @override
  String get thisUserHasn => 'This user hasn\\';

  @override
  String get formatUserCreatedat => ').format(user.createdAt)';

  @override
  String get thisWillPreventTheUserFrom =>
      'This will prevent the user from logging in and making new bookings.';

  @override
  String get manageAdmins => 'Manage Admins';

  @override
  String get viewAndManageFieldOwnerAccounts =>
      'View and manage field owner accounts';

  @override
  String get failedToLoadAdmins => 'Failed to load admins';

  @override
  String get assignFieldsToThisAdminTo =>
      'Assign fields to this admin to get started';

  @override
  String get selectAFieldToAssign => 'Select a field to assign';

  @override
  String get noAvailableFields => 'No available fields';

  @override
  String get passwordResetSuccessfully => 'Password Reset Successfully!';

  @override
  String get adminMustChangePasswordOnNext =>
      'Admin must change password on next login';

  @override
  String get resetAdminPassword => 'Reset Admin Password?';

  @override
  String get aNewPasswordWillBeGenerated =>
      'A new password will be generated for this admin. They will need to change it on their next login.';

  @override
  String get thisBookingHasBeenCompleted => 'This booking has been completed';

  @override
  String get tryAdjustingYourSearchNorFilters =>
      'Try adjusting your search\\nor filters';

  @override
  String get hour => '/hour';

  @override
  String get hideThisCityFromUsers => 'Hide this city from users';

  @override
  String get showThisCityToUsers => 'Show this city to users';

  @override
  String get addNewCity => 'Add New City';

  @override
  String get createANewCityForThe => 'Create a new city for the platform';

  @override
  String get cityName => 'City Name';

  @override
  String get cityWillBeVisibleToUsers => 'City will be visible to users';

  @override
  String get createCity => 'Create City';

  @override
  String get thisActionMayBeIrreversible => 'This action may be irreversible';

  @override
  String get permanentDeleteIsDisabledForCities =>
      'Permanent delete is disabled for cities with fields.';

  @override
  String get deleteForever => 'Delete Forever';

  @override
  String get cityIsVisibleToUsers => 'City is visible to users';

  @override
  String get oopsSomethingWentWrong => 'Oops! Something went wrong';

  @override
  String get tryAdjustingYourFiltersNorAdd =>
      'Try adjusting your filters\\nor add a new city';

  @override
  String get fieldOwnerManagement => 'Field owner management';

  @override
  String get enterTheAdmin => 'Enter the admin\\';

  @override
  String get aTemporaryPasswordWillBeGenerated =>
      'A temporary password will be generated automatically';

  @override
  String get shareCredentialsSecurelyWithTheNew =>
      'Share credentials securely with the new admin';

  @override
  String get adminCreatedSuccessfully => 'Admin Created Successfully!';

  @override
  String get shareTheseCredentialsSecurely =>
      'Share these credentials securely';

  @override
  String get sportKickAdminV100 => 'Sport Kick Admin v1.0.0';

  @override
  String get a => 'A';

  @override
  String get superAdminRole => 'SUPER ADMIN';

  @override
  String get platformRevenue => 'Platform Revenue';

  @override
  String get totalEarningsFromAllFields => 'Total earnings from all fields';

  @override
  String get successStatus => 'success';

  @override
  String get failed => 'failed';

  @override
  String get blocked => 'blocked';

  @override
  String get loadingLoginActivity => 'Loading login activity...';

  @override
  String get failedToLoadActivity => 'Failed to load activity';

  @override
  String get noLoginActivity => 'No login activity';

  @override
  String get noLoginEventsMatchNyourFilter =>
      'No login events match\\nyour filter criteria';

  @override
  String get logoutAction => 'Logout?';

  @override
  String get confirmationPrompt =>
      'Are you sure you want to logout?\\nYou will need to login again to access the admin panel.';

  @override
  String get platformSettings => 'platform';

  @override
  String get allowNewUserSignUps => 'Allow new user sign-ups';

  @override
  String get requireEmailVerificationForNewUsers =>
      'Require email verification for new users';

  @override
  String get configureDefaults => 'Configure defaults';

  @override
  String get notificationsTab => 'notifications';

  @override
  String get receiveEmailAlerts => 'Receive email alerts';

  @override
  String get receivePushAlerts => 'Receive push alerts';

  @override
  String get importantAdminNotifications => 'Important admin notifications';

  @override
  String get trackFailedLoginAttempts => 'Track failed login attempts';

  @override
  String get loggingOut => 'Logging out...';

  @override
  String get value => 'value';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get createCategory => 'Create Category';

  @override
  String get iconField => 'Icon';

  @override
  String get failedToLoadUsers => 'Failed to load users';

  @override
  String get viewAndManageAllCustomerAccounts =>
      'View and manage all customer accounts';

  @override
  String get thisUserWillBeAbleTo =>
      'This user will be able to login and make bookings again.';

  @override
  String get dd => 'dd';

  @override
  String get mmm => 'MMM';

  @override
  String get favoriteField => 'Favorite Field';

  @override
  String selectedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '$count selected',
    );
    return '$_temp0';
  }

  @override
  String fieldsFoundCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fields found',
      one: '$count field found',
      zero: 'No fields found',
    );
    return '$_temp0';
  }

  @override
  String bookingsFoundCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bookings found',
      one: '$count booking found',
      zero: 'No bookings found',
    );
    return '$_temp0';
  }

  @override
  String fieldsSelectedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fields selected',
      one: '$count field selected',
    );
    return '$_temp0';
  }

  @override
  String cityFieldsAssociatedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'This city has # fields associated with it.',
      one: 'This city has 1 field associated with it.',
      zero: 'This city has no fields associated with it.',
    );
    return '$_temp0';
  }

  @override
  String cityFieldsRegisteredCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'This city has # fields registered.',
      one: 'This city has 1 field registered.',
      zero: 'This city has no fields registered.',
    );
    return '$_temp0';
  }

  @override
  String get cityIsHiddenFromUsers => 'City is hidden from users';

  @override
  String editingCity(Object name) {
    return 'Editing: $name';
  }

  @override
  String showingAdminsCount(Object filtered, Object total) {
    return 'Showing $filtered of $total admins';
  }

  @override
  String showingUsersCount(Object filtered, Object total) {
    return 'Showing $filtered of $total users';
  }

  @override
  String ofTotalAdmins(Object total) {
    return 'of $total admins';
  }

  @override
  String ofTotalUsers(Object total) {
    return 'of $total users';
  }

  @override
  String activeCount(Object count) {
    return '$count active';
  }

  @override
  String memberSinceDate(Object date) {
    return 'Member since $date';
  }

  @override
  String joinedDate(Object date) {
    return 'Joined $date';
  }

  @override
  String sinceDate(Object date) {
    return 'Since $date';
  }

  @override
  String bookingNumber(Object id) {
    return 'Booking #$id';
  }

  @override
  String basedOnReviews(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Based on $count reviews',
      one: 'Based on $count review',
    );
    return '$_temp0';
  }

  @override
  String noStarReviewsYet(Object rating) {
    return 'No $rating-star reviews yet';
  }

  @override
  String allReviewsWithCount(Object count) {
    return 'All Reviews ($count)';
  }

  @override
  String countOfTotal(Object count, Object total) {
    return '$count of $total';
  }

  @override
  String viewAllBookingsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'View All $count Bookings',
      one: 'View All $count Booking',
    );
    return '$_temp0';
  }

  @override
  String assigningTo(Object name) {
    return 'Assigning to: $name';
  }

  @override
  String usingCurrentHours(Object hours) {
    return 'Using current hours: $hours';
  }

  @override
  String sharePasswordSecurelyWith(Object name) {
    return 'Share this password securely with $name';
  }

  @override
  String exportingReport(Object type) {
    return 'Exporting $type...';
  }

  @override
  String deleteCategoryConfirmation(Object name) {
    return 'Are you sure you want to delete \"$name\"?\\n\\nThis action cannot be undone.';
  }

  @override
  String gpsCoordinates(Object coordinates) {
    return 'GPS: $coordinates';
  }

  @override
  String labelWithValue(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String usersCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count users',
      one: '$count user',
    );
    return '$_temp0';
  }

  @override
  String get allStatuses => 'All Statuses';

  @override
  String effectiveDateLabel(Object date) {
    return 'Effective Date: $date';
  }

  @override
  String lastUpdatedLabel(Object date) {
    return 'Last Updated: $date';
  }

  @override
  String effectiveLabel(Object date) {
    return 'Effective: $date';
  }

  @override
  String beFirstToReviewField(Object fieldName) {
    return 'Be the first to review $fieldName';
  }

  @override
  String starReviewsWithCount(Object count, Object rating) {
    return '$rating Star Reviews ($count)';
  }

  @override
  String get thisUserHasntMadeAnyBookings =>
      'This user hasn\'t made any bookings yet.';

  @override
  String get thisUserHasntMadeAnyBookingsYet =>
      'This user hasn\'t made any bookings yet.';

  @override
  String get thisAdminDoesntHaveAnyFieldsAssignedYet =>
      'This admin doesn\'t have any fields assigned yet.';

  @override
  String get enterTheAdminsEmailAndPersonalDetails =>
      'Enter the admin\'s email and personal details';

  @override
  String get admins => 'Admins';

  @override
  String errorLoadingDashboard(Object message) {
    return 'Error loading dashboard: $message';
  }

  @override
  String get shareDetailsAboutYourExperience =>
      'Share details about your experience:\\n- How was the field condition?\\n- Were the facilities good?\\n- Would you recommend it?';

  @override
  String get yourReviewHelpsOthersFindTheBestFields =>
      'Your review helps others find the best fields';

  @override
  String get nameIsRequired => 'Name is required';

  @override
  String get nameIsTooShort => 'Name is too short';

  @override
  String get nameMustBeAtLeast3Characters =>
      'Name must be at least 3 characters';

  @override
  String get emailIsRequired => 'Email is required';

  @override
  String get pleaseEnterAValidEmail => 'Please enter a valid email';

  @override
  String get phoneNumberIsRequired => 'Phone number is required';

  @override
  String get pleaseEnterAValidPhoneNumber =>
      'Please enter a valid phone number';

  @override
  String get passwordIsRequired => 'Password is required';

  @override
  String get passwordMustBeAtLeast8Characters =>
      'Password must be at least 8 characters';

  @override
  String get pleaseConfirmYourPassword => 'Please confirm your password';

  @override
  String get emailAddressRequired => 'Email Address *';

  @override
  String get fullNameRequired => 'Full Name *';

  @override
  String get phoneNumberOptional => 'Phone Number (Optional)';

  @override
  String get paymentPhoneNumber => 'Payment Phone Number';

  @override
  String get paymentPhoneIsRequired => 'Payment phone is required';

  @override
  String get enterValidEgyptianPhoneNumber =>
      'Enter a valid Egyptian phone number';

  @override
  String get selectAdmin => 'Select Admin';

  @override
  String get pleaseSelectAnAdmin => 'Please select an admin';

  @override
  String get createFieldButton => 'Create Field';

  @override
  String get requiredField => 'Required';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get loadingCities => 'Loading cities...';

  @override
  String get loadingCategories => 'Loading categories...';

  @override
  String get fieldNameIsRequired => 'Field name is required';

  @override
  String get addressIsRequired => 'Address is required';

  @override
  String get priceIsRequired => 'Price is required';

  @override
  String get pleaseEnterAValidNumber => 'Please enter a valid number';

  @override
  String get priceMustBeGreaterThanZero => 'Price must be greater than 0';

  @override
  String get pleaseSelectACity => 'Please select a city';

  @override
  String get pleaseSelectASportCategory => 'Please select a sport category';

  @override
  String get pleaseSelectAnAdminToAssignField =>
      'Please select an admin to assign this field';

  @override
  String get pleaseEnterACityName => 'Please enter a city name';

  @override
  String get cityNameMustBeAtLeast2Characters =>
      'City name must be at least 2 characters';

  @override
  String get pleaseEnterACancellationReason =>
      'Please enter a cancellation reason';

  @override
  String get reasonMustBeAtLeast5Characters =>
      'Reason must be at least 5 characters';

  @override
  String get categoryNameLabel => 'Category Name';

  @override
  String get ratingPoor => 'Poor';

  @override
  String get ratingFair => 'Fair';

  @override
  String get ratingGood => 'Good';

  @override
  String get ratingVeryGood => 'Very Good';

  @override
  String get ratingExcellent => 'Excellent';

  @override
  String get bookingStatusPending => 'Pending';

  @override
  String get bookingStatusConfirmed => 'Confirmed';

  @override
  String get bookingStatusCanceled => 'Canceled';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusConf => 'Conf';

  @override
  String get bookingStatusPend => 'Pend';

  @override
  String get bookingStatusDone => 'Done';

  @override
  String get bookingStatusCanc => 'Canc';

  @override
  String get noBookingsMatchYourSearch => 'No bookings match your search';

  @override
  String get noPendingBookings => 'No pending bookings';

  @override
  String get noConfirmedBookings => 'No confirmed bookings';

  @override
  String get noCanceledBookings => 'No canceled bookings';
}
