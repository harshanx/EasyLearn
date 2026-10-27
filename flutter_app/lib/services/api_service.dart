import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

class ApiService {
  final http.Client _client;
  final AuthService _authService;
  
  ApiService({http.Client? client, AuthService? authService}) 
      : _client = client ?? http.Client(),
        _authService = authService ?? AuthService();
  
  // Get headers with authorization
  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    
    if (includeAuth) {
      final token = await _authService.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }
  
  // Generic GET request
  Future<dynamic> get(String endpoint, {bool requireAuth = true}) async {
    try {
      final headers = await _getHeaders(includeAuth: requireAuth);
      final response = await _client
          .get(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
          )
          .timeout(Duration(seconds: ApiConfig.timeoutDuration));
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // Generic POST request
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body, bool requireAuth = true}) async {
    try {
      final headers = await _getHeaders(includeAuth: requireAuth);
      final response = await _client
          .post(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(Duration(seconds: ApiConfig.timeoutDuration));
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // OAuth2PasswordRequestForm endpoints require URL-encoded form fields.
  Future<Map<String, dynamic>> postForm(
    String endpoint, {
    required Map<String, String> fields,
    bool requireAuth = false,
  }) async {
    try {
      final headers = <String, String>{'Content-Type': 'application/x-www-form-urlencoded'};
      if (requireAuth) {
        final token = await _authService.getToken();
        if (token != null && token.isNotEmpty) headers['Authorization'] = 'Bearer $token';
      }
      final response = await _client
          .post(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
            body: fields,
          )
          .timeout(Duration(seconds: ApiConfig.timeoutDuration));
      return _handleResponse(response) as Map<String, dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // Generic PUT request
  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? body, bool requireAuth = true}) async {
    try {
      final headers = await _getHeaders(includeAuth: requireAuth);
      final response = await _client
          .put(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(Duration(seconds: ApiConfig.timeoutDuration));
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // Generic DELETE request
  Future<Map<String, dynamic>> delete(String endpoint, {bool requireAuth = true}) async {
    try {
      final headers = await _getHeaders(includeAuth: requireAuth);
      final response = await _client
          .delete(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
          )
          .timeout(Duration(seconds: ApiConfig.timeoutDuration));
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please login again');
    } else {
      throw Exception('HTTP Error: ${response.statusCode} - ${response.body}');
    }
  }
  
  // Handle errors
  Exception _handleError(dynamic error) {
    if (error is Exception) {
      return error;
    }
    return Exception('Unexpected error: $error');
  }
  
  // Close the client
  void dispose() {
    _client.close();
  }
}
