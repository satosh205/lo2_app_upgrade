import 'dart:async';
import 'dart:math';

import 'package:auto_reload/auto_reload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_constants.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/home_request/user_tracking_activity.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/get_content_resp.dart';
import 'package:masterg/pages/custom_pages/card_loader.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/notification_list_page.dart';
import 'package:masterg/pages/swayam_pages/announcemnt_details_page.dart';
import 'package:masterg/pages/swayam_pages/announcemnt_filter_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/images.dart';
import 'package:masterg/utils/utility.dart';
// import 'package:auto_reload/auto_reload.dart';

class AnnouncementPage extends StatefulWidget {
  bool? isViewAll;

  Drawer? drawerWidget;

  AnnouncementPage({this.isViewAll, this.drawerWidget});

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

abstract class _AutoReloadState extends State<AnnouncementPage>
    implements AutoReloader {}

class _AnnouncementPageState extends _AutoReloadState with AutoReloadMixin {
  List<ListData>? announcementList;
  var _isLoading = true;
  int categoryId = 8;
  Box? box;
  int _countOfReload = 0;
  Timer? timer;
  int selectedIndex = 0;

  @override
  void initState() {
    // FirebaseAnalytics().logEvent(name: "annoucements_screen", parameters: null);
    // FirebaseAnalytics().setCurrentScreen(screenName: "announcements_screen");

    _getHomeData();
    super.initState();
    categoryId = int.parse(
        '${Utility.getCategoryValue(ApiConstants.ANNOUNCEMENT_TYPE)}');
    timer = Timer.periodic(Duration(seconds: 20), (Timer t) => _getHomeData());
    startAutoReload();
  }

  @override
  void dispose() {
    //cancelAutoReload();
    super.dispose();
  }

  @override
  void autoReload() {
    setState(() {
      _countOfReload = _countOfReload + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
        child: _mainBody(),
        isDrawerEnable: true,
        isBackShow: false,
        drawerWidget: widget.drawerWidget,
        bgChildColor: ColorConstants.WHITE,
        title: Strings.of(context)?.announcements,
        floatIcon: Icons.filter_alt,
        isFloatIconVisible: true,
        isNotification: true,
        onSkipClicked: () {
          Navigator.push(context, NextPageRoute(NotificationListPage()));
        },
        floatIconTap: () {
          Navigator.push(context, NextPageRoute(AnnouncementFilterPage()));
        },
        onBackPressed: () {
          // Navigator.push(context, NextPageRoute((HomePage())));
        });
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

  _announenmentList() {
    return box != null
        ? ValueListenableBuilder(
            valueListenable: box!.listenable(),
            builder: (bc, Box box, child) {
              if (box.get("announcements") == null) {
                return CardLoader();
              } else if (box.get("announcements").isEmpty) {
                return Container(
                  height: 290,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "There are no announcements available",
                      style: Styles.textBold(),
                    ),
                  ),
                );
              }
              print("#8Amit");
              announcementList = box
                  .get("announcements")
                  .map((e) => ListData.fromJson(Map<String, dynamic>.from(e)))
                  .cast<ListData>()
                  .toList();
              var list = _getFilterList();
              return ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: (widget.isViewAll == true ? 0 : 20)),
                  scrollDirection: widget.isViewAll == true
                      ? Axis.vertical
                      : Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: list == null ? 0 : list.length,
                  itemBuilder: (context, index) {
                    return _rowItem(list[index]);
                  });
            },
          )
        : CardLoader();
  }

  void _userTrack() {
    BlocProvider.of<HomeBloc>(context).add(UserTrackingActivityEvent(
        trackReq: UserTrackingActivity(
            activityType: "page_change",
            context: "",
            activityTime: DateTime.now(),
            device: 1)));
  }

  _verticalList() {
    return _announenmentList();
  }

  _rowItem(ListData item) {
    return InkWell(
      onTap: () {
        Log.v(item.toJson());
        Navigator.push(
            context,
            NextPageRoute(AnnouncementDetailsPage(
              announmentData: item,
              title: Strings.of(context)?.announcements,
            )));
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
                                  image: '${item.thumbnailUrl}',
                                  height: widget.isViewAll!
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
                              image: item.contentType == '2' ||
                                      item.contentType == '11'
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
                          item.tag!.isNotEmpty ? '${item.tag}' : "Null",
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

  _getFilterList() {
    Log.v("_getFilterList $selectedIndex");
    if (UserSession.annoncmentTags == null ||
        UserSession.annoncmentTags!.isEmpty) return announcementList;
    return announcementList
        ?.where(
            (element) => element.tag!.contains('${UserSession.annoncmentTags}'))
        .toList();
  }

  void _handleAnnouncmentData(AnnouncementContentState state) {
    var loginState = state;
    // setState(() {
    switch (loginState.apiState) {
      case ApiStatus.LOADING:
        Log.v("Loading....................");
        break;
      case ApiStatus.SUCCESS:
        Log.v(
            "Su22222222ccess.............${state.contentType}.......${state.contentType}");
        _isLoading = false;
        _userTrack();
        announcementList?.clear();
        if (state.contentType == categoryId) {
          announcementList?.addAll(state.response!.data!.list!.where((element) {
            return element.categoryId == categoryId;
          }).toList());
        }
        break;
      case ApiStatus.ERROR:
        _isLoading = false;
        Log.v("Error..........................");
        Log.v("ErrorAnnoucement..........................${loginState.error}");
        break;
      case ApiStatus.INITIAL:
        // TODO: Handle this case.
        break;
    }
    // });
  }

  void _getHomeData() async {
    box = Hive.box(DB.CONTENT);
    setState(() {
      _countOfReload = _countOfReload + 1;
    });
    BlocProvider.of<HomeBloc>(context)
        .add(AnnouncementContentEvent(contentType: categoryId, box: box));
    setState(() {});
  }

  _horizontalList() {
    var list = _getFilterList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        // Container(
        //     height: 200,
        //     child: Swiper(
        //       viewportFraction: 0.8,
        //       itemBuilder: (BuildContext context, int index) {
        //         return _rowItem(list[index]);
        //       },
        //       onIndexChanged: (page) {
        //         setState(() {
        //           selectedIndex = page;
        //         });
        //       },
        //       autoplay: true,
        //       loop: false,
        //       itemCount: min(list.length, 8),
        //     )),
        _size(height: 10),
        Container(
          height: 20,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: min(list.length, 8),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        height: 14,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: 14,
                        child: Container(),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: selectedIndex == index
                                ? ColorConstants.TEXT_DARK_BLACK
                                    .withOpacity(0.7)
                                : ColorConstants.BG_GREY,
                            border: Border.all(
                                width: 1,
                                color: ColorConstants.TEXT_DARK_BLACK
                                    .withOpacity(0.7)))),
                  ),
                );
              }),
        )
      ],
    );
  }
}
