import 'api_service.dart';
import 'api_config.dart';

class ScreeningService {
  final ApiService _apiService;
  
  ScreeningService({ApiService? apiService}) : _apiService = apiService ?? ApiService();
  
  // Create a screening record
  Future<Map<String, dynamic>> createScreening({
    required int studentId,
    String? riskLevel,
    double? modelProbability,
    Map<String, dynamic>? featuresData,
    Map<String, dynamic>? shapExplanation,
  }) async {
    return await _apiService.post(
      ApiConfig.screeningsEndpoint,
      body: {
        'student_id': studentId,
        'risk_level': riskLevel,
        'model_probability': modelProbability,
        'features_data': featuresData,
        'shap_explanation': shapExplanation,
      },
    );
  }
  
  // Submit questionnaire for prediction
  Future<Map<String, dynamic>> predictScreening({
    required String studentId,
    required Map<String, double> features,
  }) async {
    return await _apiService.post(
      ApiConfig.predictEndpoint,
      body: {
        'student_id': studentId,
        'features': features,
      },
    );
  }
  
  // Get all screenings
  Future<List<Map<String, dynamic>>> getScreenings({int skip = 0, int limit = 100}) async {
    final response = await _apiService.get('${ApiConfig.screeningsEndpoint}?skip=$skip&limit=$limit');
    return (response as List?)?.cast<Map<String, dynamic>>() ?? [];
  }
  
  // Get screening by ID
  Future<Map<String, dynamic>> getScreeningById(int screeningId) async {
    return await _apiService.get('${ApiConfig.screeningsEndpoint}/$screeningId');
  }
  
  // Get all screenings for a specific student
  Future<List<Map<String, dynamic>>> getStudentScreenings(int studentId) async {
    final response = await _apiService.get('${ApiConfig.screeningsEndpoint}/student/$studentId');
    return (response as List?)?.cast<Map<String, dynamic>>() ?? [];
  }
}
