import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:masterg/pages/auth_pages/select_interest.dart';
import 'package:masterg/pages/custom_pages/card_loader.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../blocs/bloc_manager.dart';
import '../../../../blocs/home_bloc.dart';
import '../../../../data/api/api_service.dart';
import '../../../../data/models/response/home_response/joy_category_response.dart';
import '../../../../data/models/response/home_response/joy_contentList_response.dart';
import '../../../../data/providers/video_player_provider.dart';
import '../../../../local/pref/Preference.dart';
import '../../../../utils/Log.dart';
import '../../../../utils/Strings.dart';
import '../../../../utils/Styles.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/resource/colors.dart';
import '../../../custom_pages/custom_widgets/NextPageRouting.dart';
import '../../../ghome/widget/view_widget_details_page.dart';

late FlickManager customVideoController;
YoutubePlayerController ytController = YoutubePlayerController(
    flags: YoutubePlayerFlags(
      autoPlay: true,
    ),
    initialVideoId: '');

class AlumniVoice extends StatefulWidget {
  const AlumniVoice({Key? key}) : super(key: key);

  @override
  State<AlumniVoice> createState() => _AlumniVoiceState();
}

class _AlumniVoiceState extends State<AlumniVoice> with WidgetsBindingObserver {
  List<JoyContentListElement>? joyContentListResponse;
  List<JoyContentListElement>? joyContentListView;
  Box? box;
  late VideoPlayerProvider videoPlayerProvider;
  bool _isJoyCategoryLoading = true;
  List<ListElement>? joyCategoryList = [];
  int? selectedJoyContentCategoryId = 1;

  @override
  void initState() {
    super.initState();

    getFilters();
    _getJoyContentList();
  }

  void getFilters() {
    BlocProvider.of<HomeBloc>(context).add(JoyCategoryEvent());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      //pause video
      // _videoController.play();

      ytController
        ..mute()
        ..play();
      videoPlayerProvider.mute();

      setState(() {
        customVideoController.flickControlManager?.pause();
        customVideoController.flickControlManager?.mute();
      });

      // ytController.mute();
    }
  }

  void _getJoyContentList() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(JoyContentListEvent());
  }

  //TODO: Get Alumni Content
  void _handleJoyContentListResponse(JoyContentListState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          Log.v("JoyContentListState....................");
          Log.v(state.response!.data!.list.toString());
          joyContentListResponse = state.response!.data!.list;
          joyContentListView = joyContentListResponse;

          break;
        case ApiStatus.ERROR:
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<VideoPlayerProvider>(
            create: (context) => VideoPlayerProvider(true),
          ),
        ],
        child: Consumer<VideoPlayerProvider>(
          builder: (context, value, child) => BlocManager(
            initState: (context) {
              videoPlayerProvider = value;
            },
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                    left: 15.0, top: 5.0, right: 15.0, bottom: 20.0),
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
                                    element.categoryId ==
                                    selectedJoyContentCategoryId)
                                .toList();
                          }
                          if (joyContentListView!.length == 0)
                            return SizedBox(
                              height: height(context) * 0.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/wow_studio_empty.svg',
                                    height: height(context) * 0.15,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'We are setting up personalized network.  You will soon be able to checkout the experiences shared by them.',
                                    textAlign: TextAlign.center,
                                    style: Styles.regular(
                                        size: 14, color: Color(0xff273454)),
                                  )
                                ],
                              ),
                            );

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
                                        mainAxisExtent:
                                            MediaQuery.of(context).size.height *
                                                0.35,
                                        crossAxisCount: 2),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () async {
                                      print('object');
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
                                                    BorderRadius.circular(10)),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.25,
                                                      width:
                                                          MediaQuery.of(context)
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
                                                        end: const Alignment(
                                                            0.0, -1),
                                                        begin: const Alignment(
                                                            0.0, 0.8),
                                                        colors: [
                                                          const Color(
                                                                  0x8A000000)
                                                              .withOpacity(0.4),
                                                          Colors.black12
                                                              .withOpacity(0.0)
                                                        ],
                                                      )),
                                                      child: CachedNetworkImage(
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
                                                            fit: BoxFit.fill,
                                                          )),
                                                        ),
                                                        placeholder:
                                                            (context, url) =>
                                                                Image.asset(
                                                          'assets/images/placeholder.png',
                                                          fit: BoxFit.fill,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
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
                                                if (joyContentListView![index]
                                                    .resourcePath!
                                                    .contains('.mp4'))
                                                  Positioned.fill(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: SvgPicture.asset(
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
                                                                color:
                                                                    ColorConstants
                                                                        .GREY_3)),
                                                        if (joyContentListView![
                                                                    index]
                                                                .viewCount! >
                                                            1)
                                                          Text(
                                                              Preference.getInt(
                                                                          Preference
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
                                                          color: ColorConstants
                                                              .GREY_3)),
                                              // SizedBox(
                                              //   width: 10,
                                              //   height: 4,
                                              // ),
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                    joyContentListView![index]
                                                            .title ??
                                                        '',
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Styles.semibold(
                                                        size: 14,
                                                        color: ColorConstants
                                                            .GREY_1)),
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
                          );
                        }),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ));
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
              int? isParentLanguage =
                  Preference.getInt(Preference.IS_PRIMARY_LANGUAGE);

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

                                if (isParentLanguage == 1) {
                                  isSelected = joyCategoryList![index].id ==
                                      selectedJoyContentCategoryId;
                                } else {
                                  isSelected =
                                      joyCategoryList![index].parentId ==
                                          selectedJoyContentCategoryId;
                                }
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isParentLanguage == 1) {
                                        selectedJoyContentCategoryId =
                                            joyCategoryList![index].id;
                                      } else {
                                        selectedJoyContentCategoryId =
                                            joyCategoryList![index].parentId;
                                      }

                                      if (selectedJoyContentCategoryId == 1) {
                                        joyContentListView =
                                            joyContentListResponse;
                                      } else {
                                        if (isParentLanguage != 1) {
                                          joyContentListView =
                                              joyContentListResponse!
                                                  .where((element) =>
                                                      element.categoryId ==
                                                      joyCategoryList![index]
                                                          .parentId)
                                                  .toList();
                                        } else {
                                          print('inside else ');
                                          joyContentListView =
                                              joyContentListResponse!
                                                  .where((element) =>
                                                      element.categoryId ==
                                                      joyCategoryList![index]
                                                          .id)
                                                  .toList();
                                        }
                                      }

                                      //   ytController = YoutubePlayerController(
                                      //       flags: YoutubePlayerFlags(
                                      //         mute: videoController.isMute,
                                      //         autoPlay: true,
                                      //         loop: true,
                                      //       ),
                                      //       initialVideoId:
                                      //           '${YoutubePlayer.convertUrlToId('${joyCategoryList![index].video}')}');
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
                                                color: ColorConstants.WHITE,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                border: Border.all(
                                                  color:  ColorConstants.GRADIENT_RED.withOpacity(0.3),
                                                  width: 1,
                                                )),
                                            child: Center(
                                                child: ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: <Color>[
                                                ColorConstants.GRADIENT_ORANGE,
                                                ColorConstants.GRADIENT_RED
                                              ]).createShader(bounds);
                                        },
                                        child: Text(
                                                      joyCategoryList![index]
                                                          .title
                                                          .toString(),
                                                      style: Styles.regular(
                                                          size: 12)),
                                                )))
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
                            ))).then((value) {
                          getFilters();
                          _getJoyContentList();
                        });
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
}
