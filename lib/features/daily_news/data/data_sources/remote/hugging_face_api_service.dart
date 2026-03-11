import 'package:dio/dio.dart';
import '../../../../../core/constants/constants.dart';

class HuggingFaceApiService {
  final Dio _dio;

  HuggingFaceApiService(this._dio);

  Future<Response> generateSummary(
    String authorization,
    Map<String, dynamic> body,
  ) async {
    return _dio.post(
      huggingFaceUrl,
      options: Options(
        headers: {
          'Authorization': authorization,
          'Content-Type': 'application/json',
        },
      ),
      data: body,
    );
  }
}
