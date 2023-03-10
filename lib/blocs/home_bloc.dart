import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:injector/injector.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/home_request/get_course_modules_request.dart';
import 'package:masterg/data/models/request/home_request/poll_submit_req.dart';
import 'package:masterg/data/models/request/home_request/submit_feedback_req.dart';
import 'package:masterg/data/models/request/home_request/submit_survey_req.dart';
import 'package:masterg/data/models/request/home_request/track_announcement_request.dart';
import 'package:masterg/data/models/request/home_request/user_program_subscribe.dart';
import 'package:masterg/data/models/request/home_request/user_tracking_activity.dart';
import 'package:masterg/data/models/request/save_answer_request.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/auth_response/competition_my_activity.dart';
import 'package:masterg/data/models/response/auth_response/dashboard_content_resp.dart';
import 'package:masterg/data/models/response/auth_response/dashboard_view_resp.dart';
import 'package:masterg/data/models/response/general_resp.dart';
import 'package:masterg/data/models/response/home_response/add_portfolio_resp.dart';
import 'package:masterg/data/models/response/home_response/assignment_submissions_response.dart';
import 'package:masterg/data/models/response/home_response/competition_content_list_resp.dart';
import 'package:masterg/data/models/response/home_response/competition_response.dart';
import 'package:masterg/data/models/response/home_response/content_tags_resp.dart';
import 'package:masterg/data/models/response/home_response/course_category_list_id_response.dart';
import 'package:masterg/data/models/response/home_response/create_post_response.dart';
import 'package:masterg/data/models/response/home_response/delete_post_response.dart';
import 'package:masterg/data/models/response/home_response/domain_filter_list.dart';
import 'package:masterg/data/models/response/home_response/domain_list_response.dart';
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
import 'package:masterg/data/models/response/home_response/job_domain_detail_resp.dart';
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
import 'package:masterg/data/models/response/home_response/portfolio_competition_response.dart';
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
import 'package:masterg/data/models/response/home_response/top_score.dart';
import 'package:masterg/data/models/response/home_response/topics_resp.dart';
import 'package:masterg/data/models/response/home_response/training_detail_response.dart';
import 'package:masterg/data/models/response/home_response/training_module_response.dart';
import 'package:masterg/data/models/response/home_response/update_user_profile_response.dart';
import 'package:masterg/data/models/response/home_response/user_analytics_response.dart';
import 'package:masterg/data/models/response/home_response/user_jobs_list_response.dart';
import 'package:masterg/data/models/response/home_response/user_profile_response.dart';
import 'package:masterg/data/models/response/home_response/user_program_subscribe_reponse.dart';
import 'package:masterg/data/models/response/home_response/zoom_open_url_response.dart';
import 'package:masterg/data/repositories/home_repository.dart';
import 'package:masterg/pages/user_profile_page/model/MasterBrand.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';

import '../data/models/response/home_response/create_portfolio_response.dart';
import '../data/models/response/home_response/delete_portfolio_response.dart';
import '../data/models/response/home_response/leaderboard_resp.dart';
import '../data/models/response/home_response/list_portfolio_responsed.dart';
import '../data/models/response/home_response/remove_account_resp.dart';
import '../data/models/response/home_response/top_scroing_user_response.dart';

abstract class HomeEvent {
  HomeEvent([List event = const []]) : super();
}

class LearningSpaceEvent extends HomeEvent {
  Box? box;

  LearningSpaceEvent({this.box}) : super([]);

  List<Object> get props => throw UnimplementedError();
}

class MyAssessmentEvent extends HomeEvent {
  Box? box;

  MyAssessmentEvent({this.box}) : super([]);

  List<Object> get props => throw UnimplementedError();
}

class MyAssignmentEvent extends HomeEvent {
  Box? box;

  MyAssignmentEvent({this.box}) : super([]);

  List<Object> get props => throw UnimplementedError();
}

class UserAnalyticsEvent extends HomeEvent {
  UserAnalyticsEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class LanguageEvent extends HomeEvent {
  int? languageType;

  LanguageEvent({this.languageType}) : super([languageType]);

  List<Object> get props => throw UnimplementedError();
}

class MasterLanguageEvent extends HomeEvent {
  MasterLanguageEvent() : super();

  List<Object> get props => throw UnimplementedError();
}

class UserProgramSubscribeEvent extends HomeEvent {
  UserProgramSubscribeReq? subrReq;

  UserProgramSubscribeEvent({this.subrReq}) : super([subrReq]);

  List<Object> get props => throw UnimplementedError();
}

abstract class HomeState {
  HomeState([List states = const []]) : super();

  List<Object> get props => [];
}

class UserProgramSubscribeState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  UserProgramSubscribeRes? response;
  String? error;

  UserProgramSubscribeState(this.state, {this.response, this.error});
}

class MyAssessmentState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  MyAssessmentResponse? response;
  String? error;

  MyAssessmentState(this.state, {this.response, this.error});
}

class MyAssignmentState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  MyAssignmentResponse? response;
  String? error;

  MyAssignmentState(this.state, {this.response, this.error});
}

class LearningSpaceState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  LearningSpaceResponse? response;
  String? error;

  LearningSpaceState(this.state, {this.response, this.error});
}

class LanguageState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  LanguageResponse? response;
  String? error;

  LanguageState(this.state, {this.response, this.error});
}

class MasterLanguageState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  MasterLanguageResponse? response;
  String? error;

  MasterLanguageState(this.state, {this.response, this.error});
}

class AttemptTestState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  AttemptTestResponse? response;
  String? error;

  AttemptTestState(this.state, {this.response, this.error});
}

class AttemptTestEvent extends HomeEvent {
  String? request;

  AttemptTestEvent({this.request}) : super([request]);

  List<Object> get props => throw UnimplementedError();
}

class SaveAnswerState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  SaveAnswerResponse? response;
  String? error;

  SaveAnswerState(this.state, {this.response, this.error});
}

class SaveAnswerEvent extends HomeEvent {
  SaveAnswerRequest? request;

  SaveAnswerEvent({this.request}) : super([request]);

  List<Object> get props => throw UnimplementedError();
}

class SubmitAnswerState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  SubmitAnswerResponse? response;
  String? error;

  SubmitAnswerState(this.state, {this.response, this.error});
}

//Email Code Send
class EmailCodeSendState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  String? email;
  String? error;

  EmailCodeSendState(this.state, {this.error, this.email});
}

class VerifyEmailCodeState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  String? email;
  String? code;
  String? error;

  VerifyEmailCodeState(this.state, {this.error, this.email, this.code});
}

class PasswordUpdateState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  String? email;
  String? pass;
  String? error;

  PasswordUpdateState(this.state, {this.error, this.email, this.pass});
}


class EmailCodeSendEvent extends HomeEvent {
  String? email;
  int? isSignup;
  int? forgotPass;

  EmailCodeSendEvent({this.email, this.isSignup, this.forgotPass}) : super([email, isSignup, forgotPass]);

  List<Object> get props => throw UnimplementedError();
}

class VerifyEmailCodeEvent extends HomeEvent {
  String? email;
  String? code;

  VerifyEmailCodeEvent({this.email, this.code}) : super([email, code]);

  List<Object> get props => throw UnimplementedError();

}

class PasswordUpdateEvent extends HomeEvent {
  String? email;
  String? pass;

  PasswordUpdateEvent({this.email, this.pass}) : super([email, pass]);

  List<Object> get props => throw UnimplementedError();

}

///-------------


class SubmitAnswerEvent extends HomeEvent {
  String? request;

  SubmitAnswerEvent({this.request}) : super([request]);

  List<Object> get props => throw UnimplementedError();
}

class ReviewTestState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  TestReviewResponse? response;
  String? error;

  ReviewTestState(this.state, {this.response, this.error});
}

class UserJobListState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  UserJobsListResponse? response;
  String? error;

  UserJobListState(this.state, {this.response, this.error});
}

class CompetitionDetailState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  TrainingModuleResponse? response;
  String? error;

  CompetitionDetailState(this.state, {this.response, this.error});
}

class TrainingDetailState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  TrainingDetailResponse? response;
  String? error;

  TrainingDetailState(this.state, {this.response, this.error});
}

///TODO: EVENT BLOCK

class UserJobsListEvent extends HomeEvent {
  UserJobsListEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class CompetitionDetailEvent extends HomeEvent {
  int? moduleId;
  CompetitionDetailEvent({this.moduleId}) : super([moduleId]);

  List<Object> get props => throw UnimplementedError();
}

class TrainingDetailEvent extends HomeEvent {
  int? programId;
  TrainingDetailEvent({this.programId}) : super([programId]);

  List<Object> get props => throw UnimplementedError();
}

class ReviewTestEvent extends HomeEvent {
  String? request;

  ReviewTestEvent({this.request}) : super([request]);

  List<Object> get props => throw UnimplementedError();
}

class AssignmentSubmissionsState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  AssignmentSubmissionResponse? response;
  String? error;

  AssignmentSubmissionsState(this.state, {this.response, this.error});
}

class AssignmentSubmissionsEvent extends HomeEvent {
  int? request;

  AssignmentSubmissionsEvent({this.request}) : super([request]);

  List<Object> get props => throw UnimplementedError();
}

class JoyCategoryEvent extends HomeEvent {
  JoyCategoryEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class GetCommentEvent extends HomeEvent {
  int? postId;

  GetCommentEvent({this.postId}) : super([postId]);

  List<Object> get props => throw UnimplementedError();
}

class PostCommentEvent extends HomeEvent {
  int? postId;
  int? parentId;
  String? comment;

  PostCommentEvent({this.postId, this.parentId, this.comment})
      : super([postId, parentId, comment]);

  List<Object> get props => throw UnimplementedError();
}

class getLiveClassEvent extends HomeEvent {
  getLiveClassEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class GetBottomNavigationBarEvent extends HomeEvent {
  GetBottomNavigationBarEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class PopularCoursesEvent extends HomeEvent {
  PopularCoursesEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class FilteredPopularCoursesEvent extends HomeEvent {
  FilteredPopularCoursesEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class GetUserProfileEvent extends HomeEvent {
  GetUserProfileEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class UpdateUserProfileImageEvent extends HomeEvent {
  String? filePath;
  String? name;
  String? email;
  UpdateUserProfileImageEvent({this.filePath, this.name, this.email})
      : super([filePath, name, email]);

  List<Object> get props => throw UnimplementedError();
}

class GetUserProfileState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  UserProfileResp? response;
  String? error;

  GetUserProfileState(this.state, {this.response, this.error});
}

class UpdateUserProfileImageState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  UpdateProfileImageResponse? response;
  String? error;

  UpdateUserProfileImageState(this.state, {this.response, this.error});
}

class PopularCoursesState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  popularCourses? response;
  String? error;

  PopularCoursesState(this.state, {this.response, this.error});
}

class GetBottomBarState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  BottomBarResponse? response;
  String? error;

  GetBottomBarState(this.state, {this.response, this.error});
}

class FilteredPopularCoursesState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  popularCourses? response;
  String? error;

  FilteredPopularCoursesState(this.state, {this.response, this.error});
}

class JoyCategoryState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  JoyCategoryResponse? response;
  String? error;

  JoyCategoryState(this.state, {this.response, this.error});
}

class GetCommentState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  CommentListResponse? response;
  String? error;

  GetCommentState(this.state, {this.response, this.error});
}

class PostCommentState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  PostCommentResponse? response;
  String? error;

  PostCommentState(this.state, {this.response, this.error});
}

class getLiveClassState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  onBoardSessions? response;
  String? error;

  getLiveClassState(this.state, {this.response, this.error});
}

class JoyContentListEvent extends HomeEvent {
  JoyContentListEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class JoyContentListState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  JoyConentListResponse? response;
  String? error;

  JoyContentListState(this.state, {this.response, this.error});
}

class DashboardIsVisibleEvent extends HomeEvent {
  DashboardIsVisibleEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class DashboardIsVisibleState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  DashboardViewResponse? response;
  String? error;

  DashboardIsVisibleState(this.state, {this.response, this.error});
}

class DashboardContentEvent extends HomeEvent {
  DashboardContentEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class DashboardContentState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  DashboardContentResponse? response;
  String? error;

  DashboardContentState(this.state, {this.response, this.error});
}

class ProgramListEvent extends HomeEvent {
  ProgramListEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class ProgramListState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  ProgramListResponse? response;
  String? error;

  ProgramListState(this.state, {this.response, this.error});
}

class CourseCategoryListIDEvent extends HomeEvent {
  int? categoryId;

  CourseCategoryListIDEvent({this.categoryId}) : super([categoryId]);

  List<Object> get props => throw UnimplementedError();
}

class CompetitionListEvent extends HomeEvent {
  bool? isPopular;
  bool? isFilter;
  String? ids;

  CompetitionListEvent({this.isPopular, this.isFilter = false, this.ids}) : super([isPopular, isFilter, ids]);

  List<Object> get props => throw UnimplementedError();
}

class CompetitionListFilterEvent extends HomeEvent {
  bool? isPopular;
  bool? isFilter;
  String? ids;

  CompetitionListFilterEvent({this.isPopular, this.isFilter = false, this.ids}) : super([isPopular, isFilter, ids]);

  List<Object> get props => throw UnimplementedError();
}

class JobCompListEvent extends HomeEvent {
  bool? isPopular;
  bool? isFilter;
  String? ids;
  int? isJob;
  int? myJob;
  bool? jobTypeMyJob;

  JobCompListEvent({this.isPopular, this.isFilter = false, this.ids, this.isJob, this.myJob, this.jobTypeMyJob = false}) : super([isPopular, isFilter, ids, isJob, myJob, jobTypeMyJob]);

  List<Object> get props => throw UnimplementedError();
}

class JobCompListFilterEvent extends HomeEvent {
  bool? isPopular;
  bool? isFilter;
  String? ids;
  bool? jobTypeMyJob;

  JobCompListFilterEvent({this.isPopular, this.isFilter = false, this.ids, this.jobTypeMyJob = false}) : super([isPopular, isFilter, ids, jobTypeMyJob]);

  List<Object> get props => throw UnimplementedError();
}


class DomainListEvent extends HomeEvent {

  DomainListEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class DomainListState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  DomainListResponse? response;
  String? error;

  DomainListState(this.state, {this.response, this.error});
}


class JobDomainDetailEvent extends HomeEvent {
  int? domainId;

  JobDomainDetailEvent({this.domainId}) : super([domainId]);

  List<Object> get props => throw UnimplementedError();
}

class JobDomainDetailState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  JobDomainResponse? response;
  String? error;

  JobDomainDetailState(this.state, {this.response, this.error});
}



class DomainFilterListEvent extends HomeEvent {
  String? ids;

  DomainFilterListEvent({this.ids}) : super([ids]);

  List<Object> get props => throw UnimplementedError();
}

class DomainFilterListState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  DomainFilterListResponse? response;
  String? error;

  DomainFilterListState(this.state, {this.response, this.error});
}


class LeaderboardEvent extends HomeEvent {
  String? type;
  int? id;
  int? skipotherUser;
  int? skipcurrentUser;

  LeaderboardEvent(
      {this.id, this.type, this.skipcurrentUser, this.skipotherUser})
      : super([id, type, skipotherUser, skipcurrentUser]);

  List<Object> get props => throw UnimplementedError();
}

class LeaderboardState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  LeaderboardResponse? response;

  LeaderboardState(
    this.state, {
    this.response,
  });
}

class CourseCategoryListIDState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  CourseCategoryListIdResponse? response;
  CourseCategoryListIdResponse? error;

  CourseCategoryListIDState(this.state, {this.response, this.error});
}

class CompetitionListState extends HomeState {
  ApiStatus state;
  ApiStatus get apiState => state;
  CompetitionResponse? competitonResponse, popularCompetitionResponse;
  PortfolioCompetitionResponse? competedCompetition;
  CompetitionMyActivityResponse? myActivity;
  String? error;

  CompetitionListState(this.state, {this.competitonResponse, this.popularCompetitionResponse,this.competedCompetition,this.myActivity,  this.error});
}

class CompetitionListFilterState extends HomeState {
  ApiStatus state;
  ApiStatus get apiState => state;
  CompetitionResponse? competitionFilterResponse;
  String? error;

  CompetitionListFilterState(this.state, {this.competitionFilterResponse, this.error});
}


class JobCompListState extends HomeState {
  ApiStatus state;
  ApiStatus get apiState => state;
  CompetitionResponse? jobListResponse, myJobListResponse, recommendedJobOpportunities;
  String? error;

  JobCompListState(this.state, {this.jobListResponse, this.myJobListResponse, this.recommendedJobOpportunities, this.error});
}


class JobCompListFilterState extends HomeState {
  ApiStatus state;
  ApiStatus get apiState => state;
  CompetitionResponse? jobListResponse;
  String? error;

  JobCompListFilterState(this.state, {this.jobListResponse, this.error});
}



class PopularCompetitionListState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  CompetitionResponse? response;
  String? error;

  PopularCompetitionListState(this.state, {this.response, this.error});
}

class CourseCategoryList2IDEvent extends HomeEvent {
  int? categoryId;

  CourseCategoryList2IDEvent({this.categoryId}) : super([categoryId]);

  List<Object> get props => throw UnimplementedError();
}

class CompetitionContentListEvent extends HomeEvent {
  int? competitionId;
  int? isApplied;

  CompetitionContentListEvent({this.competitionId, this.isApplied}) : super([competitionId, isApplied]);

  List<Object> get props => throw UnimplementedError();
}

class CourseCategoryList2IDState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  CourseCategoryListIdResponse? response;
  String? error;

  CourseCategoryList2IDState(this.state, {this.response, this.error});
}

class CompetitionContentListState extends HomeState {
  ApiStatus state;
  ApiStatus get apiState => state;
  CompetitionContentListResponse? response;
  CompetitionContentListState(this.state, {this.response});
}

class AppJobListCompeState extends HomeState {
  ApiStatus state;
  ApiStatus get apiState => state;
  CompetitionContentListResponse? response;
  AppJobListCompeState(this.state, {this.response});
}

class FeaturedVideoEvent extends HomeEvent {
  FeaturedVideoEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class CreatePortfolioEvent extends HomeEvent {
  String? title;
  String? description;
  String? type;
  String? filePath;
  CreatePortfolioEvent({this.title, this.description, this.type, this.filePath})
      : super([title, description, type, filePath]);

  List<Object> get props => throw UnimplementedError();
}

class MasterBrandCreateEvent extends HomeEvent {
  String? title;
  String? description;
  String? filePath;
  MasterBrandCreateEvent({this.title, this.description, this.filePath})
      : super([title, description, filePath]);

  List<Object> get props => throw UnimplementedError();
}

class UserBrandCreateEvent extends HomeEvent {
  String? endDate;
  String? startDate;
  int? typeId;
  String? filePath;
  UserBrandCreateEvent(
      {this.endDate, this.startDate, this.typeId, this.filePath})
      : super([endDate, startDate, typeId, filePath]);

  List<Object> get props => throw UnimplementedError();
}

class topScoringUsersEvent extends HomeEvent {
  int? userId;
  topScoringUsersEvent({this.userId}) : super([userId]);

  List<Object> get props => throw UnimplementedError();
}

class DeletePortfolioEvent extends HomeEvent {
  int? id;
  DeletePortfolioEvent({this.id}) : super([id]);

  List<Object> get props => throw UnimplementedError();
}

class ListPortfolioEvent extends HomeEvent {
  String? type;
  int? userId;
  ListPortfolioEvent({this.type, this.userId}) : super([type, userId]);

  List<Object> get props => throw UnimplementedError();
}

class DeletePortfolioState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  DeletePortfolioResponse? response;
  String? error;

  DeletePortfolioState(this.state, {this.response, this.error});
}

class SingularisDeletePortfolioEvent extends HomeEvent {

  int? portfolioId;
  SingularisDeletePortfolioEvent ({ this.portfolioId}) : super([portfolioId]);

  List<Object> get props => throw UnimplementedError();
}

class SingularisDeletePortfolioState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  SingularisPortfolioDelete? response;
  String? error;

  SingularisDeletePortfolioState(this.state, {this.response, this.error});
}

class ListPortfolioState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  ListPortfolioResponse? response;
  String? error;

  ListPortfolioState(this.state, {this.response, this.error});
}

class topScoringUsersState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  TopScoringUsersResponse? response;
  String? error;

  topScoringUsersState(this.state, {this.response, this.error});
}

class CreatePortfolioState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  CreatePortfolioResponse? response;
  String? error;

  CreatePortfolioState(this.state, {this.response, this.error});
}

class MasterBrandCreateState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  MasterBrandResponse? response;
  String? error;

  MasterBrandCreateState(this.state, {this.response, this.error});
}

class UserBrandCreateState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  String? error;

  UserBrandCreateState(this.state, {this.error});
}

class FeaturedVideoState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  FeaturedVideoResponse? response;
  String? error;

  FeaturedVideoState(this.state, {this.response, this.error});
}

class InterestEvent extends HomeEvent {
  InterestEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class InterestState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  JoyCategoryResponse? response;
  String? error;

  InterestState(this.state, {this.response, this.error});
}

class UserAnalyticsState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  UserAnalyticsResp? response;
  String? error;

  UserAnalyticsState(this.state, {this.response, this.error});
}

class MapInterestEvent extends HomeEvent {
  String? param;

  MapInterestEvent({this.param}) : super([param]);

  List<Object> get props => throw UnimplementedError();
}

class MapInterestState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  MapInterestResponse? response;
  String? error;

  MapInterestState(this.state, {this.response, this.error});
}

class GCarvaanPostEvent extends HomeEvent {
  int? callCount;
  int? postId;
  bool userActivity;
  GCarvaanPostEvent({this.callCount, this.postId, this.userActivity = false}) : super([callCount, postId]);

  List<Object> get props => throw UnimplementedError();
}

class GCarvaanPostState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  GCarvaanPostResponse? response;
  String? error;

  GCarvaanPostState(this.state, {this.response, this.error});
}

class GReelsPostEvent extends HomeEvent {
  bool userActivity;
  GReelsPostEvent({this.userActivity = false}) : super([]);

  List<Object> get props => throw UnimplementedError();
}

class GReelsPostState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  GReelsPostResponse? response;
  String? error;

  GReelsPostState(this.state, {this.response, this.error});
}

class AnnouncementContentState extends HomeState {
  ApiStatus state;
  int? contentType;

  ApiStatus get apiState => state;
  GetContentResp? response;
  String? error;

  AnnouncementContentState(this.state,
      {this.response, this.error, this.contentType});
}

class AnnouncementContentEvent extends HomeEvent {
  Box? box;
  int? contentType;

  AnnouncementContentEvent({this.contentType, this.box}) : super([contentType]);

  List<Object> get props => throw UnimplementedError();
}

class UpdateVideoCompletionEvent extends HomeEvent {
  int? bookmark;
  int? contentId;

  UpdateVideoCompletionEvent({this.bookmark, this.contentId})
      : super([bookmark, contentId]);

  @override
  List<Object> get props => throw UnimplementedError();
}

class UpdateVideoCompletionState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  String? error;

  UpdateVideoCompletionState(this.state, {this.error});
}

class CreatePostEvent extends HomeEvent {
  int? contentType;
  String? title;
  String? description;
  String? postType;
  List<String?>? filePath;
  String? thumbnail;

  CreatePostEvent(
      {this.contentType,
      this.title,
      this.description,
      this.postType,
      this.filePath,
      this.thumbnail
      })
      : super([title, description, postType, filePath]);

  List<Object> get props => throw UnimplementedError();
}

class CreatePostState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  CreatePostResponse? response;
  String? error;

  CreatePostState(this.state, {this.response, this.error});
}

class NotificationState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  NotificationResp? response;
  String? error;

  NotificationState(this.state, {this.response, this.error});
}

class NotificationListEvent extends HomeEvent {
  NotificationListEvent() : super([]);

  @override
  List<Object> get props => throw UnimplementedError();
}

class GetCoursesEvent extends HomeEvent {
  GetCoursesEvent({this.type = 0}) : super([]);
  int type;
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetCoursesState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  GetCoursesResp? response;
  String? error;

  GetCoursesState(this.state, {this.response, this.error});
}

class UserTrackingActivityEvent extends HomeEvent {
  UserTrackingActivity? trackReq;

  UserTrackingActivityEvent({this.trackReq}) : super([trackReq]);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UserTrackingActivityState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  GeneralResp? response;
  String? error;

  UserTrackingActivityState(this.state, {this.response, this.error});
}

class LikeContentEvent extends HomeEvent {
  int? contentId;
  String? type;
  int? like;

  LikeContentEvent({
    this.contentId,
    this.type,
    this.like,
  }) : super([contentId, type, like]);

  List<Object> get props => throw UnimplementedError();
}

class ReportEvent extends HomeEvent {
  String? status;

  int? postId;
  String? category;
  String? comment;

  ReportEvent({this.postId, this.category, this.comment, this.status})
      : super([status, postId, category, comment]);

  List<Object> get props => throw UnimplementedError();
}

class DeletePostEvent extends HomeEvent {
  int? postId;

  DeletePostEvent({this.postId})
      : super([
          postId,
        ]);

  List<Object> get props => throw UnimplementedError();
}

class LikeContentState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;

  LikeContentState(
    this.state,
  );
}

class ReportState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  ReportContentResp? response;
  String? error;

  ReportState(this.state, {this.response, this.error});
}

class DeletePostState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  DeletePostResponse? response;
  String? error;

  DeletePostState(this.state, {this.response, this.error});
}

class GetKPIAnalysisEvent extends HomeEvent {
  GetKPIAnalysisEvent() : super([]);

  @override
  List<Object> get props => throw UnimplementedError();
}

class GetKPIAnalysisState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  GetKpiAnalysisResp? response;
  String? error;

  GetKPIAnalysisState(this.state, {this.response, this.error});
}

class GetCourseModulesState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  GetCourseModulesResp? response;
  String? error;

  GetCourseModulesState(this.state, {this.response, this.error});
}

class GetCourseLeaderboardState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  GetCourseLeaderboardResp? response;
  String? error;

  GetCourseLeaderboardState(this.state, {this.response, this.error});
}

class GetCourseLeaderboardEvent extends HomeEvent {
  GetCourseModulesRequest? getCourseModulesReq;
  int type;

  GetCourseLeaderboardEvent({this.getCourseModulesReq, this.type = 0})
      : super([getCourseModulesReq, type]);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetCourseModulesEvent extends HomeEvent {
  GetCourseModulesRequest? getCourseModulesReq;
  int? type;

  GetCourseModulesEvent({this.getCourseModulesReq, this.type = 0})
      : super([getCourseModulesReq, type]);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetCertificatesEvent extends HomeEvent {
  GetCertificatesEvent() : super([]);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetCertificatesState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  GetCertificatesResp? response;
  String? error;

  GetCertificatesState(this.state, {this.response, this.error});
}

class GetModuleLeaderboardState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  GetModuleLeaderboardResp? response;
  String? error;

  GetModuleLeaderboardState(this.state, {this.response, this.error});
}

class GetModuleLeaderboardEvent extends HomeEvent {
  GetCourseModulesRequest? getCourseModulesReq;
  int type;

  GetModuleLeaderboardEvent({this.getCourseModulesReq, this.type = 0})
      : super([getCourseModulesReq, type]);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SubmitFeedbackState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  SubmitFeedbackResp? response;
  String? error;

  SubmitFeedbackState(this.state, {this.response, this.error});
}

class SubmitFeedbackEvent extends HomeEvent {
  FeedbackReq? feedbackReq;

  SubmitFeedbackEvent({this.feedbackReq}) : super([feedbackReq]);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class TopicsState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  TopicsResp? response;
  String? error;

  TopicsState(this.state, {this.response, this.error});
}

class TopicsEvent extends HomeEvent {
  TopicsEvent() : super([]);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FeedbackState extends HomeState {
  ApiStatus state;
  int? contentType;

  ApiStatus get apiState => state;
  FeedbackResp? response;
  String? error;

  FeedbackState(this.state, {this.response, this.error, this.contentType});
}

class FeedbackEvent extends HomeEvent {
  int? categoryType;

  FeedbackEvent({this.categoryType}) : super([categoryType]);

  @override
  List<Object> get props => throw UnimplementedError();
}

class ContentTagsState extends HomeState {
  ApiStatus state;
  int? contentType;

  ApiStatus get apiState => state;
  ContentTagsResp? response;
  String? error;

  ContentTagsState(this.state, {this.response, this.error, this.contentType});
}

class ContentTagsEvent extends HomeEvent {
  int? categoryType;

  ContentTagsEvent({this.categoryType}) : super([categoryType]);

  @override
  List<Object> get props => throw UnimplementedError();
}

class LibraryContentState extends HomeState {
  ApiStatus state;
  int? contentType;

  ApiStatus get apiState => state;
  GetContentResp? response;
  String? error;

  LibraryContentState(this.state,
      {this.response, this.error, this.contentType});
}

class LibraryContentEvent extends HomeEvent {
  int? contentType;

  LibraryContentEvent({this.contentType}) : super([contentType]);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class TrackAnnouncementEvent extends HomeEvent {
  TrackAnnouncementReq? rewardReq;

  TrackAnnouncementEvent({this.rewardReq}) : super([rewardReq]);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ActivityAttemptEvent extends HomeEvent {
  String? filePath;
  int? contentType;
  int? contentId;

  ActivityAttemptEvent({this.filePath, this.contentType, this.contentId})
      : super([filePath, contentType, contentId]);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ActivityAttemptState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  GeneralResp? response;
  String? error;

  ActivityAttemptState(this.state, {this.response, this.error});
}

class TrackAnnouncementState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  GeneralResp? response;
  String? error;

  TrackAnnouncementState(this.state, {this.response, this.error});
}

class SurveyDataState extends HomeState {
  ApiStatus state;
  int? contentId;

  ApiStatus get apiState => state;
  SurveyDataResp? response;
  String? error;
  SurveyDataState(this.state, {this.response, this.error, this.contentId});
}

class SurveyDataEvent extends HomeEvent {
  int? contentId;
  int? type;

  SurveyDataEvent({this.contentId, this.type}) : super([contentId, type]);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class RemoveAccountEvent extends HomeEvent {
  String? type;

  RemoveAccountEvent({this.type}) : super([type]);

  List<Object> get props => throw UnimplementedError();
}

class RemoveAccountState extends HomeState {
  ApiStatus state;
  String? type;

  ApiStatus get apiState => state;
  RemoveAccountResponse? response;
  RemoveAccountState(this.state, {this.response, this.type});
}

class SurveySubmitState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  GeneralResp? response;
  String? error;

  SurveySubmitState(this.state, {this.response, this.error});
}

class SubmitSurveyEvent extends HomeEvent {
  SubmitSurveyReq? submitSurveyReq;

  SubmitSurveyEvent({this.submitSurveyReq}) : super([submitSurveyReq]);
}

class PollSubmitState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  GeneralResp? response;
  String? error;

  PollSubmitState(this.state, {this.response, this.error});
}

class SubmitPollEvent extends HomeEvent {
  PollSubmitRequest? submitPollReq;

  SubmitPollEvent({this.submitPollReq}) : super([submitPollReq]);
}

class PortfolioEvent extends HomeEvent {
  PortfolioEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

class AddPortfolioEvent extends HomeEvent {
  Map<String, dynamic>? data;

  AddPortfolioEvent({this.data}) : super([data]);

  List<Object> get props => throw UnimplementedError();
}
class AddResumeEvent extends HomeEvent {
  Map<String, dynamic>? data;

  AddResumeEvent({this.data}) : super([data]);

  List<Object> get props => throw UnimplementedError();
}
class UploadProfileEvent extends HomeEvent {
  Map<String, dynamic>? data;

  UploadProfileEvent({this.data}) : super([data]);

  List<Object> get props => throw UnimplementedError();
}
class AddSocialEvent extends HomeEvent {
  Map<String, dynamic>? data;

  AddSocialEvent({this.data}) : super([data]);

  List<Object> get props => throw UnimplementedError();
}
class PortfolioCompetitoinEvent extends HomeEvent {
  PortfolioCompetitoinEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}
class PortfoilioCompetitionState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  PortfolioCompetitionResponse? response;
  String? error;
  PortfoilioCompetitionState(this.state, {this.response, this.error});
}

class AddSocialState extends HomeState {
  
  ApiStatus state;

  ApiStatus get apiState => state;
  AddPortfolioResp? response;
  String? error;
  AddSocialState(this.state, {this.response, this.error});
}

class TopScoringUserState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  TopScoringResponse? response;
  String? error;
  TopScoringUserState(this.state, {this.response, this.error});
}

class ZoomOpenUrlState extends HomeState {
  ApiStatus state;
  ApiStatus get apiState => state;
  ZoomOpenUrlResponse? response;
  ZoomOpenUrlState(this.state, {this.response});
}

class PortfolioState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  PortfolioResponse? response;
  String? error;
  PortfolioState(this.state, {this.response, this.error});
}
class AddResumeState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  AddPortfolioResp? response;
  String? error;
  AddResumeState(this.state, {this.response, this.error});
}
class UploadProfileState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  AddPortfolioResp? response;
  String? error;
  UploadProfileState(this.state, {this.response, this.error});
}


class AddPortfolioState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  AddPortfolioResp? response;
  String? error;
  AddPortfolioState(this.state, {this.response, this.error});
}

class AddExperienceEvent extends HomeEvent {
  Map<String, dynamic>? data;

  AddExperienceEvent({this.data}) : super([data]);

  List<Object> get props => throw UnimplementedError();
}
class TopScoringUserEvent extends HomeEvent {
  int? userId;

  TopScoringUserEvent({this.userId}) : super([userId]);

  List<Object> get props => throw UnimplementedError();
}


class ZoomOpenUrlEvent extends HomeEvent {
  int? contentId;
  ZoomOpenUrlEvent({this.contentId}) : super([contentId]);
  List<Object> get props => throw UnimplementedError();
}

class AddExperienceState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  AddPortfolioResp? response;
  String? error;
  AddExperienceState(this.state, {this.response, this.error});
}

class AddEducationEvent extends HomeEvent {
  Map<String, dynamic>? data;

  AddEducationEvent({this.data}) : super([data]);

  List<Object> get props => throw UnimplementedError();
}
class AddPortfolioProfileEvent extends HomeEvent {
  Map<String, dynamic>? data;

  AddPortfolioProfileEvent({this.data}) : super([data]);

  List<Object> get props => throw UnimplementedError();
}

class AddProfolioProfileState extends HomeState {
  ApiStatus state;
  ApiStatus get apiState => state;
  AddPortfolioResp? response;
  String? error;
  AddProfolioProfileState(this.state, {this.response, this.error});
}

class AddEducationState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  AddPortfolioResp? response;
  String? error;
  AddEducationState(this.state, {this.response, this.error});
}

class AddActivitiesEvent extends HomeEvent {
  Map<String, dynamic>? data;

  AddActivitiesEvent({this.data}) : super([data]);

  List<Object> get props => throw UnimplementedError();
}

class AddActivitiesState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  AddPortfolioResp? response;
  String? error;
  AddActivitiesState(this.state, {this.response, this.error});
}

class AddCertificateEvent extends HomeEvent {
  Map<String, dynamic>? data;

  AddCertificateEvent({this.data}) : super([data]);

  List<Object> get props => throw UnimplementedError();
}

class AddCertificateState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  AddPortfolioResp? response;
  String? error;
  AddCertificateState(this.state, {this.response, this.error});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final homeRepository = Injector.appInstance.get<HomeRepository>();

  HomeBloc(HomeState initialState) : super(initialState);

  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if(event is DomainFilterListEvent){
        try {
        yield DomainFilterListState(ApiStatus.LOADING);
        final response = await homeRepository.getFilterDomainList(event.ids!);
        //Log.v(" domain filter list  DATA ::: ${response.data}");
        if (response.data != null) {
          yield DomainFilterListState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v(" domain filter   ERROR DATA ::: $response");
          yield DomainFilterListState(ApiStatus.ERROR, response: response);
        }
      } catch (e) {}
      
    }

else if(event is JobDomainDetailEvent){
try {
        yield JobDomainDetailState(ApiStatus.LOADING);
        final response = await homeRepository.jobDomainDetail(event.domainId!);
        Log.v("top scoring resume DATA ::: ${response.data}");

        if (response.data != null) {
          yield JobDomainDetailState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("top scoring   ERROR DATA ::: $response");
          yield JobDomainDetailState(ApiStatus.ERROR, response: response);
        }
      } catch (e) {}
}

  else   if(event is DomainListEvent){
        try {
        yield DomainListState(ApiStatus.LOADING);
        final response = await homeRepository.getDomainList();
        Log.v("top scoring resume DATA ::: ${response.data}");

        if (response.data != null) {
          yield DomainListState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("top scoring   ERROR DATA ::: $response");
          yield DomainListState(ApiStatus.ERROR, response: response);
        }
      } catch (e) {}
    }
else if(event is TopScoringUserEvent){
   try {
        yield TopScoringUserState(ApiStatus.LOADING);
        final response = await homeRepository.topScoringUser(userId: event.userId);
        Log.v("top scoring resume DATA ::: ${response?.data}");

        if (response?.data != null) {
          yield TopScoringUserState(ApiStatus.SUCCESS, response: response!);
        } else {
          Log.v("top scoring   ERROR DATA ::: $response");
          yield TopScoringUserState(ApiStatus.ERROR, response: response!);
        }
      } catch (e) {}
}

    else if(event is PortfolioCompetitoinEvent){
 try {
        yield PortfoilioCompetitionState(ApiStatus.LOADING);
        final response = await homeRepository.getPortfolioCompetition();
        Log.v("Add Social resume DATA ::: ${response?.data}");

        if (response?.data != null) {
          yield PortfoilioCompetitionState(ApiStatus.SUCCESS, response: response!);
        } else {
          Log.v("Add social   ERROR DATA ::: $response");
          yield PortfoilioCompetitionState(ApiStatus.ERROR, response: response!);
        }
      } catch (e) {}
    }

    else  if(event is AddSocialEvent){
 try {
        yield AddSocialState(ApiStatus.LOADING);
        final response = await homeRepository.addSocial(data: event.data);
        Log.v("Add Social resume DATA ::: ${response?.data}");

        if (response?.data != null) {
          yield AddSocialState(ApiStatus.SUCCESS, response: response!);
        } else {
          Log.v("Add social   ERROR DATA ::: $response");
          yield AddSocialState(ApiStatus.ERROR, response: response!);
        }
      } catch (e) {}
    }
else if(event is UploadProfileEvent){
  try {
        yield UploadProfileState(ApiStatus.LOADING);
        final response = await homeRepository.uploadProfile(data: event.data);
        Log.v("Add PORTFOLIO resume DATA ::: ${response?.data}");

        if (response?.data != null) {
          yield UploadProfileState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("PORTFOLIO resume  ERROR DATA ::: $response");
          yield UploadProfileState(ApiStatus.ERROR, response: response);
        }
      } catch (e) {}
}
  else  if(event is AddResumeEvent){
try {
        yield AddResumeState(ApiStatus.LOADING);
        final response = await homeRepository.addResume(data: event.data);
        Log.v("Add PORTFOLIO resume DATA ::: ${response.data}");

        if (response.data != null) {
          yield AddResumeState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("PORTFOLIO resume  ERROR DATA ::: $response");
          yield AddResumeState(ApiStatus.ERROR, response: response);
        }
      } catch (e) {}
    }

   else if(event is AddPortfolioProfileEvent){
       try {
        yield AddProfolioProfileState(ApiStatus.LOADING);
        final response = await homeRepository.addPortfolioProfile(data: event.data);
        Log.v("Add PORTFOLIO Profile DATA ::: ${response.data}");

        if (response.data != null) {
          yield AddProfolioProfileState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("PORTFOLIO Profile  ERROR DATA ::: $response");
          yield AddProfolioProfileState(ApiStatus.ERROR, response: response);
        }
      } catch (e) {}
    }
    else if (event is AddPortfolioEvent) {
      try {
        yield AddPortfolioState(ApiStatus.LOADING);
        final response = await homeRepository.addPortfolio(data: event.data);
        Log.v("Add PORTFOLIO DATA ::: ${response.data}");

        if (response.data != null) {
          yield AddPortfolioState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("Add ERROR DATA ::: $response");
          yield AddPortfolioState(ApiStatus.ERROR, response: response);
        }
      } catch (e) {}
    } 
    else 
    if (event is PortfolioEvent) {
      try {
        yield PortfolioState(ApiStatus.LOADING);
        final response = await homeRepository.getPortfolio();
        Log.v("PORTFOLIO DATA ::: ${response?.data}");

        if (response?.data != null) {
          yield PortfolioState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: $response");
          yield PortfolioState(ApiStatus.ERROR, response: response);
        }
      } catch (e) {}
    } 

     else 
    if (event is SingularisDeletePortfolioEvent ) {
      try {
        yield SingularisDeletePortfolioState(ApiStatus.LOADING);
        final response = await homeRepository.singularisPortfolioDelete(event.portfolioId!);
        Log.v(" Delete PORTFOLIO DATA ::: ${response.data}");

        if (response.data != null) {
          yield SingularisDeletePortfolioState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: $response");
          yield SingularisDeletePortfolioState(ApiStatus.ERROR, response: response);
        }
      } catch (e) {}
    } 
  
    
    else if (event is AddActivitiesEvent) {
      try {
        yield AddActivitiesState(ApiStatus.LOADING);
        final response = await homeRepository.addProfessional(data: event.data);
        Log.v("ACTIVITIES DATA ::: ${response.data}");

        if (response.data != null) {
          yield AddActivitiesState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: $response");
          yield AddActivitiesState(ApiStatus.ERROR, response: response);
        }
      } catch (e) {}
   
    }
    else if (event is ZoomOpenUrlEvent) {
      try {
        yield ZoomOpenUrlState(ApiStatus.LOADING);
        final response = await homeRepository.getZoomOpenUrl(event.contentId!);
        print('the opne url 1');
         yield ZoomOpenUrlState(ApiStatus.SUCCESS, response: response);
      } catch (e, stacktrace) {
        print(stacktrace);
      }
   
    }
    
     else if (event is CompetitionContentListEvent) {
     try {
        yield CompetitionContentListState(ApiStatus.LOADING);
        final response =
            await homeRepository.getCompetitionContentList(event.competitionId, event.isApplied);
        Log.v("MY DA DATA ::: ${response.data}");

        if (response.data != null) {
          yield CompetitionContentListState(ApiStatus.SUCCESS,
              response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield CompetitionContentListState(ApiStatus.ERROR,
              response: response);
        }
      } catch (e) {
        Log.v("Expection DATA  : $e");
        yield CompetitionContentListState(ApiStatus.ERROR);
      }

    }else if (event is CompetitionContentListEvent) {
      try {
        yield AppJobListCompeState(ApiStatus.LOADING);
        final response = await homeRepository.getCompetitionContentList(event.competitionId, event.isApplied);
        Log.v("MY DA DATA ::: ${response.data}");
        int notCheck = 1;
        //if (response.data != null) {
        if (notCheck == 1) {
          yield AppJobListCompeState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield AppJobListCompeState(ApiStatus.ERROR,
              response: response);
        }
      } catch (e) {
        Log.v("Expection DATA  : $e");
        yield AppJobListCompeState(ApiStatus.ERROR);
      }
    }

    //leaderboard
    else if (event is LeaderboardEvent) {
      try {
        yield LeaderboardState(ApiStatus.LOADING);
        final response = await homeRepository.getLeaderboard(
            event.id, event.type, event.skipotherUser, event.skipotherUser);
        Log.v("MY DA DATA ::: ${response.data}");

        if (response.data != null) {
          yield LeaderboardState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield LeaderboardState(ApiStatus.ERROR, response: response);
        }
      } catch (e) {
        Log.v("Expection DATA  : $e");
        yield LeaderboardState(ApiStatus.ERROR);
      }
    } else if (event is AnnouncementContentEvent) {
      try {
        print('call api for getting data');
        yield AnnouncementContentState(ApiStatus.LOADING);
        final response = await homeRepository.getContentList(
          contentType: event.contentType,
        );
        if (response.data != null) {
          yield AnnouncementContentState(ApiStatus.SUCCESS,
              response: response, contentType: event.contentType);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield AnnouncementContentState(ApiStatus.ERROR,
              error: response.error![0]);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield AnnouncementContentState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is SubmitPollEvent) {
      try {
        yield PollSubmitState(ApiStatus.LOADING);
        final response = await homeRepository.submitPoll(
            submitSurveyReq: event.submitPollReq);
        if (response != null) {
          yield PollSubmitState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield PollSubmitState(ApiStatus.ERROR, error: response?.message);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield PollSubmitState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is SubmitSurveyEvent) {
      try {
        yield SurveySubmitState(ApiStatus.LOADING);
        final response = await homeRepository.submitSurvey(
            submitSurveyReq: event.submitSurveyReq);
        if (response != null) {
          yield SurveySubmitState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield SurveySubmitState(ApiStatus.ERROR, error: response.message);
        }
      } catch (e, s) {
        Log.v("ERROR DATA : $s");
        yield SurveySubmitState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is RemoveAccountEvent) {
      try {
        yield RemoveAccountState(ApiStatus.LOADING);
        final response = await homeRepository.removeAccount(type: event.type);
        if (response != null) {
          yield RemoveAccountState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: $response");
          yield RemoveAccountState(ApiStatus.ERROR);
        }
      } catch (e, s) {
        Log.v("ERROR DATA : $s");
        yield RemoveAccountState(
          ApiStatus.ERROR,
        );
      }
    } else if (event is SurveyDataEvent) {
      try {
        yield SurveyDataState(ApiStatus.LOADING);
        print("BLOCC");
        print(event.type);
        print(event.contentId);
        final response = await homeRepository.getSurveyDataList(
            contentId: event.contentId, type: event.type);
        if (response != null) {
          yield SurveyDataState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield SurveyDataState(ApiStatus.ERROR, error: response?.error![0]);
        }
      } catch (e, s) {
        print(s);
        Log.v("ERROR DATA : $s");
        yield SurveyDataState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is NotificationListEvent) {
      try {
        yield NotificationState(ApiStatus.LOADING);
        final response = await homeRepository.getNotifications();
        if (response?.data != null) {
          yield NotificationState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield NotificationState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield NotificationState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is ActivityAttemptEvent) {
      try {
        yield ActivityAttemptState(ApiStatus.LOADING);
        final response = await homeRepository.activityAttempt(
            filePath: event.filePath,
            contentType: event.contentType,
            contentId: event.contentId);
        if (response?.status == 1) {
          yield ActivityAttemptState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERRyyyOR DATA ::: ${response}");
          yield ActivityAttemptState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield ActivityAttemptState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is TrackAnnouncementEvent) {
      try {
        yield TrackAnnouncementState(ApiStatus.LOADING);
        final response = await homeRepository.trackAnnouncment(
            trackAnnouncementReq: event.rewardReq);
        if (response?.status == 1) {
          yield TrackAnnouncementState(ApiStatus.SUCCESS, response: response);
        } else {
          yield TrackAnnouncementState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield TrackAnnouncementState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is LibraryContentEvent) {
      try {
        yield LibraryContentState(ApiStatus.LOADING);
        final response =
            await homeRepository.getContentList(contentType: event.contentType);
        if (response.data != null) {
          yield LibraryContentState(ApiStatus.SUCCESS,
              response: response, contentType: event.contentType);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield LibraryContentState(ApiStatus.ERROR, error: response.error![0]);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield LibraryContentState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is ContentTagsEvent) {
      try {
        yield ContentTagsState(ApiStatus.LOADING);
        final response = await homeRepository.getContentTagsList(
            categoryType: event.categoryType);
        if (response?.data != null) {
          yield ContentTagsState(ApiStatus.SUCCESS,
              response: response, contentType: event.categoryType);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield ContentTagsState(ApiStatus.ERROR, error: response?.error![0]);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield ContentTagsState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is FeedbackEvent) {
      try {
        yield FeedbackState(ApiStatus.LOADING);
        final response = await homeRepository.getFeedbackList();
        if (response!.data != null) {
          yield FeedbackState(ApiStatus.SUCCESS,
              response: response, contentType: event.categoryType);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield FeedbackState(ApiStatus.ERROR, error: response.error![0]);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield FeedbackState(ApiStatus.ERROR, error: Strings.somethingWentWrong);
      }
    } else if (event is TopicsEvent) {
      try {
        yield TopicsState(ApiStatus.LOADING);
        final response = await homeRepository.getTopicsList();
        if (response.data != null) {
          yield TopicsState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield TopicsState(ApiStatus.ERROR, error: response.error![0]);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield TopicsState(ApiStatus.ERROR, error: Strings.somethingWentWrong);
      }
    } else if (event is SubmitFeedbackEvent) {
      try {
        yield SubmitFeedbackState(ApiStatus.LOADING);
        final response =
            await homeRepository.submitFeedback(feedbackReq: event.feedbackReq);
        if (response != null) {
          yield SubmitFeedbackState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA2 ::: ${response}");
          yield SubmitFeedbackState(ApiStatus.ERROR, error: response.message);
        }
      } catch (e, stacktrace) {
        print(stacktrace);
        Log.v("ERROR DATA3 : $e");
        yield SubmitFeedbackState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is GetModuleLeaderboardEvent) {
      try {
        yield GetModuleLeaderboardState(ApiStatus.LOADING);
        final response = await homeRepository.getModuleLeaderboardList(
            '${event.getCourseModulesReq?.courseId}',
            type: event.type);
        if (response?.data != null) {
          yield GetModuleLeaderboardState(ApiStatus.SUCCESS,
              response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield GetModuleLeaderboardState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e, s) {
        print(s);
        Log.v("ERROR DATA : $e");
        yield GetModuleLeaderboardState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is GetCertificatesEvent) {
      try {
        yield GetCertificatesState(ApiStatus.LOADING);
        final response = await homeRepository.getCertificatesList();
        if (response?.data != null) {
          yield GetCertificatesState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield GetCertificatesState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield GetCertificatesState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is GetCourseLeaderboardEvent) {
      try {
        yield GetCourseLeaderboardState(ApiStatus.LOADING);
        final response = await homeRepository.getCourseLeaderboardList(
            '${event.getCourseModulesReq?.courseId}',
            type: event.type);
        if (response!.data != null) {
          yield GetCourseLeaderboardState(ApiStatus.SUCCESS,
              response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield GetCourseLeaderboardState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e, s) {
        print(s);
        Log.v("ERROR DATA : $e");
        yield GetCourseLeaderboardState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is GetCourseModulesEvent) {
      try {
        yield GetCourseModulesState(ApiStatus.LOADING);
        final response = await homeRepository.getCourseModulesList(
            '${event.getCourseModulesReq?.courseId}',
            type: event.type!);
        if (response?.data != null) {
          yield GetCourseModulesState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield GetCourseModulesState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e, stacktrace) {
        print(stacktrace);
        Log.v("ERROR DATA : $e");
        yield GetCourseModulesState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is GetKPIAnalysisEvent) {
      try {
        yield GetKPIAnalysisState(ApiStatus.LOADING);
        final response = await homeRepository.getKPIAnalysisList();
        if (response?.data != null) {
          yield GetKPIAnalysisState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield GetKPIAnalysisState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield GetKPIAnalysisState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is MyAssessmentEvent) {
      try {
        yield MyAssessmentState(ApiStatus.LOADING);
        final response = await homeRepository.getMyAssessmentList();
        if (response.data != null) {
          yield MyAssessmentState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield MyAssessmentState(ApiStatus.ERROR, error: response.error![0]);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield MyAssessmentState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is GetCoursesEvent) {
      try {
        yield GetCoursesState(ApiStatus.LOADING);
        final response = await homeRepository.getCoursesList(type: event.type);
        if (response?.data != null) {
          yield GetCoursesState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield GetCoursesState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e, s) {
        print(s);
        Log.v("ERROR DATA : $e");
        yield GetCoursesState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is MyAssignmentEvent) {
      try {
        yield MyAssignmentState(ApiStatus.LOADING);
        final response = await homeRepository.getMyAssignmentList();
        if (response.data != null) {
          yield MyAssignmentState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield MyAssignmentState(ApiStatus.ERROR, error: response.error![0]);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield MyAssignmentState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is UserProgramSubscribeEvent) {
      try {
        yield UserProgramSubscribeState(ApiStatus.LOADING);
        final response = await homeRepository.subscribeProgram(event.subrReq!);
        if (response.data != null) {
          yield UserProgramSubscribeState(ApiStatus.SUCCESS,
              response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield UserProgramSubscribeState(ApiStatus.ERROR,
              error: response.error![0]);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield UserProgramSubscribeState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is AttemptTestEvent) {
      try {
        yield AttemptTestState(ApiStatus.LOADING);
        final response =
            await homeRepository.attemptTest(request: event.request!);
        if (response!.status == 1) {
          yield AttemptTestState(ApiStatus.SUCCESS, response: response);
        } else {
          yield AttemptTestState(ApiStatus.ERROR, error: response.error?.first);
        }
      } catch (e) {
        yield AttemptTestState(ApiStatus.ERROR, error: "Something went wrong");
      }
    } else if (event is SaveAnswerEvent) {
      try {
        yield SaveAnswerState(ApiStatus.LOADING);
        final response =
            await homeRepository.saveAnswer(request: event.request!);
        if (response!.status == 1) {
          yield SaveAnswerState(ApiStatus.SUCCESS, response: response);
        } else {
          yield SaveAnswerState(ApiStatus.ERROR, error: "SOMETHING WENT WRONG");
        }
      } catch (e) {
        yield SaveAnswerState(ApiStatus.ERROR, error: "Something went wrong");
      }
    } else if (event is SubmitAnswerEvent) {
      try {
        yield SubmitAnswerState(ApiStatus.LOADING);
        final response =
            await homeRepository.submitAnswer(request: event.request);
        if (response!.status == 1) {
          yield SubmitAnswerState(ApiStatus.SUCCESS, response: response);
        } else {
          yield SubmitAnswerState(ApiStatus.ERROR,
              error: "Something went wrong");
        }
      } catch (e) {
        yield SubmitAnswerState(ApiStatus.ERROR, error: "Something went wrong");
      }
    }

    ///Email
    else if (event is EmailCodeSendEvent) {
      try {
        yield EmailCodeSendState(ApiStatus.LOADING);
        final response = await homeRepository.emailCodeSend(email: event.email, isSignup: event.isSignup, forgotPass: event.forgotPass);
        if (response == 1) {
          yield EmailCodeSendState(ApiStatus.SUCCESS);
        } else {
          //yield EmailCodeSendState(ApiStatus.ERROR, error: "Something went wrong");
          yield EmailCodeSendState(ApiStatus.ERROR, error: response);
        }
      } catch (e) {
        yield EmailCodeSendState(ApiStatus.ERROR, error: "Something went wrong");
      }
    }else if (event is VerifyEmailCodeEvent) {
      try {
        yield VerifyEmailCodeState(ApiStatus.LOADING);
        final response = await homeRepository.verifyEmailCodeAnswer(email: event.email, eCode: event.code);

        if (response == 1) {
          yield VerifyEmailCodeState(ApiStatus.SUCCESS);
        } else {
          yield VerifyEmailCodeState(ApiStatus.ERROR, error: "Invalid Code");
        }
      } catch (e) {
        yield VerifyEmailCodeState(ApiStatus.ERROR, error: "Something went wrong");
      }
    }

    else if (event is PasswordUpdateEvent) {
      try {
        yield PasswordUpdateState(ApiStatus.LOADING);
        final response = await homeRepository.passwordUpdate(email: event.email, pass: event.pass);

        if (response == 1) {
          yield PasswordUpdateState(ApiStatus.SUCCESS);
        } else {
          yield PasswordUpdateState(ApiStatus.ERROR, error: "Password Update Error");
        }
      } catch (e) {
        yield PasswordUpdateState(ApiStatus.ERROR, error: "Something went wrong");
      }
    }
    ///

    else if (event is ReviewTestEvent) {
      try {
        yield ReviewTestState(ApiStatus.LOADING);
        final response =
            await homeRepository.reviewTest(request: event.request!);
        if (response!.status == 1) {
          yield ReviewTestState(ApiStatus.SUCCESS, response: response);
        } else {
          yield ReviewTestState(ApiStatus.ERROR, error: response.error?.first);
        }
      } catch (e) {
        yield ReviewTestState(ApiStatus.ERROR, error: "Something went wrong");
      }
    } else if (event is AssignmentSubmissionsEvent) {
      try {
        yield AssignmentSubmissionsState(ApiStatus.LOADING);
        final response =
            await homeRepository.getSubmissions(request: event.request);
        if (response!.status == 1) {
          yield AssignmentSubmissionsState(ApiStatus.SUCCESS,
              response: response);
        } else {
          yield AssignmentSubmissionsState(ApiStatus.ERROR,
              error: response.error?.first);
        }
      } catch (e) {
        yield ReviewTestState(ApiStatus.ERROR, error: "Something went wrong");
      }
    } else if (event is LanguageEvent) {
      try {
        yield LanguageState(ApiStatus.LOADING);
        final response = await homeRepository.getLanguage(event.languageType);
        if (response.data != null) {
          yield LanguageState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield LanguageState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield LanguageState(ApiStatus.ERROR, error: Strings.somethingWentWrong);
      }
    } else if (event is MasterLanguageEvent) {
      try {
        yield MasterLanguageState(ApiStatus.LOADING);
        final response = await homeRepository.getMasterLanguage();
        if (response.data != null) {
          yield MasterLanguageState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA TTT ::: ${response}");
          yield MasterLanguageState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA FFF : $e");
        yield MasterLanguageState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is JoyCategoryEvent) {
      try {
        yield JoyCategoryState(ApiStatus.LOADING);
        final response = await homeRepository.getjoyCategory();
        if (response.data != null) {
          yield JoyCategoryState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield JoyCategoryState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield JoyCategoryState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is UserJobsListEvent) {
      try {
        yield UserJobListState(ApiStatus.LOADING);
        final response = await homeRepository.getUserJobList();
        if (response.list != null) {
          yield UserJobListState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield UserJobListState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield UserJobListState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is CompetitionDetailEvent) {
      try {
        yield CompetitionDetailState(ApiStatus.LOADING);
        final response =
            await homeRepository.getCompetitionDetail(event.moduleId);
        if (response.status == 1) {
          yield CompetitionDetailState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: $response");
          yield CompetitionDetailState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield CompetitionDetailState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is TrainingDetailEvent) {
      try {
        yield TrainingDetailState(ApiStatus.LOADING);
        final response =
            await homeRepository.getTrainingDetail(event.programId);
        if (response.status == 1) {
          yield TrainingDetailState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: $response");
          yield TrainingDetailState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield TrainingDetailState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is GetCommentEvent) {
      try {
        yield GetCommentState(ApiStatus.LOADING);
        final response = await homeRepository.getComment(event.postId);
        if (response.data != null) {
          yield GetCommentState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield GetCommentState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield GetCommentState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is PostCommentEvent) {
      try {
        yield PostCommentState(ApiStatus.LOADING);
        final response = await homeRepository.postComment(
            event.postId, event.parentId, event.comment);
        if (response != null) {
          yield PostCommentState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield PostCommentState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield PostCommentState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is getLiveClassEvent) {
      try {
        yield getLiveClassState(ApiStatus.LOADING);
        final response = await homeRepository.getLiveClasses();
        if (response.data != null) {
          yield getLiveClassState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield getLiveClassState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield getLiveClassState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is DashboardIsVisibleEvent) {
      try {
        yield DashboardIsVisibleState(ApiStatus.LOADING);
        final response = await homeRepository.getDashboardIsVisible();
        if (response.data != null) {
          yield DashboardIsVisibleState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield DashboardIsVisibleState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield DashboardIsVisibleState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is DashboardContentEvent) {
      try {
        yield DashboardContentState(ApiStatus.LOADING);
        final response = await homeRepository.getDasboardList();
        if (response.data != null) {
          yield DashboardContentState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield DashboardContentState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield DashboardContentState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is JoyContentListEvent) {
      try {
        yield JoyContentListState(ApiStatus.LOADING);
        final response = await homeRepository.getjoyContentList();
        if (response.data != null) {
          yield JoyContentListState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield JoyContentListState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield JoyContentListState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is ProgramListEvent) {
      try {
        yield ProgramListState(ApiStatus.LOADING);
        final response = await homeRepository.getPrograms();
        if (response.data != null) {
          yield ProgramListState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield ProgramListState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield ProgramListState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is CourseCategoryListIDEvent) {
      try {
        yield CourseCategoryListIDState(ApiStatus.LOADING);

        final response = await homeRepository.getCourseWithId(event.categoryId);

        if (response.data != null) {
          yield CourseCategoryListIDState(ApiStatus.SUCCESS,
              response: response);
        } else {
          Log.v("ERROR DATA ::: ${response.error?.first}");
          yield CourseCategoryListIDState(ApiStatus.ERROR, error: response);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield CourseCategoryListIDState(ApiStatus.ERROR,
            error: CourseCategoryListIdResponse());
      }
    } else if (event is CompetitionListEvent) {
      if (event.isPopular == false) {
        try {
          yield CompetitionListState(ApiStatus.LOADING);

         List<dynamic> response = await  Future.wait([homeRepository.getCompetitionList(false, event.isFilter!, event.ids), homeRepository.getCompetitionList(true, event.isFilter!, event.ids),homeRepository.getPortfolioCompetition(), homeRepository.getCompetitionMyActivity()]);

          // final response = await homeRepository.getCompetitionList(false);
          yield CompetitionListState(ApiStatus.SUCCESS,competitonResponse: response[0],popularCompetitionResponse: response[1], competedCompetition: response[2], myActivity: response[3] );
        } catch (e) {
          Log.v("Exception : $e");
          yield CompetitionListState(ApiStatus.ERROR,
              error: 'Something went wrong');
        }
      } else {
        try {
          yield PopularCompetitionListState(ApiStatus.LOADING);

          final response = await homeRepository.getCompetitionList(true, event.isFilter!, event.ids);

          yield PopularCompetitionListState(ApiStatus.SUCCESS,
              response: response);
        } catch (e) {
          Log.v("Exception : $e");
          yield PopularCompetitionListState(ApiStatus.ERROR,
              error: 'Something went wrong');
        }
      }
    }

    else if (event is CompetitionListFilterEvent) {
      //if (event.isPopular == false) {
        try {
          yield CompetitionListFilterState(ApiStatus.LOADING);

          List<dynamic> response = await  Future.wait([homeRepository.getCompetitionList(false, event.isFilter!, event.ids)]);
          yield CompetitionListFilterState(ApiStatus.SUCCESS,competitionFilterResponse: response[0]);
        } catch (e) {
          Log.v("Exception : $e");
          yield CompetitionListFilterState(ApiStatus.ERROR,
              error: 'Something went wrong');
        }
      //}
    }


    ///For Job -============
    else if (event is JobCompListEvent) {
      if (event.isPopular == false) {
          try {
            yield JobCompListState(ApiStatus.LOADING);

            if(event.jobTypeMyJob == false) {
              List<dynamic> response = await Future.wait(
                  [
                    homeRepository.getJobCompApiList(
                        false, event.isFilter!, event.ids, event.isJob,
                        event.myJob, 'allJob'),
                    homeRepository.getJobCompApiList(
                        false, event.isFilter!, event.ids, event.isJob,
                        event.myJob, 'myJob'),
                    homeRepository.getJobCompApiList(
                        false, event.isFilter!, event.ids, event.isJob,
                        event.myJob, 'recomJob'),
                  ]);

              yield JobCompListState(
                  ApiStatus.SUCCESS, jobListResponse: response[0],
                  myJobListResponse: response[1], recommendedJobOpportunities: response[2]);

            }else{
              List<dynamic> response = await Future.wait(
                  [
                    homeRepository.getJobCompApiList(
                        false, event.isFilter!, event.ids, event.isJob,
                        event.myJob, 'myJob'),
                  ]);

              yield JobCompListState(
                ApiStatus.SUCCESS, myJobListResponse: response[0],);
            }

            //final response = await homeRepository.getCompetitionList(false);
          } catch (e) {
            Log.v("Exception : $e");
            yield JobCompListState(ApiStatus.ERROR,
                error: 'Something went wrong');
          }

      } else{
        try {
          yield JobCompListState(ApiStatus.LOADING);
          List<dynamic> response = await  Future.wait(
              [homeRepository.getJobCompApiList(true, event.isFilter!, event.ids, event.isJob, event.myJob, 'dashboard')]);

          yield JobCompListState(
            ApiStatus.SUCCESS,myJobListResponse: response[0],);
        } catch (e) {
          Log.v("Exception : $e");
          yield JobCompListState(ApiStatus.ERROR,
              error: 'Something went wrong');
        }
      }

    }

    ///Filter Job
    else if (event is JobCompListFilterEvent) {
      try {
        yield JobCompListFilterState(ApiStatus.LOADING);
        List<dynamic> response = await  Future.wait(
            [homeRepository.getJobCompApiList(false, true, event.ids, 0, 0, 'filter')]);

        yield JobCompListFilterState(
          ApiStatus.SUCCESS,jobListResponse: response[0],);
      } catch (e) {
        Log.v("Exception : $e");
        yield JobCompListFilterState(ApiStatus.ERROR,
            error: 'Something went wrong');
      }
    }


    else if (event is CourseCategoryList2IDEvent) {
      try {
        yield CourseCategoryList2IDState(ApiStatus.LOADING);

        final response = await homeRepository.getCourseWithId(event.categoryId);

        if (response.data != null) {
          yield CourseCategoryList2IDState(ApiStatus.SUCCESS,
              response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield CourseCategoryList2IDState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield CourseCategoryList2IDState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is FeaturedVideoEvent) {
      try {
        yield FeaturedVideoState(ApiStatus.LOADING);

        final response = await homeRepository.getFeaturedVideo();

        if (response.data != null) {
          yield FeaturedVideoState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield FeaturedVideoState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield FeaturedVideoState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is InterestEvent) {
      try {
        yield InterestState(ApiStatus.LOADING);

        final response = await homeRepository.getInterestPrograms();

        if (response.data != null) {
          yield InterestState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield InterestState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield InterestState(ApiStatus.ERROR, error: Strings.somethingWentWrong);
      }
    } else if (event is MapInterestEvent) {
      try {
        yield MapInterestState(ApiStatus.LOADING);

        final response = await homeRepository.mapInterest(event.param);

        if (response.data != null) {
          yield MapInterestState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield MapInterestState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield MapInterestState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is PopularCoursesEvent) {
      try {
        yield PopularCoursesState(ApiStatus.LOADING);

        final response = await homeRepository.getPopularCourses();

        if (response.data != null) {
          yield PopularCoursesState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield PopularCoursesState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield PopularCoursesState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is FilteredPopularCoursesEvent) {
      try {
        yield FilteredPopularCoursesState(ApiStatus.LOADING);

        final response = await homeRepository.getFilteredPopularCourses();

        if (response.data != null) {
          yield FilteredPopularCoursesState(ApiStatus.SUCCESS,
              response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield FilteredPopularCoursesState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA getFilteredPopularCourses : $e");
        yield FilteredPopularCoursesState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is GetBottomNavigationBarEvent) {
      try {
        yield GetBottomBarState(ApiStatus.LOADING);
        final response = await homeRepository.bottombarResponse();
        if (response.status == 1) {
          yield GetBottomBarState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERRyyyOR DATA ::: $response");
          yield GetBottomBarState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield GetBottomBarState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is GCarvaanPostEvent) {
      try {
        yield GCarvaanPostState(ApiStatus.LOADING);

        final response =
            await homeRepository.GCarvaanPost(event.callCount!, event.postId, event.userActivity);

        if (response.data != null) {
          yield GCarvaanPostState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: $response");
          yield GCarvaanPostState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield GCarvaanPostState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is GReelsPostEvent) {
      try {
        yield GReelsPostState(ApiStatus.LOADING);

        final response = await homeRepository.GReelsPost(event.userActivity);

        if (response.data != null) {
          yield GReelsPostState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield GReelsPostState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield GReelsPostState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is CreatePostEvent) {
      try {
        yield CreatePostState(ApiStatus.LOADING);

        final response = await homeRepository.CreatePost(
          event.thumbnail,
            event.contentType,
            event.postType,
            event.title,
            event.description,
            event.filePath);

        if (response != null) {
          yield CreatePostState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield CreatePostState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield CreatePostState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is GetUserProfileEvent) {
      try {
        yield GetUserProfileState(ApiStatus.LOADING);

        final response = await homeRepository.getUserProfile();

        if (response != null) {
          yield GetUserProfileState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield GetUserProfileState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA is : $e");
        yield GetUserProfileState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is UpdateUserProfileImageEvent) {
      try {
        yield UpdateUserProfileImageState(ApiStatus.LOADING);

        final response = await homeRepository.updateUserProfileImage(
            event.filePath, event.name, event.email);

        if (response != null) {
          yield UpdateUserProfileImageState(ApiStatus.SUCCESS,
              response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield UpdateUserProfileImageState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA is : $e");
        yield UpdateUserProfileImageState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is LikeContentEvent) {
      Log.v('calling api with ${event.contentId}');
      try {
        yield LikeContentState(ApiStatus.LOADING);

        final response = await homeRepository.likeContent(
            event.contentId, event.type, event.like);

        if (response != null) {
          yield LikeContentState(
            ApiStatus.SUCCESS,
          );
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield LikeContentState(
            ApiStatus.ERROR,
          );
        }
      } catch (e) {
        Log.v("ERROR DATA is : $e");
        yield LikeContentState(
          ApiStatus.ERROR,
        );
      }
    } else if (event is ReportEvent) {
      try {
        yield ReportState(ApiStatus.LOADING);

        final response = await homeRepository.reportContent(
            event.status, event.postId, event.category, event.comment);

        if (response != null) {
          yield ReportState(ApiStatus.SUCCESS, response: response);
        } else {
          yield ReportState(
            ApiStatus.ERROR,
          );
        }
      } catch (e) {
        Log.v("ERROR DATA is : $e");
        yield ReportState(
          ApiStatus.ERROR,
        );
      }
    } else if (event is DeletePostEvent) {
      try {
        yield DeletePostState(ApiStatus.LOADING);

        final response = await homeRepository.deletePost(event.postId);

        if (response != null) {
          yield DeletePostState(ApiStatus.SUCCESS, response: response);
        } else {
          yield DeletePostState(
            ApiStatus.ERROR,
          );
        }
      } catch (e) {
        Log.v("ERROR DATA is : $e");
        yield DeletePostState(
          ApiStatus.ERROR,
        );
      }
    } else if (event is UserAnalyticsEvent) {
      try {
        yield UserAnalyticsState(ApiStatus.LOADING);
        final response = await homeRepository.UserAnalytics();
        if (response.status == 1) {
          yield UserAnalyticsState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERRyyyOR DATA ::: ${response}");
          yield UserAnalyticsState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield UserAnalyticsState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is LearningSpaceEvent) {
      try {
        yield LearningSpaceState(ApiStatus.LOADING);
        final response = await homeRepository.learningSpace();
        if (response.status == 1) {
          yield LearningSpaceState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERRyyyOR DATA ::: ${response}");
          yield LearningSpaceState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA this : $e");
        yield LearningSpaceState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is CreatePortfolioEvent) {
      try {
        Map<String, dynamic> data = Map();
        var filePath = event.filePath;
        String fileName = filePath!.split('/').last;
        data['file'] =
            await MultipartFile.fromFile(filePath, filename: fileName);
        data['title'] = event.title;
        data['description'] = event.description;
        data['type'] = event.type;

        yield CreatePortfolioState(ApiStatus.LOADING);
        final response = await homeRepository.createPortfolio(data);
        if (response != null) {
          yield CreatePortfolioState(
            ApiStatus.SUCCESS,
          );
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield CreatePortfolioState(
            ApiStatus.ERROR,
          );
        }
      } catch (e) {
        Log.v("ERROR DATA is : $e");
        yield CreatePortfolioState(
          ApiStatus.ERROR,
        );
      }
    } else if (event is MasterBrandCreateEvent) {
      try {
        Map<String, dynamic> data = Map();
        var filePath = event.filePath;
        String fileName = filePath!.split('/').last;
        data['file'] =
            await MultipartFile.fromFile(filePath, filename: fileName);
        data['title'] = event.title;
        data['description'] = event.description;

        yield MasterBrandCreateState(ApiStatus.LOADING);
        final response = await homeRepository.masterBrandCreate(data);
        if (response != null) {
          yield MasterBrandCreateState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield MasterBrandCreateState(
            ApiStatus.ERROR,
          );
        }
      } catch (e) {
        Log.v("ERROR DATA is : $e");
        yield MasterBrandCreateState(
          ApiStatus.ERROR,
        );
      }
    } else if (event is UserBrandCreateEvent) {
      try {
        Map<String, dynamic> data = Map();
        var filePath = event.filePath;
        String fileName = filePath!.split('/').last;
        data['file'] =
            await MultipartFile.fromFile(filePath, filename: fileName);
        data['type_id'] = event.typeId;
        data['start_date'] = event.startDate;
        data['end_date'] = event.endDate;

        yield UserBrandCreateState(ApiStatus.LOADING);
        final response = await homeRepository.userBrandCreate(data);
        if (response != null) {
          yield UserBrandCreateState(
            ApiStatus.SUCCESS,
          );
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield UserBrandCreateState(
            ApiStatus.ERROR,
          );
        }
      } catch (e) {
        Log.v("ERROR DATA is : $e");
        yield UserBrandCreateState(
          ApiStatus.ERROR,
        );
      }
    } else if (event is DeletePortfolioEvent) {
      try {
        yield DeletePortfolioState(ApiStatus.LOADING);

        final response = await homeRepository.deletePortfolio(event.id);

        if (response != null) {
          yield DeletePortfolioState(
            ApiStatus.SUCCESS,
          );
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield DeletePortfolioState(
            ApiStatus.ERROR,
          );
        }
      } catch (e) {
        Log.v("ERROR DATA is : $e");
        yield DeletePortfolioState(
          ApiStatus.ERROR,
        );
      }
    } else if (event is ListPortfolioEvent) {
      try {
        yield ListPortfolioState(ApiStatus.LOADING);
        final response =
            await homeRepository.listPortfolio(event.type, event.userId);

        if (response != null) {
          yield ListPortfolioState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield ListPortfolioState(
            ApiStatus.ERROR,
          );
        }
      } catch (e) {
        Log.v("ERROR DATA is : $e");
        yield ListPortfolioState(
          ApiStatus.ERROR,
        );
      }
    } else if (event is UpdateVideoCompletionEvent) {
      try {
        yield UpdateVideoCompletionState(ApiStatus.LOADING);
        final response = await homeRepository.updateVideoCompletion(
            event.bookmark!, event.contentId!);
        if (response.status == 1) {
          yield UpdateVideoCompletionState(
            ApiStatus.SUCCESS,
          );
        } else {
          Log.v("ERRyyyOR DATA ::: ${response}");
          yield UpdateVideoCompletionState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield UpdateVideoCompletionState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    }
  }
}
