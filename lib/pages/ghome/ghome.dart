// ignore_for_file: unused_field

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/course_category_list_id_response.dart';
import 'package:masterg/data/models/response/home_response/featured_video_response.dart';
import 'package:masterg/data/models/response/home_response/joy_category_response.dart';
import 'package:masterg/data/models/response/home_response/joy_contentList_response.dart';
import 'package:masterg/data/models/response/home_response/program_list_reponse.dart';
import 'package:masterg/data/providers/training_detail_provider.dart';
import 'package:masterg/data/providers/video_player_provider.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/auth_pages/select_interest.dart';
import 'package:masterg/pages/custom_pages/card_loader.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/ghome/video_player_screen.dart';
import 'package:masterg/pages/ghome/widget/view_widget_details_page.dart';
import 'package:masterg/pages/training_pages/training_detail_page.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

late VideoPlayerController _videoController;
YoutubePlayerController ytController = YoutubePlayerController(
    flags: YoutubePlayerFlags(
      autoPlay: true,
    ),
    initialVideoId: '');

class GHome extends StatefulWidget {
  GHome({Key? key}) : super(key: key);

  @override
  State<GHome> createState() => _GHomeState();
}

class _GHomeState extends State<GHome> with WidgetsBindingObserver {
  bool _isJoyCategoryLoading = true;
  bool _isJoyContentListLoading = true;
  bool _isCourseList1Loading = true;
  bool _isCourseList2Loading = true;
  bool _isFeaturedVideoLoading = true;
  bool isProgramListLoading = true;
  List<ListElement>? joyCategoryList = [];
  List<JoyContentListElement>? joyContentListResponse;
  List<JoyContentListElement>? joyContentListView;
  List<ProgramListElement>? programListResponse;
  List<MProgram>? courseList1;
  List<MProgram>? courseList2;
  List<FeaturedVideoElement>? featuredVideoListResponse;
  int? selectedJoyContentCategoryId = 1;
  // FlickManager _flickManager;
  Box? box;

  late VideoPlayerProvider videoPlayerProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _getJoyCategory();
    _getJoyContentList();
    _getCategoryList();
    _getFeaturedVideo();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      //pause video
      // print('video is paused');
      _videoController.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<VideoPlayerProvider>(
            create: (context) => VideoPlayerProvider(true),
          ),
        ],
        child: Consumer<VideoPlayerProvider>(
          builder: (context, value, child) => BlocManager(
            initState: (context) {},
            child: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) async {
                if (state is JoyCategoryState) {
                  _handleJoyCategoryResponse(state);
                }
                if (state is JoyContentListState)
                  _handleJoyContentListResponse(state);
                if (state is ProgramListState) {
                  _handleProgramListResponse(state);
                  _getCourseList(programListResponse![0].id);
                  _getCourse2List(programListResponse![1].id);
                }

                if (state is CourseCategoryListIDState) {
                  _handleCourseList1Response(state);
                }

                if (state is CourseCategoryList2IDState) {
                  _handleCourseList2Response(state);
                }

                if (state is FeaturedVideoState) {
                  _handleFeaturedVideoResponse(state);
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                color: ColorConstants.BG_GREY,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      box!.get("joy_category") != null
                          ? __getJoyCategoryWidget(context, value)
                          : CardLoader(),

                      ValueListenableBuilder(
                          valueListenable: box!.listenable(),
                          builder: (bc, Box box, child) {
                            if (box.get("joyContentListResponse") == null) {
                              return Shimmer.fromColors(
                                baseColor: Color(0xffe6e4e6),
                                highlightColor: Color(0xffeaf0f3),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6)),
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
                                .map((e) => JoyContentListElement.fromJson(
                                    Map<String, dynamic>.from(e)))
                                .cast<JoyContentListElement>()
                                .toList();
                            joyContentListView = joyContentListResponse;

                            if (selectedJoyContentCategoryId != 1) {
                              joyContentListView = joyContentListView
                                  ?.where((element) =>
                                      element.categoryId !=
                                      selectedJoyContentCategoryId)
                                  .toList();
                            }

// return Text('nice ${joyContentListView?.first.categoryId} and $selectedJoyContentCategoryId');
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Visibility(
                                visible: joyContentListView!.length > 0,
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: joyContentListView!.length,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 0,
                                          crossAxisSpacing: 20,
                                          childAspectRatio: 2 / 3,
                                          mainAxisExtent: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.45,
                                          crossAxisCount: 2),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Visibility(
                                      visible: selectedJoyContentCategoryId == 1
                                          ? true
                                          : selectedJoyContentCategoryId ==
                                              joyContentListView![index]
                                                  .categoryId,
                                      child: InkWell(
                                        onTap: () async {
                                          value.enableProviderControl();
                                          value.mute();
                                          value.pause().then((data) =>
                                              showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor:
                                                      ColorConstants.WHITE,
                                                  isScrollControlled: true,
                                                  builder: (context) {
                                                    return FractionallySizedBox(
                                                        heightFactor: 1.0,
                                                        child:
                                                            ViewWidgetDetailsPage(
                                                          joyContentList:
                                                              joyContentListView,
                                                          currentIndex: index,
                                                        ));
                                                  }));
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.35,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          foregroundDecoration:
                                                              BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                            end:
                                                                const Alignment(
                                                                    0.0, -1),
                                                            begin:
                                                                const Alignment(
                                                                    0.0, 0.8),
                                                            colors: [
                                                              const Color(
                                                                      0x8A000000)
                                                                  .withOpacity(
                                                                      0.4),
                                                              Colors.black12
                                                                  .withOpacity(
                                                                      0.0)
                                                            ],
                                                          )),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                '${joyContentListView![index].thumbnailUrl}',
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      image:
                                                                          DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit:
                                                                    BoxFit.fill,
                                                              )),
                                                            ),
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Image.asset(
                                                              'assets/images/placeholder.png',
                                                              fit: BoxFit.fill,
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                              'assets/images/placeholder.png',
                                                              fit: BoxFit.fill,
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
                                                        .contains('.mp4'))
                                                      Positioned.fill(
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/images/play_video_icon.svg',
                                                            height: 30.0,
                                                            width: 30.0,
                                                            allowDrawingOutsideViewBox:
                                                                true,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                )),
                                            Container(
                                              height: 60,
                                              margin: EdgeInsets.only(top: 4),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  joyContentListView![index]
                                                              .viewCount !=
                                                          null
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                                '${joyContentListView![index].viewCount}  ${Strings.of(context)?.Views}',
                                                                style: Styles.regular(
                                                                    size: 10,
                                                                    color: ColorConstants
                                                                        .GREY_3)),
                                                            if (joyContentListView![
                                                                        index]
                                                                    .viewCount! >
                                                                1)
                                                              Text(
                                                                  Preference.getInt(Preference
                                                                              .APP_LANGUAGE) ==
                                                                          1
                                                                      ? 's'
                                                                      : '',
                                                                  style: Styles.regular(
                                                                      size: 10,
                                                                      color: ColorConstants
                                                                          .GREY_3)),
                                                          ],
                                                        )
                                                      : Text(
                                                          '${0}  ${Strings.of(context)?.Views}',
                                                          style: Styles.regular(
                                                              size: 10,
                                                              color:
                                                                  ColorConstants
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
                                                        softWrap: true,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Styles.semibold(
                                                            size: 14,
                                                            color:
                                                                ColorConstants
                                                                    .GREY_1)),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          })

                      //live stream card
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [

                      //       SizedBox(height: 10),

                      //       box != null
                      //           ? ValueListenableBuilder(
                      //               valueListenable: box.listenable(),
                      //               builder: (bc, Box box, child) {
                      //                 if (box.get("joyContentListResponse") == null) {
                      //                   return Shimmer.fromColors(
                      //                     baseColor: Color(0xffe6e4e6),
                      //                     highlightColor: Color(0xffeaf0f3),
                      //                     child: Container(
                      //                       height: MediaQuery.of(context).size.height *
                      //                           0.07,
                      //                       margin: EdgeInsets.symmetric(
                      //                           horizontal: 10, vertical: 20),
                      //                       width: MediaQuery.of(context).size.width,
                      //                       decoration: BoxDecoration(
                      //                           color: Colors.white,
                      //                           borderRadius: BorderRadius.circular(6)),
                      //                     ),
                      //                   );
                      //                 } else if (box
                      //                     .get("joyContentListResponse")
                      //                     .isEmpty) {
                      //                   return Container(
                      //                     height: 290,
                      //                     width: MediaQuery.of(context).size.width,
                      //                     child: Center(
                      //                       child: Text(
                      //                         "There are no libraries available",
                      //                         style: Styles.textBold(),
                      //                       ),
                      //                     ),
                      //                   );
                      //                 }

                      //                 // joyContentListResponse = box
                      //                 //     .get("joyContentListResponse")
                      //                 //     .map((e) => JoyContentListElement.fromJson(
                      //                 //         Map<String, dynamic>.from(e)))
                      //                 //     .cast<JoyContentListElement>()
                      //                 //     .toList();
                      //                 // joyContentListView = joyContentListResponse;

                      //                 return joyContentListView != null
                      //                     ? Visibility(
                      //                         visible: joyContentListView.length > 0,
                      //                         child: GridView.builder(
                      //                           physics: NeverScrollableScrollPhysics(),
                      //                           itemCount: joyContentListView.length > 6
                      //                               ? 6
                      //                               : joyContentListView.length,
                      //                           shrinkWrap: true,
                      //                           gridDelegate:
                      //                               SliverGridDelegateWithFixedCrossAxisCount(
                      //                                   mainAxisSpacing: 30,
                      //                                   crossAxisSpacing: 20,
                      //                                   childAspectRatio: 2 / 3,
                      //                                   crossAxisCount: 2),
                      //                           itemBuilder:
                      //                               (BuildContext context, int index) {
                      //                             return Visibility(
                      //                               visible: selectedJoyContentCategoryId ==
                      //                                       1
                      //                                   ? true
                      //                                   : selectedJoyContentCategoryId ==
                      //                                       joyContentListView[index]
                      //                                           .categoryId,
                      //                               child: InkWell(
                      //                                 onTap: () async {
                      //                                   Navigator.of(context).push(
                      //                                       MaterialPageRoute(
                      //                                           builder: (context) =>
                      //                                               ViewWidgetDetailsPage(
                      //                                                 joyContentList:
                      //                                                     joyContentListView,
                      //                                                 currentIndex:
                      //                                                     index,
                      //                                               )));
                      //                                 },
                      //                                 child: Container(
                      //                                     height: MediaQuery.of(context)
                      //                                             .size
                      //                                             .height *
                      //                                         0.7,
                      //                                     decoration: BoxDecoration(
                      //                                       color: Colors.white,
                      //                                       borderRadius:
                      //                                           BorderRadius.circular(
                      //                                               10),
                      //                                     ),
                      //                                     child: Container(
                      //                                         decoration: BoxDecoration(
                      //                                             borderRadius:
                      //                                                 BorderRadius
                      //                                                     .circular(
                      //                                                         10)),
                      //                                         child: Stack(
                      //                                           children: [
                      //                                             ClipRRect(
                      //                                               borderRadius:
                      //                                                   BorderRadius
                      //                                                       .circular(
                      //                                                           10),
                      //                                               child: Container(
                      //                                                 height: MediaQuery.of(
                      //                                                             context)
                      //                                                         .size
                      //                                                         .height *
                      //                                                     0.7,
                      //                                                 width:
                      //                                                     MediaQuery.of(
                      //                                                             context)
                      //                                                         .size
                      //                                                         .width,
                      //                                                 decoration: BoxDecoration(
                      //                                                     borderRadius:
                      //                                                         BorderRadius
                      //                                                             .circular(
                      //                                                                 10)),
                      //                                                 foregroundDecoration:
                      //                                                     BoxDecoration(
                      //                                                   gradient:
                      //                                                       LinearGradient(
                      //                                                     begin: Alignment
                      //                                                         .topCenter,
                      //                                                     end: Alignment
                      //                                                         .bottomCenter,
                      //                                                     colors: [
                      //                                                       const Color(
                      //                                                           0xCC000000),
                      //                                                       const Color(
                      //                                                           0x00000000),
                      //                                                       const Color(
                      //                                                           0x00000000),
                      //                                                       const Color(
                      //                                                           0xCC000000),
                      //                                                     ],
                      //                                                   ),
                      //                                                 ),
                      //                                                 child: joyContentListView[
                      //                                                             index]
                      //                                                         .resourcePath
                      //                                                         .contains(
                      //                                                             '.mp4')
                      //                                                     ? ShowImage(
                      //                                                         path: joyContentListView[
                      //                                                                 index]
                      //                                                             .resourcePath)
                      //                                                     : Image
                      //                                                         .network(
                      //                                                         '${joyContentListView[index].resourcePath}',
                      //                                                         fit: BoxFit
                      //                                                             .fill,
                      //                                                       ),
                      //                                               ),
                      //                                             ),
                      //                                             /*Positioned(
                      //                                                 child: joyContentListView[index].contentType == '2'
                      //                                                     ? Container(
                      //                                                         decoration:
                      //                                                             BoxDecoration(
                      //                                                           color: ColorConstants
                      //                                                               .BLACK
                      //                                                               .withOpacity(0.4),
                      //                                                           borderRadius:
                      //                                                               BorderRadius.circular(20),
                      //                                                         ),
                      //                                                         child:
                      //                                                             Padding(
                      //                                                           padding: const EdgeInsets.symmetric(
                      //                                                               vertical: 5.0,
                      //                                                               horizontal: 10),
                      //                                                           child:
                      //                                                               Column(
                      //                                                             children: [
                      //                                                               Icon(
                      //                                                                 CupertinoIcons.photo_on_rectangle,
                      //                                                                 color: ColorConstants.WHITE,
                      //                                                                 size: 16,
                      //                                                               ),
                      //                                                               Text(
                      //                                                                 joyContentListView[index].multiFileUploadsCount ?? '0',
                      //                                                                 style: Styles.textRegular(size: 10, color: ColorConstants.WHITE),
                      //                                                               )
                      //                                                             ],
                      //                                                           ),
                      //                                                         ))
                      //                                                     : Container(
                      //                                                         decoration:
                      //                                                             BoxDecoration(
                      //                                                           color: ColorConstants
                      //                                                               .BLACK
                      //                                                               .withOpacity(0.4),
                      //                                                           borderRadius:
                      //                                                               BorderRadius.circular(20),
                      //                                                         ),
                      //                                                         child:
                      //                                                             Padding(
                      //                                                           padding: const EdgeInsets.symmetric(
                      //                                                               vertical:
                      //                                                                   6,
                      //                                                               horizontal:
                      //                                                                   8),
                      //                                                           child:
                      //                                                               Row(
                      //                                                             children: [
                      //                                                               Icon(
                      //                                                                 CupertinoIcons.play_circle_fill,
                      //                                                                 color: ColorConstants.WHITE,
                      //                                                                 size: 16,
                      //                                                               ),
                      //                                                               SizedBox(width: 10),
                      //                                                               Text('00:30',
                      //                                                                   style: Styles.textRegular(size: 8, color: ColorConstants.WHITE))
                      //                                                             ],
                      //                                                           ),
                      //                                                         )),
                      //                                                 top: 10,
                      //                                                 right: 10),*/
                      //                                             Positioned(
                      //                                                 child: Padding(
                      //                                                   padding:
                      //                                                       const EdgeInsets
                      //                                                               .only(
                      //                                                           left:
                      //                                                               5),
                      //                                                   child: Column(
                      //                                                     crossAxisAlignment:
                      //                                                         CrossAxisAlignment
                      //                                                             .start,
                      //                                                     children: [
                      //                                                       SizedBox(
                      //                                                         width:
                      //                                                             150,
                      //                                                         child: Text(
                      //                                                             joyContentListView[index].title ??
                      //                                                                 '',
                      //                                                             style: Styles.textBold(
                      //                                                                 size: 12,
                      //                                                                 color: ColorConstants.WHITE)),
                      //                                                       ),
                      //                                                       SizedBox(
                      //                                                           width:
                      //                                                               10),
                      //                                                       Text(
                      //                                                           'Annie Richard',
                      //                                                           style: Styles.textRegular(
                      //                                                               color:
                      //                                                                   ColorConstants.WHITE)),
                      //                                                     ],
                      //                                                   ),
                      //                                                 ),
                      //                                                 left: 0,
                      //                                                 bottom: 10),
                      //                                           ],
                      //                                         ))),
                      //                               ),
                      //                             );
                      //                           },
                      //                         ),
                      //                       )
                      //                     : Shimmer.fromColors(
                      //                         baseColor: Color(0xffe6e4e6),
                      //                         highlightColor: Color(0xffeaf0f3),
                      //                         child: GridView.builder(
                      //                           shrinkWrap: true,
                      //                           physics: NeverScrollableScrollPhysics(),
                      //                           itemCount: 4,
                      //                           gridDelegate:
                      //                               SliverGridDelegateWithFixedCrossAxisCount(
                      //                                   mainAxisSpacing: 0,
                      //                                   crossAxisSpacing: 10,
                      //                                   childAspectRatio: 2 / 3,
                      //                                   crossAxisCount: 2),
                      //                           itemBuilder:
                      //                               (BuildContext context, int index) {
                      //                             return Container(
                      //                               height: MediaQuery.of(context)
                      //                                       .size
                      //                                       .height *
                      //                                   0.5,
                      //                               margin: EdgeInsets.symmetric(
                      //                                   horizontal: 10, vertical: 20),
                      //                               width: MediaQuery.of(context)
                      //                                   .size
                      //                                   .width,
                      //                               decoration: BoxDecoration(
                      //                                   color: Colors.white,
                      //                                   borderRadius:
                      //                                       BorderRadius.circular(6)),
                      //                             );
                      //                           },
                      //                         ),
                      //                       );
                      //               },
                      //             )
                      //           : Shimmer.fromColors(
                      //               baseColor: Color(0xffe6e4e6),
                      //               highlightColor: Color(0xffeaf0f3),
                      //               child: Container(
                      //                 height: MediaQuery.of(context).size.height * 0.07,
                      //                 margin: EdgeInsets.symmetric(
                      //                     horizontal: 10, vertical: 20),
                      //                 width: MediaQuery.of(context).size.width,
                      //                 decoration: BoxDecoration(
                      //                     color: Colors.white,
                      //                     borderRadius: BorderRadius.circular(6)),
                      //               ),
                      //             ),

                      //       SizedBox(height: 20),

                      //       // !_isCourseList1Loading && courseList1 != null
                      //       //     ? _getCourseWidget(courseList1)
                      //       //     : SizedBox(),

                      //       !_isFeaturedVideoLoading &&
                      //               featuredVideoListResponse != null
                      //           ? getFeaturedVideoWidget(featuredVideoListResponse)
                      //           : Shimmer.fromColors(
                      //               baseColor: Color(0xffe6e4e6),
                      //               highlightColor: Color(0xffeaf0f3),
                      //               child: Container(
                      //                 height: MediaQuery.of(context).size.height * 0.55,
                      //                 margin: EdgeInsets.symmetric(
                      //                     horizontal: 10, vertical: 20),
                      //                 width: MediaQuery.of(context).size.width,
                      //                 decoration: BoxDecoration(
                      //                     color: Colors.white,
                      //                     borderRadius: BorderRadius.circular(6)),
                      //               ),
                      //             ),
                      ,
                      SizedBox(height: 10),
                      // joyContentListView != null
                      //     ? Visibility(
                      //         visible: true,
                      //         child: GridView.builder(
                      //           shrinkWrap: true,
                      //           physics: NeverScrollableScrollPhysics(),
                      //           itemCount: joyContentListView.length ,
                      //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //               mainAxisSpacing: 30,
                      //               crossAxisSpacing: 20,
                      //               childAspectRatio: 2 / 3,
                      //               crossAxisCount: 2),
                      //           itemBuilder: (BuildContext context, int index) {
                      //             return InkWell(
                      //               onTap: () async {
                      //                 Navigator.of(context).push(MaterialPageRoute(
                      //                     builder: (context) => ViewWidgetDetailsPage(
                      //                           joyContentList: joyContentListView,
                      //                           currentIndex: index,
                      //                         )));
                      //               },
                      //               child: Container(
                      //                   height:
                      //                       MediaQuery.of(context).size.height * 0.7,
                      //                   decoration: BoxDecoration(
                      //                     color: Colors.white,
                      //                     borderRadius: BorderRadius.circular(10),
                      //                   ),
                      //                   child: Container(
                      //                       decoration: BoxDecoration(
                      //                           borderRadius:
                      //                               BorderRadius.circular(10)),
                      //                       child: Stack(
                      //                         children: [
                      //                           ClipRRect(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(10),
                      //                             child: Container(
                      //                               height: MediaQuery.of(context)
                      //                                       .size
                      //                                       .height *
                      //                                   0.7,
                      //                               width: MediaQuery.of(context)
                      //                                   .size
                      //                                   .width,
                      //                               decoration: BoxDecoration(
                      //                                   borderRadius:
                      //                                       BorderRadius.circular(10)),
                      //                               foregroundDecoration: BoxDecoration(
                      //                                 gradient: LinearGradient(
                      //                                   begin: Alignment.topCenter,
                      //                                   end: Alignment.bottomCenter,
                      //                                   colors: [
                      //                                     const Color(0xCC000000),
                      //                                     const Color(0x00000000),
                      //                                     const Color(0x00000000),
                      //                                     const Color(0xCC000000),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                               child: joyContentListView[index]
                      //                                       .resourcePath
                      //                                       .contains('.mp4')
                      //                                   ? ShowImage(
                      //                                       path: joyContentListView[
                      //                                               index]
                      //                                           .resourcePath)
                      //                                   : Image.network(
                      //                                       '${joyContentListView[index].thumbnailUrl ?? joyContentListView[index].resourcePath}',
                      //                                       fit: BoxFit.cover,
                      //                                     ),
                      //                             ),
                      //                           ),

                      /*Positioned(
                                                      child: joyContentListView[
                                                                      index]
                                                                  .contentType ==
                                                              '2'
                                                          ? Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: ColorConstants
                                                                    .BLACK
                                                                    .withOpacity(
                                                                        0.4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            5.0,
                                                                        horizontal:
                                                                            10),
                                                                child: Column(
                                                                  children: [
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .photo_on_rectangle,
                                                                      color:
                                                                          ColorConstants
                                                                              .WHITE,
                                                                      size: 16,
                                                                    ),
                                                                    Text(
                                                                      joyContentListView[
                                                                                  index]
                                                                              .multiFileUploadsCount ??
                                                                          '0',
                                                                      style: Styles
                                                                          .textRegular(
                                                                              size:
                                                                                  10,
                                                                              color:
                                                                                  ColorConstants.WHITE),
                                                                    )
                                                                  ],
                                                                ),
                                                              ))
                                                          : Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: ColorConstants
                                                                    .BLACK
                                                                    .withOpacity(
                                                                        0.4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        vertical: 6,
                                                                        horizontal:
                                                                            8),
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .play_circle_fill,
                                                                      color:
                                                                          ColorConstants
                                                                              .WHITE,
                                                                      size: 16,
                                                                    ),
                                                                    SizedBox(
                                                                        width: 10),
                                                                    Text('00:30',
                                                                        style: Styles.textRegular(
                                                                            size: 8,
                                                                            color: ColorConstants
                                                                                .WHITE))
                                                                  ],
                                                                ),
                                                              )),
                                                      top: 10,
                                                      right: 10),*/
                      //                       Positioned(
                      //                           child: Padding(
                      //                             padding: const EdgeInsets.only(
                      //                                 left: 5),
                      //                             child: Column(
                      //                               crossAxisAlignment:
                      //                                   CrossAxisAlignment.start,
                      //                               children: [
                      //                                 SizedBox(
                      //                                   width: 150,
                      //                                   child: Text(
                      //                                       joyContentListView[
                      //                                                   index + 6]
                      //                                               .resourcePath ??
                      //                                           '',
                      //                                       style: Styles.textBold(
                      //                                           size: 12,
                      //                                           color:
                      //                                               ColorConstants
                      //                                                   .WHITE)),
                      //                                 ),
                      //                                 SizedBox(width: 10),
                      //                                 // Text('Annie Richard',
                      //                                 //     style: Styles.textRegular(
                      //                                 //         color: ColorConstants
                      //                                 //             .WHITE)),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                           left: 0,
                      //                           bottom: 10),
                      //                     ],
                      //                   ))),
                      //         );
                      //       },
                      //     ),
                      //   )
                      // : SizedBox()
                      //           : Shimmer.fromColors(
                      //               baseColor: Color(0xffe6e4e6),
                      //               highlightColor: Color(0xffeaf0f3),
                      //               child: GridView.builder(
                      //                 shrinkWrap: true,
                      //                 physics: NeverScrollableScrollPhysics(),
                      //                 itemCount: 6,
                      //                 gridDelegate:
                      //                     SliverGridDelegateWithFixedCrossAxisCount(
                      //                         mainAxisSpacing: 30,
                      //                         crossAxisSpacing: 20,
                      //                         childAspectRatio: 2 / 3,
                      //                         crossAxisCount: 2),
                      //                 itemBuilder: (BuildContext context, int index) {
                      //                   return Container(
                      //                     height:
                      //                         MediaQuery.of(context).size.height * 0.5,
                      //                     margin: EdgeInsets.symmetric(
                      //                         horizontal: 10, vertical: 20),
                      //                     width: MediaQuery.of(context).size.width,
                      //                     decoration: BoxDecoration(
                      //                         color: Colors.white,
                      //                         borderRadius: BorderRadius.circular(6)),
                      //                   );
                      //                 },
                      //               ),
                      //             ),
                      //       // : Shimmer.fromColors(
                      //       //     baseColor: Color(0xffe6e4e6),
                      //       //     highlightColor: Color(0xffeaf0f3),
                      //       //     child: Container(
                      //       //       height: MediaQuery.of(context).size.height * 0.5,
                      //       //       margin: EdgeInsets.symmetric(
                      //       //           horizontal: 10, vertical: 20),
                      //       //       width: MediaQuery.of(context).size.width,
                      //       //       decoration: BoxDecoration(
                      //       //           color: Colors.white,
                      //       //           borderRadius: BorderRadius.circular(6)),
                      //       //     ),
                      //       //   ),

                      //       //getProductWidgets(),
                      //       // courseList2 != null
                      //       //     ? getCourse2Widget(courseList2)
                      //       //     : SizedBox(),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void _getJoyCategory() async {
    box = Hive.box(DB.CONTENT);
    if (box!.get('joyCategory') == null)
      BlocProvider.of<HomeBloc>(context).add(JoyCategoryEvent());
  }

  void _getJoyContentList() {
    box = Hive.box(DB.CONTENT);

    BlocProvider.of<HomeBloc>(context).add(JoyContentListEvent());
  }

  void _getCategoryList() async {
    box = Hive.box(DB.CONTENT);

    BlocProvider.of<HomeBloc>(context).add(ProgramListEvent());
  }

  void _getCourseList(int? id) {
    box = Hive.box(DB.CONTENT);

    BlocProvider.of<HomeBloc>(context)
        .add(CourseCategoryListIDEvent(categoryId: id));
  }

  void _getCourse2List(int? id) {
    box = Hive.box(DB.CONTENT);

    BlocProvider.of<HomeBloc>(context)
        .add(CourseCategoryList2IDEvent(categoryId: id));
  }

  void _getFeaturedVideo() {
    box = Hive.box(DB.CONTENT);

    BlocProvider.of<HomeBloc>(context).add(FeaturedVideoEvent());
  }

  void _handleJoyCategoryResponse(JoyCategoryState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isJoyCategoryLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("JoyCategoryState....................");
          Log.v(state.response!.data!.list.toString());

          for (int i = 0; i < state.response!.data!.list!.length; i++) {
            if (state.response!.data!.list![i].isSelected == 1) {
              print(state.response!.data!.list![i].isSelected);
              joyCategoryList!.add(state.response!.data!.list![i]);
            }
          }

          //joyCategoryList = state.response.data.list;

          // box.put('joy_category',
          //     state.response.data.list.map((e) => e.toJson()).toList());
          Log.v("JoyCategoryState Done ....................");

          _isJoyCategoryLoading = false;
          break;
        case ApiStatus.ERROR:
          _isJoyCategoryLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleJoyContentListResponse(JoyContentListState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isJoyContentListLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("JoyContentListState....................");
          Log.v(state.response!.data!.list.toString());

          joyContentListResponse = state.response!.data!.list;
          joyContentListView = joyContentListResponse;

          _isJoyContentListLoading = false;
          break;
        case ApiStatus.ERROR:
          _isJoyContentListLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleProgramListResponse(ProgramListState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isProgramListLoading = true;

          break;
        case ApiStatus.SUCCESS:
          Log.v("CourseCategoryState....................");

          programListResponse = state.response!.data!.list;

          isProgramListLoading = false;

          break;
        case ApiStatus.ERROR:
          isProgramListLoading = false;

          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleCourseList1Response(CourseCategoryListIDState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isCourseList1Loading = true;

          break;
        case ApiStatus.SUCCESS:
          Log.v("CourseCategoryState....................");
          // courseCategoryList.add(state.response.data.);

          courseList1 = state.response!.data!.programs;
          _isCourseList1Loading = false;

          break;
        case ApiStatus.ERROR:
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");

          _isCourseList1Loading = false;

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleCourseList2Response(CourseCategoryList2IDState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isCourseList2Loading = true;

          break;
        case ApiStatus.SUCCESS:
          Log.v("CourseCategoryState....................");

          courseList2 = state.response!.data!.programs;
          _isCourseList2Loading = false;

          break;
        case ApiStatus.ERROR:
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");

          _isCourseList2Loading = false;

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleFeaturedVideoResponse(FeaturedVideoState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isFeaturedVideoLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("CourseCategoryState....................");
          // courseCategoryList.add(state.response.data.);
          if (_isFeaturedVideoLoading) {
            //implement course list 1
          }
          featuredVideoListResponse = state.response!.data!.list;
          _isFeaturedVideoLoading = false;

          break;
        case ApiStatus.ERROR:
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          _isFeaturedVideoLoading = true;

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);

  Widget __getJoyCategoryWidget(context, VideoPlayerProvider videoController) {
    return box != null
        ? ValueListenableBuilder(
            valueListenable: box!.listenable(),
            builder: (bc, Box box, child) {
              if (box.get("joy_category") == null) {
                return Shimmer.fromColors(
                  baseColor: Color(0xffe6e4e6),
                  highlightColor: Color(0xffeaf0f3),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                  ),
                );
              } else if (box.get("joy_category").isEmpty) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "${Strings.of(context)?.CategoryNotFound}",
                      style: Styles.regular(),
                    ),
                  ),
                );
              }

              joyCategoryList = box
                  .get("joy_category")
                  .map(
                      (e) => ListElement.fromJson(Map<String, dynamic>.from(e)))
                  .cast<ListElement>()
                  .toList();
              joyCategoryList!.insert(
                  0,
                  ListElement(
                    id: 1,
                    title: '${Strings.of(context)?.forYou}',
                    description: '${Strings.of(context)?.forYou}',
                    createdAt: 1647343211,
                    updatedAt: 1647343211,
                    createdBy: 0,
                    updatedBy: 0,
                    status: 'Active',
                    sectionType: 3,
                    isSelected: 1,
                    parentId: 1,
                    video: Preference.getString(
                        Preference.DEFAULT_VIDEO_URL_CATEGORY),
                    image:
                        "https://qa.learningoxygen.com/joy_content/do-100-erase-or-removal-your-photo-or-imagage-bacground-627f.jpeg",
                  ));

              List<ListElement> temp = [];

              for (int i = 0; i < joyCategoryList!.length; i++) {
                if (joyCategoryList![i].isSelected == 1) {
                  print(joyCategoryList![i].isSelected);
                  temp.add(joyCategoryList![i]);
                }
              }
              joyCategoryList = temp;
              bool? isParentLanguage =
                  Preference.getBool(Preference.IS_PRIMARY_LANGUAGE);

              return Column(children: [
                Row(
                  children: [
                    Container(
                      ///height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.8,
                      //width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(right: 17.0, top: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.13,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                bool isSelected = false;
                                if (isParentLanguage == true) {
                                  isSelected = joyCategoryList![index].id ==
                                      selectedJoyContentCategoryId;
                                } else {
                                  isSelected = joyCategoryList![index].parentId ==
                                      selectedJoyContentCategoryId;
                                }
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      controller.jumpToPage(index);
                                      if (isParentLanguage == true) {
                                        selectedJoyContentCategoryId =
                                            joyCategoryList![index].id;
                                      } else {
                                        selectedJoyContentCategoryId =
                                            joyCategoryList![index].parentId;
                                      }

                                      print(
                                          'selected id is $selectedJoyContentCategoryId');

                                      if (selectedJoyContentCategoryId == 1) {
                                        joyContentListView =
                                            joyContentListResponse;
                                        print(
                                            'the list size is ${joyContentListView?.length}');
                                      } else {
                                        if (isParentLanguage == true) {
                                          joyContentListView =
                                              joyContentListResponse!
                                                  .where((element) =>
                                                      element.categoryId ==
                                                      joyCategoryList![index]
                                                          .id)
                                                  .toList();
                                        } else {
                                          joyContentListView =
                                              joyContentListResponse!
                                                  .where((element) =>
                                                      element.categoryId ==
                                                      joyCategoryList![index]
                                                          .parentId)
                                                  .toList();
                                                  
                                                  print('view lis len is ${joyContentListView?.length}');
                                        print(
                                            'the list id is  ${joyContentListResponse?.first.categoryId} and ${joyCategoryList![index]
                                                          .parentId}');
                                        }

                                      }

                                      ytController = YoutubePlayerController(
                                          flags: YoutubePlayerFlags(
                                            mute: videoController.isMute,
                                            autoPlay: true,
                                            loop: true,
                                          ),
                                          initialVideoId:
                                              '${YoutubePlayer.convertUrlToId('${joyCategoryList![index].video}')}');
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10),
                                    child: isSelected
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 0),
                                            decoration: BoxDecoration(
                                                color: ColorConstants.PILL_BG,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                border: Border.all(
                                                  color: Colors.orange,
                                                  width: 1,
                                                )),
                                            child: Center(
                                                child: Text(
                                                    joyCategoryList![index]
                                                        .title
                                                        .toString(),
                                                    style: Styles.regular(
                                                        size: 12))))
                                        : Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: ColorConstants.WHITE,
                                            ),
                                            child: Center(
                                                child: Text(
                                                    joyCategoryList![index]
                                                        .title
                                                        .toString(),
                                                    style: Styles.regular(
                                                        size: 12)))),
                                  ),
                                );
                              },
                              itemCount: joyCategoryList!.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            NextPageRoute(InterestPage(
                              backEnable: true,
                            )));
                      },
                      child: Container(
                        //color: Colors.red,
                        height: MediaQuery.of(context).size.height * 0.07,
                        margin: EdgeInsets.only(left: 0.0),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            size: 20,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.28,
                  decoration: BoxDecoration(
                    color: ColorConstants.WHITE,
                    border: Border.all(color: ColorConstants.GREY_4, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: double.infinity,
                  child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      itemCount: joyCategoryList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (ytController.initialVideoId == '')
                          ytController = YoutubePlayerController(
                              flags: YoutubePlayerFlags(
                                mute: true,
                                autoPlay: true,
                                loop: true,
                              ),
                              initialVideoId:
                                  '${YoutubePlayer.convertUrlToId('${joyCategoryList![index].video}')}');
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.99,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: !joyCategoryList![index]
                                          .video
                                          .toString()
                                          .contains('www.youtube.com')
                                      ? CustomVideoPlayer(
                                          url:
                                              '${joyCategoryList![index].video}',
                                          autoPlay: true,
                                          showPlayButton: true,
                                        )
                                      : VisibilityDetector(
                                          key: ObjectKey(ytController),
                                          onVisibilityChanged: (visibility) {
                                            var visiblePercentage =
                                                visibility.visibleFraction *
                                                    100;
                                            if (visibility.visibleFraction ==
                                                    0 &&
                                                this.mounted) {
                                              if (visiblePercentage.round() <=
                                                      70 &&
                                                  this.mounted) {
                                                //pause
                                                ytController.pause();
                                              } else {
                                                //pause
                                                ytController.pause();

                                                if (this.mounted)

                                                  //play
                                                  ytController.play();
                                              }
                                            }
                                          },
                                          child: YoutubePlayer(
                                            controller: ytController,
                                            showVideoProgressIndicator: false,
                                            bottomActions: [
                                              Expanded(child: SizedBox()),
                                              GestureDetector(
                                                onTap: () {
                                                  if (!videoController.isMute) {
                                                    ytController.mute();
                                                    videoController.mute();
                                                  } else {
                                                    ytController.unMute();
                                                    videoController.unMute();
                                                  }
                                                  setState(() {});
                                                },
                                                child: videoController.isMute !=
                                                        true
                                                    ? Icon(Icons.volume_up,
                                                        color: ColorConstants
                                                            .WHITE)
                                                    : Icon(
                                                        Icons
                                                            .volume_off_outlined,
                                                        color: ColorConstants
                                                            .WHITE),
                                              )
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            ]);
                      }),
                ),
              ]);
            },
          )
        : Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
            ),
          );
  }

  Widget getFeaturedVideoWidget(videoList) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.33,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: videoList.length,
            itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.92,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.white,
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  '${videoList[index].thumbnailUrl}'),
                                              fit: BoxFit.cover),
                                        ),
                                        foregroundDecoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              const Color(0x00000000)
                                                  .withOpacity(0.0),
                                              const Color(0xCC000000)
                                                  .withOpacity(0.4),
                                            ],
                                            stops: [0.2, 1],
                                          ),
                                        ),
                                        child: CustomVideoPlayer(
                                            url:
                                                '${videoList[index].resourcePath}')),
                                  ),
                                  Positioned(
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text('Featured',
                                              style: Styles.textBold(
                                                  size: 12,
                                                  color:
                                                      ColorConstants.WHITE))),
                                      top: 10,
                                      left: 10),
                                  /*Positioned(
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.play_circle_filled,
                                                color: ColorConstants.WHITE,
                                                size: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text('${Strings.of(context)?.liveNow}',
                                                  style: Styles.textBold(
                                                      size: 12,
                                                      color: ColorConstants
                                                          .WHITE)),
                                            ],
                                          )),
                                      top: 10,
                                      right: 10),*/
                                  Positioned(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${videoList[index].title}',
                                                style: Styles.textBold(
                                                    color:
                                                        ColorConstants.WHITE)),
                                            Text(
                                                '${videoList[index].description}',
                                                style: Styles.regularWhite())
                                          ],
                                        ),
                                      ),
                                      bottom: 10,
                                      left: 10),
                                ],
                              )),
                        ]),
                  ),
                )));
  }

  Widget getProductWidgets() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) => Container(
          width: MediaQuery.of(context).size.width * 0.55,
          padding: EdgeInsets.only(left: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    index == 1
                        ? 'https://static-bebeautiful-in.unileverservices.com/1200/900/how-to-keep-beauty-products-safe_mobhome.jpg'
                        : 'https://learningoxygen.com/joy_content/beauty%20product%20.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(index == 1 ? 'Skin Care' : 'Beauty Packaging',
                                style: Styles.textRegular()),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Text(
                                  index == 1
                                      ? 'Skin Care Combo Product'
                                      : 'Trending Beauty Product',
                                  style: Styles.textBold(size: 16)),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: '₹ 199',
                                      style: Styles.textBold(
                                          color: ColorConstants.GREEN)),
                                  TextSpan(
                                      text: '   +250 GPoints',
                                      style: Styles.textRegular(
                                          color: ColorConstants.BLACK)),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'MRP ', style: Styles.textBold()),
                                  TextSpan(
                                      text: '₹499',
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                      )),
                                  TextSpan(
                                      text: ' 50% off',
                                      style: Styles.textBold(
                                          color: ColorConstants.GREEN)),
                                ],
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ]),
        ),
      ),
    );
  }

  Widget getCourse2Widget(courseList) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.33,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: courseList.length,
            itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            NextPageRoute(
                                ChangeNotifierProvider<TrainingDetailProvider>(
                                    create: (context) => TrainingDetailProvider(
                                        TrainingService(ApiService()),
                                        courseList[index]),
                                    child: TrainingDetailPage())));
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white,
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    '${courseList[index].image}'),
                                                fit: BoxFit.cover),
                                          ),
                                          foregroundDecoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                const Color(0x00000000)
                                                    .withOpacity(0.0),
                                                const Color(0xCC000000),
                                              ],
                                              stops: [0.2, 1],
                                            ),
                                          ),
                                          child: null),
                                    ),
                                    Positioned(
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('${courseList[index].name}',
                                                  style: Styles.textBold(
                                                      size: 18,
                                                      color: ColorConstants
                                                          .WHITE)),
                                              Text('@ Just',
                                                  style: Styles.boldWhite()),
                                              Divider(
                                                color: ColorConstants.WHITE,
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            '₹${courseList[index].regularPrice}',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: ColorConstants
                                                              .WHITE,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        )),
                                                    TextSpan(
                                                      text:
                                                          ' ₹${courseList[index].salePrice}',
                                                      style:
                                                          Styles.textExtraBold(
                                                        size: 26,
                                                        color: ColorConstants
                                                            .WHITE,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: ColorConstants.WHITE,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                  ),
                                                  child: Text(
                                                      'Limited Offer. Hurry!!!',
                                                      style: Styles.textBold(
                                                          color: ColorConstants
                                                              .DARK_BLUE))),
                                            ],
                                          ),
                                        ),
                                        bottom: 10,
                                        left: 10),
                                  ],
                                )),
                          ])),
                )));
  }
}

class ShowImage extends StatefulWidget {
  final String? path;
  ShowImage({Key? key, this.path}) : super(key: key);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  Uint8List? imageFile;
  @override
  void initState() {
    super.initState();
    getFile();
  }

  Future<Uint8List?> getFile() async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: widget.path!,
      imageFormat: ImageFormat.PNG,
      quality: 10,
    );
    setState(() {
      imageFile = uint8list;
    });
    return uint8list;
  }

  @override
  Widget build(BuildContext context) {
    return imageFile != null
        ? Image.memory(
            imageFile!,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          )
        : SizedBox();
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String? videoUrl;

  VideoPlayerItem({
    Key? key,
    required this.size,
    this.videoUrl,
  }) : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  bool isShowPlaying = false;

  @override
  void initState() {
    super.initState();

    //assets/videos/video_1.mp4
    print('===========>>widget.videoUrl111');
    print(widget.videoUrl!.trim());

    _videoController = VideoPlayerController.network(widget.videoUrl!);

    _videoController.setLooping(true);
    _videoController.initialize().then((_) => setState(() {
          setState(() {
            isShowPlaying = true;
            _videoController.play();
            _videoController.setVolume(0);
          });
          // _videoController.play();
        }));
  }

  @override
  void dispose() {
    super.dispose();
    // _videoController.dispose();
  }

  Widget isPlaying() {
    return _videoController.value.isPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          setState(() {
            _videoController.value.isPlaying
                ? _videoController.pause()
                : _videoController.play();
          });
        },
        child: Container(
            height: widget.size.height,
            width: widget.size.width,
            child: Container(
              height: widget.size.height,
              width: widget.size.width,
              decoration: BoxDecoration(color: Colors.black),
              child: Stack(
                children: <Widget>[
                  isShowPlaying
                      ? VideoPlayer(_videoController)
                      : ShowImage(path: widget.videoUrl),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(),
                      child: isPlaying(),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}

// class VideoPlayerScreen extends StatefulWidget {
//   final int? index;
//   final context;
//   VideoPlayerScreen({Key? key, this.index, this.context}) : super(key: key);

//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   VideoPlayerController? _controller;
//   Future<void>? _initializeVideoPlayerFuture;
//   int? _playBackTime;

//   //The values that are passed when changing quality
//   late Duration newCurrentPosition;

//   String defaultStream =
//       'https://archive.org/download/Damas_BB_28F8B535_D_406/DaMaS.mp4';
//   String stream2 = 'https://archive.org/download/cCloud_20151126/cCloud.mp4';
//   String stream3 = 'https://archive.org/download/mblbhs/mblbhs.mp4';

//   @override
//   void initState() {
//     print('init is called with index ${widget.index}');
//     _controller = VideoPlayerController.network(defaultStream);
//     _controller!.addListener(() {
//       setState(() {
//         _playBackTime = _controller!.value.position.inSeconds;
//       });
//     });
//     _initializeVideoPlayerFuture = _controller!.initialize();
//      _videoController.play();
//         _videoController.setVolume(0);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _initializeVideoPlayerFuture = null;
//     _controller?.pause().then((_) {
//       _controller!.dispose();
//     });
//     super.dispose();
//   }

//   Future<bool> _clearPrevious() async {
//     await _controller?.pause();
//     return true;
//   }

//   Future<void> _initializePlay(String videoPath) async {
//     _controller = VideoPlayerController.network(videoPath);
//     _controller!.addListener(() {
//       setState(() {
//         _playBackTime = _controller!.value.position.inSeconds;
//       });
//     });
//     _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
//       _controller!.seekTo(newCurrentPosition);
//       _controller!.play();
//     });
//   }

//   void _getValuesAndPlay(String videoPath) {
//     newCurrentPosition = _controller!.value.position;
//     _startPlay(videoPath);
//     print(newCurrentPosition.toString());
//   }

//   Future<void> _startPlay(String videoPath) async {
//     setState(() {
//       _initializeVideoPlayerFuture = null;
//     });
//     Future.delayed(const Duration(milliseconds: 200), () {
//       _clearPrevious().then((_) {
//         _initializePlay(videoPath);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Column(children: [
//             Center(
//               child: AspectRatio(
//                 aspectRatio: _controller!.value.aspectRatio,
//                 // Use the VideoPlayer widget to display the video.
//                 child: VideoPlayer(_controller!),
//               ),
//             ),
//             Container(
//               color: Colors.black54,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Container(
//                     child: FloatingActionButton(
//                       onPressed: () {
//                         // Wrap the play or pause in a call to `setState`. This ensures the
//                         // correct icon is shown.
//                         setState(() {
//                           // If the video is playing, pause it.
//                           if (_controller!.value.isPlaying) {
//                             _controller!.pause();
//                           } else {
//                             // If the video is paused, play it.
//                             _controller!.play();
//                           }
//                         });
//                       },
//                       // Display the correct icon depending on the state of the player.
//                       child: Icon(
//                         _controller!.value.isPlaying
//                             ? Icons.pause
//                             : Icons.play_arrow,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: Text(
//                       _controller!.value.position
//                           .toString()
//                           .split('.')
//                           .first
//                           .padLeft(8, "0"),
//                     ),
//                   ),
//                   Container(
//                     child: TextButton(
//                       onPressed: () {
//                         _getValuesAndPlay(defaultStream);
//                       },
//                       child: Text('Default Stream'),
//                     ),
//                   ),
//                   Container(
//                     child: TextButton(
//                       onPressed: () {
//                         _getValuesAndPlay(stream2);
//                       },
//                       child: Text('Video Stream 2'),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ]);
//         } else {
//           // If the VideoPlayerController is still initializing, show a
//           // loading spinner.
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }
