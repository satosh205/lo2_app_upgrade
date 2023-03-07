import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:masterg/blocs/auth_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/auth_request/login_request.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/user_info_response.dart';
import 'package:masterg/pages/auth_pages/choose_language.dart';
import 'package:masterg/pages/auth_pages/singularis_login_username_pass.dart';
import 'package:masterg/pages/auth_pages/terms_and_condition_page.dart';
import 'package:masterg/pages/auth_pages/verify_otp.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/config.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:masterg/utils/widget_size.dart';
import 'package:path_provider/path_provider.dart';

@immutable
class SignUpScreen extends StatefulWidget {
  bool isFromProfile;

  SignUpScreen({this.isFromProfile = false});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final phoneController = TextEditingController();
  FocusNode phoneFocus = FocusNode();
  bool isFocused = false;
  // FocusNode phoneFocus1 = FocusNode();

  DateTime selectedDate = DateTime.now();
  final picker = ImagePicker();
  late String selectedImage;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late String gender = "male";


  UserData userData = new UserData();

  void initHive() async {
    await getApplicationDocumentsDirectory().then((value) {
      Hive.init(value.path);
      Hive.openBox(DB.CONTENT);
      Hive.openBox(DB.ANALYTICS);
      Hive.openBox(DB.TRAININGS);
      Hive.openBox('theme');
    });
  }

  @override
  void initState() {
    super.initState();
    initHive();
    phoneFocus.addListener(_onFocusChange);
    if (widget.isFromProfile) {
      userData = UserData.fromJson(json.decode(UserSession.userData!));
      phoneController.text = UserSession.phone!;
      gender = UserSession.gender!;
      UserSession.userImageUrl = userData.profileImage;
      Log.v(userData.branch);
    }
  }

  void _onFocusChange() {
    setState(() {
      isFocused = phoneFocus.hasFocus;
    });
  }



  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginState) _handleLoginResponse(state);
          },
          child: Scaffold(
            backgroundColor: ColorConstants.WHITE,
            appBar: AppBar(
              toolbarHeight: 22,
              backgroundColor: ColorConstants.WHITE,
              elevation: 0,
              // leading: IconButton(
              //     padding: const EdgeInsets.all(0),
              //     onPressed: () => Navigator.pushReplacement(
              //         context,
              //         NextPageRoute(
              //             ChooseLanguage(
              //               showEdulystLogo: true,
              //             ),
              //             isMaintainState: false)),
              //     icon: Icon(
              //       CupertinoIcons.back,
              //       color: ColorConstants.BLACK,
              //     )),
            ),
            body: ScreenWithLoader(
              isLoading: _isLoading,
              body: _makeBody(),
            ),
          ),
        ));
  }

  _makeBody() {
    String appBarImagePath = 'assets/images/${APK_DETAILS['theme_image_url']}';
    return Form(
      key: _formKey,
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        physics: isFocused
            ? BouncingScrollPhysics()
            : NeverScrollableScrollPhysics(),
        //mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: height(context)*0.4,
            child: Column(
              
              children: [
                Text(
                  "Welcome to",style: Styles.regular(size:18,color: Color(0xff5A5F73))),
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
                          height: 60,
                          width: 180,
                        ),
                ),
                // SizedBox(height: 10),
                /*Text(
                    '${Strings.of(context)?.GiveYourCreativityNewPath}',
                    style: Styles.semibold()),
                SizedBox(height: 20),*/
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
                // SizedBox(
                //     height:
                //         MediaQuery.of(context).size.height * 0.25,
                //     child: Image.asset(
                //         'assets/images/signupimage.gif')),
              ],
            ),
          ),
          // SizedBox(
          //   height: 20,
          // ),
          Container(
            
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [
                ColorConstants.GRADIENT_ORANGE,
                ColorConstants.GRADIENT_RED,
              ]),
            ),
            height: height(context) * 0.6,
            child: Column(
              children: [
                SizedBox(height: 20),
                Text('${Strings.of(context)?.login}',
                    style: Styles.bold(size: 18, color: ColorConstants.WHITE)),
                SizedBox(
                  height: 2,
                ),
                Text('${Strings.of(context)?.loginCreateAccount}',
                    style:
                        Styles.regular(size: 16, color: ColorConstants.WHITE)),

                // Text('${Strings.of(context)?.phoneNumber}',
                //     style: Styles.regular(size: 16)),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      IntlPhoneField(
                    dropdownTextStyle: TextStyle(color: ColorConstants.WHITE),
                        initialCountryCode: 'IN',
                        dropdownIcon: Icon(Icons.arrow_drop_down,color: ColorConstants.WHITE,),
                        cursorColor: ColorConstants.WHITE,
                        autofocus: false,
                        focusNode: phoneFocus,
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        style: Styles.bold(
                          color: ColorConstants.WHITE,
                          size: 14,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        // maxLength: 10,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: ColorConstants.WHITE,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: ColorConstants.WHITE,
                              width: 0.7,
                            ),
                          ),
                          fillColor: ColorConstants.WHITE,
                          hintText: '${Strings.of(context)?.yourMobileNumber}',
                          hintStyle:  Styles.regular(
                                color: ColorConstants.WHITE,
                                size: 14,
                              ),
                          isDense: true,
                          prefixIconConstraints:
                              BoxConstraints(minWidth: 0, minHeight: 0),
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.only(left: 8.0),
                          //   child: Text(
                          //     "+91 ",
                          //     style: Styles.regular(
                          //       color: ColorConstants.WHITE,
                          //       size: 14,
                          //     ),
                          //   ),
                            
                          // ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.7, color: ColorConstants.WHITE),
                              borderRadius: BorderRadius.circular(10)),

                          helperStyle: Styles.regular(
                              size: 14,
                              color: ColorConstants.GREY_3.withOpacity(0.1)),
                          counterText: "",
                          // enabledBorder: UnderlineInputBorder(
                          //   borderSide: BorderSide(
                          //       color: ColorConstants.WHITE, width: 1.5),
                          // ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        // validator: (value) {
                        //   if (value == null) return 'Enter phone number';
                        //   if (value.length != 10) {
                        //     return "Enter valid phone number.";
                        //   }
                        //   return null;
                        // },
                      ),
                    
                      Positioned(
                          right: 0,
                          
                          child: InkWell(
                            onTap: () {
                              if (phoneController.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                                if (phoneController.text.toString().length ==
                                    10) {
                                  doLogin();
                                } else {
                                  Utility.showSnackBar(
                                      scaffoldContext: context,
                                      message: 'Enter valid phone number.');
                                }
                              } else {
                                Utility.showSnackBar(
                                    scaffoldContext: context,
                                    message: 'Enter phone number.');
                              }
                            },
                            child: Container(
                              //height: height(context) * 0.07,
                              height: 50,
                              width: width(context) * 0.26,
                              decoration: const BoxDecoration(
                                  color: ColorConstants.WHITE,
                                  //borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),topRight: Radius.circular(10),bottomRight: Radius.circular(10))),
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              // child: Text('Get OTP'),
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
                                    "GET OTP",
                                    style: Styles.regular(
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                // SizedBox(height: 20.0),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SingularisLogin()));
                  },
                  child: Container(
                    // margin: EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height *
                        WidgetSize.AUTH_BUTTON_SIZE,
                  
                    child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/email.svg',
                        color: ColorConstants.WHITE,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${Strings.of(context)?.continueStr} with ${Strings.of(context)?.email}',
                        style: Styles.semibold(
                          size: 14, 
                          color: ColorConstants.WHITE,
                        ),
                      ),
                    ],
                    ),
                  ),
                ),
                // Center(
                //     child: InkWell(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => SingularisLogin()));
                //   },
                //   // child: Text('Login using username and password',
                //   //     style: Styles.textExtraBoldUnderline(
                //   //       color: ColorConstants().primaryColor(),
                //   //     )),
                // )),
                // SizedBox(
                //   height: 10,
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 110.0),
                  child: InkWell(
                    onTap: (){
                        Navigator.push(
                        context,
                        NextPageRoute(
                            TermsAndCondition(url: APK_DETAILS['policy_url']),
                            isMaintainState: false));
                    },
                    child: Column(
                      children: [
                        Text('${Strings.of(context)?.byClickingContinue}',
                            style:
                                Styles.regular(size: 10, color: Colors.white)),
                        Text(
                          '${Strings.of(context)?.byClickingContinueUnderline}',
                          style: Styles.regular(
                              size: 12, color: ColorConstants.WHITE),
                        ),
                      ],
                    ),
                  ),
                ),

                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 10),
                //     child: Text(
                //       '${Strings.of(context)?.havingTrouble}',
                //       style:
                //           Styles.regular(size: 10, color: ColorConstants.GREY_2),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
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
          Navigator.push(
              context,
              NextPageRoute(VerifyOtp(
                phoneController.text.toString(),
              )));
          _isLoading = false;
          break;

        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v(
              "Error..........................${loginState.response?.error?[0]}");
          AlertsWidget.alertWithOkBtn(
              context: context,
              text: loginState.response?.error?[0],
              onOkClick: () {
                FocusScope.of(context).unfocus();
              });
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void doLogin() {
    setState(() {
      _isLoading = true;
    });
    if (!_formKey.currentState!.validate()) return;

    BlocProvider.of<AuthBloc>(context).add(LoginUser(
        request: LoginRequest(
            mobileNo: phoneController.text.toString().trim(),
            mobile_exist_skip: '1')));
  }

  void showFileChoosePopup() {
    //  Utility.hideKeyboard();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        // return object of type Dialog
        return SimpleDialog(
          backgroundColor: ColorConstants().primaryColor(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                color: ColorConstants().primaryColor(),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      Strings.of(context)!.photoAlert!,
                      style: Styles.regularWhite(size: 18),
                    ),
                  ),
                  InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(Strings.of(context)!.takeAPicture!,
                            style: Styles.regularWhite(size: 16)),
                      ),
                      onTap: () {
                        _getImages(ImageSource.camera).then((value) {
                          Navigator.pop(context);
                          if (value == null || value.isEmpty) return;
                          setState(() {
                            UserSession.userImageUrl = null;
                            selectedImage = value;
                          });
                        });
                      }),
                  InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(Strings.of(context)!.pickFromGallery!,
                            style: Styles.regularWhite(size: 16)),
                      ),
                      onTap: () async {
                        _getImages(ImageSource.gallery).then((value) {
                          Navigator.pop(context);
                          if (value == null || value.isEmpty) return;
                          setState(() {
                            UserSession.userImageUrl = null;
                            selectedImage = value;
                          });
                        });
                      }),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<String> _getImages(ImageSource source) async {
    final picker = ImagePicker();
    PickedFile? pickedFile = await picker.getImage(source: source);
    if (pickedFile != null)
      return pickedFile.path;
    else if (Platform.isAndroid) {
      final LostData response = await picker.getLostData();
      if (response.file != null) {
        return response.file!.path;
      }
    }
    return "";
  }
}
