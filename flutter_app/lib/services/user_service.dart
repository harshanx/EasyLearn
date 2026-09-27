import 'api_service.dart';
import 'api_config.dart';
import 'auth_service.dart';

class UserService {
  final ApiService _apiService;
  final AuthService _authService;
  
  UserService({ApiService? apiService, AuthService? authService}) 
      : _apiService = apiService ?? ApiService(),
        _authService = authService ?? AuthService();
  
  // Create a new user
  Future<Map<String, dynamic>> createUser({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String role = 'parent',
  }) async {
    return await _apiService.post(
      ApiConfig.usersEndpoint,
      body: {
        'username': username,
        'email': email,
        'password': password,
        'full_name': fullName,
        'role': role,
      },
      requireAuth: false,
    );
  }
  
  // Get all users
  Future<List<Map<String, dynamic>>> getUsers({int skip = 0, int limit = 100}) async {
    final response = await _apiService.get('${ApiConfig.usersEndpoint}?skip=$skip&limit=$limit');
    return (response['users'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }
  
  // Get user by ID
  Future<Map<String, dynamic>> getUserById(int userId) async {
    return await _apiService.get('${ApiConfig.usersEndpoint}/$userId');
  }
  
  // Update user
  Future<Map<String, dynamic>> updateUser(
    int userId, {
    String? email,
    String? fullName,
    String? password,
  }) async {
    final body = <String, dynamic>{};
    if (email != null) body['email'] = email;
    if (fullName != null) body['full_name'] = fullName;
    if (password != null) body['password'] = password;
    
    return await _apiService.put(
      '${ApiConfig.usersEndpoint}/$userId',
      body: body,
    );
  }
  
  // Delete user
  Future<void> deleteUser(int userId) async {
    await _apiService.delete('${ApiConfig.usersEndpoint}/$userId');
  }
  
  // Login with JWT authentication
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      // Use form-data for OAuth2 login
      final response = await _apiService.post(
        '${ApiConfig.apiVersion}/auth/login',
        body: {
          'username': username,
          'password': password,
        },
        requireAuth: false,
      );
      
      // Save auth data if login successful
      if (response.containsKey('access_token') && response.containsKey('user')) {
        final user = response['user'] as Map<String, dynamic>;
        await _authService.saveAuthData(
          token: response['access_token'] as String,
          userId: user['id'] as int,
          username: user['username'] as String,
          role: user['role'] as String,
        );
      }
      
      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
  
  // Logout
  Future<void> logout() async {
    await _authService.clearAuthData();
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _authService.isAuthenticated();
  }
}
