import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spo_kick/core/constants/app_constants.dart';
import 'package:spo_kick/core/constants/app_theme.dart';
import 'package:spo_kick/core/di/injection_container.dart' as di;
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/routes/app_router.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/splash/splash_page.dart';

/// Supabase client instance (globally accessible)
SupabaseClient get supabase => Supabase.instance.client;

/// Main entry point of the Sport Kick application.
///
/// Initializes:
/// - Flutter framework bindings
/// - Dependency injection (GetIt)
/// - Hive local database
/// - Supabase backend
/// - System UI styling
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app
  await _initializeApp();

  // Run app
  runApp(const MyApp());
}

/// Initialize all app dependencies and services.
Future<void> _initializeApp() async {
  try {
    // 1. Initialize Hive for local storage
    await Hive.initFlutter();

    // TODO: Open Hive boxes when needed
    // await Hive.openBox(AppConstants.hiveBoxUser);
    // await Hive.openBox(AppConstants.hiveBoxFields);
    // await Hive.openBox(AppConstants.hiveBoxBookings);

    // 2. Initialize Supabase
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

    // 3. Initialize dependency injection
    await di.initDependencies();

    // 4. Set system UI styling
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // 5. Set preferred orientations
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
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: MaterialApp(
        // ==================== APP INFO ====================
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        // ==================== THEME ====================
        theme: AppTheme.lightTheme,

        // TODO: Add dark theme when ready
        // darkTheme: AppTheme.darkTheme,
        // themeMode: ThemeMode.system,

        // ==================== ROUTING ====================
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.generateRoute,

        // ==================== HOME ====================
        home: const SplashPage(),

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
      ),
    );
  }
}
