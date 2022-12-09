import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/joy_contentList_response.dart';
import 'package:masterg/data/providers/video_player_provider.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/ghome/widget/view_widget_details_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
  late VideoPlayerProvider videoPlayerProvider;

  @override
  void initState() {
    _getJoyContentList();

    super.initState();
  }

  void _getJoyContentList() {
    box = Hive.box(DB.CONTENT);

    BlocProvider.of<HomeBloc>(context).add(JoyContentListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: BlocManager(
            initState: (context) {},
            child: Consumer<VideoPlayerProvider>(
              builder: (context, value, child) => BlocManager(
                initState: (context) {
                  videoPlayerProvider = value;
                },
                child: BlocListener<HomeBloc, HomeState>(
                  listener: (context, state) async {
                    if (state is JoyContentListState) {
                      _handleJoyContentListResponse(state);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 17),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 16),
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
                          ValueListenableBuilder(
                              valueListenable: box!.listenable(),
                              builder: (bc, Box box, child) {
                                if (box.get("joyContentListResponse") == null) {
                                  return Shimmer.fromColors(
                                    baseColor: Color(0xffe6e4e6),
                                    highlightColor: Color(0xffeaf0f3),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 20),
                                      width: MediaQuery.of(context).size.width,
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

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      child: Divider(),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star,
                                            color: ColorConstants.YELLOW),
                                        SizedBox(width: 8),
                                        Text('Featured Updates',
                                            style: Styles.bold()),
                                        Expanded(child: SizedBox()),
                                        Text('View all',
                                            style: Styles.regular(
                                              size: 12,
                                              color: ColorConstants.ORANGE_3,
                                            )),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Visibility(
                                        visible: joyContentListView!.length > 0,
                                        child: GridView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: joyContentListView!.length,
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
                                                          0.45,
                                                  crossAxisCount: 2),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: () async {
                                                value.enableProviderControl();
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
                                                              heightFactor: 1.0,
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
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.35,
                                                                width:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                foregroundDecoration:
                                                                    BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                  end:
                                                                      const Alignment(
                                                                          0.0,
                                                                          -1),
                                                                  begin:
                                                                      const Alignment(
                                                                          0.0,
                                                                          0.8),
                                                                  colors: [
                                                                    const Color(
                                                                            0x8A000000)
                                                                        .withOpacity(
                                                                            0.4),
                                                                    Colors
                                                                        .black12
                                                                        .withOpacity(
                                                                            0.0)
                                                                  ],
                                                                )),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl:
                                                                      '${joyContentListView![index].thumbnailUrl}',
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            image:
                                                                                DecorationImage(
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
                                                              .contains('.mp4'))
                                                            Positioned.fill(
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
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
                                                    margin:
                                                        EdgeInsets.only(top: 4),
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
                                                                          size:
                                                                              10,
                                                                          color:
                                                                              ColorConstants.GREY_3)),
                                                                  if (joyContentListView![
                                                                              index]
                                                                          .viewCount! >
                                                                      1)
                                                                    Text(
                                                                        Preference.getInt(Preference.APP_LANGUAGE) == 1
                                                                            ? 's'
                                                                            : '',
                                                                        style: Styles.regular(
                                                                            size:
                                                                                10,
                                                                            color:
                                                                                ColorConstants.GREY_3)),
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
                                                              joyContentListView![
                                                                          index]
                                                                      .title ??
                                                                  '',
                                                              maxLines: 2,
                                                              softWrap: true,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                    ),
                                  ],
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
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
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}
