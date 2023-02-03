import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'package:masterg/data/models/request/home_request/poll_submit_req.dart';
import 'package:masterg/data/models/request/home_request/submit_feedback_req.dart';
import 'package:masterg/data/models/request/home_request/submit_survey_req.dart';
import 'package:masterg/data/models/request/home_request/track_announcement_request.dart';
import 'package:masterg/data/models/request/home_request/user_program_subscribe.dart';
import 'package:masterg/data/models/request/save_answer_request.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/general_resp.dart';
import 'package:masterg/data/models/response/home_response/add_portfolio_resp.dart';
import 'package:masterg/data/models/response/home_response/assignment_submissions_response.dart';
import 'package:masterg/data/models/response/home_response/category_response.dart';
import 'package:masterg/data/models/response/home_response/competition_content_list_resp.dart';
import 'package:masterg/data/models/response/home_response/competition_response.dart';
import 'package:masterg/data/models/response/home_response/content_tags_resp.dart';
import 'package:masterg/data/models/response/home_response/course_category_list_id_response.dart';
import 'package:masterg/data/models/response/home_response/create_post_response.dart';
import 'package:masterg/data/models/response/home_response/delete_post_response.dart';
import 'package:masterg/data/models/response/home_response/featured_video_response.dart';
import 'package:masterg/data/models/response/home_response/feedback_response.dart';
import 'package:masterg/data/models/response/home_response/gcarvaan_post_reponse.dart';
import 'package:masterg/data/models/response/home_response/get_certificates_resp.dart';
import 'package:masterg/data/models/response/home_response/get_comment_response.dart';
import 'package:masterg/data/models/response/home_response/get_content_resp.dart';
import 'package:masterg/data/models/response/home_response/get_course_leaderboard_resp.dart';
import 'package:masterg/data/models/response/home_response/get_course_modules_resp.dart';
import 'package:masterg/data/models/response/home_response/get_courses_resp.dart';
import 'package:masterg/data/models/response/home_response/get_kpi_analysis_resp.dart';
import 'package:masterg/data/models/response/home_response/get_module_leaderboard_resp.dart';
import 'package:masterg/data/models/response/home_response/greels_response.dart';
import 'package:masterg/data/models/response/home_response/joy_category_response.dart';
import 'package:masterg/data/models/response/home_response/joy_contentList_response.dart';
import 'package:masterg/data/models/response/home_response/language_response.dart';
import 'package:masterg/data/models/response/home_response/learning_space_response.dart';
import 'package:masterg/data/models/response/home_response/map_interest_response.dart';
import 'package:masterg/data/models/response/home_response/master_language_response.dart';
import 'package:masterg/data/models/response/home_response/my_assessment_response.dart';
import 'package:masterg/data/models/response/home_response/my_assignment_response.dart';
import 'package:masterg/data/models/response/home_response/new_portfolio_response.dart';
import 'package:masterg/data/models/response/home_response/notification_resp.dart';
import 'package:masterg/data/models/response/home_response/onboard_sessions.dart';
import 'package:masterg/data/models/response/home_response/popular_courses_response.dart';
import 'package:masterg/data/models/response/home_response/post_comment_response.dart';
import 'package:masterg/data/models/response/home_response/program_list_reponse.dart';
import 'package:masterg/data/models/response/home_response/report_content_response.dart';
import 'package:masterg/data/models/response/home_response/save_answer_response.dart';
import 'package:masterg/data/models/response/home_response/singularis_portfolio_deleteResp.dart';
import 'package:masterg/data/models/response/home_response/submit_answer_response.dart';
import 'package:masterg/data/models/response/home_response/submit_feedback_resp.dart';
import 'package:masterg/data/models/response/home_response/survey_data_resp.dart';
import 'package:masterg/data/models/response/home_response/test_attempt_response.dart';
import 'package:masterg/data/models/response/home_response/test_review_response.dart';
import 'package:masterg/data/models/response/home_response/topics_resp.dart';
import 'package:masterg/data/models/response/home_response/training_detail_response.dart';
import 'package:masterg/data/models/response/home_response/training_module_response.dart';
import 'package:masterg/data/models/response/home_response/update_user_profile_response.dart';
import 'package:masterg/data/models/response/home_response/user_analytics_response.dart';
import 'package:masterg/data/models/response/home_response/user_info_response.dart';
import 'package:masterg/data/models/response/home_response/user_jobs_list_response.dart';
import 'package:masterg/data/models/response/home_response/user_profile_response.dart';
import 'package:masterg/data/models/response/home_response/user_program_subscribe_reponse.dart';
import 'package:masterg/data/providers/home_provider.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/user_profile_page/model/MasterBrand.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_education.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_experience.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/response/auth_response/dashboard_content_resp.dart';
import '../models/response/auth_response/dashboard_view_resp.dart';
import '../models/response/home_response/create_portfolio_response.dart';
import '../models/response/home_response/delete_portfolio_response.dart';
import '../models/response/home_response/leaderboard_resp.dart';
import '../models/response/home_response/list_portfolio_responsed.dart';
import '../models/response/home_response/remove_account_resp.dart';

class HomeRepository {
  HomeRepository({required this.homeProvider});

  final HomeProvider homeProvider;

  void saveUserInfo(UserInfoResponse user) {
    if (user == null) return;

    UserData? userData = user.data?.userData;
    Preference.setInt(Preference.USER_ID, userData!.id!);
    UserSession.userId = userData.id;

    Preference.setInt(Preference.USER_COINS, userData.totalCoins!);
    UserSession.userCoins = userData.totalCoins;

    Preference.setString(Preference.USER_EMAIL, userData.email!);
    UserSession.email = userData.email;

    Preference.setString(Preference.DESIGNATION, userData.designation!);
    UserSession.designation = userData.designation;

    Preference.setString(Preference.USERNAME, userData.name!);
    UserSession.userName = userData.name;

    Preference.setString(Preference.PHONE, userData.mobileNo!);
    UserSession.phone = userData.mobileNo;

    Preference.setString(Preference.PROFILE_IMAGE, userData.profileImage!);
    UserSession.userImageUrl = userData.profileImage;

    Preference.setString(Preference.GENDER, userData.gender!);
    UserSession.gender = userData.gender;

    UserSession.userData = json.encode(userData.toJson()).toString();
    Preference.setString(Preference.USER_DATA, UserSession.userData!);
  }

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

  Future<UserProgramSubscribeRes> subscribeProgram(
      UserProgramSubscribeReq req) async {
    final response = await homeProvider.UserSubscribe(subrReq: req);
    if (response!.success) {
      Log.v("User Program Subscribe DATA : ${response.body}");
      UserProgramSubscribeRes resp =
          UserProgramSubscribeRes.fromJson(response.body);

      return resp;
    } else {
      return UserProgramSubscribeRes();
    }
  }

  Future<UserInfoResponse> getSwayamUserProfile() async {
    final response = await homeProvider.getSwayamUserProfile();
    if (response!.success) {
      Log.v("Profile DATA : ${response.body}");
      UserInfoResponse resp = UserInfoResponse.fromJson(response.body);
      Log.v("Sucess DATA : ${resp.toJson()}");
      saveUserInfo(resp);
      return resp;
    } else {
      Log.v("====> ${response.body}");
      return UserInfoResponse();
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
      String? filePath, String? name, String? email) async {
    final response =
        await homeProvider.updateUserProfileImage(filePath, name, email);
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

  Future<ReportContentResp> reportContent(
      String? status, int? contentId, String? category, String? comment) async {
    final response =
        await homeProvider.reportContent(status, contentId, category, comment);
    if (response!.success) {
      Log.v("Report content DATA : ${response.body}");
      ReportContentResp resp = ReportContentResp.fromJson(response.body);

      return resp;
    } else {
      Log.v("====> ${response.body}");
      return ReportContentResp(status: 0, message: 'error');
    }
  }

  Future<DeletePostResponse?> deletePost(int? postId) async {
    final response = await homeProvider.deletePost(postId);
    if (response!.success) {
      Log.v("Delete Post DATA : ${response.body}");
      DeletePostResponse resp = DeletePostResponse.fromJson(response.body);

      return resp;
    } else {
      Log.v("====> ${response.body}");
      return DeletePostResponse(status: 0, message: 'error');
    }
  }

  Future<GetCoursesResp?> getCoursesList({int? type}) async {
    final response = await homeProvider.getCoursesList(type: type!);
    var box = Hive.box("analytics");
    if (response!.success) {
      Log.v("SUCCESS DATA : ${response.body}");
      GetCoursesResp gameResponse = GetCoursesResp.fromJson(response.body);
      if (type == 0) {
        box.put("myAnalytics",
            gameResponse.data?.list?.map((e) => e.toJson()).toList());
      }
      if (type == 1) {
        box.put("teamAnalytics",
            gameResponse.data?.list?.map((e) => e.toJson()).toList());
      }
      return gameResponse;
    } else {
      if (type == 0) {
        box.put("myAnalytics", []);
      }
      if (type == 1) {
        box.put("teamAnalytics", []);
      }
      Log.v("====> ${response.body}");
      return GetCoursesResp();
    }
  }

  Future<SubmitFeedbackResp> submitFeedback({FeedbackReq? feedbackReq}) async {
    print(feedbackReq);
    final response = await homeProvider.submitFeedback(req: feedbackReq);
    if (response!.success) {
      Log.v("ERROR DATA1 : ${json.encode(response.body)}");
      SubmitFeedbackResp resp = SubmitFeedbackResp.fromJson(response.body);
      return resp;
    } else {
      Log.v("====> ${response.body}");
      return SubmitFeedbackResp(
          message:
              response.body == null ? "Something went wrong:" : response.body);
    }
  }

  Future<TopicsResp> getTopicsList() async {
    final response = await homeProvider.getTopicsList();
    if (response!.success) {
      Log.v("ERROR DATA : ${json.encode(response.body)}");
      TopicsResp resp = TopicsResp.fromJson(response.body);
      return resp;
    } else {
      Log.v("====> ${response.body}");
      return TopicsResp(
          error:
              response.body == null ? "Something went wrong:" : response.body);
    }
  }

  Future<FeedbackResp?> getFeedbackList({int? categoryType}) async {
    final response = await homeProvider.getFeedbackList();
    if (response!.success) {
      Log.v("ERROR DATA : ${json.encode(response.body)}");
      FeedbackResp resp = FeedbackResp.fromJson(response.body);
      var box = Hive.box(DB.CONTENT);
      box.put("ideas", resp.data?.list?.map((e) => e.toJson()).toList());

      return resp;
    } else {
      Log.v("====> ${response.body}");
      return FeedbackResp(
          error:
              response.body == null ? "Something went wrong:" : response.body);
    }
  }

  Future<GetKpiAnalysisResp?> getKPIAnalysisList() async {
    final response = await homeProvider.getKPIAnalysisList();
    var box = Hive.box("analytics");
    if (response!.success) {
      Log.v("SUCCESS DATA : ${response.body}");
      GetKpiAnalysisResp gameResponse =
          GetKpiAnalysisResp.fromJson(response.body);

      box.put("kpiData",
          gameResponse.data?.kpiData?.map((e) => e.toJson()).toList());
      return gameResponse;
    } else {
      box.put("kpiData", []);
      Log.v("====> ${response.body}");
      return GetKpiAnalysisResp();
    }
  }

  Future<GetCertificatesResp?> getCertificatesList() async {
    final response = await homeProvider.getCertificatesList();
    if (response!.success) {
      Log.v("SUCCESS DATA : ${response.body}");
      GetCertificatesResp gameResponse =
          GetCertificatesResp.fromJson(response.body);
      Box box = Hive.box(DB.ANALYTICS);
      box.put(
          "certificates",
          gameResponse.data?.kpiCertificatesData
              ?.map((e) => e.toJson())
              .toList());
      return gameResponse;
    } else {
      Log.v("====> ${response.body}");
      return GetCertificatesResp();
    }
  }

  Future<ContentTagsResp?> getContentTagsList({int? categoryType}) async {
    final response =
        await homeProvider.getContentTagsList(categoryType: categoryType);
    if (response!.success) {
      Log.v("ERROR DATA : ${json.encode(response.body)}");
      ContentTagsResp resp = ContentTagsResp.fromJson(response.body);
      var box = Hive.box("content");
      if (categoryType == 8) {
        box.put("announcementFilters",
            resp.data?.listTags?.map((e) => e.toJson()).toList());
      }
      if (categoryType == 9) {
        box.put("libraryFilters",
            resp.data?.listTags?.map((e) => e.toJson()).toList());
      }
      return resp;
    } else {
      Log.v("====> ${response.body}");
      return ContentTagsResp(
          error:
              response.body == null ? "Something went wrong:" : response.body);
    }
  }

  Future<GetModuleLeaderboardResp?> getModuleLeaderboardList(String moduleId,
      {int type = 0}) async {
    final response =
        await homeProvider.getModuleLeaderboardList(moduleId, type: type);
    if (response!.success) {
      Log.v("SUCCESS DATA 2: ${response.body}");
      GetModuleLeaderboardResp gameResponse =
          GetModuleLeaderboardResp.fromJson(response.body);
      var box = Hive.box("analytics");
      if (type == 0) {
        box.put(moduleId + AnalyticsType.MODULE_LEADERBOARD_TYPE_1,
            gameResponse.data?.list?.map((e) => e.toJson()).toList());
      }
      if (type == 1) {
        box.put(moduleId + AnalyticsType.MODULE_LEADERBOARD_TYPE_2,
            gameResponse.data?.list?.map((e) => e.toJson()).toList());
      }
      return gameResponse;
    } else {
      Log.v("====> ${response.body}");
      return GetModuleLeaderboardResp();
    }
  }

  Future<GetCourseLeaderboardResp?> getCourseLeaderboardList(String courseId,
      {int type = 0}) async {
    final response =
        await homeProvider.getCourseLeaderboardList(courseId, type: type);
    if (response!.success) {
      Log.v("SUCCESS DATA LEADER: ${response.body}");
      GetCourseLeaderboardResp gameResponse =
          GetCourseLeaderboardResp.fromJson(response.body);
      var box = Hive.box("analytics");
      if (type == 0) {
        box.put(courseId + AnalyticsType.COURSE_LEADERBOARD_TYPE_1,
            gameResponse.data?.list?.map((e) => e.toJson()).toList());
      }
      if (type == 1) {
        box.put(courseId + AnalyticsType.COURSE_LEADERBOARD_TYPE_2,
            gameResponse.data?.list?.map((e) => e.toJson()).toList());
      }
      return gameResponse;
    } else {
      Log.v("====> ${response.body}");
      return GetCourseLeaderboardResp();
    }
  }

  Future<GetCourseModulesResp?> getCourseModulesList(String courseId,
      {int type = 0}) async {
    try {
      final response =
          await homeProvider.getCourseModulesList(courseId, type: 0);
      if (response!.success) {
        Log.v("SUCCESS DATA MOD : ${response.body}");
        GetCourseModulesResp gameResponse =
            GetCourseModulesResp.fromJson(response.body);
        var box = Hive.box("analytics");
        if (type == 0) {
          box.put(
              courseId + AnalyticsType.MODULE_TYPE_1,
              gameResponse.data?.list?.first.modules
                  ?.map((e) => e.toJson())
                  .toList());
        }
        if (type == 1) {
          box.put(
              courseId + AnalyticsType.MODULE_TYPE_2,
              gameResponse.data?.list?.first.modules
                  ?.map((e) => e.toJson())
                  .toList());
        }
        return gameResponse;
      } else {
        Log.v("====> ${response.body}");
        return GetCourseModulesResp();
      }
    } on Exception catch (e, stacktrace) {
      print(stacktrace);
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

  //job
  Future<UserJobsListResponse> getUserJobList() async {
    final response = await homeProvider.getJobList();
    if (response!.success) {
      Log.v("Job List DATA : ${response.body}");
      UserJobsListResponse userJobsListResponse =
          UserJobsListResponse.fromJson(response.body);
      var box = Hive.box("content");
      box.put("userJobList",
          userJobsListResponse.list!.map((e) => e.toJson()).toList());
      return userJobsListResponse;
    } else {
      Log.v("====> ${response.body}");
      return UserJobsListResponse();
    }
  }

  Future<TrainingModuleResponse> getCompetitionDetail(int? moduleId) async {
    final response =
        await homeProvider.getCompetitionDetail(moduleId: moduleId);
    if (response!.success) {
      Log.v("Competition  DATA : ${response.body}");
      TrainingModuleResponse competitionData =
          TrainingModuleResponse.fromJson(response.body);

      var box = Hive.box("content");
      box.put("competitionDetail",
          competitionData.data?.module?.map((e) => e.toJson()).toList());
      return competitionData;
    } else {
      Log.v("====> ${response.body}");
      return TrainingModuleResponse();
    }
  }

  Future<CompetitionResponse> getCompetitionList(bool? isPopular) async {
    final response =
        await homeProvider.getCompetitionList(isPopular: isPopular);
    if (response!.success) {
      Log.v("Competition List  DATA : ${response.body}");
      CompetitionResponse competitionData =
          CompetitionResponse.fromJson(response.body);
      return competitionData;
    } else {
      Log.v("====> ${response.body}");
      return CompetitionResponse();
    }
  }

  Future<CompetitionContentListResponse> getCompetitionContentList(
      int? competitionId) async {
    final response = await homeProvider.getCompetitionContentList(
        competitionId: competitionId);
    if (response!.success) {
      Log.v("Competition Content List  DATA : ${response.body}");
      CompetitionContentListResponse competitionData =
          CompetitionContentListResponse.fromJson(response.body);
      return competitionData;
    } else {
      Log.v("====> ${response.body}");
      return CompetitionContentListResponse.fromJson(response.body);
    }
  }

  Future<AddPortfolioResp> addProfessional({Map<String, dynamic>? data}) async {
    final response = await homeProvider.addProfessional(data: data);
    if (response!.success) {
      Log.v("Add Professional Content  DATA : ${response.body}");
      AddPortfolioResp addProfessionalData =
          AddPortfolioResp.fromJson(response.body);
      return addProfessionalData;
    } else {
      Log.v("====> ${response.body}");
      return AddPortfolioResp.fromJson(response.body);
    }
  }

 

  Future<PortfolioResponse?> getPortfolio() async {
    final response = await homeProvider.getPortfolio();

    if (response!.success) {
      Log.v("Portfolio Content  DATA : ${response.body}");
      PortfolioResponse portfolioResponse =
          PortfolioResponse.fromJson(response.body);
      return portfolioResponse;
    } else {
      Log.v("====> ${response.body}");
      return PortfolioResponse.fromJson(response.body);
    }
  }
  Future<AddPortfolioResp?> uploadProfile({Map<String, dynamic>? data}) async {
    final response = await homeProvider.uploadProfile( data!);

    if (response!.success) {
      Log.v("Portfolio Content  DATA : ${response.body}");
      AddPortfolioResp portfolioResponse =
          AddPortfolioResp.fromJson(response.body);
      return portfolioResponse;
    } else {
      Log.v("====> ${response.body}");
      return AddPortfolioResp.fromJson(response.body);
    }
  }



  Future<AddPortfolioResp> addPortfolio({Map<String, dynamic>? data}) async {
    final response = await homeProvider.addPortfolio(data: data);
    if (response!.success) {
      Log.v("Add Portfolio Content  DATA : ${response.body}");
      AddPortfolioResp competitionData =
          AddPortfolioResp.fromJson(response.body);
      return competitionData;
    } else {
      Log.v("====> ${response.body}");
      return AddPortfolioResp.fromJson(response.body);
    }
  }
  Future<AddPortfolioResp> addPortfolioProfile({Map<String, dynamic>? data}) async {
    final response = await homeProvider.addPortfolioProfile(data: data);
    if (response!.success) {
      Log.v("Add Portfolio Profile DATA : ${response.body}");
      AddPortfolioResp competitionData =
          AddPortfolioResp.fromJson(response.body);
      return competitionData;
    } else {
      Log.v("====> ${response.body}");
      return AddPortfolioResp.fromJson(response.body);
    }
  }


 Future<AddPortfolioResp> addResume({Map<String, dynamic>? data}) async {
    final response = await homeProvider.addResume(data!);
    if (response!.success) {
      Log.v("Add Portfolio Resume DATA : ${response.body}");
      AddPortfolioResp competitionData =
          AddPortfolioResp.fromJson(response.body);
      return competitionData;
    } else {
      Log.v("====> ${response.body}");
      return AddPortfolioResp.fromJson(response.body);
    }
  }

   Future<SingularisPortfolioDelete> singularisPortfolioDelete(int portfolioId) async {
    final response = await homeProvider.singularisDeletePortfolio(portfolioId);
    if (response!.success) {
      Log.v("Delete Portfolio Content  DATA : ${response.body}");
      SingularisPortfolioDelete competitionData =
          SingularisPortfolioDelete.fromJson(response.body);
      return competitionData;
    } else {
      Log.v("====> ${response.body}");
      return SingularisPortfolioDelete.fromJson(response.body);
    }
  } 

  //leaderboard
  Future<LeaderboardResponse> getLeaderboard(
      int? id, String? type, int? skipotherUser, int? skipcurrentUser) async {
    final response = await homeProvider.getLeaderboard(
        id: id,
        type: type,
        skipcurrentUser: skipcurrentUser,
        skipotherUser: skipotherUser);
    if (response!.success) {
      Log.v("Competition Content List  DATA : ${response.body}");
      LeaderboardResponse competitionData =
          LeaderboardResponse.fromJson(response.body);
      return competitionData;
    } else {
      Log.v("====> ${response.body}");
      return LeaderboardResponse.fromJson(response.body);
    }
  }

  Future<TrainingDetailResponse> getTrainingDetail(int? programId) async {
    final response = await homeProvider.getTrainingDetail(programId);
    if (response!.success) {
      Log.v("Training Detail  DATA : ${response.body}");
      TrainingDetailResponse competitionData =
          TrainingDetailResponse.fromJson(response.body);

      var box = Hive.box("content");
      // box.put("competitionDetail",
      //     competitionData.data?.module?.map((e) => e.toJson()).toList());
      return competitionData;
    } else {
      Log.v("====> ${response.body}");
      return TrainingDetailResponse();
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
          joyConentListResponse.data!.list?.map((e) => e.toJson()).toList());

      return joyConentListResponse;
    } else {
      Log.v("====> ${response.body}");
      return JoyConentListResponse();
    }
  }

  Future<DashboardViewResponse> getDashboardIsVisible() async {
    final response = await homeProvider.getDashboardIsVisible();
    if (response!.success) {
      Log.v("RESPONSE DATA : ${response.body}");
      DashboardViewResponse dashboardViewResponse =
          DashboardViewResponse.fromJson(response.body);
      var box = Hive.box(DB.CONTENT);
      try {
        // box.put("getDashboardIsVisible", dashboardViewResponse.toJson());

        box.put("getDashboardIsVisible", dashboardViewResponse.data?.toJson());
        print('something went w inserted');
      } catch (e) {
        print('something went wrong while inserting data');
      }
      return dashboardViewResponse;
    } else {
      Log.v("====> ${response.body}");
      return DashboardViewResponse();
    }
  }

  Future<DashboardContentResponse> getDasboardList() async {
    final response = await homeProvider.getDasboardList();
    if (response!.success) {
      Log.v("RESPONSE DATA : ${response.body}");
      DashboardContentResponse dashboardViewResponse =
          DashboardContentResponse.fromJson(response.body);
      var box = Hive.box(DB.CONTENT);
      box.put(
          "dashboard_recommended_courses_limit",
          dashboardViewResponse.data?.dashboardRecommendedCoursesLimit
              ?.map((e) => e.toJson())
              .toList());

      box.put(
          'dashboard_reels_limit',
          dashboardViewResponse.data?.dashboardReelsLimit
              ?.map((e) => e.toJson())
              .toList());
      box.put(
          'dashboard_carvan_limit',
          dashboardViewResponse.data?.dashboardCarvanLimit
              ?.map((e) => e.toJson())
              .toList());
      box.put(
          'dashboard_featured_content_limit',
          dashboardViewResponse.data?.dashboardFeaturedContentLimit
              ?.map((e) => e.toJson())
              .toList());
      box.put(
          'dashboard_my_courses_limit',
          dashboardViewResponse.data?.dashboardMyCoursesLimit
              ?.map((e) => e.toJson())
              .toList());
      box.put(
          'dashboard_sessions_limit',
          dashboardViewResponse.data?.dashboardSessionsLimit
              ?.map((e) => e.toJson())
              .toList());

      // box.put("getDasboardList",
      //     dashboardViewResponse.data?.map((e) => e.toJson()).toList());

      return dashboardViewResponse;
    } else {
      Log.v("====> ${response.body}");
      return DashboardContentResponse();
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

      Log.v("ERROR DATA popularCoursess: ${response.body}");

      return mapInterestResponse;
    } else {
      Log.v("====> ${response.body}");
      return popularCourses();
    }
  }

  Future<BottomBarResponse> bottombarResponse() async {
    final response = await homeProvider.bottombarResponse();
    if (response!.success) {
      Log.v("Bttom Menu DATA : ${response.body}");
      BottomBarResponse resp = BottomBarResponse.fromJson(response.body);
      var box = Hive.box("content");
      box.put("bottomMenu", resp.data?.menu?.map((e) => e.toJson()).toList());

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

      Log.v("CARVAAN DATA : ${response.body}");

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

  Future masterBrandCreate(Map<String, dynamic> data) async {
    final response = await homeProvider.masterBrandCreate(data);
    if (response!.success) {
      Log.v("Create Portfoio DATA : ${response.body}");
      MasterBrandResponse respBr = MasterBrandResponse.fromJson(response.body);

      Log.v("Create Portfoio DATA : ${respBr.status}");
      if (respBr.status == 1) {
        return respBr;
      }
    } else {
      Log.v("Error ====> ${response.body}");
      return;
    }
  }

  Future userBrandCreate(Map<String, dynamic> data) async {
    final response = await homeProvider.userBrandCreate(data);
    if (response!.success) {
      Log.v("Create Portfoio DATA : ${response.body}");
      /*MasterBrandResponse resp =
      MasterBrandResponse.fromJson(response.body);*/
      return response.body;
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

  Future updateVideoCompletion(int bookmark, int contentId) async {
    final response =
        await homeProvider.updateVideoCompletion(bookmark, contentId);
    if (response!.success) {
      Log.v("Sucess DATA : ${response.body}");
    } else {
      Log.v("====> ${response.body}");
      return;
    }
  }

  Future<GeneralResp?> trackAnnouncment(
      {TrackAnnouncementReq? trackAnnouncementReq}) async {
    final response = await homeProvider.trackAnnouncment(
        submitRewardReq: trackAnnouncementReq!);
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      GeneralResp resp = GeneralResp.fromJson(response.body);
      Log.v("ERROR DATA : ${resp.toJson()}");
      return resp;
    } else {
      Log.v("====> ${response.body}");
      return GeneralResp();
    }
  }

  Future<GeneralResp?> activityAttempt(
      {String? filePath, int? contentType, int? contentId}) async {
    final response =
        await homeProvider.activityAttempt(filePath, contentType, contentId);
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      GeneralResp resp = GeneralResp.fromJson(response.body);
      Log.v("ERROR DATA : ${resp.toJson()}");
      return resp;
    } else {
      Log.v("====> ${response.body}");
      return GeneralResp();
    }
  }

  Future<SurveyDataResp?> getSurveyDataList({int? contentId, int? type}) async {
    try {
      final response = await homeProvider.getSurveyDataList(
          contentId: contentId, type: type);
      if (response!.success) {
        Log.v("ERROR DATA : ${json.encode(response.body)}");
        SurveyDataResp resp = SurveyDataResp.fromJson(response.body, type!);
        return resp;
      } else {
        Log.v("====> ${response.body}");
        return SurveyDataResp(
            error: response.body == null
                ? "Something went wrong:"
                : response.body);
      }
    } on Exception catch (e, s) {
      print(s);
    }
  }

  Future<GeneralResp> submitSurvey({SubmitSurveyReq? submitSurveyReq}) async {
    final response = await homeProvider.submitSurvey(req: submitSurveyReq);
    if (response!.success) {
      Log.v("ERROR DATA : ${json.encode(response.body)}");
      GeneralResp resp = GeneralResp.fromJson(response.body);
      return resp;
    } else {
      Log.v("====> ${response.body}");
      return GeneralResp(
          message:
              response.body == null ? "Something went wrong:" : response.body);
    }
  }

  Future<RemoveAccountResponse> removeAccount({String? type}) async {
    final response = await homeProvider.removeAccount(type: type);
    if (response!.success) {
      Log.v("DATA : ${json.encode(response.body)}");
      RemoveAccountResponse resp =
          RemoveAccountResponse.fromJson(response.body);
      return resp;
    } else {
      Log.v("====> ${response.body}");
      return RemoveAccountResponse.fromJson(response.body);
    }
  }

  Future<NotificationResp?> getNotifications() async {
    final response = await homeProvider.getNotifications();
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      NotificationResp notificationResp =
          NotificationResp.fromJson(response.body);
      return notificationResp;
    } else {
      Log.v("====> ${response.body}");
      return NotificationResp();
    }
  }

  Future<GeneralResp?> submitPoll({PollSubmitRequest? submitSurveyReq}) async {
    final response = await homeProvider.submitPoll(req: submitSurveyReq);
    if (response!.success) {
      Log.v("ERROR DATA : ${json.encode(response.body)}");
      GeneralResp resp = GeneralResp.fromJson(response.body);
      return resp;
    } else {
      Log.v("====> ${response.body}");
      return GeneralResp(
          message:
              response.body == null ? "Something went wrong:" : response.body);
    }
  }
}
