import 'package:bloc/bloc.dart';
import 'package:injector/injector.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/auth_request/email_request.dart';
import 'package:masterg/data/models/request/auth_request/login_request.dart';
import 'package:masterg/data/models/request/auth_request/signup_request.dart';
import 'package:masterg/data/models/request/auth_request/swayam_login_request.dart';
import 'package:masterg/data/models/request/auth_request/update_user_request.dart';
import 'package:masterg/data/models/response/auth_response/login_response.dart';
import 'package:masterg/data/models/response/auth_response/sign_up_response.dart';
import 'package:masterg/data/models/response/auth_response/swayam_login_response.dart';
import 'package:masterg/data/models/response/auth_response/verify_otp_resp.dart';
import 'package:masterg/data/models/response/home_response/app_version_response.dart';
import 'package:masterg/data/models/response/home_response/category_response.dart';
import 'package:masterg/data/models/response/home_response/city_state_response.dart';
import 'package:masterg/data/models/response/home_response/user_info_response.dart';
import 'package:masterg/data/repositories/auth_repository.dart';
import 'package:masterg/data/repositories/home_repository.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';

abstract class AuthEvent {
  AuthEvent([List event = const []]) : super();
}

class LoginUser extends AuthEvent {
  final LoginRequest request;

  LoginUser({required this.request}) : super([request]);

  List<Object> get props => throw UnimplementedError();
}

class SignUpEvent extends AuthEvent {
  final SignUpRequest request;

  SignUpEvent({required this.request}) : super([request]);

  List<Object> get props => throw UnimplementedError();
}

class AppVersionEvent extends AuthEvent {
  String? deviceType;

  AppVersionEvent({this.deviceType}) : super([deviceType]);

  List<Object> get props => throw UnimplementedError();
}

class VerifyOtpEvent extends AuthEvent {
  final EmailRequest request;

  VerifyOtpEvent({required this.request}) : super([request]);

  List<Object> get props => throw UnimplementedError();
}

class CategoryEvent extends AuthEvent {
  int? contentType;

  CategoryEvent({this.contentType}) : super([contentType]);

  List<Object> get props => throw UnimplementedError();
}

class UserProfileEvent extends AuthEvent {
  UserProfileEvent() : super([]);

  List<Object> get props => throw UnimplementedError();
}

abstract class AuthState {
  AuthState([List states = const []]) : super();

  List<Object> get props => [];
}

class CategoryState extends AuthState {
  ApiStatus state;

  ApiStatus get apiState => state;
  CategoryResp? response;
  String? error;

  CategoryState(this.state, {this.response, this.error});
}

class AppVersionState extends AuthState {
  ApiStatus state;

  ApiStatus get apiState => state;
  AppVersionResp? response;
  String? error;

  AppVersionState(this.state, {this.response, this.error});
}

class LoginState extends AuthState {
  ApiStatus state;

  ApiStatus get apiState => state;
  LoginResponse? response;
  String? error;

  LoginState(this.state, {this.response, this.error});
}

class SignUpState extends AuthState {
  ApiStatus state;

  ApiStatus get apiState => state;
  SignUpResponse? response;
  String? error;

  SignUpState(this.state, {this.response, this.error});
}

class VerifyOtpState extends AuthState {
  ApiStatus state;

  ApiStatus get apiState => state;
  VerifyOtpResp? response;
  String? error;
  int? status;

  VerifyOtpState(this.state, {this.response, this.error, this.status});
}

class UpdateUserState extends AuthState {
  ApiStatus state;

  ApiStatus get apiState => state;
  SignUpResponse? response;
  String? error;

  UpdateUserState(this.state, {this.response, this.error});
}



class StateState extends AuthState {
  ApiStatus state;

  ApiStatus get apiState => state;
  CityStateResp? response;
  String? error;

  StateState(this.state, {this.response, this.error});
}

class StateEvent extends AuthEvent {
  StateEvent() : super([]);

  @override
  List<Object> get props => throw UnimplementedError();
}

class UpdateUserEvent extends AuthEvent {
  final UpdateUserRequest? request;

  UpdateUserEvent({this.request}) : super([request]);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}



class CityState extends AuthState {
  ApiStatus state;

  ApiStatus get apiState => state;
  CityStateResp? response;
  String? error;

  CityState(this.state, {this.response, this.error});
}


class CityEvent extends AuthEvent {
  int stateId;

  CityEvent(this.stateId) : super([stateId]);

  @override
  List<Object> get props => throw UnimplementedError();
}

class SwayamLoginState extends AuthState {
  ApiStatus state;

  ApiStatus get apiState => state;
  SwayamLoginResponse? response;
  String? error;

  SwayamLoginState(this.state, {this.response, this.error});
}


class SignUp extends AuthEvent {
  final SignUpRequest? request;

  SignUp({this.request}) : super([request]);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class PvmSwayamLogin extends AuthEvent {
  final SwayamLoginRequest? request;

  PvmSwayamLogin({this.request}) : super([request]);

  @override
  List<Object> get props => throw UnimplementedError();
}

class UserProfileState extends AuthState {
  ApiStatus state;

  ApiStatus get apiState => state;
  UserInfoResponse? response;
  String? error;

  UserProfileState(this.state, {this.response, this.error});
}




class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authRepository = Injector.appInstance.get<AuthRepository>();
  final homeRepository = Injector.appInstance.get<HomeRepository>();

  AuthBloc(AuthState initialState) : super(initialState);

  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginUser) {
      try {
        yield LoginState(ApiStatus.LOADING);
        final response = await authRepository.loginCall(request: event.request);
        if (response.status == 1) {
          yield LoginState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: $response");
          yield LoginState(ApiStatus.ERROR, error: response.message);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield LoginState(ApiStatus.ERROR, error: Strings.somethingWentWrong);
      }
    } 
else if (event is UserProfileEvent) {
      try {
        yield UserProfileState(ApiStatus.LOADING);
        final response = await homeRepository.getSwayamUserProfile();
        if (response.data != null) {
          yield UserProfileState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield UserProfileState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e, stacktrace) {
        Log.v("ERROR DATA : $e");
        print(stacktrace);
        yield UserProfileState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    }
    else if (event is PvmSwayamLogin) {
      try {
        yield SwayamLoginState(ApiStatus.LOADING);
        final response =
            await authRepository.swayamLoginCall(request: event.request);
        if (response?.status == 1) {
          yield SwayamLoginState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: $response");
          yield LoginState(ApiStatus.ERROR, error: response?.message);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield LoginState(ApiStatus.ERROR, error: Strings.somethingWentWrong);
      }
    }
    else if (event is StateEvent) {
      try {
        yield StateState(ApiStatus.LOADING);
        final response = await authRepository.getStateList();
        if (response?.data != null) {
          yield StateState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield StateState(ApiStatus.ERROR, error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield StateState(ApiStatus.ERROR, error: Strings.somethingWentWrong);
      }
    }


    else if (event is CityEvent) {
      try {
        yield CityState(ApiStatus.LOADING);
        final response = await authRepository.getCityList(event.stateId);
        if (response.data != null) {
          yield CityState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield CityState(ApiStatus.ERROR, error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield CityState(ApiStatus.ERROR, error: Strings.somethingWentWrong);
      }
    }
    
    else if (event is UpdateUserEvent) {
      try {
        yield UpdateUserState(ApiStatus.LOADING);
        final response =
            await authRepository.updateUser(request: event.request);
        if (response?.status == 1) {
          Log.v("sign up data");
          yield UpdateUserState(ApiStatus.SUCCESS, response: response);
        } else {
          yield UpdateUserState(ApiStatus.ERROR, error: 'error');
        }
      } catch (e) {
        Log.v("ERROR DATA : ");
        yield UpdateUserState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is SignUpEvent) {
      try {
        yield SignUpState(ApiStatus.LOADING);
        final response =
            await authRepository.signUpCall(request: event.request);

        if (response.status == 1) {
          yield SignUpState(ApiStatus.SUCCESS, response: response);
        } else {
          yield SignUpState(
            ApiStatus.ERROR,
            error: response.error?.first,
          );
        }
      } catch (e) {
        Log.v("Expection DATA : ");

        yield SignUpState(ApiStatus.ERROR, error: Strings.somethingWentWrong);
      }
    } else if (event is VerifyOtpEvent) {
      try {
        yield VerifyOtpState(ApiStatus.LOADING);
        final response = await authRepository.verifyOtp(request: event.request);
        if (response.status == 1) {
          yield VerifyOtpState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERRORe4 DATA ::: ${response.status}");
          yield VerifyOtpState(ApiStatus.ERROR,
              error: response.error != null && response.error!.length > 0
                  ? response.error!.first
                  : Strings.somethingWentWrong,
              status: response.status);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield VerifyOtpState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    } else if (event is CategoryEvent) {
      try {
        yield CategoryState(ApiStatus.LOADING);
        final response = await homeRepository.getCategory();
        if (response.data != null) {
          yield CategoryState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield CategoryState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield CategoryState(ApiStatus.ERROR, error: Strings.somethingWentWrong);
      }
    } else if (event is AppVersionEvent) {
      try {
        yield AppVersionState(ApiStatus.LOADING);
        final response =
            await authRepository.getAppVeriosn(deviceType: event.deviceType);
        if (response.data != null) {
          yield AppVersionState(ApiStatus.SUCCESS, response: response);
        } else {
          Log.v("ERROR DATA ::: ${response}");
          yield AppVersionState(ApiStatus.ERROR,
              error: Strings.somethingWentWrong);
        }
      } catch (e) {
        Log.v("ERROR DATA : $e");
        yield AppVersionState(ApiStatus.ERROR,
            error: Strings.somethingWentWrong);
      }
    }
  }
}
