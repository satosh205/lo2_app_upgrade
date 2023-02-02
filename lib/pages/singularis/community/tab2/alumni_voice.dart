import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../blocs/bloc_manager.dart';
import '../../../../blocs/home_bloc.dart';
import '../../../../data/api/api_service.dart';
import '../../../../data/models/response/home_response/joy_contentList_response.dart';
import '../../../../data/providers/video_player_provider.dart';
import '../../../../local/pref/Preference.dart';
import '../../../../utils/Log.dart';
import '../../../../utils/Strings.dart';
import '../../../../utils/Styles.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/resource/colors.dart';
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

  @override
  void initState() {
    super.initState();
    _getJoyContentList();
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
                                                      joyContentList: joyContentListView,
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
}
