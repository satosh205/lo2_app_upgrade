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
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/ghome/video_player_screen.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_portfolio.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
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
  VideoPlayerController? _controller;
  bool deletePortfolio = false;
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
    } else  if(type == 'mp4' || type == 'mov'){
      _controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          setState(() {});
        });
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
if(state is SingularisDeletePortfolioState){
  handleDeletePortfolio(state);
}
            },
            child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close_outlined))
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: width(context) * 0.8,
                        child: Text(
                          '${widget.portfolio.portfolioTitle}',
                          style: Styles.bold(size: 16),
                        )),
                    InkWell(
                      onTap: ()async{

                           await Navigator.push(context, PageTransition(
      duration:Duration(milliseconds: 300) ,
      reverseDuration: Duration(milliseconds: 300),
      type: PageTransitionType.bottomToTop, child:  AddPortfolio(baseUrl: '${widget.baseUrl}',editMode: true, portfolio: widget.portfolio,))).then((value) => Navigator.pop(context));
                      },
                      child: SvgPicture.asset('assets/images/edit_portfolio.svg')),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: () async {
                          deleteResume(widget.portfolio.id);
                        },
                        child: SvgPicture.asset(
                          'assets/images/delete.svg',
                          color: Color(0xff0E1638),
                        )),
                  ],
                ),
                Text('${widget.portfolio.desc}',
                    style: Styles.regular(size: 12, color: Color(0xff929BA3))),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                    onTap: () {
                      launchUrl(Uri.parse('${widget.portfolio.portfolioLink}'));
                    },
                    child: Text('${widget.portfolio.portfolioLink}',
                        style: Styles.regular(
                            size: 12, color: Color(0xff0094FF)))),
                SizedBox(
                  height: 20,
                ),
                if (urlType == 'pdf') ...[
                  SizedBox(
                    height: height(context) * 0.8,
                    child: PDF(
                      enableSwipe: true,
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
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
              ],
            ),
          ),
        ),
      ),
      )));

    
  }
  
}
