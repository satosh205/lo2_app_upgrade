import 'package:masterg/utils/config.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/config.dart';

class ApiConstants {
  /**Server url*/

  ///todo change Env to production when release to the client
  ///For Developer
  // static const PRODUCTION_BASE_URL = "https://learningoxygen.com/";
  //static const PRODUCTION_BASE_URL = "https://mylearning.learnandbuild.in/";

  static const DEV_BASE_URL = "https://learningoxygen.com/";

  //static const IMAGE_BASE_URL = 'https://learningoxygen.com/joy_content/';

  //todo before share this change it to production

  static const API_KEY = "nlms-api-key";
  //static const API_KEY_VALUE = "0612b32b39f4b29f48c5c5363028ee916bb10MasterGV1"; //Demo Test Dev
  static const API_KEY_VALUE = "0612b32b39f4b29f48c5c5363028ee916bb99TECH";

  String APIKeyValue() {
    return APK_DETAILS['nlms_api_key']!;
  } //Demo test Client

  String PRODUCTION_BASE_URL() {
    return APK_DETAILS['domain_url']!;
  }

  ///APIs
  static const LOGIN = "api/joy/signin";
  static const SIGNUP = "api/joy/signup";
  static const UPDATE_API = "api/swayam/os";

  /// swayam

  static const VERIFY_OTP = "api/joy/validate-opt";

  static const GET_CONTENT_API = "api/joy/content/";
  static const GET_ASSESSMENT_API = "api/assessment-list/";
  static const GET_ASSIGNMENT_API = "api/assignment/";
  static const LANGUAGE_API = "api/joy/language";
  static const APP_LANGUAGE_API = "api/joy/app-language";
  static const MASTER_LANGUAGE_API = "api/master-language";

  static const TRACK_ANNOUNCMENT_API = "api/joy/content-tracking";
  static const SUBSCRIBE_PROGRAM = "api/program/subscribe";
  static const TRACK_USER_ACTIVITY = "api/user-track-activity";
  static const BRAND_SEARCH = "api/master-brand-search";

  /// swayam language

  static const USER_PROFILE_API = "/api/profilev1";
  static const USER_PROFILE_SWAYAM_API = "api/joy/profile";
  static const USER_PROFILE_IMAGE_API = "/api/profile-update_v1";

  static const GET_PARTNER_API = "api/joy/rewards/partner_benefits";

  static const SUBMIT_REWARD_API = "api/joy/redeem-request";

  static const CATEGORY_API = "api/joy/category";

  static const ACTIVITY_ATTEMPT_API = "api/joy/activity-attempt";
  static const PROGRAMS_LIST = "api/learner/programs";
  static const SUBMIT_ASSIGNMENT = 'api/assignmentsubmit';
  static const CREATE_POST = "/api/create-post";

  static const MODULES = "api/learner/programs/modules";
  static const CONTENT_DETAILS = "api/learner/content";
  static const USER_ANALYTICS = "api/user-analytics";
  static const LEARNINGSPACE_DATA = "api/learning-space";
  static const ASSIGNMENT_DETAILS = 'api/assignment/';
  static const ASSESSMENT_INSTRUCTIONS = 'api/assessment-instructions/';
  static const ATTEMPT_ASSESSMENT = '/api/assessment-detail/';
  static const SAVE_ANSWER = '/api/assessment-submit';
  static const SUBMMIT_ANSWER = '/api/assessment-onfinish';
  static const ASSESSMENT_REVIEW = '/api/assessment-review/';
  static const ASSIGNMENT_SUBMISSION_DETAILS = '/api/assignmentdetails';
  static const UPDATE_COURSE_COMPLETION = "/api/program-content-attempt";

  static const JOY_CATEGORY = "/api/joy/category";
  static const JOY_CONTENT_LIST = "/api/joy/content";
  static const LIVECLASSLIST = "/api/onboard-sessions";
  static const COURSE_CATEGORY = "/api/category";
  static const INTEREST_PROGRAM_LIST = "/api/joy/category";
  static const MAP_INTEREST = "/api/courses/user-mapping";
  static const POPULARCOURSES = "/api/courses/popular";
  static const GCARVAAN_POST = "/api/carvan";
  static const GREELS_POST = "/api/reels";
  static const LIKE_CONTENT = "/api/user-view-tracking";
  static const REPORT_CONTENT = "/api/post-report";
  static const CREATE_PORTFOLIO = "/api/create-portfolio";
  static const USER_BRAND_CREATE = "/api/user-brand-create";
  static const MASTER_BRAND_CREATE = "/api/master-brand-create";
  static const PORTFOLIO = "/api/portfolio";

  static const COMMENT_LIST = "/api/comments";
  static const POST_COMMENT_LIST = "/api/user-comment-tracking";
  static const DELETE_POST = "/api/joy/content/delete/";

  static const COURSE_LIST = "/api/courses-list";
  static const FEATURED_VIDEOS = "/api/joy/content?is_featured=1";

  static const ANNOUNCEMENT_TYPE = "Announcement";
  static const TRAININGS = "Trainings";
  static const settings = "/api/settings";
  static const DASHBOARD_CONTENT = "/api/g-dashboard";
  static const NOTIFICATION_API = "api/joy/notifications";

  static const SWAYAM = 3;

  static const REPORT_PROGRAMS_LIST = "api/learner/programs-user";
  static const KPI_LIST = "api/learner/kpi";
  static const LEADERBOARD_LIST = "api/learner/course";
  static const REPORT_LEADERBOARD_LIST = "api/learner/reported-course";
  static const CERTIFICATES_LIST = "api/learner/kpi/certificates";
  static const MODULE_WISE_LEADERBOARD_LIST = "api/learner/module";
  static const REPORT_MODULE_WISE_LEADERBOARD_LIST =
      "api/learner/reported-module";

  static const FEEDBACK_API = "api/joy/feedback";
  static const TOPIC_API = "api/joy/feedback-topics";

  static const UPDATE_PROFILE_API = "api/joy/profile-update";
  static const STATE_API = "api/joy/state";
  static const CITY_API = "api/joy/city";
  static const TAGS_API = "api/joy/tags";

  static const LIBRARY_TYPE = "Library";
  static const SURVEY_API = "api/joy/survey";
  static const POLL_API = 'api/poll';
  static const SWAYAM_LOGIN = 'api/login';
  static const REMOVE_ACCOUNT = '/api/user/delete';
  static const USER_JOBS_LIST = '/api/user_jobs/list';
  static const COMPETITION_MODULE_DATA = '/api/competition-list';
}
