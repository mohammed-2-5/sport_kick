import 'package:connectivity_plus/connectivity_plus.dart';

/// Network connectivity checker.
///
/// Provides methods to check if the device has an active internet connection.
/// This is used by repositories to determine if they should fetch from remote
/// or fall back to cached data.
///
/// Example usage in repository:
/// ```dart
/// if (await networkInfo.isConnected) {
///   // Fetch from remote
///   final data = await remoteDataSource.getData();
///   await localDataSource.cacheData(data);
///   return Right(data);
/// } else {
///   // Fetch from cache
///   final cachedData = await localDataSource.getCachedData();
///   return Right(cachedData);
/// }
/// ```
abstract class NetworkInfo {
  /// Check if device has internet connection.
  ///
  /// Returns `true` if connected to WiFi, mobile data, or ethernet.
  /// Returns `false` if offline or connection type is none/bluetooth.
  Future<bool> get isConnected;

  /// Get current connection type.
  ///
  /// Returns the active connection type (wifi, mobile, ethernet, etc.)
  Future<List<ConnectivityResult>> get connectionType;

  /// Stream of connectivity changes.
  ///
  /// Listen to this stream to be notified when connectivity changes.
  /// Useful for showing online/offline indicators in UI.
  ///
  /// Example:
  /// ```dart
  /// networkInfo.onConnectivityChanged.listen((result) {
  ///   if (result.contains(ConnectivityResult.none)) {
  ///     showOfflineSnackbar();
  ///   } else {
  ///     showOnlineSnackbar();
  ///   }
  /// });
  /// ```
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

/// Implementation of [NetworkInfo] using connectivity_plus package.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  const NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    final result = await connectionType;
    return !result.contains(ConnectivityResult.none);
  }

  @override
  Future<List<ConnectivityResult>> get connectionType async {
    return await connectivity.checkConnectivity();
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return connectivity.onConnectivityChanged;
  }
}
