import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/constant.dart';
import 'package:permission_handler/permission_handler.dart';

class ViewResume extends StatefulWidget {
  final String? resumUrl;
  final int? resumeId;
  const ViewResume({super.key,  this.resumUrl, this.resumeId});

  @override
  State<ViewResume> createState() => _ViewResumeState();
}

class _ViewResumeState extends State<ViewResume> {
  bool? updateResume = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            actions: [
              if (widget.resumUrl != '')
                InkWell(
                    onTap: () {
                      print('downlaod file');
                    },
                    child: SvgPicture.asset(
                      'assets/images/download.svg',
                    )),
              SizedBox(
                width: 20,
              ),
              if (widget.resumUrl != '')
                InkWell(
                    onTap: () {
                      deleteResume(widget.resumeId!);
                    },
                    child: SvgPicture.asset(
                      'assets/images/delete.svg',
                    )),
              SizedBox(
                width: 20,
              ),
              Padding(
                padding: EdgeInsets.only(right: 8.0),
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
          Container(
            width: width(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 110.0),
                  child: InkWell(
                    onTap: () async {
                      FilePickerResult? result;
                      if (await Permission.storage.request().isGranted) {
                        if (Platform.isIOS) {
                          result = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.media,
                              allowedExtensions: ['pdf']);
                        } else {
                          result = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.custom,
                              onFileLoading: (path) {
                                print('File $path is loading');
                              },
                              allowedExtensions: [
                                'pdf',
                              ]);
                        }

                        Map<String, dynamic> data = Map();

                        data['file'] = await MultipartFile.fromFile(
                            '${result?.files.first.path}',
                            filename: result?.files.first.name);
                            updateResume = true;
                            setState(() {
                              
                            });
                        addResume(data);
                      }
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/images/upload_icon.svg'),
                        SizedBox(
                          width: 10,
                        ),
                        GradientText(child: Text('Upload Latest'))
                      ],
                    ),
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
          isLoading: updateResume,
          body: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) async {
              if (state is SingularisDeletePortfolioState) {
                handleDeleteResume(state);
              }
              if(state is AddResumeState){
                   if(state.apiState == ApiStatus.SUCCESS) {
                    updateResume = false;
                    setState(() {
                      
                    });
          
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Resume uploaded'),
            ));
                await    Future.delayed(Duration(seconds: 1));
                  Navigator.pop(context);
                }
              }
            },
            child: Container(
              color: Colors.white,
              height: height(context) * 0.8,
              width: width(context),
              child: widget.resumUrl == '' || widget.resumUrl == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/no_resume.svg',
                          width: 80,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "You have not uploaded your resume yet! ${widget.resumUrl}",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff929BA3)),
                        ),
                      ],
                    ) 
                    
                    // : Text('${widget.resumUrl}')
                  : PDF(
                      //swipeHorizontal: true,
                      enableSwipe: true,
                      gestureRecognizers: [
                        Factory(() => PanGestureRecognizer()),
                        Factory(() => VerticalDragGestureRecognizer())
                      ].toSet(),
                    ).cachedFromUrl(
                      //ApiConstants.IMAGE_BASE_URL + url,
                      widget.resumUrl!,
                      placeholder: (progress) =>
                          Center(child: Text('$progress %')),
                      errorWidget: (error) =>
                          Center(child: Text(error.toString())),
                    ),
            ),
          ),
        ));
  }

  void deleteResume(int id) {
    BlocProvider.of<HomeBloc>(context)
        .add(SingularisDeletePortfolioEvent(portfolioId: id));
  }

  void addResume(Map<String, dynamic> data) {
    BlocProvider.of<HomeBloc>(context).add(AddResumeEvent(data: data));
  }

  void handleDeleteResume(SingularisDeletePortfolioState state) {
    setState(() {
      switch (state.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading Add  Certificate....................");
          updateResume = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Add  Certificate....................");
          updateResume = false;
          Navigator.pop(context);
          break;
        case ApiStatus.ERROR:
          Log.v("Error Add Certificate....................");
          updateResume = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}
