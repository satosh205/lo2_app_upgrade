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
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/download_resume.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class ViewResume extends StatefulWidget {
  final String? resumUrl;
  final int? resumeId;
  const ViewResume({super.key, this.resumUrl, this.resumeId});

  @override
  State<ViewResume> createState() => _ViewResumeState();
}

class _ViewResumeState extends State<ViewResume> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
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
              style: Styles.bold(size: 14),
            ),
            actions: [
              if (!(widget.resumUrl == '' || widget.resumUrl == null))
                InkWell(
                    onTap: () {
                      download(widget.resumUrl);
                      // downloadFile(widget.resumUrl!);
                    
                    },
                    child: SvgPicture.asset(
                      'assets/images/download.svg',
                    )),
              SizedBox(
                width: 20,
              ),
              if (!(widget.resumUrl == '' || widget.resumUrl == null))
                InkWell(
                    onTap: () {
                      AlertsWidget.showCustomDialog(
                          context: context,
                          title: '',
                          text: 'Are you sure you want to delete the resume?',
                          icon: 'assets/images/circle_alert_fill.svg',
                          onOkClick: () async {
                            deleteResume(widget.resumeId!);
                          });
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    FilePickerResult? result;
                    if (await Permission.storage.request().isGranted) {
                      if (Platform.isIOS) {

                        // result =
                        //                   await FilePicker.platform.pickFiles(
                        //                 allowMultiple: false,
                        //                 type: FileType.custom,
                        //               );
                        result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
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
                     
                      if (result?.files.first.extension == 'pdf') {
                         setState(() {});
                         updateResume = true;
                        addResume(data);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'It is not a PDF file please try to upload a PDF file.'),
                        ));
                      }
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/upload_icon.svg'),
                      SizedBox(
                        width: 10,
                      ),
                      GradientText(child: Text('Upload Latest'))
                    ],
                  ),
                ),
                Text("Supported Format: .pdf",
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
              if (state is AddResumeState) {
                if (state.apiState == ApiStatus.SUCCESS) {
                  updateResume = false;
                  setState(() {});

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Resume uploaded'),
                  ));
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.pop(context);
                }
              }
            },
            child: Container(
              color: ColorConstants.WHITE,
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
                          "You have not uploaded your resume yet!",
                          style: Styles.regular(size: 14),
                        ),
                      ],
                    )

                  // : Text('${widget.resumUrl}')
                  : Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: PDF(
                        //swipeHorizontal: true,
                        autoSpacing: false,
                        fitPolicy: FitPolicy.BOTH,
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
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Resume successfully deleted.'),
            ));
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

  void download(String? usersFile) async {
    print('downloading');
    if (await Permission.storage.request().isGranted) {
      // var tempDir = await getApplicationDocumentsDirectory();
      String localPath = "";
      if (Platform.isAndroid) {
        localPath = "/sdcard/download/";
        //check if file exists
        final file = File(localPath + "/" + usersFile!.split('/').last);
        if (file.existsSync()) {
          print("FILE EXISTS");
          // Utility.showSnackBar(
          //     scaffoldContext: context, message: "File already exists");

          await FlutterDownloader.open(taskId: usersFile.split('/').last);
          return;
        }
      } else {
        localPath = (await getApplicationDocumentsDirectory()).path;
      }
      //String localPath = (tempDir.path) + Platform.pathSeparator + 'MyCoach';
      var savedDir = Directory(localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir = await savedDir.create();
      }
      download2(usersFile!, localPath);
    } else {
      Utility.showSnackBar(
          scaffoldContext: context,
          message: "Please enable storage permission");
    }
  }

  Future download2(String url, String savePath) async {
    try {
      // _key.currentState!.showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       "Downloading start.",
      //       style: Styles.boldWhite(),
      //     ),
      //     backgroundColor: ColorConstants.BLACK,
      //     duration: Duration(seconds: 2),
      //   ),
      // );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(' Downloading start.'),
      ));

      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: savePath,
        showNotification: true,
        openFileFromNotification: true,
      );
      print(taskId);
    } catch (e) {
      print(e);
    }
  }

  Future<String> downloadFile(String url) async {
    String localPath;
   if (Platform.isAndroid) {
        localPath = "/sdcard/download/";
        //check if file exists
        final file = File(localPath + "/" + url.split('/').last);
        if (file.existsSync()) {
          print("FILE EXISTS");
          Utility.showSnackBar(
              scaffoldContext: context, message: "File already exists");

          await FlutterDownloader.open(taskId: url.split('/').last);
        
        }
      } else {
        localPath = (await getApplicationDocumentsDirectory()).path;
      }
  final fileName = url.split('/').last;
  final filePath = '$localPath/$fileName';

  final response = await http.get(Uri.parse(url));
  final file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);

  return filePath;
}
}



