// ignore_for_file: unused_field

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:masterg/pages/auth_pages/sign_up_screen.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/custom_pages/faq_page.dart';
import 'package:masterg/pages/user_profile_page/mobile_ui_helper.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/models/response/home_response/create_portfolio_response.dart';
import '../../data/models/response/home_response/delete_portfolio_response.dart';
import '../../data/models/response/home_response/list_portfolio_responsed.dart';
import '../../utils/utility.dart';
import '../custom_pages/TapWidget.dart';
import 'g_portfolio_page.dart';

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
  late CreatePortfolioResponse createPortfolioResp;
  bool isPortfolioListLoading = true;
  bool isDeletePortfolioLoading = true;
  late List<PortfolioElement> listPortfolioBrand = [];
  late DeletePortfolioResponse deletePortfolioResp;
  int? deleteIndex;
  String deleteType = '';
  String typeValue = '';
  bool deleteVisibleIconFlag = false;


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
        filePath: selectedBrandPath));
  }

  Future<void> _listPortfolio(String type) async {
    setState(() {
      typeValue = type;
    });
    print(typeValue);
    print(type);
    BlocProvider.of<HomeBloc>(context).add(ListPortfolioEvent(type: type, userId: userProfileDataList!.userId));
  }

  Future<void> _deletePortfolio(int id, int index) async {
    BlocProvider.of<HomeBloc>(context).add(DeletePortfolioEvent(id: id));
  }

  void validation() {
    print('========== selectedBrandPath ===========');
    print(selectedBrandPath);

    if (titleController.text
        .toString()
        .isEmpty) {
      AlertsWidget.showCustomDialog(
          context: context,
          title: "Error",
          text: "Please enter title",
          icon: 'assets/images/circle_alert_fill.svg',
          oKText: 'OK',
          showCancel: false,
          onOkClick: () async {

          });
    } else if (selectedBrandPath!.isEmpty) {
      AlertsWidget.showCustomDialog(
          context: context,
          title: "Error",
          text: "Please select image.",
          icon: 'assets/images/circle_alert_fill.svg',
          oKText: 'OK',
          showCancel: false,
          onOkClick: () async {

          });
    } else {
      Navigator.pop(context);
      createPortfolio();
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
                          showBottomSheet(context, 'profile');
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
                height: 10,
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

               Text(
                 userProfileDataList!.organization!,
                style: Styles.textRegular(color: ColorConstants.BLACK, size: 14),
               ),
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
              Container(
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
                                listPortfolioBrand.length != 0 ? Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      print('object delete');
                                      this.setState(() {
                                        deleteVisibleIconFlag = true;
                                      });
                                    },
                                      child: Icon(Icons.edit, size: 20,)),
                                ):SizedBox(),
                              ],
                            ),
                            GestureDetector(
                                onTap: (){
                                  print('onclick ');
                                  selectedBrandPath = '';
                                  titleController.clear();

                                  this.setState(() {
                                    _isLoadingAdd = true;
                                  });

                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: ColorConstants.WHITE,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return FractionallySizedBox(
                                          heightFactor: 0.4,
                                          child: Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: [

                                                Container(
                                                  margin: EdgeInsets.only(top: 5.0),
                                                  height: 3,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius: BorderRadius.all(Radius.circular(10))),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.only(top: 20),
                                                  child: Text(
                                                    'Add a Brand',
                                                    style:
                                                    Styles.textBold(size: 14, color: ColorConstants.BLACK),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                                                  child: TextFormField(
                                                    controller: titleController,
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
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),

                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        const BorderSide(color: Colors.blue, width: 1.0),
                                                        borderRadius: BorderRadius.circular(10.0),
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
                                                  ),
                                                ),

                                                SizedBox(
                                                  height: 30,
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    showBottomSheet(context, 'brand');
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.file_upload_outlined),
                                                      Text('Upload Brand Logo'),

                                                    ],
                                                  ),
                                                ),

                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Supported formats - .jpeg, .png',
                                                  style: Styles.textExtraBold(
                                                      size: 14,
                                                      color: ColorConstants.GREY_3),
                                                ),
                                                /*selectedBrandPath!.isNotEmpty ? Text(
                                              '${selectedBrandPath!.substring(selectedBrandPath!.length -20)}',
                                              style: Styles.textExtraBold(
                                                  size: 14,
                                                  color: ColorConstants.GREY_3),
                                            ):SizedBox(),*/

                                                SizedBox(
                                                  height: 20,
                                                ),
                                                TapWidget(
                                                  onTap: () {
                                                    validation();
                                                  },
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width * 0.65,
                                                    padding: EdgeInsets.all(8),
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });

                                },child: Icon(Icons.add)),

                          ],
                        ),


                        Container(
                          height: 250,
                          child: listPortfolioBrand.length != 0 ? GridView.builder(

                            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,

                            ),

                            itemCount: listPortfolioBrand.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Container(
                                    child: Center(
                                      //child: Text('${index + 1}' , style: Styles.textRegular(size: 16, color: Colors.white),),
                                      child: Image.network('${listPortfolioBrand[index].image}',),
                                    ),
                                  ),

                                  deleteVisibleIconFlag == true ? Positioned.fill(
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
                                              _deletePortfolio(listPortfolioBrand[index].id!, index);
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 20.0,
                                          width: 20.0,
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            border:
                                            Border.all(width: 0, color: Colors.transparent),
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
                                  ): SizedBox(),
                                ],
                              );
                            },
                          ):Container(
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
                                        size: 14,
                                        color: ColorConstants.GREY_3),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'Add a brand and let everyone know about your Brand Associations.',
                                      style: Styles.textExtraBold(
                                          size: 14,
                                          color: ColorConstants.GREY_3), textAlign: TextAlign.center,
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
              ),

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
                          //Navigator.push(context, NextPageRoute(FaqPage()));
                          Navigator.push(context, NextPageRoute(GPortfolioPage(
                            profileUrl: userProfileDataList!.profileImage,
                          name: userProfileDataList!.name,)));
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
          Preference.setString(Preference.PROFILE_IMAGE, '${userProfileDataList!.profileImage}');

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

          if(state.response!.data!.list != null){
            for(int i = 0; i < state.response!.data!.list!.length; i++){
              if(state.response!.data!.list![i].type == 'brand'){
                listPortfolioBrand = state.response!.data!.list!;

              }/*else if(state.response!.data!.list![i].type == 'award'){
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
          deletePortfolioResp = state.response!;
          if(deleteType == 'brand') {
            listPortfolioBrand.removeAt(deleteIndex!);

            deleteVisibleIconFlag = false;

          }/*else if(deleteType == 'award') {
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

  void showBottomSheet(context, String clickSide) {
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
                    '${Strings
                        .of(context)
                        ?.Gallery}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await _getImages(ImageSource.gallery, 'gallery').then((
                        value) async {
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
                    '${Strings
                        .of(context)
                        ?.Camera}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await _getImages(ImageSource.camera, 'camera').then((
                        value) async {
                      if (clickSide.endsWith('profile')) {
                        selectedImage = value;
                        selectedImage = await _cropImage(value);
                        _updateUserProfileImage(selectedImage);
                      }else{

                      }
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
