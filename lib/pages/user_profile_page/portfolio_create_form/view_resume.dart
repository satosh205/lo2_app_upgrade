import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/constant.dart';


class ViewResume extends StatefulWidget {
  final String resumUrl;
  final int? resumeId;
  const ViewResume({super.key, required this.resumUrl, this.resumeId});

  @override
  State<ViewResume> createState() => _ViewResumeState();
}

class _ViewResumeState extends State<ViewResume> {

  bool? deletingResume = false;
  @override
  Widget build(BuildContext context) {
    return
    
     Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Resume",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          actions:[
        if(widget.resumUrl != '' )   InkWell(
              onTap: (){
                  print('downlaod file');
              },
              child: SvgPicture.asset('assets/images/download.svg',)),
            SizedBox(width: 20,),
                if(widget.resumUrl != '' )    InkWell(
              onTap: (){
                deleteResume(widget.resumeId!);
              },
              child:  SvgPicture.asset('assets/images/delete.svg',)),
            SizedBox(width: 20,),
            
            Padding(
              padding: EdgeInsets.only(right:8.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  
                ),
              ),
              
            ),
            
          ]),
          persistentFooterButtons: [
            Container(width: width(context),
            
            child: 
            
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:110.0),
                        child: Row(
                          children:  [
                            SvgPicture.asset('assets/images/upload_icon.svg'),
                            SizedBox(width: 10,),
                            GradientText(child: Text('Upload Latest'))
                            
                          ],
                        ),
                      ),
                      Text("Supported Format: .pdf, .doc, .jpeg",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff929BA3))),
                    ],
                  ),
                ),
  
          
          ],
        
      body: ScreenWithLoader(
isLoading: deletingResume,
        body: BlocListener<HomeBloc, HomeState>(
                listener: (context, state) async {
                  if(state is SingularisDeletePortfolioState){
                    handleDeleteResume(state);
                  }
                },
                child:  Container(
          color: Colors.white,
          height: height(context) * 0.8,
          width: width(context),
          child:widget.resumUrl == '' ?  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
      
             
                SvgPicture.asset('assets/images/no_resume.svg',width: 80,),
              SizedBox(height: 20,),
              
               Text(
                "You have not uploaded your resume yet! ${widget.resumUrl}",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff929BA3)),
              ),
            
      
          
            
              
              
            
              
            ],
          ) : PDF(
          //swipeHorizontal: true,
          enableSwipe: true,
          gestureRecognizers: [
            Factory(() => PanGestureRecognizer()),
            Factory(() => VerticalDragGestureRecognizer())
          ].toSet(),
        ).cachedFromUrl(
          //ApiConstants.IMAGE_BASE_URL + url,
          widget.resumUrl,
          placeholder: (progress) => Center(child: Text('$progress %')),
          errorWidget: (error) => Center(child: Text(error.toString())),
        ),
        ),
          ),
      ));
  }


  void deleteResume(int id){
   
    BlocProvider.of<HomeBloc>(context).add(SingularisDeletePortfolioEvent(portfolioId: id));

  }


  void handleDeleteResume(SingularisDeletePortfolioState state){

   
    setState(() {
      switch (state.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading Add  Certificate....................");
          deletingResume = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Add  Certificate....................");
          deletingResume = false;
          Navigator.pop(context);
          break;
        case ApiStatus.ERROR:
          Log.v("Error Add Certificate....................");
          deletingResume = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });

  }
}
