import 'package:dio/dio.dart';
import 'package:eventflow/utils/constants/api_constants.dart';
import 'package:flutter/foundation.dart';
import '../datasource/dio/dio_clint.dart';
import '../datasource/response/api_error_handler.dart';
import '../datasource/response/api_response.dart';

class MediaRepo {
  final DioClient? dioClient;

  MediaRepo({@required this.dioClient});

  Future<ApiResponse> uploadMedia(
      {required MultipartFile file,required String apiKey, required bool isVideo}) async {
    try {
      var body = FormData.fromMap({
        "key": apiKey,
        "image": file,
      });
      final response = await dioClient!.post(Apis.uploadImage, data: body);
      if (kDebugMode) {
        print("response : ${response.data.toString()}");
      }
      return ApiResponse.withSuccess(response);
    } catch (e) {
      if (kDebugMode) {
        print("error on repo : $e");
      }
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
