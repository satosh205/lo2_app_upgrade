import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:masterg/data/api/api_constants.dart';
import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/dealer/submit_reward_req.dart';
import 'package:masterg/data/models/request/home_request/track_announcement_request.dart';
import 'package:masterg/data/models/request/home_request/user_program_subscribe.dart';
import 'package:masterg/data/models/request/home_request/user_tracking_activity.dart';
import 'package:masterg/data/models/request/save_answer_request.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/utility.dart';

class HomeProvider {
  HomeProvider({required this.api});

  ApiService api;

  Map<String, dynamic> get defaultParams => {
        "key": api.env.apiKey, // all
      };

  Future<ApiResponse?> getMyAssignmentList({int? contentType}) async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.GET_ASSIGNMENT_API,
          /*queryParameters: {
            'id': 1,
            'category_id': '$contentType',
            'language': UserSession.userContentLanguageId
          },*/
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> getContentList({int? contentType}) async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.GET_CONTENT_API,
          queryParameters: {
            'id': 1,
            'category_id': '$contentType',
            'language': UserSession.userContentLanguageId
          },
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> getMyAssessmentList({int? contentType}) async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.GET_ASSESSMENT_API,
          /*queryParameters: {
            'id': 1,
            'category_id': '$contentType',
            'language': UserSession.userContentLanguageId
          },*/
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  static Future<ApiResponse?> getContentDetails({int? id}) async {
    //  Utility.hideKeyboard();
    final _url = ApiConstants().PRODUCTION_BASE_URL() +
        "api/joy/contents/" +
        id.toString();
    Log.v(_url);
    try {
      final response = await http.get(
        Uri.parse(_url),
        headers: {
          "Authorization": "Bearer ${UserSession.userToken}",
          ApiConstants.API_KEY: ApiConstants().APIKeyValue(),
          "Content-Type": "application/json",
        },
      );
      Log.v(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('error') && (data["error"] as List).length != 0) {
          return ApiResponse.error(data);
        } else {
          // return ApiResponse.success(Response(data: data));
        }
      }
    } catch (e) {
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
    return null;
  }

  Future<ApiResponse?> getUserProfile() async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.USER_PROFILE_API,
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
              },
              contentType: "application/json",
              responseType: ResponseType.json // or ResponseType.JSON
              ));
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
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
    return null;
  }

  Future<ApiResponse?> updateUserProfileImage(String? filePath) async {
    //  Utility.hideKeyboard();

    try {
      Map<String, dynamic> data = Map();
      if (filePath != null && filePath.isNotEmpty) {
        String fileName = filePath.split('/').last;
        data['profile_pic'] =
            await MultipartFile.fromFile(filePath, filename: fileName);
      }
      final response = await api.dio.post(ApiConstants.USER_PROFILE_IMAGE_API,
          data: FormData.fromMap(data),
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
              },
              responseType: ResponseType.json // or ResponseType.JSON
              ));
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
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
    return null;
  }

  Future<ApiResponse?> likeContent(
      int? contentId, String? type, int? like) async {
    //  Utility.hideKeyboard();
    try {
      Map<String, dynamic> data = Map();
      data["content_id"] = contentId;
      data['type'] = type;
      data['like'] = like;
      final response = await api.dio.post(ApiConstants.LIKE_CONTENT,
          data: FormData.fromMap(data),
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
              },
              contentType: "application/json",
              responseType: ResponseType.json // or ResponseType.JSON
              ));
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
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
    return null;
  }

  Future<ApiResponse?> getLanguage(int? languageType) async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(
          languageType == 1
              ? ApiConstants.APP_LANGUAGE_API
              : languageType == 2
                  ? ApiConstants.LANGUAGE_API
                  : ApiConstants.APP_LANGUAGE_API,
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> getMasterLanguage() async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.MASTER_LANGUAGE_API,
          options: Options(
              method: 'GET',
              headers: {
                //"Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
              },
              contentType: "application/json",
              responseType: ResponseType.json // or ResponseType.JSON
              ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          Log.v("====> ${response.statusCode}");
          return ApiResponse.error(response.data);
        } else {
          Log.v("====> ${response.statusCode}");
          return ApiResponse.success(response);
        }
      }
    } catch (e) {
      // Log.v("====> ${e.response.data["message"]}");
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
    return null;
  }

  Future<ApiResponse?> getjoyCategory() async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(
          ApiConstants.JOY_CATEGORY +
              '?language_id=${Preference.getInt(Preference.APP_LANGUAGE) ?? 1}',
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> getComment(int? postId) async {
    //  Utility.hideKeyboard();
    Map<String, dynamic> data = Map();
    data['post_id'] = postId;
    data['show_all'] = 1;
    try {
      final response = await api.dio.post(ApiConstants.COMMENT_LIST,
          data: FormData.fromMap(data),
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> postComment(
      int? postId, int? parentId, String? comment) async {
    //  Utility.hideKeyboard();
    Map<String, dynamic> data = Map();
    data['post_id'] = postId;
    data['parent_id'] = parentId;
    data['content'] = comment;
    try {
      final response = await api.dio.post(ApiConstants.POST_COMMENT_LIST,
          data: FormData.fromMap(data),
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> getjoyContentList() async {
    //  Utility.hideKeyboard();
    try {
      final response =
          //await api.dio.get(ApiConstants.JOY_CONTENT_LIST + '?is_featured=2',
          await api.dio.get(
              ApiConstants.JOY_CONTENT_LIST +
                  '?category_id=${Preference.getString('interestCategory')}',
              // '?language_id=${Preference.getInt(Preference.APP_LANGUAGE)}',
              options: Options(
                  method: 'GET',
                  headers: {
                    "Authorization": "Bearer ${UserSession.userToken}",
                    ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> getLiveClasses() async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.post(ApiConstants.LIVECLASSLIST,
          data: {'date': ''},
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
              },
              contentType: "application/json",
              responseType: ResponseType.json // or ResponseType.JSON
              ));
      Log.v("oboardsessions4444");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response.data);
        } else {
          return ApiResponse.success(response);
        }
      }
    } catch (e) {
      Log.v("oboardsessions");
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
    return null;
  }

  // ignore: missing_return
  Future<ApiResponse?> getPrograms() async {
    try {
      final response = await api.dio.get(ApiConstants.COURSE_CATEGORY,
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> getCourseWithId(int? id) async {
    try {
      final response =
          await api.dio.get(ApiConstants.COURSE_LIST + '?category_id=$id',
              options: Options(
                  method: 'GET',
                  headers: {
                    "Authorization": "Bearer ${UserSession.userToken}",
                    ApiConstants.API_KEY: ApiConstants().APIKeyValue()
                  },
                  contentType: "application/json",
                  responseType: ResponseType.json // or ResponseType.JSON
                  ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response);
        } else {
          return ApiResponse.success(response);
        }
      }
    } catch (e) {
      // return ApiResponse.failure(e, message: e.response.data["message"]);
    }
    return null;
  }

  // ignore: missing_return
  Future<ApiResponse?> getFeaturedVideo() async {
    try {
      final response = await api.dio.get(ApiConstants.FEATURED_VIDEOS,
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> getInterestPrograms() async {
    try {
      final response = await api.dio.get(
          ApiConstants.INTEREST_PROGRAM_LIST +
              '?language_id=${Preference.getInt(Preference.APP_LANGUAGE) ?? 1}',
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> mapInterest(String? parameter) async {
    try {
      final response = await api.dio
          .get(ApiConstants.MAP_INTEREST + '?category_ids=$parameter',
              options: Options(
                  method: 'POST',
                  headers: {
                    "Authorization": "Bearer ${UserSession.userToken}",
                    //"Authorization":"bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9iODBmLTE4Mi03Ni00MS01OS5uZ3Jvay5pb1wvYXBpXC9sb2dpbiIsImlhdCI6MTY0NjY0NTgzOCwiZXhwIjoxNjUwMjQ1ODM4LCJuYmYiOjE2NDY2NDU4MzgsImp0aSI6Ild6b0oxeGlub3FSdktXT3AiLCJzdWIiOjE2LCJwcnYiOiI4N2UwYWYxZWY5ZmQxNTgxMmZkZWM5NzE1M2ExNGUwYjA0NzU0NmFhIn0.r8mR2JABQ7jMZRs-Rg1iRZ1SsckjSIyD1bp2L58uZdc",
                    ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> getPopularCourses() async {
    try {
      final response = await api.dio.get(ApiConstants.POPULARCOURSES,
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                //"Authorization":"bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9iODBmLTE4Mi03Ni00MS01OS5uZ3Jvay5pb1wvYXBpXC9sb2dpbiIsImlhdCI6MTY0NjY0NTgzOCwiZXhwIjoxNjUwMjQ1ODM4LCJuYmYiOjE2NDY2NDU4MzgsImp0aSI6Ild6b0oxeGlub3FSdktXT3AiLCJzdWIiOjE2LCJwcnYiOiI4N2UwYWYxZWY5ZmQxNTgxMmZkZWM5NzE1M2ExNGUwYjA0NzU0NmFhIn0.r8mR2JABQ7jMZRs-Rg1iRZ1SsckjSIyD1bp2L58uZdc",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> bottombarResponse() async {
    try {
      final response = await api.dio.get('${ApiConstants.settings}?type=7',
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
              },
              // contentType: "application/json",
              responseType: ResponseType.json // or ResponseType.JSON
              ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data.containsKey('error') &&
            (response.data["error"] as List).isNotEmpty) {
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

  Future<ApiResponse?> getFilteredPopularCourses() async {
    try {
      final response = await api.dio.get(
          ApiConstants.POPULARCOURSES +
              '?types=short_term,recommended,most_viewed,highly_rated,other_learners',
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                //"Authorization":"bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9iODBmLTE4Mi03Ni00MS01OS5uZ3Jvay5pb1wvYXBpXC9sb2dpbiIsImlhdCI6MTY0NjY0NTgzOCwiZXhwIjoxNjUwMjQ1ODM4LCJuYmYiOjE2NDY2NDU4MzgsImp0aSI6Ild6b0oxeGlub3FSdktXT3AiLCJzdWIiOjE2LCJwcnYiOiI4N2UwYWYxZWY5ZmQxNTgxMmZkZWM5NzE1M2ExNGUwYjA0NzU0NmFhIn0.r8mR2JABQ7jMZRs-Rg1iRZ1SsckjSIyD1bp2L58uZdc",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> GCarvaanPost(int callCount, int? postId) async {
    try {
      int from = ((callCount - 1) * 10) + 1;
      final response = await api.dio.get(
          postId != null
              ? ApiConstants.GCARVAAN_POST +
                  '?from=1&count=10&content_type=0&id=$postId'
              : ApiConstants.GCARVAAN_POST +
                  '?from=$from&count=10&content_type=0',
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> GReelsPost() async {
    try {
      final response =
          await api.dio.get(ApiConstants.GREELS_POST + '?from=1&count=20',
              options: Options(
                  method: 'GET',
                  headers: {
                    "Authorization": "Bearer ${UserSession.userToken}",
                    ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> getPartners() async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.GET_PARTNER_API,
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> getCategorys() async {
    //  Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.CATEGORY_API,
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> submitReward(
      {required SubmitRewardReq submitRewardReq}) async {
    //  Utility.hideKeyboard();
    try {
      Log.v("ERROR DATA : ${submitRewardReq}");
      final response = await api.dio.post(ApiConstants.SUBMIT_REWARD_API,
          data: json.encode(submitRewardReq.toJson()),
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> activityAttempt(
      String? filePath, int? contentType, int? contentId) async {
    //  Utility.hideKeyboard();
    try {
      Map<String, dynamic> data = Map();
      if (filePath != null && filePath.isNotEmpty) {
        String fileName = filePath.split('/').last;
        data['file'] =
            await MultipartFile.fromFile(filePath, filename: fileName);
      }
      Log.v(data);
      data['content_id'] = contentId;
      final response = await api.dio.post(ApiConstants.ACTIVITY_ATTEMPT_API,
          data: FormData.fromMap(data),
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
      Log.v(e);
      // if (e.response.data.containsKey('error') &&
      //     (e.response.data["error"] as List).length != 0) {
      //   return ApiResponse.error(e.response.data);
      // } else
      //   return ApiResponse.failure(e, message: "Something went wrong");
    }
    return null;
  }

  Future<ApiResponse?> createPost(
      List<MultipartFile>? filePath,
      int? contentType,
      String? postType,
      String? title,
      String? description,
      List<String?>? filepaths) async {
    //  Utility.hideKeyboard();

    try {
      Map<String, dynamic> data = Map();
      List<MultipartFile> files = [];

      if (contentType == 2) {
        for (var item in filepaths!) {
          files.add(await MultipartFile.fromFile(item!,
              filename: item.split('/').last));
        }
        data['file[]'] = files;
      } else {
        files.add(await MultipartFile.fromFile(filepaths![0]!,
            filename: filepaths[0]!.split('/').last));
        data['file'] = files;
      }

      data['post_type'] = postType;
      data['title'] = "";
      data['description'] = description;
      data['content_type'] = contentType;
      data['status'] = '1';
      Log.v("upload file data is $data");

      final response = await api.dio.post(ApiConstants.CREATE_POST,
          data: FormData.fromMap(data),
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
      Log.v(e);
    }
    return null;
  }

  Future<ApiResponse?> getUserAnalytics() async {
    // Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.USER_ANALYTICS,
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> getLearningSpaceData() async {
    // Utility.hideKeyboard();
    try {
      final response = await api.dio.get(ApiConstants.LEARNINGSPACE_DATA,
          options: Options(
              method: 'GET',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> trackAnnouncment(
      {required TrackAnnouncementReq submitRewardReq}) async {
    try {
      Log.v("ERROR DATA : ${submitRewardReq}");
      final response = await api.dio.post(ApiConstants.TRACK_ANNOUNCMENT_API,
          data: json.encode(submitRewardReq.toJson()),
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> UserSubscribe(
      {required UserProgramSubscribeReq subrReq}) async {
    try {
      Log.v("ERROR DATA : ${subrReq}");
      final response = await api.dio.post(ApiConstants.SUBSCRIBE_PROGRAM,
          data: json.encode(subrReq.toJson()),
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> UserTrackingActivityReq(
      {required UserTrackingActivity submitRewardReq}) async {
    try {
      Log.v("ERROR DATA9999999 : ${submitRewardReq.toJson()}");
      final response = await api.dio.post(ApiConstants.TRACK_USER_ACTIVITY,
          data: json.encode(submitRewardReq.toJson()),
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants().APIKeyValue()
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
    return null;
  }

  Future<ApiResponse?> attemptTest({required String request}) async {
    Utility.hideKeyboard();
    try {
      final response = await api.dio.get(
        ApiConstants.ATTEMPT_ASSESSMENT + request,
        options: Options(
          method: 'GET',
          contentType: "application/json",
          headers: {
            "Authorization": "bearer ${UserSession.userToken}",
            ApiConstants.API_KEY: ApiConstants().APIKeyValue()
          },
          responseType: ResponseType.json, // or ResponseType.JSON
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response);
      }
    } catch (e) {
      if (e is DioError) {
        Log.v("data ==> ${e.response!.statusCode}");
      }
      // return ApiResponse.failure(e);
    }
    return null;
  }

  Future<ApiResponse?> saveAnswer({required SaveAnswerRequest request}) async {
    Utility.hideKeyboard();
    try {
      final response = await api.dio.post(
        ApiConstants.SAVE_ANSWER,
        data: request.toJson(),
        options: Options(
          method: 'POST',
          contentType: "application/json",
          headers: {
            "Authorization": "bearer ${UserSession.userToken}",
            ApiConstants.API_KEY: ApiConstants().APIKeyValue()
          },
          responseType: ResponseType.json, // or ResponseType.JSON
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response);
      }
    } catch (e) {
      if (e is DioError) {
        Log.v("data ==> ${e.response!.statusCode}");
      }
      // return ApiResponse.failure(e);
    }
    return null;
  }

  Future<ApiResponse?> submitAnswer({String? request}) async {
    Utility.hideKeyboard();
    try {
      final response = await api.dio.post(
        ApiConstants.SUBMMIT_ANSWER,
        data: {"content_id": request},
        options: Options(
          method: 'POST',
          contentType: "application/json",
          headers: {
            "Authorization": "bearer ${UserSession.userToken}",
            ApiConstants.API_KEY: ApiConstants().APIKeyValue()
          },
          responseType: ResponseType.json, // or ResponseType.JSON
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response);
      }
    } catch (e) {
      if (e is DioError) {
        Log.v("data ==> ${e.response!.statusCode}");
      }
      // return ApiResponse.failure(e);
    }
    return null;
  }

  Future<ApiResponse?> reviewTest({required String request}) async {
    Utility.hideKeyboard();
    try {
      final response = await api.dio.get(
        ApiConstants.ASSESSMENT_REVIEW + request,
        options: Options(
          method: 'GET',
          contentType: "application/json",
          headers: {
            "Authorization": "bearer ${UserSession.userToken}",
            ApiConstants.API_KEY: ApiConstants().APIKeyValue()
          },
          responseType: ResponseType.json, // or ResponseType.JSON
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response);
      }
    } catch (e) {
      // return ApiResponse.failure(e);
    }
    return null;
  }

  Future<ApiResponse?> getSubmissions({int? request}) async {
    Utility.hideKeyboard();
    try {
      final response = await api.dio.get(
        ApiConstants.ASSIGNMENT_SUBMISSION_DETAILS + "/$request",
        options: Options(
          method: 'GET',
          contentType: "application/json",
          headers: {
            "Authorization": "bearer ${UserSession.userToken}",
            ApiConstants.API_KEY: ApiConstants().APIKeyValue()
          },
          responseType: ResponseType.json, // or ResponseType.JSON
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response);
      }
    } catch (e) {
      // return ApiResponse.failure(e);
    }
    return null;
  }

  Future<ApiResponse?> createPortfolio(Map<String, dynamic> data) async {
    try {
      final response = await api.dio.post(ApiConstants.CREATE_PORTFOLIO,
          data: FormData.fromMap(data),
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
              },
              contentType: "application/json",
              responseType: ResponseType.json // or ResponseType.JSON
              ));
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
      if (e is DioError) {
        Log.v("data ==> ${e.response!.statusCode}");
      }
      //return ApiResponse.failure(e, message: e.response.data["message"]);
    }
  }

  Future<ApiResponse?> masterBrandCreate(Map<String, dynamic> data) async {
    try {
      final response = await api.dio.post(ApiConstants.MASTER_BRAND_CREATE,
          data: FormData.fromMap(data),
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
              },
              contentType: "application/json",
              responseType: ResponseType.json // or ResponseType.JSON
              ));
      Log.v(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response);

        /*if (response.data.containsKey('error') &&
            (response.data["error"] as List).length != 0) {
          return ApiResponse.error(response.data);
        } else {
          return ApiResponse.success(response);
        }*/

      }
    } catch (e) {
      if (e is DioError) {
        Log.v("data ==> ${e.response!.statusCode}");
      }
      //return ApiResponse.failure(e, message: e.response.data["message"]);
    }
  }

  Future<ApiResponse?> userBrandCreate(Map<String, dynamic> data) async {
    try {
      final response = await api.dio.post(ApiConstants.USER_BRAND_CREATE,
          data: FormData.fromMap(data),
          options: Options(
              method: 'POST',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
              },
              contentType: "application/json",
              responseType: ResponseType.json // or ResponseType.JSON
              ));
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
      if (e is DioError) {
        Log.v("data ==> ${e.response!.statusCode}");
      }
      //return ApiResponse.failure(e, message: e.response.data["message"]);
    }
  }

  Future<ApiResponse?> deletePortfolio(int id) async {
    try {
      final response = await api.dio.delete(ApiConstants.PORTFOLIO + '/$id',
          options: Options(
              method: 'DELETE',
              headers: {
                "Authorization": "Bearer ${UserSession.userToken}",
                ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
              },
              contentType: "application/json",
              responseType: ResponseType.json // or ResponseType.JSON
              ));
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
      if (e is DioError) {
        Log.v("data ==> ${e.response!.statusCode}");
      }
      //return ApiResponse.failure(e, message: e.response.data["message"]);
    }
  }

  Future<ApiResponse?> listPortfolio(String type, int userId) async {
    try {
      final response = await api.dio
          .get(ApiConstants.PORTFOLIO + '?type=$type&user_id=$userId',
              options: Options(
                  method: 'GET',
                  headers: {
                    "Authorization": "Bearer ${UserSession.userToken}",
                    ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
                  },
                  contentType: "application/json",
                  responseType: ResponseType.json // or ResponseType.JSON
                  ));
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
      if (e is DioError) {
        Log.v("data ==> ${e.response!.statusCode}");
      }
      //return ApiResponse.failure(e, message: e.response.data["message"]);
    }
  }
}
