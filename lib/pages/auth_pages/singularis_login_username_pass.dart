import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
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
import 'package:masterg/pages/auth_pages/forget_password.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/TapWidget.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/ghome/home_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/config.dart';
import 'package:masterg/utils/constant.dart';
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
          Preference.setInt(Preference.USER_ID,
              int.parse('${state.response?.data?.user?.id}'));
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
                  // padding: const EdgeInsets.symmetric(horizontal: 20),
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

    var _pin;
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
              Text("Welcome to",
                  style: Styles.regular(size: 18, color: Color(0xff5A5F73))),
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
                        height: 80,
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  gradient: LinearGradient(colors: [
                    ColorConstants.GRADIENT_ORANGE,
                    ColorConstants.GRADIENT_RED,
                  ]),
                ),
                height: height(context) * 0.6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('${Strings.of(context)?.login}',
                          style: Styles.bold(
                              size: 18, color: ColorConstants.WHITE)),
                      _size(),
                      Text('${Strings.of(context)?.loginCreateAccount}',
                          style: Styles.regular(
                              size: 16, color: ColorConstants.WHITE)),
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
                          prefixImage: 'assets/images/lock.png',
                          obscureText: _isObscure,
                          validation: validatePassword1,
                          onEyePress: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.only(left: 200.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgetScreen()));
                            },
                            child: Text(
                              "Forget Password?",
                              style: Styles.regularWhite(),
                            )),
                      ),
                      _size(height: 20),
                      Column(
                        children: [
                          // _loginButton(),
                          InkWell(
                            onTap: () {
                              String? value = validateEmail(
                                  _emailController.text.toString().trim());
                              String? pass = validatePassword(
                                  _passController.text.toString().trim());
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
                                BlocProvider.of<AuthBloc>(context).add(
                                    PvmSwayamLogin(
                                        request: SwayamLoginRequest(
                                            deviceToken:
                                                UserSession.firebaseToken,
                                            device_id: "31232131231231",
                                            deviceType:
                                                Platform.isAndroid ? "1" : "2",
                                            userName: _emailController.text
                                                .toString()
                                                .trim(),
                                            password: _passController.text
                                                .toString()
                                                .trim())));
                            },
                            child: Container(
                                margin: EdgeInsets.all(12),
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    // color: _pin.length != 4
                                    //     ? ColorConstants.WHITE

                                    //         .withOpacity(0.5)
                                    //     : ColorConstants.WHITE,
                                    borderRadius: BorderRadius.circular(10)),
                                child: ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: <Color>[
                                          ColorConstants.GRADIENT_ORANGE,
                                          ColorConstants.GRADIENT_RED
                                        ]).createShader(bounds);
                                  },
                                  child: Center(
                                    child: Text(
                                      '${Strings.of(context)?.signIn}',
                                      style: Styles.regular(
                                        size: 16,
                                        color: ColorConstants.WHITE,
                                      ),
                                    ),
                                  ),

                                  //     child: Text(
                                  //   '${Strings.of(context)?.signIn}',
                                  //   style: Styles.regular(
                                  //     color: ColorConstants.WHITE,
                                  //   ),
                                  // )),
                                )),
                          ),
                          // _size(),
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
                          // _size(height: 5),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      '${Strings.of(context)?.changePhoneNumber}',
                                      style: Styles.regular(
                                          size: 14,
                                          color: ColorConstants.WHITE),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  // CountdownTimer(
                                  //   endTime: endTime,
                                  //   widgetBuilder: (_, CurrentRemainingTime? time) {
                                  //     return RichText(
                                  //       text: TextSpan(
                                  //           text: 'nice',
                                  //           style: TextStyle(
                                  //             fontSize: 3,
                                  //           ),
                                  //           children: <TextSpan>[
                                  //             time == null
                                  //                 ? TextSpan(
                                  //                     text:
                                  //                         '${Strings.of(context)?.resend}',
                                  //                     recognizer: TapGestureRecognizer()
                                  //                       ..onTap = () {
                                  //                         resendOTP();
                                  //                       },
                                  //                     style: Styles.regular(
                                  //                         size: 12,
                                  //                         color: ColorConstants.WHITE))
                                  //                 : TextSpan(text: 'Resend in ${time.sec} secs', style:Styles.regular(
                                  //                         size: 12,
                                  //                         color: ColorConstants.WHITE) ),
                                  //           ]),
                                  //     );
                                  //   },
                                  // ),

                                  //             RichText(
                                  //   text: new TextSpan(
                                  //     text: 'Not registered?',
                                  //     style: Styles.semibold(size: 14,color: Color(0xff0E1638)),
                                  //     children: <TextSpan>[
                                  //       new TextSpan(
                                  //           text: '  Register now',
                                  //           style: Styles.regularWhite(size: 14)),

                                  //     ],
                                  //   ),
                                  // ),
                                ]),
                          ),
                          // TapWidget(
                          //   onTap: () {
                          //     Navigator.pop(context);
                          //   },
                          //   // child: Text(
                          //   //   'Login using OTP',
                          //   //   style: Styles.textExtraBoldUnderline(
                          //   //       size: 16, color: ColorConstants.WHITE),
                          //   // ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Column(
                              children: [
                                Text(
                                    '${Strings.of(context)?.byClickingContinue}',
                                    style: Styles.regular(
                                        size: 10, color: Colors.white)),
                                SizedBox(width: 10),
                                Text(
                                  '${Strings.of(context)?.byClickingContinueUnderline}',
                                  style: Styles.regular(
                                      size: 12, color: ColorConstants.WHITE),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
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
        cursorColor: ColorConstants.WHITE,
        style: Styles.regularWhite(),
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
                ?
                //SvgPicture.asset('assets/images/email.svg',color: ColorConstants.WHITE)
                Icon(
                    Icons.email_outlined, color: ColorConstants.WHITE,
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
                          color: ColorConstants.WHITE,
                          // size: 30,
                          // color: ColorConstants.GREY,
                        )
                      : Icon(
                          Icons.visibility_off,
                          color: ColorConstants.WHITE,
                        )),
            ),
          ),
          hintStyle: Styles.regular(size: 18, color: ColorConstants.WHITE),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: ColorConstants.WHITE, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: ColorConstants.WHITE, width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: ColorConstants.WHITE, width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: ColorConstants.WHITE, width: 1)),
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
