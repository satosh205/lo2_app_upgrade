import 'dart:io';

//import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/utils/config.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
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
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pinput/pinput.dart';
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
  // var phoneFocus = FocusNode();
  FocusNode focusNode = FocusNode();

  String? changePasswordStatus = null;
  String _pin = "";
  String? deviceId;
  bool resendFlag = false;
  List<Menu>? menuList;
  bool isFocused = false;
  //NotificationHelper? _notificationHelper;
  ///Add New code for OTP AutoFill
  late OTPTextEditController otpController;
  late OTPInteractor _otpInteractor;
  String otpCode = '';

  Future<Null> _getId() async {
  //var deviceInfo = DeviceInfoPlugin();
  /*if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
   deviceId =  iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if(Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
   //deviceId = androidDeviceInfo.androidId; // unique ID on Android
   deviceId = androidDeviceInfo.id; // unique ID on Android
  }*/

  setState(() {
    
  });
}


  @override
  void initState() {
    super.initState();
     focusNode.addListener(_onFocusChange);
    _getId();

    ///Add New code for OTP AutoFill
      //_notificationHelper = NotificationHelper.getInstance(context);
    //_notificationHelper?.setFcm();
    //_notificationHelper?.getFcmToken();

    _otpInteractor = OTPInteractor();
    _otpInteractor.getAppSignature()
    //ignore: avoid_print
        .then((value) => print('signature - $value'));
    print(_otpInteractor.getAppSignature());
    otpController = OTPTextEditController(
      codeLength: 4,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent((code) {
        final exp = RegExp(r'(\d{4})');
        return exp.stringMatch(code ?? '') ?? '';
      },
      /*strategies: [
        SampleStrategy('Your code is otp 52222'),
        //SampleStrategy(otpCode),
      ],*/
    );
  }

   void _onFocusChange(){
    setState(() {
      isFocused = focusNode.hasFocus;
    });
  }

  ///Add New code for OTP AutoFill
  @override
  Future<void> dispose() async {
    // await otpController.stopListen();
    super.dispose();
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
          // Navigator.of(context).pop();
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

          Preference.setInt(Preference.APP_LANGUAGE, Preference.getInt(Preference.APP_LANGUAGE) ?? 1);
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
                MaterialPageRoute(builder: (context)=> SelfDetailsPage(
                  phoneNumber: widget.username,
                )));
          else {
            AlertsWidget.showCustomDialog(
                context: context,
                title: "${loginState.error}",
                text: "",
                icon: 'assets/images/circle_alert_fill.svg',
                oKText: '${Strings.of(context)?.ok}',
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

  final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  @override
  Widget build(BuildContext context) {
    String appBarImagePath = 'assets/images/${APK_DETAILS['theme_image_url']}';

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
          //title: Text(''),
          title: Text(otpCode),
          iconTheme: IconThemeData(color: ColorConstants.BLACK),
        ),
        body: ScreenWithLoader(
          isLoading: _isLoading,
          body: SingleChildScrollView(
          //physics: isFocused ? BouncingScrollPhysics():  NeverScrollableScrollPhysics(),
            child: Container(
               //height: height(context)*2,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  "Welcome to",style: Styles.regular(size:18,color: Color(0xff5A5F73))),
                  Center(
                    child: Column(
                      children: [
                     Transform.scale(
                    scale: 1.2,
                    child:        appBarImagePath.split('.').last == 'svg'
                            ? SvgPicture.asset(
                                appBarImagePath,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                appBarImagePath,
                                height: 40,
                                width: 180,
                              )),
                        // SvgPicture.asset(
                        //   'assets/images/masterg_logo.svg',
                        //   height: 75,
                        //   width: 173,
                        //   allowDrawingOutsideViewBox: true,
                        // ),
                        // SizedBox(height: 10),
                        // SizedBox(height: 10),
                        // Text(
                        //     '${Strings.of(context)?.GiveYourCreativityNewPath} ',
                        //     style: Styles.semibold()),
                        // SizedBox(height: 20),
                      APK_DETAILS['package_name'] == 'com.at.masterg' ?   SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child:
                                Image.asset('assets/images/signupimage.gif')) :    APK_DETAILS['theme_image_url2']?.split('.').last == 'svg'
                                ? SvgPicture.asset(
                                        height:
                                    MediaQuery.of(context).size.height * 0.25,
                            'assets/images/${APK_DETAILS['theme_image_url2']}',
                              fit: BoxFit.cover,
                            )
                                : Image.asset(
                            'assets/images/${APK_DETAILS['theme_image_url2']}',
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                              // width: 150,
                            ),
                      ],
                    ),
                  ),
                //  SizedBox(height: 20),
                //   Center(
                //     child: Text(
                //       '${Strings.of(context)?.verificationTitle} +91 ${widget.username}',
                //       style: Styles.regular(size: 15),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                  _size(height: 50),
                  Container(
                    decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              gradient: LinearGradient(colors: [
                ColorConstants.GRADIENT_ORANGE,
                ColorConstants.GRADIENT_RED,
              ]),
          ),
          height: height(context) * 0.5,
                    child: Column(children: [
                     Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top:30.0),
                      child: Text(
                        '${Strings.of(context)?.verify_your_mobile}',
                        style: Styles.bold(color: ColorConstants.WHITE),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                  ),
                  
                  _size(height: 25),
                  // _otpVerificationPart(),
          
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45),
                      /*child: OtpTextField(
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
                          }),*/
          
                      child: Pinput(
                        defaultPinTheme: defaultPinTheme,
                        length: 4,
                        controller: otpController,
                        onChanged: (String code){
                          setState(() {
                            _pin = code;
                          });
                        },
                        focusNode: focusNode,
                        onSubmitted: (String pin){
                          setState(() {
                            _pin = pin;
                          });
                        },
                      ),
          
                      /*child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: otpController,
                      ),*/
                    ),
                  ),
          
                  //_size(height: 30),
                  /*Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                        height: 1,
                        color: ColorConstants.SELECTED_PAGE,
                        thickness: 1.2),
                  ),*/

                  _size(height: 10),
                  
                  _size(height: height(context) * 0.10),
                  InkWell(
                      onTap: () {
                        if (_pin.isNotEmpty) {
                          if (_pin.length == 4) {
                            verifyOTP();
                          } else {
                            Utility.showSnackBar(
                                scaffoldContext: context,
                                message: '${Strings.of(context)?.enterValidOtp}');
                          }
                        } else {
                          Utility.showSnackBar(
                              scaffoldContext: context, message: '${Strings.of(context)?.enterOtp}');
                        }
                      },
                      child: Container(
                        
                        margin: EdgeInsets.all(12),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.06,
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
                          style: Styles.regular(size: 16,
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
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Icon(Icons.arrow_back_ios_new,color: Colors.white,size: 15,),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                         
                      child:    Text(
                            '${Strings.of(context)?.changePhoneNumber}',
                            style: Styles.regular(
                                size: 12, color: ColorConstants.WHITE),
                          ),
                        ),
                        Expanded(child: SizedBox(),),
                        CountdownTimer(
                          endTime: endTime,
                          widgetBuilder: (_, CurrentRemainingTime? time) {
                            return RichText(
                              text: TextSpan(
                                  text: '',
                                  style: TextStyle(
                                    fontSize: 3,
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
                                                color: ColorConstants.WHITE))
                                        : TextSpan(text: 'Resend in ${time.sec} secs', style:Styles.regular(
                                                size: 12,
                                                color: ColorConstants.WHITE) ),
                                  ]),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],),),
                 
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

    print(UserSession.firebaseToken);
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
