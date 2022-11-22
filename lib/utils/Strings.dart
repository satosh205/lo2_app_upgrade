import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/utils/config.dart';

import 'en_file.dart';

class Strings {
  final Locale locale;
  static var somethingWentWrong = "Something went wrong";

  get faqTitle1 => _localizedValues[locale.languageCode]!['faqTitle1'];

  get faqTitle2 => _localizedValues[locale.languageCode]!['faqTitle2'];

  get faqTitle3 => _localizedValues[locale.languageCode]!['faqTitle3'];

  get faqTitle4 => _localizedValues[locale.languageCode]!['faqTitle4'];

  get faqTitle5 => _localizedValues[locale.languageCode]!['faqTitle5'];

  get faqTitle6 => _localizedValues[locale.languageCode]!['faqTitle6'];

  get faqTitle7 => _localizedValues[locale.languageCode]!['faqTitle7'];

  get faqTitle8 => _localizedValues[locale.languageCode]!['faqTitle8'];

  get faqTitle9 => _localizedValues[locale.languageCode]!['faqTitle9'];

  get faqTitle10 => _localizedValues[locale.languageCode]!['faqTitle10'];

  get faqTitle11 => _localizedValues[locale.languageCode]!['faqTitle11'];

  get faq1 => _localizedValues[locale.languageCode]!['faq1'];

  get faq2 => _localizedValues[locale.languageCode]!['faq2'];

  get faq3 => _localizedValues[locale.languageCode]!['faq3'];

  get faq4 => _localizedValues[locale.languageCode]!['faq4'];

  get faq5 => _localizedValues[locale.languageCode]!['faq5'];

  get faq6 => _localizedValues[locale.languageCode]!['faq6'];

  get faq7 => _localizedValues[locale.languageCode]!['faq7'];

  get faq8 => _localizedValues[locale.languageCode]!['faq8'];

  get faq9 => _localizedValues[locale.languageCode]!['faq9'];

  get faq10 => _localizedValues[locale.languageCode]!['faq10'];

  get faq11 => _localizedValues[locale.languageCode]!['faq11'];

  Strings(this.locale);

  get name => _localizedValues[locale.languageCode]!['name'];

  get enterName => _localizedValues[locale.languageCode]!['enter_name'];

  get contact => _localizedValues[locale.languageCode]!['contact'];

  get enterContact => _localizedValues[locale.languageCode]!['enter_contact'];

  get email => _localizedValues[locale.languageCode]!['email'];

  get enterEmail => _localizedValues[locale.languageCode]!['enter_email'];

  String? get male => _localizedValues[locale.languageCode]!['male'];
  String? get reportThisPost =>
      _localizedValues[locale.languageCode]!['reportThisPost'];
  String? get removeHidePost =>
      _localizedValues[locale.languageCode]!['removeHidePost'];
  String? get loadingComment =>
      _localizedValues[locale.languageCode]!['loadingComment'];
  String? get writeYourComment =>
      _localizedValues[locale.languageCode]!['writeYourComment'];
  String? get writeAComment =>
      _localizedValues[locale.languageCode]!['writeAComment'];
  String? get enrollments =>
      _localizedValues[locale.languageCode]!['enrollments'];

  String? get trainerName =>
      _localizedValues[locale.languageCode]!['trainerName'];
  String? get studentsAlreadyEnrolled =>
      _localizedValues[locale.languageCode]!['studentsAlreadyEnrolled'];
  String? get enrollNow => _localizedValues[locale.languageCode]!['enrollNow'];
  String? get request => _localizedValues[locale.languageCode]!['request'];
  String? get noActiveProgram =>
      _localizedValues[locale.languageCode]!['noActiveProgram'];
  String? get submitBefore =>
      _localizedValues[locale.languageCode]!['submitBefore'];
  String? get marks => _localizedValues[locale.languageCode]!['marks'];
  String? get create => _localizedValues[locale.languageCode]!['create'];
  String? get deleteThisPost =>
      _localizedValues[locale.languageCode]!['deleteThisPost'];
  String? get deletePost =>
      _localizedValues[locale.languageCode]!['deletePost'];
  String? get areYouSureDelete =>
      _localizedValues[locale.languageCode]!['areYouSureDelete'];
  String? get noContentFound =>
      _localizedValues[locale.languageCode]!['noContentFound'];
  String? get multipleAttempts =>
      _localizedValues[locale.languageCode]!['multipleAttempts'];
  String? get startAssignment =>
      _localizedValues[locale.languageCode]!['startAssignment'];
  String? get nowPlaying =>
      _localizedValues[locale.languageCode]!['nowPlaying'];
  String? get viewNote => _localizedValues[locale.languageCode]!['viewNote'];
  String? get startQuiz => _localizedValues[locale.languageCode]!['startQuiz'];
  String? get months => _localizedValues[locale.languageCode]!['months'];
  String? get days => _localizedValues[locale.languageCode]!['days'];
  String? get seeMore => _localizedValues[locale.languageCode]!['seeMore'];
  String? get seeLess => _localizedValues[locale.languageCode]!['seeLess'];
  String? get d => _localizedValues[locale.languageCode]!['d'];
  String? get mos => _localizedValues[locale.languageCode]!['mos'];
  String? get w => _localizedValues[locale.languageCode]!['w'];
  String? get h => _localizedValues[locale.languageCode]!['h'];
  String? get m => _localizedValues[locale.languageCode]!['m'];
  String? get commentCantBlank =>
      _localizedValues[locale.languageCode]!['commentCantBlank'];
  String? get justNow => _localizedValues[locale.languageCode]!['justNow'];
  String? get s => _localizedValues[locale.languageCode]!['s'];

  String? get phone => _localizedValues[locale.languageCode]!['phone'];
  String? get branchAssociation =>
      _localizedValues[locale.languageCode]!['branchAssociation'];
  String? get addBrand => _localizedValues[locale.languageCode]!['addBrand'];
  String? get brandName => _localizedValues[locale.languageCode]!['brandName'];
  String? get uploadBrandLogo =>
      _localizedValues[locale.languageCode]!['uploadBrandLogo'];
  String? get supportedFormat =>
      _localizedValues[locale.languageCode]!['supportedFormat'];
  String? get uploadJoiningLetter =>
      _localizedValues[locale.languageCode]!['uploadJoiningLetter'];
  String? get error => _localizedValues[locale.languageCode]!['error'];
  String? get pleaseSelectedJoiningLetter =>
      _localizedValues[locale.languageCode]!['pleaseSelectedJoiningLetter'];
  String? get pleaseSelectFromDate =>
      _localizedValues[locale.languageCode]!['pleaseSelectFromDate'];
  String? get pleaseSelectValidJoiningDate =>
      _localizedValues[locale.languageCode]!['pleaseSelectValidJoiningDate'];
  String? get areYourSureYouWantToDelete =>
      _localizedValues[locale.languageCode]!['areYourSureYouWantToDelete'];
  String? get youHaveNotAddedAnyBrandYet =>
      _localizedValues[locale.languageCode]!['youHaveNotAddedAnyBrandYet'];
  String? get addABrandAndLetEveryoneKnowAboutYourBrandAssociations =>
      _localizedValues[locale.languageCode]![
          'addABrandAndLetEveryoneKnowAboutYourBrandAssociations'];
  String? get from => _localizedValues[locale.languageCode]!['from'];
  String? get to => _localizedValues[locale.languageCode]!['to'];
  String? get fromDate => _localizedValues[locale.languageCode]!['fromDate'];
  String? get present => _localizedValues[locale.languageCode]!['present'];
  String? get toDate => _localizedValues[locale.languageCode]!['toDate'];
  String? get awards => _localizedValues[locale.languageCode]!['awards'];
  String? get awardsAssociations =>
      _localizedValues[locale.languageCode]!['awardsAssociations'];
  String? get projects => _localizedValues[locale.languageCode]!['projects'];

  String? get female => _localizedValues[locale.languageCode]!['female'];

  String? get sendOTP => _localizedValues[locale.languageCode]!['send_otp'];

  String? get forgotpasswordcaps =>
      _localizedValues[locale.languageCode]!['forgot_pass'];

  String? get photoAlert =>
      _localizedValues[locale.languageCode]!['photo_alert'];

  String? get verification =>
      _localizedValues[locale.languageCode]!['verification'];

  get familyMember => _localizedValues[locale.languageCode]!['family_member'];

  String? get you_can_change_langauge =>
      _localizedValues[locale.languageCode]!['you_can_change_langauge'];

  String? get submitted => _localizedValues[locale.languageCode]!['submitted'];

  String? get chooseLanguage =>
      _localizedValues[locale.languageCode]!['choose_language'];

  String? get updateProfile =>
      _localizedValues[locale.languageCode]!['update_profile'];

  String? get gender => _localizedValues[locale.languageCode]!['gender'];
  String? get forYou => _localizedValues[locale.languageCode]!['forYou'];

  static Strings? of(BuildContext context) {
    // Locale myLocale = Localizations.localeOf(context);
    // debugPrint(myLocale.languageCode);
    return Localizations.of<Strings>(context, Strings);
  }

  String? get yes => _localizedValues[locale.languageCode]!['yes'];

  String? get no => _localizedValues[locale.languageCode]!['no'];

  String? get login => _localizedValues[locale.languageCode]!['login'];

  String? get alert => _localizedValues[locale.languageCode]!['alert'];
  String? get hello => _localizedValues[locale.languageCode]!['hello'];

  String? get coinHistoryTitle =>
      _localizedValues[locale.languageCode]!['coin_history_title'];

  String? get logout => _localizedValues[locale.languageCode]!['logout'];
  String? get editProfile =>
      _localizedValues[locale.languageCode]!['editProfile'];
  String? get editPortfolio =>
      _localizedValues[locale.languageCode]!['edit_portfolio'];

  String? get profileTitle =>
      _localizedValues[locale.languageCode]!['profile_title'];

  String? get cancel => _localizedValues[locale.languageCode]!['cancel'];
  String? get enterValidOtp =>
      _localizedValues[locale.languageCode]!['enterValidOtp'];
  String? get enterOtp => _localizedValues[locale.languageCode]!['enterOtp'];
  String? get noPostAvailable =>
      _localizedValues[locale.languageCode]!['noPostAvailable'];
  String? get imageVideoSizeLarge =>
      _localizedValues[locale.languageCode]!['imageVideoSizeLarge'];
  String? get only4ImagesVideosAllowed =>
      _localizedValues[locale.languageCode]!['only4ImagesVideosAllowed'];
  String? get writeAPost =>
      _localizedValues[locale.languageCode]!['writeAPost'];
  String? get photo => _localizedValues[locale.languageCode]!['photo'];
  String? get video => _localizedValues[locale.languageCode]!['video'];
  String? get emailIsRequired =>
      _localizedValues[locale.languageCode]!['emailIsRequired'];

  String? get takeAPicture =>
      _localizedValues[locale.languageCode]!['take_a_picture'];

  String? get pickFromGallery =>
      _localizedValues[locale.languageCode]!['pick_from_gallery'];

  String? get takeAVideo =>
      _localizedValues[locale.languageCode]!['take_a_video'];

  String? get pickAVideo =>
      _localizedValues[locale.languageCode]!['pick_a_video'];

  String? get pickAFile =>
      _localizedValues[locale.languageCode]!['pick_a_file'];

  String? get termAndCondition =>
      _localizedValues[locale.languageCode]!['term_and_condition'];

  String? get ok => _localizedValues[locale.languageCode]!['ok'];

  String? get loading => _localizedValues[locale.languageCode]!['loading'];

  String? get enterLoginText =>
      _localizedValues[locale.languageCode]!['enter_login_text'];

  String? get requestOtp =>
      _localizedValues[locale.languageCode]!['request_otp'];

  String? get createAnAccount =>
      _localizedValues[locale.languageCode]!['create_an_account'];

  String? get verificationTitle =>
      _localizedValues[locale.languageCode]!['verification_title'];

  String? get submit => _localizedValues[locale.languageCode]!['submit'];

  String? get resend => _localizedValues[locale.languageCode]!['resend'];

  String? get codeIn => _localizedValues[locale.languageCode]!['code_in'];

  String? get engangement =>
      _localizedValues[locale.languageCode]!['engangement'];

  String? get dealer => _localizedValues[locale.languageCode]!['dealer'];

  String? get selectSection =>
      _localizedValues[locale.languageCode]!['select_section'];

  String? get announcements =>
      _localizedValues[locale.languageCode]!['announcements'];

  String? get assessments =>
      _localizedValues[locale.languageCode]!['assessments'];

  String? get assignments =>
      _localizedValues[locale.languageCode]!['assignments'];

  String? get mandatoryCourses =>
      _localizedValues[locale.languageCode]!['mandatory_courses'];

  String? get training => _localizedValues[locale.languageCode]!["training"];

  String? get learnNewEveryday =>
      _localizedValues[locale.languageCode]!["learnNewEveryday"];

  String? get topPicksCourses =>
      _localizedValues[locale.languageCode]!["topPicksCourses"];
  String? get recommendedCourses =>
      _localizedValues[locale.languageCode]!["recommendedCourses"];
  String? get otherLearnerCourses =>
      _localizedValues[locale.languageCode]!["otherLearnerCourses"];
  String? get otherLearnerCoursesMasterG =>
      _localizedValues[locale.languageCode]!["otherLearnerCoursesMasterG"];

  String? get shortCourses =>
      _localizedValues[locale.languageCode]!["shortCourses"];

  String? get highlyRatedCourses =>
      _localizedValues[locale.languageCode]!["highlyRatedCourses"];

  String? get MyClasses => _localizedValues[locale.languageCode]!["myclasses"];

  String? get MyAssignments =>
      _localizedValues[locale.languageCode]!["myassignments"];
  String? get MyAssessments =>
      _localizedValues[locale.languageCode]!["myassessments"];

  String? get mostViewedCourses =>
      _localizedValues[locale.languageCode]!["mostViewedCourses"];

  String? get byInstructorName =>
      _localizedValues[locale.languageCode]!["byInstructorName"];

  String? get library => _localizedValues[locale.languageCode]!['library'];

  String? get analytics => _localizedValues[locale.languageCode]!['analytics'];

  String? get createASession =>
      _localizedValues[locale.languageCode]!['create_a_session'];

  String? get myCertificates =>
      _localizedValues[locale.languageCode]!['my_certificates'];

  String? get scheduledSessions =>
      _localizedValues[locale.languageCode]!['scheduled_sessions'];

  String? get askingRateCalculator =>
      _localizedValues[locale.languageCode]!['asking_rate_calculator'];

  String? get feedback => _localizedValues[locale.languageCode]!['feedback'];

  String? get survey => _localizedValues[locale.languageCode]!['survey'];

  String? get language => _localizedValues[locale.languageCode]!['language'];

  String? get accountSettings =>
      _localizedValues[locale.languageCode]!['account_settings'];

  String? get fAQs => _localizedValues[locale.languageCode]!['FAQs'];
  String? get faq => _localizedValues[locale.languageCode]!['FAQ'];

  String? get contactUs => _localizedValues[locale.languageCode]!['contact_us'];
  String? get changePassword =>
      _localizedValues[locale.languageCode]!['change_password'];

  String? get aboutPerfettiJoy =>
      _localizedValues[locale.languageCode]!['about_perfetti_Joy'];

  String? get termsAndConditions =>
      _localizedValues[locale.languageCode]!['terms_and_conditions'];

  String? get privacyPolicy =>
      _localizedValues[locale.languageCode]!['privacy_policy'];

  String? get viewAll => _localizedValues[locale.languageCode]!['view_all'];

  String? get startSurvey =>
      _localizedValues[locale.languageCode]!['start_survey'];

  String? get announcementFilters =>
      _localizedValues[locale.languageCode]!['announcement_filters'];

  String? get writeFeedback =>
      _localizedValues[locale.languageCode]!['write_feedback'];

  String? get writeAnIdea =>
      _localizedValues[locale.languageCode]!['write_an_idea'];

  String? get libraryFilters =>
      _localizedValues[locale.languageCode]!['library_filters'];

  String? get rewards => _localizedValues[locale.languageCode]!['rewards'];

  String? get games => _localizedValues[locale.languageCode]!['games'];

  String? get partnerBenefits =>
      _localizedValues[locale.languageCode]!['partner_benefits'];

  String? get storyboard =>
      _localizedValues[locale.languageCode]!['storyboard'];

  String? get yourPoints =>
      _localizedValues[locale.languageCode]!['your_points'];

  String? get likes => _localizedValues[locale.languageCode]!['likes'];

  String? get share => _localizedValues[locale.languageCode]!['share'];

  String? get winUpto => _localizedValues[locale.languageCode]!['win_upto'];

  String? get points => _localizedValues[locale.languageCode]!['points'];

  String? get searchGame =>
      _localizedValues[locale.languageCode]!['search_game'];

  String? get yourBestScore =>
      _localizedValues[locale.languageCode]!['your_best_score'];

  String? get playNow => _localizedValues[locale.languageCode]!['play_now'];

  String? get howToPlay =>
      _localizedValues[locale.languageCode]!['how_to_play'];

  String? get yourScore => _localizedValues[locale.languageCode]!['your_score'];

  String? get gameOver => _localizedValues[locale.languageCode]!['game_over'];

  String? get playAgain => _localizedValues[locale.languageCode]!['play_again'];

  String? get viewCoinHistory =>
      _localizedValues[locale.languageCode]!['view_coin_history'];

  String? get rewardCatalogue =>
      _localizedValues[locale.languageCode]!['reward_catalogue'];

  String? get claimedReward =>
      _localizedValues[locale.languageCode]!['claimed_reward'];

  String? get coins => _localizedValues[locale.languageCode]!['coins'];

  String? get reedem => _localizedValues[locale.languageCode]!['reedem'];

  String? get notifications =>
      _localizedValues[locale.languageCode]!['notifications'];

  String? get profile => _localizedValues[locale.languageCode]!['profile'];

  String? get address => _localizedValues[locale.languageCode]!['address'];

  String? get socialMedia =>
      _localizedValues[locale.languageCode]!['social_media'];

  String? get addFamilyMember =>
      _localizedValues[locale.languageCode]!['add_family_member'];

  String? get businessDetails =>
      _localizedValues[locale.languageCode]!['business_details'];

  String? get businessAddress =>
      _localizedValues[locale.languageCode]!['business_address'];

  String? get landmark => _localizedValues[locale.languageCode]!['landmark'];

  String? get postOffice =>
      _localizedValues[locale.languageCode]!['post_office'];

  String? get city => _localizedValues[locale.languageCode]!['city'];

  String? get state => _localizedValues[locale.languageCode]!['state'];

  String? get saveChanges =>
      _localizedValues[locale.languageCode]!['save_changes'];

  String? get whatsapp => _localizedValues[locale.languageCode]!['whatsapp'];

  String? get facebookId =>
      _localizedValues[locale.languageCode]!['facebook_id'];

  String? get insta => _localizedValues[locale.languageCode]!['insta'];

  String? get twitterHandle =>
      _localizedValues[locale.languageCode]!['twitter_handle'];

  String? get gstNumber => _localizedValues[locale.languageCode]!['gst_number'];

  String? get panNumber => _localizedValues[locale.languageCode]!['pan_number'];

  String? get save => _localizedValues[locale.languageCode]!['save'];

  String? get bonding => _localizedValues[locale.languageCode]!['bonding'];

  String? get connection =>
      _localizedValues[locale.languageCode]!['connection'];

  String? get recoginsion =>
      _localizedValues[locale.languageCode]!['recoginsion'];

  String? get definition =>
      _localizedValues[locale.languageCode]!['definition'];

  String? get eligibilityMembership =>
      _localizedValues[locale.languageCode]!['eligibility_membership'];

  String? get benfitsText =>
      _localizedValues[locale.languageCode]!['benfits_text'];

  String? get benefits => _localizedValues[locale.languageCode]!['benefits'];

  String? get general => _localizedValues[locale.languageCode]!['General'];

  String? get thePoints => _localizedValues[locale.languageCode]!['the_points'];

  String? get changeLanguage =>
      _localizedValues[locale.languageCode]!['change_language'];

  String? get membershipBenefits =>
      _localizedValues[locale.languageCode]!['membership_benefits'];

  String? get changeMyNumber =>
      _localizedValues[locale.languageCode]!['change_my_number'];

  String? get previous => _localizedValues[locale.languageCode]!['previous'];

  String? get next => _localizedValues[locale.languageCode]!['next'];

  String? get appLanguage =>
      _localizedValues[locale.languageCode]!['app_language'];

  String? get contentLanguage =>
      _localizedValues[locale.languageCode]!['content_language'];

  String? get chooseAppLanguage =>
      _localizedValues[locale.languageCode]!['choose_app_language'];

  String? get chooseContentLanguage =>
      _localizedValues[locale.languageCode]!['choose_content_language'];

  String? get addedFamilyMembers =>
      _localizedValues[locale.languageCode]!['added_family_members'];

  String? get relationWithFamily =>
      _localizedValues[locale.languageCode]!['relation_with_family'];

  String? get firstName => _localizedValues[locale.languageCode]!['first_name'];

  String? get lastName => _localizedValues[locale.languageCode]!['last_name'];

  String? get dateOfBirth =>
      _localizedValues[locale.languageCode]!['date_of_birth'];

  String? get mobileNumber =>
      _localizedValues[locale.languageCode]!['mobile_number'];

  String? get occupation =>
      _localizedValues[locale.languageCode]!['occupation'];

  String? get emailAddress =>
      _localizedValues[locale.languageCode]!['email_address'];
  String? get emailAddressError =>
      _localizedValues[locale.languageCode]!['email_address_error'];

  String? get title => _localizedValues[locale.languageCode]!['title'];

  String? get topic => _localizedValues[locale.languageCode]!['topic'];

  String? get description =>
      _localizedValues[locale.languageCode]!['description'];

  String? get attachFile =>
      _localizedValues[locale.languageCode]!['attachFile'];

  String? get selectAppLanguage =>
      _localizedValues[locale.languageCode]!['select_app_language'];

  String? get languageOption =>
      _localizedValues[locale.languageCode]!['language_option'];

  String? get selectContentLanguage =>
      _localizedValues[locale.languageCode]!['select_content_language'];

  String? get updateVersionTitle =>
      _localizedValues[locale.languageCode]!['update_version_title'];

  String? get updateVersionText1 =>
      _localizedValues[locale.languageCode]!['update_version_text1'];

  String? get updateVersionText2 =>
      _localizedValues[locale.languageCode]!['update_version_text2'];

  String? get Idea_Factory =>
      _localizedValues[locale.languageCode]!['Idea_Factory'];

  String? get Create_Live_Class =>
      _localizedValues[locale.languageCode]!['Create_Live_Class'];

  String? get Schedule_Now =>
      _localizedValues[locale.languageCode]!['Schedule_Now'];

  String? get Create_a_Session =>
      _localizedValues[locale.languageCode]!['Create_a_Session'];

  String? get Select_Title =>
      _localizedValues[locale.languageCode]!['Select_Title'];

  String? get Select_Date =>
      _localizedValues[locale.languageCode]!['Select_Date'];

  String? get Invite_learners =>
      _localizedValues[locale.languageCode]!['Invite_learners'];

  String? get Members_added =>
      _localizedValues[locale.languageCode]!['Members_added'];

  String? get Publish_Now =>
      _localizedValues[locale.languageCode]!['Publish_Now'];

  String? get Save_as_draft =>
      _localizedValues[locale.languageCode]!['Save_as_draft'];

  String? get Schedules_Sessions =>
      _localizedValues[locale.languageCode]!['Schedules_Sessions'];

  String? get Upcoming_Sessions =>
      _localizedValues[locale.languageCode]!['Upcoming_Sessions'];

  String? get Draft => _localizedValues[locale.languageCode]!['Draft'];

  String? get What_to_expect =>
      _localizedValues[locale.languageCode]!['What_to_expect'];

  String? get Start_date =>
      _localizedValues[locale.languageCode]!['Start_date'];

  String? get End_date => _localizedValues[locale.languageCode]!['End_date'];

  String? get Modules_included =>
      _localizedValues[locale.languageCode]!['Modules_included'];

  String? get List_of_modules =>
      _localizedValues[locale.languageCode]!['List_of_modules'];

  String? get Content => _localizedValues[locale.languageCode]!['Content'];

  String? get Scorm => _localizedValues[locale.languageCode]!['Scorm'];

  String? get Live_sessions =>
      _localizedValues[locale.languageCode]!['Live_sessions'];

  String? get Videos => _localizedValues[locale.languageCode]!['Videos'];

  String? get Notes => _localizedValues[locale.languageCode]!['Notes'];

  String? get Assignment =>
      _localizedValues[locale.languageCode]!['Assignment'];

  String? get Assessment =>
      _localizedValues[locale.languageCode]!['Assessment'];

  String? get Define_your_self =>
      _localizedValues[locale.languageCode]!['Define_your_self'];

  String? get Certification =>
      _localizedValues[locale.languageCode]!['Certification'];

  String? get My_Analytics =>
      _localizedValues[locale.languageCode]!['My_Analytics'];

  String? get Team_Analytics =>
      _localizedValues[locale.languageCode]!['Team_Analytics'];

  String? get KPI_Analytics =>
      _localizedValues[locale.languageCode]!['KPI_Analytics'];

  String? get Course_level_Analysis =>
      _localizedValues[locale.languageCode]!['Course_level_Analysis'];

  String? get Module_level_Analysis =>
      _localizedValues[locale.languageCode]!['Module_level_Analysis'];

  String? get Leaderboard =>
      _localizedValues[locale.languageCode]!['Leaderboard'];

  String? get Switch_to_modules =>
      _localizedValues[locale.languageCode]!['Switch_to_modules'];

  String? get Switch_to_leaderboard =>
      _localizedValues[locale.languageCode]!['Switch_to_leaderboard'];

  String? get Completed => _localizedValues[locale.languageCode]!['Completed'];

  String? get Score => _localizedValues[locale.languageCode]!['Score'];

  String? get Course_name =>
      _localizedValues[locale.languageCode]!['Course_name'];

  String? get KPIs_assigned =>
      _localizedValues[locale.languageCode]!['KPIs_assigned'];

  String? get Monthly_performance =>
      _localizedValues[locale.languageCode]!['Monthly_performance'];

  String? get My_certificates =>
      _localizedValues[locale.languageCode]!['My_certificates'];

  String? get Your_medals =>
      _localizedValues[locale.languageCode]!['Your_medals'];

  String? get Certificates =>
      _localizedValues[locale.languageCode]!['Certificates'];

  String? get Set_your_goals =>
      _localizedValues[locale.languageCode]!['Set_your_goals'];

  String? get Select_your_goal =>
      _localizedValues[locale.languageCode]!['Select_your_goal'];

  String? get Calculate_now =>
      _localizedValues[locale.languageCode]!['Calculate_now'];

  String? get Billed_outlets =>
      _localizedValues[locale.languageCode]!['Billed_outlets'];

  String? get Targeted_outlets =>
      _localizedValues[locale.languageCode]!['Targeted_outlets'];

  String? get Target => _localizedValues[locale.languageCode]!['Target'];

  String? get Currently_achieved =>
      _localizedValues[locale.languageCode]!['Currently_achieved'];

  String? get Total_MSS_Points =>
      _localizedValues[locale.languageCode]!['Total_MSS_Points'];

  String? get Calculated_asking_rate =>
      _localizedValues[locale.languageCode]!['Calculated_asking_rate'];

  String? get verify_your_mobile =>
      _localizedValues[locale.languageCode]!['verify_your_mobile'];

  String? get Manage_your_everyday =>
      _localizedValues[locale.languageCode]!['Manage_your_everyday'];

  String? get For_next => _localizedValues[locale.languageCode]!['For_next'];

  String? get Days => _localizedValues[locale.languageCode]!['Days'];

  String? get Details => _localizedValues[locale.languageCode]!['Details'];

  String? get time => _localizedValues[locale.languageCode]!['time'];

  String? get duration => _localizedValues[locale.languageCode]!['duration'];

  //Login Page
  String? get loginCreateAccount =>
      _localizedValues[locale.languageCode]!['login_create_account'];
  String? get phoneNumber =>
      _localizedValues[locale.languageCode]!['phone_number'];
  String? get yourMobileNumber =>
      _localizedValues[locale.languageCode]!['your_mobile_number'];
  String? get continueStr => _localizedValues[locale.languageCode]!['continue'];
  String? get byClickingContinue =>
      _localizedValues[locale.languageCode]!['by_clicking_continue'];
  String? get byClickingContinueUnderline =>
      _localizedValues[locale.languageCode]!['by_clicking_continue_underline'];
  String? get havingTrouble =>
      _localizedValues[locale.languageCode]!['having_trouble'];
  String? get changePhoneNumber =>
      _localizedValues[locale.languageCode]!['change_phone_number'];
  String? get LetsStartYourJourney =>
      _localizedValues[locale.languageCode]!['Lets_start_your_journey'];
  String? get GiveYourCreativityNewPath =>
      _localizedValues[locale.languageCode]!['giving_your_creativity'];
  String? get TellUsAboutYourSelf =>
      _localizedValues[locale.languageCode]!['tell_us_about_yourself'];
  String? get SelectCategories =>
      _localizedValues[locale.languageCode]!['select_categories'];
  String? get EnterFullName =>
      _localizedValues[locale.languageCode]!['enter_full_name'];
  String? get ChooseImage =>
      _localizedValues[locale.languageCode]!['choose_image'];
  String? get ChooseImageDescription =>
      _localizedValues[locale.languageCode]!['choose_image_description'];
  String? get Gallery => _localizedValues[locale.languageCode]!['gallery'];
  String? get camera => _localizedValues[locale.languageCode]!['camera'];

  String? get ChooseProfileImage =>
      _localizedValues[locale.languageCode]!['choose_profile_image'];
  String? get ChangeProfileImage =>
      _localizedValues[locale.languageCode]!['change_profile_image'];
  String? get PhoneAlreadyRegisterd =>
      _localizedValues[locale.languageCode]!['phone_already_exists'];
  String? get UseAnotherPhone =>
      _localizedValues[locale.languageCode]!['use_another_phone'];
  String? get ChooseYourInterests =>
      _localizedValues[locale.languageCode]!['choose_your_interests'];
  String? get SelectAleastSixCategories =>
      _localizedValues[locale.languageCode]!['select_aleast_six_categories'];

  String? get createPost =>
      _localizedValues[locale.languageCode]!['create_post'];
  String? get CreateReels =>
      _localizedValues[locale.languageCode]!['create_reels'];
  String? get GHome => _localizedValues[locale.languageCode]!['ghome'];
  String? get GReels => _localizedValues[locale.languageCode]!['greels'];
  String? get GCarvaan => _localizedValues[locale.languageCode]!['gcarvaan'];
  String? get GShool => _localizedValues[locale.languageCode]!['gschool'];
  String? get Like => _localizedValues[locale.languageCode]!['like'];
  String? get Comment => _localizedValues[locale.languageCode]!['comment'];
  String? get Views => _localizedValues[locale.languageCode]!['views'];
  String? get Reels => _localizedValues[locale.languageCode]!['reels'];
  String? get Share => _localizedValues[locale.languageCode]!['share'];
  String? get WriteYourPost =>
      _localizedValues[locale.languageCode]!['write_your_post'];
  String? get AddMore => _localizedValues[locale.languageCode]!['add_more'];
  String? get CategoryNotFound =>
      _localizedValues[locale.languageCode]!['category_not_found'];
  String? get ThereAreNoRecentActivity =>
      _localizedValues[locale.languageCode]!['there_are_no_recent_activity'];
  String? get ApniPadhaiJaariRakein =>
      _localizedValues[locale.languageCode]!['apni_padhai_jaari_rakein'];

  String? get recent_activity =>
      _localizedValues[locale.languageCode]!['recent_activity'];

  String? get resumelearning =>
      _localizedValues[locale.languageCode]!['resumelearning'];

  String? get RecentActivies =>
      _localizedValues[locale.languageCode]!['recent_activity'];
  String? get MyCourses => _localizedValues[locale.languageCode]!['my_courses'];
  String? get MyQuiz => _localizedValues[locale.languageCode]!['my_quiz'];
  String? get sortBy => _localizedValues[locale.languageCode]!['sort_by'];
  String? get all => _localizedValues[locale.languageCode]!['all'];
  String? get pending => _localizedValues[locale.languageCode]!['pending'];
  String? get upcoming => _localizedValues[locale.languageCode]!['upcoming'];
  String? get ongoing => _localizedValues[locale.languageCode]!['Ongoing'];
  String? get deleteAccount =>
      _localizedValues[locale.languageCode]!['deleteAccount'];
  String? get settingAndAccount =>
      _localizedValues[locale.languageCode]!['settingAndAccount'];
  String? get enterBrandName =>
      _localizedValues[locale.languageCode]!['enterBrandName'];
  String? get suggestedBrand =>
      _localizedValues[locale.languageCode]!['suggestedBrand'];
  String? get pleaseSelectBrand =>
      _localizedValues[locale.languageCode]!['pleaseSelectBrand'];
  String? get selectTenure =>
      _localizedValues[locale.languageCode]!['selectTenure'];
  String? get noActiveCourses =>
      _localizedValues[locale.languageCode]!['noActiveCourses'];
  String? get subscribeToCourseToGetStarted =>
      _localizedValues[locale.languageCode]!['subscribeToCourseToGetStarted'];
  String? get areYouSureYouWantToExit =>
      _localizedValues[locale.languageCode]!['areYouSureYouWantToExit'];
  String? get leavingSoSoon =>
      _localizedValues[locale.languageCode]!['leavingSoSoon'];

  String? get upcomingQuiz =>
      _localizedValues[locale.languageCode]!['upcomingQuiz'];
  String? get quizCompleted =>
      _localizedValues[locale.languageCode]!['quizCompleted'];
  String? get quizPending =>
      _localizedValues[locale.languageCode]!['quizPending'];
  String? get dailyQuiz => _localizedValues[locale.languageCode]!['dailyQuiz'];
  String? get noAssessmentAvailable =>
      _localizedValues[locale.languageCode]!['noAssessmentAvailable'];
  String? get assessmentSubmissionNotReady =>
      _localizedValues[locale.languageCode]!['assessmentSubmissionNotReady'];
  String? get assessmentSubmissionDeadlineOver => _localizedValues[
      locale.languageCode]!['assessmentSubmissionDeadlineOver'];
  String? get attemptLeft =>
      _localizedValues[locale.languageCode]!['attemptLeft'];
  String? get report => _localizedValues[locale.languageCode]!['report'];
  String? get upcomingAssignment =>
      _localizedValues[locale.languageCode]!['upcomingAssignment'];
  String? get assignmentCompleted =>
      _localizedValues[locale.languageCode]!['assignmentCompleted'];
  String? get assignmentPending =>
      _localizedValues[locale.languageCode]!['assignmentPending'];
  String? get myAssignments =>
      _localizedValues[locale.languageCode]!['myAssignments'];
  String? get noAssignmentsAvailable =>
      _localizedValues[locale.languageCode]!['noAssignmentsAvailable'];
  String? get assignmentNotReady =>
      _localizedValues[locale.languageCode]!['assignmentNotReady'];
  String? get assignmentDeadline =>
      _localizedValues[locale.languageCode]!['assignmentDeadline'];
  String? get deadline => _localizedValues[locale.languageCode]!['deadline'];
  String? get scoreEarned =>
      _localizedValues[locale.languageCode]!['scoreEarned'];
  String? get ongoingClass =>
      _localizedValues[locale.languageCode]!['ongoingClass'];
  String? get upcomingClass =>
      _localizedValues[locale.languageCode]!['upcomingClass'];
  String? get classCompleted =>
      _localizedValues[locale.languageCode]!['classCompleted'];
  String? get noClassesAvailable =>
      _localizedValues[locale.languageCode]!['noClassesAvailable'];
  String? get liveNow => _localizedValues[locale.languageCode]!['liveNow'];
  String? get live => _localizedValues[locale.languageCode]!['live'];
  String? get classroom => _localizedValues[locale.languageCode]!['classroom'];
  String? get comingSoon =>
      _localizedValues[locale.languageCode]!['comingSoon'];
  String? get joinNow => _localizedValues[locale.languageCode]!['joinNow'];
  String? get markYourAttendance =>
      _localizedValues[locale.languageCode]!['markYourAttendance'];
  String? get concluded => _localizedValues[locale.languageCode]!['concluded'];
  static const SERVER_DATE_YYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss";
  static const REQUIRED_DATE_YYYY_MM_DD_HH_MM_A = "yyyy-MM-dd hh:mm a";
  static const REQUIRED_DATE_YYYY_MM_DD = "yyyy-MM-dd";
  static const REQUIRED_DATE_DD_MMM_YYYY = "dd MMM, yyyy";
  static const CLASS_TIME_FORMAT = "hh:mm a";
  static const DATE_MONTH = "dd MMM";
  static const REQUIRED_DATE_DD_MMM_YYYY_HH_MM__SS = "dd MMM, yyyy hh:mm a";
  static const REQUIRED_DATE_HH_MM_A_DD_MMM = "hh:mm a, dd MMM";
  static const REQUIRED_DATE_DD_MMMM = "dd MMMM";
  static const REQUIRED_DATE_HH_MM_A = "hh:mm a";

  static const NO_INTERNET_MESSAGE = "No internet connection.";

  String get appName => APK_DETAILS['app_name']!;

  static Map<String, Map<String, String>> _localizedValues = {
    'en': EN_TEXT,
    'bn': BN_TEXT,
    'ta': TA_TEXT,
    'te': TE_TEXT,
    'kn': KN_TEXT,
    'hi': HI_TEXT,
    'mr': MR_TEXT,
    'ml': ML_TEXT
  };
}

class DemoLocalizationsDelegate extends LocalizationsDelegate<Strings> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [
        'en',
        'bn',
        'ta',
        'te',
        'kn',
        'hi',
        'mr',
        'ml'
      ].contains(locale.languageCode);

  @override
  Future<Strings> load(Locale locale) {
    // if (UserSession.language != null) locale = new Locale(UserSession.language!);
    return SynchronousFuture<Strings>(Strings(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => true;
}
