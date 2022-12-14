import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/home_response/joy_contentList_response.dart';
import 'package:masterg/data/models/response/home_response/onboard_sessions.dart';
import 'package:masterg/data/providers/video_player_provider.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/gcarvaan/post/gcarvaan_post_page.dart';
import 'package:masterg/pages/ghome/my_assessments.dart';
import 'package:masterg/pages/ghome/my_assignments.dart';
import 'package:masterg/pages/ghome/my_courses.dart';
import 'package:masterg/pages/ghome/widget/view_widget_details_page.dart';
import 'package:masterg/pages/reels/reels_dashboard_page.dart';
import 'package:masterg/pages/singularis/reels_horizontal.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/config.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/response/home_response/popular_courses_response.dart';
import '../training_pages/new_screen/courses_details_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Box? box;
  List<JoyContentListElement>? joyContentListResponse;
  List<JoyContentListElement>? joyContentListView;
  int? selectedJoyContentCategoryId = 1;
  bool isJoyContentListLoading = false;
  bool isJoyCategoryLoading = true;
  bool isNotLiveclass = false;
  late VideoPlayerProvider videoPlayerProvider;
  List<Recommended>? recommendedcourses = [];

  bool showAllFeatured = false;

  List<Liveclass>? liveclassList;

  @override
  void initState() {
    _getJoyContentList();
    _getLiveClass();
    _getFilteredPopularCourses();
    _getPopularCourses();

    super.initState();
  }

  void _getJoyContentList() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(JoyContentListEvent());
  }

  void _getPopularCourses() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(PopularCoursesEvent());
  }

  void _getLiveClass() {
    BlocProvider.of<HomeBloc>(context).add(getLiveClassEvent());
  }

  void _getFilteredPopularCourses() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(FilteredPopularCoursesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        backgroundColor: ColorConstants.WHITE,
        body: SafeArea(
          child: BlocManager(
              initState: (context) {},
              child: Consumer2<VideoPlayerProvider, MenuListProvider>(
                builder: (context, value, menuProvider, child) => BlocManager(
                  initState: (context) {
                    videoPlayerProvider = value;
                  },
                  child: BlocListener<HomeBloc, HomeState>(
                    listener: (context, state) async {
                      if (state is JoyContentListState) {
                        _handleJoyContentListResponse(state);
                      }
                      if (state is getLiveClassState)
                        _handleLiveClassResponse(state);

                      if (state is FilteredPopularCoursesState)
                        _handlePopularFilteredCourses(state);
                    },
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //user detail start
                            Container(
                              // margin: EdgeInsets.only(top: 16),
                              margin:
                                  EdgeInsets.only(left: 17, right: 17, top: 17),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                ],
                              ),
                            ),

                            //grid view content start

                            ValueListenableBuilder(
                                valueListenable: box!.listenable(),
                                builder: (bc, Box box, child) {
                                  if (box.get("joyContentListResponse") ==
                                      null) {
                                    return Shimmer.fromColors(
                                      baseColor: Color(0xffe6e4e6),
                                      highlightColor: Color(0xffeaf0f3),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 20),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                      ),
                                    );
                                  } else if (box
                                      .get("joyContentListResponse")
                                      .isEmpty) {
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

                                  joyContentListResponse = box
                                      .get("joyContentListResponse")
                                      .map((e) =>
                                          JoyContentListElement.fromJson(
                                              Map<String, dynamic>.from(e)))
                                      .cast<JoyContentListElement>()
                                      .toList();
                                  joyContentListView = joyContentListResponse;

                                  if (selectedJoyContentCategoryId != 1) {
                                    joyContentListView = joyContentListView
                                        ?.where((element) =>
                                            element.categoryId ==
                                            selectedJoyContentCategoryId)
                                        .toList();
                                  }

                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: 17, right: 17, top: 17),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          child: Divider(
                                            color: ColorConstants.GREY_3,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.star,
                                                color: ColorConstants.YELLOW),
                                            SizedBox(width: 8),
                                            Text('Featured Updates',
                                                style: Styles.bold()),
                                            Expanded(child: SizedBox()),
                                            InkWell(
                                              onTap: () {
                                                menuProvider
                                                    .updateCurrentIndex(1);
                                              },
                                              child: Text('View all',
                                                  style: Styles.regular(
                                                    size: 12,
                                                    color:
                                                        ColorConstants.ORANGE_3,
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Visibility(
                                            visible:
                                                joyContentListView!.length > 0,
                                            child: GridView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: showAllFeatured
                                                  ? joyContentListView!.length
                                                  : min(
                                                      2,
                                                      joyContentListView!
                                                          .length),
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      mainAxisSpacing: 0,
                                                      crossAxisSpacing: 20,
                                                      childAspectRatio: 2 / 3,
                                                      mainAxisExtent:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.35,
                                                      crossAxisCount: 2),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return InkWell(
                                                  onTap: () async {
                                                    value
                                                        .enableProviderControl();
                                                    value.mute();
                                                    value.pause().then((data) =>
                                                        showModalBottomSheet(
                                                            context: context,
                                                            backgroundColor:
                                                                ColorConstants
                                                                    .WHITE,
                                                            isScrollControlled:
                                                                true,
                                                            builder: (context) {
                                                              return FractionallySizedBox(
                                                                  heightFactor:
                                                                      1.0,
                                                                  child:
                                                                      ViewWidgetDetailsPage(
                                                                    joyContentList:
                                                                        joyContentListView,
                                                                    currentIndex:
                                                                        index,
                                                                  ));
                                                            }));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Stack(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child: Container(
                                                                    height: MediaQuery.of(context).size.height * 0.25,
                                                                    width: MediaQuery.of(context).size.width,
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                                                    foregroundDecoration: BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                      end: const Alignment(
                                                                          0.0,
                                                                          -1),
                                                                      begin: const Alignment(
                                                                          0.0,
                                                                          0.8),
                                                                      colors: [
                                                                        const Color(0x8A000000)
                                                                            .withOpacity(0.4),
                                                                        Colors
                                                                            .black12
                                                                            .withOpacity(0.0)
                                                                      ],
                                                                    )),
                                                                    child: CachedNetworkImage(
                                                                      imageUrl:
                                                                          '${joyContentListView![index].thumbnailUrl}',
                                                                      imageBuilder:
                                                                          (context, imageProvider) =>
                                                                              Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                                image: DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        )),
                                                                      ),
                                                                      placeholder: (context,
                                                                              url) =>
                                                                          Image
                                                                              .asset(
                                                                        'assets/images/placeholder.png',
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Image
                                                                              .asset(
                                                                        'assets/images/placeholder.png',
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                    )
                                                                    // child: Image.network(
                                                                    //   '${joyContentListView![index].thumbnailUrl}',
                                                                    //   fit: BoxFit.fill,
                                                                    // ),
                                                                    ),
                                                              ),
                                                              if (joyContentListView![
                                                                      index]
                                                                  .resourcePath!
                                                                  .contains(
                                                                      '.mp4'))
                                                                Positioned.fill(
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      'assets/images/play_video_icon.svg',
                                                                      height:
                                                                          30.0,
                                                                      width:
                                                                          30.0,
                                                                      allowDrawingOutsideViewBox:
                                                                          true,
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          )),
                                                      Container(
                                                        height: 60,
                                                        margin: EdgeInsets.only(
                                                            top: 4),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            joyContentListView![
                                                                            index]
                                                                        .viewCount !=
                                                                    null
                                                                ? Row(
                                                                    children: [
                                                                      Text(
                                                                          '${joyContentListView![index].viewCount}  ${Strings.of(context)?.Views}',
                                                                          style: Styles.regular(
                                                                              size: 10,
                                                                              color: ColorConstants.GREY_3)),
                                                                      if (joyContentListView![index]
                                                                              .viewCount! >
                                                                          1)
                                                                        Text(
                                                                            Preference.getInt(Preference.APP_LANGUAGE) == 1
                                                                                ? 's'
                                                                                : '',
                                                                            style:
                                                                                Styles.regular(size: 10, color: ColorConstants.GREY_3)),
                                                                    ],
                                                                  )
                                                                : Text(
                                                                    '${0}  ${Strings.of(context)?.Views}',
                                                                    style: Styles.regular(
                                                                        size:
                                                                            10,
                                                                        color: ColorConstants
                                                                            .GREY_3)),
                                                            // SizedBox(
                                                            //   width: 10,
                                                            //   height: 4,
                                                            // ),
                                                            SizedBox(
                                                              width: 150,
                                                              child: Text(
                                                                  joyContentListView![
                                                                              index]
                                                                          .title ??
                                                                      '',
                                                                  maxLines: 2,
                                                                  softWrap:
                                                                      true,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: Styles
                                                                      .semibold(
                                                                          size:
                                                                              14,
                                                                          color:
                                                                              ColorConstants.GREY_1)),
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
                                }),

                            //grid view content end

                            //Live classes start

                            Container(
                                // color: ColorConstants.GREY_4,
                                child: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: liveclassList != null &&
                                            liveclassList!.length > 0
                                        ? _getTodayClass()
                                        : Container())),

                            //live class ended

                            //recent activites
                            Container(
                              color: ColorConstants.GREY,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, top: 16, right: 12),
                                child: Row(
                                  children: [
                                    Text(
                                      'Recent activites',
                                      style: Styles.bold(),
                                    ),
                                    Expanded(child: SizedBox()),
                                  ],
                                ),
                              ),
                            ),

                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                child: MyAssignmentPage(fromDashboard: true)),

                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                child: MyAssessmentPage(fromDashboard: true)),

                            //recent activites end

                            //mycourses starrted
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, top: 16, right: 12),
                              child: Row(
                                children: [
                                  Text(
                                    'My Courses',
                                    style: Styles.bold(),
                                  ),
                                  Expanded(child: SizedBox()),
                                  InkWell(
                                    onTap: () {
                                      // menuProvider.updateCurrentIndex(2);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyCourses()));
                                    },
                                    child: Text('View all',
                                        style: Styles.regular(
                                          size: 12,
                                          color: ColorConstants.ORANGE_3,
                                        )),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: MyCourses(fromDashboard: true)),

                            Container(
                              height: MediaQuery.of(context).size.height * 0.04,
                              width: double.infinity,
                              color: ColorConstants.GREY,
                            ),

                            //Latest Trends start

                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            'Latest Trends',
                                            style: Styles.bold(),
                                          )),
                                      Expanded(child: SizedBox()),
                                      IconButton(
                                          onPressed: () {
                                            menuProvider.updateCurrentIndex(3);
                                          },
                                          icon: Icon(Icons.arrow_forward_ios))
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: Divider(
                                      color: ColorConstants.GREY_3,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.34,
                                    child: ReelHorizontal(),
                                  )
                                ],
                              ),
                            ),
                            //Latest Trends end

                            //recommended course start

                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            'Recommended Courses',
                                            style: Styles.bold(),
                                          )),
                                      Expanded(child: SizedBox()),
                                      IconButton(
                                          onPressed: () {
                                            menuProvider.updateCurrentIndex(2);
                                          },
                                          icon: Icon(Icons.arrow_forward_ios))
                                    ],
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.34,
                                    child: _getRecommendedCourses(
                                        context,
                                        MediaQuery.of(context).size.height *
                                            0.35),
                                  )
                                ],
                              ),
                            ),

                            //recommended course end

                            //recent Careers start

                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 10,
                                        ),
                                        child: Text(
                                          'Recent Career Posts',
                                          style: Styles.bold(),
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      // Icon(Icons.arrow_forward_ios)
                                      IconButton(
                                          onPressed: () {
                                            menuProvider.updateCurrentIndex(4);
                                          },
                                          icon: Icon(Icons.arrow_forward_ios))
                                    ],
                                  ),

                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    color: ColorConstants.WHITE,
                                    child: GCarvaanPostPage(
                                      fileToUpload: null,
                                      desc: null,
                                      filesPath: null,
                                      formCreatePost: false,
                                      fromDashboard: true,
                                    ),
                                  ),

                                  //show posts
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ));
  }

  Widget _getRecommendedCourses(context, size) {
    var title = Strings.of(context)!.recommendedCourses;
    return ValueListenableBuilder(
      valueListenable: box!.listenable(),
      builder: (bc, Box box, child) {
        if (box.get("recommended") == null) {
          // return Container();
          return Column(
            children: [
              Shimmer.fromColors(
                baseColor: Color(0xffe6e4e6),
                highlightColor: Color(0xffeaf0f3),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.02,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),
              ListView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Shimmer.fromColors(
                        baseColor: Color(0xffe6e4e6),
                        highlightColor: Color(0xffeaf0f3),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6)),
                        ),
                      )),
            ],
          );
        } else if (box.get("recommended").isEmpty) {
          return Container();
        }

        recommendedcourses = box
            .get("recommended")
            .map((e) => Recommended.fromJson(Map<String, dynamic>.from(e)))
            .cast<Recommended>()
            .toList();

        // recommendedcourse.sor
        if (APK_DETAILS['package_name'] == 'com.learn_build')
          recommendedcourses
              ?.sort((a, b) => a.categoryName!.compareTo(b.categoryName!));
        //var list = _getFilterList();
        return Container(
            padding: EdgeInsets.all(10),
            height: size,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: ColorConstants.WHITE),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return _getCourseTemplate(context, recommendedcourses![index],
                    index, 'TagReco', size);
              },
              itemCount: recommendedcourses?.length ?? 0,
              shrinkWrap: true,
            ));
      },
    );
  }

  Widget _getCourseTemplate(context, yourCourses, int index, String tag, size) {
    List<String> duration = yourCourses.duration.toString().split(' ');
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CoursesDetailsPage(
                  imgUrl: recommendedcourses![index].image,
                  indexc: index,
                  tagName: 'TagReco',
                  name: recommendedcourses![index].name,
                  description: recommendedcourses![index].description ?? '',
                  regularPrice: recommendedcourses![index].regularPrice,
                  salePrice: recommendedcourses![index].salePrice,
                  trainer: recommendedcourses![index].trainer,
                  enrolmentCount: recommendedcourses![index].enrolmentCount,
                  type: recommendedcourses![index].subscriptionType,
                  id: recommendedcourses![index].id,
                  shortCode: recommendedcourses![index].shortCode)),
        ).then((isSuccess) {
          if (isSuccess == true) {
            print('sucess enrolled');
            _getPopularCourses();
            _getFilteredPopularCourses();

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyCourses()));
          }
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
            border: Border.all(color: ColorConstants.GREY_4),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size * 0.5,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    '${yourCourses.image}',
                    errorBuilder: (context, error, stackTrace) {
                      return SvgPicture.asset(
                        'assets/images/gscore_postnow_bg.svg',
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Text('${yourCourses.name}',
                              overflow: TextOverflow.ellipsis,
                              style: Styles.bold(size: 16))),
                      Icon(CupertinoIcons.clock,
                          size: 15, color: Color(0xFFFDB515)),
                      SizedBox(width: 2),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text('${duration[0]} ${duration[1]}',
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: Styles.regular(
                                  size: 10, color: Colors.black)))
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text('by ${yourCourses.trainer}',
                    style: Styles.regular(size: 12)),
              ),
              SizedBox(
                height: 2,
              ),
              Center(
                  child: Text(
                      '${yourCourses.enrolmentCount} Students already enrolled in this course',
                      style: Styles.regular(size: 12))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start now',
                    style: Styles.semibold(),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  // Text(
                  //     '${yourCourses.enrolmentCount} ${Strings.of(context)?.enrollments}',
                  //     style: Styles.regular(size: 12)),
                  Row(
                    children: [
                      if (yourCourses.regularPrice != null)
                        Text('₹${yourCourses.regularPrice}',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                            )),
                      SizedBox(
                        width: 8,
                      ),
                      if (yourCourses.salePrice != null)
                        Text(
                          '₹${yourCourses.salePrice}',
                          style: Styles.semibold(
                              size: 22, color: ColorConstants.GREEN),
                        ),
                    ],
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  Widget _getTodayClass() {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: ColorConstants.GREY),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(left: 4, top: 10),
              child:
                  Text('Today\'s classes', style: Styles.semibold(size: 18))),
          ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return liveclassList!.length > 0
                  ? Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: ColorConstants.WHITE,
                          border:
                              Border.all(color: Colors.grey[350]!, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            liveclassList![index]
                                        .liveclassStatus!
                                        .toLowerCase() ==
                                    'live'
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      liveclassList![index]
                                                  .contentType!
                                                  .toLowerCase() !=
                                              'offlineclass'
                                          ? SvgPicture.asset(
                                              'assets/images/live_icon.svg',
                                              width: 25,
                                              height: 25,
                                              allowDrawingOutsideViewBox: true,
                                            )
                                          : SvgPicture.asset(
                                              'assets/images/offline_live.svg',
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                      SizedBox(width: 5),
                                      Text(
                                          liveclassList![index]
                                                      .contentType!
                                                      .toLowerCase() ==
                                                  'offlineclass'
                                              ? 'Ongoing'
                                              : "${Strings.of(context)?.liveNow}",
                                          style: Styles.regular(
                                              size: 12,
                                              color: ColorConstants()
                                                  .primaryColor())),
                                      Expanded(child: SizedBox()),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: ColorConstants.BG_GREY),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 18),
                                        child: Text(
                                            liveclassList![index]
                                                            .contentType!
                                                            .toLowerCase() ==
                                                        'liveclass' ||
                                                    liveclassList![index]
                                                            .contentType!
                                                            .toLowerCase() ==
                                                        'zoomclass'
                                                ? "Live"
                                                : 'Classroom',
                                            style: Styles.regular(
                                                size: 10,
                                                color: ColorConstants.BLACK)),
                                      ),
                                    ],
                                  )
                                : liveclassList![index]
                                            .liveclassStatus!
                                            .toLowerCase() ==
                                        'upcoming'
                                    ? Row(children: [
                                        SvgPicture.asset(
                                          'assets/images/upcoming_live.svg',
                                          allowDrawingOutsideViewBox: true,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                            '${liveclassList![index].startTime} - ${liveclassList![index].endTime} |${DateFormat('d').format(DateTime.fromMillisecondsSinceEpoch(liveclassList![index].fromDate! * 1000))} ${months[int.parse(DateFormat('M').format(DateTime.fromMillisecondsSinceEpoch(liveclassList![index].fromDate! * 1000))) - 1]}',
                                            style: Styles.regular(size: 14)),
                                        Expanded(child: SizedBox()),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: ColorConstants.BG_GREY),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 18),
                                          child: Text(
                                              liveclassList![index]
                                                          .contentType!
                                                          .toLowerCase() ==
                                                      'offlineclass'
                                                  ? "Classroom"
                                                  : "Live",
                                              style: Styles.regular(
                                                  size: 10,
                                                  color: ColorConstants.BLACK)),
                                        ),
                                      ])
                                    : SizedBox(),
                            SizedBox(height: 10),
                            Text('${liveclassList![index].name}',
                                style: Styles.semibold(size: 16)),
                            SizedBox(height: 9),
                            Text(
                              '${liveclassList![index].description}',
                              style: Styles.regular(size: 14),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                liveclassList![index].trainerName != null &&
                                        liveclassList![index].trainerName != ''
                                    ? Text(
                                        'by ${liveclassList![index].trainerName} ',
                                        style: Styles.regular(size: 12))
                                    : Text(''),
                                Expanded(child: SizedBox()),
                                if (liveclassList![index]
                                        .liveclassStatus!
                                        .toLowerCase() ==
                                    'live')
                                  InkWell(
                                      onTap: () {
                                        launch(liveclassList![index].url!);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              ColorConstants().primaryColor(),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                            child: Text(
                                                liveclassList![index]
                                                                .contentType!
                                                                .toLowerCase() ==
                                                            "liveclass" ||
                                                        liveclassList![index]
                                                                .contentType!
                                                                .toLowerCase() ==
                                                            "zoomclass"
                                                    ? "Join Now"
                                                    : "Mark your attendance",
                                                style: Styles.regular(
                                                    size: 12,
                                                    color: ColorConstants()
                                                        .primaryForgroundColor())),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 8)),
                                      )),
                                if (liveclassList![index]
                                        .liveclassStatus!
                                        .toLowerCase() ==
                                    'upcoming')
                                  Text('Upcoming',
                                      style: Styles.regular(size: 12)),
                                Visibility(
                                    child: Padding(
                                        child: Text(
                                          "Concluded",
                                          style: Styles.regular(
                                              size: 12,
                                              color: ColorConstants.BLACK),
                                        ),
                                        padding: EdgeInsets.all(10)),
                                    visible: liveclassList![index]
                                            .liveclassStatus!
                                            .toLowerCase() ==
                                        'completed')
                              ],
                            )
                          ]))
                  : Container(child: Text(""));
            },
            itemCount: liveclassList?.length != 0
                ? liveclassList!.length >= 2
                    ? 2
                    : liveclassList?.length
                : 0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
        ]));
  }

  void _handleJoyContentListResponse(JoyContentListState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isJoyContentListLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("JoyContentListState....................");
          Log.v(state.response!.data!.list.toString());

          joyContentListResponse = state.response!.data!.list;
          joyContentListView = joyContentListResponse;

          isJoyContentListLoading = false;
          break;
        case ApiStatus.ERROR:
          isJoyContentListLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorHome......................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handlePopularFilteredCourses(FilteredPopularCoursesState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isJoyCategoryLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("JoyCategoryState....................");
          Log.v(state.response!.data);

          Log.v("LiveClassState Done ....................${liveclassList}");

          isJoyCategoryLoading = false;
          break;
        case ApiStatus.ERROR:
          isJoyCategoryLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleLiveClassResponse(getLiveClassState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");

          // isJoyCategoryLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("LiveClassState....................");
          Log.v(state.response!.data!.modules!.liveclass.toString());

          liveclassList = state.response!.data!.modules!.liveclass;

          liveclassList = liveclassList
              ?.where((element) =>
                  element.liveclassStatus?.toLowerCase() != 'completed')
              .toList();

          isJoyCategoryLoading = false;
          break;
        case ApiStatus.ERROR:
          isNotLiveclass = true;
          isJoyCategoryLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}
