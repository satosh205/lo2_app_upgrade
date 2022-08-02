import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:injector/injector.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/home_request/user_program_subscribe.dart';
import 'package:masterg/data/models/request/save_answer_request.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/home_response/assignment_submissions_response.dart';
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
import 'package:masterg/data/models/response/home_response/user_program_subscribe_reponse.dart';
import 'package:masterg/data/repositories/home_repository.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';

import '../data/models/response/home_response/create_portfolio_response.dart';
import '../data/models/response/home_response/delete_portfolio_response.dart';
import '../data/models/response/home_response/list_portfolio_responsed.dart';
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
  UpdateUserProfileImageEvent({this.filePath}) : super([filePath]);

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

class CourseCategoryListIDState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  CourseCategoryListIdResponse? response;
  CourseCategoryListIdResponse? error;

  CourseCategoryListIDState(this.state, {this.response, this.error});
}

class CourseCategoryList2IDEvent extends HomeEvent {
  int? categoryId;

  CourseCategoryList2IDEvent({this.categoryId}) : super([categoryId]);

  List<Object> get props => throw UnimplementedError();
}

class CourseCategoryList2IDState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  CourseCategoryListIdResponse? response;
  String? error;

  CourseCategoryList2IDState(this.state, {this.response, this.error});
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
  GCarvaanPostEvent({this.callCount, this.postId}) : super([callCount, postId]);

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
  GReelsPostEvent() : super([]);

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

class CreatePostEvent extends HomeEvent {
  int? contentType;
  String? title;
  String? description;
  String? postType;
  List<MultipartFile>? files;
  List<String?>? filePath;

  CreatePostEvent(
      {this.contentType,
      this.title,
      this.description,
      this.postType,
      this.files,
      this.filePath})
      : super([title, description, postType, files, filePath]);

  List<Object> get props => throw UnimplementedError();
}

class CreatePostState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;
  CreatePostResponse? response;
  String? error;

  CreatePostState(this.state, {this.response, this.error});
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

class LikeContentState extends HomeState {
  ApiStatus state;

  ApiStatus get apiState => state;

  LikeContentState(
    this.state,
  );
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final homeRepository = Injector.appInstance.get<HomeRepository>();

  HomeBloc(HomeState initialState) : super(initialState);

  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is AnnouncementContentEvent) {
      try {
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
    } else if (event is ReviewTestEvent) {
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
          Log.v("ERROR DATA ::: ${response}");
          yield CourseCategoryListIDState(ApiStatus.ERROR, error: response);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield CourseCategoryListIDState(ApiStatus.ERROR,
            error: CourseCategoryListIdResponse());
      }
    } else if (event is CourseCategoryList2IDEvent) {
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
        Log.v("ERROR DATA : $e");
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
            await homeRepository.GCarvaanPost(event.callCount!, event.postId);

        if (response.data != null) {
          yield GCarvaanPostState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
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

        final response = await homeRepository.GReelsPost();

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
            event.files,
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

        final response =
            await homeRepository.updateUserProfileImage(event.filePath);

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
        Log.v("ERROR DATA : $e");
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
    }
  }
}
