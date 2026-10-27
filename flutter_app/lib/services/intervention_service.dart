import 'api_service.dart';
import 'api_config.dart';

class InterventionService {
  final ApiService _apiService;
  
  InterventionService({ApiService? apiService}) : _apiService = apiService ?? ApiService();
  
  // Get all interventions
  Future<List<Map<String, dynamic>>> getInterventions({String? category}) async {
    String endpoint = ApiConfig.interventionsEndpoint;
    if (category != null) {
      endpoint += '?category=$category';
    }
    final response = await _apiService.get(endpoint);
    return (response as List?)?.cast<Map<String, dynamic>>() ?? [];
  }
  
  // Get intervention by ID
  Future<Map<String, dynamic>> getInterventionById(int interventionId) async {
    return await _apiService.get('${ApiConfig.interventionsEndpoint}/$interventionId');
  }
  
  // Get personalized recommendations
  Future<Map<String, dynamic>> getRecommendations({
    String? studentId,
    int? studentAge,
    String? studentGrade,
    required List<String> topFeatures,
    required String riskLevel,
  }) async {
    return await _apiService.post(
      '${ApiConfig.interventionsEndpoint}/recommend',
      body: {
        if (studentId != null) 'student_id': studentId,
        if (studentAge != null) 'student_age': studentAge,
        if (studentGrade != null) 'student_grade': studentGrade,
        'top_features': topFeatures,
        'risk_level': riskLevel,
      },
    );
  }
}
