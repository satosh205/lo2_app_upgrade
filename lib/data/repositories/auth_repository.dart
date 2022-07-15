import 'package:masterg/data/models/request/auth_request/email_request.dart';
import 'package:masterg/data/models/request/auth_request/login_request.dart';
import 'package:masterg/data/models/request/auth_request/signup_request.dart';
import 'package:masterg/data/models/response/auth_response/login_response.dart';
import 'package:masterg/data/models/response/auth_response/sign_up_response.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/auth_response/verify_otp_resp.dart';
import 'package:masterg/data/models/response/home_response/app_version_response.dart';
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
      return SignUpResponse(
          error: response.body == null
              ? "Something went wrong:" as List<dynamic>?
              : response.body);
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
