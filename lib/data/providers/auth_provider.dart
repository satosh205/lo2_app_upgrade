import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:masterg/data/api/api_constants.dart';
import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/auth_request/email_request.dart';
import 'package:masterg/data/models/request/auth_request/login_request.dart';
import 'package:masterg/data/models/request/auth_request/signup_request.dart';
import 'package:masterg/data/models/request/auth_request/swayam_login_request.dart';
import 'package:masterg/data/models/request/auth_request/update_user_request.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/config.dart';

class AuthProvider {
  AuthProvider({required this.api});

  ApiService api;

  Map<String, dynamic> get defaultParams => {
        "key": api.env.apiKey, // all
      };

  Future<ApiResponse?> loginCall({required LoginRequest request}) async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.post(ApiConstants.LOGIN,
          data: json.encode(request.toJson()),
          options: Options(
              method: 'POST',
              headers: {ApiConstants.API_KEY: ApiConstants().APIKeyValue()},
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
    return null;
  }

  Future<ApiResponse?> updateUser(UpdateUserRequest request) async {
    //  Utility.hideKeyboard();
    try {
      Log.v(request.toJson());
      Map<String, dynamic>? data = request.toJson().cast<String, String>();
      if (request.profilePic != null && request.profilePic!.isNotEmpty) {
        String fileName = request.profilePic!.split('/').last;
        data['profile_pic'] = await MultipartFile.fromFile(
            '${request.profilePic}',
            filename: fileName);
      }
      Log.v(data);
      final response = await api.dio.post(ApiConstants.UPDATE_PROFILE_API,
          data: FormData.fromMap(data),
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
              },
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
      // if (e.response.data.containsKey('error') &&
      //     (e.response.data["error"] as List).length != 0) {
      //   return ApiResponse.error(e.response.data);
      // } else
      //   return ApiResponse.failure(e, message: "Something went wrong");
    }
  }

  Future<ApiResponse?> signUpCall(SignUpRequest request) async {
    try {
      print('request ====${request.toJson()}');
      Map<String, dynamic> data = request.toJson();
      String fileName = request.profilePic!.split('/').last;
      data['profile_pic'] =
          await MultipartFile.fromFile(request.profilePic!, filename: fileName);
      final response = await api.dio.post(
          '${ApiConstants.SIGNUP}${APK_DETAILS['package_name'] == 'com.learn_build' ? '?org=1' : ''}',
          data: FormData.fromMap(data),
          options: Options(
            method: 'POST',
            headers: {
              ApiConstants.API_KEY: ApiConstants().APIKeyValue(),
            },
            // responseType: ResponseType.json // or ResponseType.JSON
          )); 

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response);
      }
    } catch (e) {}
    return null;
  }

  Future<ApiResponse?> getStateList() async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.STATE_API,
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

  Future<ApiResponse?> getAppVerison({String? deviceType}) async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.UPDATE_API,
          queryParameters: {"device_type": deviceType},
          options: Options(
              method: 'GET',
              headers: {
                ApiConstants.API_KEY: ApiConstants().APIKeyValue(),
              },
              responseType: ResponseType.json // or ResponseType.JSON
              ));
      Log.v("231455559999999");
      Log.v(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response.data);
        } else {
          return ApiResponse.success(response);
        }
      }
    } catch (e) {
      Log.v("23145555");
    }
    return null;
  }

    Future<ApiResponse?> getCityList(int stateId) async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.CITY_API + "/$stateId",
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

    Future<ApiResponse?> swayamLoginCall({SwayamLoginRequest? request}) async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.post(ApiConstants.SWAYAM_LOGIN,
          data: json.encode(request?.toJson()),
          options: Options(
              method: 'POST',
              headers: {ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE},
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


  Future<ApiResponse?> verifyOTP(EmailRequest request) async {
    try {
      final response = await api.dio.post(ApiConstants.VERIFY_OTP,
          data: json.encode(request.toJson()),
          options: Options(
              method: 'POST',
              headers: {ApiConstants.API_KEY: ApiConstants().APIKeyValue()},
              responseType: ResponseType.json // or ResponseType.JSON
              ));

      Log.v('api responseee is ${response}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response.data);
        } else {
          return ApiResponse.success(response);
        }
      }
    } catch (e) {
      Log.v('api expecation ${e}');
    }
    return null;
  }
}
