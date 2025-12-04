import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/core/errors/exceptions.dart' as app_exceptions;
import 'package:spo_kick/features/auth/data/models/user_model.dart';

/// Abstract class defining the contract for authentication remote data source.
abstract class AuthRemoteDataSource {
  /// Logs in a user with email and password.
  ///
  /// Throws [app_exceptions.ServerException] if login fails.
  Future<UserModel> login({required String email, required String password});

  /// Registers a new user.
  ///
  /// Throws [app_exceptions.ServerException] if registration fails.
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  });

  /// Logs out the current user.
  ///
  /// Throws [app_exceptions.ServerException] if logout fails.
  Future<void> logout();

  /// Gets the currently logged-in user.
  ///
  /// Returns null if no user is logged in.
  /// Throws [app_exceptions.ServerException] if there's an error fetching user data.
  Future<UserModel?> getCurrentUser();

  /// Updates the current user's profile.
  ///
  /// Throws [app_exceptions.ServerException] if update fails.
  Future<UserModel> updateProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
    List<String>? preferredSports,
  });

  /// Sends a password reset email.
  ///
  /// Throws [app_exceptions.ServerException] if the request fails.
  Future<void> resetPassword({required String email});

  /// Checks if user session is valid.
  Future<bool> isSessionValid();

  /// Changes the current user's password.
  ///
  /// Throws [app_exceptions.ServerException] if password change fails.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

/// Implementation of [AuthRemoteDataSource] using Supabase.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabase;

  const AuthRemoteDataSourceImpl({required this.supabase});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Supabase Auth
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const app_exceptions.ServerException(
          'Login failed: No user returned',
        );
      }

      // Fetch profile data from profiles table
      final profileData = await supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(profileData);
    } on AuthException catch (e) {
      throw app_exceptions.ServerException('Login failed: ${e.message}');
    } catch (e) {
      throw app_exceptions.ServerException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      print('📝 Starting registration for: $email');
      print('📝 Phone number: ${phone ?? "null"}');

      // 1. Create auth user
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user == null) {
        throw const app_exceptions.ServerException(
          'Registration failed: No user returned',
        );
      }

      print('✅ Auth user created with ID: ${response.user!.id}');

      // 2. Wait a moment for the database trigger to create the profile
      await Future.delayed(const Duration(milliseconds: 500));

      // 3. Update profile with phone number
      final profileData = {'full_name': fullName, 'phone': phone};

      print('📝 Updating profile with data: $profileData');

      await supabase
          .from('profiles')
          .update(profileData)
          .eq('id', response.user!.id);

      print('✅ Profile updated successfully');

      // 4. Fetch the created profile
      final profile = await supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      print('✅ Profile fetched: ${profile['phone']}');

      return UserModel.fromJson(profile);
    } on AuthException catch (e) {
      print('❌ Auth Exception: ${e.message}');
      throw app_exceptions.ServerException('Registration failed: ${e.message}');
    } catch (e) {
      print('❌ Registration Exception: ${e.toString()}');
      throw app_exceptions.ServerException(
        'Registration failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (e) {
      throw app_exceptions.ServerException('Logout failed: ${e.message}');
    } catch (e) {
      throw app_exceptions.ServerException('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // Check if user is logged in
      final currentUser = supabase.auth.currentUser;

      debugPrint('🔐 Checking current user session...');
      debugPrint('   User ID: ${currentUser?.id ?? "null"}');
      debugPrint('   Email: ${currentUser?.email ?? "null"}');

      if (currentUser == null) {
        debugPrint('❌ No user session found');
        return null;
      }

      // Fetch profile data
      debugPrint('📱 Fetching profile for user: ${currentUser.id}');
      final profileData = await supabase
          .from('profiles')
          .select()
          .eq('id', currentUser.id)
          .single();

      debugPrint('✅ User session restored: ${profileData['full_name']}');
      return UserModel.fromJson(profileData);
    } on PostgrestException catch (e) {
      debugPrint('❌ Profile fetch error: ${e.message}');
      throw app_exceptions.ServerException(
        'Failed to fetch current user: ${e.message}',
      );
    } catch (e) {
      // If user not logged in or session expired, return null
      debugPrint('❌ Session error: $e');
      return null;
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
    List<String>? preferredSports,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updateData['full_name'] = fullName;
      if (phone != null) updateData['phone'] = phone;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;
      if (preferredSports != null) {
        updateData['preferred_sports'] = preferredSports;
      }

      await supabase.from('profiles').update(updateData).eq('id', userId);

      // Fetch updated profile
      final profileData = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromJson(profileData);
    } on PostgrestException catch (e) {
      throw app_exceptions.ServerException(
        'Failed to update profile: ${e.message}',
      );
    } catch (e) {
      throw app_exceptions.ServerException(
        'Profile update failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw app_exceptions.ServerException(
        'Password reset failed: ${e.message}',
      );
    } catch (e) {
      throw app_exceptions.ServerException(
        'Password reset failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> isSessionValid() async {
    try {
      final session = supabase.auth.currentSession;
      if (session == null) return false;

      // Check if token is expired
      final expiresAt = session.expiresAt;
      if (expiresAt == null) return false;

      return DateTime.now().millisecondsSinceEpoch <
          expiresAt * 1000; // expiresAt is in seconds
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null || user.email == null) {
        throw const app_exceptions.ServerException('User not authenticated');
      }

      // 1. Verify current password by re-authenticating
      // We use signInWithPassword to verify credentials
      final authResponse = await supabase.auth.signInWithPassword(
        email: user.email!,
        password: currentPassword,
      );

      if (authResponse.user == null) {
        throw const app_exceptions.ServerException('Invalid current password');
      }

      // 2. Update password
      await supabase.auth.updateUser(UserAttributes(password: newPassword));

      // 3. Update profile to set password_changed = true
      await supabase
          .from('profiles')
          .update({'password_changed': true})
          .eq('id', user.id);

      debugPrint('✅ Password changed successfully for user: ${user.email}');
    } on AuthException catch (e) {
      debugPrint('❌ Password change failed: ${e.message}');
      throw app_exceptions.ServerException(
        'Failed to change password: ${e.message}',
      );
    } catch (e) {
      debugPrint('❌ Password change error: $e');
      throw app_exceptions.ServerException(
        'Failed to change password: ${e.toString()}',
      );
    }
  }
}
