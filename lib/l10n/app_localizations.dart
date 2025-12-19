import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Sport Kick'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Book Your Football Field Instantly'**
  String get appTagline;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmationMessage;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone Number (Optional)'**
  String get phoneOptional;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @fieldOwner.
  ///
  /// In en, this message translates to:
  /// **'Field Owner'**
  String get fieldOwner;

  /// No description provided for @loginAsUser.
  ///
  /// In en, this message translates to:
  /// **'Login as User'**
  String get loginAsUser;

  /// No description provided for @loginAsAdmin.
  ///
  /// In en, this message translates to:
  /// **'Login as Admin'**
  String get loginAsAdmin;

  /// No description provided for @adminPortalTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Portal'**
  String get adminPortalTitle;

  /// No description provided for @adminPortalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Field Owner & Administrator Access'**
  String get adminPortalSubtitle;

  /// No description provided for @adminPortalLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access the dashboard'**
  String get adminPortalLoginSubtitle;

  /// No description provided for @notAnAdmin.
  ///
  /// In en, this message translates to:
  /// **'Not an admin?'**
  String get notAnAdmin;

  /// No description provided for @userLogin.
  ///
  /// In en, this message translates to:
  /// **'User Login'**
  String get userLogin;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingIn;

  /// No description provided for @currentSession.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentSession;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully'**
  String get loginSuccess;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get registerSuccess;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logoutSuccess;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Email already registered'**
  String get emailAlreadyExists;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get weakPassword;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameTooShort;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalidInput;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordMinChars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinChars;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterName;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createPassword;

  /// No description provided for @reenterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reenterPassword;

  /// No description provided for @passwordRequirementText.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordRequirementText;

  /// No description provided for @termsAndPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to our Terms of Service and Privacy Policy'**
  String get termsAndPrivacyNote;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you a link to reset your password.'**
  String get resetPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @recoverAccount.
  ///
  /// In en, this message translates to:
  /// **'Recover your account'**
  String get recoverAccount;

  /// No description provided for @sendingResetLink.
  ///
  /// In en, this message translates to:
  /// **'Sending reset link...'**
  String get sendingResetLink;

  /// No description provided for @resetEmailSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get resetEmailSentTitle;

  /// No description provided for @resetEmailSentMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset link to your email address. Please check your inbox and follow the instructions.'**
  String get resetEmailSentMessage;

  /// No description provided for @resetLinkExpires.
  ///
  /// In en, this message translates to:
  /// **'Please check your inbox and use the link to reset your password. The link will expire in 1 hour.'**
  String get resetLinkExpires;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @backToUserLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to User Login'**
  String get backToUserLogin;

  /// No description provided for @checkSpamFolder.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the email? Check your spam folder.'**
  String get checkSpamFolder;

  /// No description provided for @passwordTooLong.
  ///
  /// In en, this message translates to:
  /// **'Password must be less than {max} characters'**
  String passwordTooLong(Object max);

  /// No description provided for @passwordNeedUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordNeedUppercase;

  /// No description provided for @passwordNeedLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get passwordNeedLowercase;

  /// No description provided for @passwordNeedNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get passwordNeedNumber;

  /// No description provided for @passwordNeedSpecial.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character'**
  String get passwordNeedSpecial;

  /// No description provided for @passwordStrength.
  ///
  /// In en, this message translates to:
  /// **'Password strength'**
  String get passwordStrength;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get passwordStrengthFair;

  /// No description provided for @passwordStrengthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get passwordStrengthGood;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrengthStrong;

  /// No description provided for @nameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name must be less than {max} characters'**
  String nameTooLong(Object max);

  /// No description provided for @nameLettersOnly.
  ///
  /// In en, this message translates to:
  /// **'Name can only contain letters and spaces'**
  String get nameLettersOnly;

  /// No description provided for @phoneMustBe11Digits.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 11 digits'**
  String get phoneMustBe11Digits;

  /// No description provided for @phoneDigitsOnly.
  ///
  /// In en, this message translates to:
  /// **'Phone number can only contain digits'**
  String get phoneDigitsOnly;

  /// No description provided for @phoneMustStartWith01.
  ///
  /// In en, this message translates to:
  /// **'Phone number must start with 01'**
  String get phoneMustStartWith01;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get enterValidNumber;

  /// No description provided for @numberAtLeast.
  ///
  /// In en, this message translates to:
  /// **'Number must be at least {min}'**
  String numberAtLeast(Object min);

  /// No description provided for @numberAtMost.
  ///
  /// In en, this message translates to:
  /// **'Number must be at most {max}'**
  String numberAtMost(Object max);

  /// No description provided for @enterValidInteger.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid whole number'**
  String get enterValidInteger;

  /// No description provided for @minLengthChars.
  ///
  /// In en, this message translates to:
  /// **'Must be at least {length} characters'**
  String minLengthChars(Object length);

  /// No description provided for @maxLengthChars.
  ///
  /// In en, this message translates to:
  /// **'Must be at most {length} characters'**
  String maxLengthChars(Object length);

  /// No description provided for @exactLengthChars.
  ///
  /// In en, this message translates to:
  /// **'Must be exactly {length} characters'**
  String exactLengthChars(Object length);

  /// No description provided for @enterValidUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get enterValidUrl;

  /// No description provided for @fields.
  ///
  /// In en, this message translates to:
  /// **'Fields'**
  String get fields;

  /// No description provided for @fieldDetails.
  ///
  /// In en, this message translates to:
  /// **'Field Details'**
  String get fieldDetails;

  /// No description provided for @searchFields.
  ///
  /// In en, this message translates to:
  /// **'Search fields...'**
  String get searchFields;

  /// No description provided for @filterFields.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterFields;

  /// No description provided for @noFieldsFound.
  ///
  /// In en, this message translates to:
  /// **'No fields found'**
  String get noFieldsFound;

  /// No description provided for @pricePerHour.
  ///
  /// In en, this message translates to:
  /// **'Price per hour'**
  String get pricePerHour;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @facilities.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// No description provided for @surfaceType.
  ///
  /// In en, this message translates to:
  /// **'Surface Type'**
  String get surfaceType;

  /// No description provided for @fieldSize.
  ///
  /// In en, this message translates to:
  /// **'Field Size'**
  String get fieldSize;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @fieldNotFound.
  ///
  /// In en, this message translates to:
  /// **'Field not found'**
  String get fieldNotFound;

  /// No description provided for @loadingFields.
  ///
  /// In en, this message translates to:
  /// **'Loading fields...'**
  String get loadingFields;

  /// No description provided for @refreshFields.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshFields;

  /// No description provided for @browseFields.
  ///
  /// In en, this message translates to:
  /// **'Browse Fields'**
  String get browseFields;

  /// No description provided for @searchFieldsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Fields'**
  String get searchFieldsTitle;

  /// No description provided for @searchByNameCityAddress.
  ///
  /// In en, this message translates to:
  /// **'Search by name, city, or address...'**
  String get searchByNameCityAddress;

  /// No description provided for @filtersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @filtersApplied.
  ///
  /// In en, this message translates to:
  /// **'Filters applied!'**
  String get filtersApplied;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @activeFiltersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String activeFiltersCount(Object count);

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @perHour.
  ///
  /// In en, this message translates to:
  /// **'per hour'**
  String get perHour;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @sortRelevance.
  ///
  /// In en, this message translates to:
  /// **'Relevance'**
  String get sortRelevance;

  /// No description provided for @sortPriceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get sortPriceLowToHigh;

  /// No description provided for @sortPriceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get sortPriceHighToLow;

  /// No description provided for @sortRating.
  ///
  /// In en, this message translates to:
  /// **'Highest Rated'**
  String get sortRating;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get sortNewest;

  /// No description provided for @sortPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get sortPopular;

  /// No description provided for @noFieldsFoundForQuery.
  ///
  /// In en, this message translates to:
  /// **'No fields found for \"{query}\"'**
  String noFieldsFoundForQuery(Object query);

  /// No description provided for @searchTryDifferentKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try searching with different keywords'**
  String get searchTryDifferentKeywords;

  /// No description provided for @searchResultsForQuery.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} result for \"{query}\"} other {{count} results for \"{query}\"}}'**
  String searchResultsForQuery(num count, Object query);

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @searchForFields.
  ///
  /// In en, this message translates to:
  /// **'Search for fields'**
  String get searchForFields;

  /// No description provided for @searchByNameCityAddressDescription.
  ///
  /// In en, this message translates to:
  /// **'Find fields by name, city, or address'**
  String get searchByNameCityAddressDescription;

  /// No description provided for @searchTipFieldNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Field Name'**
  String get searchTipFieldNameTitle;

  /// No description provided for @searchTipFieldNameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., \"Cairo Stadium\", \"Zamalek Arena\"'**
  String get searchTipFieldNameExample;

  /// No description provided for @searchTipCityTitle.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get searchTipCityTitle;

  /// No description provided for @searchTipCityExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., \"Cairo\", \"Alexandria\", \"Giza\"'**
  String get searchTipCityExample;

  /// No description provided for @searchTipAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get searchTipAddressTitle;

  /// No description provided for @searchTipAddressExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., \"Nasr City\", \"Zamalek\"'**
  String get searchTipAddressExample;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @fieldsMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Fields Map'**
  String get fieldsMapTitle;

  /// No description provided for @fieldsMapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore nearby football fields'**
  String get fieldsMapSubtitle;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @favoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fields you love'**
  String get favoritesSubtitle;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// No description provided for @favoritesHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart icon on any field to save it here for quick access later'**
  String get favoritesHint;

  /// No description provided for @exploreFields.
  ///
  /// In en, this message translates to:
  /// **'Explore Fields'**
  String get exploreFields;

  /// No description provided for @favoritesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart icon on any field to add it to your favorites'**
  String get favoritesEmptySubtitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No favorite fields yet'**
  String get favoritesEmpty;

  /// No description provided for @beFirstReview.
  ///
  /// In en, this message translates to:
  /// **'Be the first to review this field'**
  String get beFirstReview;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @reviewsTitleFull.
  ///
  /// In en, this message translates to:
  /// **'Reviews & Ratings'**
  String get reviewsTitleFull;

  /// No description provided for @favoritesSavedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} field saved} other {{count} fields saved}}'**
  String favoritesSavedCount(num count);

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// No description provided for @shareField.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareField;

  /// No description provided for @shareFieldSubject.
  ///
  /// In en, this message translates to:
  /// **'Check out {fieldName} on SpoKick'**
  String shareFieldSubject(Object fieldName);

  /// No description provided for @shareFieldMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out {fieldName}!\n\n{description}\n📍 {address}, {city}\n💰 {price}\n⭐ {rating}\n\nBook now on SpoKick!'**
  String shareFieldMessage(
    Object address,
    Object city,
    Object description,
    Object fieldName,
    Object price,
    Object rating,
  );

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @recentReviews.
  ///
  /// In en, this message translates to:
  /// **'Recent Reviews'**
  String get recentReviews;

  /// No description provided for @failedToLoadReviews.
  ///
  /// In en, this message translates to:
  /// **'Failed to load reviews'**
  String get failedToLoadReviews;

  /// No description provided for @reviewsSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} review} other {{count} reviews}}'**
  String reviewsSummary(num count);

  /// No description provided for @feature.
  ///
  /// In en, this message translates to:
  /// **'Feature'**
  String get feature;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @surface.
  ///
  /// In en, this message translates to:
  /// **'Surface'**
  String get surface;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @popularity.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get popularity;

  /// No description provided for @noneListed.
  ///
  /// In en, this message translates to:
  /// **'None listed'**
  String get noneListed;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @removeFromFavoritesQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites?'**
  String get removeFromFavoritesQuestion;

  /// No description provided for @removeFromFavoritesBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove \"{name}\" from your favorites?'**
  String removeFromFavoritesBody(Object name);

  /// No description provided for @manageFields.
  ///
  /// In en, this message translates to:
  /// **'Manage Fields'**
  String get manageFields;

  /// No description provided for @manageFieldsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage all your fields'**
  String get manageFieldsSubtitle;

  /// No description provided for @searchFieldsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or location...'**
  String get searchFieldsHint;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @failedToLoadFields.
  ///
  /// In en, this message translates to:
  /// **'Failed to load fields'**
  String get failedToLoadFields;

  /// No description provided for @addField.
  ///
  /// In en, this message translates to:
  /// **'Add Field'**
  String get addField;

  /// No description provided for @noFieldsMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No fields match your search'**
  String get noFieldsMatchSearch;

  /// No description provided for @noActiveFields.
  ///
  /// In en, this message translates to:
  /// **'No active fields'**
  String get noActiveFields;

  /// No description provided for @noInactiveFields.
  ///
  /// In en, this message translates to:
  /// **'No inactive fields'**
  String get noInactiveFields;

  /// No description provided for @noFields.
  ///
  /// In en, this message translates to:
  /// **'No fields yet'**
  String get noFields;

  /// No description provided for @addFirstField.
  ///
  /// In en, this message translates to:
  /// **'Add your first field to get started'**
  String get addFirstField;

  /// No description provided for @deleteFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Field'**
  String get deleteFieldTitle;

  /// No description provided for @deleteFieldMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{fieldName}\"? This action cannot be undone.'**
  String deleteFieldMessage(Object fieldName);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize your experience'**
  String get settingsSubtitle;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @businessHours.
  ///
  /// In en, this message translates to:
  /// **'Business Hours'**
  String get businessHours;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSection;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @emailNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications via email'**
  String get emailNotificationsDesc;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive push notifications on your device'**
  String get pushNotificationsDesc;

  /// No description provided for @bookingAlerts.
  ///
  /// In en, this message translates to:
  /// **'Booking Alerts'**
  String get bookingAlerts;

  /// No description provided for @bookingAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified for new bookings'**
  String get bookingAlertsDesc;

  /// No description provided for @instantNotifications.
  ///
  /// In en, this message translates to:
  /// **'Instant Notifications'**
  String get instantNotifications;

  /// No description provided for @instantNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications immediately'**
  String get instantNotificationsDesc;

  /// No description provided for @bookingPreferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Booking Preferences'**
  String get bookingPreferencesSection;

  /// No description provided for @autoApproveBookings.
  ///
  /// In en, this message translates to:
  /// **'Auto-Approve Bookings'**
  String get autoApproveBookings;

  /// No description provided for @autoApproveBookingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically confirm new bookings'**
  String get autoApproveBookingsDesc;

  /// No description provided for @bookingRules.
  ///
  /// In en, this message translates to:
  /// **'Booking Rules'**
  String get bookingRules;

  /// No description provided for @pricingSettings.
  ///
  /// In en, this message translates to:
  /// **'Pricing Settings'**
  String get pricingSettings;

  /// No description provided for @securitySection.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securitySection;

  /// No description provided for @loginActivity.
  ///
  /// In en, this message translates to:
  /// **'Login Activity'**
  String get loginActivity;

  /// No description provided for @activeSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get activeSessions;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @configure.
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get configure;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get viewHistory;

  /// No description provided for @businessHoursSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Hours'**
  String get businessHoursSheetTitle;

  /// No description provided for @businessHoursSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set your operating hours'**
  String get businessHoursSheetSubtitle;

  /// No description provided for @businessHoursPerField.
  ///
  /// In en, this message translates to:
  /// **'Business Hours per Field'**
  String get businessHoursPerField;

  /// No description provided for @businessHoursPerFieldDesc.
  ///
  /// In en, this message translates to:
  /// **'Business Hours are set individually for each field. Go to your Fields list and select a field to manage its operating hours.'**
  String get businessHoursPerFieldDesc;

  /// No description provided for @goToMyFields.
  ///
  /// In en, this message translates to:
  /// **'Go to My Fields'**
  String get goToMyFields;

  /// No description provided for @addFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Field'**
  String get addFieldTitle;

  /// No description provided for @addFieldSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new football field'**
  String get addFieldSubtitle;

  /// No description provided for @createFieldRestrictedMessage.
  ///
  /// In en, this message translates to:
  /// **'Creating new fields is currently restricted to Admins.'**
  String get createFieldRestrictedMessage;

  /// No description provided for @editFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Field'**
  String get editFieldTitle;

  /// No description provided for @updateFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Update {fieldName}'**
  String updateFieldTitle(Object fieldName);

  /// No description provided for @updatingFieldMessage.
  ///
  /// In en, this message translates to:
  /// **'Updating field...'**
  String get updatingFieldMessage;

  /// No description provided for @updateFieldDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update details for {fieldName}'**
  String updateFieldDetailsSubtitle(Object fieldName);

  /// No description provided for @bookingTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Table'**
  String get bookingTableTitle;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// No description provided for @businessHoursMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'Business hours missing'**
  String get businessHoursMissingTitle;

  /// No description provided for @businessHoursMissingBody.
  ///
  /// In en, this message translates to:
  /// **'Set hours for {fieldName} to enable booking slots.'**
  String businessHoursMissingBody(Object fieldName);

  /// No description provided for @setUp.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get setUp;

  /// No description provided for @failedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get failedToLoad;

  /// No description provided for @myLocation.
  ///
  /// In en, this message translates to:
  /// **'My Location'**
  String get myLocation;

  /// No description provided for @mapCenteredOnLocation.
  ///
  /// In en, this message translates to:
  /// **'Centered on your location'**
  String get mapCenteredOnLocation;

  /// No description provided for @noFieldsMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No fields match your filters'**
  String get noFieldsMatchFilters;

  /// No description provided for @noFieldsWithLocation.
  ///
  /// In en, this message translates to:
  /// **'No fields with location data available'**
  String get noFieldsWithLocation;

  /// No description provided for @filtered.
  ///
  /// In en, this message translates to:
  /// **'Filtered'**
  String get filtered;

  /// No description provided for @verifiedFieldsOnly.
  ///
  /// In en, this message translates to:
  /// **'Verified Fields Only'**
  String get verifiedFieldsOnly;

  /// No description provided for @verifiedFieldsDescription.
  ///
  /// In en, this message translates to:
  /// **'Show only verified fields'**
  String get verifiedFieldsDescription;

  /// No description provided for @sortByDistance.
  ///
  /// In en, this message translates to:
  /// **'Sort by Distance'**
  String get sortByDistance;

  /// No description provided for @sortByDistanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Show nearest fields first'**
  String get sortByDistanceDescription;

  /// No description provided for @minimumRating.
  ///
  /// In en, this message translates to:
  /// **'Minimum Rating'**
  String get minimumRating;

  /// No description provided for @anyOption.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get anyOption;

  /// No description provided for @maximumPricePerHour.
  ///
  /// In en, this message translates to:
  /// **'Maximum Price (per hour)'**
  String get maximumPricePerHour;

  /// No description provided for @surfaceGrass.
  ///
  /// In en, this message translates to:
  /// **'Grass'**
  String get surfaceGrass;

  /// No description provided for @surfaceTurf.
  ///
  /// In en, this message translates to:
  /// **'Turf'**
  String get surfaceTurf;

  /// No description provided for @indoor.
  ///
  /// In en, this message translates to:
  /// **'Indoor'**
  String get indoor;

  /// No description provided for @outdoor.
  ///
  /// In en, this message translates to:
  /// **'Outdoor'**
  String get outdoor;

  /// No description provided for @fieldsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} Field} other {{count} Fields}}'**
  String fieldsCount(num count);

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @noImage.
  ///
  /// In en, this message translates to:
  /// **'No Image'**
  String get noImage;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @changingRooms.
  ///
  /// In en, this message translates to:
  /// **'Changing Rooms'**
  String get changingRooms;

  /// No description provided for @lockers.
  ///
  /// In en, this message translates to:
  /// **'Lockers'**
  String get lockers;

  /// No description provided for @showers.
  ///
  /// In en, this message translates to:
  /// **'Showers'**
  String get showers;

  /// No description provided for @toilets.
  ///
  /// In en, this message translates to:
  /// **'Toilets'**
  String get toilets;

  /// No description provided for @lighting.
  ///
  /// In en, this message translates to:
  /// **'Lighting'**
  String get lighting;

  /// No description provided for @seating.
  ///
  /// In en, this message translates to:
  /// **'Seating'**
  String get seating;

  /// No description provided for @scoreboard.
  ///
  /// In en, this message translates to:
  /// **'Scoreboard'**
  String get scoreboard;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get wifi;

  /// No description provided for @cafeteria.
  ///
  /// In en, this message translates to:
  /// **'Cafeteria'**
  String get cafeteria;

  /// No description provided for @refreshments.
  ///
  /// In en, this message translates to:
  /// **'Refreshments'**
  String get refreshments;

  /// No description provided for @firstAid.
  ///
  /// In en, this message translates to:
  /// **'First Aid'**
  String get firstAid;

  /// No description provided for @equipmentRental.
  ///
  /// In en, this message translates to:
  /// **'Equipment Rental'**
  String get equipmentRental;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @trackBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your upcoming and past bookings'**
  String get trackBookingsSubtitle;

  /// No description provided for @createBooking.
  ///
  /// In en, this message translates to:
  /// **'Create Booking'**
  String get createBooking;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @availableSlots.
  ///
  /// In en, this message translates to:
  /// **'Available Time Slots'**
  String get availableSlots;

  /// No description provided for @noSlotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No slots available'**
  String get noSlotsAvailable;

  /// No description provided for @bookingDate.
  ///
  /// In en, this message translates to:
  /// **'Booking Date'**
  String get bookingDate;

  /// No description provided for @bookingTime.
  ///
  /// In en, this message translates to:
  /// **'Booking Time'**
  String get bookingTime;

  /// No description provided for @dateTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateTimeLabel;

  /// No description provided for @timeSlot.
  ///
  /// In en, this message translates to:
  /// **'Time Slot'**
  String get timeSlot;

  /// No description provided for @field.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get field;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @bookingStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get bookingStatus;

  /// No description provided for @bookingTimeline.
  ///
  /// In en, this message translates to:
  /// **'Booking Timeline'**
  String get bookingTimeline;

  /// No description provided for @bookingNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get bookingNotes;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @emailClientUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not open email client. Please contact {email}'**
  String emailClientUnavailable(Object email);

  /// No description provided for @emailClientOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to open email client'**
  String get emailClientOpenFailed;

  /// No description provided for @noBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get noBookingsYet;

  /// No description provided for @chooseAnotherDate.
  ///
  /// In en, this message translates to:
  /// **'Choose Another Date'**
  String get chooseAnotherDate;

  /// No description provided for @bookingCreated.
  ///
  /// In en, this message translates to:
  /// **'Booking created successfully'**
  String get bookingCreated;

  /// No description provided for @bookingConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingConfirmedTitle;

  /// No description provided for @bookingConfirmedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your booking has been successfully placed.\nYou will receive a confirmation shortly.'**
  String get bookingConfirmedDescription;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled'**
  String get bookingCancelled;

  /// No description provided for @cancelBookingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking?'**
  String get cancelBookingConfirm;

  /// No description provided for @cannotCancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cannot cancel this booking'**
  String get cannotCancelBooking;

  /// No description provided for @bookingAlreadyCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking already cancelled'**
  String get bookingAlreadyCancelled;

  /// No description provided for @cancellationReason.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason'**
  String get cancellationReason;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @bookFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Field'**
  String get bookFieldTitle;

  /// No description provided for @chooseTime.
  ///
  /// In en, this message translates to:
  /// **'Choose Time'**
  String get chooseTime;

  /// No description provided for @selectDateFirstMessage.
  ///
  /// In en, this message translates to:
  /// **'Please select a date first'**
  String get selectDateFirstMessage;

  /// No description provided for @selectTimeSlotFirstMessage.
  ///
  /// In en, this message translates to:
  /// **'Please select a time slot'**
  String get selectTimeSlotFirstMessage;

  /// No description provided for @reviewBooking.
  ///
  /// In en, this message translates to:
  /// **'Review Booking'**
  String get reviewBooking;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @selectTimeSlotPrompt.
  ///
  /// In en, this message translates to:
  /// **'Select a Time Slot'**
  String get selectTimeSlotPrompt;

  /// No description provided for @creatingBooking.
  ///
  /// In en, this message translates to:
  /// **'Creating your booking...'**
  String get creatingBooking;

  /// No description provided for @pleaseWaitMoment.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment'**
  String get pleaseWaitMoment;

  /// No description provided for @loadingSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Loading subscriptions...'**
  String get loadingSubscriptions;

  /// No description provided for @totalWithHours.
  ///
  /// In en, this message translates to:
  /// **'Total ({hours}h)'**
  String totalWithHours(Object hours);

  /// No description provided for @confirmYourBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Your Booking'**
  String get confirmYourBooking;

  /// No description provided for @reviewBookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Please review your booking details before confirming.'**
  String get reviewBookingDetails;

  /// No description provided for @bookingTermsNotice.
  ///
  /// In en, this message translates to:
  /// **'By confirming, you agree to our booking terms and cancellation policy.'**
  String get bookingTermsNotice;

  /// No description provided for @footballField.
  ///
  /// In en, this message translates to:
  /// **'Football Field'**
  String get footballField;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, one {{hours} hour} other {{hours} hours}}'**
  String durationHours(num hours);

  /// No description provided for @ratePerHour.
  ///
  /// In en, this message translates to:
  /// **'Rate per hour'**
  String get ratePerHour;

  /// No description provided for @priceBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Price Breakdown'**
  String get priceBreakdown;

  /// No description provided for @selectedDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected: {date}'**
  String selectedDateLabel(Object date);

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @bookingDuration.
  ///
  /// In en, this message translates to:
  /// **'Booking Duration'**
  String get bookingDuration;

  /// No description provided for @durationRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get durationRecommended;

  /// No description provided for @durationBestValue.
  ///
  /// In en, this message translates to:
  /// **'Best Value'**
  String get durationBestValue;

  /// No description provided for @durationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available for this time slot'**
  String get durationUnavailable;

  /// No description provided for @sendPaymentToNumber.
  ///
  /// In en, this message translates to:
  /// **'Send payment to this number'**
  String get sendPaymentToNumber;

  /// No description provided for @paymentPhone.
  ///
  /// In en, this message translates to:
  /// **'Payment Phone'**
  String get paymentPhone;

  /// No description provided for @paymentPhoneMissing.
  ///
  /// In en, this message translates to:
  /// **'Payment phone not configured. Please contact the field owner.'**
  String get paymentPhoneMissing;

  /// No description provided for @paymentInstructions.
  ///
  /// In en, this message translates to:
  /// **'Payment Instructions'**
  String get paymentInstructions;

  /// No description provided for @phoneCopied.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied: {phone}'**
  String phoneCopied(Object phone);

  /// No description provided for @paymentProof.
  ///
  /// In en, this message translates to:
  /// **'Payment Proof'**
  String get paymentProof;

  /// No description provided for @selectPaymentProof.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Proof'**
  String get selectPaymentProof;

  /// No description provided for @choosePaymentUploadMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose how to upload your payment screenshot'**
  String get choosePaymentUploadMethod;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @capturePaymentScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Capture payment screenshot'**
  String get capturePaymentScreenshot;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @selectExistingScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Select existing screenshot'**
  String get selectExistingScreenshot;

  /// No description provided for @uploadPaymentScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Upload Payment Screenshot'**
  String get uploadPaymentScreenshot;

  /// No description provided for @paymentUploadHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to take a photo or select from gallery'**
  String get paymentUploadHint;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @uploadedLabel.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploadedLabel;

  /// No description provided for @tapToView.
  ///
  /// In en, this message translates to:
  /// **'Tap to view'**
  String get tapToView;

  /// No description provided for @uploadedOn.
  ///
  /// In en, this message translates to:
  /// **'Uploaded on {date}'**
  String uploadedOn(Object date);

  /// No description provided for @uploadingPaymentProof.
  ///
  /// In en, this message translates to:
  /// **'Uploading Payment Proof...'**
  String get uploadingPaymentProof;

  /// No description provided for @paymentUploadWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we upload your screenshot'**
  String get paymentUploadWait;

  /// No description provided for @paymentAwaitingVerification.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Verification'**
  String get paymentAwaitingVerification;

  /// No description provided for @paymentRejected.
  ///
  /// In en, this message translates to:
  /// **'Payment Rejected'**
  String get paymentRejected;

  /// No description provided for @paymentRequired.
  ///
  /// In en, this message translates to:
  /// **'Payment Required'**
  String get paymentRequired;

  /// No description provided for @paymentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatusLabel;

  /// No description provided for @paymentStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get paymentStatusPending;

  /// No description provided for @paymentStatusUploaded.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Verification'**
  String get paymentStatusUploaded;

  /// No description provided for @paymentStatusVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get paymentStatusVerified;

  /// No description provided for @paymentStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get paymentStatusRejected;

  /// No description provided for @paymentProofSubmittedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your payment proof has been submitted. The field owner will verify it shortly.'**
  String get paymentProofSubmittedMessage;

  /// No description provided for @paymentVerified.
  ///
  /// In en, this message translates to:
  /// **'Payment Verified'**
  String get paymentVerified;

  /// No description provided for @paymentVerifiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your payment has been verified by the field owner. Enjoy your game!'**
  String get paymentVerifiedMessage;

  /// No description provided for @verifiedOn.
  ///
  /// In en, this message translates to:
  /// **'Verified on {date}'**
  String verifiedOn(Object date);

  /// No description provided for @invoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoiceTitle;

  /// No description provided for @invoiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get invoiceDetails;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @invoiceCopied.
  ///
  /// In en, this message translates to:
  /// **'Invoice number copied: {number}'**
  String invoiceCopied(Object number);

  /// No description provided for @viewInvoiceAndPay.
  ///
  /// In en, this message translates to:
  /// **'View Invoice & Pay'**
  String get viewInvoiceAndPay;

  /// No description provided for @viewMyBookings.
  ///
  /// In en, this message translates to:
  /// **'View My Bookings'**
  String get viewMyBookings;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @noUpcomingBookings.
  ///
  /// In en, this message translates to:
  /// **'No upcoming bookings'**
  String get noUpcomingBookings;

  /// No description provided for @noBookingHistory.
  ///
  /// In en, this message translates to:
  /// **'No booking history'**
  String get noBookingHistory;

  /// No description provided for @bookingId.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingId;

  /// No description provided for @bookingIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Booking ID copied to clipboard'**
  String get bookingIdCopied;

  /// No description provided for @availableTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'Available Time Slots'**
  String get availableTimeSlots;

  /// No description provided for @allSlotsBookedMessage.
  ///
  /// In en, this message translates to:
  /// **'All time slots for this date are booked. Try selecting a different date.'**
  String get allSlotsBookedMessage;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @lateNight.
  ///
  /// In en, this message translates to:
  /// **'Late Night'**
  String get lateNight;

  /// No description provided for @availableCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} available} other {{count} available}}'**
  String availableCount(num count);

  /// No description provided for @bookedLabel.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get bookedLabel;

  /// No description provided for @cancelReasonOptional.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get cancelReasonOptional;

  /// No description provided for @cancelReasonPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Why are you cancelling?'**
  String get cancelReasonPlaceholder;

  /// No description provided for @keepBooking.
  ///
  /// In en, this message translates to:
  /// **'Keep Booking'**
  String get keepBooking;

  /// No description provided for @noRecurringSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'No recurring subscriptions'**
  String get noRecurringSubscriptions;

  /// No description provided for @recurringSlotHint.
  ///
  /// In en, this message translates to:
  /// **'Reserve a weekly slot and never miss a game!'**
  String get recurringSlotHint;

  /// No description provided for @createSubscription.
  ///
  /// In en, this message translates to:
  /// **'Create Subscription'**
  String get createSubscription;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @pendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get pendingApproval;

  /// No description provided for @cancelSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription?'**
  String get cancelSubscriptionTitle;

  /// No description provided for @cancelSubscriptionBody.
  ///
  /// In en, this message translates to:
  /// **'Bookings within the next 7 days will still be honored. Only future bookings will be canceled.'**
  String get cancelSubscriptionBody;

  /// No description provided for @canceledByUser.
  ///
  /// In en, this message translates to:
  /// **'Canceled by user'**
  String get canceledByUser;

  /// No description provided for @slotAlreadyBooked.
  ///
  /// In en, this message translates to:
  /// **'This time slot is already booked'**
  String get slotAlreadyBooked;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get statusUpcoming;

  /// No description provided for @historyTab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTab;

  /// No description provided for @recurringTab.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurringTab;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write Review'**
  String get writeReview;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @yourReview.
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get yourReview;

  /// No description provided for @rateField.
  ///
  /// In en, this message translates to:
  /// **'Rate this field'**
  String get rateField;

  /// No description provided for @noReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviews;

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted successfully'**
  String get reviewSubmitted;

  /// No description provided for @selectRating.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating'**
  String get selectRating;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @bookingConfirmations.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmations'**
  String get bookingConfirmations;

  /// No description provided for @bookingReminders.
  ///
  /// In en, this message translates to:
  /// **'Booking Reminders'**
  String get bookingReminders;

  /// No description provided for @statusUpdates.
  ///
  /// In en, this message translates to:
  /// **'Status Updates'**
  String get statusUpdates;

  /// No description provided for @fieldOwnerMessages.
  ///
  /// In en, this message translates to:
  /// **'Field Owner Messages'**
  String get fieldOwnerMessages;

  /// No description provided for @bookingConfirmationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when bookings are confirmed'**
  String get bookingConfirmationsDesc;

  /// No description provided for @bookingRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Get reminded 1 hour before your booking'**
  String get bookingRemindersDesc;

  /// No description provided for @statusUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified of booking status changes'**
  String get statusUpdatesDesc;

  /// No description provided for @fieldOwnerMessagesDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified of messages from field owners'**
  String get fieldOwnerMessagesDesc;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @helpSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Email us your questions'**
  String get helpSupportDesc;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date Format'**
  String get dateFormat;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @bookingsSettings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookingsSettings;

  /// No description provided for @appearanceSettings.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSettings;

  /// No description provided for @notificationsSettings.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSettings;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacySettings;

  /// No description provided for @securitySettings.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securitySettings;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSettings;

  /// No description provided for @aboutSettings.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSettings;

  /// No description provided for @noPreferencesLoaded.
  ///
  /// In en, this message translates to:
  /// **'No preferences loaded'**
  String get noPreferencesLoaded;

  /// No description provided for @settingsUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Settings updated successfully'**
  String get settingsUpdatedSuccess;

  /// No description provided for @weeklySubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Weekly Subscriptions'**
  String get weeklySubscriptions;

  /// No description provided for @weeklySubscriptionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your recurring bookings'**
  String get weeklySubscriptionsDesc;

  /// No description provided for @bookingsHistory.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get bookingsHistory;

  /// No description provided for @bookingsHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'View your booking history'**
  String get bookingsHistoryDesc;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @favoritesDesc.
  ///
  /// In en, this message translates to:
  /// **'View your favorite fields'**
  String get favoritesDesc;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @showProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Show Profile Picture'**
  String get showProfilePicture;

  /// No description provided for @showProfilePictureDesc.
  ///
  /// In en, this message translates to:
  /// **'Display your profile picture to field owners'**
  String get showProfilePictureDesc;

  /// No description provided for @showPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Show Phone Number'**
  String get showPhoneNumber;

  /// No description provided for @showPhoneNumberDesc.
  ///
  /// In en, this message translates to:
  /// **'Display your phone number to field owners'**
  String get showPhoneNumberDesc;

  /// No description provided for @showEmail.
  ///
  /// In en, this message translates to:
  /// **'Show Email'**
  String get showEmail;

  /// No description provided for @showEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'Display your email to field owners'**
  String get showEmailDesc;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @loginActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'View your recent login history'**
  String get loginActivityDesc;

  /// No description provided for @activeSessionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your logged-in devices'**
  String get activeSessionsDesc;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @editProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get editProfileDesc;

  /// No description provided for @changePasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get changePasswordDesc;

  /// No description provided for @passwordRequirementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Password must contain:'**
  String get passwordRequirementsTitle;

  /// No description provided for @requirement8Chars.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get requirement8Chars;

  /// No description provided for @requirementUppercase.
  ///
  /// In en, this message translates to:
  /// **'One uppercase letter'**
  String get requirementUppercase;

  /// No description provided for @requirementLowercase.
  ///
  /// In en, this message translates to:
  /// **'One lowercase letter'**
  String get requirementLowercase;

  /// No description provided for @requirementNumber.
  ///
  /// In en, this message translates to:
  /// **'One number'**
  String get requirementNumber;

  /// No description provided for @requirementSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'One special character'**
  String get requirementSpecialChar;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @couldNotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link'**
  String get couldNotOpenLink;

  /// No description provided for @errorOpeningLink.
  ///
  /// In en, this message translates to:
  /// **'Error opening link: {error}'**
  String errorOpeningLink(Object error);

  /// No description provided for @noLoginActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'No Login Activity'**
  String get noLoginActivityTitle;

  /// No description provided for @noLoginActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your login history will appear here'**
  String get noLoginActivitySubtitle;

  /// No description provided for @loginStatusSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get loginStatusSuccess;

  /// No description provided for @loginStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get loginStatusFailed;

  /// No description provided for @loginStatusBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get loginStatusBlocked;

  /// No description provided for @deviceTypeMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get deviceTypeMobile;

  /// No description provided for @deviceTypeWeb.
  ///
  /// In en, this message translates to:
  /// **'Web'**
  String get deviceTypeWeb;

  /// No description provided for @deviceTypeDesktop.
  ///
  /// In en, this message translates to:
  /// **'Desktop'**
  String get deviceTypeDesktop;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String minutesAgo(Object minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String hoursAgo(Object hours);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(Object days);

  /// No description provided for @loginDateTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'{date} • {time}'**
  String loginDateTimeFormat(Object date, Object time);

  /// No description provided for @adminAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access Denied: You don\'t have admin privileges. Redirecting to user dashboard.'**
  String get adminAccessDenied;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInSubtitle;

  /// No description provided for @welcomeBackHeader.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBackHeader;

  /// No description provided for @loggingInMessage.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingInMessage;

  /// No description provided for @joinNow.
  ///
  /// In en, this message translates to:
  /// **'Join Now'**
  String get joinNow;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get creatingAccount;

  /// No description provided for @loginActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Login Activity'**
  String get loginActivityTitle;

  /// No description provided for @loginActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your recent login history'**
  String get loginActivitySubtitle;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSince;

  /// No description provided for @roleUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get roleUser;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Field Owner'**
  String get roleAdmin;

  /// No description provided for @roleSuperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get roleSuperAdmin;

  /// No description provided for @firstLoginMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Please change your password to continue.'**
  String get firstLoginMessage;

  /// No description provided for @pleaseLoginToViewProfile.
  ///
  /// In en, this message translates to:
  /// **'Please login to view your profile'**
  String get pleaseLoginToViewProfile;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again'**
  String get serverError;

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authError;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @timeoutError.
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get timeoutError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknownError;

  /// No description provided for @operationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Operation completed successfully'**
  String get operationSuccessful;

  /// No description provided for @dataSaved.
  ///
  /// In en, this message translates to:
  /// **'Data saved successfully'**
  String get dataSaved;

  /// No description provided for @dataDeleted.
  ///
  /// In en, this message translates to:
  /// **'Data deleted successfully'**
  String get dataDeleted;

  /// No description provided for @dataUpdated.
  ///
  /// In en, this message translates to:
  /// **'Data updated successfully'**
  String get dataUpdated;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavorites;

  /// No description provided for @emptyList.
  ///
  /// In en, this message translates to:
  /// **'List is empty'**
  String get emptyList;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @todayBookings.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Bookings'**
  String get todayBookings;

  /// No description provided for @upcomingBookings.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Bookings'**
  String get upcomingBookings;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @confirmBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBookingTitle;

  /// No description provided for @rejectBooking.
  ///
  /// In en, this message translates to:
  /// **'Reject Booking'**
  String get rejectBooking;

  /// No description provided for @totalBookings.
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get totalBookings;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get paymentSuccessful;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get paymentFailed;

  /// No description provided for @processingPayment.
  ///
  /// In en, this message translates to:
  /// **'Processing payment...'**
  String get processingPayment;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get thisActionCannotBeUndone;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Find Your Perfect Field'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Browse hundreds of football fields near you'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Book Instantly'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'No more phone calls. Book in seconds'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Play Football'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Show up and enjoy your game'**
  String get onboardingDesc3;

  /// No description provided for @accessibilityMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get accessibilityMenu;

  /// No description provided for @accessibilityClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get accessibilityClose;

  /// No description provided for @accessibilityBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get accessibilityBack;

  /// No description provided for @accessibilitySearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get accessibilitySearch;

  /// No description provided for @accessibilityFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get accessibilityFilter;

  /// No description provided for @accessibilitySort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get accessibilitySort;

  /// No description provided for @ownerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Owner Dashboard'**
  String get ownerDashboard;

  /// No description provided for @ownerProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get ownerProfile;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @myFields.
  ///
  /// In en, this message translates to:
  /// **'My Fields'**
  String get myFields;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @forWalkInCustomers.
  ///
  /// In en, this message translates to:
  /// **'For walk-in customers'**
  String get forWalkInCustomers;

  /// No description provided for @manageBookings.
  ///
  /// In en, this message translates to:
  /// **'Manage Bookings'**
  String get manageBookings;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @revenueAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Revenue Analytics'**
  String get revenueAnalytics;

  /// No description provided for @trackPerformance.
  ///
  /// In en, this message translates to:
  /// **'Track your performance'**
  String get trackPerformance;

  /// No description provided for @customizeExperience.
  ///
  /// In en, this message translates to:
  /// **'Customize your experience'**
  String get customizeExperience;

  /// No description provided for @reviewManageBookings.
  ///
  /// In en, this message translates to:
  /// **'Review and manage all bookings'**
  String get reviewManageBookings;

  /// No description provided for @viewManageFields.
  ///
  /// In en, this message translates to:
  /// **'View and manage all your fields'**
  String get viewManageFields;

  /// No description provided for @updateYourInformation.
  ///
  /// In en, this message translates to:
  /// **'Update your information'**
  String get updateYourInformation;

  /// No description provided for @tabAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get tabAll;

  /// No description provided for @noBookingsFound.
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get noBookingsFound;

  /// No description provided for @noFieldsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No fields available'**
  String get noFieldsAvailable;

  /// No description provided for @addYourFirstField.
  ///
  /// In en, this message translates to:
  /// **'Add Your First Field'**
  String get addYourFirstField;

  /// No description provided for @editField.
  ///
  /// In en, this message translates to:
  /// **'Edit Field'**
  String get editField;

  /// No description provided for @deleteField.
  ///
  /// In en, this message translates to:
  /// **'Delete Field'**
  String get deleteField;

  /// No description provided for @createNewField.
  ///
  /// In en, this message translates to:
  /// **'Create a new football field'**
  String get createNewField;

  /// No description provided for @updateFieldDetails.
  ///
  /// In en, this message translates to:
  /// **'Update details for {fieldName}'**
  String updateFieldDetails(Object fieldName);

  /// No description provided for @fieldActive.
  ///
  /// In en, this message translates to:
  /// **'Field Active'**
  String get fieldActive;

  /// No description provided for @manageBusinessHours.
  ///
  /// In en, this message translates to:
  /// **'Manage Business Hours'**
  String get manageBusinessHours;

  /// No description provided for @setWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Set working hours for each day of the week'**
  String get setWorkingHours;

  /// No description provided for @setOperatingHours.
  ///
  /// In en, this message translates to:
  /// **'Set your operating hours'**
  String get setOperatingHours;

  /// No description provided for @businessHoursMissing.
  ///
  /// In en, this message translates to:
  /// **'Business hours missing'**
  String get businessHoursMissing;

  /// No description provided for @bookingTable.
  ///
  /// In en, this message translates to:
  /// **'Booking Table'**
  String get bookingTable;

  /// No description provided for @goToToday.
  ///
  /// In en, this message translates to:
  /// **'Go to Today'**
  String get goToToday;

  /// No description provided for @fieldIsClosed.
  ///
  /// In en, this message translates to:
  /// **'Field is closed at this time'**
  String get fieldIsClosed;

  /// No description provided for @cannotCreatePastBookings.
  ///
  /// In en, this message translates to:
  /// **'Cannot create bookings for past dates'**
  String get cannotCreatePastBookings;

  /// No description provided for @selectFieldToSeePrice.
  ///
  /// In en, this message translates to:
  /// **'Select field to see price'**
  String get selectFieldToSeePrice;

  /// No description provided for @chooseAField.
  ///
  /// In en, this message translates to:
  /// **'Choose a field'**
  String get chooseAField;

  /// No description provided for @createManualBooking.
  ///
  /// In en, this message translates to:
  /// **'Create Manual Booking'**
  String get createManualBooking;

  /// No description provided for @manualBooking.
  ///
  /// In en, this message translates to:
  /// **'MANUAL'**
  String get manualBooking;

  /// No description provided for @bookingSummary.
  ///
  /// In en, this message translates to:
  /// **'Booking Summary'**
  String get bookingSummary;

  /// No description provided for @customerInformation.
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get customerInformation;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerName;

  /// No description provided for @customerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Customer name is required'**
  String get customerNameRequired;

  /// No description provided for @enterCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Enter customer name'**
  String get enterCustomerName;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get enterEmailAddress;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// No description provided for @addAnyNotes.
  ///
  /// In en, this message translates to:
  /// **'Add any special notes'**
  String get addAnyNotes;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get chooseDate;

  /// No description provided for @addTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Add Time Slot'**
  String get addTimeSlot;

  /// No description provided for @approveBooking.
  ///
  /// In en, this message translates to:
  /// **'Approve Booking'**
  String get approveBooking;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @verifyPayment.
  ///
  /// In en, this message translates to:
  /// **'Verify Payment'**
  String get verifyPayment;

  /// No description provided for @rejectPayment.
  ///
  /// In en, this message translates to:
  /// **'Reject Payment'**
  String get rejectPayment;

  /// No description provided for @viewPaymentProof.
  ///
  /// In en, this message translates to:
  /// **'View Payment Proof'**
  String get viewPaymentProof;

  /// No description provided for @paymentVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment verified successfully'**
  String get paymentVerifiedSuccess;

  /// No description provided for @paymentRejectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment rejected'**
  String get paymentRejectedMessage;

  /// No description provided for @bookingApprovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking approved successfully'**
  String get bookingApprovedSuccess;

  /// No description provided for @bookingRejectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Booking rejected'**
  String get bookingRejectedMessage;

  /// No description provided for @revenueTrendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Revenue Trends'**
  String get revenueTrendsTitle;

  /// No description provided for @revenueTrendsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track revenue over time'**
  String get revenueTrendsSubtitle;

  /// No description provided for @revenueByFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Revenue by Field'**
  String get revenueByFieldTitle;

  /// No description provided for @revenueByFieldSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Top performing fields'**
  String get revenueByFieldSubtitle;

  /// No description provided for @bookingStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Status Breakdown'**
  String get bookingStatusTitle;

  /// No description provided for @bookingStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Distribution of booking statuses'**
  String get bookingStatusSubtitle;

  /// No description provided for @totalRevenueLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenueLabel;

  /// No description provided for @monthlyRevenueLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthlyRevenueLabel;

  /// No description provided for @averageBookingLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg. Booking'**
  String get averageBookingLabel;

  /// No description provided for @totalBookingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get totalBookingsLabel;

  /// No description provided for @pendingBookingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingBookingsLabel;

  /// No description provided for @revenueGrowthLabel.
  ///
  /// In en, this message translates to:
  /// **'Growth Rate'**
  String get revenueGrowthLabel;

  /// No description provided for @topPerformingFields.
  ///
  /// In en, this message translates to:
  /// **'Top Performing Fields'**
  String get topPerformingFields;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get last30Days;

  /// No description provided for @last90Days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 Days'**
  String get last90Days;

  /// No description provided for @lastYear.
  ///
  /// In en, this message translates to:
  /// **'Last Year'**
  String get lastYear;

  /// No description provided for @noDataAvailablePeriod.
  ///
  /// In en, this message translates to:
  /// **'No data available for selected period'**
  String get noDataAvailablePeriod;

  /// No description provided for @createdBy.
  ///
  /// In en, this message translates to:
  /// **'Created By'**
  String get createdBy;

  /// No description provided for @unknownField.
  ///
  /// In en, this message translates to:
  /// **'Unknown Field'**
  String get unknownField;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @createBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Booking'**
  String get createBookingTitle;

  /// No description provided for @createBookingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a manual booking'**
  String get createBookingSubtitle;

  /// No description provided for @bookingStepDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get bookingStepDetails;

  /// No description provided for @bookingStepCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get bookingStepCustomer;

  /// No description provided for @bookingStepConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get bookingStepConfirm;

  /// No description provided for @fieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get fieldLabel;

  /// No description provided for @selectField.
  ///
  /// In en, this message translates to:
  /// **'Select Field'**
  String get selectField;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @totalPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPriceLabel;

  /// No description provided for @enterPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enterPriceHint;

  /// No description provided for @customerInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get customerInfoTitle;

  /// No description provided for @customerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerNameLabel;

  /// No description provided for @enterCustomerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter customer name'**
  String get enterCustomerNameHint;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @enterPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneHint;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @emailOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get emailOptionalLabel;

  /// No description provided for @enterEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get enterEmailHint;

  /// No description provided for @notesOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptionalLabel;

  /// No description provided for @addNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add any special notes'**
  String get addNotesHint;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// No description provided for @notEntered.
  ///
  /// In en, this message translates to:
  /// **'Not entered'**
  String get notEntered;

  /// No description provided for @bookingConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please review the booking details before confirming. This action cannot be undone.'**
  String get bookingConfirmationMessage;

  /// No description provided for @loginToViewProfile.
  ///
  /// In en, this message translates to:
  /// **'Please login to view your profile'**
  String get loginToViewProfile;

  /// No description provided for @loadingStatistics.
  ///
  /// In en, this message translates to:
  /// **'Loading statistics...'**
  String get loadingStatistics;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
