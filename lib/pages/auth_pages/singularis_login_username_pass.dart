import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/blocs/auth_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/auth_request/swayam_login_request.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/main.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/TapWidget.dart';
import 'package:masterg/pages/swayam_pages/notification_helper.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/config.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
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
  bool _autoValidation = false;
  var _isObscure = true;

  @override
  void initState() {
    // _notificationHelper.getFcmToken();
    super.initState();
  }

  void _handleLoginResponse(LoginState state) {
    try {
      Log.v("State is ${state.apiState}");
      setState(() {
        switch (state.apiState) {
          case ApiStatus.LOADING:
            _isLoading = true;
            break;
          case ApiStatus.SUCCESS:
            _isLoading = false;
            // print(Preference.getBool(Preference.IS_ON_BOARDING_COMPLETE));
            // if (Preference.getBool(Preference.IS_ON_BOARDING_COMPLETE)) {
            //   Navigator.pushAndRemoveUntil(_scaffoldContext,
            //       NextPageRoute(DashboardPage()), (route) => false);
            // } else {
            //   Navigator.pushAndRemoveUntil(_scaffoldContext,
            //       NextPageRoute(OnBoardingPage()), (route) => false);

            // }
            break;
          case ApiStatus.ERROR:
            _isLoading = false;
            Log.v("data ${state.error}");
            Utility.showSnackBar(
                scaffoldContext: _scaffoldContext, message: state.error);
            break;
          case ApiStatus.INITIAL:
            break;
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Application(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocManager(
      initState: (context) {},
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginState) _handleLoginResponse(state);
        },
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
              // Image.asset(
              //   Images.LOGIN_IMAGE,
              //   height: 150,
              //   width: 150,
              // ),
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
                        height: MediaQuery.of(context).size.height * 0.25,
                        'assets/images/${APK_DETAILS['theme_image_url2']}',
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/${APK_DETAILS['theme_image_url2']}',
                        height: MediaQuery.of(context).size.height * 0.25,
                        // width: 150,
                      ),
              _size(height: 25),
              Text('Welcome Back!', style: Styles.bold(size: 22)),
              _size(),
              Text('Enter your login credentails to continue',
                  style: Styles.regular(size: 16)),
              _size(height: 25),
              _textField(
                controller: _emailController,
                hintText: 'Enter your email',
                // prefixImage: Icon(Icons.email),
                // validation: validateUserName,
              ),
              _size(height: 10),
              _textField(
                  controller: _passController,
                  hintText: 'Password',
                  // prefixImage: Images.LOCK,
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
                  _size(height: 7),
                  TapWidget(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Login using OTP',
                      style: Styles.textExtraBoldUnderline(
                        size: 16,
                      ),
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
    TextEditingController? controller,
    String? hintText,
    String? prefixImage,
    bool obscureText = false,
    Function(String)? validation,
    Function()? onEyePress,
  }) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        style: TextStyle(fontSize: 18),
        controller: controller,
        // validator: validation,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          // prefixIcon: Padding(
          //   padding: const EdgeInsets.all(5),
          //   child: Image.asset(
          //     prefixImage,
          //     height: 32,
          //     width: 32,
          //   ),
          // ),
          // suffixIcon: Visibility(
          //   visible: onEyePress != null,
          //   child: TapWidget(
          //     onTap: onEyePress,
          //     child: Padding(
          //       padding: const EdgeInsets.only(right: 5),
          //       child: !obscureText
          //           ? Icon(
          //               Icons.remove_red_eye_outlined,
          //               size: 30,
          //               color: ColorConstants.GREY,
          //             )
          //           : Image.asset(Images.EYE_HIDE),
          //     ),
          //   ),
          // ),
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
          style: Styles.regularWhite(size: 18),
        ),
      ),
    );
  }
}
