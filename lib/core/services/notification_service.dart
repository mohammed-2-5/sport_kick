import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Notification Service
///
/// Manages Firebase Cloud Messaging (FCM) for push notifications.
/// Handles token management, permissions, and notification handling
/// for all user roles (User, Admin, Super Admin).
/// Android notification channel for high importance notifications.
const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  FirebaseMessaging? _messaging;
  FlutterLocalNotificationsPlugin? _localNotifications;
  String? _fcmToken;
  bool _isInitialized = false;
  bool _isSupported = false;

  /// Get current FCM token.
  String? get fcmToken => _fcmToken;

  /// Check if service is initialized.
  bool get isInitialized => _isInitialized;

  /// Check if notifications are supported on this platform.
  bool get isSupported => _isSupported;

  /// Initialize the notification service.
  ///
  /// Should be called after Firebase.initializeApp() and user authentication.
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Skip initialization on web (requires additional setup)
    if (kIsWeb) {
      debugPrint('[NotificationService] Skipping on web platform');
      _isInitialized = true;
      _isSupported = false;
      return;
    }

    try {
      _messaging = FirebaseMessaging.instance;

      // Initialize local notifications for foreground
      await _initializeLocalNotifications();

      // Request permission
      final hasPermission = await _requestPermission();
      if (!hasPermission) {
        debugPrint('[NotificationService] Permission denied');
        _isInitialized = true;
        _isSupported = false;
        return;
      }

      // Get FCM token
      _fcmToken = await _messaging!.getToken();
      debugPrint('[NotificationService] FCM Token: $_fcmToken');

      // Listen for token refresh
      _messaging!.onTokenRefresh.listen(_handleTokenRefresh);

      // Configure message handlers
      _configureMessageHandlers();

      // Set foreground notification presentation options (iOS)
      await _messaging!.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      _isInitialized = true;
      _isSupported = true;
      debugPrint('[NotificationService] Initialized successfully');
    } catch (e) {
      debugPrint('[NotificationService] Initialization error: $e');
      _isInitialized = true;
      _isSupported = false;
    }
  }

  /// Initialize local notifications plugin.
  Future<void> _initializeLocalNotifications() async {
    _localNotifications = FlutterLocalNotificationsPlugin();

    // Android initialization
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS initialization
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications!.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      await _localNotifications!
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_androidChannel);
    }

    debugPrint('[NotificationService] Local notifications initialized');
  }

  /// Handle notification tap from local notification.
  void _onNotificationTap(NotificationResponse response) {
    debugPrint(
      '[NotificationService] Local notification tapped: ${response.payload}',
    );
    // Handle navigation based on payload
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        _handleNotificationData(data);
      } catch (e) {
        debugPrint('[NotificationService] Error parsing payload: $e');
      }
    }
  }

  /// Request notification permission from user.
  Future<bool> _requestPermission() async {
    if (_messaging == null) return false;

    final settings = await _messaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final isAuthorized =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    debugPrint(
      '[NotificationService] Permission status: ${settings.authorizationStatus}',
    );

    return isAuthorized;
  }

  /// Handle FCM token refresh.
  void _handleTokenRefresh(String newToken) {
    debugPrint('[NotificationService] Token refreshed: $newToken');
    _fcmToken = newToken;
    // Update token in backend
    _updateTokenInBackend(newToken);
  }

  /// Configure message handlers for foreground, background, and terminated.
  void _configureMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background message tap (app was in background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Check if app was opened from terminated state via notification
    _checkInitialMessage();
  }

  /// Handle foreground messages.
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('[NotificationService] Foreground message: ${message.toMap()}');

    final notification = message.notification;
    if (notification != null) {
      debugPrint(
        '[NotificationService] Title: ${notification.title}, Body: ${notification.body}',
      );

      // Show local notification when app is in foreground
      _showLocalNotification(
        title: notification.title ?? 'New Notification',
        body: notification.body ?? '',
        payload: jsonEncode(message.data),
      );
    }

    // Handle data payload
    if (message.data.isNotEmpty) {
      _handleNotificationData(message.data);
    }
  }

  /// Show a local notification.
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (_localNotifications == null) return;

    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications!.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    debugPrint('[NotificationService] Local notification shown: $title');
  }

  /// Handle when user taps notification (app was in background).
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('[NotificationService] Message opened app: ${message.toMap()}');
    _handleNotificationTap(message);
  }

  /// Check if app was opened from terminated state.
  Future<void> _checkInitialMessage() async {
    if (_messaging == null) return;

    final initialMessage = await _messaging!.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
        '[NotificationService] Initial message: ${initialMessage.toMap()}',
      );
      _handleNotificationTap(initialMessage);
    }
  }

  /// Handle notification tap navigation.
  void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] as String?;
    final id = data['id'] as String?;

    debugPrint('[NotificationService] Tap handler - type: $type, id: $id');

    // Navigation will be handled by the app based on type
    // This could emit to a stream that the app listens to
  }

  /// Handle notification data payload.
  void _handleNotificationData(Map<String, dynamic> data) {
    debugPrint('[NotificationService] Data payload: $data');
    // Process data based on notification type
  }

  /// Save FCM token to Supabase for the current user.
  Future<void> saveTokenForUser(String userId, String userRole) async {
    if (!_isSupported || _fcmToken == null) {
      debugPrint(
        '[NotificationService] No FCM token to save (not supported or no token)',
      );
      return;
    }

    try {
      final supabase = Supabase.instance.client;

      // Upsert token to user_fcm_tokens table
      await supabase.from('user_fcm_tokens').upsert({
        'user_id': userId,
        'fcm_token': _fcmToken,
        'user_role': userRole,
        'device_info': _getDeviceInfo(),
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id');

      debugPrint('[NotificationService] Token saved for user: $userId');
    } catch (e) {
      debugPrint('[NotificationService] Error saving token: $e');
    }
  }

  /// Update token in backend when refreshed.
  Future<void> _updateTokenInBackend(String token) async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user != null) {
        await supabase
            .from('user_fcm_tokens')
            .update({
              'fcm_token': token,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('user_id', user.id);

        debugPrint('[NotificationService] Token updated in backend');
      }
    } catch (e) {
      debugPrint('[NotificationService] Error updating token: $e');
    }
  }

  /// Remove FCM token from backend (on logout).
  Future<void> removeTokenForUser(String userId) async {
    try {
      final supabase = Supabase.instance.client;

      await supabase.from('user_fcm_tokens').delete().eq('user_id', userId);

      debugPrint('[NotificationService] Token removed for user: $userId');
    } catch (e) {
      debugPrint('[NotificationService] Error removing token: $e');
    }
  }

  /// Subscribe to a topic for role-based notifications.
  Future<void> subscribeToTopic(String topic) async {
    if (!_isSupported || _messaging == null) {
      debugPrint('[NotificationService] Skipping subscribe - not supported');
      return;
    }

    try {
      await _messaging!.subscribeToTopic(topic);
      debugPrint('[NotificationService] Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('[NotificationService] Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    if (!_isSupported || _messaging == null) {
      debugPrint('[NotificationService] Skipping unsubscribe - not supported');
      return;
    }

    try {
      await _messaging!.unsubscribeFromTopic(topic);
      debugPrint('[NotificationService] Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('[NotificationService] Error unsubscribing from topic: $e');
    }
  }

  /// Subscribe to role-specific topics.
  Future<void> subscribeToRoleTopics(String userRole) async {
    // Subscribe to general topic
    await subscribeToTopic('all_users');

    // Subscribe to role-specific topic
    switch (userRole.toLowerCase()) {
      case 'super_admin':
        await subscribeToTopic('super_admins');
        await subscribeToTopic('admins');
        break;
      case 'admin':
      case 'owner':
        await subscribeToTopic('admins');
        await subscribeToTopic('field_owners');
        break;
      case 'user':
      default:
        await subscribeToTopic('customers');
        break;
    }
  }

  /// Unsubscribe from all role topics (on logout).
  Future<void> unsubscribeFromAllTopics() async {
    final topics = [
      'all_users',
      'super_admins',
      'admins',
      'field_owners',
      'customers',
    ];

    for (final topic in topics) {
      await unsubscribeFromTopic(topic);
    }
  }

  /// Get device info for token storage.
  String _getDeviceInfo() {
    return jsonEncode({
      'platform': defaultTargetPlatform.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Check if notifications are enabled.
  Future<bool> areNotificationsEnabled() async {
    if (!_isSupported || _messaging == null) return false;

    final settings = await _messaging!.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Open app settings for notification permissions.
  Future<void> openNotificationSettings() async {
    if (!_isSupported || _messaging == null) return;

    await _messaging!.requestPermission();
  }
}

/// Background message handler (must be top-level function).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[NotificationService] Background message: ${message.messageId}');
  // Handle background message
  // Note: Cannot access UI or app state here
}
