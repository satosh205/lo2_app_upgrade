// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
import 'g_portfolio_page.dart';
import 'package:http/http.dart' as http;

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
  List<String?>? files = [];
  bool flagUploadBranVisible = false;
  /*List<MasterBrand> filteredUsers = [];
  List<MasterBrand> addressListData = <MasterBrand>[];*/
  String strDocFile = '';
  int? id;

  @override
  void initState() {
    super.initState();
    //apiFetch();
    _getUserProfile();
  }

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
    BlocProvider.of<HomeBloc>(context)
        .add(UpdateUserProfileImageEvent(filePath: filePath));
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

  void userBrandCreate() {
    print('========= userBrandCreate =========');
    print(files);
    print(fromDateController.text.toString());
    print(id);

    BlocProvider.of<HomeBloc>(context).add(UserBrandCreateEvent(
      startDate: fromDateController.text.toString(),
      //startDate: '2021-01-27 00:00:00',
      //endDate: '2021-05-27 00:00:00',
      endDate: checkBoxValue == false ? toDateController.text.toString(): DateTime.now().toString(),
      typeId: brandImageUrl.isEmpty ? _masterBrandResponse.data!.id: id,
      filePath: files!.length !=0 ? files![0] : '',));
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
    print('========== selectedBrandPath ===========');
    print(selectedBrandPath);

    if (titleController.text.toString().isEmpty) {
      AlertsWidget.showCustomDialog(
          context: context,
          title: "Error",
          text: "Please enter title",
          icon: 'assets/images/circle_alert_fill.svg',
          oKText: 'OK',
          showCancel: false,
          onOkClick: () async {});
    } else if (selectedBrandPath!.isEmpty && brandImageUrl.isEmpty) {
      AlertsWidget.showCustomDialog(
          context: context,
          title: "Error",
          text: "Please select image.",
          icon: 'assets/images/circle_alert_fill.svg',
          oKText: 'OK',
          showCancel: false,
          onOkClick: () async {});
    } else {
      Navigator.pop(context);
      //createPortfolio();
      masterBrandCreate();
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

                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${userProfileDataList!.name}',
                        style:
                            Styles.bold(color: ColorConstants.BLACK, size: 20),
                      ),
                      /*SvgPicture.asset('assets/images/edit_profile_icon.svg',
                          width: 20, height: 20)*/
                    ],
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
                  _addBrand(),

                  //TODO: FAQ Widget
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 12,
                    color: Colors.grey[200],
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

  Widget _addBrand() {
    void updateValue(value) {
      print('the updated vaue is $value');
      setState(() {
        selectedBrandPath = value;
      });
    }

    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 5;
    final double itemWidth = size.width / 5;
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
                      Text('Brand Associations'),
                      listPortfolioBrand.length != 0
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: GestureDetector(
                                  onTap: () async {
                                    print('object delete hh');
                                    this.setState(() {
                                      deleteVisibleIconFlag = true;
                                    });
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
                      onTap: (){
                        selectedBrandPath = '';
                        titleController.clear();
                        fromDateController.clear();
                        toDateController.clear();

                        this.setState(() {
                          _isLoadingAdd = true;
                          checkBoxValue = true;
                          brandImageUrl = '';
                          flagUploadBranVisible = false;
                          files!.clear();
                        });

                        showModalBottomSheet(
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
                                        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
                                        child: TextFormField(
                                          controller: titleController,
                                          readOnly: true,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
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
                                            /*inputFormatters: [
                                                      FilteringTextInputFormatter.deny(RegExp(r"[a-zA-Z -]"))
                                                    ],*/
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
                                              hintText: "Brand Name",
                                              //make hint text
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontFamily: "verdana_regular",
                                                fontWeight: FontWeight.w400,
                                              ),

                                              //create lable
                                              labelText: 'Brand Name',
                                              //lable style
                                              labelStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontFamily: "verdana_regular",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            onTap: () {
                                              print('On Text Click');
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
                                        brandImageUrl.isNotEmpty
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

                                        //TODO: Upload Logo Image
                                        brandImageUrl.isEmpty
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(top: 15.0),
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
                                                                'Upload Brand Logo'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      'Supported formats - .jpeg, .png',
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
                                                          'Upload Joining Letter'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                'Supported formats - .pdf, .doc',
                                                style: Styles.textExtraBold(
                                                    size: 14,
                                                    color:
                                                        ColorConstants.GREY_3),
                                              ),
                                              Text(
                                                'file name',
                                                style: Styles.textExtraBold(
                                                    size: 14,
                                                    color:
                                                        ColorConstants.GREY_3),
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
                                          if(brandImageUrl.isEmpty){
                                            validation();
                                          }else{
                                            if(files!.length == 0){
                                              AlertsWidget.showCustomDialog(
                                                  context: context,
                                                  title: "Error",
                                                  text: "Please select joining letter",
                                                  icon: 'assets/images/circle_alert_fill.svg',
                                                  oKText: 'OK',
                                                  showCancel: false,
                                                  onOkClick: () async {

                                                  });
                                            }else if(fromDateController.text.toString().isEmpty){
                                              AlertsWidget.showCustomDialog(
                                                  context: context,
                                                  title: "Error",
                                                  text: "Please select from date",
                                                  icon: 'assets/images/circle_alert_fill.svg',
                                                  oKText: 'OK',
                                                  showCancel: false,
                                                  onOkClick: () async {

                                                  });
                                            }else{
                                              userBrandCreate();
                                            }
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.bottomCenter,
                                          width: MediaQuery.of(context).size.width * 0.85,
                                          padding: EdgeInsets.all(18),
                                          decoration: BoxDecoration(
                                              color: ColorConstants().primaryColor(),
                                              borderRadius: BorderRadius.all(Radius.circular(5))),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8, top: 4, bottom: 4),
                                            child: Text(
                                              'Submit', textAlign: TextAlign.center,
                                              style: Styles.textExtraBold(
                                                  size: 14,
                                                  color: ColorConstants.WHITE),
                                            ),
                                          ),
                                        ),
                                    )],
                                    ),
                                  ),
                                );
                              });
                            });
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
                            EdgeInsets.only(left: 0.0, right: 10.0, top: 30.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          //childAspectRatio: (itemWidth / itemHeight),
                          childAspectRatio: 1.0,
                        ),
                        itemCount: listPortfolioBrand.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              Container(
                                height: 70,
                                width: 130,
                                child: Center(
                                  //child: Text('${index + 1}' , style: Styles.textRegular(size: 16, color: Colors.white),),
                                  child: Image.network(
                                    '${listPortfolioBrand[index].image}',
                                  ),
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
                                                  "Are you sure you want to delete.",
                                              title: "Alert!",
                                              okText: "Yes",
                                              cancelText: "No",
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
                              SvgPicture.asset(
                                'assets/images/brand_not.svg',
                                allowDrawingOutsideViewBox: true,
                              ),
                              Text(
                                'You have not aded any brand yet,',
                                style: Styles.textExtraBold(
                                    size: 14, color: ColorConstants.GREY_3),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  'Add a brand and let everyone know about your Brand Associations.',
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
                      child: Text('From'))),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(left: 5.0),
                child: Text('To'),
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
                  height: 35,
                  padding: EdgeInsets.only(right: 5.0),
                  child: TextFormField(
                    controller: fromDateController,
                    readOnly: true,
                    style: TextStyle(fontSize: 13.0),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 13.0),
                      hintText: 'From Date',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => calenderOpen('from'),
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
                  height: 35,
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
        //padding: EdgeInsets.all(5.0),
        child: checkBoxValue == true
            ? Row(
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
                    'Present',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )
            : Container(
                //height: 35,
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

  Widget _selectedBrandLogo(){
    //return StatefulBuilder(builder: (context, setstate){
      return Container(
        height: 50,
        width: 100,
        margin: EdgeInsets.only(top: 4.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(File('$selectedBrandPath')),
            fit: BoxFit.fill,
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
      //String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      String formattedDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDate);
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
          _isLoadingAdd = true;
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          print('_handle Master Brand Create Response');
          _isLoadingAdd = false;
          Log.v("Success....................");
          userBrandCreate();
          _masterBrandResponse = state.response!;
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

  void _handleUserBrandCreateResponse(UserBrandCreateState state) {
    var loginState = state;
    this.setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          _isLoadingAdd = true;
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          Navigator.pop(context);
          print('_handle Master Brand Create Response');
          _isLoadingAdd = false;
          Log.v("Success....................");
          _listPortfolio('brand');
          //_masterBrandResponse = state.response!;
          break;
        case ApiStatus.ERROR:
          Navigator.pop(context);
          _listPortfolio('brand');
          _isLoadingAdd = false;
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

  Future<String> _getImages(ImageSource source, String sourceType) async {
    if (sourceType == 'camera') {
      final picker = ImagePicker();
      PickedFile? pickedFile =
          await picker.getImage(source: source, imageQuality: 100);
      if (pickedFile != null) {
        return pickedFile.path;
      } else if (Platform.isAndroid) {
        final LostData response = await picker.getLostData();
        if (response.file != null) {
          return response.file!.path;
        }
      }
      return "";
    } else {
      final picker = ImagePicker();
      PickedFile? pickedFile =
          await picker.getImage(source: source, imageQuality: 100);
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

  void _initFilePiker() async {
    print('============= str Doc File==============');
    FilePickerResult? result;
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
      files!.add(result?.paths.first);
      /*this.setState(() {
        files = result?.paths.first as List<String?>?;
      });*/
      print('============= str Doc File==============');
      print(files![0]);
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
                        selectedImage = value;
                        selectedImage = await _cropImage(value);
                        if (selectedImage != null) {
                          Preference.setString(
                              Preference.PROFILE_IMAGE, '${selectedImage}');
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
                    '${Strings.of(context)?.Camera}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await _getImages(ImageSource.camera, 'camera')
                        .then((value) async {
                      if (clickSide.endsWith('profile')) {
                        selectedImage = value;
                        selectedImage = await _cropImage(value);
                        _updateUserProfileImage(selectedImage);
                      } else {}
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

  void onCalledFromOutside(String strName, String image, int brandId) {
    print(strName);
    print(image);
    print(brandId);
    titleController.text = strName;

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

/*

 Future<List<MasterBrand>> masterBrandCreate() async {
    //List<AddressModel> addressListData = new List<AddressModel>();
    addressListData.clear();

    print('========== masterBrandCreate ===========');

    Map data = {
      //'file': await MultipartFile.fromFile(selectedBrandPath!, filename: 'brand'),
      'file': selectedBrandPath,
      'title': titleController.text.toString(),
      'description': 'Create Brand'
    };
    //encode Map to JSON
    //var body = json.encode(data);

    print(data);

    String url = 'https://qa.learningoxygen.com/api/master-brand-create';
    final response = await http.post(Uri.parse(url),
      body: data,
      headers: {
        "Authorization": "Bearer ${UserSession.userToken}",
        ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
      },);
    Map parsedJson = json.decode(response.body);

    print('======== parsed Json ===========');
    print(parsedJson);

    if (response.statusCode == 200) {
      //flagIndicator = false;

      print(parsedJson);
      var resultsData = parsedJson['data'] as List;


      print('object===========');
      print(resultsData.length);
      for(int i = 0; i <resultsData.length; i++){
        setState(() {

          print(resultsData[i]['id']);
          //addressListData.add(new BrandModel.fromJson(resultsData[i]['title']));
          addressListData.add(new MasterBrand.fromJson(resultsData[i]));

          print(addressListData);

          filteredUsers = addressListData;
        });

        print(resultsData[i]['title']);
      }

      print(resultsData);

    } else {
      throw Exception('Unable to fetch products from the REST API');
    }

    return addressListData;
  }
*/

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
