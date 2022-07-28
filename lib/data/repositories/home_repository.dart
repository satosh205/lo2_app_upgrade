import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:masterg/data/models/request/save_answer_request.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/home_response/assignment_submissions_response.dart';
import 'package:masterg/data/models/response/home_response/category_response.dart';
import 'package:masterg/data/models/response/home_response/course_category_list_id_response.dart';
import 'package:masterg/data/models/response/home_response/create_post_response.dart';
import 'package:masterg/data/models/response/home_response/featured_video_response.dart';
import 'package:masterg/data/models/response/home_response/gcarvaan_post_reponse.dart';
import 'package:masterg/data/models/response/home_response/get_comment_response.dart';
import 'package:masterg/data/models/response/home_response/get_content_resp.dart';
import 'package:masterg/data/models/response/home_response/greels_response.dart';
import 'package:masterg/data/models/response/home_response/joy_category_response.dart';
import 'package:masterg/data/models/response/home_response/joy_contentList_response.dart';
import 'package:masterg/data/models/response/home_response/language_response.dart';
import 'package:masterg/data/models/response/home_response/learning_space_response.dart';
import 'package:masterg/data/models/response/home_response/map_interest_response.dart';
import 'package:masterg/data/models/response/home_response/master_language_response.dart';
import 'package:masterg/data/models/response/home_response/my_assessment_response.dart';
import 'package:masterg/data/models/response/home_response/my_assignment_response.dart';
import 'package:masterg/data/models/response/home_response/onboard_sessions.dart';
import 'package:masterg/data/models/response/home_response/popular_courses_response.dart';
import 'package:masterg/data/models/response/home_response/post_comment_response.dart';
import 'package:masterg/data/models/response/home_response/program_list_reponse.dart';
import 'package:masterg/data/models/response/home_response/save_answer_response.dart';
import 'package:masterg/data/models/response/home_response/submit_answer_response.dart';
import 'package:masterg/data/models/response/home_response/test_attempt_response.dart';
import 'package:masterg/data/models/response/home_response/test_review_response.dart';
import 'package:masterg/data/models/response/home_response/update_user_profile_response.dart';
import 'package:masterg/data/models/response/home_response/user_analytics_response.dart';
import 'package:masterg/data/models/response/home_response/user_profile_response.dart';
import 'package:masterg/data/providers/home_provider.dart';
import 'package:masterg/utils/Log.dart';

import '../models/response/home_response/create_portfolio_response.dart';
import '../models/response/home_response/delete_portfolio_response.dart';
import '../models/response/home_response/list_portfolio_responsed.dart';

class HomeRepository {
  HomeRepository({required this.homeProvider});

  final HomeProvider homeProvider;

  Future<MyAssessmentResponse> getMyAssessmentList() async {
    final response = await homeProvider.getMyAssessmentList();
    if (response!.success) {
      Log.v("SUCCESS DATA : ${json.encode(response.body)}");
      Log.v("MyAssingment123");
      MyAssessmentResponse resp = MyAssessmentResponse.fromJson(response.body);
      Log.v("MyAssingment");

      var box = Hive.box("content");
      box.put("myassessment",
          resp.data!.assessmentList!.map((e) => e.toJson()).toList());

      return resp;
    } else {
      Log.v("====> ${response.body}");
      return MyAssessmentResponse(
          error: response.body == null
              ? "Something went wrong:" as List<String>?
              : response.body);
    }
  }

  Future<MyAssignmentResponse> getMyAssignmentList() async {
    final response = await homeProvider.getMyAssignmentList();
    if (response!.success) {
      Log.v("SUCCESS DATA : ${json.encode(response.body)}");
      Log.v("MyAssingment123");
      MyAssignmentResponse resp = MyAssignmentResponse.fromJson(response.body);
      Log.v("MyAssingment");

      var box = Hive.box("content");
      box.put("myassignment", resp.data!.list!.map((e) => e.toJson()).toList());

      return resp;
    } else {
      Log.v("====> ${response.body}");
      return MyAssignmentResponse(
          error: response.body == null
              ? "Something went wrong:" as List<String>?
              : response.body);
    }
  }

  Future<UserProfileResp> getUserProfile() async {
    final response = await homeProvider.getUserProfile();
    if (response!.success) {
      Log.v("Profile DATA : ${response.body}");
      UserProfileResp resp = UserProfileResp.fromJson(response.body);
      Log.v("ERROR DATA : ${resp.toJson()}");
      var box = Hive.box("content");
      box.put("user_profile_data", resp);
      return resp;
    } else {
      Log.v("====> ${response.body}");
      return UserProfileResp();
    }
  }

  Future<UpdateProfileImageResponse> updateUserProfileImage(
      String? filePath) async {
    final response = await homeProvider.updateUserProfileImage(filePath);
    if (response!.success) {
      Log.v("Profile DATA : ${response.body}");
      UpdateProfileImageResponse resp =
          UpdateProfileImageResponse.fromJson(response.body);

      return resp;
    } else {
      Log.v("====> ${response.body}");
      return UpdateProfileImageResponse();
    }
  }

  Future likeContent(int? contentId, String? type, int? like) async {
    final response = await homeProvider.likeContent(contentId, type, like);
    if (response!.success) {
      Log.v("Profile DATA : ${response.body}");
      UserProfileResp resp = UserProfileResp.fromJson(response.body);
      Log.v("ERROR DATA : ${resp.toJson()}");

      return resp;
    } else {
      Log.v("====> ${response.body}");
      return;
    }
  }

  Future<CategoryResp> getCategory() async {
    final response = await homeProvider.getCategorys();
    if (response!.success) {
      Log.v("response!.success : ${response.body}");
      CategoryResp categoryResp = CategoryResp.fromJson(response.body);
      return categoryResp;
    } else {
      Log.v("====> ${response.body}");
      return CategoryResp();
    }
  }

  Future<JoyCategoryResponse> getjoyCategory() async {
    final response = await homeProvider.getjoyCategory();
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      JoyCategoryResponse joyCategoryResponse =
          JoyCategoryResponse.fromJson(response.body);
      Log.v('=======at category call ');
      var box = Hive.box("content");
      box.put("joy_category",
          joyCategoryResponse.data!.list!.map((e) => e.toJson()).toList());
      return joyCategoryResponse;
    } else {
      Log.v("====> ${response.body}");
      return JoyCategoryResponse();
    }
  }

  Future<CommentListResponse> getComment(int? postId) async {
    final response = await homeProvider.getComment(postId);
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      CommentListResponse commentListResponse =
          CommentListResponse.fromJson(response.body);

      return commentListResponse;
    } else {
      Log.v("====> ${response.body}");
      return CommentListResponse();
    }
  }

  Future<PostCommentResponse> postComment(
      int? postId, int? parentId, String? comment) async {
    final response = await homeProvider.postComment(postId, parentId, comment);
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      PostCommentResponse postCommentResponse =
          PostCommentResponse.fromJson(response.body);

      return postCommentResponse;
    } else {
      Log.v("====> ${response.body}");
      return PostCommentResponse();
    }
  }

  Future<JoyConentListResponse> getjoyContentList() async {
    final response = await homeProvider.getjoyContentList();
    if (response!.success) {
      Log.v("RESPONSE DATA : ${response.body}");
      JoyConentListResponse joyConentListResponse =
          JoyConentListResponse.fromJson(response.body);

      var box = Hive.box("content");
      box.put("joyContentListResponse",
          joyConentListResponse.data!.list!.map((e) => e.toJson()).toList());

      return joyConentListResponse;
    } else {
      Log.v("====> ${response.body}");
      return JoyConentListResponse();
    }
  }

  Future<onBoardSessions> getLiveClasses() async {
    final response = await homeProvider.getLiveClasses();
    if (response!.success) {
      Log.v("RESPONSE DATA : ${response.body}");
      onBoardSessions joyConentListResponse =
          onBoardSessions.fromJson(response.body);
      return joyConentListResponse;
    } else {
      Log.v("====> ${response.body}");
      return onBoardSessions();
    }
  }

  Future<ProgramListResponse> getPrograms() async {
    final response = await homeProvider.getPrograms();
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      ProgramListResponse programListResponse =
          ProgramListResponse.fromJson(response.body);
      return programListResponse;
    } else {
      Log.v("====> ${response.body}");
      return ProgramListResponse();
    }
  }

  Future<CourseCategoryListIdResponse> getCourseWithId(int? id) async {
    final response = await homeProvider.getCourseWithId(id);
    if (response!.success) {
      Log.v("SUCESS DATA : ${response.body}");
      CourseCategoryListIdResponse courseCategoryListIdResponse =
          CourseCategoryListIdResponse.fromJson(response.body);

      var box = Hive.box("content");
      box.put(
          "courseCategoryList",
          courseCategoryListIdResponse.data!.programs!
              .map((e) => e.toJson())
              .toList());
      return courseCategoryListIdResponse;
    } else {
      return CourseCategoryListIdResponse();
    }
  }

  Future<GetContentResp> getContentList({int? contentType}) async {
    final response =
        await homeProvider.getContentList(contentType: contentType);
    if (response!.success) {
      GetContentResp resp = GetContentResp.fromJson(response.body);
      var box = Hive.box("content");
      if (contentType == 16) {
        box.put(
            "announcements", resp.data!.list!.map((e) => e.toJson()).toList());
      }
      if (contentType == 18) {
        box.put("library", resp.data!.list!.map((e) => e.toJson()).toList());
      }
      if (contentType == 10) {
        box.put("benefits", resp.data!.list!.map((e) => e.toJson()).toList());
      }
      return resp;
    } else {
      Log.v("====> ${response.body}");
      return GetContentResp(
          error: response.body == null
              ? "Something went wrong:" as List<String>?
              : response.body);
    }
  }

  Future<FeaturedVideoResponse> getFeaturedVideo() async {
    final response = await homeProvider.getFeaturedVideo();
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      FeaturedVideoResponse featuredVideoResponse =
          FeaturedVideoResponse.fromJson(response.body);
      return featuredVideoResponse;
    } else {
      Log.v("====> ${response.body}");
      return FeaturedVideoResponse();
    }
  }

  Future<JoyCategoryResponse> getInterestPrograms() async {
    final response = await homeProvider.getInterestPrograms();
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      JoyCategoryResponse interestResponse =
          JoyCategoryResponse.fromJson(response.body);

      var box = Hive.box("content");
      box.put("joy_category",
          interestResponse.data!.list!.map((e) => e.toJson()).toList());
      return interestResponse;
    } else {
      Log.v("====> ${response.body}");
      return JoyCategoryResponse();
    }
  }

  Future<MapInterestResponse> mapInterest(String? param) async {
    final response = await homeProvider.mapInterest(param);
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      MapInterestResponse mapInterestResponse =
          MapInterestResponse.fromJson(response.body);
      return mapInterestResponse;
    } else {
      Log.v("====> ${response.body}");
      return MapInterestResponse();
    }
  }

  Future<popularCourses> getPopularCourses() async {
    final response = await homeProvider.getPopularCourses();
    if (response!.success) {
      popularCourses mapInterestResponse =
          popularCourses.fromJson(response.body);
      var box = Hive.box("content");
      box.put("popularCoursess",
          mapInterestResponse.data!.list!.map((e) => e.toJson()).toList());

      Log.v("ERROR DATA : ${response.body}");

      return mapInterestResponse;
    } else {
      Log.v("====> ${response.body}");
      return popularCourses();
    }
  }

  Future<BottomBarResponse> bottombarResponse() async {
    final response = await homeProvider.bottombarResponse();
    if (response!.success) {
      Log.v("List Portfoio DATA : ${response.body}");
      BottomBarResponse resp = BottomBarResponse.fromJson(response.body);

      return resp;
    } else {
      Log.v("Error ====> ${response.body}");
      return BottomBarResponse();
    }
  }

  Future<popularCourses> getFilteredPopularCourses() async {
    final response = await homeProvider.getFilteredPopularCourses();
    if (response!.success) {
      popularCourses mapInterestResponse =
          popularCourses.fromJson(response.body);
      var box = Hive.box("content");
      box.put("short_term",
          mapInterestResponse.data!.shortTerm!.map((e) => e.toJson()).toList());
      box.put(
          "recommended",
          mapInterestResponse.data!.recommended!
              .map((e) => e.toJson())
              .toList());
      box.put(
          "most_viewed",
          mapInterestResponse.data!.mostViewed!
              .map((e) => e.toJson())
              .toList());
      box.put(
          "highly_rated",
          mapInterestResponse.data!.highlyRated!
              .map((e) => e.toJson())
              .toList());
      box.put(
          "other_learners",
          mapInterestResponse.data!.otherLearners!
              .map((e) => e.toJson())
              .toList());

      Log.v("ERROR DATA : ${response.body}");

      return mapInterestResponse;
    } else {
      Log.v("====> ${response.body}");
      return popularCourses();
    }
  }

  Future<GCarvaanPostResponse> GCarvaanPost(int callCount, int? postId) async {
    final response = await homeProvider.GCarvaanPost(callCount, postId);
    if (response!.success) {
      GCarvaanPostResponse gcarvaanPost =
          GCarvaanPostResponse.fromJson(response.body);
      var box = Hive.box("content");
      box.put("gcarvaan_post",
          gcarvaanPost.data!.list!.map((e) => e.toJson()).toList());

      Log.v("ERROR DATA : ${response.body}");

      return gcarvaanPost;
    } else {
      Log.v("====> ${response.body}");
      return GCarvaanPostResponse();
    }
  }

  Future<GReelsPostResponse> GReelsPost() async {
    final response = await homeProvider.GReelsPost();
    if (response!.success) {
      GReelsPostResponse gReelsPost =
          GReelsPostResponse.fromJson(response.body);
      var box = Hive.box("content");
      box.put("greels_post",
          gReelsPost.data!.list!.map((e) => e.toJson()).toList());

      Log.v("ERROR DATA : ${response.body}");
      return gReelsPost;
    } else {
      Log.v("====> ${response.body}");
      return GReelsPostResponse();
    }
  }

  Future<CreatePostResponse> CreatePost(
      List<MultipartFile>? filePath,
      int? contentType,
      String? postType,
      String? title,
      String? description,
      List<String?>? filePaths) async {
    final response = await homeProvider.createPost(
        filePath, contentType, postType, title, description, filePaths);
    if (response!.success) {
      CreatePostResponse createPostResp =
          CreatePostResponse.fromJson(response.body);

      Log.v("ERROR DATA : ${response.body}");

      return createPostResp;
    } else {
      Log.v("====> ${response.body}");
      return CreatePostResponse();
    }
  }

  Future<LanguageResponse> getLanguage(int? languageType) async {
    final response = await homeProvider.getLanguage(languageType);
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      LanguageResponse languageResponse =
          LanguageResponse.fromJson(response.body);
      return languageResponse;
    } else {
      Log.v("====> ${response.body}");
      return LanguageResponse();
    }
  }

  Future<MasterLanguageResponse> getMasterLanguage() async {
    final response = await homeProvider.getMasterLanguage();
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      MasterLanguageResponse languageResponse =
          MasterLanguageResponse.fromJson(response.body);
      return languageResponse;
    } else {
      Log.v("====> ${response.body}");
      return MasterLanguageResponse();
    }
  }

  Future<UserAnalyticsResp> UserAnalytics() async {
    final response = await homeProvider.getUserAnalytics();
    if (response!.success) {
      Log.v("SUCCESS DATA : ${response.body}");
      UserAnalyticsResp gameResponse =
          UserAnalyticsResp.fromJson(response.body);
      return gameResponse;
    } else {
      Log.v("====> ${response.body}");
      return UserAnalyticsResp();
    }
  }

  Future<LearningSpaceResponse> learningSpace() async {
    final response = await homeProvider.getLearningSpaceData();
    if (response!.success) {
      Log.v("SUCCESS DATA : ${response.body}");
      LearningSpaceResponse resp =
          LearningSpaceResponse.fromJson(response.body);

      var box = Hive.box("content");
      box.put("learningspace",
          resp.data!.learningSpace!.map((e) => e.toJson()).toList());

      return resp;
    } else {
      Log.v("====> ${response.body}");
      return LearningSpaceResponse();
    }
  }

  Future<AttemptTestResponse?> attemptTest({required String request}) async {
    try {
      final response = await homeProvider.attemptTest(request: request);
      if (response!.success) {
        AttemptTestResponse user = AttemptTestResponse.fromJson(response.body);
        if (user.status == 1) {
          return user;
        } else {
          return AttemptTestResponse(error: [user.error?.first], status: 0);
        }
      } else {
        return AttemptTestResponse(error: ["Something went wrong"], status: 0);
      }
    } catch (e) {
      Log.v("EXCEPTION  :  $e");
    }
    return null;
  }

  Future<SaveAnswerResponse?> saveAnswer(
      {required SaveAnswerRequest request}) async {
    try {
      final response = await homeProvider.saveAnswer(request: request);
      if (response!.success) {
        SaveAnswerResponse user = SaveAnswerResponse.fromJson(response.body);
        if (user.status == 1) {
          return user;
        } else {
          return SaveAnswerResponse(status: 0);
        }
      } else {
        return SaveAnswerResponse(status: 0);
      }
    } catch (e) {
      Log.v("EXCEPTION  :  $e");
    }
    return null;
  }

  Future<SubmitAnswerResponse?> submitAnswer({String? request}) async {
    try {
      final response = await homeProvider.submitAnswer(request: request);
      if (response!.success) {
        SubmitAnswerResponse user =
            SubmitAnswerResponse.fromJson(response.body);
        if (user.status == 1) {
          return user;
        } else {
          return SubmitAnswerResponse(status: 0);
        }
      } else {
        return SubmitAnswerResponse(status: 0);
      }
    } catch (e) {
      Log.v("EXCEPTION  :  $e");
    }
    return null;
  }

  Future<TestReviewResponse?> reviewTest({required String request}) async {
    try {
      final response = await homeProvider.reviewTest(request: request);
      if (response!.success) {
        TestReviewResponse user = TestReviewResponse.fromJson(response.body);
        if (user.status == 1) {
          return user;
        } else {
          return TestReviewResponse(error: [user.error?.first], status: 0);
        }
      } else {
        return TestReviewResponse(error: ["Something went wrong"], status: 0);
      }
    } catch (e, s) {
      Log.v(s);
      Log.v("EXCEPTION  :  $e");
    }
    return null;
  }

  Future<AssignmentSubmissionResponse?> getSubmissions({int? request}) async {
    try {
      final response = await homeProvider.getSubmissions(request: request);
      if (response!.success) {
        AssignmentSubmissionResponse user =
            AssignmentSubmissionResponse.fromJson(response.body);
        if (user.status == 1) {
          return user;
        } else {
          return AssignmentSubmissionResponse(
              error: [user.error?.first], status: 0);
        }
      } else {
        return AssignmentSubmissionResponse(
            error: ["Something went wrong"], status: 0);
      }
    } catch (e, s) {
      Log.v(s);
      Log.v("EXCEPTION  :  $e");
    }
    return null;
  }


  Future createPortfolio(Map<String, dynamic> data) async {
    final response = await homeProvider.createPortfolio(data);
    if (response!.success) {
      Log.v("Create Portfoio DATA : ${response.body}");
      CreatePortfolioResponse resp =
      CreatePortfolioResponse.fromJson(response.body);

      return resp;
    } else {
      Log.v("Error ====> ${response.body}");
      return;
    }
  }

  Future deletePortfolio(int? id) async {
    final response = await homeProvider.deletePortfolio(id!);
    if (response!.success) {
      Log.v("Delete Portfoio DATA : ${response.body}");
      DeletePortfolioResponse resp =
      DeletePortfolioResponse.fromJson(response.body);

      return resp;
    } else {
      Log.v("Error ====> ${response.body}");
      return;
    }
  }

  Future<ListPortfolioResponse> listPortfolio(String? type, int? userId) async {
    final response = await homeProvider.listPortfolio(type!, userId!);
    if (response!.success) {
      Log.v("List Portfoio DATA : ${response.body}");
      ListPortfolioResponse resp =
      ListPortfolioResponse.fromJson(response.body);

      return resp;
    } else {
      Log.v("Error ====> ${response.body}");
      return ListPortfolioResponse();
    }
  }

}
