// ignore_for_file: unused_field

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/user_profile_response.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/auth_pages/choose_language.dart';
import 'package:masterg/pages/auth_pages/sign_up_screen.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/custom_pages/faq_page.dart';
import 'package:masterg/pages/user_profile_page/mobile_ui_helper.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/click_picker.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:shimmer/shimmer.dart';

class EditUserProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditUserProfilePageState();
  }
}

class _EditUserProfilePageState extends State<EditUserProfilePage>
    with SingleTickerProviderStateMixin {
  Box? box;
  bool _isLoading = false;
  bool _enabled = true;
  UserProfileData? userProfileDataList;
  String? selectedImage = null;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  void _getUserProfile() async {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(GetUserProfileEvent());
  }

  void _updateUserProfileImage(String? filePath) async {
    BlocProvider.of<HomeBloc>(context)
        .add(UpdateUserProfileImageEvent(filePath: filePath));
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetUserProfileState) {
            _handleUserProfileResponse(state);
          }
          if (state is UpdateUserProfileImageState) {
            _handleUpdateUserProfileImageResponse(state);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            elevation: 0,
            leading: BackButton(color: Colors.black),
            backgroundColor: ColorConstants().primaryColor(),
            actions: [
              IconButton(
                  onPressed: () {
                    AlertsWidget.showCustomDialog(
                        context: context,
                      title:'${Strings.of(context)?.leavingSoSoon}',
                        text: '${Strings.of(context)?.areYouSureYouWantToExit}',
                        icon: 'assets/images/circle_alert_fill.svg',
                        onOkClick: () async {
                          UserSession.clearSession();
                          await Hive.deleteFromDisk();
                          Preference.clearPref().then((value) {
                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     NextPageRoute(ChooseLanguage(showEdulystLogo: true,)),
                            //     (route) => false);
                          });
                        });
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ))
            ],
          ),
          body: userProfileDataList != null ? _makeBody() : BlankPage(),
        ),
      ),
    );
  }

  Widget _makeBody() {
    return Stack(
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
              color: ColorConstants().primaryColor(),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12))),
          // child: HeaderWidget(100, false, Icons.house_rounded),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(0, 26, 0, 10),
          // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              Container(
                height: 100.0,
                width: 100.0,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 0, color: Colors.transparent),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 100,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    selectedImage != null && selectedImage!.isNotEmpty
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(File('$selectedImage')),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: null /* add child content here */,
                          )
                        : userProfileDataList!.profileImage != null
                            ? ClipOval(
                                child: Image.network(
                                  userProfileDataList!.profileImage!,
                                  filterQuality: FilterQuality.low,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : SvgPicture.asset(
                                'assets/images/bxs_user_circle.svg',
                                allowDrawingOutsideViewBox: true,
                              ),
                    Positioned(
                      left: 62,
                      top: 62,
                      child: InkWell(
                        onTap: () {
                          showBottomSheet(context);
                          /*Navigator.push(
                              context,
                              NextPageRoute(ChangeImage()));*/
                        },
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border:
                                Border.all(width: 0, color: Colors.transparent),
                            color: Colors.grey[200],
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${userProfileDataList!.name}',
                    style: Styles.bold(color: ColorConstants.BLACK, size: 20),
                  ),
                  /*SvgPicture.asset('assets/images/edit_profile_icon.svg',
                      width: 20, height: 20)*/
                ],
              ),

              // Text(
              //   userProfileDataList.organization,
              //   style: Styles.semibold(color: ColorConstants.BLACK),
              // ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                color: ColorConstants.WHITE,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              ListTile(
                                title: Text('${Strings.of(context)?.email}',
                                    style: Styles.regular(
                                        color: ColorConstants.GREY_3,
                                        size: 12)),
                                subtitle: Text(
                                  '${userProfileDataList!.email}',
                                  style: Styles.regular(
                                      size: 16, color: ColorConstants.BLACK),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                    '${Strings.of(context)?.phoneNumber}',
                                    style: Styles.regular(
                                        color: ColorConstants.GREY_3,
                                        size: 12)),
                                subtitle: Text(
                                    '${userProfileDataList!.mobileNo}',
                                    style: Styles.regular(
                                        size: 16, color: ColorConstants.BLACK)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Container(
                height: 100,
                color: ColorConstants.WHITE,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, NextPageRoute(FaqPage()));
                        },
                        child: Row(
                          children: [
                            Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorConstants().primaryColor(),
                                ),
                                child: Icon(
                                  Icons.info,
                                  color: ColorConstants.WHITE,
                                  size: 20,
                                )),
                            SizedBox(width: 10),
                            Text('FAQ', style: Styles.regular()),
                            Expanded(child: SizedBox()),
                            Icon(Icons.arrow_forward_ios, size: 15),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      indent: 60,
                    )
                  ],
                ),
              ),

              Expanded(child: SizedBox()),
            ],
          ),
        )
      ],
    );
  }

  void _handleUserProfileResponse(GetUserProfileState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("UserProfileState....................");
          Log.v(state.response!.data!.list.toString());

          userProfileDataList = state.response!.data!.list;
          Preference.setString(
              Preference.PROFILE_IMAGE, '${userProfileDataList!.profileImage}');

          _isLoading = false;
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleUpdateUserProfileImageResponse(
      UpdateUserProfileImageState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("UserProfileState....................");

          Preference.setString(Preference.PROFILE_IMAGE,
              '${state.response!.data!.profileImage}');

          _isLoading = false;
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  Future<String> _getImages(ImageSource source, String sourceType) async {
    print('_getImages');
    print(source);
    print(sourceType);

    if (sourceType == 'camera') {
      final picker = ImagePicker();
      // ignore: deprecated_member_use
      PickedFile? pickedFile =
          await picker.getImage(source: source, imageQuality: 100);
      if (pickedFile != null) {
        print('======= pickedFile =======');
        print(pickedFile.path);
        return pickedFile.path;
      } else if (Platform.isAndroid) {
        // ignore: deprecated_member_use
        final LostData response = await picker.getLostData();
        if (response.file != null) {
          return response.file!.path;
        }
      }
      return "";
    } else {
      final picker = ImagePicker();
      // ignore: deprecated_member_use
      PickedFile? pickedFile =
          await picker.getImage(source: source, imageQuality: 100);
      if (pickedFile != null)
        return pickedFile.path;
      else if (Platform.isAndroid) {
        // ignore: deprecated_member_use
        final LostData response = await picker.getLostData();
        if (response.file != null) {
          return response.file!.path;
        }
      }
      return "";
    }
  }

  Future<String> _cropImage(_pickedFile) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: buildUiSettings(context),
      );
      if (croppedFile != null) {
        return croppedFile.path;
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
                  leading: new Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  title: new Text(
                    '${Strings.of(context)?.Gallery}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await _getImages(ImageSource.gallery, 'gallery')
                        .then((value) async {
                      selectedImage = value;
                      selectedImage = await _cropImage(value);

                      if (selectedImage != null) {
                        Preference.setString(
                            Preference.PROFILE_IMAGE, '${selectedImage}');
                        _updateUserProfileImage(selectedImage);
                      }
                      setState(() {});
                    });
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
                  leading: new Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                  title: new Text(
                    '${Strings.of(context)?.camera}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                                  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

Navigator.push(context, MaterialPageRoute(builder: (context)=> TakePictureScreen(camera: firstCamera)))
                        .then((value) async {
                      selectedImage = value;
                      selectedImage = await _cropImage(value);
                      _updateUserProfileImage(selectedImage);
                      setState(() {});
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        });
  }
}

class BlankPage extends StatelessWidget {
  const BlankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Container(
        //   height: 100,
        //   child: HeaderWidget(100, false, Icons.house_rounded),
        // ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              Container(
                height: 100.0,
                width: 100.0,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 0, color: Colors.transparent),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 100,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: ClipOval(
                    child: SvgPicture.asset(
                      'assets/images/bxs_user_circle.svg',
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(
                  height: 12,
                  width: 200,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(
                  height: 12,
                  width: 150,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Card(
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  enabled: true,
                                  child: ListTile(
                                    leading: Icon(Icons.email),
                                    title: Text("Email",
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                ),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  enabled: true,
                                  child: ListTile(
                                    leading: Icon(Icons.phone),
                                    title: Text("Phone",
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
