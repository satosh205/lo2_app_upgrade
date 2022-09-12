import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterg/blocs/auth_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/auth_request/login_request.dart';
import 'package:masterg/data/models/request/auth_request/signup_request.dart';
import 'package:masterg/data/models/request/auth_request/update_user_request.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/user_info_response.dart';
import 'package:masterg/pages/auth_pages/verify_otp.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/image_widget.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';

class SignUpScreen extends StatefulWidget {
  bool isFromProfile;

  SignUpScreen({this.isFromProfile = false});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final firmController = TextEditingController();
  final firstNameController = TextEditingController();
  final usernameController = TextEditingController();

  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final dobController = TextEditingController();

  final departmentController = TextEditingController();
  final designationController = TextEditingController();
  final seniorController = TextEditingController();
  final locationController = TextEditingController();
  final langaugeController = TextEditingController();
  final branchController = TextEditingController();
  final areaController = TextEditingController();
  final stateController = TextEditingController();
  final territoryController = TextEditingController();

  final firmFocus = FocusNode();
  final usernameFocus = FocusNode();
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final phoneFocus = FocusNode();
  final emailFocus = FocusNode();
  final dobFocus = FocusNode();
  DateTime selectedDate = DateTime.now();
  final picker = ImagePicker();
  String? selectedImage;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String gender = "male";

  UserData? userData = new UserData();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dobController.text = Utility.convertDateFormat(selectedDate);
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isFromProfile) {
      userData = UserData.fromJson(json.decode('${UserSession.userData}'));
      firstNameController.text = UserSession.userName!.split(" ").first;
      lastNameController.text = UserSession.userName!.split(" ").last;
      emailController.text = UserSession.email!;
      phoneController.text = UserSession.phone!;
      dobController.text =
          Utility.convertDateFromMillis(userData!.dateOfBirth!, "MM/dd/yyyy");
      gender = UserSession.gender!;
      departmentController.text = userData!.department!;
      designationController.text = userData!.designation!;
      seniorController.text = userData!.senior!;
      locationController.text = userData!.location!;
      langaugeController.text = userData!.langauge!;
      branchController.text = userData!.branch!;
      areaController.text = userData!.area!;
      stateController.text = userData!.state!;
      territoryController.text = userData!.territory!;
      UserSession.userImageUrl = userData!.profileImage!;
      usernameController.text = userData!.username ?? '';
      Log.v(userData!.branch);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is SignUpState)
                _handleResponse(state);
              else if (state is UpdateUserState)
                _handleUserResponse(state);
              else if (state is LoginState) _handleLoginResponse(state);
            },
            child: CommonContainer(
              isBackShow: true,
              isLoading: _isLoading,
              child: _makeBody(),
              title: widget.isFromProfile
                  ? Strings.of(context)?.updateProfile
                  : "Sign Up",
              onBackPressed: () {
                Navigator.pop(context);
              },
            )));
  }

  _makeBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _profile(),
                      SizedBox(height: 10.0),
                      Text(
                        "User name",
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        controller: usernameController,
                        focusNode: usernameFocus,
                        readOnly: true,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                          hintText: "",
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {
                          firstNameFocus.nextFocus();
                        },
                      ),
                      SizedBox(height: 20.0),
                      Visibility(
                        visible: !widget.isFromProfile,
                        child: Text(
                          "Firm Name",
                          style: Styles.textRegular(
                              color: ColorConstants.TEXT_DARK_BLACK),
                        ),
                      ),
                      Visibility(
                        visible: !widget.isFromProfile,
                        child: TextFormField(
                          controller: firmController,
                          focusNode: firmFocus,
                          style: Styles.textBold(size: 16),
                          decoration: textInputDecoration.copyWith(
                            hintText: "",
                          ),
                          validator: (value) {
                            if (value!.isEmpty && !widget.isFromProfile) {
                              return 'Please enter firm name';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {},
                          onFieldSubmitted: (val) {
                            firstNameFocus.requestFocus();
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${Strings.of(context)?.firstName}',
                                  style: Styles.textRegular(
                                      color: ColorConstants.TEXT_DARK_BLACK),
                                ),
                                TextFormField(
                                  readOnly: UserSession.userName != null &&
                                      UserSession.userName!.isNotEmpty,
                                  controller: firstNameController,
                                  focusNode: firstNameFocus,
                                  textInputAction: TextInputAction.next,
                                  style: Styles.textBold(size: 16),
                                  decoration: textInputDecoration.copyWith(
                                    hintText: "",
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return Strings.of(context)?.firstName;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {},
                                  onFieldSubmitted: (val) {
                                    lastNameFocus.requestFocus();
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${Strings.of(context)?.lastName}',
                                  style: Styles.textRegular(
                                      color: ColorConstants.TEXT_DARK_BLACK),
                                ),
                                TextFormField(
                                  readOnly: UserSession.userName != null &&
                                      UserSession.userName!.isNotEmpty,
                                  controller: lastNameController,
                                  focusNode: lastNameFocus,
                                  textInputAction: TextInputAction.next,
                                  style: Styles.textBold(size: 16),
                                  decoration: textInputDecoration.copyWith(
                                    hintText: "",
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return Strings.of(context)?.lastName;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {},
                                  onFieldSubmitted: (val) {
                                    emailFocus.requestFocus();
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Text(
                      '${  Strings.of(context)?.dateOfBirth}',
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        controller: dobController,
                        focusNode: dobFocus,
                        onTap: () {
                          if (userData != null &&
                              userData!.dateOfBirth != null &&
                              userData!.dateOfBirth! > 0) return;
                          _selectDate(context);
                        },
                        readOnly: true,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                          hintText: "",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings.of(context)!.dateOfBirth;
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {
                          emailFocus.nextFocus();
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text(
                       '${ Strings.of(context)?.gender}',
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (UserSession.gender != null &&
                                  UserSession.gender!.isNotEmpty) return;
                              setState(() {
                                gender = 'male';
                              });
                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                 '${ Strings.of(context)?.male}',
                                  style: Styles.boldWhite(size: 16),
                                ),
                              ),
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: gender == 'male'
                                      ? ColorConstants.PRIMARY_COLOR
                                      : ColorConstants.DARK_GREY,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          InkWell(
                            onTap: () {
                              if (UserSession.gender != null &&
                                  UserSession.gender!.isNotEmpty) return;
                              setState(() {
                                gender = 'female';
                              });
                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                  '${Strings.of(context)?.female}',
                                  style: Styles.boldWhite(size: 16),
                                ),
                              ),
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: gender == 'female'
                                      ? ColorConstants.PRIMARY_COLOR
                                      : ColorConstants.DARK_GREY,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Text(
                   '${     Strings.of(context)?.emailAddress}',
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        readOnly: UserSession.email != null &&
                            UserSession.email!.isNotEmpty,
                        controller: emailController,
                        focusNode: emailFocus,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                          hintText: "",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings.of(context)?.emailAddress;
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {
                          phoneFocus.nextFocus();
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Department",
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        controller: departmentController,
                        readOnly: true,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                            hintText: "",
                            prefixStyle: TextStyle(
                              color: ColorConstants.TEXT_DARK_BLACK,
                              fontSize: 16,
                            )),
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Designation",
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),

                      TextFormField(
                        controller: designationController,
                        readOnly: true,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                            hintText: "",
                            prefixStyle: TextStyle(
                              color: ColorConstants.TEXT_DARK_BLACK,
                              fontSize: 16,
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings
                                .of(context)
                                !.mobileNumber;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Report to",
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        controller: seniorController,
                        readOnly: true,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                            hintText: "",
                            prefixStyle: TextStyle(
                              color: ColorConstants.TEXT_DARK_BLACK,
                              fontSize: 16,
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings
                                .of(context)
                                !.mobileNumber;
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Location",
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        controller: locationController,
                        readOnly: true,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                            hintText: "",
                            prefixStyle: TextStyle(
                              color: ColorConstants.TEXT_DARK_BLACK,
                              fontSize: 16,
                            )),
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Language",
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        controller: langaugeController,
                        readOnly: true,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                            hintText: "",
                            prefixStyle: TextStyle(
                              color: ColorConstants.TEXT_DARK_BLACK,
                              fontSize: 16,
                            )),
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Branch",
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        controller: branchController,
                        readOnly: true,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                            hintText: "",
                            prefixStyle: TextStyle(
                              color: ColorConstants.TEXT_DARK_BLACK,
                              fontSize: 16,
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings
                                .of(context)
                                !.mobileNumber;
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Area",
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        controller: areaController,
                        readOnly: true,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                            hintText: "",
                            prefixStyle: TextStyle(
                              color: ColorConstants.TEXT_DARK_BLACK,
                              fontSize: 16,
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings
                                .of(context)
                                !.mobileNumber;
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "State",
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        controller: stateController,
                        readOnly: true,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                            hintText: "",
                            prefixStyle: TextStyle(
                              color: ColorConstants.TEXT_DARK_BLACK,
                              fontSize: 16,
                            )),
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Territory",
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        controller: territoryController,
                        readOnly: true,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                            hintText: "",
                            prefixStyle: TextStyle(
                              color: ColorConstants.TEXT_DARK_BLACK,
                              fontSize: 16,
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings
                                .of(context)
                                !.mobileNumber;
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {},
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
            /* Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: AppButton(
                onTap: () {
                  saveChanges();
                },
                title: Strings.of(context).submit,
              ),
            )*/
          ],
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
          doLogin();
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void saveChanges() {
    if (!_formKey.currentState!.validate()) return;
    if (widget.isFromProfile) {
      var req = UpdateUserRequest(
        firstName: firstNameController.text.toString(),
        lastName: lastNameController.text.toString(),
        gender: gender,
        profilePic: selectedImage,
        dateOfBirth:
            Utility.convertDateFormat(selectedDate, format: "yyyy-MM-dd"),
        emailAddress: emailController.text.toString(),
        mobileNo: phoneController.text.toString(),
      );
      BlocProvider.of<AuthBloc>(context).add(UpdateUserEvent(request: req));
    } else {
      var req = SignUpRequest(
        firmName: firmController.text.toString(),
        firstName: firstNameController.text.toString(),
        lastName: lastNameController.text.toString(),
        gender: gender,
        profilePic: selectedImage,
        dateOfBirth:
            Utility.convertDateFormat(selectedDate, format: 'yyyy-MM-dd'),
        emailAddress: emailController.text.toString(),
        mobileNo: phoneController.text.toString(),
      );
      BlocProvider.of<AuthBloc>(context).add(SignUp(request: req));
    }
  }

  void _handleLoginResponse(LoginState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          Navigator.push(
              context,
              NextPageRoute(VerifyOtp(
                phoneController.text.toString(),
                // isSignUp: true,
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
          // TODO: Handle this case.
          break;
      }
    });
  }

  void _handleUserResponse(UpdateUserState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          _isLoading = false;
          AlertsWidget.alertWithOkBtn(
              context: context,
              text: loginState.response?.message ?? "",
              onOkClick: () {
                Navigator.pop(context);
              });
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void doLogin() {
    BlocProvider.of<AuthBloc>(context).add(LoginUser(
        request:
            LoginRequest(mobileNo: phoneController.text.toString().trim())));
  }

  _profile() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageChooseWidget(
            isFromNetwork: UserSession.userImageUrl != null,
            image: UserSession.userImageUrl ?? selectedImage,
            isChooseVisible: true,
            selectImage: () {
              showFileChoosePopup();
            },
          ),
        ],
      ),
    );
  }

  void showFileChoosePopup() {
    //  Utility.hideKeyboard();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations
          .of(context)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        // return object of type Dialog
        return SimpleDialog(
          backgroundColor: ColorConstants.PRIMARY_COLOR,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: ColorConstants.PRIMARY_COLOR,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                     '${ Strings.of(context)?.photoAlert}',
                      style: Styles.regularWhite(size: 18),
                    ),
                  ),
                  InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('${Strings.of(context)?.takeAPicture}',
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
                        child: Text('${Strings.of(context)?.pickFromGallery}',
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
