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

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

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

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

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
  /// **'Enter full name'**
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

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

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

  /// No description provided for @autoApproveEnabledTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-Approve Enabled'**
  String get autoApproveEnabledTitle;

  /// No description provided for @autoApproveEnabledMessage.
  ///
  /// In en, this message translates to:
  /// **'All new booking requests will be automatically approved.'**
  String get autoApproveEnabledMessage;

  /// No description provided for @autoApproveDisabledTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-Approve Disabled'**
  String get autoApproveDisabledTitle;

  /// No description provided for @autoApproveDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need to manually approve each booking request.'**
  String get autoApproveDisabledMessage;

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

  /// No description provided for @businessHoursLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading business hours...'**
  String get businessHoursLoading;

  /// No description provided for @businessHoursSetDefaultHours.
  ///
  /// In en, this message translates to:
  /// **'Set Default Hours'**
  String get businessHoursSetDefaultHours;

  /// No description provided for @businessHoursApplyToAllDays.
  ///
  /// In en, this message translates to:
  /// **'Apply to All Days'**
  String get businessHoursApplyToAllDays;

  /// No description provided for @businessHoursApplyToAllDescription.
  ///
  /// In en, this message translates to:
  /// **'This will set the same hours for all 7 days of the week.'**
  String get businessHoursApplyToAllDescription;

  /// No description provided for @businessHoursHelpText.
  ///
  /// In en, this message translates to:
  /// **'Set when your field is available for bookings. You can set different hours for each day of the week.'**
  String get businessHoursHelpText;

  /// No description provided for @businessHoursHelpTimeSelection.
  ///
  /// In en, this message translates to:
  /// **'Select opening and closing times in 15-minute intervals.'**
  String get businessHoursHelpTimeSelection;

  /// No description provided for @businessHoursOpeningTime.
  ///
  /// In en, this message translates to:
  /// **'Opening Time'**
  String get businessHoursOpeningTime;

  /// No description provided for @businessHoursClosingTime.
  ///
  /// In en, this message translates to:
  /// **'Closing Time'**
  String get businessHoursClosingTime;

  /// No description provided for @businessHoursOpen24Hours.
  ///
  /// In en, this message translates to:
  /// **'Open 24 Hours'**
  String get businessHoursOpen24Hours;

  /// No description provided for @businessHoursClosedAllDay.
  ///
  /// In en, this message translates to:
  /// **'Closed All Day'**
  String get businessHoursClosedAllDay;

  /// No description provided for @businessHoursCurrentlyOpen.
  ///
  /// In en, this message translates to:
  /// **'Currently Open'**
  String get businessHoursCurrentlyOpen;

  /// No description provided for @businessHoursCurrentlyClosed.
  ///
  /// In en, this message translates to:
  /// **'Currently Closed'**
  String get businessHoursCurrentlyClosed;

  /// No description provided for @businessHoursAcceptingBookings.
  ///
  /// In en, this message translates to:
  /// **'Your field is currently accepting bookings'**
  String get businessHoursAcceptingBookings;

  /// No description provided for @businessHoursClosedForBookings.
  ///
  /// In en, this message translates to:
  /// **'Your field is currently closed for bookings'**
  String get businessHoursClosedForBookings;

  /// No description provided for @businessHoursUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Business hours updated successfully'**
  String get businessHoursUpdatedSuccess;

  /// No description provided for @businessHoursDefaultHoursSet.
  ///
  /// In en, this message translates to:
  /// **'Default hours (24/7) set for all days'**
  String get businessHoursDefaultHoursSet;

  /// No description provided for @businessHoursInvalidTimeRange.
  ///
  /// In en, this message translates to:
  /// **'Opening time must be before closing time'**
  String get businessHoursInvalidTimeRange;

  /// No description provided for @businessHoursNoHoursSet.
  ///
  /// In en, this message translates to:
  /// **'No business hours set'**
  String get businessHoursNoHoursSet;

  /// No description provided for @businessHoursNoHoursSetDescription.
  ///
  /// In en, this message translates to:
  /// **'Set your field operating hours to allow users to make bookings.'**
  String get businessHoursNoHoursSetDescription;

  /// No description provided for @businessHoursTimeOutsideRange.
  ///
  /// In en, this message translates to:
  /// **'Time is outside business hours'**
  String get businessHoursTimeOutsideRange;

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

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

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
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @hoursLabel.
  ///
  /// In en, this message translates to:
  /// **'{countFormatted} {count, plural, one{hour} other{hours}}'**
  String hoursLabel(num count, Object countFormatted);

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

  /// No description provided for @bookingStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Status Breakdown'**
  String get bookingStatusTitle;

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

  /// No description provided for @failedToLoadBookings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load bookings'**
  String get failedToLoadBookings;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @noContactInfoAvailable.
  ///
  /// In en, this message translates to:
  /// **'No contact info available'**
  String get noContactInfoAvailable;

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

  /// No description provided for @bookingsWillAppearMessage.
  ///
  /// In en, this message translates to:
  /// **'Bookings will appear here once customers start booking your fields'**
  String get bookingsWillAppearMessage;

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

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ll see booking updates and alerts here'**
  String get notificationsEmptySubtitle;

  /// No description provided for @notificationJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notificationJustNow;

  /// No description provided for @notificationMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String notificationMinutesAgo(Object minutes);

  /// No description provided for @notificationHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String notificationHoursAgo(Object hours);

  /// No description provided for @notificationDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String notificationDaysAgo(Object days);

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

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

  /// No description provided for @vsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'vs last month'**
  String get vsLastMonth;

  /// No description provided for @bookingsCount.
  ///
  /// In en, this message translates to:
  /// **'{countFormatted} {count, plural, one{booking} other{bookings}}'**
  String bookingsCount(num count, Object countFormatted);

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

  /// No description provided for @noImagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No images available'**
  String get noImagesAvailable;

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
  /// **'Customer Name *'**
  String get customerNameLabel;

  /// No description provided for @enterCustomerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter customer name'**
  String get enterCustomerNameHint;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number *'**
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

  /// No description provided for @pleaseLoginToManageBusinessHours.
  ///
  /// In en, this message translates to:
  /// **'Please log in to manage business hours'**
  String get pleaseLoginToManageBusinessHours;

  /// No description provided for @youHaveNoFields.
  ///
  /// In en, this message translates to:
  /// **'You have no fields'**
  String get youHaveNoFields;

  /// No description provided for @fieldInactive.
  ///
  /// In en, this message translates to:
  /// **'Field Inactive'**
  String get fieldInactive;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @createManualBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Manual Booking'**
  String get createManualBookingTitle;

  /// No description provided for @manualBookingCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Manual booking created successfully for {customerName}'**
  String manualBookingCreatedSuccess(Object customerName);

  /// No description provided for @manualBookingSelectField.
  ///
  /// In en, this message translates to:
  /// **'Please select a field'**
  String get manualBookingSelectField;

  /// No description provided for @manualBookingSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get manualBookingSelectDate;

  /// No description provided for @manualBookingSelectTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Please select a time slot'**
  String get manualBookingSelectTimeSlot;

  /// No description provided for @manualBookingEnterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price'**
  String get manualBookingEnterValidPrice;

  /// No description provided for @manualBookingEnterCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Please enter customer name'**
  String get manualBookingEnterCustomerName;

  /// No description provided for @manualBookingEnterCustomerPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter customer phone'**
  String get manualBookingEnterCustomerPhone;

  /// No description provided for @bookingDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetailsTitle;

  /// No description provided for @bookingDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select field, date, time, and price'**
  String get bookingDetailsSubtitle;

  /// No description provided for @chooseField.
  ///
  /// In en, this message translates to:
  /// **'Choose a field'**
  String get chooseField;

  /// No description provided for @endTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'End time: {time} ({hours} {hours, plural, one{hour} other{hours}})'**
  String endTimeLabel(num hours, Object time);

  /// No description provided for @priceCalculation.
  ///
  /// In en, this message translates to:
  /// **'{price} EGP/hour × {hours} {hours, plural, one{hour} other{hours}}'**
  String priceCalculation(num hours, Object price);

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @enterFieldName.
  ///
  /// In en, this message translates to:
  /// **'Enter field name'**
  String get enterFieldName;

  /// No description provided for @fieldNameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., Premium Soccer Field'**
  String get fieldNameExample;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get enterDescription;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get enterAddress;

  /// No description provided for @enterCity.
  ///
  /// In en, this message translates to:
  /// **'Enter city'**
  String get enterCity;

  /// No description provided for @citySelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Your City'**
  String get citySelectionTitle;

  /// No description provided for @citySelectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your city to see available football fields'**
  String get citySelectionSubtitle;

  /// No description provided for @cityChangeCity.
  ///
  /// In en, this message translates to:
  /// **'Change City'**
  String get cityChangeCity;

  /// No description provided for @citySelectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get citySelectCity;

  /// No description provided for @citySelectPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please select a city'**
  String get citySelectPrompt;

  /// No description provided for @cityNoCitiesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No cities available'**
  String get cityNoCitiesAvailable;

  /// No description provided for @cityErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cities'**
  String get cityErrorLoading;

  /// No description provided for @cityLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading cities...'**
  String get cityLoading;

  /// No description provided for @citySavingSelection.
  ///
  /// In en, this message translates to:
  /// **'Saving your selection...'**
  String get citySavingSelection;

  /// No description provided for @citySelectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'City selected successfully'**
  String get citySelectedSuccess;

  /// No description provided for @cityContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Please contact support for assistance'**
  String get cityContactSupport;

  /// No description provided for @citySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search cities...'**
  String get citySearchHint;

  /// No description provided for @homeWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get homeWelcomeBack;

  /// No description provided for @homeGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning,'**
  String get homeGoodMorning;

  /// No description provided for @homeGoodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon,'**
  String get homeGoodAfternoon;

  /// No description provided for @homeGoodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening,'**
  String get homeGoodEvening;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @homeGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get homeGuest;

  /// No description provided for @homeProfileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeProfileTooltip;

  /// No description provided for @homeQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get homeQuickActionsTitle;

  /// No description provided for @homeComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get homeComingSoonTitle;

  /// No description provided for @homeMyProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get homeMyProfileTitle;

  /// No description provided for @homeMyProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View & edit'**
  String get homeMyProfileSubtitle;

  /// No description provided for @homeBrowseFieldsTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse Fields'**
  String get homeBrowseFieldsTitle;

  /// No description provided for @homeBrowseFieldsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find fields'**
  String get homeBrowseFieldsSubtitle;

  /// No description provided for @homeMyBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get homeMyBookingsTitle;

  /// No description provided for @homeMyBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View & manage'**
  String get homeMyBookingsSubtitle;

  /// No description provided for @homeFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get homeFavoritesTitle;

  /// No description provided for @homeFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get homeFavoritesSubtitle;

  /// No description provided for @homeFavoritesComingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'Favorites feature coming soon!'**
  String get homeFavoritesComingSoonMessage;

  /// No description provided for @homeExploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Fields'**
  String get homeExploreTitle;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeViewAll;

  /// No description provided for @homeNoFieldsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No fields available'**
  String get homeNoFieldsAvailable;

  /// No description provided for @homeNearbyFieldsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby Fields'**
  String get homeNearbyFieldsTitle;

  /// No description provided for @homeViewMap.
  ///
  /// In en, this message translates to:
  /// **'View Map'**
  String get homeViewMap;

  /// No description provided for @homeNoFieldsNearby.
  ///
  /// In en, this message translates to:
  /// **'No fields nearby'**
  String get homeNoFieldsNearby;

  /// No description provided for @homeTapToViewOnMap.
  ///
  /// In en, this message translates to:
  /// **'Tap to view on map'**
  String get homeTapToViewOnMap;

  /// No description provided for @homeShortcutBrowseTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse\nFields'**
  String get homeShortcutBrowseTitle;

  /// No description provided for @homeShortcutBrowseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find venues'**
  String get homeShortcutBrowseSubtitle;

  /// No description provided for @homeShortcutBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My\nBookings'**
  String get homeShortcutBookingsTitle;

  /// No description provided for @homeShortcutBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get homeShortcutBookingsSubtitle;

  /// No description provided for @homeShortcutFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorite\nFields'**
  String get homeShortcutFavoritesTitle;

  /// No description provided for @homeShortcutFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your picks'**
  String get homeShortcutFavoritesSubtitle;

  /// No description provided for @homeShortcutProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeShortcutProfileTitle;

  /// No description provided for @homeShortcutProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeShortcutProfileSubtitle;

  /// No description provided for @homeUpcomingMatch.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Match'**
  String get homeUpcomingMatch;

  /// No description provided for @homeDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get homeDirections;

  /// No description provided for @homeInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get homeInvite;

  /// No description provided for @homeAddToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to Calendar'**
  String get homeAddToCalendar;

  /// No description provided for @homeNoUpcomingMatches.
  ///
  /// In en, this message translates to:
  /// **'No upcoming matches'**
  String get homeNoUpcomingMatches;

  /// No description provided for @homeErrorLoadingBookings.
  ///
  /// In en, this message translates to:
  /// **'Error loading bookings'**
  String get homeErrorLoadingBookings;

  /// No description provided for @homeBookNextGame.
  ///
  /// In en, this message translates to:
  /// **'Book your next game now!'**
  String get homeBookNextGame;

  /// No description provided for @homeErrorOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Could not open maps'**
  String get homeErrorOpenMaps;

  /// No description provided for @homeErrorAddCalendar.
  ///
  /// In en, this message translates to:
  /// **'Could not add to calendar'**
  String get homeErrorAddCalendar;

  /// No description provided for @homeCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Football at {fieldName}'**
  String homeCalendarTitle(Object fieldName);

  /// No description provided for @homeCalendarDetails.
  ///
  /// In en, this message translates to:
  /// **'Booked via Sport Kick'**
  String get homeCalendarDetails;

  /// No description provided for @homeBookingShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Football at {fieldName}'**
  String homeBookingShareTitle(Object fieldName);

  /// No description provided for @homeBookingShareDescription.
  ///
  /// In en, this message translates to:
  /// **'Booked via Sport Kick'**
  String get homeBookingShareDescription;

  /// No description provided for @homeNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeNavHome;

  /// No description provided for @homeNavExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get homeNavExplore;

  /// No description provided for @homeNavBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get homeNavBookings;

  /// No description provided for @homeNavSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeNavSettings;

  /// No description provided for @sportFootball.
  ///
  /// In en, this message translates to:
  /// **'Football'**
  String get sportFootball;

  /// No description provided for @sportTennis.
  ///
  /// In en, this message translates to:
  /// **'Tennis'**
  String get sportTennis;

  /// No description provided for @sportBasketball.
  ///
  /// In en, this message translates to:
  /// **'Basketball'**
  String get sportBasketball;

  /// No description provided for @sportPadel.
  ///
  /// In en, this message translates to:
  /// **'Padel'**
  String get sportPadel;

  /// No description provided for @sportVolleyball.
  ///
  /// In en, this message translates to:
  /// **'Volleyball'**
  String get sportVolleyball;

  /// No description provided for @homeFeaturePayments.
  ///
  /// In en, this message translates to:
  /// **'Secure online payments'**
  String get homeFeaturePayments;

  /// No description provided for @ownerWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get ownerWelcomeBack;

  /// No description provided for @ownerManageFieldsTagline.
  ///
  /// In en, this message translates to:
  /// **'Manage your football fields'**
  String get ownerManageFieldsTagline;

  /// No description provided for @ownerNoFieldsYet.
  ///
  /// In en, this message translates to:
  /// **'No Fields Yet'**
  String get ownerNoFieldsYet;

  /// No description provided for @ownerStartByAddingField.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first football field'**
  String get ownerStartByAddingField;

  /// No description provided for @ownerAddFirstField.
  ///
  /// In en, this message translates to:
  /// **'Add Your First Field'**
  String get ownerAddFirstField;

  /// No description provided for @ownerEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get ownerEditProfile;

  /// No description provided for @ownerVerifyPayment.
  ///
  /// In en, this message translates to:
  /// **'Verify Payment'**
  String get ownerVerifyPayment;

  /// No description provided for @ownerVerifyPaymentMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to verify this payment? This will confirm that the customer has paid for the booking.'**
  String get ownerVerifyPaymentMessage;

  /// No description provided for @ownerRejectPayment.
  ///
  /// In en, this message translates to:
  /// **'Reject Payment'**
  String get ownerRejectPayment;

  /// No description provided for @ownerRejectPaymentMessage.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason for rejecting this payment. The customer will be notified.'**
  String get ownerRejectPaymentMessage;

  /// No description provided for @ownerRejectReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Enter rejection reason (min 10 characters)'**
  String get ownerRejectReasonHint;

  /// No description provided for @ownerRejectCounter.
  ///
  /// In en, this message translates to:
  /// **'{count}/10 characters minimum'**
  String ownerRejectCounter(Object count);

  /// No description provided for @fieldOwnerRole.
  ///
  /// In en, this message translates to:
  /// **'Field Owner'**
  String get fieldOwnerRole;

  /// No description provided for @bookingShortId.
  ///
  /// In en, this message translates to:
  /// **'Booking #{id}'**
  String bookingShortId(Object id);

  /// No description provided for @paymentProofLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get paymentProofLoadFailed;

  /// No description provided for @paymentProofTryLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get paymentProofTryLater;

  /// No description provided for @ownerApproveBookingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to approve this booking?'**
  String get ownerApproveBookingConfirm;

  /// No description provided for @ownerRejectBookingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this booking?'**
  String get ownerRejectBookingConfirm;

  /// No description provided for @rejectedByOwner.
  ///
  /// In en, this message translates to:
  /// **'Rejected by owner'**
  String get rejectedByOwner;

  /// No description provided for @workingSchedule.
  ///
  /// In en, this message translates to:
  /// **'Working schedule'**
  String get workingSchedule;

  /// No description provided for @closedSlotMessage.
  ///
  /// In en, this message translates to:
  /// **'Field is closed at this time'**
  String get closedSlotMessage;

  /// No description provided for @pastSlotMessage.
  ///
  /// In en, this message translates to:
  /// **'Cannot create bookings for past dates'**
  String get pastSlotMessage;

  /// No description provided for @paymentRejectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment rejected'**
  String get paymentRejectedSuccess;

  /// No description provided for @bookingRejectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking rejected'**
  String get bookingRejectedSuccess;

  /// No description provided for @walkInCustomer.
  ///
  /// In en, this message translates to:
  /// **'Walk-in Customer'**
  String get walkInCustomer;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @paymentInformation.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get paymentInformation;

  /// No description provided for @paymentStatusPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Payment'**
  String get paymentStatusPendingTitle;

  /// No description provided for @paymentStatusPendingDesc.
  ///
  /// In en, this message translates to:
  /// **'Customer has not yet uploaded payment proof'**
  String get paymentStatusPendingDesc;

  /// No description provided for @paymentProofUploadedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Proof Uploaded'**
  String get paymentProofUploadedTitle;

  /// No description provided for @paymentProofUploadedDesc.
  ///
  /// In en, this message translates to:
  /// **'Review the payment proof and verify or reject'**
  String get paymentProofUploadedDesc;

  /// No description provided for @paymentVerifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Verified'**
  String get paymentVerifiedTitle;

  /// No description provided for @paymentVerifiedDesc.
  ///
  /// In en, this message translates to:
  /// **'Payment has been confirmed'**
  String get paymentVerifiedDesc;

  /// No description provided for @paymentRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Rejected'**
  String get paymentRejectedTitle;

  /// No description provided for @paymentRejectedDesc.
  ///
  /// In en, this message translates to:
  /// **'Payment was rejected, awaiting new proof'**
  String get paymentRejectedDesc;

  /// No description provided for @rejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason'**
  String get rejectionReason;

  /// No description provided for @copyValueMessage.
  ///
  /// In en, this message translates to:
  /// **'Copied: {value}'**
  String copyValueMessage(Object value);

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enterPrice;

  /// No description provided for @updateField.
  ///
  /// In en, this message translates to:
  /// **'Update Field'**
  String get updateField;

  /// No description provided for @saveField.
  ///
  /// In en, this message translates to:
  /// **'Save Field'**
  String get saveField;

  /// No description provided for @setWorkingHoursDesc.
  ///
  /// In en, this message translates to:
  /// **'Set working hours for each day of the week'**
  String get setWorkingHoursDesc;

  /// No description provided for @surfaceHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get surfaceHybrid;

  /// No description provided for @fieldType.
  ///
  /// In en, this message translates to:
  /// **'Field Type'**
  String get fieldType;

  /// No description provided for @thousandsAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'{value}K'**
  String thousandsAbbreviation(Object value);

  /// No description provided for @millionsAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'{value}M'**
  String millionsAbbreviation(Object value);

  /// No description provided for @currencyEgp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currencyEgp;

  /// No description provided for @recentBookings.
  ///
  /// In en, this message translates to:
  /// **'Recent Bookings'**
  String get recentBookings;

  /// No description provided for @unknownCustomer.
  ///
  /// In en, this message translates to:
  /// **'Unknown Customer'**
  String get unknownCustomer;

  /// No description provided for @fieldVisibleToCustomers.
  ///
  /// In en, this message translates to:
  /// **'Field is visible to customers'**
  String get fieldVisibleToCustomers;

  /// No description provided for @fieldHiddenFromCustomers.
  ///
  /// In en, this message translates to:
  /// **'Field is hidden from customers'**
  String get fieldHiddenFromCustomers;

  /// No description provided for @enterCustomerDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter customer details for walk-in booking'**
  String get enterCustomerDetails;

  /// No description provided for @customerNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get customerNameTooShort;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'01XXXXXXXXX'**
  String get phoneHint;

  /// No description provided for @invalidEgyPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid Egyptian phone number'**
  String get invalidEgyPhone;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'customer@example.com'**
  String get emailHint;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesLabel;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Any special requests or notes...'**
  String get notesHint;

  /// No description provided for @selectDay.
  ///
  /// In en, this message translates to:
  /// **'Select Day'**
  String get selectDay;

  /// No description provided for @selectDaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the day you want to reserve every week'**
  String get selectDaySubtitle;

  /// No description provided for @availableSlotsForDay.
  ///
  /// In en, this message translates to:
  /// **'Available time slots for {day}'**
  String availableSlotsForDay(Object day);

  /// No description provided for @selectDayFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a day first'**
  String get selectDayFirst;

  /// No description provided for @fieldClosedOnDay.
  ///
  /// In en, this message translates to:
  /// **'Field is closed on {day}'**
  String fieldClosedOnDay(Object day);

  /// No description provided for @selectDifferentDay.
  ///
  /// In en, this message translates to:
  /// **'Please select a different day'**
  String get selectDifferentDay;

  /// No description provided for @noAvailableSlots.
  ///
  /// In en, this message translates to:
  /// **'No available slots'**
  String get noAvailableSlots;

  /// No description provided for @reservedBy.
  ///
  /// In en, this message translates to:
  /// **'Reserved by {name}'**
  String reservedBy(Object name);

  /// No description provided for @reservedByAnotherUser.
  ///
  /// In en, this message translates to:
  /// **'another user'**
  String get reservedByAnotherUser;

  /// No description provided for @recurringDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get recurringDurationTitle;

  /// No description provided for @recurringDurationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How long do you want to play each week?'**
  String get recurringDurationSubtitle;

  /// No description provided for @recurringHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, one {{hoursFormatted} hour} two {{hoursFormatted} hours} few {{hoursFormatted} hours} many {{hoursFormatted} hours} other {{hoursFormatted} hours}}'**
  String recurringHoursLabel(num hours, Object hoursFormatted);

  /// No description provided for @recurringHoursShort.
  ///
  /// In en, this message translates to:
  /// **'{hoursFormatted}h'**
  String recurringHoursShort(Object hoursFormatted);

  /// No description provided for @perWeek.
  ///
  /// In en, this message translates to:
  /// **'per week'**
  String get perWeek;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @weeklyReservationSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Weekly Reservation'**
  String get weeklyReservationSummaryTitle;

  /// No description provided for @dayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayLabel;

  /// No description provided for @weeklyCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly Cost'**
  String get weeklyCostLabel;

  /// No description provided for @weeklyPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly Price'**
  String get weeklyPriceLabel;

  /// No description provided for @weeklyLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weeklyLabel;

  /// No description provided for @everyLabel.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get everyLabel;

  /// No description provided for @reserveWeeklySlot.
  ///
  /// In en, this message translates to:
  /// **'Reserve Weekly Slot'**
  String get reserveWeeklySlot;

  /// No description provided for @recurringRequestSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Submitted!'**
  String get recurringRequestSubmittedTitle;

  /// No description provided for @recurringRequestSubmittedBody.
  ///
  /// In en, this message translates to:
  /// **'Your recurring booking request has been sent to the field owner. You\'ll be notified once it\'s approved.'**
  String get recurringRequestSubmittedBody;

  /// No description provided for @viewMySubscriptions.
  ///
  /// In en, this message translates to:
  /// **'View My Subscriptions'**
  String get viewMySubscriptions;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @submittingRequest.
  ///
  /// In en, this message translates to:
  /// **'Submitting Request...'**
  String get submittingRequest;

  /// No description provided for @submittingRequestDescription.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we process your request'**
  String get submittingRequestDescription;

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every {day}'**
  String everyDay(Object day);

  /// No description provided for @completedSessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed Sessions'**
  String get completedSessionsLabel;

  /// No description provided for @nextBooking.
  ///
  /// In en, this message translates to:
  /// **'Next Booking'**
  String get nextBooking;

  /// No description provided for @paidLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paidLabel;

  /// No description provided for @cancelingSubscription.
  ///
  /// In en, this message translates to:
  /// **'Canceling...'**
  String get cancelingSubscription;

  /// No description provided for @cancelSubscriptionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this recurring booking?'**
  String get cancelSubscriptionQuestion;

  /// No description provided for @pendingApprovalMessage.
  ///
  /// In en, this message translates to:
  /// **'Waiting for owner approval. You\'ll be notified once approved.'**
  String get pendingApprovalMessage;

  /// No description provided for @requestRejected.
  ///
  /// In en, this message translates to:
  /// **'Request Rejected'**
  String get requestRejected;

  /// No description provided for @activeSubscription.
  ///
  /// In en, this message translates to:
  /// **'Active Subscription'**
  String get activeSubscription;

  /// No description provided for @remainingBookings.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String remainingBookings(Object count);

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @sinceLabel.
  ///
  /// In en, this message translates to:
  /// **'Since'**
  String get sinceLabel;

  /// No description provided for @weeklyLabelShort.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weeklyLabelShort;

  /// No description provided for @generatingBooking.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get generatingBooking;

  /// No description provided for @completedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} completed'**
  String completedCount(Object count);

  /// No description provided for @mySubscriptions.
  ///
  /// In en, this message translates to:
  /// **'My Subscriptions'**
  String get mySubscriptions;

  /// No description provided for @newSubscription.
  ///
  /// In en, this message translates to:
  /// **'New Subscription'**
  String get newSubscription;

  /// No description provided for @subscriptionCanceled.
  ///
  /// In en, this message translates to:
  /// **'Subscription canceled successfully'**
  String get subscriptionCanceled;

  /// No description provided for @subscriptionCancelFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel subscription'**
  String get subscriptionCancelFailed;

  /// No description provided for @activeSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Active Subscriptions'**
  String get activeSubscriptions;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @weeklyReservations.
  ///
  /// In en, this message translates to:
  /// **'Weekly Reservations'**
  String get weeklyReservations;

  /// No description provided for @recurringSummaryCounts.
  ///
  /// In en, this message translates to:
  /// **'{active} active • {pending} pending'**
  String recurringSummaryCounts(Object active, Object pending);

  /// No description provided for @noSubscriptionsYet.
  ///
  /// In en, this message translates to:
  /// **'No Subscriptions Yet'**
  String get noSubscriptionsYet;

  /// No description provided for @noSubscriptionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reserve your favorite weekly slot and never miss a game!'**
  String get noSubscriptionsSubtitle;

  /// No description provided for @guaranteedWeeklySlot.
  ///
  /// In en, this message translates to:
  /// **'Guaranteed weekly slot'**
  String get guaranteedWeeklySlot;

  /// No description provided for @autoRenewsWeekly.
  ///
  /// In en, this message translates to:
  /// **'Auto-renews every week'**
  String get autoRenewsWeekly;

  /// No description provided for @paymentReminders.
  ///
  /// In en, this message translates to:
  /// **'Payment reminders'**
  String get paymentReminders;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get statusPendingApproval;

  /// No description provided for @statusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get statusCanceled;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @newRecurringRequest.
  ///
  /// In en, this message translates to:
  /// **'New Recurring Request'**
  String get newRecurringRequest;

  /// No description provided for @processingRequest.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processingRequest;

  /// No description provided for @pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get pendingRequests;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @completedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedLabel;

  /// No description provided for @upcomingLabel.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcomingLabel;

  /// No description provided for @progressCompleted.
  ///
  /// In en, this message translates to:
  /// **'{percent}% completed'**
  String progressCompleted(Object percent);

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleTitle;

  /// No description provided for @recurringRequestsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'When users request weekly recurring bookings, they\'ll appear here for your approval.'**
  String get recurringRequestsEmptySubtitle;

  /// No description provided for @keepSubscription.
  ///
  /// In en, this message translates to:
  /// **'Keep Subscription'**
  String get keepSubscription;

  /// No description provided for @cancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancelSubscription;

  /// No description provided for @recurringRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring Subscriptions'**
  String get recurringRequestsTitle;

  /// No description provided for @recurringRequestApproved.
  ///
  /// In en, this message translates to:
  /// **'Request approved successfully'**
  String get recurringRequestApproved;

  /// No description provided for @recurringRequestApproveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to approve request'**
  String get recurringRequestApproveFailed;

  /// No description provided for @recurringRequestRejected.
  ///
  /// In en, this message translates to:
  /// **'Request rejected'**
  String get recurringRequestRejected;

  /// No description provided for @recurringRequestRejectFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reject request'**
  String get recurringRequestRejectFailed;

  /// No description provided for @rejectRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Request'**
  String get rejectRequestTitle;

  /// No description provided for @rejectRequestPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason for rejecting this recurring booking request:'**
  String get rejectRequestPrompt;

  /// No description provided for @rejectRequestHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Slot not available, time conflict...'**
  String get rejectRequestHint;

  /// No description provided for @loadingRequests.
  ///
  /// In en, this message translates to:
  /// **'Loading requests...'**
  String get loadingRequests;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How we protect your data'**
  String get privacyPolicySubtitle;

  /// No description provided for @privacyHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy Matters'**
  String get privacyHeaderTitle;

  /// No description provided for @privacyHeaderDescription.
  ///
  /// In en, this message translates to:
  /// **'Sport Kick is committed to protecting your privacy and personal information. This policy explains how we collect, use, and safeguard your data.'**
  String get privacyHeaderDescription;

  /// No description provided for @privacyInfoCollectTitle.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get privacyInfoCollectTitle;

  /// No description provided for @privacyCollectAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account information (name, email, phone number)'**
  String get privacyCollectAccountInfo;

  /// No description provided for @privacyCollectProfileInfo.
  ///
  /// In en, this message translates to:
  /// **'Profile information you provide'**
  String get privacyCollectProfileInfo;

  /// No description provided for @privacyCollectBookingHistory.
  ///
  /// In en, this message translates to:
  /// **'Booking history and preferences'**
  String get privacyCollectBookingHistory;

  /// No description provided for @privacyCollectLocation.
  ///
  /// In en, this message translates to:
  /// **'Location data when using the app'**
  String get privacyCollectLocation;

  /// No description provided for @privacyCollectDevice.
  ///
  /// In en, this message translates to:
  /// **'Device information and usage data'**
  String get privacyCollectDevice;

  /// No description provided for @privacyCollectPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment information (processed securely by our payment provider)'**
  String get privacyCollectPayment;

  /// No description provided for @privacyUseInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get privacyUseInfoTitle;

  /// No description provided for @privacyUseProvideService.
  ///
  /// In en, this message translates to:
  /// **'To provide and maintain our booking services'**
  String get privacyUseProvideService;

  /// No description provided for @privacyUseProcessPayments.
  ///
  /// In en, this message translates to:
  /// **'To process your bookings and payments'**
  String get privacyUseProcessPayments;

  /// No description provided for @privacyUseCommunicate.
  ///
  /// In en, this message translates to:
  /// **'To communicate with you about bookings and updates'**
  String get privacyUseCommunicate;

  /// No description provided for @privacyUseImprove.
  ///
  /// In en, this message translates to:
  /// **'To improve our services and user experience'**
  String get privacyUseImprove;

  /// No description provided for @privacyUseSecurity.
  ///
  /// In en, this message translates to:
  /// **'To prevent fraud and ensure security'**
  String get privacyUseSecurity;

  /// No description provided for @privacyUseLegal.
  ///
  /// In en, this message translates to:
  /// **'To comply with legal obligations'**
  String get privacyUseLegal;

  /// No description provided for @privacyStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Storage and Security'**
  String get privacyStorageTitle;

  /// No description provided for @privacyStorageSecure.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored securely using Supabase (PostgreSQL database)'**
  String get privacyStorageSecure;

  /// No description provided for @privacyStorageEncryption.
  ///
  /// In en, this message translates to:
  /// **'We use industry-standard encryption for data transmission'**
  String get privacyStorageEncryption;

  /// No description provided for @privacyStoragePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment information is handled by certified payment processors'**
  String get privacyStoragePayment;

  /// No description provided for @privacyStorageUpdates.
  ///
  /// In en, this message translates to:
  /// **'We implement regular security updates and monitoring'**
  String get privacyStorageUpdates;

  /// No description provided for @privacyStorageAccess.
  ///
  /// In en, this message translates to:
  /// **'Access to personal data is restricted to authorized personnel only'**
  String get privacyStorageAccess;

  /// No description provided for @privacySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get privacySharingTitle;

  /// No description provided for @privacySharingNoSell.
  ///
  /// In en, this message translates to:
  /// **'We do NOT sell your personal information to third parties'**
  String get privacySharingNoSell;

  /// No description provided for @privacySharingOwners.
  ///
  /// In en, this message translates to:
  /// **'Field owners can see your booking details (name, phone) for confirmed bookings'**
  String get privacySharingOwners;

  /// No description provided for @privacySharingProviders.
  ///
  /// In en, this message translates to:
  /// **'We may share data with service providers (payment processors, analytics)'**
  String get privacySharingProviders;

  /// No description provided for @privacySharingLegal.
  ///
  /// In en, this message translates to:
  /// **'We will share data if required by law or to protect rights and safety'**
  String get privacySharingLegal;

  /// No description provided for @privacyRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get privacyRightsTitle;

  /// No description provided for @privacyRightsAccess.
  ///
  /// In en, this message translates to:
  /// **'Access your personal data at any time through your profile'**
  String get privacyRightsAccess;

  /// No description provided for @privacyRightsUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update or correct your information'**
  String get privacyRightsUpdate;

  /// No description provided for @privacyRightsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete your account and associated data'**
  String get privacyRightsDelete;

  /// No description provided for @privacyRightsOptOut.
  ///
  /// In en, this message translates to:
  /// **'Opt-out of marketing communications'**
  String get privacyRightsOptOut;

  /// No description provided for @privacyRightsExport.
  ///
  /// In en, this message translates to:
  /// **'Export your booking history'**
  String get privacyRightsExport;

  /// No description provided for @privacyRightsWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw consent for data processing (may limit service availability)'**
  String get privacyRightsWithdraw;

  /// No description provided for @privacyCookiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Cookies and Tracking'**
  String get privacyCookiesTitle;

  /// No description provided for @privacyCookiesUse.
  ///
  /// In en, this message translates to:
  /// **'We use cookies and similar technologies to improve user experience'**
  String get privacyCookiesUse;

  /// No description provided for @privacyCookiesAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics cookies help us understand app usage'**
  String get privacyCookiesAnalytics;

  /// No description provided for @privacyCookiesDisable.
  ///
  /// In en, this message translates to:
  /// **'You can disable cookies in your device settings'**
  String get privacyCookiesDisable;

  /// No description provided for @privacyCookiesImpact.
  ///
  /// In en, this message translates to:
  /// **'Some features may not work without cookies'**
  String get privacyCookiesImpact;

  /// No description provided for @privacyChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'Children\'s Privacy'**
  String get privacyChildrenTitle;

  /// No description provided for @privacyChildrenNotFor.
  ///
  /// In en, this message translates to:
  /// **'Our service is not intended for children under 13'**
  String get privacyChildrenNotFor;

  /// No description provided for @privacyChildrenNoCollect.
  ///
  /// In en, this message translates to:
  /// **'We do not knowingly collect data from children'**
  String get privacyChildrenNoCollect;

  /// No description provided for @privacyChildrenDelete.
  ///
  /// In en, this message translates to:
  /// **'If we learn we have collected child data, we will delete it'**
  String get privacyChildrenDelete;

  /// No description provided for @privacyChildrenParents.
  ///
  /// In en, this message translates to:
  /// **'Parents can contact us to request data deletion'**
  String get privacyChildrenParents;

  /// No description provided for @privacyChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Changes to This Policy'**
  String get privacyChangesTitle;

  /// No description provided for @privacyChangesMayUpdate.
  ///
  /// In en, this message translates to:
  /// **'We may update this privacy policy from time to time'**
  String get privacyChangesMayUpdate;

  /// No description provided for @privacyChangesNotify.
  ///
  /// In en, this message translates to:
  /// **'We will notify you of significant changes via email or app notification'**
  String get privacyChangesNotify;

  /// No description provided for @privacyChangesAccept.
  ///
  /// In en, this message translates to:
  /// **'Continued use of the app after changes constitutes acceptance'**
  String get privacyChangesAccept;

  /// No description provided for @privacyChangesLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String privacyChangesLastUpdated(Object date);

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsTitle;

  /// No description provided for @termsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rules and guidelines'**
  String get termsSubtitle;

  /// No description provided for @termsDescription.
  ///
  /// In en, this message translates to:
  /// **'Please read these terms carefully before using Sport Kick. These terms govern your use of our platform and services.'**
  String get termsDescription;

  /// No description provided for @termsAcceptanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of Terms'**
  String get termsAcceptanceTitle;

  /// No description provided for @termsAcceptanceAgree.
  ///
  /// In en, this message translates to:
  /// **'By using Sport Kick, you agree to these Terms of Service'**
  String get termsAcceptanceAgree;

  /// No description provided for @termsAcceptanceDisagree.
  ///
  /// In en, this message translates to:
  /// **'If you do not agree, please do not use our services'**
  String get termsAcceptanceDisagree;

  /// No description provided for @termsAcceptanceModify.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to modify these terms at any time'**
  String get termsAcceptanceModify;

  /// No description provided for @termsAcceptanceContinuedUse.
  ///
  /// In en, this message translates to:
  /// **'Continued use after changes constitutes acceptance'**
  String get termsAcceptanceContinuedUse;

  /// No description provided for @termsAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'User Accounts'**
  String get termsAccountsTitle;

  /// No description provided for @termsAccountsAccurateInfo.
  ///
  /// In en, this message translates to:
  /// **'You must provide accurate and complete information when registering'**
  String get termsAccountsAccurateInfo;

  /// No description provided for @termsAccountsSecurity.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the security of your account'**
  String get termsAccountsSecurity;

  /// No description provided for @termsAccountsAge.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 13 years old to use our services'**
  String get termsAccountsAge;

  /// No description provided for @termsAccountsSingle.
  ///
  /// In en, this message translates to:
  /// **'One person or business per account'**
  String get termsAccountsSingle;

  /// No description provided for @termsAccountsNoShare.
  ///
  /// In en, this message translates to:
  /// **'You must not share your account credentials'**
  String get termsAccountsNoShare;

  /// No description provided for @termsAccountsNotify.
  ///
  /// In en, this message translates to:
  /// **'Notify us immediately of any unauthorized account access'**
  String get termsAccountsNotify;

  /// No description provided for @termsBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Policies'**
  String get termsBookingTitle;

  /// No description provided for @termsBookingAvailability.
  ///
  /// In en, this message translates to:
  /// **'All bookings are subject to field availability'**
  String get termsBookingAvailability;

  /// No description provided for @termsBookingApproval.
  ///
  /// In en, this message translates to:
  /// **'Bookings may require owner approval before confirmation'**
  String get termsBookingApproval;

  /// No description provided for @termsBookingArrival.
  ///
  /// In en, this message translates to:
  /// **'You must arrive on time for your booking'**
  String get termsBookingArrival;

  /// No description provided for @termsBookingLate.
  ///
  /// In en, this message translates to:
  /// **'Late arrivals may result in reduced playing time'**
  String get termsBookingLate;

  /// No description provided for @termsBookingNoShow.
  ///
  /// In en, this message translates to:
  /// **'No-shows may result in account restrictions'**
  String get termsBookingNoShow;

  /// No description provided for @termsBookingPrices.
  ///
  /// In en, this message translates to:
  /// **'Prices are set by field owners and may vary'**
  String get termsBookingPrices;

  /// No description provided for @termsCancellationTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellation and Refunds'**
  String get termsCancellationTitle;

  /// No description provided for @termsCancellationPolicy.
  ///
  /// In en, this message translates to:
  /// **'Users can cancel bookings according to the cancellation policy'**
  String get termsCancellationPolicy;

  /// No description provided for @termsCancellationFullRefund.
  ///
  /// In en, this message translates to:
  /// **'Cancellations made 24+ hours in advance may be eligible for full refund'**
  String get termsCancellationFullRefund;

  /// No description provided for @termsCancellationLateFees.
  ///
  /// In en, this message translates to:
  /// **'Cancellations made less than 24 hours may incur fees'**
  String get termsCancellationLateFees;

  /// No description provided for @termsCancellationNoShow.
  ///
  /// In en, this message translates to:
  /// **'No-shows are not eligible for refunds'**
  String get termsCancellationNoShow;

  /// No description provided for @termsCancellationRefundTime.
  ///
  /// In en, this message translates to:
  /// **'Refunds are processed according to payment method (3-7 business days)'**
  String get termsCancellationRefundTime;

  /// No description provided for @termsCancellationOwnerCancel.
  ///
  /// In en, this message translates to:
  /// **'Field owners reserve the right to cancel bookings due to maintenance or weather'**
  String get termsCancellationOwnerCancel;

  /// No description provided for @termsConductTitle.
  ///
  /// In en, this message translates to:
  /// **'User Conduct'**
  String get termsConductTitle;

  /// No description provided for @termsConductRules.
  ///
  /// In en, this message translates to:
  /// **'You must follow field rules and guidelines'**
  String get termsConductRules;

  /// No description provided for @termsConductNoAbuse.
  ///
  /// In en, this message translates to:
  /// **'No harassment, discrimination, or abuse towards staff or players'**
  String get termsConductNoAbuse;

  /// No description provided for @termsConductDamage.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for any damage caused during your booking'**
  String get termsConductDamage;

  /// No description provided for @termsConductProhibited.
  ///
  /// In en, this message translates to:
  /// **'Prohibited activities include fraudulent bookings or misuse of the platform'**
  String get termsConductProhibited;

  /// No description provided for @termsLiabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Liability and Disclaimers'**
  String get termsLiabilityTitle;

  /// No description provided for @termsLiabilityPlatform.
  ///
  /// In en, this message translates to:
  /// **'Sport Kick is a platform that connects users with field owners'**
  String get termsLiabilityPlatform;

  /// No description provided for @termsLiabilityCondition.
  ///
  /// In en, this message translates to:
  /// **'We are not responsible for the condition of fields or equipment'**
  String get termsLiabilityCondition;

  /// No description provided for @termsLiabilityInjuries.
  ///
  /// In en, this message translates to:
  /// **'We are not liable for injuries, accidents, or losses during use of the services'**
  String get termsLiabilityInjuries;

  /// No description provided for @termsLiabilityOwner.
  ///
  /// In en, this message translates to:
  /// **'Field owners are responsible for their facilities and adherence to safety standards'**
  String get termsLiabilityOwner;

  /// No description provided for @termsPaymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment and Fees'**
  String get termsPaymentsTitle;

  /// No description provided for @termsPaymentsProcessed.
  ///
  /// In en, this message translates to:
  /// **'Payments are processed securely via our payment provider'**
  String get termsPaymentsProcessed;

  /// No description provided for @termsPaymentsFees.
  ///
  /// In en, this message translates to:
  /// **'Service fees may apply to bookings'**
  String get termsPaymentsFees;

  /// No description provided for @termsPaymentsDisplay.
  ///
  /// In en, this message translates to:
  /// **'Prices are displayed before checkout'**
  String get termsPaymentsDisplay;

  /// No description provided for @termsPaymentsRefunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds follow the cancellation policy'**
  String get termsPaymentsRefunds;

  /// No description provided for @termsPaymentsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency and taxes are displayed during checkout'**
  String get termsPaymentsCurrency;

  /// No description provided for @termsIPTitle.
  ///
  /// In en, this message translates to:
  /// **'Intellectual Property'**
  String get termsIPTitle;

  /// No description provided for @termsIPProtected.
  ///
  /// In en, this message translates to:
  /// **'All content on Sport Kick is protected by copyright and trademarks'**
  String get termsIPProtected;

  /// No description provided for @termsIPBrand.
  ///
  /// In en, this message translates to:
  /// **'You may not use our branding without permission'**
  String get termsIPBrand;

  /// No description provided for @termsIPUserContent.
  ///
  /// In en, this message translates to:
  /// **'User-generated content remains your property, but you grant us a license to display it'**
  String get termsIPUserContent;

  /// No description provided for @termsTerminationTitle.
  ///
  /// In en, this message translates to:
  /// **'Termination'**
  String get termsTerminationTitle;

  /// No description provided for @termsTerminationSuspend.
  ///
  /// In en, this message translates to:
  /// **'We may suspend or terminate accounts for violations of these terms'**
  String get termsTerminationSuspend;

  /// No description provided for @termsTerminationDelete.
  ///
  /// In en, this message translates to:
  /// **'Users may delete their accounts at any time'**
  String get termsTerminationDelete;

  /// No description provided for @termsTerminationDisputes.
  ///
  /// In en, this message translates to:
  /// **'Outstanding payments or disputes may delay account deletion'**
  String get termsTerminationDisputes;

  /// No description provided for @termsLawTitle.
  ///
  /// In en, this message translates to:
  /// **'Governing Law'**
  String get termsLawTitle;

  /// No description provided for @termsLawGoverning.
  ///
  /// In en, this message translates to:
  /// **'These terms are governed by applicable local laws'**
  String get termsLawGoverning;

  /// No description provided for @termsLawDisputes.
  ///
  /// In en, this message translates to:
  /// **'Any disputes will be resolved in the appropriate jurisdiction'**
  String get termsLawDisputes;

  /// No description provided for @supportContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get supportContactTitle;

  /// No description provided for @supportContactDescription.
  ///
  /// In en, this message translates to:
  /// **'If you have questions about our policies or need assistance, please contact us:'**
  String get supportContactDescription;
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
