import 'api_service.dart';
import 'api_config.dart';

class StudentService {
  final ApiService _apiService;
  
  StudentService({ApiService? apiService}) : _apiService = apiService ?? ApiService();
  
  // Create a new student
  Future<Map<String, dynamic>> createStudent({
    required String studentId,
    required String fullName,
    required int parentId,
    int? age,
    String? grade,
  }) async {
    return await _apiService.post(
      ApiConfig.studentsEndpoint,
      body: {
        'student_id': studentId,
        'full_name': fullName,
        'parent_id': parentId,
        'age': age,
        'grade': grade,
      },
    );
  }
  
  // Get all students
  Future<List<Map<String, dynamic>>> getStudents({int skip = 0, int limit = 100}) async {
    final response = await _apiService.get('${ApiConfig.studentsEndpoint}?skip=$skip&limit=$limit');
    return (response as List?)?.cast<Map<String, dynamic>>() ?? [];
  }
  
  // Get student by internal ID
  Future<Map<String, dynamic>> getStudentById(int studentId) async {
    return await _apiService.get('${ApiConfig.studentsEndpoint}/$studentId');
  }
  
  // Get student by external student_id
  Future<Map<String, dynamic>> getStudentByExternalId(String studentExternalId) async {
    return await _apiService.get('${ApiConfig.studentsEndpoint}/by-student-id/$studentExternalId');
  }
  
  // Update student
  Future<Map<String, dynamic>> updateStudent(
    int studentId, {
    String? fullName,
    int? age,
    String? grade,
  }) async {
    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName;
    if (age != null) body['age'] = age;
    if (grade != null) body['grade'] = grade;
    
    return await _apiService.put(
      '${ApiConfig.studentsEndpoint}/$studentId',
      body: body,
    );
  }
  
  // Delete student
  Future<void> deleteStudent(int studentId) async {
    await _apiService.delete('${ApiConfig.studentsEndpoint}/$studentId');
  }
}
