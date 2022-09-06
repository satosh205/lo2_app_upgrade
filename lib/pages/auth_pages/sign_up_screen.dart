import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterg/pages/auth_pages/self_details_page.dart';
import 'package:masterg/utils/config.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:masterg/blocs/auth_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/auth_request/login_request.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/user_info_response.dart';
import 'package:masterg/pages/auth_pages/choose_language.dart';
import 'package:masterg/pages/auth_pages/terms_and_condition_page.dart';
import 'package:masterg/pages/auth_pages/verify_otp.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:masterg/utils/widget_size.dart';
import 'package:path_provider/path_provider.dart';

class SignUpScreen extends StatefulWidget {
  bool isFromProfile;

  SignUpScreen({this.isFromProfile = false});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final phoneController = TextEditingController();
  FocusNode phoneFocus = FocusNode();
  FocusNode phoneFocus1 = FocusNode();

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
    if (widget.isFromProfile) {
      userData = UserData.fromJson(json.decode(UserSession.userData!));
      phoneController.text = UserSession.phone!;
      gender = UserSession.gender!;
      UserSession.userImageUrl = userData.profileImage;
      Log.v(userData.branch);
    }
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
              backgroundColor: ColorConstants.WHITE,
              elevation: 0,
              leading: IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () => Navigator.pushReplacement(context,
                      NextPageRoute(ChooseLanguage(), isMaintainState: false)),
                  icon: Icon(
                    CupertinoIcons.back,
                    color: ColorConstants.BLACK,
                  )),
            ),
            body: KeyboardActions(
              config: KeyboardActionsConfig(
                keyboardBarColor: Colors.orange,
                actions: [
                  KeyboardActionsItem(focusNode: phoneFocus),
                ],
              ),
              child: ScreenWithLoader(
                isLoading: _isLoading,
                body: _makeBody(),
              ),
            ),
          ),
        ));
  }

  _makeBody() {
    String appBarImagePath = 'assets/images/${APK_DETAILS['theme_image_url']}';
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 6, right: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            appBarImagePath.split('.').last == 'svg'
                                ? SvgPicture.asset(
                                    appBarImagePath,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    appBarImagePath,
                                    height: 150,
                                    width: 150,
                                  ),
                            SizedBox(height: 10),
                            /*Text(
                                '${Strings.of(context)?.GiveYourCreativityNewPath}',
                                style: Styles.semibold()),
                            SizedBox(height: 20),*/
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Image.asset(
                                    'assets/images/signupimage.png')),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('${Strings.of(context)?.LetsStartYourJourney}',
                          style: Styles.bold()),
                      SizedBox(
                        height: 2,
                      ),
                      Text('${Strings.of(context)?.loginCreateAccount}',
                          style: Styles.regular(size: 12)),
                      SizedBox(height: 20),
                      Text('${Strings.of(context)?.phoneNumber}',
                          style: Styles.regular(size: 16)),
                      SizedBox(
                        height: 1,
                      ),
                      TextFormField(
                        autofocus: true,
                        focusNode: Platform.isIOS ? phoneFocus : phoneFocus1,
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        style: Styles.bold(
                          size: 14,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: '${Strings.of(context)?.yourMobileNumber}',
                          isDense: true,
                          prefixIconConstraints:
                              BoxConstraints(minWidth: 0, minHeight: 0),
                          prefixIcon: Text(
                            "+91 ",
                            style: Styles.bold(
                              size: 14,
                            ),
                          ),
                          helperStyle: Styles.regular(
                              size: 14,
                              color: ColorConstants.GREY_3.withOpacity(0.1)),
                          counterText: "",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: ColorConstants().primaryColor(),
                                width: 1.5),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null) return 'Enter phone number';
                          if (value.length != 10) {
                            return "Enter valid phone number.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      InkWell(
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
                            margin: EdgeInsets.symmetric(vertical: 12),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height *
                                WidgetSize.AUTH_BUTTON_SIZE,
                            decoration: BoxDecoration(
                                color: phoneController.value.text.length != 10
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              NextPageRoute(
                                  TermsAndCondition(
                                      url: APK_DETAILS['policy_url']),
                                  isMaintainState: false));
                        },
                        child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        '${Strings.of(context)?.byClickingContinue}',
                                    style: Styles.regular(size: 10)),
                                TextSpan(
                                  text:
                                      '${Strings.of(context)?.byClickingContinueUnderline}',
                                  style: Styles.bold(
                                      size: 10, color: ColorConstants.GREY_2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            '${Strings.of(context)?.havingTrouble}',
                            style: Styles.regular(
                                size: 10, color: ColorConstants.GREY_2),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
                borderRadius: BorderRadius.all(Radius.circular(20)),
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
