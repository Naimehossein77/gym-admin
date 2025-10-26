// models/basic_response.dart
class BasicResponse {
  final bool success;
  final String message;

  BasicResponse({required this.success, required this.message});

  factory BasicResponse.fromJson(Map<String, dynamic> j) => BasicResponse(
        success: (j['success'] as bool?) ?? false,
        message: (j['message'] as String?) ?? 'Unknown response',
      );
}