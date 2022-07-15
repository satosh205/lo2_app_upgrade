import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:masterg/data/api/api_constants.dart';
import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';

class TrainingService {
  TrainingService(this.api);

  ApiService api;

  Map<String, dynamic> get defaultParams => {
        "key": api.env.apiKey, // all
      };

  Future<dynamic> getTrainings() async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.PROGRAMS_LIST,
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
              },
              contentType: "application/json",
              responseType: ResponseType.json // or ResponseType.JSON
              ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('api call response -- ${response}');

        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response.data);
        } else {
          debugPrint('api call response -- ${response}');
          return ApiResponse.success(response);
        }
      }
    } catch (e) {
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
  }

  Future<dynamic> getMTraningData(int id) async {
    //  Utility.hideKeyboard();

    try {
      final response =
          await api.dio.get(ApiConstants.COURSE_LIST + '?category_id=$id',
              options: Options(
                  method: 'GET',
                  headers: {
                    "Authorization": "Bearer ${UserSession.userToken}",
                    ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
                  },
                  contentType: "application/json",
                  responseType: ResponseType.json // or ResponseType.JSON
                  ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response.data);
        } else {
          return ApiResponse.success(response);
        }
      }
    } catch (e) {
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
  }

  Future<dynamic> getTrainingDetail(int? moduleId) async {
    //  Utility.hideKeyboard();
    try {
      final response =
          await api.dio.get(ApiConstants.PROGRAMS_LIST + '/${moduleId}',
              options: Options(
                  method: 'POST',
                  headers: {
                    "Authorization": "Bearer ${UserSession.userToken}",
                    ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
                  },
                  contentType: "application/json",
                  responseType: ResponseType.json // or ResponseType.JSON
                  ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('api call response -- ${response}');

        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response.data);
        } else {
          debugPrint('api call response -- ${response}');
          return ApiResponse.success(response);
        }
      }
    } catch (e) {
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
  }

  Future<dynamic> getDetailContent(int? moduleId) async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(
          ApiConstants.MODULES +
              '/$moduleId' +
              "/${UserSession.userContentLanguageId}",
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
              },
              contentType: "application/json",
              responseType: ResponseType.json // or ResponseType.JSON
              ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('api call response -- ${response}');

        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response.data);
        } else {
          debugPrint('api call response -- ${response}');
          return ApiResponse.success(response);
        }
      }
    } catch (e) {
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
  }

  Future<dynamic> getTrainingDetailedContent(int? programContentId) async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio
          .get(ApiConstants.CONTENT_DETAILS + '/${programContentId}',
              options: Options(
                  method: 'POST',
                  headers: {
                    "Authorization": "Bearer ${UserSession.userToken}",
                    ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
                  },
                  contentType: "application/json",
                  responseType: ResponseType.json // or ResponseType.JSON
                  ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('api call response -- ${response}');

        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response.data);
        } else {
          debugPrint('api call response -- ${response}');
          return ApiResponse.success(response);
        }
      }
    } catch (e) {
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
  }

  Future<dynamic> getAnnouncemnets(Map<String, dynamic> data) async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.GET_CONTENT_API,
          queryParameters: data,
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
              },
              contentType: "application/json",
              responseType: ResponseType.json // or ResponseType.JSON
              ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('api call response -- ${response}');

        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response.data);
        } else {
          debugPrint('api call response -- ${response}');
          return ApiResponse.success(response);
        }
      }
    } catch (e) {
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
  }

  Future<dynamic> getAssignmentDetails(int? id) async {
    //  Utility.hideKeyboard();
    try {
      final response =
          await api.dio.get(ApiConstants.ASSIGNMENT_DETAILS + id.toString(),
              options: Options(
                  method: 'GET',
                  headers: {
                    "Authorization": "Bearer ${UserSession.userToken}",
                    ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
                  },
                  contentType: "application/json",
                  responseType: ResponseType.json // or ResponseType.JSON
                  ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('api call response -- ${response}');

        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response.data);
        } else {
          debugPrint('api call response -- ${response}');
          return ApiResponse.success(response);
        }
      }
    } catch (e) {
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
  }

  Future<ApiResponse?> submitAssignment(
      {int? id, String? notes,  String? path}) async {
    try {
      print(path);
      var formData = FormData.fromMap({
        "content_id": id,
        "user_notes": notes,
        "file":
            await MultipartFile.fromFile(path!, filename: path.split("/").last)
      });
      print(formData.fields);
      print(formData.files);
      final response = await api.dio.post(ApiConstants.SUBMIT_ASSIGNMENT,
          data: formData,
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
              },
              contentType: "multipart/form-data"));
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response.data);
        } else {
          return ApiResponse.success(response);
        }
      }
    } catch (e, s) {
      print(e.toString());
      print(s);
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
    return null;
  }

  getAssessmentInstructions(int? programContentId) async {
    try {
      final response = await api.dio.get(
          ApiConstants.ASSESSMENT_INSTRUCTIONS + programContentId.toString(),
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
              },
              contentType: "application/json",
              responseType: ResponseType.json // or ResponseType.JSON
              ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('api call response -- ${response}');

        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response.data);
        } else {
          debugPrint('api call response -- ${response}');
          return ApiResponse.success(response);
        }
      }
    } catch (e) {
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
  }
}
