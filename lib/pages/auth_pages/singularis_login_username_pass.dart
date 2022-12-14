import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/blocs/auth_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/auth_request/swayam_login_request.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/main.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/TapWidget.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/ghome/home_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/config.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/validation.dart';

class SingularisLogin extends StatefulWidget {
  @override
  _SingularisLoginState createState() => _SingularisLoginState();
}

class _SingularisLoginState extends State<SingularisLogin> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _isLoading = false;
  var _scaffoldContext;
  AuthBloc? _authBloc;
  // NotificationHelper _notificationHelper = NotificationHelper.getInstance();
  var _formKey = GlobalKey<FormState>();
  bool _autoValidation = true;
  var _isObscure = true;
  List<Menu>? menuList;

  @override
  void initState() {
    // _notificationHelper.getFcmToken();
    super.initState();
  }

  void getBottomNavigationBar() {
    BlocProvider.of<HomeBloc>(context).add((GetBottomNavigationBarEvent()));
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
          if (state.response?.error?.length != 0) {
            AlertsWidget.showCustomDialog(
                context: context,
                title: loginState.response?.error?.first,
                text: "",
                icon: 'assets/images/circle_alert_fill.svg',
                showCancel: false,
                oKText: "Ok",
                onOkClick: () async {
                  // Navigator.pop(context);
                  setState(() {
                    _isLoading = false;
                  });
                });
            // AlertsWidget.alertWithOkBtn(
            //     context: context,
            //     text: loginState.response?.error?.first,
            //     onOkClick: () {
            //       // FocusScope.of(context).autofocus(phoneFocus);
            //       setState(() {
            //         _isLoading = false;
            //       });
            //     });
            break;
          }

          UserSession.userToken = state.response?.data?.token;
          UserSession.email = state.response?.data?.user?.email;
          UserSession.userName = state.response?.data?.user?.name;
          UserSession.userImageUrl = state.response?.data?.user?.profileImage;
          UserSession.socialEmail = state.response?.data?.user?.email;
          // UserSession.userType = state.response?.data?.user?.isTrainer;
          // UserSession.userDAta = state.response?.data?.user?.isTrainer;
          /*UserSession.userContentLanguageId = 1;
          UserSession.userAppLanguageId = 1;*/
          Preference.setString(
              Preference.FIRST_NAME, '${state.response?.data?.user?.name}');
          Preference.setString(
              Preference.PHONE, '${state.response?.data?.user?.mobileNo}');
          // Preference.setInt(
          //     Preference.USER_ID, state.response!.data!.user!.id);
          Preference.setString(
              Preference.USER_TOKEN, '${state.response?.data?.token}');
          Preference.setString(
              Preference.USERNAME, '${state.response?.data?.user?.name}');
          Preference.setString(
              Preference.USER_EMAIL, '${state.response?.data?.user?.email}');
          Preference.setString(Preference.PROFILE_IMAGE,
              '${state.response?.data?.user?.profileImage}');
          // Preference.setInt(Preference.USER_TYPE,
          //     int.parse('${state.response?.data?.user?.isTrainer}'));
          Preference.setString(
              'interestCategory', '${state.response!.data!.user!.categoryIds}');
          Preference.setString(Preference.DEFAULT_VIDEO_URL_CATEGORY,
              '${state.response!.data!.user!.defaultVideoUrlOnCategory}');
          print('called api');
          getBottomNavigationBar();

          /*Preference.setInt(Preference.APP_LANGUAGE, 1);
          Preference.setInt(Preference.CONTENT_LANGUAGE, 1);*/
          // _userTrack();

          // await Hive.openBox(DB.CONTENT);
          // await Hive.openBox(DB.ANALYTICS);
          // await Hive.openBox(DB.TRAININGS);
          _isLoading = false;
          // _moveToNext();
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
              text: loginState.response?.error?.first,
              onOkClick: () {
                // FocusScope.of(context).autofocus(phoneFocus);
                setState(() {
                  _isLoading = false;
                });
              });
          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
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
          menuList = state.response!.data!.menu;

          if (menuList?.length == 0) {
            AlertsWidget.alertWithOkBtn(
                context: context,
                text: 'App Under Maintenance!',
                onOkClick: () {
                  FocusScope.of(context).unfocus();
                });
          } else {
            menuList?.sort((a, b) => a.inAppOrder!.compareTo(b.inAppOrder!));
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

  @override
  Widget build(BuildContext context) {
    Application(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    return MultiBlocListener(
      // initState: (context) {},
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            // if (state is LoginState) _handleLoginResponse(state);
            if (state is SwayamLoginState) _swayamLoginResponse(state);
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listener: (BuildContext context, state) {
            if (state is GetBottomBarState) _handelBottomNavigationBar(state);
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorConstants.WHITE,
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        body: Builder(builder: (_context) {
          _scaffoldContext = _context;
          return ScreenWithLoader(
            body: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: _content(),
                ),
              ),
            ),
            isLoading: _isLoading,
          );
        }),
      ),
    );
  }

  Widget _bg() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Text('et iamge'),
          Spacer(),
        ],
      ),
    );
  }

  Widget _content() {
    String appBarImagePath = 'assets/images/${APK_DETAILS['theme_image_url']}';

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidation
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Transform.scale(
                scale: 1.2,
                child: appBarImagePath.split('.').last == 'svg'
                    ? SvgPicture.asset(
                        appBarImagePath,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        appBarImagePath,
                        // 'assets/images/${APK_DETAILS' ,
                        height: 150,
                        width: 150,
                      ),
              ),
              SizedBox(height: 10),
              if (APK_DETAILS['theme_image_url2'] != "")
                APK_DETAILS['theme_image_url2']?.split('.').last == 'svg'
                    ? SvgPicture.asset(
                        height: MediaQuery.of(context).size.height * 0.2,
                        'assets/images/${APK_DETAILS['theme_image_url2']}',
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/${APK_DETAILS['theme_image_url2']}',
                        height: MediaQuery.of(context).size.height * 0.2,
                        // width: 150,
                      ),
              _size(height: 20),
              Text('Welcome Back!',
                  style: Styles.bold(
                      size: 22, color: ColorConstants().primaryColor())),
              _size(),
              Text('Enter your login credentails to continue',
                  style: Styles.regular(size: 16)),
              _size(height: 20),
              _textField(
                isEmail: true,
                controller: _emailController,
                hintText: 'Username',
                prefixImage: 'assets/images/email_icon.png',
                validation: validateEmail,
              ),
              _size(height: 10),
              _textField(
                  controller: _passController,
                  hintText: 'Password',
                  prefixImage: 'assets/images/lock_icon.png',
                  obscureText: _isObscure,
                  validation: validatePassword1,
                  onEyePress: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  }),
              _size(height: 20),
              Column(
                children: [
                  _loginButton(),
                  _size(),
                  // Row(
                  //   children: [
                  //     Text(
                  //       Strings.of(context).dontHaveAnAccount,
                  //       style: Styles.boldBlack(size: 16),
                  //     ),
                  //     TapWidget(
                  //       onTap: () {
                  //         Navigator.push(
                  //             context, NextPageRoute(RegistrationPage()));
                  //       },
                  //       child: Text(
                  //         Strings.of(context).signUp,
                  //         style: Styles.boldGreen(size: 20),
                  //       ),
                  //     ),
                  //   ],
                  // )
                  // TapWidget(
                  //   onTap: () {
                  //     // Navigator.push(_scaffoldContext,
                  //     //     NextPageRoute(ForgotPasswordPage()));
                  //   },
                  //   child: Text(
                  //     Strings.of(_scaffoldContext).forgotPasswordQuestion,
                  //     style: Styles.regularBlack(size: 18),
                  //   ),
                  // ),
                  _size(height: 5),
                  TapWidget(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Login using OTP',
                      style: Styles.textExtraBoldUnderline(
                          size: 16, color: ColorConstants().primaryColor()),
                    ),
                  ),
                ],
              ),
              // _size(height: 20),
              // Text(
              //   Strings.of(context).dontHaveAnAccount,
              //   style: Styles.boldBlack(size: 16),
              // ),

              // TapWidget(
              //   onTap: () {
              //     Navigator.push(context, NextPageRoute(RegistrationPage()));
              //     //Navigator.push(context, NextPageRoute(RegistrationStepOnePage()));
              //   },
              //   child: Text(
              //     Strings.of(context).signUp,
              //     style: Styles.boldGreen(size: 20),
              //   ),
              // ),
              // _size(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _size({double height = 10}) {
    return SizedBox(
      height: height,
    );
  }

  Widget _textField({
    bool isEmail = false,
    TextEditingController? controller,
    String? hintText,
    required String prefixImage,
    bool obscureText = false,
    required Function(String) validation,
    Function()? onEyePress,
  }) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        style: TextStyle(fontSize: 18),
        controller: controller,
        validator: (String? vla) {
          validation(vla!);
        },
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(5),
            child: isEmail == true
                ? Icon(Icons.person
                    // size: 30,
                    // color: ColorConstants.GREY,
                    )
                : Image.asset(
                    prefixImage,
                    height: 32,
                    width: 32,
                  ),
          ),
          suffixIcon: Visibility(
            visible: onEyePress != null,
            child: TapWidget(
              onTap: () {
                // onTap: onEyePress,
                onEyePress!();
              },
              child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: !obscureText
                      ? Icon(
                          Icons.remove_red_eye_outlined,
                          // size: 30,
                          // color: ColorConstants.GREY,
                        )
                      : Icon(Icons.visibility_off)),
            ),
          ),
          hintStyle: Styles.regular(size: 18, color: ColorConstants.GREY_3),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide:
                  BorderSide(color: ColorConstants().primaryColor(), width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide:
                  BorderSide(color: ColorConstants().primaryColor(), width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide:
                  BorderSide(color: ColorConstants().primaryColor(), width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide:
                  BorderSide(color: ColorConstants().primaryColor(), width: 1)),
        ),
      ),
    );
  }

  _loginButton() {
    return TapWidget(
      onTap: () {
        String? value = validateEmail(_emailController.text.toString().trim());
        String? pass = validatePassword(_passController.text.toString().trim());
        if (value != null) {
          AlertsWidget.showCustomDialog(
              context: context,
              title: value,
              text: "",
              icon: 'assets/images/circle_alert_fill.svg',
              showCancel: false,
              oKText: "Ok",
              onOkClick: () async {
                // Navigator.pop(context);
              });
        } else if (pass != null) {
          AlertsWidget.showCustomDialog(
              context: context,
              title: pass,
              text: "",
              icon: 'assets/images/circle_alert_fill.svg',
              showCancel: false,
              oKText: "Ok",
              onOkClick: () async {
                // Navigator.pop(context);
              });
        } else
          BlocProvider.of<AuthBloc>(context).add(PvmSwayamLogin(
              request: SwayamLoginRequest(
                  deviceToken: UserSession.firebaseToken,
                  device_id: "31232131231231",
                  deviceType: Platform.isAndroid ? "1" : "2",
                  userName: _emailController.text.toString().trim(),
                  password: _passController.text.toString().trim())));
        // if (_formKey.currentState.validate()) {
        //   Utility.deviceId().then((token) {
        //     print('deviceId ====************* ' + token);
        //     if (token != null) {
        //       _authBloc.add(
        //         LoginUser(
        //           request: LoginRequest(
        //               username: _emailController.text.trim(),
        //               password: _passController.text.trim(),
        //               deviceToken: UserSession.firebaseToken,
        //               deviceType: Platform.isAndroid ? 1 : 2,
        //               deviceId: token,
        //               fcmToken: UserSession.firebaseToken),
        //         ),
        //       );
        //     }
        //   });
        // } else {
        //   _autoValidation = true;
        // }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 56,
        decoration: BoxDecoration(
          color: ColorConstants().primaryColor(),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          'Login',
          style: Styles.regular(
            color: ColorConstants.WHITE,
          ),
        ),
      ),
    );
  }
}
