import 'package:masterg/local/pref/Preference.dart';

class UserSession {
  static String? firstName;
  static String? lastName;
  static String? gender;

  static String? firebaseToken;
  static int? userId;
  static String? userToken;
  static String? userName;
  static String? email;
  static String? phone = "";
  static String? nationality;
  static String? socialToken;
  static String? socialFirstName;
  static String? socialLastName;
  static String? userImageUrl;
  static String? categoryData;
  static dynamic notificationData;
  static String? designation;

  static int? userType = 0;
  static int? userCoins = 0;
  static int? userContentLanguageId = 0;
  static int? userAppLanguageId = 0;

  static String? address = "";
  static String? gameUrl = "";

  static String? socialEmail = "";

  static String? userData = '';

  static String? language = 'en';

  static int currentTime = 0;

  static String? libraryTags = '';
  static String? annoncmentTags = '';

  static clearSession() {
    address = null;
    firstName = null;
    lastName = null;
    userId = null;
    userToken = null;
    socialToken = null;
    socialFirstName = null;
    socialLastName = null;
    userType = 0;
    userImageUrl = null;
    email = null;
    socialEmail = null;
    userName = null;
    nationality = null;
    gender = null;
    designation = null;
    gameUrl = null;
    categoryData = null;
    notificationData = null;
    userData = null;
    userCoins = 0;
    language = 'en';
  }

  UserSession() {
    userId = Preference.getInt(Preference.USER_ID);

    firebaseToken = Preference.getString(Preference.FIREBASE_TOKEN);

    if (Preference.getString(Preference.FIRST_NAME) != null) {
      firstName = Preference.getString(Preference.FIRST_NAME);
    }
    if (Preference.getString(Preference.LAST_NAME) != null) {
      lastName = Preference.getString(Preference.LAST_NAME);
    }
    if (Preference.getString(Preference.GENDER) != null) {
      gender = Preference.getString(Preference.GENDER);
    }
    if (Preference.getString(Preference.DESIGNATION) != null) {
      designation = Preference.getString(Preference.DESIGNATION);
    }
    if (Preference.getString(Preference.USER_TOKEN) != null) {
      userToken = Preference.getString(Preference.USER_TOKEN);
    }
    if (Preference.getString(Preference.USER_EMAIL) != null) {
      email = Preference.getString(Preference.USER_EMAIL);
    }
    if (Preference.getString(Preference.USERNAME) != null) {
      userName = Preference.getString(Preference.USERNAME);
    }
    if (Preference.getString(Preference.PHONE) != null) {
      phone = Preference.getString(Preference.PHONE);
    }

    if (Preference.getString(Preference.PROFILE_IMAGE) != null) {
      userImageUrl = Preference.getString(Preference.PROFILE_IMAGE);
    }

    if (Preference.getString(Preference.CATEGORY_DATA) != null) {
      categoryData = Preference.getString(Preference.CATEGORY_DATA);
    }

    if (Preference.getInt(Preference.USER_TYPE) != null) {
      userType = Preference.getInt(Preference.USER_TYPE);
    }
    if (Preference.getInt(Preference.USER_COINS) != null) {
      userCoins = Preference.getInt(Preference.USER_COINS);
    }
    if (Preference.getInt(Preference.CONTENT_LANGUAGE) != null) {
      userContentLanguageId = Preference.getInt(Preference.CONTENT_LANGUAGE);
    }
    if (Preference.getInt(Preference.APP_LANGUAGE) != null) {
      userAppLanguageId = Preference.getInt(Preference.APP_LANGUAGE);
    }
    if (Preference.getString(Preference.USER_DATA) != null) {
      userData = Preference.getString(Preference.USER_DATA);
    }
    if (Preference.getString(Preference.LANGUAGE) != null) {
      language = Preference.getString(Preference.LANGUAGE);
    }
  }
}
