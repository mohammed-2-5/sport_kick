import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'package:spo_kick/core/localization/app_locale_cubit.dart';
import 'package:spo_kick/core/constants/app_constants.dart';
import 'package:spo_kick/core/constants/app_theme.dart';
import 'package:spo_kick/core/di/injection_container.dart' as di;
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/services/notification_service.dart';
import 'package:spo_kick/core/utils/app_logger.dart';
import 'package:spo_kick/firebase_options.dart';
import 'package:spo_kick/core/routes/go_router_config.dart';
import 'package:spo_kick/core/observers/app_bloc_observer.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_state.dart';

import 'l10n/app_localizations.dart';

/// Supabase client instance (globally accessible)
SupabaseClient get supabase => Supabase.instance.client;

/// Main entry point of the Sport Kick application.
///
/// Initializes:
/// - Flutter framework bindings
/// - Firebase (Core, Crashlytics, Messaging)
/// - Dependency injection (GetIt)
/// - Hive local database
/// - Supabase backend
/// - Notification service
/// - System UI styling
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app
  await _initializeApp();

  // Setup Flutter error handling with Crashlytics when available
  if (!kIsWeb) {
    try {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    } catch (_) {
      // Crashlytics not available on this platform; fall back to default handlers.
    }
  }

  // Set up background message handler for FCM (not supported on web)
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  // Set Bloc Observer
  Bloc.observer = const AppBlocObserver();

  // Run app
  runApp(const MyApp());
}

/// Initialize all app dependencies and services.
Future<void> _initializeApp() async {
  try {
    // 0. Load environment variables
    await dotenv.load(fileName: '.env');

    // 1. Initialize Hive for local storage
    await Hive.initFlutter();

    // TODO: Open Hive boxes when needed
    // await Hive.openBox(AppConstants.hiveBoxUser);
    // await Hive.openBox(AppConstants.hiveBoxFields);
    // await Hive.openBox(AppConstants.hiveBoxBookings);

    // 2. Initialize Firebase
    AppLogger.info('Initializing Firebase...', tag: 'INIT');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (!kIsWeb) {
      try {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          true,
        );
      } catch (_) {
        AppLogger.warn(
          'Crashlytics not available on this platform; skipping enable step',
          tag: 'INIT',
        );
      }
    }

    // 3. Initialize Supabase
    AppLogger.info('Initializing Supabase...', tag: 'INIT');
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
      debug: true, // Enable debug logs in development
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce, // Use PKCE flow for better security
        autoRefreshToken: true, // Auto refresh tokens before expiry
      ),
      // Session persistence is enabled by default in Supabase Flutter
    );
    AppLogger.info('Supabase initialized', tag: 'INIT');

    // 4. Initialize dependency injection
    await di.initDependencies();

    // 5. Initialize notification service
    AppLogger.info('Initializing notification service...', tag: 'INIT');
    await NotificationService.instance.initialize();

    // 6. Set system UI styling
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // 7. Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    AppLogger.info('App initialization completed successfully', tag: 'INIT');
  } catch (e, stackTrace) {
    AppLogger.error(
      'App initialization failed: $e',
      tag: 'INIT',
      error: e,
      stackTrace: stackTrace,
    );
    FlutterError.reportError(
      FlutterErrorDetails(exception: e, stack: stackTrace),
    );
    rethrow;
  }
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouterConfig.createRouter();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthCubit>()..checkAuthStatus()),
        BlocProvider(create: (context) => sl<CityCubit>()),
        BlocProvider(
          create: (context) => sl<AppLocaleCubit>()..loadSavedLocale(),
        ),
        BlocProvider(create: (context) => sl<SettingsCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                current is Authenticated &&
                (previous is! Authenticated ||
                    previous.user.id != current.user.id),
            listener: (context, state) {
              if (state is Authenticated) {
                context.read<SettingsCubit>().loadPreferences(state.user.id);
              }
            },
          ),
          BlocListener<SettingsCubit, SettingsState>(
            listenWhen: (previous, current) =>
                current is SettingsLoaded || current is SettingsUpdated,
            listener: (context, state) {
              final localeCubit = context.read<AppLocaleCubit>();
              if (state is SettingsLoaded) {
                localeCubit.setLocale(state.preferences.language);
              } else if (state is SettingsUpdated) {
                localeCubit.setLocale(state.preferences.language);
              }
            },
          ),
        ],
        child: BlocBuilder<AppLocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              // ==================== APP INFO ====================
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,

              // ==================== LOCALIZATION ====================
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                final languageCode = locale.languageCode;
                final hasSaved = supportedLocales.any(
                  (l) => l.languageCode == languageCode,
                );
                if (hasSaved) {
                  return locale;
                }
                if (deviceLocale != null) {
                  final match = supportedLocales.firstWhere(
                    (l) => l.languageCode == deviceLocale.languageCode,
                    orElse: () => supportedLocales.first,
                  );
                  return match;
                }
                return supportedLocales.first;
              },

              // ==================== THEME ====================
              theme: AppTheme.lightTheme,

              // TODO: Add dark theme when ready
              // darkTheme: AppTheme.darkTheme,
              // themeMode: ThemeMode.system,

              // ==================== ROUTING (GoRouter) ====================
              routerConfig: router,

              // ==================== BUILDER ====================
              builder: (context, child) {
                // Wrap with custom error widget in production
                ErrorWidget.builder = (FlutterErrorDetails details) {
                  // In production, show user-friendly error
                  if (const bool.fromEnvironment('dart.vm.product')) {
                    return Material(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Something went wrong',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Please restart the app',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // In debug mode, show detailed error
                  return ErrorWidget(details.exception);
                };

                return child ?? const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
