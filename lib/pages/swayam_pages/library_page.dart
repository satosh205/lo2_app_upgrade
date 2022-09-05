import 'dart:async';

// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_constants.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/content_tags_resp.dart';
import 'package:masterg/data/models/response/home_response/get_content_resp.dart';
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

class LibraryPage extends StatefulWidget {
  bool isViewAll;
  Widget? drawerWidget;

  LibraryPage({this.isViewAll = true, this.drawerWidget});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Box? box;
  Timer? timer;
  List<ListData> libraryList = [];
  var _isLoading = true;
  int? categoryId;
  List<ListTags> tagList = <ListTags>[];

  @override
  void initState() {
    // FirebaseAnalytics().logEvent(name: "library_screen", parameters: null);
    // FirebaseAnalytics().setCurrentScreen(screenName: "library_screen");
    super.initState();
    categoryId = Utility.getCategoryValue(ApiConstants.LIBRARY_TYPE);
    _getHomeData();
    timer = Timer.periodic(Duration(seconds: 20), (Timer t) => _getHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return _mainBody();
  }

  _mainBody() {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is LibraryContentState) _handleAnnouncmentData(state);
            // else if (state is ContentTagsState) _handleResponse(state);
          },
          child: widget.isViewAll ? _verticalList() : _libraryPageList(),
        ));
  }

  _libraryPageList() {
    // var list = _getFilterList();
    return box == null
        ? CardLoader()
        : ValueListenableBuilder(
            valueListenable: box!.listenable(),
            builder: (bc, Box box, child) {
              if (box.get("library") == null) {
                return CardLoader();
              } else if (box.get("library").isEmpty) {
                return Container(
                  height: 290,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "There are no libraries available",
                      style: Styles.textBold(),
                    ),
                  ),
                );
              }
              print("#9");
              libraryList = box
                  .get("library")
                  .map((e) => ListData.fromJson(Map<String, dynamic>.from(e)))
                  .cast<ListData>()
                  .toList();
              var list = _getFilterList();
              return _listWidget(list);
            },
          );
  }

  _getFilterList() {
    Log.v(UserSession.libraryTags);
    if (UserSession.libraryTags == null || UserSession.libraryTags!.isEmpty)
      return libraryList;
    return libraryList
        .where((element) =>
            element.tag?.contains('${UserSession.libraryTags}') as bool)
        .toList();
  }

  _verticalList() {
    return CommonContainer(
      isBackShow: false,
      isDrawerEnable: widget.drawerWidget != null,
      drawerWidget: widget.drawerWidget,
      child: _libraryPageList(),
      title: Strings.of(context)?.library,
      isNotification: true,
      onSkipClicked: () {
        Navigator.push(context, NextPageRoute(NotificationListPage()));
      },
      onBackPressed: () {
        Navigator.pop(context);
      },
      floatIcon: Icons.filter_alt,
      isFloatIconVisible: true,
      floatIconTap: () {
        // Navigator.push(context, NextPageRoute(LibraryFilterPage()));
      },
    );
  }

  _rowItem(ListData item) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     NextPageRoute(LibraryDetailPage(
        //       libraryData: item,
        //     )));
      },
      child: Card(
          margin: EdgeInsets.only(
              top: 5,
              bottom: 5,
              left: widget.isViewAll ? 20 : 5,
              right: widget.isViewAll ? 20 : 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          elevation: 4,
          color: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width /
                (widget.isViewAll ? 1.2 : 1.5),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      child: item.contentType == '1' &&
                              item.thumbnailUrl!.isEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              height: MediaQuery.of(context).size.width /
                                  (widget.isViewAll ? 2.5 : 3),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.description,
                                color: ColorConstants.PRIMARY_COLOR,
                                size: 60,
                              ),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.width /
                                  (widget.isViewAll ? 2.5 : 3),
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                children: [
                                  FadeInImage.assetNetwork(
                                    placeholder: Images.PLACE_HOLDER,
                                    image: item.thumbnailUrl ??
                                        '${item.resourcePath}',
                                    height: MediaQuery.of(context).size.width /
                                        (widget.isViewAll ? 2.5 : 3),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Visibility(
                                      visible: item.contentType == '2',
                                      child: Image(
                                        image: AssetImage(Images.PLAY_ICON),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.watch_later_rounded,
                            size: 12,
                            color: ColorConstants.WHITE,
                          ),
                          _size(width: 3),
                          Text(
                            Utility.convertDateFromMillis(item.createdAt!,
                                Strings.REQUIRED_DATE_DD_MMM_YYYY),
                            style: Styles.boldWhite(size: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _size(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    '${item.title}',
                    style: Styles.textBold(
                        size: 18, color: ColorConstants.TEXT_DARK_BLACK),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage(Images.PRODUCT_CATALOGUE),
                        width: 20,
                        height: 20,
                      ),
                      _size(width: 3),
                      Text(
                        '${item.tag}',
                        textAlign: TextAlign.center,
                        style: Styles.textBold(
                            size: 12, color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                    ],
                  ),
                )
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

  void _handleAnnouncmentData(LibraryContentState state) {
    var loginState = state;
    // setState(() {
    switch (loginState.apiState) {
      case ApiStatus.LOADING:
        Log.v("Loading....................");
        break;
      case ApiStatus.SUCCESS:
        Log.v("Success....................");
        libraryList.clear();
        print(state.contentType);
        print(categoryId);
        // if (state.contentType == categoryId)
        //   libraryList.addAll(state.response.data.list.where((element) {
        //     return element.categoryId == categoryId;
        //   }).toList());
        _isLoading = false;
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
    // });
  }

  void _getHomeData() {
    box = Hive.box("content");
    BlocProvider.of<HomeBloc>(context)
        .add(LibraryContentEvent(contentType: categoryId));
  }

  _listWidget(List<ListData> libraryList) {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: (widget.isViewAll ? 0 : 20)),
        scrollDirection: widget.isViewAll ? Axis.vertical : Axis.horizontal,
        shrinkWrap: true,
        itemCount: libraryList.length,
        itemBuilder: (context, index) {
          return _rowItem(libraryList[index]);
        });
  }

  void _handleResponse(ContentTagsState state) {
    var loginState = state;
    // setState(() {
    switch (loginState.apiState) {
      case ApiStatus.LOADING:
        Log.v("Loading....................");
        _isLoading = true;
        break;
      case ApiStatus.SUCCESS:
        Log.v("Success....................");
        _isLoading = false;
        tagList = state.response?.data?.listTags as List<ListTags>;
        break;
      case ApiStatus.ERROR:
        _isLoading = false;
        Log.v("Error..........................${loginState.error}");
        break;
      case ApiStatus.INITIAL:
        // TODO: Handle this case.
        break;
    }
    // });
  }

  // void getTagList() async {
  //   box = await Hive.openBox("library");
  //   BlocProvider.of<DealerBloc>(context).add(ContentTagsEvent(
  //       categoryType: Utility.getCategoryValue(ApiConstants.LIBRARY_TYPE)));
  // }
}
