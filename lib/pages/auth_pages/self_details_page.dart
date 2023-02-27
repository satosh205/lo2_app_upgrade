import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterg/blocs/auth_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/auth_request/signup_request.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/auth_response/login_by_id_response.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/auth_pages/select_interest.dart';
import 'package:masterg/pages/auth_pages/terms_and_condition_page.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/user_profile_page/mobile_ui_helper.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/config.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/widget_size.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/click_picker.dart';

class SelfDetailsPage extends StatefulWidget {
  bool isFromProfile;
  final phoneNumber;
  final String? email;
  final String? password;
  final bool? loginWithEmail;

  List<Menu>? menuList;

  SelfDetailsPage({this.isFromProfile = false, this.phoneNumber, this.email, this.password, this.loginWithEmail = false});

  @override
  _SelfDetailsPageState createState() => _SelfDetailsPageState();
}

class _SelfDetailsPageState extends State<SelfDetailsPage>
    with SingleTickerProviderStateMixin {
  final phoneController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  bool? checkedValue = false;

  String? selectedImage;
  List<LoginByIdResp>? loginResp;
  late AnimationController controller;
  Animation<Offset>? offset;

  //final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    phoneController.text = widget.phoneNumber ?? '';
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 5.0))
        .animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is SignUpState) _handleResponse(state);
              // if (state is LoginByIDState) _handleLoginResponse(state);
            },
            /*child: WillPopScope(
              onWillPop: () async => false,
              child:
            )*/
          child: Scaffold(
            backgroundColor: ColorConstants.WHITE,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: Text('${Strings.of(context)?.TellUsAboutYourSelf}',
                style: Styles.semibold(color: ColorConstants.BLACK, size: 16),
              ),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: ColorConstants.BLACK,
                ),
              ),
              elevation: 0.0,
            ),
            body: SafeArea(
                child: ScreenWithLoader(
                  isLoading: _isLoading,
                  body: _makeBody(),
                )),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        if (checkedValue == true) saveChanges();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            ColorConstants.GRADIENT_ORANGE,
                            ColorConstants.GRADIENT_RED,
                          ]),
                        ),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height *
                            WidgetSize.AUTH_BUTTON_SIZE,
                        margin: EdgeInsets.symmetric(
                            vertical: 2, horizontal: 16),
                        // decoration: BoxDecoration(
                        //     color: checkedValue == false
                        //         ? ColorConstants()
                        //             .buttonColor()
                        //             .withOpacity(0.5)
                        //         : ColorConstants().buttonColor(),
                        //     borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                              '${Strings.of(context)?.continueStr}',
                              style: Styles.semibold(
                                color: ColorConstants.WHITE,
                              ),
                            )),
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  _makeBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /*Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(height: 10),
                    Text('${Strings.of(context)?.TellUsAboutYourSelf}',
                        style: Styles.bold()),
                    SizedBox(height: 40),
                  ],
                ),
              ),*/
              SizedBox(height: 30,),
              Center(
                child: Stack(
                  children: [
                    selectedImage != null && selectedImage!.isNotEmpty
                        ? Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(File('$selectedImage')),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: null /* add child content here */,
                          )
                        : SvgPicture.asset(
                            'assets/images/default_user.svg',
                            height: 100.0,
                            width: 100.0,
                            allowDrawingOutsideViewBox: true,
                          ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                          width: 30,
                          height: 30,
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFF5F6F9)),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: Icon(Icons.camera_alt_outlined,
                                color: Colors.grey, size: 15),
                            onPressed: () {
                              showBottomSheet(context);
                            },
                          )),
                    ),
                    Positioned(
                      right: 10,
                      top: 0,
                      child: Text(
                        '',
                        style: Styles.regular(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Full Name*', style: Styles.regular(size: 12)),
              SizedBox(
                height: 6,
              ),
              Center(
                  child: Column(children: [
                TextFormField(
                  controller: fullNameController,
                  style: Styles.regular(),
                  maxLength: 100,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffE5E5E5)),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: '${Strings.of(context)?.EnterFullName}*',
                    helperStyle: Styles.regular(color: ColorConstants.GREY_4),
                    counterText: "",
                    suffixIconConstraints: BoxConstraints(minWidth: 0),
                    // suffixIcon: Text(
                    //   fullNameController.value.text.length > 0 ? '' : "*",
                    //   style: Styles.regular(color: ColorConstants.RED_BG),
                    // ),
                    // enabledBorder: UnderlineInputBorder(
                    //   borderSide: BorderSide(
                    //       color: ColorConstants.RED, width: 1.5),
                    // ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value!.length == 0)
                      return '${Strings.of(context)?.EnterFullName}';

                    return null;
                  },
                ),
              ])),
              SizedBox(
                height: 20,
              ),

              ///Email Fields
            widget.loginWithEmail == false ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email*', style: Styles.regular(size: 12)),
                  SizedBox(
                    height: 6,
                  ),
                  TextFormField(
                    controller: emailController,
                    style: Styles.regular(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                          const BorderSide(width: 1, color: Color(0xffE5E5E5)),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: '${Strings.of(context)?.emailAddress}',
                      helperStyle: Styles.regular(color: ColorConstants.GREY_4),
                      counterText: "",
                      // enabledBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(
                      //       color: ColorConstants.RED, width: 1.5),
                      // ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == '')
                        return APK_DETAILS['package_name'] == 'com.learn_build' ||
                            APK_DETAILS['package_name'] == 'com.singulariswow'
                            ? 'Email is required'
                            : null;
                      int index = value?.length as int;

                      if (value![index - 1] == '.')
                        return '${Strings.of(context)?.emailAddressError}';

                      if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value))
                        return '${Strings.of(context)?.emailAddressError}';

                      return null;
                    },
                  ),
                ],
              ) :
              ///Phone Number Fields
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone Number*', style: Styles.regular(size: 12)),
                  SizedBox(
                    height: 6,
                  ),
                  TextFormField(
                    controller: phoneController,
                    style: Styles.regular(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: Color(0xffE5E5E5)),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: '${Strings.of(context)?.phoneNumber}',
                      helperStyle: Styles.regular(color: ColorConstants.GREY_4),
                      counterText: "",
                      // enabledBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(
                      //       color: ColorConstants.RED, width: 1.5),
                      // ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == '')
                        return APK_DETAILS['package_name'] == 'com.learn_build' ||
                            APK_DETAILS['package_name'] == 'com.singulariswow'
                            ? 'Email is required'
                            : null;
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),
              Transform.translate(
                offset: Offset(-28, 0.0),
                child: CheckboxListTile(
                  title: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          NextPageRoute(
                              TermsAndCondition(url: APK_DETAILS['policy_url']),
                              isMaintainState: false));
                    },
                    child: Transform.translate(
                      offset: const Offset(-10, 0),
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
                          textAlign: TextAlign.left),
                    ),
                  ),
                  value: checkedValue,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue = newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleResponse(SignUpState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          // print("processed to login");
          Preference.setString(
              Preference.FIRST_NAME, '${state.response!.data!.user!.name}');
          Preference.setString(
              Preference.USER_TOKEN, '${state.response!.data!.token}');
          Preference.setString(
              Preference.PHONE, '${state.response!.data!.user!.mobileNo}');
          Preference.setString(Preference.PROFILE_IMAGE,
              '${state.response!.data!.user!.profileImage}');
          Preference.setInt(
              Preference.USER_ID, loginState.response!.data!.user!.id!);
          Preference.setString(Preference.USER_EMAIL,
              '${loginState.response!.data!.user!.email}');
          Preference.setString(Preference.DESIGNATION,
              '${loginState.response!.data!.user!.designation}');

          Preference.setString(Preference.PROFILE_IMAGE,
              '${loginState.response!.data!.user!.profileImage}');
          Preference.setString(Preference.DESIGNATION,
              '${loginState.response!.data!.user!.designation}');
          Preference.setString(Preference.DEFAULT_VIDEO_URL_CATEGORY,
              '${state.response!.data!.user!.defaultVideoUrlOnCategory}');

          UserSession.userToken = state.response!.data!.token;
          UserSession.email = state.response!.data!.user!.email;
          UserSession.userImageUrl = state.response!.data!.user!.profileImage;
          UserSession.socialEmail = state.response!.data!.user!.email;
          Preference.setString(
              Preference.USER_EMAIL, '${state.response!.data!.user!.email}');
          Navigator.push(context, NextPageRoute(InterestPage()));
          // doLogin();
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");
          _isLoading = false;

          AlertsWidget.showCustomDialog(
              context: context,
              title: "${loginState.error}",
              text: "",
              icon: 'assets/images/circle_alert_fill.svg',
              showCancel: false,
              oKText: "Ok",
              onOkClick: () async {
                // Navigator.pop(context);
              });

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  Future<String> _cropImage(_pickedFile) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: buildUiSettings(context),
        // uiSettings: [
        //   AndroidUiSettings(
        //       //toolbarTitle: 'Cropper',
        //       toolbarColor: Colors.deepOrange,
        //       toolbarWidgetColor: Colors.white,
        //       initAspectRatio: CropAspectRatioPreset.square,
        //       hideBottomControls: true,
        //       lockAspectRatio: false),
        // ],
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (croppedFile != null) {
        return croppedFile.path;
      }
    }
    return "";
  }

  void saveChanges() {
    if (!_formKey.currentState!.validate()) return;
    if (selectedImage != null) {
      var req = SignUpRequest(
        profilePic: selectedImage,
        firstName: fullNameController.text.toString(),
        mobileNo: phoneController.text.toString(),
        alternateMobileNo: phoneController.text.toString(),
        emailAddress: widget.loginWithEmail != true ? emailController.text.toString() : widget.email,
        username: emailController.text.toString(),
        firmName: '',
        lastName: '',
        gender: '',
        dateOfBirth: '',
        dbCode: '0',
        password: widget.password,
      );
      BlocProvider.of<AuthBloc>(context).add(SignUpEvent(request: req));
    } else {
      AlertsWidget.showCustomDialog(
          context: context,
          title: "Upload your profile picture",
          text: "",
          icon: 'assets/images/circle_alert_fill.svg',
          showCancel: false,
          oKText: "Ok",
          onOkClick: () async {
            // Navigator.pop(context);
          });
    }
  }

  Future<String> _getImages(ImageSource source) async {
    final picker = ImagePicker();
    PickedFile? pickedFile = await picker.getImage(
      source: source,
    );
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

  void showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.black,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 10),
                  height: 4,
                  width: 70,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Container(
                child: ListTile(
                  leading: new ShaderMask(
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
                    child: Icon(
                      Icons.image,
                    ),
                  ),
                  title: new Text(
                    '${Strings.of(context)?.Gallery}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    FilePickerResult? result;
                    try {
                      if (await Permission.storage.request().isGranted) {
                        if (Platform.isIOS) {
                          result = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.image,
                              allowedExtensions: []);
                        } else {
                          result = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'png', 'jpeg']);
                        }
                      }
                    } catch (e) {
                      print('the expection is $e');
                    }

                    String? value = result?.paths.first;
                    if (value != null) {
                      selectedImage = value;
                      selectedImage = await _cropImage(value);
                    }
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey[100],
              ),
              Container(
                child: ListTile(
                  leading: new ShaderMask(
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
                    child: Icon(
                      Icons.camera_alt_outlined,
                    ),
                  ),
                  title: new Text(
                    '${Strings.of(context)?.camera}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    print('Camera on click');
                    final cameras = await availableCameras();
                    // Get a specific camera from the list of available cameras.
                    final firstCamera = cameras.first;

                    await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TakePictureScreen(camera: firstCamera)))
                        .then((value) async {
                      if (value != null) {
                        selectedImage = value;
                        selectedImage = await _cropImage(value);
                      }
                      setState(() {});
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
            ],
          );
        });
  }
}
