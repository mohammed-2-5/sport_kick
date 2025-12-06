import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spo_kick/core/constants/app_constants.dart';
import 'package:spo_kick/core/constants/app_theme.dart';
import 'package:spo_kick/core/di/injection_container.dart' as di;
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/routes/go_router_config.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';

/// Supabase client instance (globally accessible)
SupabaseClient get supabase => Supabase.instance.client;

/// Main entry point of the Sport Kick application.
///
/// Initializes:
/// - Flutter framework bindings
/// - Firebase (Core & Crashlytics)
/// - Dependency injection (GetIt)
/// - Hive local database
/// - Supabase backend
/// - System UI styling
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app
  await _initializeApp();

  // Setup Flutter error handling with Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

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
    debugPrint('🔄 Initializing Firebase...');
    await Firebase.initializeApp();

    // Enable Crashlytics collection
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    // Set user identifier for better crash tracking (optional)
    // This will be set later when user logs in
    debugPrint('✅ Firebase initialized successfully');

    // 3. Initialize Supabase
    debugPrint('🔄 Initializing Supabase...');
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
    debugPrint('✅ Supabase initialized successfully');

    // 4. Initialize dependency injection
    await di.initDependencies();

    // 5. Set system UI styling
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // 6. Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    debugPrint('✅ App initialization completed successfully');
  } catch (e, stackTrace) {
    debugPrint('❌ App initialization failed: $e');
    debugPrint('Stack trace: $stackTrace');
    // In production, you might want to show an error screen
    // or send error to crash reporting service
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
        BlocProvider(create: (context) => sl<AuthCubit>()),
        BlocProvider(create: (context) => sl<CityCubit>()),
      ],
      child: MaterialApp.router(
        // ==================== APP INFO ====================
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

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
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
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
      ),
    );
  }
}
