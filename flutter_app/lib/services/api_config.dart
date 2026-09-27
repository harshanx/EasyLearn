class ApiConfig {
  // Base URL for the backend API
  // Change this to match your backend server address
  static const String baseUrl = 'http://10.0.2.2:8000';
  
  // For emulator testing, use 10.0.2.2 to access localhost
  // For physical device testing, use your machine's IP address
  // For production, use your actual backend URL
  
  // API Endpoints
  static const String apiVersion = '/api/v1';
  
  // Auth endpoints
  static const String usersEndpoint = '$apiVersion/users';
  
  // Student endpoints
  static const String studentsEndpoint = '$apiVersion/students';
  
  // Screening endpoints
  static const String screeningsEndpoint = '$apiVersion/screenings';
  static const String predictEndpoint = '$screeningsEndpoint/predict';
  
  // Intervention endpoints
  static const String interventionsEndpoint = '$apiVersion/interventions';
  
  // Timeout duration in seconds
  static const int timeoutDuration = 30;
}
