import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eventflow/data/datasource/services/firebase/firebase_services.dart';
import 'package:eventflow/data/models/image_response.dart';
import 'package:eventflow/data/repos/media_repo.dart';
import 'package:eventflow/utils/common_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasource/response/api_response.dart';

class MediaProvider extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;
  final MediaRepo? mediaRepo;

  MediaProvider({@required this.sharedPreferences, @required this.mediaRepo});

  Future<void> refresh() async {
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      notifyListeners();
    });
  }

  /// --- IMAGEPATH
  ///

  String get imagePath => _imagePath;
  String _imagePath = "";

  void setImagePath({required String newPath, bool listen = true}) {
    _imagePath = newPath;

    if (listen) notifyListeners();
  }

  /// --- UPLOAD IMAGE API INTEGRATION
  ///

  ImageResponse? get imageResponse => _imageResponse;
  ImageResponse? _imageResponse;

  Future<String> uploadImage(
      {required String imagePath, bool listen = true}) async {
    String imageUrl = '';
    try {
      final String apiKey = await FireServices.instance.fetchApiKey();
      ApiResponse res = await mediaRepo!.uploadMedia(
          apiKey: apiKey,
          file: await MultipartFile.fromFile(imagePath,
              contentType: MediaType.parse(getMimeType(filePath: imagePath))),
          isVideo: false);

      if (res.response?.data != null && res.response?.statusCode == 200) {
        ImageResponse image = ImageResponse.fromJson(res.response?.data);
        imageUrl = image.data!.url!;
      }
    } catch (e) {
      print("--> --> err upload image provider : $e");
      showToast("Something went wrong.!");
    } finally {
      if (listen) notifyListeners();
      return imageUrl;
    }
  }

  String getMimeType({required String filePath}) {
    String? addressName;
    String? addressMimeType;
    if (filePath != "") {
      addressName =
          filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
      addressMimeType = mime(addressName);
    }
    return addressMimeType ?? "";
  }
}
