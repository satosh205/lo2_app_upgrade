import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/data/models/response/home_response/new_portfolio_response.dart';
import 'package:masterg/pages/ghome/video_player_screen.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class PortfolioDetail extends StatefulWidget {
  final Portfolio portfolio;
  final String? baseUrl;
  const PortfolioDetail({Key? key, required this.portfolio, this.baseUrl}) : super(key: key);

  @override
  State<PortfolioDetail> createState() => _PortfolioDetailState();
}

class _PortfolioDetailState extends State<PortfolioDetail> {
  String? urlType;
   VideoPlayerController? _controller;
  @override
  void initState() {
   check();
    super.initState();
  }

void check(){
  String url = widget.portfolio.portfolioFile;
  String type = url.split('/').last.split('.').last;
  print('the vidoe url is $type');
  if(type == 'pdf') urlType = 'pdf';
  else if(type == 'jpg' || type == 'jpeg' || type == 'png' || type == 'gif' ){
urlType = 'img';
  }
  else{
     _controller = VideoPlayerController.network(
      url)
      ..initialize().then((_) {
        setState(() {});
      });
    urlType = 'video';
  }
setState(() {
  
});

  
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    SvgPicture.asset('assets/images/edit_portfolio.svg'),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: () async {},
                        child: SvgPicture.asset(
                          'assets/images/delete.svg',
                          color: Color(0xff0E1638),
                        )),
                  ],
                ),
                Text('${widget.portfolio.desc}', style: Styles.regular(size: 12, color: Color(0xff929BA3))),
                  SizedBox(height: 20,),

                InkWell(
                  onTap: (){
          
                     launchUrl(Uri.parse(
                           '${widget.portfolio.portfolioLink}'));
                    
                 
                  },
                  child: Text('${widget.portfolio.portfolioLink}', style: Styles.regular(size: 12, color: Color(0xff0094FF)))),
                  SizedBox(height: 20,),
                  if(urlType == 'pdf')...[
          
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
                  ]
                  else if(urlType == 'img')...[
                    
                    Image.network('${widget.baseUrl}${widget.portfolio.portfolioFile}'),

                  ]
                  else if(urlType == 'video') AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
          
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}
