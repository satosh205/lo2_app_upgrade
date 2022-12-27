import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/dashboard_content_resp.dart';
import 'package:masterg/data/models/response/auth_response/dashboard_view_resp.dart';
import 'package:masterg/data/models/response/home_response/joy_contentList_response.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/ghome/widget/view_widget_details_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/custom_progress_indicator.dart';
import 'package:masterg/utils/resource/colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Box? box;
  bool? dashboardIsVisibleLoading = true;
  bool? dasboardListLoading = true;

  DashboardContentResponse? dashboardContentResponse;
  List<DashboardFeaturedContentLimit>? featuredContentList;
  DashboardViewResponse? dashboardViewResponse;

  bool showAllFeatured = false;

  @override
  void initState() {
    getDashboardIsVisible();
    getDasboardList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) async {},
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                'Welcome',
                style: Styles.semibold(size: 14),
              ),
              Text(
                '${Preference.getString(Preference.FIRST_NAME)}',
                style: Styles.bold(size: 28),
              ),
              Text(
                'Begin your learning journey',
                style: Styles.regular(),
              ),
              getFeaturedContentLimit()
            ],
          )),
        ));
  }

  getFeaturedContentLimit() {
    return ValueListenableBuilder(
      valueListenable: Hive.box(DB.CONTENT).listenable(),
      builder: (bc, Box box, child) {
        if (box.get("dashboard_featured_content_limit") == null) {
          // return CustomProgressIndicator(true, Colors.white);
          return Text('lading');
        } else if (box.get("dashboard_featured_content_limit").isEmpty) {
          return Container(
            height: 290,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                "There are no getDashboardIsVisible available",
                style: Styles.textBold(),
              ),
            ),
          );
        }

        featuredContentList = box
            .get("dashboard_featured_content_limit")
            .map((e) => DashboardFeaturedContentLimit.fromJson(
                Map<String, dynamic>.from(e)))
            .cast<DashboardFeaturedContentLimit>()
            .toList();

        return Container(
          margin: EdgeInsets.only(left: 17, right: 17, top: 17),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(
                  color: ColorConstants.GREY_3,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.star, color: ColorConstants.YELLOW),
                  SizedBox(width: 8),
                  Text('Featured Updates', style: Styles.bold()),
                  Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      // menuProvider
                      //     .updateCurrentIndex(1);
                    },
                    child: Text('View all',
                        style: Styles.regular(
                          size: 12,
                          color: ColorConstants.ORANGE_3,
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Visibility(
                  visible: featuredContentList!.length > 0,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: showAllFeatured
                        ? featuredContentList!.length
                        : min(2, featuredContentList!.length),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 20,
                        childAspectRatio: 2 / 3,
                        mainAxisExtent:
                            MediaQuery.of(context).size.height * 0.35,
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          // value
                          //     .enableProviderControl();
                          // value.mute();
                          // value.pause().then((data) =>
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: ColorConstants.WHITE,
                              isScrollControlled: true,
                              builder: (context) {
                                return FractionallySizedBox(
                                    heightFactor: 1.0,
                                    child: ViewWidgetDetailsPage(
                                      joyContentList: featuredContentList
                                          as List<JoyContentListElement>,
                                      currentIndex: index,
                                    ));
                              });
                        },
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.25,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          foregroundDecoration: BoxDecoration(
                                              gradient: LinearGradient(
                                            end: const Alignment(0.0, -1),
                                            begin: const Alignment(0.0, 0.8),
                                            colors: [
                                              const Color(0x8A000000)
                                                  .withOpacity(0.4),
                                              Colors.black12.withOpacity(0.0)
                                            ],
                                          )),
                                          child: CachedNetworkImage(
                                            imageUrl: '',
                                            // '${featuredContentList![index].thumbnailUrl}',
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                              )),
                                            ),
                                            placeholder: (context, url) =>
                                                Image.asset(
                                              'assets/images/placeholder.png',
                                              fit: BoxFit.fill,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              'assets/images/placeholder.png',
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                          // child: Image.network(
                                          //   '${featuredContentList![index].thumbnailUrl}',
                                          //   fit: BoxFit.fill,
                                          // ),
                                          ),
                                    ),
                                    if (featuredContentList![index]
                                        .resourcePath!
                                        .contains('.mp4'))
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                            'assets/images/play_video_icon.svg',
                                            height: 30.0,
                                            width: 30.0,
                                            allowDrawingOutsideViewBox: true,
                                          ),
                                        ),
                                      ),
                                  ],
                                )),
                            Container(
                              height: 60,
                              margin: EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // featuredContentList![
                                  //                 index]
                                  //             .viewCount !=
                                  //         null
                                  //     ? Row(
                                  //         children: [
                                  //           Text(
                                  //               '${featuredContentList![index].viewCount}  ${Strings.of(context)?.Views}',
                                  //               style: Styles.regular(
                                  //                   size: 10,
                                  //                   color: ColorConstants.GREY_3)),
                                  //           if (featuredContentList![index]
                                  //                   .viewCount! >
                                  //               1)
                                  //             Text(
                                  //                 Preference.getInt(Preference.APP_LANGUAGE) == 1
                                  //                     ? 's'
                                  //                     : '',
                                  //                 style:
                                  //                     Styles.regular(size: 10, color: ColorConstants.GREY_3)),
                                  //         ],
                                  //       )
                                  //     : Text(
                                  //         '${0}  ${Strings.of(context)?.Views}',
                                  //         style: Styles.regular(
                                  //             size:
                                  //                 10,
                                  //             color: ColorConstants
                                  //                 .GREY_3)),
                                  // SizedBox(
                                  //   width: 10,
                                  //   height: 4,
                                  // ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                        featuredContentList![index].title ?? '',
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: Styles.semibold(
                                            size: 14,
                                            color: ColorConstants.GREY_1)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void getDashboardIsVisible() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(DashboardIsVisibleEvent());
  }

  void getDasboardList() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(DashboardContentEvent());
  }

  void handleDashboardIsVisible(DashboardIsVisibleState state) {
    var dashboardIsVisibleState = state;
    setState(() {
      switch (dashboardIsVisibleState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          dashboardIsVisibleLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("DashboardIsVisibleState....................");
          Log.v(state.response!.data);
          dashboardViewResponse = state.response;

          dashboardIsVisibleLoading = false;
          break;
        case ApiStatus.ERROR:
          dashboardIsVisibleLoading = false;
          Log.v("Error..........................");
          Log.v(
              "Error..........................${dashboardIsVisibleState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void handleDasboardList(DashboardContentState state) {
    var dashboardContentState = state;
    setState(() {
      switch (dashboardContentState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          dasboardListLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("DashboardContentState....................");
          Log.v(state.response!.data);
          dashboardContentResponse = state.response;

          dasboardListLoading = false;
          break;
        case ApiStatus.ERROR:
          dasboardListLoading = false;
          Log.v("Error..........................");
          Log.v(
              "Error..........................${dashboardContentState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}
