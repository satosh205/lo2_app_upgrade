import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/assignment_submissions_response.dart';
import 'package:masterg/pages/announecment_pages/full_video_page.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/custom_progress_indicator.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ReviewSubmissions extends StatefulWidget {
  final int? maxMarks;
  final int? contentId;
  const ReviewSubmissions({Key? key, this.contentId, this.maxMarks})
      : super(key: key);

  @override
  _ReviewSubmissionsState createState() => _ReviewSubmissionsState();
}

class _ReviewSubmissionsState extends State<ReviewSubmissions> {
  late AssessmentDetails data;
  List<SubmissionDetails>? _attempts = [];
  // var _swiperController = SwiperController();
  bool _isLoading = true;

  @override
  void initState() {
    _getData();
    _downloadListener();

    super.initState();
  }

  void _getData() {
    BlocProvider.of<HomeBloc>(context)
        .add(AssignmentSubmissionsEvent(request: widget.contentId));
  }

  void _handleResponse(AssignmentSubmissionsState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("UserProfileState....................");
          data = state.response!.data!.assessmentDetails!.first;
          _attempts =
              state.response!.data!.assessmentDetails!.first.submissionDetails;

          _isLoading = false;
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: ColorConstants.BLACK),
        elevation: 0,
        title: Text(
          "Review submission",
          style: Styles.bold(size: 20),
        ),
      ),
      body: BlocManager(
        initState: (c) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is AssignmentSubmissionsState) _handleResponse(state);
          },
          child: _buildBody(),
        ),
      ),
    );
  }

  _buildBody() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: _isLoading
            ? Center(
                child: CustomProgressIndicator(true, ColorConstants.WHITE),
              )
            : _attempts!.isNotEmpty
                ? SingleChildScrollView(
                    child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        // reverse: true,
                        itemCount: _attempts?.length,
                        itemBuilder: (BuildContext context, int currentIndex) =>
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${_attempts![currentIndex].file!.split('/').last}',
                                            overflow: TextOverflow.fade,
                                            maxLines: 2,
                                            softWrap: true,
                                            style: Styles.regular(size: 14)),
                                        Text(
                                            '${Utility.convertDateFromMillis(
                                              _attempts![currentIndex]
                                                  .createdAt!,
                                              Strings
                                                  .REQUIRED_DATE_DD_MMM_YYYY_HH_MM__SS,
                                            )}',
                                            style: Styles.regular(
                                                size: 10,
                                                color: ColorConstants.GREY_3))
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              download( _attempts![currentIndex]
                                                      .file);
                                              // _downloadSubmission(
                                              //     _attempts![currentIndex]
                                              //         .file);
                                            },
                                            child: SvgPicture.asset(
                                              'assets/images/download_icon.svg',
                                              height: 25,
                                              width: 25,
                                              color: ColorConstants()
                                                  .primaryColor(),
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  NextPageRoute(FullContentPage(
                                                    contentType: "1",
                                                    resourcePath:
                                                        _attempts![currentIndex]
                                                            .file,
                                                  )));
                                            },
                                            child: SvgPicture.asset(
                                              'assets/images/view_icon.svg',
                                              color: ColorConstants()
                                                  .primaryColor(),
                                              height: 25,
                                              width: 25,
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: data
                                                        .submissionDetails![
                                                            currentIndex]
                                                        .reviewStatus ==
                                                    0
                                                ? Text(
                                                    "Under Review",
                                                  )
                                                : Text(
                                                    data.isGraded == 0
                                                        ? "Non Graded "
                                                        : "${data.submissionDetails![currentIndex].marksObtained ?? 0}/${widget.maxMarks}",

                                                    // : _attempts![currentIndex]
                                                    //                 .reviewStatus ==
                                                    //             1 &&
                                                    //         _attempts![currentIndex]
                                                    //                 .isPassed ==
                                                    //             1
                                                    //     ? "Congratulations you passed!"
                                                    //     : _attempts![currentIndex]
                                                    //                     .reviewStatus ==
                                                    //                 1 &&
                                                    //             _attempts![currentIndex]
                                                    //                     .isPassed ==
                                                    //                 0
                                                    //         ? "Sorry, you failed."
                                                    //         : "Under Review",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    style: Styles.bold(
                                                        size: 12,
                                                        color:
                                                            data.isGraded == 0
                                                                ? ColorConstants
                                                                    .BLACK
                                                                : ColorConstants
                                                                    .GREEN),
                                                  ),
                                          ),
                                          SizedBox(width: 6),
                                          SvgPicture.asset(
                                            'assets/images/info.svg',
                                            height: 14,
                                            width: 14,
                                            allowDrawingOutsideViewBox: true,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                  ))
                : Center(
                    child: Text(
                      "No assignments submitted",
                      style: Styles.textBold(),
                    ),
                  ));
  }

  Widget kPadding({required Widget child}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: child);
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  ReceivePort _port = ReceivePort();

  _downloadListener() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) async {
      print("###");
      print(data);
      print("#");
      String? id = data[0];
      DownloadTaskStatus? status = data[1];
      int? progress = data[2];
      print(status);
      if (status == DownloadTaskStatus.complete &&
          progress == 100 &&
          id != null) {
        print("INSIDEE");
        String query = "SELECT * FROM task WHERE task_id='" + id + "'";
        var tasks = await FlutterDownloader.loadTasksWithRawQuery(query: query);
        print(tasks);
        print(id);
        //if the task exists, open it
        if (tasks != null) {
          Future.delayed(Duration(seconds: 2), () {
            print("OPENNN");
            FlutterDownloader.open(taskId: tasks.first.taskId);
          });
        }
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  Future download2(String url, String savePath) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Download started..",
            style: Styles.boldWhite(),
          ),
          backgroundColor: ColorConstants.BLACK,
          duration: Duration(seconds: 2),
        ),
      );
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: savePath,
        showNotification: true,
        headers: {"auth": "test_for_sql_encoding"},
        openFileFromNotification: true,
      );
      print(taskId);
    } catch (e) {
      print(e);
    }
  }

    void download(String? usersFile) async {
    print('downloading');
    if (await Permission.storage.request().isGranted) {
      // var tempDir = await getApplicationDocumentsDirectory();
      String localPath = "";
      if (Platform.isAndroid) {
        final path = (await getExternalStorageDirectories(
                type: StorageDirectory.downloads))!
            .first;

        localPath = path.path;

        //check if file exists
        final file = File(localPath + "/" + usersFile!.split('/').last);
        if (file.existsSync()) {
          print("FILE EXISTS");
          Utility.showSnackBar(
              scaffoldContext: context, message: "File already exists");

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

  void _downloadSubmission(String? usersFile) async {
    if (await Permission.storage.request().isGranted) {
      var tempDir = await getApplicationDocumentsDirectory();
      String localPath = "";
      if (Platform.isAndroid) {
        localPath = "/sdcard/download/";
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
}
