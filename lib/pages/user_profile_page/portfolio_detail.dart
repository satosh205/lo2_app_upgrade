import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/new_portfolio_response.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_portfolio.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class PortfolioDetail extends StatefulWidget {
  final Portfolio portfolio;
  final String? baseUrl;
  const PortfolioDetail({Key? key, required this.portfolio, this.baseUrl})
      : super(key: key);

  @override
  State<PortfolioDetail> createState() => _PortfolioDetailState();
}

class _PortfolioDetailState extends State<PortfolioDetail> {
  String? urlType;
  FlickManager? flickManager;
  bool deletePortfolio = false;
   late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    check();

    super.initState();
  }

  void check() {
    String url = widget.portfolio.portfolioFile;
    String type = url.split('/').last.split('.').last;
    print('the vidoe url is $type');
    if (type == 'pdf')
      urlType = 'pdf';
    else if (type == 'jpg' ||
        type == 'jpeg' ||
        type == 'png' ||
        type == 'gif') {
      urlType = 'img';
    } else if (type == 'mp4' || type == 'mov') {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(
            "https://singularis.learningoxygen.com/portfolio/SampleVideo_1280x720_2mb.mp4"),
      );
      _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
      urlType = 'video';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void deleteResume(int id) {
      BlocProvider.of<HomeBloc>(context)
          .add(SingularisDeletePortfolioEvent(portfolioId: id));
    }

    void handleDeletePortfolio(SingularisDeletePortfolioState state) {
      setState(() {
        switch (state.apiState) {
          case ApiStatus.LOADING:
            Log.v("Loading Add  Certificate....................");
            deletePortfolio = true;
            break;

          case ApiStatus.SUCCESS:
            Log.v("Success Add  Certificate....................");
            deletePortfolio = false;
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Portfolio deleted'),
            ));
            Navigator.pop(context);
            break;
          case ApiStatus.ERROR:
            Log.v("Error Add Certificate....................");
            deletePortfolio = false;
            break;
          case ApiStatus.INITIAL:
            break;
        }
      });
    }

    return Scaffold(
        body: ScreenWithLoader(
            isLoading: deletePortfolio,
            body: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) async {
                if (state is SingularisDeletePortfolioState) {
                  handleDeletePortfolio(state);
                }
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.close_outlined))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            SizedBox(
                                width: width(context) * 0.8,
                                child: Text(
                                  '${widget.portfolio.portfolioTitle}',
                                  style: Styles.bold(size: 16),
                                )),
                                
                            InkWell(
                                onTap: () async {

                                  AlertsWidget.showCustomDialog(
                      context: context,
                      title: '',
                      text: 'Are you sure you want to edit?',
                      icon: 'assets/images/circle_alert_fill.svg',
                      onOkClick: () async {
                        await Navigator.push(
                                      context,
                                      PageTransition(
                                          duration: Duration(milliseconds: 300),
                                          reverseDuration:
                                              Duration(milliseconds: 300),
                                          type: PageTransitionType.bottomToTop,
                                          child: AddPortfolio(
                                            baseUrl: '${widget.baseUrl}',
                                            editMode: true,
                                            portfolio: widget.portfolio,
                                          ))).then(
                                      (value) => Navigator.pop(context));
                      });
                                 
                                },
                                child: SvgPicture.asset(
                                    'assets/images/edit_portfolio.svg')),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                                onTap: () async {
                                      AlertsWidget.showCustomDialog(
                      context: context,
                      title: '',
                      text: 'Are you sure you want to delete?',
                      icon: 'assets/images/circle_alert_fill.svg',
                      onOkClick: () async {
                         deleteResume(widget.portfolio.id);
                      });
                               
                                },
                                child: SvgPicture.asset(
                                  'assets/images/delete.svg',
                                  color: Color(0xff0E1638),
                                )),
                          ],
                        ),
                      ),
                      // SizedBox(height: 10,),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${widget.portfolio.desc}',
                            style: Styles.regular(
                                size: 14, color: Color(0xff929BA3))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {
                              launchUrl(Uri.parse(
                                  '${widget.portfolio.portfolioLink}'));
                            },
                            child: Text('${widget.portfolio.portfolioLink}',
                                style: Styles.regular(
                                    size: 12, color: Color(0xff0094FF)))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (urlType == 'pdf') ...[
                        SizedBox(
                          height: height(context) * 0.8,
                          child: PDF(
                            enableSwipe: true,
                            autoSpacing: false,
                            gestureRecognizers: [
                              Factory(() => PanGestureRecognizer()),
                              Factory(() => VerticalDragGestureRecognizer())
                            ].toSet(),
                          ).cachedFromUrl(
                            '${widget.baseUrl}${widget.portfolio.portfolioFile}',
                            placeholder: (progress) =>
                                Center(child: Text('$progress %')),
                            errorWidget: (error) =>
                                Center(child: Text(error.toString())),
                          ),
                        )
                      ] else if (urlType == 'img') ...[
                        Image.network(
                            '${widget.baseUrl}${widget.portfolio.portfolioFile}'),
                      ] else if (urlType == 'video')
                       
                      Text('video')

      //                     FutureBuilder(
      //   future: _initializeVideoPlayerFuture,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       // If the VideoPlayerController has finished initialization, use
      //       // the data it provides to limit the aspect ratio of the video.
      //       return AspectRatio(
      //         aspectRatio: _controller.value.aspectRatio,
      //         // Use the VideoPlayer widget to display the video.
      //         child: VideoPlayer(_controller),
      //       );
      //     } else {
      //       // If the VideoPlayerController is still initializing, show a
      //       // loading spinner.
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // )
                    ],
                  ),
                ),
              ),
            )));
  }
}
