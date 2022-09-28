import 'dart:io';

// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:masterg/blocs/auth_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/models/request/auth_request/login_request.dart';
import 'package:masterg/data/models/request/auth_request/swayam_login_request.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/auth_pages/verify_otp.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/app_button.dart';
// import 'package:masterg/pages/custom_pages/common_bg_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/data/models/request/home_request/user_tracking_activity.dart';
import 'package:masterg/pages/ghome/home_page.dart';
import 'package:masterg/pages/swayam_pages/common_bg_container.dart';
import 'package:masterg/pages/swayam_pages/language_page.dart';
import 'package:masterg/pages/swayam_pages/notification_helper.dart';
// import 'package:masterg/pages/home_pages/home_page.dart';
// import 'package:masterg/pages/language_page/language_page.dart';
// import 'package:masterg/pages/auth_pages/reset_password.dart';
// import 'package:masterg/pages/account_pages/contact_us_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
// import 'package:masterg/utils/notification_helper.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';

class LoginScreen extends StatefulWidget {
  final username;
  final password;
  const LoginScreen({Key? key, this.username, this.password}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  var phoneFocus = FocusNode();
  final userNameController = TextEditingController();
  var userNameNode = FocusNode();
  final passwordController = TextEditingController();
  var passwordNode = FocusNode();
  NotificationHelper? _notificationHelper;

  var _obscureText = true;

  List<Menu>? menuList;

  @override
  void initState() {
    _notificationHelper = NotificationHelper.getInstance(context);
    _notificationHelper?.setFcm();

    _notificationHelper?.getFcmToken();
    // FirebaseAnalytics().logEvent(name: "login_screen", parameters: null);
    // FirebaseAnalytics().setCurrentScreen(screenName: "login_screen");

    if (widget.username != null && widget.password != null) {
      userNameController.text = widget.username.toString().split('@')[0];
      passwordController.text = widget.password;
      pvmSwayamLogin();
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      // initState: (BuildContext context) {},
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (BuildContext context, state) {
            if (state is LoginState)
              _handleLoginResponse(state);
            else if (state is SwayamLoginState) _swayamLoginResponse(state);
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listener: (BuildContext context, state) {
            if (state is GetBottomBarState) _handelBottomNavigationBar(state);
          },
        ),
      ],

      child: CommonBgContainer(
        onBackPressed: () {},
        isBackShow: false,
        child: _pvmSwayamLogin(),
        isLoading: _isLoading,
      ),
    );
    // return BlocManager(
    //     initState: (BuildContext context) {},
    //     child: BlocListener<AuthBloc, AuthState>(
    //       listener: (context, state) {
    //         if (state is LoginState)
    //           _handleLoginResponse(state);
    //         else if (state is SwayamLoginState) _swayamLoginResponse(state);
    //       },
    //       child: CommonBgContainer(
    //         onBackPressed: () {},
    //         isBackShow: false,
    //         child: _pvmSwayamLogin(),
    //         isLoading: _isLoading,
    //       ),
    //     ));
  }

  _size({double height = 20}) {
    return SizedBox(
      height: height,
    );
  }

  void getBottomNavigationBar() {
    BlocProvider.of<HomeBloc>(context).add((GetBottomNavigationBarEvent()));
  }

  void _getUserProfile() {
    BlocProvider.of<AuthBloc>(context).add(UserProfileEvent());
  }
  void _handelBottomNavigationBar(GetBottomBarState state) {
    var getBottomBarState = state;
    setState(() {
      switch (getBottomBarState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          _getUserProfile();

          menuList = state.response!.data!.menu;
          

          if (menuList?.length == 0) {
            AlertsWidget.alertWithOkBtn(
                context: context,
                text: 'App Under Maintenance!',
                onOkClick: () {
                  FocusScope.of(context).unfocus();
                });
          } else {
            menuList?.sort((a, b) => a.inAppOrder!.compareTo(b.order!));
            Navigator.pushAndRemoveUntil(
                context,
                NextPageRoute(
                    homePage(
                      bottomMenu: menuList,
                    ),
                    isMaintainState: true),
                (route) => false);
          }
          _isLoading = false;
          break;

        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${getBottomBarState.error}");

          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void _swayamLoginResponse(SwayamLoginState state) async {
    var loginState = state;
    setState(() async {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v(
              "Success.................... -- ${state.response?.data?.token}");
          UserSession.userToken = state.response?.data?.token;
          UserSession.email = state.response?.data?.user?.email;
          UserSession.userName = state.response?.data?.user?.name;
          UserSession.userImageUrl = state.response?.data?.user?.profileImage;
          UserSession.socialEmail = state.response?.data?.user?.email;
          UserSession.userType = state.response?.data?.user?.isTrainer;
          // UserSession.userDAta = state.response?.data?.user?.isTrainer;
          /*UserSession.userContentLanguageId = 1;
          UserSession.userAppLanguageId = 1;*/
          Preference.setString(
              Preference.USER_TOKEN, '${state.response?.data?.token}');
          Preference.setString(
              Preference.USERNAME, '${state.response?.data?.user?.name}');
          Preference.setString(
              Preference.USER_EMAIL, '${state.response?.data?.user?.email}');
          Preference.setString(Preference.PROFILE_IMAGE,
              '${state.response?.data?.user?.profileImage}');
          Preference.setInt(Preference.USER_TYPE,
              int.parse('${state.response?.data?.user?.isTrainer}'));
          /*Preference.setInt(Preference.APP_LANGUAGE, 1);
          Preference.setInt(Preference.CONTENT_LANGUAGE, 1);*/
          _userTrack();

          await Hive.openBox(DB.CONTENT);
          await Hive.openBox(DB.ANALYTICS);
          await Hive.openBox(DB.TRAININGS);
          _isLoading = false;
          _moveToNext();
          // getBottomNavigationBar();
          // FirebaseAnalytics().logEvent(
          //     name: "login_successful",
          //     parameters: {"user_id": state.response.data.user.id});
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");

          AlertsWidget.alertWithOkBtn(
              context: context,
              text: loginState.error,
              onOkClick: () {
                FocusScope.of(context).autofocus(phoneFocus);
              });
          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void _moveToNext() {
    if (Preference.getString(Preference.USER_TOKEN) != null) {
      if (UserSession.userAppLanguageId == 0 ||
          UserSession.userContentLanguageId == 0) {
        Navigator.pushAndRemoveUntil(
            context,
            NextPageRoute(LanguagePage(
              languageType: UserSession.userAppLanguageId == 0 ? 1 : 2,
              isFromLogin: true,
            )),
            (Route<dynamic> route) => false);
      } else
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     NextPageRoute(homePage(
        //       bottomMenu: menuList,
        //     )),
        //     (route) => false);
        getBottomNavigationBar();
    } else {
      Navigator.pushAndRemoveUntil(
          context, NextPageRoute(LoginScreen()), (route) => false);
    }
  }

  void _userTrack() {
    BlocProvider.of<HomeBloc>(context).add(UserTrackingActivityEvent(
        trackReq: UserTrackingActivity(
            activityType: "login",
            context: "",
            activityTime: DateTime.now(),
            device: 1)));
  }

  void _handleLoginResponse(LoginState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          Navigator.push(context,
              NextPageRoute(VerifyOtp(phoneController.text.toString())));
          _isLoading = false;
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");

          AlertsWidget.alertWithOkBtn(
              context: context,
              text: loginState.error,
              onOkClick: () {
                FocusScope.of(context).autofocus(phoneFocus);
              });
          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void doLogin() {
    //  Utility.hideKeyboard();
    Utility.checkNetwork().then((isConnected) {
      if (isConnected) {
        setState(() {
          _isLoading = true;
        });
        BlocProvider.of<AuthBloc>(context).add(LoginUser(
            request: LoginRequest(
                mobileNo: phoneController.text.toString().trim())));
      } else {
        AlertsWidget.alertWithOkBtn(
            context: context,
            text: Strings.NO_INTERNET_MESSAGE,
            onOkClick: () {
              FocusScope.of(context).unfocus();
            });
      }
    });
  }

  _makeBody() {
    return Container(
      padding: EdgeInsets.only(left: 30, bottom: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${Strings.of(context)?.login}',
            textAlign: TextAlign.center,
            style: Styles.textBold(size: 25, color: ColorConstants.ORANGE),
          ),
          _size(height: 20),
          Text(
            '${Strings.of(context)?.enterLoginText}',
            textAlign: TextAlign.center,
            style: Styles.textBold(size: 16, color: ColorConstants.PURPLE),
          ),
          _size(height: 20),
          TextFormField(
            controller: phoneController,
            focusNode: phoneFocus,
            style: Styles.textBold(size: 16),
            keyboardType: TextInputType.number,
            decoration: textInputDecoration.copyWith(
                hintText: '${Strings.of(context)?.mobileNumber}',
                prefixText: "+91",
                prefixStyle: TextStyle(
                  color: ColorConstants.TEXT_DARK_BLACK,
                  fontSize: 16,
                )),
            validator: (value) =>
                value!.isEmpty ? Strings.of(context)?.mobileNumber : null,
            textInputAction: TextInputAction.done,
            onChanged: (value) {},
            onFieldSubmitted: (val) {
              doLogin();
            },
          ),
          Spacer(),
          AppButton(
            onTap: () {
              // Navigator.push(context,
              //     NextPageRoute(VerifyOtp(phoneController.text.toString())));
              doLogin();
            },
            title: Strings.of(context)?.requestOtp,
          ),
          _size(height: 10),
          /* InkWell(
                      onTap: () {
                        Navigator.push(context, NextPageRoute(SignUpScreen()));
                      },
                      child: Text(
                        "Create an Account",
                        textAlign: TextAlign.center,
                        style: Styles.textSemiBold(color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                    ),*/
        ],
      ),
    );
  }

  void pvmSwayamLogin() {
    //  Utility.hideKeyboard();
    Utility.checkNetwork().then((isConnected) {
      if (isConnected) {
        setState(() {
          _isLoading = true;
        });
        BlocProvider.of<AuthBloc>(context).add(PvmSwayamLogin(
            request: SwayamLoginRequest(
                deviceToken: UserSession.firebaseToken,
                device_id: "31232131231231",
                deviceType: Platform.isAndroid ? "1" : "2",
                userName: userNameController.text.toString().trim(),
                password: passwordController.text.toString().trim())));
      } else {
        AlertsWidget.alertWithOkBtn(
            context: context,
            text: Strings.NO_INTERNET_MESSAGE,
            onOkClick: () {
              FocusScope.of(context).unfocus();
            });
      }
    });
  }

  _pvmSwayamLogin() {
    return Container(
      padding: EdgeInsets.only(left: 30, bottom: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${Strings.of(context)?.login}',
            textAlign: TextAlign.center,
            style: Styles.textBold(size: 25, color: ColorConstants.ORANGE),
          ),
          _size(height: 20),
          TextFormField(
            controller: userNameController,
            focusNode: userNameNode,
            style: Styles.textBold(size: 16),
            keyboardType: TextInputType.text,
            decoration: textInputDecoration.copyWith(
              hintText: 'Username',
            ),
            validator: (value) =>
                value!.isEmpty ? 'Username is required' : null,
            textInputAction: TextInputAction.next,
            onChanged: (value) {},
          ),
          _size(height: 20),
          TextFormField(
            controller: passwordController,
            focusNode: passwordNode,
            style: Styles.textBold(size: 16),
            keyboardType: TextInputType.visiblePassword,
            decoration: textInputDecoration.copyWith(
              hintText: 'Password',
              suffixIcon: InkWell(
                onTap: _toggle,
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  size: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
            obscureText: _obscureText,
            validator: (value) =>
                value!.isEmpty ? 'password is required' : null,
            textInputAction: TextInputAction.done,
            onChanged: (value) {},
            onFieldSubmitted: (val) {
              pvmSwayamLogin();
            },
          ),
          _size(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            GestureDetector(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => ResetPassword()));
                },
                child: Text(
                  "Forgot password ?",
                  textAlign: TextAlign.left,
                  style: Styles.textSemiBold(
                      size: 15, color: ColorConstants.PRIMARY_COLOR),
                )),
          ]),
          Spacer(),
          AppButton(
            onTap: () {
              pvmSwayamLogin();
            },
            title: "Login",
          ),
          _size(height: 10),
        ],
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void initHive() async {
    await Hive.openBox(DB.CONTENT);
    await Hive.openBox(DB.ANALYTICS);
    await Hive.openBox(DB.TRAININGS);
  }
}
