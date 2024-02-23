import 'package:dio/dio.dart';
import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:flutter/foundation.dart';

import '../datasource/dio/dio_clint.dart';
import '../datasource/response/api_error_handler.dart';
import '../datasource/response/api_response.dart';


class NotificationRepo {
  final DioClient? dioClient;
  
  

  NotificationRepo({@required this.dioClient});

  Future<ApiResponse> sendNotification({required String apiUrl, required Map<String, dynamic> body}) async {
    try {
      final res = await dioClient!.post(
        apiUrl,
        data: body,
        options: Options(
          headers: {
            "Authorization": "key=${await FireServices.instance.fetchServerKey()}",
          },
        ),
      );
      return ApiResponse.withSuccess(res);
    } catch (e) {
      if (kDebugMode) {
        print("error in notifcaion repo  : $e");
      }
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
