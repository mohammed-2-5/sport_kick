import 'package:dio/dio.dart';
import 'package:spo_kick/core/constants/app_constants.dart';

/// HTTP client wrapper around Dio.
///
/// Provides a configured Dio instance with:
/// - Base URL configuration
/// - Request/response interceptors
/// - Error handling
/// - Logging
/// - Authentication headers
///
/// This is used when you need to make HTTP requests to external APIs
/// (not Supabase). For Supabase, use SupabaseClient directly.
///
/// Example usage:
/// ```dart
/// final response = await apiClient.get('/users');
/// final data = response.data;
/// ```
class ApiClient {
  final Dio dio;

  ApiClient({required this.dio}) {
    _configureDio();
  }

  /// Configure Dio with interceptors and options.
  void _configureDio() {
    // Base options
    dio.options = BaseOptions(
      baseUrl: AppConstants.apiBaseUrl.isEmpty
          ? 'https://api.example.com'
          : AppConstants.apiBaseUrl,
      connectTimeout: Duration(seconds: AppConstants.apiTimeout),
      receiveTimeout: Duration(seconds: AppConstants.apiTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    dio.interceptors.addAll([
      _loggingInterceptor(),
      _authInterceptor(),
      _errorInterceptor(),
    ]);
  }

  /// Logging interceptor for debugging.
  ///
  /// Logs all requests and responses in debug mode.
  /// Disable in production for performance.
  Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        print('═══ REQUEST ═══');
        print('${options.method} ${options.uri}');
        print('Headers: ${options.headers}');
        if (options.data != null) {
          print('Body: ${options.data}');
        }
        print('═══════════════');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('═══ RESPONSE ═══');
        print('${response.statusCode} ${response.requestOptions.uri}');
        print('Data: ${response.data}');
        print('════════════════');
        handler.next(response);
      },
      onError: (error, handler) {
        print('═══ ERROR ═══');
        print('${error.response?.statusCode} ${error.requestOptions.uri}');
        print('Message: ${error.message}');
        if (error.response != null) {
          print('Response: ${error.response?.data}');
        }
        print('═════════════');
        handler.next(error);
      },
    );
  }

  /// Authentication interceptor.
  ///
  /// Automatically adds auth token to requests if available.
  /// Gets token from local storage and adds to Authorization header.
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // TODO: Get auth token from local storage
        // final token = await getAuthToken();
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        handler.next(options);
      },
    );
  }

  /// Error handling interceptor.
  ///
  /// Standardizes error responses and handles common HTTP errors.
  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response != null) {
          switch (error.response!.statusCode) {
            case 401:
              // Unauthorized - Token expired
              // TODO: Handle token refresh or logout
              break;
            case 403:
              // Forbidden - No permission
              break;
            case 404:
              // Not found
              break;
            case 500:
            case 502:
            case 503:
              // Server errors
              break;
          }
        } else {
          // Network error (no response)
          if (error.type == DioExceptionType.connectionTimeout) {
            // Connection timeout
          } else if (error.type == DioExceptionType.receiveTimeout) {
            // Receive timeout
          } else if (error.type == DioExceptionType.unknown) {
            // No internet connection
          }
        }
        handler.next(error);
      },
    );
  }

  // ==================== HTTP METHODS ====================

  /// Perform GET request.
  ///
  /// Example:
  /// ```dart
  /// final response = await apiClient.get('/users');
  /// final users = response.data;
  /// ```
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Perform POST request.
  ///
  /// Example:
  /// ```dart
  /// final response = await apiClient.post('/users', data: {
  ///   'name': 'John Doe',
  ///   'email': 'john@example.com',
  /// });
  /// ```
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Perform PUT request.
  ///
  /// Example:
  /// ```dart
  /// final response = await apiClient.put('/users/123', data: {
  ///   'name': 'Jane Doe',
  /// });
  /// ```
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Perform PATCH request.
  ///
  /// Example:
  /// ```dart
  /// final response = await apiClient.patch('/users/123', data: {
  ///   'email': 'newemail@example.com',
  /// });
  /// ```
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Perform DELETE request.
  ///
  /// Example:
  /// ```dart
  /// await apiClient.delete('/users/123');
  /// ```
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Upload file with progress tracking.
  ///
  /// Example:
  /// ```dart
  /// await apiClient.upload(
  ///   '/upload',
  ///   filePath: '/path/to/file.jpg',
  ///   onProgress: (sent, total) {
  ///     print('${(sent / total * 100).toStringAsFixed(0)}%');
  ///   },
  /// );
  /// ```
  Future<Response> upload(
    String path, {
    required String filePath,
    String fileKey = 'file',
    Map<String, dynamic>? data,
    void Function(int sent, int total)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      ...?data,
      fileKey: await MultipartFile.fromFile(filePath),
    });

    return await dio.post(
      path,
      data: formData,
      onSendProgress: onProgress,
    );
  }

  /// Download file with progress tracking.
  ///
  /// Example:
  /// ```dart
  /// await apiClient.download(
  ///   '/files/document.pdf',
  ///   savePath: '/path/to/save/document.pdf',
  ///   onProgress: (received, total) {
  ///     print('${(received / total * 100).toStringAsFixed(0)}%');
  ///   },
  /// );
  /// ```
  Future<Response> download(
    String path, {
    required String savePath,
    void Function(int received, int total)? onProgress,
  }) async {
    return await dio.download(
      path,
      savePath,
      onReceiveProgress: onProgress,
    );
  }
}
