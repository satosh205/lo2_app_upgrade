import 'package:masterg/data/models/request/auth_request/email_request.dart';
import 'package:masterg/data/models/request/auth_request/login_request.dart';
import 'package:masterg/data/models/request/auth_request/signup_request.dart';
import 'package:masterg/data/models/request/auth_request/swayam_login_request.dart';
import 'package:masterg/data/models/request/auth_request/update_user_request.dart';
import 'package:masterg/data/models/response/auth_response/login_response.dart';
import 'package:masterg/data/models/response/auth_response/sign_up_response.dart';
import 'package:masterg/data/models/response/auth_response/swayam_login_response.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/auth_response/verify_otp_resp.dart';
import 'package:masterg/data/models/response/home_response/app_version_response.dart';
import 'package:masterg/data/models/response/home_response/city_state_response.dart';
import 'package:masterg/data/providers/auth_provider.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/utils/Log.dart';

class AuthRepository {
  AuthRepository({required this.userProvider});

  final AuthProvider userProvider;

  Future<LoginResponse> loginCall({required LoginRequest request}) async {
    final response = await userProvider.loginCall(request: request);
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      LoginResponse user = LoginResponse.fromJson(response.body);
      return user;
    } else {
      Log.v("====> ${response.body}");
      return LoginResponse(
          message:
              response.body == null ? "Something went wrong:" : response.body);
    }
  }

  Future<SignUpResponse> signUpCall({required SignUpRequest request}) async {
    final response = await userProvider.signUpCall(request);

    if (response!.success) {
      SignUpResponse users = SignUpResponse.fromJson(response.body);
      return users;
    } else {
      return SignUpResponse(error: response.body);
    }
  }


    Future<SignUpResponse?> updateUser({UpdateUserRequest? request}) async {
    final response = await userProvider.updateUser(request!);
    if (response!.success) {
      Log.v("response.success : ${response.body}");
      SignUpResponse verifyOtpResp = SignUpResponse.fromJson(response.body);
      return verifyOtpResp;
    } else {
      Log.v("====> ${response.body}");
      return SignUpResponse();
    }
  }

  Future<CityStateResp?> getStateList() async {
    final response = await userProvider.getStateList();
    if (response!.success) {
      Log.v("response.success : ${response.body}");
      CityStateResp categoryResp = CityStateResp.fromJson(response.body);
      return categoryResp;
    } else {
      Log.v("====> ${response.body}");
      return CityStateResp();
    }
  }

   Future<CityStateResp> getCityList(int stateId) async {
    final response = await userProvider.getCityList(stateId);
    if (response!.success) {
      Log.v("response.success : ${response.body}");
      CityStateResp categoryResp = CityStateResp.fromJson(response.body);
      return categoryResp;
    } else {
      Log.v("====> ${response.body}");
      return CityStateResp();
    }
  }

    Future<SwayamLoginResponse?> swayamLoginCall(
      {SwayamLoginRequest? request}) async {
    final response = await userProvider.swayamLoginCall(request: request);
    if (response!.success) {
      Log.v("ERROR DATA : ${response.body}");
      SwayamLoginResponse user = SwayamLoginResponse.fromJson(response.body);
      return user;
    } else {
      Log.v("====> ${response.body}");
      return SwayamLoginResponse(
          message:
              response.body == null ? "Something went wrong:" : response.body);
    }
  }

  Future<VerifyOtpResp> verifyOtp({required EmailRequest request}) async {
    final response = await userProvider.verifyOTP(request);
    if (response!.success) {
      Log.v("!response.success : ${response.body}");
      VerifyOtpResp verifyOtpResp = VerifyOtpResp.fromJson(response.body);
      saveUserToken(verifyOtpResp);
      return verifyOtpResp;
    } else {
      Log.v("====> ${response.body}");
      Log.v("====> ${response.status}");
      return VerifyOtpResp(error: response.body, status: response.status);
    }
  }

  void saveUserToken(VerifyOtpResp verifyOtpResp) {
    if (verifyOtpResp == null) return;
    Preference.setString(Preference.USER_TOKEN, '${verifyOtpResp.data?.token}');
    UserSession.userToken = verifyOtpResp.data!.token;
  }

  Future<AppVersionResp> getAppVeriosn({String? deviceType}) async {
    final response = await userProvider.getAppVerison(deviceType: deviceType);
    if (response!.success) {
      Log.v("!response.success : ${response.body}");
      AppVersionResp resp = AppVersionResp.fromJson(response.body);
      return resp;
    } else {
      Log.v("====> ${response.body}");
      return AppVersionResp();
    }
  }
}
