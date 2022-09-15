import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/joy_contentList_response.dart';
import 'package:masterg/data/providers/video_player_provider.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/ghome/video_player_screen.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ViewWidgetDetailsPage extends StatefulWidget {
  final int currentIndex;
  final List<JoyContentListElement>? joyContentList;

  ViewWidgetDetailsPage({Key? key, this.joyContentList, this.currentIndex = 0})
      : super(key: key);
  @override
  _ViewWidgetDetailsPageState createState() => _ViewWidgetDetailsPageState();
}

class _ViewWidgetDetailsPageState extends State<ViewWidgetDetailsPage> {
  PageController controller = PageController(initialPage: 0);
  PageController controllerV = PageController(initialPage: 0);
  bool isLoading = true;
  bool _isJoyContentListLoading = true;
  double currentIndexPage = 0;
  List<JoyContentListElement>? joyContentListResponse;

  @override
  void initState() {
    super.initState();
    joyContentListResponse = widget.joyContentList;
    _isJoyContentListLoading = false;
  }

  void _handleJoyContentListResponse(
      JoyContentListState state, JoyContentListModel list) {
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
          joyContentListResponse =
              state.response!.data!.list!.cast<JoyContentListElement>();

          list.updateList(joyContentListResponse!);

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<VideoPlayerProvider>(
            create: (context) => VideoPlayerProvider(false),
          ),
          ChangeNotifierProvider<JoyContentListModel>(
            create: (context) => JoyContentListModel(joyContentListResponse),
          ),
          ChangeNotifierProvider<JoyContentListModel>(
            create: (context) => JoyContentListModel(widget.joyContentList),
          ),
        ],
        child: BlocManager(
            initState: (context) {
              // BlocProvider.of<HomeBloc>(context).add(JoyContentListEvent());
            },
            child: Consumer<JoyContentListModel>(
              builder: (context, joyContentModel, child) =>
                  BlocListener<HomeBloc, HomeState>(
                      listener: (context, state) async {
                        if (state is JoyContentListState)
                          _handleJoyContentListResponse(state, joyContentModel);
                      },
                      child: getBody(size, joyContentModel)),
            )));
  }

  Widget getBody(var size, JoyContentListModel joyContentListResponse) {
    return Consumer<VideoPlayerProvider>(
        builder: (context, value, child) => Scaffold(
            backgroundColor: ColorConstants.BLACK,
            appBar: AppBar(
              toolbarHeight: 75,
              //automaticallyImplyLeading: false,
              leading: Padding(
                padding: const EdgeInsets.only(top: 30.0, right: 20.0),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: ColorConstants.WHITE,
                  ),
                  onPressed: () {
                    value.disableProivderControl();
                    Navigator.pop(context);
                  },
                ),
              ),
              elevation: 0.0,
              // title: Center(
              //   child: Container(
              //     height: 5,
              //     width: 48,
              //     decoration: BoxDecoration(
              //         color: ColorConstants.GREY_2,
              //         borderRadius: BorderRadius.circular(8)),
              //   ),
              // ),
              backgroundColor: ColorConstants.BLACK,
            ),
            body: ScreenWithLoader(
              isLoading: _isJoyContentListLoading,
              body: Container(
                child: PageView.builder(
                  controller: PageController(
                      initialPage: widget.currentIndex,
                      keepPage: true,
                      viewportFraction: 1),
                  itemCount: joyContentListResponse.list!.length != 0
                      ? joyContentListResponse.list!.length
                      : 0,
                  scrollDirection: Axis.vertical,
                  //physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        child: Stack(
                      children: <Widget>[
                        Container(
                            child: Container(
                          child: PageView.builder(
                            itemCount: joyContentListResponse
                                        .list![index].multiFileUploads !=
                                    0
                                ? joyContentListResponse
                                    .list![index].multiFileUploads!.length
                                : 0,
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int indexIn) {
                              return Stack(children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(children: [
                                        Container(
                                          child: joyContentListResponse
                                              .list![index]
                                              .resourceType ==
                                              'image'
                                              ? Image.network(
                                              '${joyContentListResponse.list![index].multiFileUploads![indexIn]}',
                                fit: BoxFit.fitHeight,
                                //height: MediaQuery.of(context).size.height * 0.87,
                                width: double.infinity,
                              ): joyContentListResponse
                                              .list![index]
                                              .resourceType ==
                                              'video'
                                              ? Container(
                                            height: MediaQuery.of(
                                                context)
                                                .size
                                                .height *
                                                0.9,
                                            child:
                                            CustomVideoPlayer(
                                              url: joyContentListResponse
                                                  .list![index]
                                                  .multiFileUploads![
                                              indexIn],
                                            ),
                                          )
                                              : Container(
                                            height: 370,
                                          ),
                                        ),
                                      ]),
                                      /*GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder:
                                                  (context) =>
                                                      FractionallySizedBox(
                                                        //heightFactor: 0.97,
                                                        heightFactor: 1.0,
                                                        child: Container(
                                                          child:
                                                              PageView.builder(
                                                            controller:
                                                                PageController(
                                                                    initialPage:
                                                                        0,
                                                                    keepPage:
                                                                        true,
                                                                    viewportFraction:
                                                                        1),
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (context,
                                                                    viewIndex) {
                                                              return Stack(
                                                                children: [
                                                                  Image.network(
                                                                    '${joyContentListResponse.list![index].multiFileUploads![viewIndex]}',
                                                                    // 'https://images.unsplash.com/photo-1644982647869-e1337f992828?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=435&q=80',
                                                                    fit: BoxFit
                                                                        .contain,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height,
                                                                  ),
                                                                  Positioned(
                                                                      top: 10,
                                                                      right: 10,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap: () =>
                                                                            Navigator.pop(context),
                                                                        child:
                                                                            //Icon(Icons.zoom_out_map_sharp, color: Colors.red,),
                                                                            SvgPicture.asset(
                                                                          'assets/images/shrink_icon.svg',
                                                                          height:
                                                                              20.0,
                                                                          width:
                                                                              20.0,
                                                                          allowDrawingOutsideViewBox:
                                                                              true,
                                                                        ),
                                                                      )),
                                                                  Align(
                                                                    alignment:
                                                                        FractionalOffset
                                                                            .bottomCenter,
                                                                    child:
                                                                        DotsIndicator(
                                                                      dotsCount: joyContentListResponse
                                                                          .list![
                                                                              index]
                                                                          .multiFileUploads!
                                                                          .length,
                                                                      position:
                                                                          viewIndex
                                                                              .toDouble(),
                                                                      decorator:
                                                                          DotsDecorator(
                                                                        size: const Size.square(
                                                                            9.0),
                                                                        activeSize: const Size(
                                                                            18.0,
                                                                            9.0),
                                                                        activeColor:
                                                                            ColorConstants.WHITE,
                                                                        color: ColorConstants
                                                                            .GREY_4,
                                                                        activeShape:
                                                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                            itemCount:
                                                                joyContentListResponse
                                                                    .list![
                                                                        index]
                                                                    .multiFileUploads!
                                                                    .length,
                                                          ),
                                                        ),
                                                      ));
                                        },
                                        child: Stack(children: [
                                          Container(
                                            child: joyContentListResponse
                                                        .list![index]
                                                        .resourceType ==
                                                    'image'
                                                ? Image.network(
                                                    '${joyContentListResponse.list![index].multiFileUploads![indexIn]}',
                                                    fit: BoxFit.fitHeight,
                                                    //height: MediaQuery.of(context).size.height * 0.87,
                                                    width: double.infinity,
                                                  )
                                                : joyContentListResponse
                                                            .list![index]
                                                            .resourceType ==
                                                        'video'
                                                    ? Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.9,
                                                        child:
                                                            CustomVideoPlayer(
                                                          url: joyContentListResponse
                                                                  .list![index]
                                                                  .multiFileUploads![
                                                              indexIn],
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 370,
                                                      ),
                                          ),
                                        ]),
                                      ),*/
                                    ],
                                  ),
                                ),
                              ]);
                            },
                          ),
                        )),
                        /*Positioned(
                            top: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: ColorConstants.BLACK.withOpacity(0.4),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 8.0),
                                    child: joyContentListResponse[index].title != null ? Text(
                                      '${joyContentListResponse[index].title}',
                                      style: Styles.bold(
                                          size: 14,
                                          color: ColorConstants
                                              .WHITE),
                                    ):null,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        bottom: 20,
                                        left: 8,
                                        right: 8),
                                    child: Text(
                                      joyContentListResponse[index].description != null ?
                                      '${joyContentListResponse[index].description}' : '',
                                      style: Styles.regular(
                                          size: 12,
                                          color: ColorConstants
                                              .WHITE),
                                    ),
                                  ),
                                ],
                              ),
                            )),*/

                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            //color: ColorConstants.BLACK.withOpacity(0.5),
                            /*decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 40,
                                    offset: Offset(0.0, 20.0)

                                )
                              ],
                            ),*/
                            constraints: BoxConstraints(minHeight: 120),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 1.0],
                                colors: [
                                  Colors.black.withOpacity(0.0),
                                  Colors.black.withOpacity(0.8),
                                ],
                              ),
                            ),

                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 10.0, left: 5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 8.0),
                                        child: joyContentListResponse
                                                    .list![index].title !=
                                                null
                                            ? Text(
                                                '${joyContentListResponse.list![index].title}',
                                                style: Styles.bold(
                                                    size: 14,
                                                    color:
                                                        ColorConstants.WHITE),
                                              )
                                            : null,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, left: 8, right: 8),
                                        child: Text(
                                          joyContentListResponse.list![index]
                                                      .description !=
                                                  null
                                              ? '${joyContentListResponse.list![index].description}'
                                              : '',
                                          style: Styles.regular(
                                              size: 12,
                                              color: ColorConstants.WHITE),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 12.0, bottom: 60.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: joyContentListResponse
                                                    .list![index].viewCount !=
                                                null
                                            ? Row(
                                                children: [
                                                  Text(
                                                    '${joyContentListResponse.list![index].viewCount ?? 0} view',
                                                    style: Styles.regular(
                                                        size: 12,
                                                        color: ColorConstants
                                                            .WHITE),
                                                  ),
                                                  if (joyContentListResponse
                                                              .list![index]
                                                              .viewCount! >
                                                          1 &&
                                                      Preference.getInt(Preference
                                                              .APP_LANGUAGE) ==
                                                          1)
                                                    Text(
                                                      Preference.getInt(Preference.APP_LANGUAGE) == 1 ? 's' : '',
                                                      style: Styles.regular(
                                                          size: 14,
                                                          color: ColorConstants
                                                              .WHITE),
                                                    ),
                                                ],
                                              )
                                            : Text(
                                                '${0} view',
                                                style: Styles.regular(
                                                    size: 12,
                                                    color:
                                                        ColorConstants.WHITE),
                                              ),
                                      ),
                                      if (joyContentListResponse.list![index]
                                              .multiFileUploads!.length >
                                          1)
                                        Container(
                                          margin: EdgeInsets.only(top: 0),
                                          child: Center(
                                            child: DotsIndicator(
                                              dotsCount: joyContentListResponse
                                                  .list![index]
                                                  .multiFileUploads!
                                                  .length,
                                              position: currentIndexPage,
                                              decorator: DotsDecorator(
                                                size: const Size.square(9.0),
                                                activeSize:
                                                    const Size(18.0, 9.0),
                                                activeColor:
                                                    ColorConstants.WHITE,
                                                color: ColorConstants.GREY_4,
                                                activeShape:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    24.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          // margin: EdgeInsets.only(bottom: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 55, top: 20, bottom: 0),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: size.width * 0.7,
                                    ),
                                    RightPanel(
                                      size: size,
                                      likes: joyContentListResponse
                                              .list![index].likeCount ??
                                          0,
                                      comments: joyContentListResponse
                                              .list![index].commentCount ??
                                          0,
                                      shares: "shares",
                                      contentId: joyContentListResponse
                                          .list![index].id,
                                      isLiked: joyContentListResponse
                                                  .list![index].userLiked ==
                                              0
                                          ? false
                                          : true,
                                      model: joyContentListResponse,
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
                  },
                ),
              ),
            )));
  }
}

class RightPanel extends StatelessWidget {
  final int? likes;
  final int? comments;
  final String? shares;
  final int? contentId;
  final bool? isLiked;
  final JoyContentListModel? model;
  const RightPanel(
      {Key? key,
      required this.size,
      this.likes,
      this.comments,
      this.shares,
      this.contentId,
      this.isLiked,
      this.model})
      : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        //height: size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.67,
            ),
            Expanded(
                child: Column(
              children: <Widget>[
                Container(),
                // getIcons(TikTokIcons.heart, likes, 25.0),
                LikeWidget(
                  contentId: contentId,
                  likes: likes.toString(),
                  isLiked: isLiked,
                  model: model,
                ),
                SizedBox(
                  height: 14,
                ),
                InkWell(
                    onTap: () {
                      Share.share('${model?.getResourcePath(contentId!)}');
                    },
                    child: SvgPicture.asset(
                      'assets/images/share_icon_reels.svg',
                      height: 35,
                      width: 35,
                      color: ColorConstants.WHITE,
                      allowDrawingOutsideViewBox: true,
                    ))

                // InkWell(child: getIcons(TikTokIcons.reply, shares, 20.0)),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class LikeWidget extends StatefulWidget {
  final String? likes;
  bool? isLiked;
  final int? contentId;
  final JoyContentListModel? model;

  LikeWidget({Key? key, this.likes, this.isLiked, this.contentId, this.model})
      : super(key: key);

  @override
  State<LikeWidget> createState() => _LikeWidgetState();
}

class _LikeWidgetState extends State<LikeWidget> {
  int? likeCount;
  bool? isLiked;
  @override
  void initState() {
    super.initState();

    updateInfo();
    updateLikeandViews(null);
  }

  updateInfo() {
    setState(() {
      likeCount = int.parse(widget.likes!);
      isLiked = widget.isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isLiked!) {
            updateLikeandViews(0);
            likeCount = likeCount! - 1;
            widget.model?.decreaseLikeCount(widget.contentId!);
            isLiked = false;
          } else {
            updateLikeandViews(1);
            likeCount = likeCount! + 1;
            widget.model?.increaseLikeCount(widget.contentId!);
            isLiked = true;
          }
        });
      },
      child: Container(
        child: Column(
          children: <Widget>[
            isLiked!
                ? SvgPicture.asset(
                    'assets/images/greels_liked.svg',
                    height: 35.0,
                    width: 35.0,
                    allowDrawingOutsideViewBox: true,
                  )
                : SvgPicture.asset(
                    'assets/images/greels_like.svg',
                    height: 35.0,
                    width: 35.0,
                    allowDrawingOutsideViewBox: true,
                  ),
            // Icon(TikTokIcons.heart,
            //     color: isLiked ? ColorConstants.RED_BG : ColorConstants.WHITE,
            //     size: 23),
            SizedBox(
              height: 5,
            ),
            Text(
              '${likeCount}',
              style: Styles.regular(size: 12, color: ColorConstants.WHITE),
            )
          ],
        ),
      ),
    );
  }

  void updateLikeandViews(int? like) async {
    BlocProvider.of<HomeBloc>(context).add(LikeContentEvent(
        contentId: widget.contentId, like: like, type: 'contents'));
  }
}
