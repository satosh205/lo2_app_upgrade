// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/get_content_resp.dart';
// import 'package:masterg/pages/account_pages/address_screen.dart';
// import 'package:masterg/pages/announecment_pages/announcemnt_details_page.dart';
import 'package:masterg/pages/auth_pages/sign_up_screen.dart';
import 'package:masterg/pages/custom_pages/card_loader.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/notification_list_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/images.dart';
import 'package:masterg/utils/utility.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'notification_list_page.dart';

class ProfilePage extends StatefulWidget {
  Widget? drawerWidget;
  bool? isViewAll = true;

  ProfilePage({this.drawerWidget});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ListData>? benefitstList;
  var _isLoading = true;
  int categoryId = 10;

  int selectedIndex = 0;

  @override
  void initState() {
    // FirebaseAnalytics()
    //     .logEvent(name: "myspace_benefits_screen", parameters: null);
    // FirebaseAnalytics().setCurrentScreen(screenName: "myspace_benefits_screen");
    _getHomeData();
    super.initState();
  }

  void _getHomeData() {
    BlocProvider.of<HomeBloc>(context)
        .add(AnnouncementContentEvent(contentType: categoryId));
  }

  _getFilterList() {
    Log.v("_getFilterList $selectedIndex");
    if (UserSession.annoncmentTags == null ||
        UserSession.annoncmentTags!.isEmpty) return benefitstList;
    return benefitstList
        ?.where(
            (element) => element.tag!.contains('${UserSession.annoncmentTags}'))
        .toList();
  }

  _announenmentList() {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: Hive.box("content").listenable(),
        builder: (bc, Box box, child) {
          if (box.get("benefits") == null) {
            return CardLoader();
          } else if (box.get("benefits").isEmpty) {
            return Container(
              height: 290,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "There are no benefits available",
                  style: Styles.textBold(),
                ),
              ),
            );
          }
          print("#8");
          benefitstList = box
              .get("benefits")
              .map((e) => ListData.fromJson(Map<String, dynamic>.from(e)))
              .cast<ListData>()
              .toList();
          return ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: (widget.isViewAll == true ? 0 : 20)),
              scrollDirection:
                  widget.isViewAll == true ? Axis.vertical : Axis.horizontal,
              shrinkWrap: true,
              itemCount: benefitstList == null ? 0 : benefitstList?.length,
              itemBuilder: (context, index) {
                return _rowItem(benefitstList![index]);
              });
        },
      ),
    );
  }

  _verticalList() {
    return _announenmentList();
  }

  _rowItem(ListData item) {
    return InkWell(
      onTap: () {
        Log.v(item.toJson());
        // Navigator.push(
        //     context,
        //     NextPageRoute(AnnouncementDetailsPage(
        //         announmentData: item, title: Strings.of(context).benefits)));
      },
      child: Card(
          margin: EdgeInsets.only(
              top: 5,
              bottom: 5,
              left: widget.isViewAll == true ? 20 : 5,
              right: widget.isViewAll == true ? 20 : 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          elevation: 2,
          color: Colors.white,
          child: Container(
            width: widget.isViewAll == false
                ? 290
                : MediaQuery.of(context).size.width /
                    (widget.isViewAll == true ? 1 : 1.3),
            height: widget.isViewAll == true
                ? MediaQuery.of(context).size.width / 1.68
                : 200,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      child: item.contentType == '1'
                          ? item.thumbnailUrl != null &&
                                  item.thumbnailUrl!.isNotEmpty
                              ? FadeInImage.assetNetwork(
                                  placeholder: Images.PLACE_HOLDER,
                                  image: item.thumbnailUrl!,
                                  height: widget.isViewAll == true
                                      ? MediaQuery.of(context).size.width /
                                              1.68 -
                                          60
                                      : 130,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  height: widget.isViewAll == true
                                      ? MediaQuery.of(context).size.width /
                                              1.68 -
                                          60
                                      : 130,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.description,
                                    color: ColorConstants.PRIMARY_COLOR,
                                    size: 60,
                                  ),
                                )
                          : FadeInImage.assetNetwork(
                              placeholder: Images.PLACE_HOLDER,
                              image: item.contentType == '2'
                                  ? item.thumbnailUrl ?? ""
                                  : item.resourcePath ?? "",
                              height: widget.isViewAll == true
                                  ? MediaQuery.of(context).size.width / 1.68 -
                                      60
                                  : 130,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                    ),
                    Container(
                      height: widget.isViewAll == true
                          ? MediaQuery.of(context).size.width / 1.68 - 60
                          : 130,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '${item.title}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.textBold(
                              size: 18, color: ColorConstants.WHITE),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: item.contentType == '2',
                      child: Image(
                        image: AssetImage(Images.PLAY_ICON),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(Images.CLOCK),
                      ),
                      _size(width: 3),
                      Text(
                        Utility.convertDateFromMillis(
                            item.createdAt!, Strings.REQUIRED_DATE_DD_MMM_YYYY),
                        style: Styles.textRegular(size: 12),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: ColorConstants.BG_LIGHT_GREY,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Text(
                          item.tag!.isNotEmpty ? item.tag! : "Null",
                          textAlign: TextAlign.center,
                          style: Styles.textBold(
                              size: 12, color: ColorConstants.TEXT_DARK_BLACK),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _size({double height = 20, double width = 0}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  void _handleAnnouncmentData(AnnouncementContentState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          Log.v(
              "Su22222222ccess.............${state.contentType}.......${state.contentType}");
          _isLoading = false;
          benefitstList?.clear();
          if (state.contentType == categoryId) {
            benefitstList = state.response?.data?.list?.where((element) {
              return element.categoryId == categoryId;
            }).toList();
          }
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

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      child: _content(),
      isDrawerEnable: true,
      isBackShow: false,
      isNotification: true,
      onSkipClicked: () {
        Navigator.push(context, NextPageRoute(NotificationListPage()));
      },
      drawerWidget: widget.drawerWidget,
      bgChildColor: ColorConstants.WHITE,
      title: Strings.of(context)?.accountSettings,
    );
  }

  _mainBody() {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is AnnouncementContentState)
              _handleAnnouncmentData(state);
          },
          child: _verticalList(),
        ));
  }

  _content() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _size(),
          _getRowItem(Images.IC_PROFILE, '${Strings.of(context)?.profile}',
              onTap: () {
            Navigator.push(
                context,
                NextPageRoute(SignUpScreen(
                  isFromProfile: true,
                )));
          }),
          _size(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${Strings.of(context)?.benefits}',
                  style: Styles.textBold(size: 16)),
            ],
          ),
          _mainBody()
          /*_getRowItem(Images.IC_ADDRESS, Strings.of(context).address,
              onTap: () {
            Navigator.push(
                context,
                NextPageRoute(AddressScreen(
                  isFromProfile: true,
                )));
          }),*/
          /*_size(),
          _getRowItem(Images.IC_SOCIAL_MEDIA, Strings.of(context).socialMedia,
              onTap: () {
            Navigator.push(
                context, NextPageRoute(SocialMediaPage(isFromProfile: true)));
          }),
          _size(),
          _getRowItem(Images.IC_ADD_MEMBER, Strings.of(context).addFamilyMember,
              onTap: () {
            Navigator.push(context, NextPageRoute(FamilyListPage()));
          }),
          _size(),
          _getRowItem(
              Images.IC_BUSINESS_DETAILS, Strings.of(context).businessDetails,
              onTap: () {
            Navigator.push(context,
                NextPageRoute(BusinessDetailsPage(isFromProfile: true)));
          }),*/
        ],
      ),
    );
  }

  _getRowItem(String image, String title, {Function? onTap}) {
    return InkWell(
      onTap: () {
      Navigator.push(
                context,
                NextPageRoute(SignUpScreen(
                  isFromProfile: true,
                )));
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: AssetImage(image),
              width: 20,
              height: 20,
            ),
            _size(height: 0, width: 10),
            Text(
              title,
              style: Styles.textBold(size: 16),
            )
          ],
        ),
      ),
    );
  }
}
