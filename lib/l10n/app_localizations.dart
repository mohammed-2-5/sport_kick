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
  /// **'Current Session'**
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
  /// **'Cancellation Reason *'**
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
  /// **'Active Status'**
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
  /// **'security'**
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

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @newUsersThisMonth.
  ///
  /// In en, this message translates to:
  /// **'+{count} this month'**
  String newUsersThisMonth(Object count);

  /// No description provided for @totalAdmins.
  ///
  /// In en, this message translates to:
  /// **'Total Admins'**
  String get totalAdmins;

  /// No description provided for @fieldOwners.
  ///
  /// In en, this message translates to:
  /// **'Field owners'**
  String get fieldOwners;

  /// No description provided for @activeFields.
  ///
  /// In en, this message translates to:
  /// **'Active Fields'**
  String get activeFields;

  /// No description provided for @inactiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} inactive'**
  String inactiveCount(Object count);

  /// No description provided for @pendingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String pendingCount(Object count);

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

  /// No description provided for @version100.
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get version100;

  /// No description provided for @version1001.
  ///
  /// In en, this message translates to:
  /// **'1.0.0+1'**
  String get version1001;

  /// No description provided for @oneHour.
  ///
  /// In en, this message translates to:
  /// **'1 Hour'**
  String get oneHour;

  /// No description provided for @phoneExample.
  ///
  /// In en, this message translates to:
  /// **'+20 123 456 7890'**
  String get phoneExample;

  /// No description provided for @twoHours.
  ///
  /// In en, this message translates to:
  /// **'2 Hours'**
  String get twoHours;

  /// No description provided for @accountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get accountStatus;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @activateAdmins.
  ///
  /// In en, this message translates to:
  /// **'Activate Admins'**
  String get activateAdmins;

  /// No description provided for @activateCity.
  ///
  /// In en, this message translates to:
  /// **'Activate City'**
  String get activateCity;

  /// No description provided for @activateSelectedAdmins.
  ///
  /// In en, this message translates to:
  /// **'Activate Selected Admins'**
  String get activateSelectedAdmins;

  /// No description provided for @activateSelectedUsers.
  ///
  /// In en, this message translates to:
  /// **'Activate Selected Users'**
  String get activateSelectedUsers;

  /// No description provided for @activateUser.
  ///
  /// In en, this message translates to:
  /// **'Activate User?'**
  String get activateUser;

  /// No description provided for @activateUsers.
  ///
  /// In en, this message translates to:
  /// **'Activate Users'**
  String get activateUsers;

  /// No description provided for @activatingAdmins.
  ///
  /// In en, this message translates to:
  /// **'Activating admins...'**
  String get activatingAdmins;

  /// No description provided for @activatingUser.
  ///
  /// In en, this message translates to:
  /// **'Activating user...'**
  String get activatingUser;

  /// No description provided for @activatingUsers.
  ///
  /// In en, this message translates to:
  /// **'Activating users...'**
  String get activatingUsers;

  /// No description provided for @active2.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get active2;

  /// No description provided for @activeNow.
  ///
  /// In en, this message translates to:
  /// **'Active Now'**
  String get activeNow;

  /// No description provided for @addANewFieldOwner.
  ///
  /// In en, this message translates to:
  /// **'Add a new field owner'**
  String get addANewFieldOwner;

  /// No description provided for @addAnExtraLayerOfSecurity.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security'**
  String get addAnExtraLayerOfSecurity;

  /// No description provided for @addCity.
  ///
  /// In en, this message translates to:
  /// **'Add City'**
  String get addCity;

  /// No description provided for @addNewFieldOwner.
  ///
  /// In en, this message translates to:
  /// **'Add new field owner'**
  String get addNewFieldOwner;

  /// No description provided for @addNewSportsField.
  ///
  /// In en, this message translates to:
  /// **'Add new sports field'**
  String get addNewSportsField;

  /// No description provided for @adminAlerts.
  ///
  /// In en, this message translates to:
  /// **'Admin Alerts'**
  String get adminAlerts;

  /// No description provided for @adminCreated.
  ///
  /// In en, this message translates to:
  /// **'Admin Created!'**
  String get adminCreated;

  /// No description provided for @adminDetails.
  ///
  /// In en, this message translates to:
  /// **'Admin Details'**
  String get adminDetails;

  /// No description provided for @adminExampleCom.
  ///
  /// In en, this message translates to:
  /// **'admin@example.com'**
  String get adminExampleCom;

  /// No description provided for @adminsExportedToCsv.
  ///
  /// In en, this message translates to:
  /// **'Admins exported to CSV'**
  String get adminsExportedToCsv;

  /// No description provided for @ahmedMohamed.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Mohamed'**
  String get ahmedMohamed;

  /// No description provided for @all2.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get all2;

  /// No description provided for @allBookings.
  ///
  /// In en, this message translates to:
  /// **'All Bookings'**
  String get allBookings;

  /// No description provided for @allCities.
  ///
  /// In en, this message translates to:
  /// **'All Cities'**
  String get allCities;

  /// No description provided for @allFields.
  ///
  /// In en, this message translates to:
  /// **'All Fields'**
  String get allFields;

  /// No description provided for @allSports.
  ///
  /// In en, this message translates to:
  /// **'All Sports'**
  String get allSports;

  /// No description provided for @allTimeEarnings.
  ///
  /// In en, this message translates to:
  /// **'All time earnings'**
  String get allTimeEarnings;

  /// No description provided for @allowRegistrations.
  ///
  /// In en, this message translates to:
  /// **'Allow Registrations'**
  String get allowRegistrations;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @applyToWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Apply to Weekdays'**
  String get applyToWeekdays;

  /// No description provided for @applyToWeekend.
  ///
  /// In en, this message translates to:
  /// **'Apply to Weekend'**
  String get applyToWeekend;

  /// No description provided for @approveThisBookingRequest.
  ///
  /// In en, this message translates to:
  /// **'Approve this booking request'**
  String get approveThisBookingRequest;

  /// No description provided for @approvingBooking.
  ///
  /// In en, this message translates to:
  /// **'Approving booking...'**
  String get approvingBooking;

  /// No description provided for @areYouSureYouWantToActivateCountAdmins.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {Are you sure you want to activate {count} admin?} other {Are you sure you want to activate {count} admins?}}'**
  String areYouSureYouWantToActivateCountAdmins(num count);

  /// No description provided for @areYouSureYouWantToActivateCountUsers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {Are you sure you want to activate {count} user?} other {Are you sure you want to activate {count} users?}}'**
  String areYouSureYouWantToActivateCountUsers(num count);

  /// No description provided for @areYouSureYouWantToDeactivateCountAdmins.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {Are you sure you want to deactivate {count} admin?} other {Are you sure you want to deactivate {count} admins?}}'**
  String areYouSureYouWantToDeactivateCountAdmins(num count);

  /// No description provided for @areYouSureYouWantToDeactivateCountUsers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {Are you sure you want to deactivate {count} user?} other {Are you sure you want to deactivate {count} users?}}'**
  String areYouSureYouWantToDeactivateCountUsers(num count);

  /// No description provided for @assign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assign;

  /// No description provided for @assignField.
  ///
  /// In en, this message translates to:
  /// **'Assign Field'**
  String get assignField;

  /// No description provided for @assignFieldToAdmin.
  ///
  /// In en, this message translates to:
  /// **'Assign Field to Admin'**
  String get assignFieldToAdmin;

  /// No description provided for @assignFirstField.
  ///
  /// In en, this message translates to:
  /// **'Assign First Field'**
  String get assignFirstField;

  /// No description provided for @assignToAdmin.
  ///
  /// In en, this message translates to:
  /// **'Assign to Admin'**
  String get assignToAdmin;

  /// No description provided for @assigningField.
  ///
  /// In en, this message translates to:
  /// **'Assigning field...'**
  String get assigningField;

  /// No description provided for @automaticallyApproveNewBookings.
  ///
  /// In en, this message translates to:
  /// **'Automatically approve new bookings'**
  String get automaticallyApproveNewBookings;

  /// No description provided for @averageRating.
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get averageRating;

  /// No description provided for @avgRating.
  ///
  /// In en, this message translates to:
  /// **'Avg Rating'**
  String get avgRating;

  /// No description provided for @avgRevenue.
  ///
  /// In en, this message translates to:
  /// **'Avg. Revenue'**
  String get avgRevenue;

  /// No description provided for @beTheFirstToShareYourNexperience.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share your\\nexperience!'**
  String get beTheFirstToShareYourNexperience;

  /// No description provided for @bookYourFirstFieldAndStartNplayingToday.
  ///
  /// In en, this message translates to:
  /// **'Book your first field and start\\nplaying today!'**
  String get bookYourFirstFieldAndStartNplayingToday;

  /// No description provided for @bookingAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Booking Analytics'**
  String get bookingAnalytics;

  /// No description provided for @bookingDistribution.
  ///
  /// In en, this message translates to:
  /// **'Booking Distribution'**
  String get bookingDistribution;

  /// No description provided for @bookingHasBeenFulfilled.
  ///
  /// In en, this message translates to:
  /// **'Booking has been fulfilled'**
  String get bookingHasBeenFulfilled;

  /// No description provided for @bookingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Booking Notifications'**
  String get bookingNotifications;

  /// No description provided for @bookingSettings.
  ///
  /// In en, this message translates to:
  /// **'Booking Settings'**
  String get bookingSettings;

  /// No description provided for @bookingStatistics.
  ///
  /// In en, this message translates to:
  /// **'Booking Statistics'**
  String get bookingStatistics;

  /// No description provided for @bookingStatus2.
  ///
  /// In en, this message translates to:
  /// **'Booking Status'**
  String get bookingStatus2;

  /// No description provided for @bookingscountBookings.
  ///
  /// In en, this message translates to:
  /// **'\$bookingsCount Bookings'**
  String get bookingscountBookings;

  /// No description provided for @bookingscountBookings2.
  ///
  /// In en, this message translates to:
  /// **'\$bookingsCount bookings'**
  String get bookingscountBookings2;

  /// No description provided for @briefDescription.
  ///
  /// In en, this message translates to:
  /// **'Brief description'**
  String get briefDescription;

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// No description provided for @byNumberOfBookings.
  ///
  /// In en, this message translates to:
  /// **'By number of bookings'**
  String get byNumberOfBookings;

  /// No description provided for @byStatus.
  ///
  /// In en, this message translates to:
  /// **'By status'**
  String get byStatus;

  /// No description provided for @cancelSelection.
  ///
  /// In en, this message translates to:
  /// **'Cancel selection'**
  String get cancelSelection;

  /// No description provided for @cancelThisBookingWithReason.
  ///
  /// In en, this message translates to:
  /// **'Cancel this booking with reason'**
  String get cancelThisBookingWithReason;

  /// No description provided for @cancelingBooking.
  ///
  /// In en, this message translates to:
  /// **'Canceling booking...'**
  String get cancelingBooking;

  /// No description provided for @cancellingBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancelling booking...'**
  String get cancellingBooking;

  /// No description provided for @cardContent.
  ///
  /// In en, this message translates to:
  /// **'Card content'**
  String get cardContent;

  /// No description provided for @categoryDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Category deleted successfully'**
  String get categoryDeletedSuccessfully;

  /// No description provided for @categoryNameCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Category \"\$name\" created successfully'**
  String get categoryNameCreatedSuccessfully;

  /// No description provided for @categoryUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully'**
  String get categoryUpdatedSuccessfully;

  /// No description provided for @chooseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Choose Currency'**
  String get chooseCurrency;

  /// No description provided for @chooseDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Choose Date Format'**
  String get chooseDateFormat;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get chooseTheme;

  /// No description provided for @cities.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get cities;

  /// No description provided for @compareFields.
  ///
  /// In en, this message translates to:
  /// **'Compare Fields'**
  String get compareFields;

  /// No description provided for @completion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get completion;

  /// No description provided for @configureDefaultPlatformHours.
  ///
  /// In en, this message translates to:
  /// **'Configure default platform hours'**
  String get configureDefaultPlatformHours;

  /// No description provided for @configureLocations.
  ///
  /// In en, this message translates to:
  /// **'Configure locations'**
  String get configureLocations;

  /// No description provided for @configurePaymentMethodsAndFees.
  ///
  /// In en, this message translates to:
  /// **'Configure payment methods and fees'**
  String get configurePaymentMethodsAndFees;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @continueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continueWithFacebook;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @copyAll.
  ///
  /// In en, this message translates to:
  /// **'Copy All'**
  String get copyAll;

  /// No description provided for @copyLabel.
  ///
  /// In en, this message translates to:
  /// **'Copy \$label'**
  String get copyLabel;

  /// No description provided for @couldNotDetermineYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not determine your location'**
  String get couldNotDetermineYourLocation;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createAStrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get createAStrongPassword;

  /// No description provided for @createAdmin.
  ///
  /// In en, this message translates to:
  /// **'Create Admin'**
  String get createAdmin;

  /// No description provided for @createAdminAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Admin Account'**
  String get createAdminAccount;

  /// No description provided for @createField.
  ///
  /// In en, this message translates to:
  /// **'Create Field'**
  String get createField;

  /// No description provided for @createNewField2.
  ///
  /// In en, this message translates to:
  /// **'Create New Field'**
  String get createNewField2;

  /// No description provided for @creatingAdminAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating admin account...'**
  String get creatingAdminAccount;

  /// No description provided for @creatingBooking2.
  ///
  /// In en, this message translates to:
  /// **'Creating booking...'**
  String get creatingBooking2;

  /// No description provided for @creatingCity.
  ///
  /// In en, this message translates to:
  /// **'Creating city...'**
  String get creatingCity;

  /// No description provided for @creatingField.
  ///
  /// In en, this message translates to:
  /// **'Creating field...'**
  String get creatingField;

  /// No description provided for @creatingManualBooking.
  ///
  /// In en, this message translates to:
  /// **'Creating manual booking...'**
  String get creatingManualBooking;

  /// No description provided for @creationDate.
  ///
  /// In en, this message translates to:
  /// **'Creation Date'**
  String get creationDate;

  /// No description provided for @credentialsCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Credentials copied to clipboard'**
  String get credentialsCopiedToClipboard;

  /// No description provided for @csv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get csv;

  /// No description provided for @customersUsers.
  ///
  /// In en, this message translates to:
  /// **'Customers (Users)'**
  String get customersUsers;

  /// No description provided for @customizeEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Customize email notifications'**
  String get customizeEmailNotifications;

  /// No description provided for @ddMmYyyy.
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get ddMmYyyy;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @deactivateAdmins.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Admins'**
  String get deactivateAdmins;

  /// No description provided for @deactivateCity.
  ///
  /// In en, this message translates to:
  /// **'Deactivate City'**
  String get deactivateCity;

  /// No description provided for @deactivateOrPermanentlyRemoveThisField.
  ///
  /// In en, this message translates to:
  /// **'Deactivate or permanently remove this field'**
  String get deactivateOrPermanentlyRemoveThisField;

  /// No description provided for @deactivateSelectedAdmins.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Selected Admins'**
  String get deactivateSelectedAdmins;

  /// No description provided for @deactivateSelectedUsers.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Selected Users'**
  String get deactivateSelectedUsers;

  /// No description provided for @deactivateSoftDelete.
  ///
  /// In en, this message translates to:
  /// **'Deactivate (Soft Delete)'**
  String get deactivateSoftDelete;

  /// No description provided for @deactivateUser.
  ///
  /// In en, this message translates to:
  /// **'Deactivate User?'**
  String get deactivateUser;

  /// No description provided for @deactivateUsers.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Users'**
  String get deactivateUsers;

  /// No description provided for @deactivatingAdmins.
  ///
  /// In en, this message translates to:
  /// **'Deactivating admins...'**
  String get deactivatingAdmins;

  /// No description provided for @deactivatingUser.
  ///
  /// In en, this message translates to:
  /// **'Deactivating user...'**
  String get deactivatingUser;

  /// No description provided for @deactivatingUsers.
  ///
  /// In en, this message translates to:
  /// **'Deactivating users...'**
  String get deactivatingUsers;

  /// No description provided for @defaultHoursForNewFields.
  ///
  /// In en, this message translates to:
  /// **'Default hours for new fields'**
  String get defaultHoursForNewFields;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategory;

  /// No description provided for @deleteCity.
  ///
  /// In en, this message translates to:
  /// **'Delete City'**
  String get deleteCity;

  /// No description provided for @deleteField2.
  ///
  /// In en, this message translates to:
  /// **'Delete field'**
  String get deleteField2;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently'**
  String get deletePermanently;

  /// No description provided for @deleteReview.
  ///
  /// In en, this message translates to:
  /// **'Delete Review?'**
  String get deleteReview;

  /// No description provided for @deletingCity.
  ///
  /// In en, this message translates to:
  /// **'Deleting city...'**
  String get deletingCity;

  /// No description provided for @deletingField.
  ///
  /// In en, this message translates to:
  /// **'Deleting field...'**
  String get deletingField;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @deselect.
  ///
  /// In en, this message translates to:
  /// **'Deselect'**
  String get deselect;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get deselectAll;

  /// No description provided for @eGFootballBasketball.
  ///
  /// In en, this message translates to:
  /// **'e.g., Football, Basketball'**
  String get eGFootballBasketball;

  /// No description provided for @editCity.
  ///
  /// In en, this message translates to:
  /// **'Edit City'**
  String get editCity;

  /// No description provided for @editField2.
  ///
  /// In en, this message translates to:
  /// **'Edit field'**
  String get editField2;

  /// No description provided for @editReview.
  ///
  /// In en, this message translates to:
  /// **'Edit Review'**
  String get editReview;

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// No description provided for @egpEgyptianPound.
  ///
  /// In en, this message translates to:
  /// **'EGP (Egyptian Pound)'**
  String get egpEgyptianPound;

  /// No description provided for @egyptianPound.
  ///
  /// In en, this message translates to:
  /// **'Egyptian Pound'**
  String get egyptianPound;

  /// No description provided for @emailTemplates.
  ///
  /// In en, this message translates to:
  /// **'Email Templates'**
  String get emailTemplates;

  /// No description provided for @emailVerification.
  ///
  /// In en, this message translates to:
  /// **'Email Verification'**
  String get emailVerification;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @enableDisablePlatformAccess.
  ///
  /// In en, this message translates to:
  /// **'Enable/disable platform access'**
  String get enableDisablePlatformAccess;

  /// No description provided for @enterCityName.
  ///
  /// In en, this message translates to:
  /// **'Enter city name'**
  String get enterCityName;

  /// No description provided for @enterReasonForCancellation.
  ///
  /// In en, this message translates to:
  /// **'Enter reason for cancellation...'**
  String get enterReasonForCancellation;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @euro.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get euro;

  /// No description provided for @exampleEmailCom.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get exampleEmailCom;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @featureWillBeAvailableInAFutureUpdate.
  ///
  /// In en, this message translates to:
  /// **'\$feature will be available in a future update.'**
  String get featureWillBeAvailableInAFutureUpdate;

  /// No description provided for @featureWillBeAvailableSoonNstayTuned.
  ///
  /// In en, this message translates to:
  /// **'\$feature will be available soon.\\nStay tuned!'**
  String get featureWillBeAvailableSoonNstayTuned;

  /// No description provided for @fieldAssignedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Field assigned successfully'**
  String get fieldAssignedSuccessfully;

  /// No description provided for @fieldOwners2.
  ///
  /// In en, this message translates to:
  /// **'Field Owners'**
  String get fieldOwners2;

  /// No description provided for @fieldOwnersAdmins.
  ///
  /// In en, this message translates to:
  /// **'Field Owners (Admins)'**
  String get fieldOwnersAdmins;

  /// No description provided for @fieldPerformance.
  ///
  /// In en, this message translates to:
  /// **'Field Performance'**
  String get fieldPerformance;

  /// No description provided for @fieldscountFields.
  ///
  /// In en, this message translates to:
  /// **'\$fieldsCount fields'**
  String get fieldscountFields;

  /// No description provided for @getNotifiedAboutBookings.
  ///
  /// In en, this message translates to:
  /// **'Get notified about bookings'**
  String get getNotifiedAboutBookings;

  /// No description provided for @glassEffect.
  ///
  /// In en, this message translates to:
  /// **'Glass effect'**
  String get glassEffect;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @hideThisCityFromUsersCanBeReactivatedLat.
  ///
  /// In en, this message translates to:
  /// **'Hide this city from users. Can be reactivated later.'**
  String get hideThisCityFromUsersCanBeReactivatedLat;

  /// No description provided for @inactive2.
  ///
  /// In en, this message translates to:
  /// **'inactive'**
  String get inactive2;

  /// No description provided for @invalidPrice.
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get invalidPrice;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// No description provided for @joinDate.
  ///
  /// In en, this message translates to:
  /// **'Join Date'**
  String get joinDate;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'{label}: '**
  String label(Object label);

  /// No description provided for @labelCopied.
  ///
  /// In en, this message translates to:
  /// **'{label} copied'**
  String labelCopied(Object label);

  /// No description provided for @labelCount.
  ///
  /// In en, this message translates to:
  /// **'{label} ({count})'**
  String labelCount(Object count, Object label);

  /// No description provided for @last6Months.
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get last6Months;

  /// No description provided for @last6MonthsRevenue.
  ///
  /// In en, this message translates to:
  /// **'Last 6 months revenue'**
  String get last6MonthsRevenue;

  /// No description provided for @loadingAdmins.
  ///
  /// In en, this message translates to:
  /// **'Loading admins...'**
  String get loadingAdmins;

  /// No description provided for @loadingAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Loading analytics...'**
  String get loadingAnalytics;

  /// No description provided for @loadingAvailableTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'Loading available time slots...'**
  String get loadingAvailableTimeSlots;

  /// No description provided for @loadingBookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading booking details...'**
  String get loadingBookingDetails;

  /// No description provided for @loadingBookings.
  ///
  /// In en, this message translates to:
  /// **'Loading bookings...'**
  String get loadingBookings;

  /// No description provided for @loadingDashboard.
  ///
  /// In en, this message translates to:
  /// **'Loading dashboard...'**
  String get loadingDashboard;

  /// No description provided for @loadingPlatformData.
  ///
  /// In en, this message translates to:
  /// **'Loading platform data...'**
  String get loadingPlatformData;

  /// No description provided for @loadingRevenueData.
  ///
  /// In en, this message translates to:
  /// **'Loading revenue data...'**
  String get loadingRevenueData;

  /// No description provided for @loadingReviews.
  ///
  /// In en, this message translates to:
  /// **'Loading reviews...'**
  String get loadingReviews;

  /// No description provided for @loadingUsers.
  ///
  /// In en, this message translates to:
  /// **'Loading users...'**
  String get loadingUsers;

  /// No description provided for @loadingYourBookings.
  ///
  /// In en, this message translates to:
  /// **'Loading your bookings...'**
  String get loadingYourBookings;

  /// No description provided for @loadingYourFields.
  ///
  /// In en, this message translates to:
  /// **'Loading your fields...'**
  String get loadingYourFields;

  /// No description provided for @logFailedLogins.
  ///
  /// In en, this message translates to:
  /// **'Log Failed Logins'**
  String get logFailedLogins;

  /// No description provided for @maintenanceMode.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Mode'**
  String get maintenanceMode;

  /// No description provided for @manageCities.
  ///
  /// In en, this message translates to:
  /// **'Manage Cities'**
  String get manageCities;

  /// No description provided for @manageCustomers.
  ///
  /// In en, this message translates to:
  /// **'Manage customers'**
  String get manageCustomers;

  /// No description provided for @manageFieldOwners.
  ///
  /// In en, this message translates to:
  /// **'Manage field owners'**
  String get manageFieldOwners;

  /// No description provided for @managePlatformLocations.
  ///
  /// In en, this message translates to:
  /// **'Manage platform locations'**
  String get managePlatformLocations;

  /// No description provided for @managePlatformNotifications.
  ///
  /// In en, this message translates to:
  /// **'Manage platform notifications'**
  String get managePlatformNotifications;

  /// No description provided for @manageSportTypes.
  ///
  /// In en, this message translates to:
  /// **'Manage sport types'**
  String get manageSportTypes;

  /// No description provided for @manageUsers.
  ///
  /// In en, this message translates to:
  /// **'Manage Users'**
  String get manageUsers;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @markAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markAsCompleted;

  /// No description provided for @memberDays.
  ///
  /// In en, this message translates to:
  /// **'Member Days'**
  String get memberDays;

  /// No description provided for @minutesMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, one {{minutes} minute} other {{minutes} minutes}}'**
  String minutesMinutes(num minutes);

  /// No description provided for @mmDdYyyy.
  ///
  /// In en, this message translates to:
  /// **'MM/DD/YYYY'**
  String get mmDdYyyy;

  /// No description provided for @moderatePlatformReviews.
  ///
  /// In en, this message translates to:
  /// **'Moderate platform reviews'**
  String get moderatePlatformReviews;

  /// No description provided for @monthlyBookings.
  ///
  /// In en, this message translates to:
  /// **'Monthly Bookings'**
  String get monthlyBookings;

  /// No description provided for @mostBookedFields.
  ///
  /// In en, this message translates to:
  /// **'Most booked fields'**
  String get mostBookedFields;

  /// No description provided for @newFields.
  ///
  /// In en, this message translates to:
  /// **'New Fields'**
  String get newFields;

  /// No description provided for @newNotification.
  ///
  /// In en, this message translates to:
  /// **'New Notification'**
  String get newNotification;

  /// No description provided for @noBookingsYet2.
  ///
  /// In en, this message translates to:
  /// **'No Bookings Yet'**
  String get noBookingsYet2;

  /// No description provided for @noFavoritesYet2.
  ///
  /// In en, this message translates to:
  /// **'No Favorites Yet'**
  String get noFavoritesYet2;

  /// No description provided for @noFeaturedFieldsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No featured fields available'**
  String get noFeaturedFieldsAvailable;

  /// No description provided for @noFieldsAvailable2.
  ///
  /// In en, this message translates to:
  /// **'No Fields Available'**
  String get noFieldsAvailable2;

  /// No description provided for @noPastBookings.
  ///
  /// In en, this message translates to:
  /// **'No Past Bookings'**
  String get noPastBookings;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get noResultsFound;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No Reviews Yet'**
  String get noReviewsYet;

  /// No description provided for @noUpcomingBookings2.
  ///
  /// In en, this message translates to:
  /// **'No Upcoming Bookings'**
  String get noUpcomingBookings2;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @operatingHours.
  ///
  /// In en, this message translates to:
  /// **'Operating Hours'**
  String get operatingHours;

  /// No description provided for @paymentSettings.
  ///
  /// In en, this message translates to:
  /// **'Payment Settings'**
  String get paymentSettings;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @perBooking.
  ///
  /// In en, this message translates to:
  /// **'Per booking'**
  String get perBooking;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @performanceMetrics.
  ///
  /// In en, this message translates to:
  /// **'Performance Metrics'**
  String get performanceMetrics;

  /// No description provided for @permanentDelete.
  ///
  /// In en, this message translates to:
  /// **'Permanent Delete'**
  String get permanentDelete;

  /// No description provided for @permanentlyRemoveThisCity.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove this city'**
  String get permanentlyRemoveThisCity;

  /// No description provided for @phone2.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone2;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @platformAnalyticsAndExports.
  ///
  /// In en, this message translates to:
  /// **'Platform analytics & exports'**
  String get platformAnalyticsAndExports;

  /// No description provided for @platformConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Platform configuration'**
  String get platformConfiguration;

  /// No description provided for @platformDataExportedToCsv.
  ///
  /// In en, this message translates to:
  /// **'Platform data exported to CSV'**
  String get platformDataExportedToCsv;

  /// No description provided for @platformInsights.
  ///
  /// In en, this message translates to:
  /// **'Platform insights'**
  String get platformInsights;

  /// No description provided for @platformPerformanceMetrics.
  ///
  /// In en, this message translates to:
  /// **'Platform performance metrics'**
  String get platformPerformanceMetrics;

  /// No description provided for @platformSecurityMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Platform security monitoring'**
  String get platformSecurityMonitoring;

  /// No description provided for @pleaseAcceptTheTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms & Conditions'**
  String get pleaseAcceptTheTermsAndConditions;

  /// No description provided for @pleaseEnableLocationPermissionsInSetting.
  ///
  /// In en, this message translates to:
  /// **'Please enable location permissions in settings'**
  String get pleaseEnableLocationPermissionsInSetting;

  /// No description provided for @pleaseEnterACategoryName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a category name'**
  String get pleaseEnterACategoryName;

  /// No description provided for @pricePerHourEgp.
  ///
  /// In en, this message translates to:
  /// **'Price per Hour (EGP)'**
  String get pricePerHourEgp;

  /// No description provided for @pricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing;

  /// No description provided for @readOurPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get readOurPrivacyPolicy;

  /// No description provided for @readOurTerms.
  ///
  /// In en, this message translates to:
  /// **'Read our terms'**
  String get readOurTerms;

  /// No description provided for @receivePushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive push notifications'**
  String get receivePushNotifications;

  /// No description provided for @receiveUpdatesViaEmail.
  ///
  /// In en, this message translates to:
  /// **'Receive updates via email'**
  String get receiveUpdatesViaEmail;

  /// No description provided for @rejectingBooking.
  ///
  /// In en, this message translates to:
  /// **'Rejecting booking...'**
  String get rejectingBooking;

  /// No description provided for @removeCityFromDatabaseCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'Remove city from database. Cannot be undone.'**
  String get removeCityFromDatabaseCannotBeUndone;

  /// No description provided for @removeVerification.
  ///
  /// In en, this message translates to:
  /// **'Remove Verification'**
  String get removeVerification;

  /// No description provided for @removingVerification.
  ///
  /// In en, this message translates to:
  /// **'Removing verification...'**
  String get removingVerification;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @response.
  ///
  /// In en, this message translates to:
  /// **'Response'**
  String get response;

  /// No description provided for @revenueReport.
  ///
  /// In en, this message translates to:
  /// **'Revenue Report'**
  String get revenueReport;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @satisfaction.
  ///
  /// In en, this message translates to:
  /// **'Satisfaction'**
  String get satisfaction;

  /// No description provided for @saudiRiyal.
  ///
  /// In en, this message translates to:
  /// **'Saudi Riyal'**
  String get saudiRiyal;

  /// No description provided for @searchAdmins.
  ///
  /// In en, this message translates to:
  /// **'Search admins...'**
  String get searchAdmins;

  /// No description provided for @searchAdminsByNameEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Search admins by name, email, or phone...'**
  String get searchAdminsByNameEmailOrPhone;

  /// No description provided for @searchByCustomerFieldOrId.
  ///
  /// In en, this message translates to:
  /// **'Search by customer, field, or ID...'**
  String get searchByCustomerFieldOrId;

  /// No description provided for @searchByNameEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Search by name, email, or phone...'**
  String get searchByNameEmailOrPhone;

  /// No description provided for @searchByUserFieldOrBookingId.
  ///
  /// In en, this message translates to:
  /// **'Search by user, field, or booking ID...'**
  String get searchByUserFieldOrBookingId;

  /// No description provided for @searchByUserOrField.
  ///
  /// In en, this message translates to:
  /// **'Search by user or field...'**
  String get searchByUserOrField;

  /// No description provided for @searchCustomers.
  ///
  /// In en, this message translates to:
  /// **'Search customers...'**
  String get searchCustomers;

  /// No description provided for @searchFieldsByNameCityOrOwner.
  ///
  /// In en, this message translates to:
  /// **'Search fields by name, city, or owner...'**
  String get searchFieldsByNameCityOrOwner;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsers;

  /// No description provided for @searchUsersByNameEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Search users by name, email, or phone...'**
  String get searchUsersByNameEmailOrPhone;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @selectFieldLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Field Location'**
  String get selectFieldLocation;

  /// No description provided for @selectOnMap.
  ///
  /// In en, this message translates to:
  /// **'Select on map'**
  String get selectOnMap;

  /// No description provided for @selectSportCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Sport Category'**
  String get selectSportCategory;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @sessionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Session Timeout'**
  String get sessionTimeout;

  /// No description provided for @shareYourExperienceWithThisField.
  ///
  /// In en, this message translates to:
  /// **'Share your experience with this field...'**
  String get shareYourExperienceWithThisField;

  /// No description provided for @somethingWentWrong2.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get somethingWentWrong2;

  /// No description provided for @sportCategories.
  ///
  /// In en, this message translates to:
  /// **'Sport Categories'**
  String get sportCategories;

  /// No description provided for @sportCategory.
  ///
  /// In en, this message translates to:
  /// **'Sport Category'**
  String get sportCategory;

  /// No description provided for @sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// No description provided for @startAddingFieldsToYourFavorites.
  ///
  /// In en, this message translates to:
  /// **'Start adding fields to your favorites'**
  String get startAddingFieldsToYourFavorites;

  /// No description provided for @statisticsExportedToPdf.
  ///
  /// In en, this message translates to:
  /// **'Statistics exported to PDF'**
  String get statisticsExportedToPdf;

  /// No description provided for @streetAddressOrSelectOnMap.
  ///
  /// In en, this message translates to:
  /// **'Street address or select on map'**
  String get streetAddressOrSelectOnMap;

  /// No description provided for @submittingReview.
  ///
  /// In en, this message translates to:
  /// **'Submitting review...'**
  String get submittingReview;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @success2.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success2;

  /// No description provided for @successRate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get successRate;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @systemAlertsAndUpdates.
  ///
  /// In en, this message translates to:
  /// **'System alerts and updates'**
  String get systemAlertsAndUpdates;

  /// No description provided for @systemPreferences.
  ///
  /// In en, this message translates to:
  /// **'System Preferences'**
  String get systemPreferences;

  /// No description provided for @tellOthersAboutYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Tell others about your experience...'**
  String get tellOthersAboutYourExperience;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @thereAreNoFieldsInYourAreaYetNcheckBackS.
  ///
  /// In en, this message translates to:
  /// **'There are no fields in your area yet.\\nCheck back soon!'**
  String get thereAreNoFieldsInYourAreaYetNcheckBackS;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'title'**
  String get title;

  /// No description provided for @todayBookings2.
  ///
  /// In en, this message translates to:
  /// **'Today Bookings'**
  String get todayBookings2;

  /// No description provided for @todaySActivity.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Activity'**
  String get todaySActivity;

  /// No description provided for @topFieldsByBookings.
  ///
  /// In en, this message translates to:
  /// **'Top Fields by Bookings'**
  String get topFieldsByBookings;

  /// No description provided for @total2.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get total2;

  /// No description provided for @totalCities.
  ///
  /// In en, this message translates to:
  /// **'Total Cities'**
  String get totalCities;

  /// No description provided for @totalFields.
  ///
  /// In en, this message translates to:
  /// **'Total Fields'**
  String get totalFields;

  /// No description provided for @totalLogins.
  ///
  /// In en, this message translates to:
  /// **'Total Logins'**
  String get totalLogins;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpent;

  /// No description provided for @tryAdjustingYourFiltersOrNsearchWithDiff.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or\\nsearch with different keywords'**
  String get tryAdjustingYourFiltersOrNsearchWithDiff;

  /// No description provided for @twoFactorAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuthentication;

  /// No description provided for @unableToConnectToTheServerNpleaseCheckYo.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server.\\nPlease check your internet.'**
  String get unableToConnectToTheServerNpleaseCheckYo;

  /// No description provided for @unableToLoadFields.
  ///
  /// In en, this message translates to:
  /// **'Unable to load fields'**
  String get unableToLoadFields;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @updateCityName.
  ///
  /// In en, this message translates to:
  /// **'Update city name'**
  String get updateCityName;

  /// No description provided for @updateFieldDetailsPricingAndLocation.
  ///
  /// In en, this message translates to:
  /// **'Update field details, pricing, and location'**
  String get updateFieldDetailsPricingAndLocation;

  /// No description provided for @updateReview.
  ///
  /// In en, this message translates to:
  /// **'Update Review'**
  String get updateReview;

  /// No description provided for @updateYourLoginPassword.
  ///
  /// In en, this message translates to:
  /// **'Update your login password'**
  String get updateYourLoginPassword;

  /// No description provided for @updateYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get updateYourPassword;

  /// No description provided for @updatingBooking.
  ///
  /// In en, this message translates to:
  /// **'Updating booking...'**
  String get updatingBooking;

  /// No description provided for @updatingBookingStatus.
  ///
  /// In en, this message translates to:
  /// **'Updating booking status...'**
  String get updatingBookingStatus;

  /// No description provided for @updatingCity.
  ///
  /// In en, this message translates to:
  /// **'Updating city...'**
  String get updatingCity;

  /// No description provided for @updatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Updating profile...'**
  String get updatingProfile;

  /// No description provided for @usDollar.
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get usDollar;

  /// No description provided for @userActivated.
  ///
  /// In en, this message translates to:
  /// **'User activated'**
  String get userActivated;

  /// No description provided for @userActivityReport.
  ///
  /// In en, this message translates to:
  /// **'User Activity Report'**
  String get userActivityReport;

  /// No description provided for @userDeactivated.
  ///
  /// In en, this message translates to:
  /// **'User deactivated'**
  String get userDeactivated;

  /// No description provided for @userDetails.
  ///
  /// In en, this message translates to:
  /// **'User Details'**
  String get userDetails;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @usersExportedToCsv.
  ///
  /// In en, this message translates to:
  /// **'Users exported to CSV'**
  String get usersExportedToCsv;

  /// No description provided for @verifyField.
  ///
  /// In en, this message translates to:
  /// **'Verify Field'**
  String get verifyField;

  /// No description provided for @verifyingField.
  ///
  /// In en, this message translates to:
  /// **'Verifying field...'**
  String get verifyingField;

  /// No description provided for @viewAdmins.
  ///
  /// In en, this message translates to:
  /// **'View Admins'**
  String get viewAdmins;

  /// No description provided for @viewAllReservations.
  ///
  /// In en, this message translates to:
  /// **'View all reservations'**
  String get viewAllReservations;

  /// No description provided for @viewAllSportsFields.
  ///
  /// In en, this message translates to:
  /// **'View all sports fields'**
  String get viewAllSportsFields;

  /// No description provided for @viewAndManageYourBookings.
  ///
  /// In en, this message translates to:
  /// **'View and manage your bookings'**
  String get viewAndManageYourBookings;

  /// No description provided for @viewBookings.
  ///
  /// In en, this message translates to:
  /// **'View Bookings'**
  String get viewBookings;

  /// No description provided for @viewFields.
  ///
  /// In en, this message translates to:
  /// **'View Fields'**
  String get viewFields;

  /// No description provided for @viewRecentLoginAttempts.
  ///
  /// In en, this message translates to:
  /// **'View recent login attempts'**
  String get viewRecentLoginAttempts;

  /// No description provided for @viewUsers.
  ///
  /// In en, this message translates to:
  /// **'View Users'**
  String get viewUsers;

  /// No description provided for @viewYourProfileDetails.
  ///
  /// In en, this message translates to:
  /// **'View your profile details'**
  String get viewYourProfileDetails;

  /// No description provided for @vodafoneCash.
  ///
  /// In en, this message translates to:
  /// **'vodafone_cash'**
  String get vodafoneCash;

  /// No description provided for @weeklySchedule.
  ///
  /// In en, this message translates to:
  /// **'Weekly Schedule'**
  String get weeklySchedule;

  /// No description provided for @writeAReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeAReview;

  /// No description provided for @youMustBeLoggedInToReview.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to review'**
  String get youMustBeLoggedInToReview;

  /// No description provided for @yourRating.
  ///
  /// In en, this message translates to:
  /// **'Your Rating *'**
  String get yourRating;

  /// No description provided for @yyyyMmDd.
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD'**
  String get yyyyMmDd;

  /// No description provided for @rateYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Experience'**
  String get rateYourExperience;

  /// No description provided for @helpOthersMakeInformedDecisions.
  ///
  /// In en, this message translates to:
  /// **'Share your experience to help others make informed decisions'**
  String get helpOthersMakeInformedDecisions;

  /// No description provided for @recentReviewsFromCustomers.
  ///
  /// In en, this message translates to:
  /// **'Recent reviews from our customers'**
  String get recentReviewsFromCustomers;

  /// No description provided for @errorLoadingFieldMessage.
  ///
  /// In en, this message translates to:
  /// **'Error loading field: {message}'**
  String errorLoadingFieldMessage(Object message);

  /// No description provided for @updateFieldSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update {fieldName}'**
  String updateFieldSubtitle(Object fieldName);

  /// No description provided for @reviewsSummaryForField.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{fieldName} • {count} review} other {{fieldName} • {count} reviews}}'**
  String reviewsSummaryForField(num count, Object fieldName);

  /// No description provided for @totalAdminsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} total admin} other {{count} total admins}}'**
  String totalAdminsCount(num count);

  /// No description provided for @totalUsersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} total user} other {{count} total users}}'**
  String totalUsersCount(num count);

  /// No description provided for @totalBookingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} total booking} other {{count} total bookings}}'**
  String totalBookingsCount(num count);

  /// No description provided for @totalFieldsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} total field} other {{count} total fields}}'**
  String totalFieldsCount(num count);

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(Object message);

  /// No description provided for @ownerIdShort.
  ///
  /// In en, this message translates to:
  /// **'Owner ID: {id}...'**
  String ownerIdShort(Object id);

  /// No description provided for @bookingHistory.
  ///
  /// In en, this message translates to:
  /// **'Booking History'**
  String get bookingHistory;

  /// No description provided for @advancedFilters.
  ///
  /// In en, this message translates to:
  /// **'Advanced Filters'**
  String get advancedFilters;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

  /// No description provided for @startAddingFavorites.
  ///
  /// In en, this message translates to:
  /// **'Start adding fields to your favorites\\nfor quick access anytime'**
  String get startAddingFavorites;

  /// No description provided for @bookAField.
  ///
  /// In en, this message translates to:
  /// **'Book a Field'**
  String get bookAField;

  /// No description provided for @userRole.
  ///
  /// In en, this message translates to:
  /// **'user'**
  String get userRole;

  /// No description provided for @adminRole.
  ///
  /// In en, this message translates to:
  /// **'admin'**
  String get adminRole;

  /// No description provided for @aZ.
  ///
  /// In en, this message translates to:
  /// **'[A-Z]'**
  String get aZ;

  /// No description provided for @aToZ.
  ///
  /// In en, this message translates to:
  /// **'[a-z]'**
  String get aToZ;

  /// No description provided for @iAgreeToThe.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeToThe;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  /// No description provided for @mybookings.
  ///
  /// In en, this message translates to:
  /// **'myBookings'**
  String get mybookings;

  /// No description provided for @eeeMmmD.
  ///
  /// In en, this message translates to:
  /// **'EEE, MMM d'**
  String get eeeMmmD;

  /// No description provided for @mmmmYyyy.
  ///
  /// In en, this message translates to:
  /// **'MMMM yyyy'**
  String get mmmmYyyy;

  /// No description provided for @eee.
  ///
  /// In en, this message translates to:
  /// **'EEE'**
  String get eee;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @verifiedField.
  ///
  /// In en, this message translates to:
  /// **'Verified Field'**
  String get verifiedField;

  /// No description provided for @indoorType.
  ///
  /// In en, this message translates to:
  /// **'indoor'**
  String get indoorType;

  /// No description provided for @outdoorType.
  ///
  /// In en, this message translates to:
  /// **'outdoor'**
  String get outdoorType;

  /// No description provided for @aboutThisField.
  ///
  /// In en, this message translates to:
  /// **'About This Field'**
  String get aboutThisField;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @autoBookSameTimeEveryWeek.
  ///
  /// In en, this message translates to:
  /// **'Auto-book same time every week'**
  String get autoBookSameTimeEveryWeek;

  /// No description provided for @getDirections.
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'recommended'**
  String get recommended;

  /// No description provided for @priceAsc.
  ///
  /// In en, this message translates to:
  /// **'price_asc'**
  String get priceAsc;

  /// No description provided for @priceDesc.
  ///
  /// In en, this message translates to:
  /// **'price_desc'**
  String get priceDesc;

  /// No description provided for @ratingField.
  ///
  /// In en, this message translates to:
  /// **'rating'**
  String get ratingField;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'profile'**
  String get profileTab;

  /// No description provided for @fieldslist.
  ///
  /// In en, this message translates to:
  /// **'fieldsList'**
  String get fieldslist;

  /// No description provided for @favoritesTab.
  ///
  /// In en, this message translates to:
  /// **'favorites'**
  String get favoritesTab;

  /// No description provided for @descriptionField.
  ///
  /// In en, this message translates to:
  /// **'description'**
  String get descriptionField;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'icon'**
  String get icon;

  /// No description provided for @bookingsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Bookings will appear here'**
  String get bookingsWillAppearHere;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @noBookingsForThisFieldIn.
  ///
  /// In en, this message translates to:
  /// **'No bookings for this field in this week'**
  String get noBookingsForThisFieldIn;

  /// No description provided for @scrollRightToSeeAllDays.
  ///
  /// In en, this message translates to:
  /// **'Scroll right to see all days (Sat-Fri)'**
  String get scrollRightToSeeAllDays;

  /// No description provided for @verifiedBadge.
  ///
  /// In en, this message translates to:
  /// **'VERIFIED'**
  String get verifiedBadge;

  /// No description provided for @createNewCustomer.
  ///
  /// In en, this message translates to:
  /// **'Create New Customer'**
  String get createNewCustomer;

  /// No description provided for @noFieldDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No field data available'**
  String get noFieldDataAvailable;

  /// No description provided for @vsLastPeriod.
  ///
  /// In en, this message translates to:
  /// **'vs last period'**
  String get vsLastPeriod;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get pendingStatus;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'confirmed'**
  String get confirmed;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'canceled'**
  String get canceled;

  /// No description provided for @tryAdjustingYourFiltersOrSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search'**
  String get tryAdjustingYourFiltersOrSearch;

  /// No description provided for @ownerbookings.
  ///
  /// In en, this message translates to:
  /// **'ownerBookings'**
  String get ownerbookings;

  /// No description provided for @sportKickV100.
  ///
  /// In en, this message translates to:
  /// **'Sport Kick v1.0.0'**
  String get sportKickV100;

  /// No description provided for @o.
  ///
  /// In en, this message translates to:
  /// **'O'**
  String get o;

  /// No description provided for @noRecentBookings.
  ///
  /// In en, this message translates to:
  /// **'No Recent Bookings'**
  String get noRecentBookings;

  /// No description provided for @yourRecentBookingsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your recent bookings will appear here'**
  String get yourRecentBookingsWillAppearHere;

  /// No description provided for @manageYourPreferences.
  ///
  /// In en, this message translates to:
  /// **'Manage your preferences'**
  String get manageYourPreferences;

  /// No description provided for @howWouldYouRateThisField.
  ///
  /// In en, this message translates to:
  /// **'How would you rate this field?'**
  String get howWouldYouRateThisField;

  /// No description provided for @shareYourExperienceOptional.
  ///
  /// In en, this message translates to:
  /// **'Share your experience (optional)'**
  String get shareYourExperienceOptional;

  /// No description provided for @reviewing.
  ///
  /// In en, this message translates to:
  /// **'Reviewing'**
  String get reviewing;

  /// No description provided for @yourReviewOptional.
  ///
  /// In en, this message translates to:
  /// **'Your Review (Optional)'**
  String get yourReviewOptional;

  /// No description provided for @youCanUpdateYourRatingAnd.
  ///
  /// In en, this message translates to:
  /// **'You can update your rating and comment'**
  String get youCanUpdateYourRatingAnd;

  /// No description provided for @noRatingsYet.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get noRatingsYet;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @edited.
  ///
  /// In en, this message translates to:
  /// **'(edited)'**
  String get edited;

  /// No description provided for @recentReview.
  ///
  /// In en, this message translates to:
  /// **'Recent Review'**
  String get recentReview;

  /// No description provided for @filterByRating.
  ///
  /// In en, this message translates to:
  /// **'Filter by Rating'**
  String get filterByRating;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @thisActionCannotBeUndoneAre.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Are you sure you want to delete this review?'**
  String get thisActionCannotBeUndoneAre;

  /// No description provided for @editedLabel.
  ///
  /// In en, this message translates to:
  /// **'edited'**
  String get editedLabel;

  /// No description provided for @editingReviewFor.
  ///
  /// In en, this message translates to:
  /// **'Editing review for'**
  String get editingReviewFor;

  /// No description provided for @shareYourExperienceToHelpOthers.
  ///
  /// In en, this message translates to:
  /// **'Share your experience to help others'**
  String get shareYourExperienceToHelpOthers;

  /// No description provided for @updateRatingPrompt.
  ///
  /// In en, this message translates to:
  /// **'You can update your rating and comment anytime'**
  String get updateRatingPrompt;

  /// No description provided for @shareDetailsAboutYourExperienceN.
  ///
  /// In en, this message translates to:
  /// **'Share details about your experience...\\n\\n'**
  String get shareDetailsAboutYourExperienceN;

  /// No description provided for @howWasTheFieldConditionN.
  ///
  /// In en, this message translates to:
  /// **'- How was the field condition?\\n'**
  String get howWasTheFieldConditionN;

  /// No description provided for @reviewUpdated.
  ///
  /// In en, this message translates to:
  /// **'Review Updated!'**
  String get reviewUpdated;

  /// No description provided for @reviewSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Review Submitted!'**
  String get reviewSubmittedSuccess;

  /// No description provided for @yourReviewHasBeenUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your review has been updated successfully'**
  String get yourReviewHasBeenUpdatedSuccessfully;

  /// No description provided for @egpE.
  ///
  /// In en, this message translates to:
  /// **'EGP (E£)'**
  String get egpE;

  /// No description provided for @eur.
  ///
  /// In en, this message translates to:
  /// **'EUR (€)'**
  String get eur;

  /// No description provided for @sar.
  ///
  /// In en, this message translates to:
  /// **'SAR (﷼)'**
  String get sar;

  /// No description provided for @eG25122025.
  ///
  /// In en, this message translates to:
  /// **'e.g., 25/12/2025'**
  String get eG25122025;

  /// No description provided for @eG12252025.
  ///
  /// In en, this message translates to:
  /// **'e.g., 12/25/2025'**
  String get eG12252025;

  /// No description provided for @eG20251225.
  ///
  /// In en, this message translates to:
  /// **'e.g., 2025-12-25'**
  String get eG20251225;

  /// No description provided for @loginactivity.
  ///
  /// In en, this message translates to:
  /// **'loginActivity'**
  String get loginactivity;

  /// No description provided for @notificationManagementWillBeNavailableIn.
  ///
  /// In en, this message translates to:
  /// **'Notification management will be\\navailable in a future update.'**
  String get notificationManagementWillBeNavailableIn;

  /// No description provided for @reviewsModerationWillBeNavailableIn.
  ///
  /// In en, this message translates to:
  /// **'Reviews moderation will be\\navailable in a future update.'**
  String get reviewsModerationWillBeNavailableIn;

  /// No description provided for @failedToLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories'**
  String get failedToLoadCategories;

  /// No description provided for @noCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No Categories Yet'**
  String get noCategoriesYet;

  /// No description provided for @tapTheButtonToCreateNyour.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create\\nyour first sport category'**
  String get tapTheButtonToCreateNyour;

  /// No description provided for @platformPerformance.
  ///
  /// In en, this message translates to:
  /// **'Platform Performance'**
  String get platformPerformance;

  /// No description provided for @comprehensiveOverviewOfYourPlatformMetrics.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive overview of your platform metrics'**
  String get comprehensiveOverviewOfYourPlatformMetrics;

  /// No description provided for @errorLoadingAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Error loading analytics'**
  String get errorLoadingAnalytics;

  /// No description provided for @enforceOperatingHours.
  ///
  /// In en, this message translates to:
  /// **'Enforce Operating Hours'**
  String get enforceOperatingHours;

  /// No description provided for @applyToAllFieldBookings.
  ///
  /// In en, this message translates to:
  /// **'Apply to all field bookings'**
  String get applyToAllFieldBookings;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @userRegistrationsAndEngagement.
  ///
  /// In en, this message translates to:
  /// **'User registrations and engagement'**
  String get userRegistrationsAndEngagement;

  /// No description provided for @platformWideRevenueAndTransactions.
  ///
  /// In en, this message translates to:
  /// **'Platform-wide revenue and transactions'**
  String get platformWideRevenueAndTransactions;

  /// No description provided for @bookingTrendsAndFieldUtilization.
  ///
  /// In en, this message translates to:
  /// **'Booking trends and field utilization'**
  String get bookingTrendsAndFieldUtilization;

  /// No description provided for @fieldRatingsAndReviewAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Field ratings and review analysis'**
  String get fieldRatingsAndReviewAnalysis;

  /// No description provided for @quickOverview.
  ///
  /// In en, this message translates to:
  /// **'Quick Overview'**
  String get quickOverview;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @generateAndDownloadDetailedReportsIn.
  ///
  /// In en, this message translates to:
  /// **'Generate and download detailed reports in CSV or PDF format.'**
  String get generateAndDownloadDetailedReportsIn;

  /// No description provided for @activatingAdmin.
  ///
  /// In en, this message translates to:
  /// **'Activating admin...'**
  String get activatingAdmin;

  /// No description provided for @deactivatingAdmin.
  ///
  /// In en, this message translates to:
  /// **'Deactivating admin...'**
  String get deactivatingAdmin;

  /// No description provided for @permanentlyDeletingField.
  ///
  /// In en, this message translates to:
  /// **'Permanently deleting field...'**
  String get permanentlyDeletingField;

  /// No description provided for @deactivatingField.
  ///
  /// In en, this message translates to:
  /// **'Deactivating field...'**
  String get deactivatingField;

  /// No description provided for @noAdminsYet.
  ///
  /// In en, this message translates to:
  /// **'No Admins Yet'**
  String get noAdminsYet;

  /// No description provided for @createYourFirstFieldOwnerAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your first field owner account'**
  String get createYourFirstFieldOwnerAccount;

  /// No description provided for @errorLoadingAdmins.
  ///
  /// In en, this message translates to:
  /// **'Error loading admins'**
  String get errorLoadingAdmins;

  /// No description provided for @assignedFields.
  ///
  /// In en, this message translates to:
  /// **'Assigned Fields'**
  String get assignedFields;

  /// No description provided for @noFieldsAssigned.
  ///
  /// In en, this message translates to:
  /// **'No Fields Assigned'**
  String get noFieldsAssigned;

  /// No description provided for @thisAdminDoesn.
  ///
  /// In en, this message translates to:
  /// **'This admin doesn\\'**
  String get thisAdminDoesn;

  /// No description provided for @superAdmin.
  ///
  /// In en, this message translates to:
  /// **'super_admin'**
  String get superAdmin;

  /// No description provided for @activeAccount.
  ///
  /// In en, this message translates to:
  /// **'Active Account'**
  String get activeAccount;

  /// No description provided for @inactiveAccount.
  ///
  /// In en, this message translates to:
  /// **'Inactive Account'**
  String get inactiveAccount;

  /// No description provided for @formatAdminCreatedat.
  ///
  /// In en, this message translates to:
  /// **').format(admin.createdAt)}'**
  String get formatAdminCreatedat;

  /// No description provided for @allAvailableFieldsAssigned.
  ///
  /// In en, this message translates to:
  /// **'All Available Fields Assigned'**
  String get allAvailableFieldsAssigned;

  /// No description provided for @thisAdminAlreadyHasAllAvailable.
  ///
  /// In en, this message translates to:
  /// **'This admin already has all available fields assigned.'**
  String get thisAdminAlreadyHasAllAvailable;

  /// No description provided for @tryAdjustingYourSearchOrFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get tryAdjustingYourSearchOrFilters;

  /// No description provided for @bookingsOverview.
  ///
  /// In en, this message translates to:
  /// **'Bookings Overview'**
  String get bookingsOverview;

  /// No description provided for @mmmDdYyyy.
  ///
  /// In en, this message translates to:
  /// **'MMM dd, yyyy'**
  String get mmmDdYyyy;

  /// No description provided for @longPressForActions.
  ///
  /// In en, this message translates to:
  /// **'Long press for actions'**
  String get longPressForActions;

  /// No description provided for @tryAdjustingYourFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get tryAdjustingYourFilters;

  /// No description provided for @errorLoadingFields.
  ///
  /// In en, this message translates to:
  /// **'Error loading fields'**
  String get errorLoadingFields;

  /// No description provided for @fieldsOverview.
  ///
  /// In en, this message translates to:
  /// **'Fields Overview'**
  String get fieldsOverview;

  /// No description provided for @noCitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No cities found'**
  String get noCitiesFound;

  /// No description provided for @tryChangingTheFilter.
  ///
  /// In en, this message translates to:
  /// **'Try changing the filter'**
  String get tryChangingTheFilter;

  /// No description provided for @platformCoverage.
  ///
  /// In en, this message translates to:
  /// **'Platform Coverage'**
  String get platformCoverage;

  /// No description provided for @createFieldOwnerAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Field Owner Account'**
  String get createFieldOwnerAccount;

  /// No description provided for @aSecurePasswordWillBeGenerated.
  ///
  /// In en, this message translates to:
  /// **'A secure password will be generated automatically. The admin must change it on first login.'**
  String get aSecurePasswordWillBeGenerated;

  /// No description provided for @adminAccountHasBeenCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Admin account has been created successfully. Please save these credentials:'**
  String get adminAccountHasBeenCreatedSuccessfully;

  /// No description provided for @adminMustChangePasswordOnFirst.
  ///
  /// In en, this message translates to:
  /// **'Admin must change password on first login'**
  String get adminMustChangePasswordOnFirst;

  /// No description provided for @eGChampionsField.
  ///
  /// In en, this message translates to:
  /// **'e.g., Champions Field'**
  String get eGChampionsField;

  /// No description provided for @selectAvailableFacilities.
  ///
  /// In en, this message translates to:
  /// **'Select Available Facilities'**
  String get selectAvailableFacilities;

  /// No description provided for @fillInDetailsAndAssignTo.
  ///
  /// In en, this message translates to:
  /// **'Fill in details and assign to admin'**
  String get fillInDetailsAndAssignTo;

  /// No description provided for @indoorField.
  ///
  /// In en, this message translates to:
  /// **'Indoor Field'**
  String get indoorField;

  /// No description provided for @vodafoneCashNumberForReceivingPayments.
  ///
  /// In en, this message translates to:
  /// **'Vodafone Cash number for receiving payments'**
  String get vodafoneCashNumberForReceivingPayments;

  /// No description provided for @instapayNumberForReceivingTransfers.
  ///
  /// In en, this message translates to:
  /// **'InstaPay number for receiving transfers'**
  String get instapayNumberForReceivingTransfers;

  /// No description provided for @sportKickPlatform.
  ///
  /// In en, this message translates to:
  /// **'Sport Kick Platform'**
  String get sportKickPlatform;

  /// No description provided for @platformOverview.
  ///
  /// In en, this message translates to:
  /// **'Platform Overview'**
  String get platformOverview;

  /// No description provided for @chooseHowToDeleteThisField.
  ///
  /// In en, this message translates to:
  /// **'Choose how to delete this field:'**
  String get chooseHowToDeleteThisField;

  /// No description provided for @fieldWillBeHiddenFromUsers.
  ///
  /// In en, this message translates to:
  /// **'Field will be hidden from users but data is preserved. Can be reactivated later.'**
  String get fieldWillBeHiddenFromUsers;

  /// No description provided for @allDataWillBePermanentlyRemoved.
  ///
  /// In en, this message translates to:
  /// **'All data will be permanently removed. This action cannot be undone!'**
  String get allDataWillBePermanentlyRemoved;

  /// No description provided for @removeVerifiedBadgeFromThisField.
  ///
  /// In en, this message translates to:
  /// **'Remove verified badge from this field'**
  String get removeVerifiedBadgeFromThisField;

  /// No description provided for @addVerifiedBadgeToThisField.
  ///
  /// In en, this message translates to:
  /// **'Add verified badge to this field'**
  String get addVerifiedBadgeToThisField;

  /// No description provided for @noAdminsMatchYourFilters.
  ///
  /// In en, this message translates to:
  /// **'No admins match your filters'**
  String get noAdminsMatchYourFilters;

  /// No description provided for @noAdminsFound.
  ///
  /// In en, this message translates to:
  /// **'No admins found'**
  String get noAdminsFound;

  /// No description provided for @noUsersMatchYourFilters.
  ///
  /// In en, this message translates to:
  /// **'No users match your filters'**
  String get noUsersMatchYourFilters;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @areYouSureYouWantTo.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to enable maintenance mode? '**
  String get areYouSureYouWantTo;

  /// No description provided for @thisWillPreventUsersFromAccessing.
  ///
  /// In en, this message translates to:
  /// **'This will prevent users from accessing the platform.'**
  String get thisWillPreventUsersFromAccessing;

  /// No description provided for @changepassword.
  ///
  /// In en, this message translates to:
  /// **'changePassword'**
  String get changepassword;

  /// No description provided for @termsofservice.
  ///
  /// In en, this message translates to:
  /// **'termsOfService'**
  String get termsofservice;

  /// No description provided for @privacypolicy.
  ///
  /// In en, this message translates to:
  /// **'privacyPolicy'**
  String get privacypolicy;

  /// No description provided for @editprofile.
  ///
  /// In en, this message translates to:
  /// **'editProfile'**
  String get editprofile;

  /// No description provided for @dateFormatSettings.
  ///
  /// In en, this message translates to:
  /// **'Date Format Settings'**
  String get dateFormatSettings;

  /// No description provided for @currencySettings.
  ///
  /// In en, this message translates to:
  /// **'Currency Settings'**
  String get currencySettings;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @noUsersYet.
  ///
  /// In en, this message translates to:
  /// **'No Users Yet'**
  String get noUsersYet;

  /// No description provided for @errorLoadingUsers.
  ///
  /// In en, this message translates to:
  /// **'Error loading users'**
  String get errorLoadingUsers;

  /// No description provided for @deactivateAccount.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Account'**
  String get deactivateAccount;

  /// No description provided for @activateAccount.
  ///
  /// In en, this message translates to:
  /// **'Activate Account'**
  String get activateAccount;

  /// No description provided for @mmmDY.
  ///
  /// In en, this message translates to:
  /// **'MMM d, y'**
  String get mmmDY;

  /// No description provided for @thisUserHasn.
  ///
  /// In en, this message translates to:
  /// **'This user hasn\\'**
  String get thisUserHasn;

  /// No description provided for @formatUserCreatedat.
  ///
  /// In en, this message translates to:
  /// **').format(user.createdAt)}'**
  String get formatUserCreatedat;

  /// No description provided for @thisWillPreventTheUserFrom.
  ///
  /// In en, this message translates to:
  /// **'This will prevent the user from logging in and making new bookings.'**
  String get thisWillPreventTheUserFrom;

  /// No description provided for @manageAdmins.
  ///
  /// In en, this message translates to:
  /// **'Manage Admins'**
  String get manageAdmins;

  /// No description provided for @viewAndManageFieldOwnerAccounts.
  ///
  /// In en, this message translates to:
  /// **'View and manage field owner accounts'**
  String get viewAndManageFieldOwnerAccounts;

  /// No description provided for @failedToLoadAdmins.
  ///
  /// In en, this message translates to:
  /// **'Failed to load admins'**
  String get failedToLoadAdmins;

  /// No description provided for @assignFieldsToThisAdminTo.
  ///
  /// In en, this message translates to:
  /// **'Assign fields to this admin to get started'**
  String get assignFieldsToThisAdminTo;

  /// No description provided for @selectAFieldToAssign.
  ///
  /// In en, this message translates to:
  /// **'Select a field to assign'**
  String get selectAFieldToAssign;

  /// No description provided for @noAvailableFields.
  ///
  /// In en, this message translates to:
  /// **'No available fields'**
  String get noAvailableFields;

  /// No description provided for @passwordResetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password Reset Successfully!'**
  String get passwordResetSuccessfully;

  /// No description provided for @adminMustChangePasswordOnNext.
  ///
  /// In en, this message translates to:
  /// **'Admin must change password on next login'**
  String get adminMustChangePasswordOnNext;

  /// No description provided for @resetAdminPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Admin Password?'**
  String get resetAdminPassword;

  /// No description provided for @aNewPasswordWillBeGenerated.
  ///
  /// In en, this message translates to:
  /// **'A new password will be generated for this admin. They will need to change it on their next login.'**
  String get aNewPasswordWillBeGenerated;

  /// No description provided for @thisBookingHasBeenCompleted.
  ///
  /// In en, this message translates to:
  /// **'This booking has been completed'**
  String get thisBookingHasBeenCompleted;

  /// No description provided for @tryAdjustingYourSearchNorFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search\\nor filters'**
  String get tryAdjustingYourSearchNorFilters;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'/hour'**
  String get hour;

  /// No description provided for @hideThisCityFromUsers.
  ///
  /// In en, this message translates to:
  /// **'Hide this city from users'**
  String get hideThisCityFromUsers;

  /// No description provided for @showThisCityToUsers.
  ///
  /// In en, this message translates to:
  /// **'Show this city to users'**
  String get showThisCityToUsers;

  /// No description provided for @addNewCity.
  ///
  /// In en, this message translates to:
  /// **'Add New City'**
  String get addNewCity;

  /// No description provided for @createANewCityForThe.
  ///
  /// In en, this message translates to:
  /// **'Create a new city for the platform'**
  String get createANewCityForThe;

  /// No description provided for @cityName.
  ///
  /// In en, this message translates to:
  /// **'City Name'**
  String get cityName;

  /// No description provided for @cityWillBeVisibleToUsers.
  ///
  /// In en, this message translates to:
  /// **'City will be visible to users'**
  String get cityWillBeVisibleToUsers;

  /// No description provided for @createCity.
  ///
  /// In en, this message translates to:
  /// **'Create City'**
  String get createCity;

  /// No description provided for @thisActionMayBeIrreversible.
  ///
  /// In en, this message translates to:
  /// **'This action may be irreversible'**
  String get thisActionMayBeIrreversible;

  /// No description provided for @permanentDeleteIsDisabledForCities.
  ///
  /// In en, this message translates to:
  /// **'Permanent delete is disabled for cities with fields.'**
  String get permanentDeleteIsDisabledForCities;

  /// No description provided for @deleteForever.
  ///
  /// In en, this message translates to:
  /// **'Delete Forever'**
  String get deleteForever;

  /// No description provided for @cityIsVisibleToUsers.
  ///
  /// In en, this message translates to:
  /// **'City is visible to users'**
  String get cityIsVisibleToUsers;

  /// No description provided for @oopsSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get oopsSomethingWentWrong;

  /// No description provided for @tryAdjustingYourFiltersNorAdd.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters\\nor add a new city'**
  String get tryAdjustingYourFiltersNorAdd;

  /// No description provided for @fieldOwnerManagement.
  ///
  /// In en, this message translates to:
  /// **'Field owner management'**
  String get fieldOwnerManagement;

  /// No description provided for @enterTheAdmin.
  ///
  /// In en, this message translates to:
  /// **'Enter the admin\\'**
  String get enterTheAdmin;

  /// No description provided for @aTemporaryPasswordWillBeGenerated.
  ///
  /// In en, this message translates to:
  /// **'A temporary password will be generated automatically'**
  String get aTemporaryPasswordWillBeGenerated;

  /// No description provided for @shareCredentialsSecurelyWithTheNew.
  ///
  /// In en, this message translates to:
  /// **'Share credentials securely with the new admin'**
  String get shareCredentialsSecurelyWithTheNew;

  /// No description provided for @adminCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Admin Created Successfully!'**
  String get adminCreatedSuccessfully;

  /// No description provided for @shareTheseCredentialsSecurely.
  ///
  /// In en, this message translates to:
  /// **'Share these credentials securely'**
  String get shareTheseCredentialsSecurely;

  /// No description provided for @sportKickAdminV100.
  ///
  /// In en, this message translates to:
  /// **'Sport Kick Admin v1.0.0'**
  String get sportKickAdminV100;

  /// No description provided for @a.
  ///
  /// In en, this message translates to:
  /// **'A'**
  String get a;

  /// No description provided for @superAdminRole.
  ///
  /// In en, this message translates to:
  /// **'SUPER ADMIN'**
  String get superAdminRole;

  /// No description provided for @platformRevenue.
  ///
  /// In en, this message translates to:
  /// **'Platform Revenue'**
  String get platformRevenue;

  /// No description provided for @totalEarningsFromAllFields.
  ///
  /// In en, this message translates to:
  /// **'Total earnings from all fields'**
  String get totalEarningsFromAllFields;

  /// No description provided for @successStatus.
  ///
  /// In en, this message translates to:
  /// **'success'**
  String get successStatus;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'failed'**
  String get failed;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'blocked'**
  String get blocked;

  /// No description provided for @loadingLoginActivity.
  ///
  /// In en, this message translates to:
  /// **'Loading login activity...'**
  String get loadingLoginActivity;

  /// No description provided for @failedToLoadActivity.
  ///
  /// In en, this message translates to:
  /// **'Failed to load activity'**
  String get failedToLoadActivity;

  /// No description provided for @noLoginActivity.
  ///
  /// In en, this message translates to:
  /// **'No login activity'**
  String get noLoginActivity;

  /// No description provided for @noLoginEventsMatchNyourFilter.
  ///
  /// In en, this message translates to:
  /// **'No login events match\\nyour filter criteria'**
  String get noLoginEventsMatchNyourFilter;

  /// No description provided for @logoutAction.
  ///
  /// In en, this message translates to:
  /// **'Logout?'**
  String get logoutAction;

  /// No description provided for @confirmationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?\\nYou will need to login again to access the admin panel.'**
  String get confirmationPrompt;

  /// No description provided for @platformSettings.
  ///
  /// In en, this message translates to:
  /// **'platform'**
  String get platformSettings;

  /// No description provided for @allowNewUserSignUps.
  ///
  /// In en, this message translates to:
  /// **'Allow new user sign-ups'**
  String get allowNewUserSignUps;

  /// No description provided for @requireEmailVerificationForNewUsers.
  ///
  /// In en, this message translates to:
  /// **'Require email verification for new users'**
  String get requireEmailVerificationForNewUsers;

  /// No description provided for @configureDefaults.
  ///
  /// In en, this message translates to:
  /// **'Configure defaults'**
  String get configureDefaults;

  /// No description provided for @notificationsTab.
  ///
  /// In en, this message translates to:
  /// **'notifications'**
  String get notificationsTab;

  /// No description provided for @receiveEmailAlerts.
  ///
  /// In en, this message translates to:
  /// **'Receive email alerts'**
  String get receiveEmailAlerts;

  /// No description provided for @receivePushAlerts.
  ///
  /// In en, this message translates to:
  /// **'Receive push alerts'**
  String get receivePushAlerts;

  /// No description provided for @importantAdminNotifications.
  ///
  /// In en, this message translates to:
  /// **'Important admin notifications'**
  String get importantAdminNotifications;

  /// No description provided for @trackFailedLoginAttempts.
  ///
  /// In en, this message translates to:
  /// **'Track failed login attempts'**
  String get trackFailedLoginAttempts;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get loggingOut;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'value'**
  String get value;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @createCategory.
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get createCategory;

  /// No description provided for @iconField.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get iconField;

  /// No description provided for @failedToLoadUsers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load users'**
  String get failedToLoadUsers;

  /// No description provided for @viewAndManageAllCustomerAccounts.
  ///
  /// In en, this message translates to:
  /// **'View and manage all customer accounts'**
  String get viewAndManageAllCustomerAccounts;

  /// No description provided for @thisUserWillBeAbleTo.
  ///
  /// In en, this message translates to:
  /// **'This user will be able to login and make bookings again.'**
  String get thisUserWillBeAbleTo;

  /// No description provided for @dd.
  ///
  /// In en, this message translates to:
  /// **'dd'**
  String get dd;

  /// No description provided for @mmm.
  ///
  /// In en, this message translates to:
  /// **'MMM'**
  String get mmm;

  /// No description provided for @favoriteField.
  ///
  /// In en, this message translates to:
  /// **'Favorite Field'**
  String get favoriteField;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} selected} other {{count} selected}}'**
  String selectedCount(num count);

  /// No description provided for @fieldsFoundCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, zero {No fields found} one {{count} field found} other {{count} fields found}}'**
  String fieldsFoundCount(num count);

  /// No description provided for @bookingsFoundCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, zero {No bookings found} one {{count} booking found} other {{count} bookings found}}'**
  String bookingsFoundCount(num count);

  /// No description provided for @fieldsSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} field selected} other {{count} fields selected}}'**
  String fieldsSelectedCount(num count);

  /// No description provided for @cityFieldsAssociatedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, zero {This city has no fields associated with it.} one {This city has 1 field associated with it.} other {This city has # fields associated with it.}}'**
  String cityFieldsAssociatedCount(num count);

  /// No description provided for @cityFieldsRegisteredCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, zero {This city has no fields registered.} one {This city has 1 field registered.} other {This city has # fields registered.}}'**
  String cityFieldsRegisteredCount(num count);

  /// No description provided for @cityIsHiddenFromUsers.
  ///
  /// In en, this message translates to:
  /// **'City is hidden from users'**
  String get cityIsHiddenFromUsers;

  /// No description provided for @editingCity.
  ///
  /// In en, this message translates to:
  /// **'Editing: {name}'**
  String editingCity(Object name);

  /// No description provided for @showingAdminsCount.
  ///
  /// In en, this message translates to:
  /// **'Showing {filtered} of {total} admins'**
  String showingAdminsCount(Object filtered, Object total);

  /// No description provided for @showingUsersCount.
  ///
  /// In en, this message translates to:
  /// **'Showing {filtered} of {total} users'**
  String showingUsersCount(Object filtered, Object total);

  /// No description provided for @ofTotalAdmins.
  ///
  /// In en, this message translates to:
  /// **'of {total} admins'**
  String ofTotalAdmins(Object total);

  /// No description provided for @ofTotalUsers.
  ///
  /// In en, this message translates to:
  /// **'of {total} users'**
  String ofTotalUsers(Object total);

  /// No description provided for @activeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String activeCount(Object count);

  /// No description provided for @memberSinceDate.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String memberSinceDate(Object date);

  /// No description provided for @joinedDate.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String joinedDate(Object date);

  /// No description provided for @sinceDate.
  ///
  /// In en, this message translates to:
  /// **'Since {date}'**
  String sinceDate(Object date);

  /// No description provided for @bookingNumber.
  ///
  /// In en, this message translates to:
  /// **'Booking #{id}'**
  String bookingNumber(Object id);

  /// No description provided for @basedOnReviews.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {Based on {count} review} other {Based on {count} reviews}}'**
  String basedOnReviews(num count);

  /// No description provided for @noStarReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No {rating}-star reviews yet'**
  String noStarReviewsYet(Object rating);

  /// No description provided for @allReviewsWithCount.
  ///
  /// In en, this message translates to:
  /// **'All Reviews ({count})'**
  String allReviewsWithCount(Object count);

  /// No description provided for @countOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total}'**
  String countOfTotal(Object count, Object total);

  /// No description provided for @viewAllBookingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {View All {count} Booking} other {View All {count} Bookings}}'**
  String viewAllBookingsCount(num count);

  /// No description provided for @assigningTo.
  ///
  /// In en, this message translates to:
  /// **'Assigning to: {name}'**
  String assigningTo(Object name);

  /// No description provided for @usingCurrentHours.
  ///
  /// In en, this message translates to:
  /// **'Using current hours: {hours}'**
  String usingCurrentHours(Object hours);

  /// No description provided for @sharePasswordSecurelyWith.
  ///
  /// In en, this message translates to:
  /// **'Share this password securely with {name}'**
  String sharePasswordSecurelyWith(Object name);

  /// No description provided for @exportingReport.
  ///
  /// In en, this message translates to:
  /// **'Exporting {type}...'**
  String exportingReport(Object type);

  /// No description provided for @deleteCategoryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?\\n\\nThis action cannot be undone.'**
  String deleteCategoryConfirmation(Object name);

  /// No description provided for @gpsCoordinates.
  ///
  /// In en, this message translates to:
  /// **'GPS: {coordinates}'**
  String gpsCoordinates(Object coordinates);

  /// No description provided for @labelWithValue.
  ///
  /// In en, this message translates to:
  /// **'{label}: {value}'**
  String labelWithValue(Object label, Object value);

  /// No description provided for @usersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} user} other {{count} users}}'**
  String usersCount(num count);

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get allStatuses;

  /// No description provided for @effectiveDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Effective Date: {date}'**
  String effectiveDateLabel(Object date);

  /// No description provided for @lastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: {date}'**
  String lastUpdatedLabel(Object date);

  /// No description provided for @effectiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Effective: {date}'**
  String effectiveLabel(Object date);

  /// No description provided for @beFirstToReviewField.
  ///
  /// In en, this message translates to:
  /// **'Be the first to review {fieldName}'**
  String beFirstToReviewField(Object fieldName);

  /// No description provided for @starReviewsWithCount.
  ///
  /// In en, this message translates to:
  /// **'{rating} Star Reviews ({count})'**
  String starReviewsWithCount(Object count, Object rating);

  /// No description provided for @thisUserHasntMadeAnyBookings.
  ///
  /// In en, this message translates to:
  /// **'This user hasn\'t made any bookings yet.'**
  String get thisUserHasntMadeAnyBookings;

  /// No description provided for @thisUserHasntMadeAnyBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'This user hasn\'t made any bookings yet.'**
  String get thisUserHasntMadeAnyBookingsYet;

  /// No description provided for @thisAdminDoesntHaveAnyFieldsAssignedYet.
  ///
  /// In en, this message translates to:
  /// **'This admin doesn\'t have any fields assigned yet.'**
  String get thisAdminDoesntHaveAnyFieldsAssignedYet;

  /// No description provided for @enterTheAdminsEmailAndPersonalDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter the admin\'s email and personal details'**
  String get enterTheAdminsEmailAndPersonalDetails;

  /// No description provided for @admins.
  ///
  /// In en, this message translates to:
  /// **'Admins'**
  String get admins;

  /// No description provided for @errorLoadingDashboard.
  ///
  /// In en, this message translates to:
  /// **'Error loading dashboard: {message}'**
  String errorLoadingDashboard(Object message);

  /// No description provided for @shareDetailsAboutYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Share details about your experience:\\n- How was the field condition?\\n- Were the facilities good?\\n- Would you recommend it?'**
  String get shareDetailsAboutYourExperience;

  /// No description provided for @yourReviewHelpsOthersFindTheBestFields.
  ///
  /// In en, this message translates to:
  /// **'Your review helps others find the best fields'**
  String get yourReviewHelpsOthersFindTheBestFields;

  /// No description provided for @nameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameIsRequired;

  /// No description provided for @nameIsTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name is too short'**
  String get nameIsTooShort;

  /// No description provided for @nameMustBeAtLeast3Characters.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get nameMustBeAtLeast3Characters;

  /// No description provided for @emailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// No description provided for @pleaseEnterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterAValidEmail;

  /// No description provided for @phoneNumberIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberIsRequired;

  /// No description provided for @pleaseEnterAValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterAValidPhoneNumber;

  /// No description provided for @passwordIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// No description provided for @passwordMustBeAtLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMustBeAtLeast8Characters;

  /// No description provided for @pleaseConfirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmYourPassword;

  /// No description provided for @emailAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Email Address *'**
  String get emailAddressRequired;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get fullNameRequired;

  /// No description provided for @phoneNumberOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone Number (Optional)'**
  String get phoneNumberOptional;

  /// No description provided for @paymentPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Payment Phone Number'**
  String get paymentPhoneNumber;

  /// No description provided for @paymentPhoneIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Payment phone is required'**
  String get paymentPhoneIsRequired;

  /// No description provided for @enterValidEgyptianPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Egyptian phone number'**
  String get enterValidEgyptianPhoneNumber;

  /// No description provided for @selectAdmin.
  ///
  /// In en, this message translates to:
  /// **'Select Admin'**
  String get selectAdmin;

  /// No description provided for @pleaseSelectAnAdmin.
  ///
  /// In en, this message translates to:
  /// **'Please select an admin'**
  String get pleaseSelectAnAdmin;

  /// No description provided for @createFieldButton.
  ///
  /// In en, this message translates to:
  /// **'Create Field'**
  String get createFieldButton;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @loadingCities.
  ///
  /// In en, this message translates to:
  /// **'Loading cities...'**
  String get loadingCities;

  /// No description provided for @loadingCategories.
  ///
  /// In en, this message translates to:
  /// **'Loading categories...'**
  String get loadingCategories;

  /// No description provided for @fieldNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Field name is required'**
  String get fieldNameIsRequired;

  /// No description provided for @addressIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressIsRequired;

  /// No description provided for @priceIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get priceIsRequired;

  /// No description provided for @pleaseEnterAValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterAValidNumber;

  /// No description provided for @priceMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Price must be greater than 0'**
  String get priceMustBeGreaterThanZero;

  /// No description provided for @pleaseSelectACity.
  ///
  /// In en, this message translates to:
  /// **'Please select a city'**
  String get pleaseSelectACity;

  /// No description provided for @pleaseSelectASportCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a sport category'**
  String get pleaseSelectASportCategory;

  /// No description provided for @pleaseSelectAnAdminToAssignField.
  ///
  /// In en, this message translates to:
  /// **'Please select an admin to assign this field'**
  String get pleaseSelectAnAdminToAssignField;

  /// No description provided for @pleaseEnterACityName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a city name'**
  String get pleaseEnterACityName;

  /// No description provided for @cityNameMustBeAtLeast2Characters.
  ///
  /// In en, this message translates to:
  /// **'City name must be at least 2 characters'**
  String get cityNameMustBeAtLeast2Characters;

  /// No description provided for @pleaseEnterACancellationReason.
  ///
  /// In en, this message translates to:
  /// **'Please enter a cancellation reason'**
  String get pleaseEnterACancellationReason;

  /// No description provided for @reasonMustBeAtLeast5Characters.
  ///
  /// In en, this message translates to:
  /// **'Reason must be at least 5 characters'**
  String get reasonMustBeAtLeast5Characters;

  /// No description provided for @categoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryNameLabel;

  /// No description provided for @ratingPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get ratingPoor;

  /// No description provided for @ratingFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get ratingFair;

  /// No description provided for @ratingGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get ratingGood;

  /// No description provided for @ratingVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get ratingVeryGood;

  /// No description provided for @ratingExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get ratingExcellent;

  /// No description provided for @bookingStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get bookingStatusPending;

  /// No description provided for @bookingStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get bookingStatusConfirmed;

  /// No description provided for @bookingStatusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get bookingStatusCanceled;

  /// No description provided for @bookingStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingStatusCompleted;

  /// No description provided for @bookingStatusConf.
  ///
  /// In en, this message translates to:
  /// **'Conf'**
  String get bookingStatusConf;

  /// No description provided for @bookingStatusPend.
  ///
  /// In en, this message translates to:
  /// **'Pend'**
  String get bookingStatusPend;

  /// No description provided for @bookingStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get bookingStatusDone;

  /// No description provided for @bookingStatusCanc.
  ///
  /// In en, this message translates to:
  /// **'Canc'**
  String get bookingStatusCanc;

  /// No description provided for @noBookingsMatchYourSearch.
  ///
  /// In en, this message translates to:
  /// **'No bookings match your search'**
  String get noBookingsMatchYourSearch;

  /// No description provided for @noPendingBookings.
  ///
  /// In en, this message translates to:
  /// **'No pending bookings'**
  String get noPendingBookings;

  /// No description provided for @noConfirmedBookings.
  ///
  /// In en, this message translates to:
  /// **'No confirmed bookings'**
  String get noConfirmedBookings;

  /// No description provided for @noCanceledBookings.
  ///
  /// In en, this message translates to:
  /// **'No canceled bookings'**
  String get noCanceledBookings;
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
