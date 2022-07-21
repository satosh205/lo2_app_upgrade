import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:masterg/blocs/auth_bloc.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/auth_request/email_request.dart';
import 'package:masterg/data/models/request/auth_request/login_request.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/auth_pages/self_details_page.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/ghome/home_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
//import 'package:otp_text_field/otp_field.dart';

class VerifyOtp extends StatefulWidget {
  String username;

  VerifyOtp(this.username);

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  bool _isLoading = false;
  //OtpFieldController _otpController = OtpFieldController();
  var phoneFocus = FocusNode();
  String? changePasswordStatus = null;

  String _pin = "";
  String? deviceId;

  bool resendFlag = false;
  List<Menu>? menuList;

  // NotificationHelper? _notificationHelper;

  @override
  void initState() {
    super.initState();
  }

  void _handleLoginResponseOTP(LoginState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          print('=================OTP');
          Navigator.of(context).pop();
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
                FocusScope.of(context).unfocus();
              });
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void getBottomNavigationBar() {
    BlocProvider.of<HomeBloc>(context).add((GetBottomNavigationBarEvent()));
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
          menuList?.sort((a, b) => a.inAppOrder!.compareTo(b.order!));

          if (menuList?.length == 0) {
            AlertsWidget.alertWithOkBtn(
                context: context,
                text: 'App Under Maintenance!',
                onOkClick: () {
                  FocusScope.of(context).unfocus();
                });
          } else {
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

  void _handleVerifyResponse(VerifyOtpState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success ....................");
          if (state.response!.isCompleted == null)
            state.response!.isCompleted = 0;

          Preference.setInt(Preference.APP_LANGUAGE,
              Preference.getInt(Preference.APP_LANGUAGE) ?? 1);
          Preference.setInt(Preference.CONTENT_LANGUAGE, 1);

          Preference.setString(
              Preference.FIRST_NAME, '${state.response!.data!.user!.name}');
          Preference.setInt(
              Preference.USER_ID, state.response!.data!.user!.id!);
          Preference.setString(
              Preference.USER_EMAIL, '${state.response!.data!.user!.email}');
          Preference.setString(
              Preference.USER_TOKEN, '${state.response!.data!.token}');
          Preference.setString(
              Preference.PHONE, '${state.response!.data!.user!.mobileNo}');
          Preference.setString(Preference.PROFILE_IMAGE,
              '${state.response!.data!.user!.profileImage}');
          Preference.setString(
              'interestCategory', '${state.response!.data!.user!.categoryIds}');
          Preference.setString(Preference.DEFAULT_VIDEO_URL_CATEGORY,
              '${state.response!.data!.user!.defaultVideoUrlOnCategory}');

          debugPrint(
              "the user pref data is ${Preference.getString(Preference.USER_TOKEN)}");

          getBottomNavigationBar();

          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................${loginState.status}");
          Log.v("Error..........................${loginState.error}");

          if (loginState.status == 2)
            Navigator.push(
                context,
                NextPageRoute(SelfDetailsPage(
                  phoneNumber: widget.username,
                )));
          else {
            AlertsWidget.showCustomDialog(
                context: context,
                title: "Invalid OTP",
                text: "",
                icon: 'assets/images/circle_alert_fill.svg',
                oKText: 'Ok',
                showCancel: false,
                onOkClick: () async {
                  // Navigator.pop(context);
                });
          }

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      // initState: (BuildContext context) {},
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (BuildContext context, state) {
            if (state is LoginState) _handleLoginResponseOTP(state);
            if (state is VerifyOtpState) _handleVerifyResponse(state);
            // if(state is GetBottomBarState) _handelBottomNavigationBar(state);
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorConstants.WHITE,
          title: Text(''),
          iconTheme: IconThemeData(color: ColorConstants.BLACK),
        ),
        body: ScreenWithLoader(
          isLoading: _isLoading,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/app_icon.jpg',
                          height: 100,
                          width: 150,
                        ),
                        // SvgPicture.asset(
                        //   'assets/images/masterg_logo.svg',
                        //   height: 75,
                        //   width: 173,
                        //   allowDrawingOutsideViewBox: true,
                        // ),
                        SizedBox(height: 10),
                        // SizedBox(height: 10),
                        Text(
                            '${Strings.of(context)?.GiveYourCreativityNewPath} ',
                            style: Styles.semibold()),
                        SizedBox(height: 20),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child:
                                Image.asset('assets/images/signupimage.png')),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      '${Strings.of(context)?.verificationTitle} +91 ${widget.username}',
                      style: Styles.regular(size: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _size(height: 10),
                  Center(
                    child: Text(
                      '${Strings.of(context)?.verify_your_mobile}',
                      style: Styles.bold(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _size(height: 4),
                  // _otpVerificationPart(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: OtpTextField(
                        //controller: _otpController,
                        keyboardType: Platform.isIOS
                            ? TextInputType.numberWithOptions(
                                signed: true, decimal: true)
                            : TextInputType.number,
                        numberOfFields: 4,
                        borderColor: Colors.orange,
                        //set to true to show as box or false to show as dash
                        showFieldAsBox: false,
                        autoFocus: false,
                        //length: 4,
                        //width: MediaQuery.of(context).size.width,
                        //textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 45,
                        // fieldStyle: FieldStyle.underline,
                        //outlineBorderRadius: 15,
                        //style: TextStyle(fontSize: 17),
                        onCodeChanged: (String code) {
                          print("Changed: " + code);
                          setState(() {
                            _pin = code;
                          });
                        },
                        onSubmit: (String pin) {
                          print("Completed: " + pin);
                          setState(() {
                            _pin = pin;
                          });
                        }),
                  ),

                  _size(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                        height: 1,
                        color: ColorConstants.SELECTED_PAGE,
                        thickness: 1.2),
                  ),

                  _size(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '${Strings.of(context)?.changePhoneNumber}',
                            style: Styles.regular(
                                size: 12, color: ColorConstants.BLACK),
                          ),
                        ),
                        CountdownTimer(
                          endTime: endTime,
                          widgetBuilder: (_, CurrentRemainingTime? time) {
                            return RichText(
                              text: TextSpan(
                                  text: '',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                  children: <TextSpan>[
                                    time == null
                                        ? TextSpan(
                                            text:
                                                '${Strings.of(context)?.resend}',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                resendOTP();
                                              },
                                            style: Styles.regular(
                                                size: 12,
                                                color: ColorConstants.BLACK))
                                        : TextSpan(text: ''),
                                  ]),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  _size(height: 30),
                  InkWell(
                      onTap: () {
                        if (_pin.isNotEmpty) {
                          if (_pin.length == 4) {
                            verifyOTP();
                          } else {
                            Utility.showSnackBar(
                                scaffoldContext: context,
                                message: 'Enter valid OTP.');
                          }
                        } else {
                          Utility.showSnackBar(
                              scaffoldContext: context, message: 'Enter OTP.');
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(12),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                            color: _pin.length != 4
                                ? ColorConstants()
                                    .buttonColor()
                                    .withOpacity(0.5)
                                : ColorConstants().buttonColor(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          '${Strings.of(context)?.continueStr}',
                          style: Styles.regular(
                            color: ColorConstants.WHITE,
                          ),
                        )),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _size({double height = 20}) {
    return SizedBox(
      height: height,
    );
  }

  void verifyOTP() {
    setState(() {
      _isLoading = true;
    });
    Utility.hideKeyboard();
    if (_pin.length != 4) {
      return;
    }

    Utility.checkNetwork().then((isConnected) {
      if (isConnected) {
        var verifyOtp = EmailRequest(
            mobileNo: widget.username,
            optKey: _pin,
            deviceType: Utility.getDeviceType(),
            deviceId: deviceId,
            locale: Strings.of(context)!.locale.languageCode == 'hi'
                ? 'Hindi'
                : 'English',
            deviceToken: UserSession.firebaseToken);
        BlocProvider.of<AuthBloc>(context)
            .add(VerifyOtpEvent(request: verifyOtp));
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

  void resendOTP() {
    setState(() {
      _isLoading = true;
    });
    BlocProvider.of<AuthBloc>(context).add(LoginUser(
        request:
            LoginRequest(mobileNo: widget.username, mobile_exist_skip: '1')));
  }
}
