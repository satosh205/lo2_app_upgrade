// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/user_profile_response.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/auth_pages/sign_up_screen.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/custom_pages/faq_page.dart';
import 'package:masterg/pages/user_profile_page/mobile_ui_helper.dart';
import 'package:masterg/pages/user_profile_page/model/MasterBrand.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/click_picker.dart';
import 'package:masterg/utils/config.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/api/api_constants.dart';
import '../../data/models/response/home_response/create_portfolio_response.dart';
import '../../data/models/response/home_response/delete_portfolio_response.dart';
import '../../data/models/response/home_response/list_portfolio_responsed.dart';
import '../../utils/utility.dart';
import '../custom_pages/TapWidget.dart';
import 'brand_filter_page.dart';
import 'edit_self_details_page.dart';
import 'g_portfolio_page.dart';
import 'package:http/http.dart' as http;

import 'model/BrandModel.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserProfilePageState();
  }
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  Box? box;
  bool _isLoading = false;
  bool _isLoadingBrandCreate = false;
  bool _isLoadingAdd = false;
  bool _enabled = true;
  UserProfileData? userProfileDataList;
  String? selectedImage = null;
  String? selectedBrandPath = '';
  final titleController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  late CreatePortfolioResponse createPortfolioResp;
  late MasterBrandResponse _masterBrandResponse;
  bool isPortfolioListLoading = true;
  bool isDeletePortfolioLoading = true;
  late List<PortfolioElement> listPortfolioBrand = [];
  late DeletePortfolioResponse deletePortfolioResp;
  int? deleteIndex;
  String deleteType = '';
  String typeValue = '';
  bool deleteVisibleIconFlag = false;
  bool checkBoxValue = true;
  String brandImageUrl = '';
  String brandName = '';
  List<String?>? files = [];
  bool flagUploadBranVisible = false;
  /*List<MasterBrand> filteredUsers = [];
  List<MasterBrand> addressListData = <MasterBrand>[];*/
  List<BrandModel> addressListData = <BrandModel>[];
  String strDocFile = '';
  int? id;
  String fileString = '';
  var _result;
  bool readOnly = true;
  bool textContentHide = true;

    late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    
      
    //apiFetch();
    _getUserProfile();
  }

  // void initCamera()async{
  //    final cameras = await availableCameras();

  // // Get a specific camera from the list of available cameras.
  // final firstCamera = cameras.first;

  // _controller = CameraController(
  //     // Get a specific camera from the list of available cameras.
  //     firstCamera,
  //     // Define the resolution to use.
  //     ResolutionPreset.medium,
  //   );

  //   // Next, initialize the controller. This returns a Future.
  //   _initializeControllerFuture = _controller.initialize();
  // }

  Future<void> apiFetch() async {
    await _listPortfolio('brand');
    /*await _listPortfolio('award');
    await _listPortfolio('project');
    await _listPortfolio('certification');*/
  }

  void _getUserProfile() async {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(GetUserProfileEvent());
  }

  void _updateUserProfileImage(String? filePath) async {
    BlocProvider.of<HomeBloc>(context).add(UpdateUserProfileImageEvent(filePath: filePath));
  }

  void createPortfolio() {
    BlocProvider.of<HomeBloc>(context).add(CreatePortfolioEvent(
      title: titleController.text.toString(),
      description: 'Create Brand',
      type: 'brand',
      filePath: selectedBrandPath!.isEmpty ? selectedBrandPath : brandImageUrl,
    ));
  }

  void masterBrandCreate() {
    BlocProvider.of<HomeBloc>(context).add(MasterBrandCreateEvent(
      title: titleController.text.toString(),
      description: 'Create Brand',
      filePath: selectedBrandPath,
    ));
  }

  void userBrandCreate(int? brandID) {
    BlocProvider.of<HomeBloc>(context).add(UserBrandCreateEvent(
      startDate: fromDateController.text.toString(),
      //startDate: '2021-01-27 00:00:00',
      //endDate: '2021-05-27 00:00:00',
      endDate: checkBoxValue == false
          ? toDateController.text.toString()
          : DateTime.now().toString(),
      typeId: brandImageUrl.isEmpty ? brandID : id,
      filePath: files!.length != 0 ? files![0] : '',
    ));
  }

  Future<void> _listPortfolio(String type) async {
    setState(() {
      typeValue = type;
    });
    print(typeValue);
    print(type);
    BlocProvider.of<HomeBloc>(context).add(
        ListPortfolioEvent(type: type, userId: userProfileDataList!.userId));
  }

  Future<void> _deletePortfolio(int id, int index) async {
    BlocProvider.of<HomeBloc>(context).add(DeletePortfolioEvent(id: id));
  }

  void validation() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    DateTime? valEnd;
    DateTime? date;
    if (fromDateController.text.isNotEmpty) {
      valEnd = DateTime.parse(fromDateController.text.toString());
      date = toDateController.text.isNotEmpty
          ? DateTime.parse(toDateController.text.toString())
          : DateTime.parse(formattedDate);
    }

    if (titleController.text.toString().isEmpty) {
      AlertsWidget.showCustomDialog(
          context: context,
          title: "Error",
          text: "Please enter brand title",
          icon: 'assets/images/circle_alert_fill.svg',
          oKText: '${Strings.of(context)?.ok}',
          showCancel: false,
          onOkClick: () async {});
    } else if (selectedBrandPath!.isEmpty && brandImageUrl.isEmpty) {
      AlertsWidget.showCustomDialog(
          context: context,
          title: "Error",
          text: "Please select brand logo image.",
          icon: 'assets/images/circle_alert_fill.svg',
          oKText: '${Strings.of(context)?.ok}',
          showCancel: false,
          onOkClick: () async {});
    } else if (files!.length == 0) {
      AlertsWidget.showCustomDialog(
          context: context,
          title: "Error",
          text: "Please select joining letter",
          icon: 'assets/images/circle_alert_fill.svg',
          oKText: '${Strings.of(context)?.ok}',
          showCancel: false,
          onOkClick: () async {});
    } else if (fromDateController.text.toString().isEmpty) {
      AlertsWidget.showCustomDialog(
          context: context,
          title: "Error",
          text: "Please select joining date.",
          icon: 'assets/images/circle_alert_fill.svg',
          oKText: '${Strings.of(context)?.ok}',
          showCancel: false,
          onOkClick: () async {});
    } else {
      if (valEnd!.compareTo(date!) < 0) {
        masterBrandCreate();
      } else {
        AlertsWidget.showCustomDialog(
            context: context,
            title: "Error",
            text: "Please select valid joining date.",
            icon: 'assets/images/circle_alert_fill.svg',
            oKText: '${Strings.of(context)?.ok}',
            showCancel: false,
            onOkClick: () async {});
      }
    }
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
          if (state is CreatePortfolioState) {
            _handleCreatePortfolioResponse(state);
          }
          if (state is ListPortfolioState) {
            _handleListPortfolioResponse(state);
          }
          if (state is DeletePortfolioState) {
            _handleDeletePortfolioResponse(state);
          }
          if (state is MasterBrandCreateState) {
            _handleMasterBrandCreateResponse(state);
          }
          if (state is UserBrandCreateState) {
            _handleUserBrandCreateResponse(state);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: BackButton(color: Colors.black),
            backgroundColor: ColorConstants().primaryColor(),
            actions: [
              IconButton(
                  onPressed: () {
                    AlertsWidget.showCustomDialog(
                        context: context,
                        title: "Leaving so soon…",
                        text: "Are you sure you want to exit?",
                        icon: 'assets/images/circle_alert_fill.svg',
                        onOkClick: () async {
                          UserSession.clearSession();
                          await Hive.deleteFromDisk();
                          Preference.clearPref().then((value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                NextPageRoute(SignUpScreen()),
                                (route) => false);
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
    void updateValue(value) {
      print('the value is $value');
    }

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
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
                                    child: GestureDetector(
                                      onTap: (){
                                        print('Profile image');
                                        _showBgProfilePic(context, userProfileDataList!.profileImage!);
                                      },
                                      child: Image.network(
                                        userProfileDataList!.profileImage!,
                                        filterQuality: FilterQuality.low,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/images/default_user.svg',
                                    width: 200,
                                    height: 200,
                                    allowDrawingOutsideViewBox: true,
                                  ),
                        Positioned(
                          left: 62,
                          top: 62,
                          child: InkWell(
                            onTap: () {
                              showBottomSheet(context, 'profile', updateValue);
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
                                border: Border.all(
                                    width: 0, color: Colors.transparent),
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

                  ///TODO: Profile Edit
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Flexible(
                      fit: FlexFit.loose,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${userProfileDataList!.name}',
                            style: Styles.bold(color: ColorConstants.BLACK, size: 20,),
                          ),
                          GestureDetector(
                            onTap: (){
                              //print('object ..');
                              Navigator.push(
                                context,
                                NextPageRoute(EditSelfDetailsPage(
                                  name: userProfileDataList!.name,
                                  email: userProfileDataList!.email, onCalledBack: editCallBack,)),);
                            },
                            child: Container(
                                margin: EdgeInsets.only(left: 5.0),
                                height: 30,
                                width: 30,
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Icon(Icons.edit, size: 15,))),
                          ),
                          /*SvgPicture.asset('assets/images/edit_profile_icon.svg',
                            width: 20, height: 20)*/
                        ],
                      ),
                    ),
                  ),


                  Text(
                    userProfileDataList!.organization!,
                    style: Styles.textRegular(
                        color: ColorConstants.GREY_3, size: 14),
                  ),

                  Text(
                    '${userProfileDataList!.email}',
                    style:
                        Styles.regular(size: 14, color: ColorConstants.GREY_3),
                  ),

                  Text('${userProfileDataList!.mobileNo}',
                      style: Styles.regular(
                          size: 14, color: ColorConstants.GREY_3)),

                  SizedBox(
                    height: 20,
                  ),

                  //TODO: User Information
                  Container(
                    height: 12,
                    color: Colors.grey[200],
                  ),
                  /* Container(
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
                  ),*/

                  //TODO: Show Brand Associations
                  SizedBox(
                    height: 20,
                  ),
                  if (APK_DETAILS["isBrandEnabled"] == "1") _addBrand(),

                  //TODO: FAQ Widget
                  SizedBox(
                    height: 30,
                  ),
                  if (APK_DETAILS["isBrandEnabled"] == "1")
                    Container(
                      height: 12,
                      color: Colors.grey[200],
                    ),
                  if (APK_DETAILS["faqEnabled"] == "1")
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
                                Navigator.push(
                                    context, NextPageRoute(FaqPage()));
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
                            color: Colors.grey,
                            indent: 60,
                          )
                        ],
                      ),
                    ),

                  Expanded(child: SizedBox()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  _showBgProfilePic(BuildContext context, String imgUrl) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Stack(
              children: [
                Center(
                  child: Image.network(
                    userProfileDataList!.profileImage!,
                    filterQuality: FilterQuality.low,
                    //width: MediaQuery,
                    //height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _addBrand() {
    void updateValue(value) {
      print('the updated vaue is $value');
      setState(() {
        selectedBrandPath = value;
      });
    }

    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('${Strings.of(context)?.branchAssociation}'),
                      listPortfolioBrand.length != 0
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: GestureDetector(
                                  onTap: () async {
                                    this.setState(() {
                                      deleteVisibleIconFlag = true;
                                    });
                                    /*brandImageUrl = 'null';
                                    _result = null;
                                    titleController.text = '';
                                    fetchProducts('a');
                                    showBottomSheetBrandShow();*/
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                  )),
                            )
                          : SizedBox(),
                    ],
                  ),
                  GestureDetector(
                      onTap: () {
                        selectedBrandPath = '';
                        titleController.clear();
                        fromDateController.clear();
                        toDateController.clear();

                        this.setState(() {
                          _isLoadingAdd = true;
                          checkBoxValue = true;
                          textContentHide = true;
                          //brandImageUrl = '';
                          brandImageUrl = 'null';
                          flagUploadBranVisible = false;
                          files!.clear();
                          fileString = '';
                        });

                        brandImageUrl = 'null';
                        _result = null;
                        titleController.text = '';
                        showBottomSheetBrandShow();
                        fetchProducts('a');

                        /*showModalBottomSheet(
                            context: context,
                            backgroundColor: ColorConstants.WHITE,
                            isScrollControlled: true,
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context,
                                      StateSetter setSheetState) {
                                Timer.periodic(Duration(seconds: 1), (timer) {
                                  setSheetState(() {});
                                });

                                return FractionallySizedBox(
                                  heightFactor: 0.6,
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      //mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 5.0),
                                          height: 3,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),

                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0,
                                                right: 20.0,
                                                top: 10.0),
                                            child: Text(
                                                '${Strings.of(context)?.addBrand}')),
                                        SizedBox(
                                          height: 12,
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              top: 10.0),
                                          child: TextFormField(
                                            controller: titleController,
                                            readOnly: true,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            keyboardType: TextInputType.text,
                                            */ /*inputFormatters: [
                                                      FilteringTextInputFormatter.deny(RegExp(r"[a-zA-Z -]"))
                                                    ],*/ /*
                                            onChanged: (value) {},
                                            decoration: InputDecoration(
                                              focusColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              fillColor: Colors.grey,
                                              hintText:
                                                  "${Strings.of(context)?.brandName}",
                                              //make hint text
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontFamily: "verdana_regular",
                                                fontWeight: FontWeight.w400,
                                              ),

                                              //create lable
                                              labelText:
                                                  "${Strings.of(context)?.brandName}",
                                              //lable style
                                              labelStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontFamily: "verdana_regular",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BrandFilterPage(
                                                            onCalledFromOutside,
                                                          )));
                                            },
                                          ),
                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),
                                        brandImageUrl.isNotEmpty && brandImageUrl != 'null'
                                            ? Image.network(
                                                brandImageUrl,
                                                filterQuality:
                                                    FilterQuality.low,
                                                width: 130,
                                                height: 80,
                                                fit: BoxFit.fill,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    debugPrint(
                                                        'image loading null');
                                                    return child;
                                                  }
                                                  debugPrint(
                                                      'image loading...');
                                                  return const Center(
                                                      child: SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: ColorConstants
                                                                .PRIMARY_COLOR,
                                                          )));
                                                },
                                              )
                                            : SizedBox(),

                                        //TODO: Upload Brand Logo Image
                                        brandImageUrl.isEmpty
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(top: 10.0),
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        showBottomSheet(
                                                            context,
                                                            'brand',
                                                            updateValue);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(Icons
                                                              .file_upload_outlined),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0),
                                                            child: Text(
                                                                "${Strings.of(context)?.uploadBrandLogo}"),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      '${Strings.of(context)?.supportedFormat} - .jpeg, .png',
                                                      style:
                                                          Styles.textExtraBold(
                                                              size: 14,
                                                              color:
                                                                  ColorConstants
                                                                      .GREY_3),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),

                                        selectedBrandPath != null &&
                                                selectedBrandPath!.isNotEmpty
                                            ? _selectedBrandLogo()
                                            : SizedBox(),

                                        //TODO: Upload Joining Letter
                                        Container(
                                          margin: EdgeInsets.only(top: 10.0),
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _initFilePiker();
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons
                                                        .file_upload_outlined),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      child: Text(
                                                          '${Strings.of(context)?.uploadJoiningLetter}'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                '${Strings.of(context)?.supportedFormat} - .pdf, .doc',
                                                style: Styles.textExtraBold(
                                                    size: 14,
                                                    color:
                                                        ColorConstants.GREY_3),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: Text(
                                                  fileString.isNotEmpty &&
                                                          fileString != 'null'
                                                      ? fileString.substring(
                                                          fileString.length -
                                                              20)
                                                      : '',
                                                  style: Styles.textExtraBold(
                                                      size: 14,
                                                      color: ColorConstants
                                                          .GREY_3),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),

                                        _workingTime(),

                                        SizedBox(
                                          height: 30,
                                        ),

                                        TapWidget(
                                          onTap: () {
                                            if (brandImageUrl.isEmpty) {
                                              validation();
                                            } else {
                                              DateTime now = DateTime.now();
                                              String formattedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(now);
                                              DateTime? valEnd;
                                              DateTime? date;
                                              if (fromDateController
                                                  .text.isNotEmpty) {
                                                valEnd = DateTime.parse(
                                                    fromDateController.text
                                                        .toString());
                                                date = toDateController
                                                        .text.isNotEmpty
                                                    ? DateTime.parse(
                                                        toDateController.text
                                                            .toString())
                                                    : DateTime.parse(
                                                        formattedDate);
                                              }

                                              if (files!.length == 0) {
                                                AlertsWidget.showCustomDialog(
                                                    context: context,
                                                    title:
                                                        "${Strings.of(context)?.error}",
                                                    text:
                                                        "${Strings.of(context)?.pleaseSelectedJoiningLetter}",
                                                    icon:
                                                        'assets/images/circle_alert_fill.svg',
                                                    oKText:
                                                        '${Strings.of(context)?.ok}',
                                                    showCancel: false,
                                                    onOkClick: () async {});
                                              } else if (fromDateController.text
                                                  .toString()
                                                  .isEmpty) {
                                                AlertsWidget.showCustomDialog(
                                                    context: context,
                                                    title:
                                                        "${Strings.of(context)?.error}",
                                                    text:
                                                        "${Strings.of(context)?.pleaseSelectFromDate}",
                                                    icon:
                                                        'assets/images/circle_alert_fill.svg',
                                                    oKText:
                                                        '${Strings.of(context)?.ok}',
                                                    showCancel: false,
                                                    onOkClick: () async {});
                                              } else {
                                                if (valEnd!.compareTo(date!) <
                                                    0) {
                                                  userBrandCreate(0);
                                                } else {
                                                  AlertsWidget.showCustomDialog(
                                                      context: context,
                                                      title:
                                                          "${Strings.of(context)?.error}",
                                                      text:
                                                          "${Strings.of(context)?.pleaseSelectValidJoiningDate}",
                                                      icon:
                                                          'assets/images/circle_alert_fill.svg',
                                                      oKText:
                                                          '${Strings.of(context)?.ok}',
                                                      showCancel: false,
                                                      onOkClick: () async {});
                                                }
                                              }
                                            }
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              _isLoadingBrandCreate == false
                                                  ? Container(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.85,
                                                      padding:
                                                          EdgeInsets.all(18),
                                                      decoration: BoxDecoration(
                                                          color: ColorConstants()
                                                              .primaryColor(),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8,
                                                                right: 8,
                                                                top: 4,
                                                                bottom: 4),
                                                        child: Text(
                                                          '${Strings.of(context)?.submit}',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: Styles.textExtraBold(
                                                              size: 14,
                                                              color:
                                                                  ColorConstants
                                                                      .WHITE),
                                                        ),
                                                      ),
                                                    )
                                                  : const Center(
                                                      child: SizedBox(
                                                          width: 30,
                                                          height: 30,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: ColorConstants
                                                                .PRIMARY_COLOR,
                                                          ))),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                            });*/
                      },
                      child: Icon(Icons.add)),
                ],
              ),
              Container(
                constraints: BoxConstraints(
                    minHeight: 100, minWidth: double.infinity, maxHeight: 250),
                child: listPortfolioBrand.length != 0
                    ? GridView.builder(
                        padding:
                            EdgeInsets.only(left: 0.0, right: 0.0, top: 30.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 17,
                          mainAxisSpacing: 10,
                          //childAspectRatio: (itemWidth / itemHeight),
                          childAspectRatio: 1.0,
                        ),
                        itemCount: listPortfolioBrand.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              Container(
                                height: 37,
                                width: 100,
                                child: Center(
                                  //child: Text('${index + 1}' , style: Styles.textRegular(size: 16, color: Colors.white),),
                                  child: Image.network(
                                    '${listPortfolioBrand[index].image}',
                                  ),
                                  //child: Image.asset('assets/images/br1.png'),
                                ),
                              ),
                              deleteVisibleIconFlag == true
                                  ? Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            AlertsWidget.alertWithOkCancelBtn(
                                              context: context,
                                              text:
                                                  "${Strings.of(context)?.areYourSureYouWantToDelete}",
                                              title:
                                                  "${Strings.of(context)?.alert}",
                                              okText:
                                                  "${Strings.of(context)?.yes}",
                                              cancelText:
                                                  "${Strings.of(context)?.no}",
                                              onOkClick: () async {
                                                //call delete api
                                                deleteIndex = index;
                                                deleteType = 'brand';
                                                _deletePortfolio(
                                                    listPortfolioBrand[index]
                                                        .id!,
                                                    index);
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: 20.0,
                                            width: 20.0,
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                  width: 0,
                                                  color: Colors.transparent),
                                              color: Colors.grey[200],
                                            ),
                                            child: Icon(
                                              Icons.delete,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          );
                        },
                      )
                    : Container(
                        child: Center(
                          child: Column(
                            children: [
                              /*SvgPicture.asset(
                                'assets/images/brand_not.svg',
                                allowDrawingOutsideViewBox: true,
                              ),*/
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child:
                                    Image.asset('assets/images/br_empty.png'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  '${Strings.of(context)?.youHaveNotAddedAnyBrandYet}',
                                  style: Styles.textExtraBold(
                                      size: 14, color: ColorConstants.GREY_3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  '${Strings.of(context)?.addABrandAndLetEveryoneKnowAboutYourBrandAssociations}',
                                  style: Styles.textExtraBold(
                                      size: 14, color: ColorConstants.GREY_3),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),

          /*_isLoadingAdd
                            ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        ):SizedBox(),*/
        ],
      ),
    );
  }

  void showBottomSheetBrandShow() {
    void updateValue(value) {
      print('the value is $value');}
    bool nextFlag = false;

    showModalBottomSheet(
        context: context,
        //backgroundColor: ColorConstants.WHITE,
        backgroundColor: nextFlag == false ? Colors.transparent : ColorConstants.WHITE,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setSheetState) {
            Timer.periodic(Duration(seconds: 1), (timer) {
              setSheetState(() {});
            });

            return nextFlag == false
                ? Container(
              margin: EdgeInsets.only(top: 200),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Stack(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 48,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: ColorConstants.GREY_4,
                              borderRadius:
                              BorderRadius.circular(8)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0),
                          child: Text(
                            '${Strings.of(context)?.addBrand}',
                            style: Styles.bold(size: 14),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0),
                          child: TextFormField(
                            controller: titleController,
                            /*readOnly: brandImageUrl.isNotEmpty
                                            ? true
                                            : false,*/
                            readOnly: readOnly,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              print("on change method called");
                              if (brandImageUrl.isEmpty) {
                                setSheetState(() {
                                  textContentHide = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              focusColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10.0),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                                borderRadius:
                                BorderRadius.circular(10.0),
                              ),
                              fillColor: Colors.grey,
                              hintText: brandImageUrl.isEmpty
                                  ? "Enter brand name"
                                  : "${Strings.of(context)?.brandName}",
                              //make hint text
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontFamily: "verdana_regular",
                                fontWeight: FontWeight.w400,
                              ),

                              //create lable
                              labelText: brandImageUrl.isEmpty
                                  ? "Enter brand name"
                                  : "${Strings.of(context)?.brandName}",
                              //lable style
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontFamily: "verdana_regular",
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: brandImageUrl.isNotEmpty
                                  ? Icon(Icons.search_rounded,
                                  color: ColorConstants.BLACK)
                                  : null,
                            ),
                            onTap: () {
                              if (brandImageUrl.isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BrandFilterPage(
                                              onCalledFromOutside,
                                            )));
                              } else {
                                print('else===========');
                                setSheetState(() {
                                  readOnly = false;
                                  // textContentHide = false;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (titleController.text.isEmpty)
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0),
                        child: Text('Suggested brand',
                            style: Styles.regular(
                                size: 12,
                                color: ColorConstants.GREY_4))),

                  //TODO: Show Brand List
                  titleController.text.isEmpty
                      ? Container(
                    //padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    //height: 360,
                    margin: EdgeInsets.only(top: 150.0, bottom: 80.0),
                    height: MediaQuery.of(context).size.height,

                    child: addressListData.length != 0
                        ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: addressListData.length,
                      itemBuilder:
                          (BuildContext context,
                          int index) {
                        return Container(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Radio(
                                  value: index,
                                  groupValue: _result,
                                  onChanged: (value) {
                                    setState(() {
                                      _result = value;
                                    });
                                  },
                                  activeColor:
                                  Colors.green,
                                ),
                                title: Transform.translate(
                                   offset: Offset(-16, 0),
                                  child: Text(
                                      addressListData[index]
                                          .title
                                          .toString(),
                                      style: Styles.bold(
                                          size: 14)),
                                ),
                                trailing: Image.network(
                                  addressListData[index]
                                      .image
                                      .toString(),
                                  filterQuality:
                                  FilterQuality.low,
                                  width: 80,
                                  height: 45,
                                  //fit: BoxFit.fill,
                                  loadingBuilder: (context,
                                      child,
                                      loadingProgress) {
                                    if (loadingProgress ==
                                        null) {
                                      debugPrint(
                                          'image loading null');
                                      return child;
                                    }
                                    debugPrint(
                                        'image loading...');
                                    return const Center(
                                        child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child:
                                            CircularProgressIndicator(
                                              color: ColorConstants
                                                  .PRIMARY_COLOR,
                                            )));
                                  },
                                ),
                                onTap: () {
                                  Text('Another data');
                                },
                              ),
                              new Divider(
                                height: 1.0,
                                indent: 1.0,
                              ),
                            ],
                          ),
                        );
                      },
                    )
                        : const Center(
                        child: SizedBox(
                            width: 30,
                            height: 30,
                            child:
                            CircularProgressIndicator(
                              color: ColorConstants
                                  .PRIMARY_COLOR,
                            ))),
                  )
                      : SizedBox(),

                  brandImageUrl.isNotEmpty &&
                      brandImageUrl != 'null'
                      ? Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Image.network(brandImageUrl,
                    filterQuality: FilterQuality.low,
                    width: 130,
                    height: 80,
                    //fit: BoxFit.fill,
                    loadingBuilder:
                            (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            debugPrint('image loading null');
                            return child;
                          }
                          debugPrint('image loading...');
                          return const Center(
                              child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                  CircularProgressIndicator(
                                    color: ColorConstants
                                        .PRIMARY_COLOR,
                                  )));
                    },
                  ),
                        ),
                      )
                      : SizedBox(),


                  //TODO: Upload Brand Logo Image
                  brandImageUrl.isEmpty
                      ? Center(
                        child: Container(
                    margin: EdgeInsets.only(top: 250.0),
                    child: Column(
                        children: [
                          // Text(
                          //   'We could not find your brand in our list.',
                          //   style: Styles.textExtraBold(
                          //       size: 14,
                          //       color: ColorConstants.GREY_3),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),

                          selectedBrandPath != null &&
                              selectedBrandPath!.isNotEmpty
                              ? _selectedBrandLogo()
                              : SizedBox(),

                          SizedBox(
                            height: 30,
                          ),

                          GestureDetector(
                            onTap: () {
                              showBottomSheet(context, 'brand',
                                  updateValue);
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Icon(
                                    Icons.file_upload_outlined),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 10.0),
                                  child: Text(
                                      "${Strings.of(context)?.uploadBrandLogo}"),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${Strings.of(context)?.supportedFormat} - .jpeg, .png ...',
                            style: Styles.textExtraBold(
                                size: 14,
                                color: ColorConstants.GREY_3),
                          ),
                        ],
                    ),
                  ),
                      )
                      : SizedBox(),

                  /*SizedBox(
                    height: 20,
                  ),
                  selectedBrandPath != null &&
                      selectedBrandPath!.isNotEmpty
                      ? _selectedBrandLogo()
                      : SizedBox(),*/

                  Align(
                      alignment: Alignment.bottomCenter,
                      child: TapWidget(
                        onTap: () {
                          print(_result);
                          print(selectedBrandPath);

                          if (selectedBrandPath != null &&
                              selectedBrandPath!.isNotEmpty ||
                              _result != null ||
                              brandImageUrl.isNotEmpty &&
                                  brandImageUrl != 'null') {
                            if (_result != null) {
                              setSheetState(() {
                                brandImageUrl = addressListData[_result]
                                    .image
                                    .toString();
                                id = addressListData[_result].id;
                                brandName = addressListData[_result]
                                    .title
                                    .toString();
                                nextFlag = true;
                              });
                            } else {
                              setSheetState(() {
                                nextFlag = true;
                              });
                            }
                          } else {
                            AlertsWidget.showCustomDialog(
                                context: context,
                                title: "${Strings.of(context)?.error}",
                                text: "Please Select Brand",
                                icon:
                                'assets/images/circle_alert_fill.svg',
                                oKText: '${Strings.of(context)?.ok}',
                                showCancel: false,
                                onOkClick: () async {});
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _isLoadingBrandCreate == false
                                ? Container(
                              alignment: Alignment.bottomCenter,
                              width: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.90,
                              height: 50,
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  color: _result == null &&
                                      titleController
                                          .text.isEmpty
                                      ? ColorConstants()
                                      .primaryColor()
                                      .withOpacity(0.5)
                                      : ColorConstants()
                                      .primaryColor(),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5))),
                              child: Center(
                                child: Text(
                                  '${Strings.of(context)?.next}',
                                  textAlign: TextAlign.center,
                                  style: Styles.textExtraBold(
                                      size: 14,
                                      color:
                                      ColorConstants.WHITE),
                                ),
                              ),
                            )
                                : const Center(
                                child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child:
                                    CircularProgressIndicator(
                                      color: ColorConstants
                                          .PRIMARY_COLOR,
                                    ))),
                          ],
                        ),
                      )),
                ],
              ),
            )

                : Container(
              color: Colors.white,
                  child: FractionallySizedBox(
                      heightFactor: 0.6,
                      child: CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Container(
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 5,
                                        width: 48,
                                        margin: EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                            color: ColorConstants.GREY_4,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20.0, top: 10.0),
                                          child: Text(
                                              '${Strings.of(context)?.addBrand}')),
                                      SizedBox(
                                        height: 12,
                                      ),

                                      /* Padding(
                                 padding: const EdgeInsets.only(
                                     left: 20.0,
                                     right: 20.0,
                                     top: 10.0),
                                 child: TextFormField(
                                   controller: titleController,
                                   readOnly: true,
                                   style: TextStyle(
                                     fontSize: 14,
                                     fontWeight: FontWeight.w600,
                                   ),
                                   keyboardType: TextInputType.text,
                                   onChanged: (value) {},
                                   decoration: InputDecoration(
                                     focusColor: Colors.white,
                                     border: OutlineInputBorder(
                                       borderRadius:
                                       BorderRadius.circular(10.0),
                                     ),

                                     focusedBorder: OutlineInputBorder(
                                       borderSide: const BorderSide(
                                           color: Colors.blue,
                                           width: 1.0),
                                       borderRadius:
                                       BorderRadius.circular(10.0),
                                     ),
                                     fillColor: Colors.grey,
                                     hintText:
                                     "${Strings.of(context)?.brandName}",
                                     //make hint text
                                     hintStyle: TextStyle(
                                       color: Colors.grey,
                                       fontSize: 16,
                                       fontFamily: "verdana_regular",
                                       fontWeight: FontWeight.w400,
                                     ),

                                     //create lable
                                     labelText:
                                     "${Strings.of(context)?.brandName}",
                                     //lable style
                                     labelStyle: TextStyle(
                                       color: Colors.grey,
                                       fontSize: 16,
                                       fontFamily: "verdana_regular",
                                       fontWeight: FontWeight.w400,
                                     ),
                                   ),
                                   onTap: () {
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                             builder: (context) =>
                                                 BrandFilterPage(
                                                   onCalledFromOutside,
                                                 )));
                                   },
                                 ),
                               ),*/

                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                ),

                                Center(
                                  child: Text(
                                    '$brandName',
                                    style: Styles.regular(size: 12),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                brandImageUrl.isNotEmpty &&
                                        brandImageUrl != 'null'
                                    ? Image.network(
                                        brandImageUrl,
                                        filterQuality: FilterQuality.low,
                                        width: 130,
                                        height: 80,
                                        //fit: BoxFit.fill,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            debugPrint('image loading null');
                                            return child;
                                          }
                                          debugPrint('image loading...');
                                          return const Center(
                                              child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: ColorConstants
                                                        .PRIMARY_COLOR,
                                                  )));
                                        },
                                      )
                                    : SizedBox(),

                                //TODO: Upload Brand Logo Image
                                /*brandImageUrl.isEmpty
                             ? Container(
                           margin:
                           EdgeInsets.only(top: 10.0),
                           child: Column(
                             children: [
                               GestureDetector(
                                 onTap: () {
                                   showBottomSheet(
                                       context,
                                       'brand',
                                       updateValue);
                                 },
                                 child: Row(
                                   mainAxisAlignment:
                                   MainAxisAlignment
                                       .center,
                                   children: [
                                     Icon(Icons
                                         .file_upload_outlined),
                                     Padding(
                                       padding:
                                       const EdgeInsets
                                           .only(
                                           left: 10.0),
                                       child: Text(
                                           "${Strings.of(context)?.uploadBrandLogo}"),
                                     ),
                                   ],
                                 ),
                               ),
                               Text(
                                 '${Strings.of(context)?.supportedFormat} - .jpeg, .png',
                                 style:
                                 Styles.textExtraBold(
                                     size: 14,
                                     color:
                                     ColorConstants
                                         .GREY_3),
                               ),
                             ],
                           ),
                         )
                             : SizedBox(),*/

                                selectedBrandPath != null &&
                                        selectedBrandPath!.isNotEmpty
                                    ? _selectedBrandLogo()
                                    : SizedBox(),

                                //TODO: Date selection
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0, top: 20.0),
                                      child: Text('Select tenure')),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                _workingTime(),

                                //TODO: Upload Joining Letter
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: GestureDetector(
                                          onTap: () {
                                            _initFilePiker();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.file_upload_outlined),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: Text(
                                                    '${Strings.of(context)?.uploadJoiningLetter}'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '${Strings.of(context)?.supportedFormat} - .pdf, .doc',
                                        style: Styles.textExtraBold(
                                            size: 14,
                                            color: ColorConstants.GREY_3),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          fileString.isNotEmpty &&
                                                  fileString != 'null'
                                              ? fileString.substring(
                                                  fileString.length - 20)
                                              : '',
                                          style: Styles.textExtraBold(
                                              size: 14,
                                              color: ColorConstants.GREY_3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: TapWidget(
                                  onTap: () {
                                    if (brandImageUrl.isEmpty) {
                                      validation();
                                    } else {
                                      DateTime now = DateTime.now();
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd').format(now);
                                      DateTime? valEnd;
                                      DateTime? date;
                                      if (fromDateController.text.isNotEmpty) {
                                        valEnd = DateTime.parse(
                                            fromDateController.text.toString());
                                        date = toDateController.text.isNotEmpty
                                            ? DateTime.parse(
                                                toDateController.text.toString())
                                            : DateTime.parse(formattedDate);
                                      }

                                      if (files!.length == 0) {
                                        AlertsWidget.showCustomDialog(
                                            context: context,
                                            title:
                                                "${Strings.of(context)?.error}",
                                            text:
                                                "${Strings.of(context)?.pleaseSelectedJoiningLetter}",
                                            icon:
                                                'assets/images/circle_alert_fill.svg',
                                            oKText: '${Strings.of(context)?.ok}',
                                            showCancel: false,
                                            onOkClick: () async {});
                                      } else if (fromDateController.text
                                          .toString()
                                          .isEmpty) {
                                        AlertsWidget.showCustomDialog(
                                            context: context,
                                            title:
                                                "${Strings.of(context)?.error}",
                                            text:
                                                "${Strings.of(context)?.pleaseSelectFromDate}",
                                            icon:
                                                'assets/images/circle_alert_fill.svg',
                                            oKText: '${Strings.of(context)?.ok}',
                                            showCancel: false,
                                            onOkClick: () async {});
                                      } else {
                                        if (valEnd!.compareTo(date!) < 0) {
                                          userBrandCreate(0);
                                        } else {
                                          AlertsWidget.showCustomDialog(
                                              context: context,
                                              title:
                                                  "${Strings.of(context)?.error}",
                                              text:
                                                  "${Strings.of(context)?.pleaseSelectValidJoiningDate}",
                                              icon:
                                                  'assets/images/circle_alert_fill.svg',
                                              oKText:
                                                  '${Strings.of(context)?.ok}',
                                              showCancel: false,
                                              onOkClick: () async {});
                                        }
                                      }
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      _isLoadingBrandCreate == false
                                          ? Container(
                                              alignment: Alignment.bottomCenter,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.85,
                                              margin: EdgeInsets.only(bottom: 10),
                                              height: 50,
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                  color: ColorConstants()
                                                      .primaryColor(),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                    top: 4,
                                                    bottom: 4),
                                                child: Text(
                                                  '${Strings.of(context)?.submit}',
                                                  textAlign: TextAlign.center,
                                                  style: Styles.textExtraBold(
                                                      size: 14,
                                                      color:
                                                          ColorConstants.WHITE),
                                                ),
                                              ),
                                            )
                                          : const Center(
                                              child: SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: ColorConstants
                                                        .PRIMARY_COLOR,
                                                  ))),
                                    ],
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                );
          });
        });
  }


  Widget _workingTime() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Text('${Strings.of(context)?.from}'))),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(left: 5.0),
                child: Text('${Strings.of(context)?.to}'),
              )),
            ],
          ),
          SizedBox(
            height: 4.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  //height: 35,
                  padding: EdgeInsets.only(right: 5.0),
                  child: Column(
                    children: [
                      Container(
                        height: 35,
                        child: TextFormField(
                          controller: fromDateController,
                          readOnly: true,
                          style: TextStyle(fontSize: 13.0),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 13.0),
                            hintText: '${Strings.of(context)?.fromDate}',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () => calenderOpen('from'),
                        ),
                      ),

                      checkBoxValue == false ? SizedBox(height: 45,): SizedBox(),
                    ],
                  ),
                ),
              ),

              /*Expanded(
                child: Container(
                  height: 35,
                  padding: EdgeInsets.only(left: 5.0),
                  child: TextFormField(
                    controller: toDateController,
                    readOnly: true,
                    style: TextStyle(fontSize: 13.0),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 13.0),
                      hintText: 'To Date',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => calenderOpen('to'),
                  ),
                ),
              ),*/

              Expanded(
                child: Container(
                  //height: 35,
                  padding: EdgeInsets.only(left: 0.0),
                  child: _checkBox(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _checkBox() {
    return StatefulBuilder(builder: (context, setstate) {
      return Container(
        child: Column(
          //padding: EdgeInsets.all(5.0),
          children: [
            checkBoxValue == false ? Container(
              height: 35,
              padding: EdgeInsets.only(left: 5.0),
              child: TextFormField(
                controller: toDateController,
                readOnly: true,
                style: TextStyle(fontSize: 13.0),
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 13.0),
                  hintText: '${Strings.of(context)?.toDate}',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => calenderOpen('to'),
              ),
            ) : SizedBox(),
            Row(
              children: <Widget>[
                Container(
                  child: new Checkbox(
                      value: checkBoxValue,
                      activeColor: Colors.green,
                      onChanged: (bool? newValue) {
                        setstate(() {
                          checkBoxValue = newValue!;
                        });
                      }),
                ),
                Text(
                  '${Strings.of(context)?.present}',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      );
    });

    /*return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          new Checkbox(
              value: checkBoxValue,
              activeColor: Colors.green,
              onChanged:(bool? newValue){
                setState(() {
                  checkBoxValue = newValue!;
                });
                Text('Remember me');
              }),
        ],
      ),
    );*/
  }

  Widget _selectedBrandLogo() {
    //return StatefulBuilder(builder: (context, setstate){
    return Container(
      //padding: const EdgeInsets.only(top: 200.0, bottom: 200.0),
      height: 60,
      width: 100,
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(File('$selectedBrandPath')),
          //fit: BoxFit.fill,
        ),
      ),
      child: null /* add child content here */,
    );
    //});
  }

  void calenderOpen(String inputType) async {
    print(inputType);

    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime.now(),
        useRootNavigator: false);

    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      //String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDate);
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
      //you can implement different kind of Date Format here according to your requirement
      if (inputType.endsWith('from')) {
        this.setState(() {
          fromDateController.text = formattedDate;
        });
      } else if (inputType.endsWith('to')) {
        this.setState(() {
          toDateController.text = formattedDate;
        });
      }
      //set output date to TextField value.
    } else {
      print("Date is not selected");
    }
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

          _listPortfolio('brand');
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

  void _handleUpdateUserProfileImageResponse(UpdateUserProfileImageState state) {
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

  void _handleCreatePortfolioResponse(CreatePortfolioState state) {
    var loginState = state;
    this.setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          _isLoadingAdd = true;
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          _isLoadingAdd = false;
          Log.v("Success....................");
          _listPortfolio('brand');
          createPortfolioResp = state.response!;
          break;
        case ApiStatus.ERROR:
          _isLoadingAdd = false;
          Log.v("Error.........................");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleMasterBrandCreateResponse(MasterBrandCreateState state) {
    var loginState = state;
    this.setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          _isLoadingBrandCreate = true;
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          //_isLoadingBrandCreate = false;
          Log.v("Success....................");
          _masterBrandResponse = state.response!;
          print(state.response!.data!.id);
          userBrandCreate(state.response!.data!.id);
          break;
        case ApiStatus.ERROR:
          //_isLoadingBrandCreate = false;
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleUserBrandCreateResponse(UserBrandCreateState state) {
    var loginState = state;
    this.setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          if (brandImageUrl.isNotEmpty) {
            _isLoadingBrandCreate = true;
          }
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          Navigator.pop(context);
          _isLoadingBrandCreate = false;
          Log.v("Success....................");
          _listPortfolio('brand');

          showModalBottomSheet(
              context: context,
              backgroundColor: ColorConstants.WHITE,
              isScrollControlled: true,
              builder: (context) {
                return FractionallySizedBox(
                  heightFactor: 0.6,
                  child: Column(children: [
                    SizedBox(height: 4),
                    Container(
                      height: 5,
                      width: 48,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: ColorConstants.GREY_4,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/thumb_up.svg',
                        height: 100.0,
                        width: 100.0,
                        allowDrawingOutsideViewBox: true,
                      ),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: Text('Congratulations!!',
                          textAlign: TextAlign.center,
                          style: Styles.bold(size: 22)),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Center(
                        child: Text(
                            'You have succcessfully added brand to your portfolio.',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: Styles.regular(size: 14)),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.only(bottom: 10),
                            height: 50,
                            decoration: BoxDecoration(
                                color: ColorConstants().primaryColor(),
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                'Done',
                                style: Styles.regular(size: 16),
                              ),
                            )),
                      ),
                    )
                  ]),
                );
              });

          //_masterBrandResponse = state.response!;

          break;
        case ApiStatus.ERROR:
          //Navigator.pop(context);
          _isLoadingBrandCreate = false;
          _listPortfolio('brand');
          Log.v("Error.........................");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleListPortfolioResponse(ListPortfolioState state) {
    print('handleListPortfolioResponse');
    var listPortfolioState = state;
    setState(() {
      switch (listPortfolioState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isPortfolioListLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("TopScoringUsersState data....................");

          if (state.response!.data!.list != null) {
            for (int i = 0; i < state.response!.data!.list!.length; i++) {
              if (state.response!.data!.list![i].type == 'brand') {
                listPortfolioBrand = state.response!.data!.list!;
              } /*else if(state.response!.data!.list![i].type == 'award'){
                listPortfolioAward = state.response!.data!.list!;

              }else if(state.response!.data!.list![i].type == 'project'){
                listPortfolioProject = state.response!.data!.list!;

              }else if(state.response!.data!.list![i].type == 'certification'){
                listPortfolioCertification = state.response!.data!.list!;
              }*/
            }
          }
          isPortfolioListLoading = false;
          break;
        case ApiStatus.ERROR:
          isPortfolioListLoading = false;
          Log.v("Error..........................");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleDeletePortfolioResponse(DeletePortfolioState state) {
    var deletePortfolio = state;
    this.setState(() {
      switch (deletePortfolio.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isDeletePortfolioLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("DeletePortfolioResponseState....................");
          //deletePortfolioResp = state.response!;
          if (deleteType == 'brand') {
            listPortfolioBrand.removeAt(deleteIndex!);
            deleteVisibleIconFlag = false;
          } /*else if(deleteType == 'award') {
            listPortfolioAward.removeAt(deleteIndex!);

          }else if(deleteType == 'project') {
            listPortfolioProject.removeAt(deleteIndex!);

          }else if(deleteType == 'certification') {
            listPortfolioCertification.removeAt(deleteIndex!);
          }*/
          isDeletePortfolioLoading = false;
          break;
        case ApiStatus.ERROR:
          isDeletePortfolioLoading = false;
          Log.v("Error..........................");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  Future<List<BrandModel>> fetchProducts(String strBrandName) async {
    addressListData.clear();
    String url =
        'https://qa.learningoxygen.com/api/master-brand-search?key= &all_data=1';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${UserSession.userToken}",
        ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
      },
    );
    Map parsedJson = json.decode(response.body);
    if (response.statusCode == 200) {
      print(parsedJson);
      var resultsData = parsedJson['data'] as List;
      print(resultsData.length);
      for (int i = 0; i < resultsData.length; i++) {
        setState(() {
          print(resultsData[i]['title']);
          addressListData.add(new BrandModel.fromJson(resultsData[i]));
          print(addressListData);
          //filteredUsers = addressListData;
        });
        print(resultsData[i]['title']);
      }
      print(resultsData);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
    return addressListData;
  }

  Future<String> _getImages(ImageSource source, String sourceType) async {
    if (sourceType == 'camera') {
      final picker = ImagePicker();
      //PickedFile? pickedFile = await picker.getImage(source: ImageSource.camera,
     /* PickedFile? pickedFile = await picker.getImage(source: ImageSource.camera,
      maxWidth: 400,
      maxHeight: 400);*/

      /*XFile? pickedFile = await picker.pickImage(source: source, imageQuality: 60, maxWidth: 400,
          maxHeight: 400);*/
      final pickedFile = await ImagePicker()
          .pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        return pickedFile.path;
      } /*else if (Platform.isAndroid) {
        //final LostData response = await picker.getLostData();
        final LostDataResponse response = await picker.retrieveLostData();
        if (response.file != null) {
           //return response.file!.path;
           return response.file!.path;
        }
      }*/
      return "";
    } else {
      final picker = ImagePicker();
      PickedFile? pickedFile = await picker.getImage(source: source, imageQuality: 70);
      //XFile? pickedFile = await picker.pickImage(source: source, imageQuality: 60);
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


  Future<String> _cropImage(_pickedFile) async {
    if (_pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: buildUiSettings(context),
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (croppedFile != null) {
        return croppedFile.path;
      }
    }
    return _pickedFile;
  }

  void _initFilePiker() async {
    FilePickerResult? result;
    files!.clear();
    if (await Permission.storage.request().isGranted) {
      if (Platform.isIOS) {
        result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['pdf', 'doc']);
      } else {
        result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['pdf', 'doc']);
      }
      files!.add(result!.paths.first);
      /*this.setState(() {
        files = result?.paths.first as List<String?>?;
      });*/
      print(files![0].toString().contains('.pdf'));

      if (files![0] != null) {
        if (files![0].toString().contains('.pdf')) {
          fileString = files![0].toString();
        } else {
          files!.clear();
          fileString = '';
          Utility.showSnackBar(
              scaffoldContext: context,
              message: 'Only Supported formats - .pdf, .doc');
        }
      }

      /*if (result != null) {
        files = result?.paths.first as List<String?>?;

        print('============= str Doc File==============');
        print(files);
        //strDocFile = result?.paths.first!.toString();
      }*/
    }
  }

  void showBottomSheet(context, String clickSide, Function callback) {
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
                      if (clickSide.endsWith('profile')) {
                        if (value != null) {
                          selectedImage = value;
                          //if(Platform.isIOS) {
                            selectedImage = await _cropImage(value);
                          //}
                        }
                        if (selectedImage != null) {
                          Preference.setString(Preference.PROFILE_IMAGE, '${selectedImage}');
                          _updateUserProfileImage(selectedImage);
                        }

                        setState(() {});
                      } else {
                        setState(() {
                          selectedBrandPath = value;
                        });
                        callback(value);
                      }
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              clickSide.endsWith('profile')
                  ? Container(
                      height: 0.5,
                      color: Colors.grey[100],
                    )
                  : SizedBox(),
              clickSide.endsWith('profile')
                  ? Container(
                      child: ListTile(
                        leading: new Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        ),
                        title: new Text(
                          '${Strings.of(context)?.Camera}',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () async {
                           final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

Navigator.push(context, MaterialPageRoute(builder: (context)=> TakePictureScreen(camera: firstCamera))).then((value) async {
                            if (clickSide.endsWith('profile')) {
                              if (value != null) {
                                selectedImage = value;
                                //if(Platform.isIOS) {
                                  selectedImage = await _cropImage(value);
                                //}
                              }
                              if (selectedImage != null) {
                                Preference.setString(Preference.PROFILE_IMAGE, '${selectedImage}');
                                _updateUserProfileImage(selectedImage);
                              }
                               //_updateUserProfileImage(selectedImage);

                            } else {
                           if(mounted)   setState(() {
                                selectedBrandPath = value;
                              });
                              callback(value);
                            }
                          Navigator.pop(context);

                          if(mounted)  setState(() {});
                          });
                          // Navigator.pop(context);
                        },
                      ),
                    )
                  : SizedBox(),
            ],
          );
        });
  }

  void onCalledFromOutside(String strName, String image, int brandId) {
    print(strName);
    print(image);
    print(brandId);
    titleController.text = strName;
    _result = null;
    setState(() {
      brandImageUrl = image;
      id = brandId;
    });

    /*if(image.isEmpty){
      print('image.isEmpty');
      setState(() {
        flagUploadBranVisible = true;
      });
    }*/
  }


  void editCallBack(){
    _getUserProfile();
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
                                    title: Text("${Strings.of(context)?.email}",
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                ),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  enabled: true,
                                  child: ListTile(
                                    leading: Icon(Icons.phone),
                                    title: Text("${Strings.of(context)?.phone}",
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
