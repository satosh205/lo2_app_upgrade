import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/assignment_detail_response.dart';
import 'package:masterg/data/models/response/home_response/assignment_submissions_response.dart';
import 'package:masterg/data/providers/assignment_detail_provider.dart';
import 'package:masterg/pages/announecment_pages/full_video_page.dart';
import 'package:masterg/pages/custom_pages/TapWidget.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/training_pages/assignment_submissions.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/custom_progress_indicator.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AssignmentDetailPage extends StatefulWidget {
  final int? id;
  final bool fromCompetition;
  AssignmentDetailPage({required this.id, this.fromCompetition = false});
  @override
  _AssignmentDetailPageState createState() => _AssignmentDetailPageState();
}

class _AssignmentDetailPageState extends State<AssignmentDetailPage> {
  File? file;
  final _userNotes = TextEditingController(text: "");
  AssignmentDetailProvider? assignmentDetailProvider;
  bool _isLoading = false;
  AssessmentDetails? data;
  List<SubmissionDetails>? _attempts = [];

  @override
  void initState() {
    _getData();
    _downloadListener();
    super.initState();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  ReceivePort _port = ReceivePort();

  _downloadListener() async {
    // WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize();
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
        saveInPublicStorage: true,
        headers: {"auth": "test_for_sql_encoding"},
        openFileFromNotification: true,
      );
      print(taskId);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    assignmentDetailProvider = Provider.of<AssignmentDetailProvider>(context);
    return Scaffold(
        backgroundColor: ColorConstants.WHITE,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: ColorConstants.GREY_1, //change your color here
          ),
          title: Text(
            'Assignment',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocManager(
            initState: (c) {},
            child: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is AssignmentSubmissionsState) _handleResponse(state);
              },
              child: assignmentDetailProvider?.assignment != null
                  ? _buildBody()
                  : CustomProgressIndicator(true, ColorConstants.WHITE),
            )));
  }

  _buildBody() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.fromCompetition) ...[
                      // Center(
                      //   child: Container(
                      //     margin: EdgeInsets.symmetric(vertical: 6),
                      //     decoration: BoxDecoration(
                      //         color: ColorConstants.GREY_4,
                      //         borderRadius: BorderRadius.circular(6)),
                      //     width: MediaQuery.of(context).size.width * 0.15,
                      //     height: 6,
                      //   ),
                      // ),
                      // Divider(),
            
                      Text(
                        '${assignmentDetailProvider?.assignment?.title}',
                        style: Styles.bold(size: 14),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Submit Before: ',
                            style: Styles.regular(
                                size: 12, color: Color(0xff5A5F73)),
                          ),
                          Text(
                            '${Utility.convertDateFromMillis(assignmentDetailProvider!.assignment!.endDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
                            style: Styles.semibold(
                                size: 12, color: Color(0xff0E1638)),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('100 marks '),
                          Text('• ',
                              style: Styles.regular(
                                  color: ColorConstants.GREY_2, size: 12)),
                          Text('Level: '),
                          Text('Easy'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${assignmentDetailProvider?.assignment?.description}',
                        style: Styles.regular(size: 14, color: Color(0xff5A5F73)),
                      ),
                      Divider(),
                      SizedBox(height: 8),
            
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: <Color>[
                                          ColorConstants.GRADIENT_ORANGE,
                                          ColorConstants.GRADIENT_RED
                                        ]).createShader(bounds);
                                  },
                         child:   Text('Assignment file',
                                style: Styles.bold(
                            )),),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    print('download_icon');
                                    if (await Permission.storage
                                        .request()
                                        .isGranted) {
                                      var tempDir =
                                          await getApplicationDocumentsDirectory();
            
                                      String localPath = (tempDir.path) +
                                          Platform.pathSeparator +
                                          'Swayam';
            
                                      var savedDir = Directory(localPath);
                                      bool hasExisted = await savedDir.exists();
                                      print(hasExisted);
                                      if (!hasExisted) {
                                        try {
                                          savedDir = await savedDir.create();
                                        } on Exception catch (e) {
                                          print(e);
                                        }
                                      }
            
                                      download(assignmentDetailProvider
                                          ?.assignment!.file!);
                                    } else {
                                      Utility.showSnackBar(
                                          scaffoldContext: context,
                                          message:
                                              "Please enable storage permission");
                                    }
                                  },
                                  child: ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: <Color>[
                                          ColorConstants.GRADIENT_ORANGE,
                                          ColorConstants.GRADIENT_RED
                                        ]).createShader(bounds);
                                  },
                                 child: SvgPicture.asset(
                                    'assets/images/download_icon.svg',
                                   
                                    height: 22,
                                    width: 22,
                                    allowDrawingOutsideViewBox: true,
                                  ),
                                ),),
                                _size(width: 20),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        NextPageRoute(FullContentPage(
                                          contentType: "1",
                                          resourcePath: assignmentDetailProvider
                                              ?.assignment!.file!,
                                        )));
                                  },
                                  child:
                                  ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: <Color>[
                                          ColorConstants.GRADIENT_ORANGE,
                                          ColorConstants.GRADIENT_RED
                                        ]).createShader(bounds);
                                  },child: SvgPicture.asset(
                                    'assets/images/view_icon.svg',
                                   
                                    height: 22,
                                    width: 22,
                                    allowDrawingOutsideViewBox: true,
                                  ),
                                ),)
                              ],
                            ),
                          ]),
                      // SizedBox(height: 8),
                       _buildListBody(),
                      Spacer(),
            
                      Divider(),
                      InkWell(
                        onTap: () {
                          _attachFile();
                          bool disbaleUpload =
                              assignmentDetailProvider?.assignment?.score == null
                                  ? false
                                  : true;
            
                          if (!disbaleUpload)
                            AlertsWidget.showCustomDialog(
                                context: context,
                                title: "Upload Assignment!",
                                text: "",
                                icon: 'assets/images/circle_alert_fill.svg',
                                showCancel: true,
                                oKText: "Upload",
                                onOkClick: () async {
                                  // Navigator.pop(context);
                                  _submitAssignment();
                                });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [
                  ColorConstants.GRADIENT_ORANGE,
                  ColorConstants.GRADIENT_RED,
                ]),
              ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(22),
                          //     color: Color(0xff0E1638)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Upload Assignment',
                                style: Styles.boldWhite(size: 14),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.file_upload_outlined,
                                  color: ColorConstants.WHITE)
                            ],
                          ),
                        ),
                      )
                    ] else ...[
                      _belowTitle(assignmentDetailProvider!),
                      _body(assignmentDetailProvider!.assignment!),
                      _buildListBody(),
                    ]
                  ]),
            ),
          ),
        ));
  }

  _buildListBody() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        child: _isLoading
            ? Center(
                child: CustomProgressIndicator(true, ColorConstants.WHITE),
              )
            : _attempts!.isNotEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ListView.builder(
                        itemCount: _attempts?.length,
                        itemBuilder: (BuildContext context, int currentIndex) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
                                            '${Utility.convertDateFromMillis(_attempts![currentIndex].createdAt!, Strings.REQUIRED_DATE_DD_MMM_YYYY_HH_MM__SS)}',
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
                                              print('List View Click');
                                              download(_attempts![currentIndex]
                                                  .file);
                                              // _downloadSubmission(
                                              //    );
                                            },
                                            child: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: <Color>[
                                        ColorConstants.GRADIENT_ORANGE,
                                        ColorConstants.GRADIENT_RED
                                      ]).createShader(bounds);
                                },
                                          child:  SvgPicture.asset(
                                              'assets/images/download_icon.svg',
                                              
                                              height: 25,
                                              width: 25,
                                            
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                          ),),
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
                                            child:ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: <Color>[
                                        ColorConstants.GRADIENT_ORANGE,
                                        ColorConstants.GRADIENT_RED
                                      ]).createShader(bounds);
                                },
                                          child:   SvgPicture.asset(
                                              'assets/images/view_icon.svg',
                                              
                                              height: 22,
                                              width: 22,
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                          ),)
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: data
                                                        ?.submissionDetails![
                                                            currentIndex]
                                                        .reviewStatus ==
                                                    0
                                                ? Text(
                                                    "Under Review",
                                                  )
                                                : Text(
                                                    data?.isGraded == 0
                                                        ? "Non Graded "
                                                        : "${data?.submissionDetails![currentIndex].marksObtained ?? 0}/${assignmentDetailProvider?.assignments.maximumMarks}",

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
                                                            data?.isGraded == 0
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
                  )
                : Center(
                    child: Text(
                      "No assignments submitted",
                      style: Styles.textBold(),
                    ),
                  ));
  }

  void _downloadSubmission(String? usersFile) async {
    print('=========== usersFile ===========');
    print(usersFile);

    if (await Permission.storage.request().isGranted) {
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

  _belowTitle(AssignmentDetailProvider assignmentDetailProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${Strings.of(context)?.submitBefore}: ${'${Utility.convertDateFromMillis(assignmentDetailProvider.assignment!.endDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY)}'}',
            style: Styles.bold(size: 14, color: ColorConstants.BLACK),
          ),
          _size(height: 10),
          Text('${assignmentDetailProvider.assignments.title}',
              style: Styles.bold(
                  color: ColorConstants().primaryColor(), size: 16)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  data?.isGraded == 0
                      ? Text(
                          "Non Graded ",
                          style: Styles.bold(
                              size: 14, color: ColorConstants.BLACK),
                        )
                      : Text(
                          '${assignmentDetailProvider.assignments.maximumMarks} Marks',
                          style: Styles.bold(
                              size: 14, color: ColorConstants.BLACK),
                        ),
                  Text(
                    assignmentDetailProvider.assignments.allowMultiple != 0
                        ? ' • Multiple Attempts'
                        : ' • 1 Attempt',
                    style: Styles.bold(size: 14, color: ColorConstants.BLACK),
                  ),
                ],
              ),
              _size(height: 10),
              Text('${assignmentDetailProvider.assignments.description}',
                  style: Styles.regular(size: 14)),
              _size(height: 30),
              Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Assignment file',
                    style: Styles.bold(color: Color(0xffFF2452), size: 16)),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        print('download_icon');
                        if (await Permission.storage.request().isGranted) {
                          var tempDir =
                              await getApplicationDocumentsDirectory();

                          String localPath = (tempDir.path) +
                              Platform.pathSeparator +
                              'Swayam';

                          var savedDir = Directory(localPath);
                          bool hasExisted = await savedDir.exists();
                          print(hasExisted);
                          if (!hasExisted) {
                            try {
                              savedDir = await savedDir.create();
                            } on Exception catch (e) {
                              print(e);
                            }
                          }

                          download(assignmentDetailProvider.assignment!.file!);
                        } else {
                          Utility.showSnackBar(
                              scaffoldContext: context,
                              message: "Please enable storage permission");
                        }
                      },
                      child: SvgPicture.asset(
                        'assets/images/download_icon.svg',
                        color: Color(0xffFF2452),
                        height: 22,
                        width: 22,
                        allowDrawingOutsideViewBox: true,
                      ),
                    ),
                    _size(width: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            NextPageRoute(FullContentPage(
                              contentType: "1",
                              resourcePath:
                                  assignmentDetailProvider.assignment!.file!,
                            )));
                      },
                      child: SvgPicture.asset(
                        'assets/images/view_icon.svg',
                        color: Color(0xffFF2452),
                        height: 22,
                        width: 22,
                        allowDrawingOutsideViewBox: true,
                      ),
                    ),
                  ],
                )
              ]),
              Divider(),
            ],
          )
        ],
      ),
    );
  }

  _size({double height = 20, double width = 0}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  _body(Assignment assignment) {
    bool disbaleUpload =
        assignmentDetailProvider?.assignment?.score == null ? false : true;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _size(height: 20),
                Text(
                  'User notes',
                  style: Styles.textExtraBold(
                      size: 18, color: ColorConstants().primaryColor()),
                ),
                _size(height: 5),
                TextFormField(
                  maxLines: 3,
                  controller: _userNotes,
                  style: Styles.textBold(size: 16),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Color(0xFFFFFF),
                    hintStyle: TextStyle(
                      color: ColorConstants.GREY_OUTLINE,
                      fontSize: 16,
                    ),
                    filled: false,
                    labelStyle: TextStyle(
                      color: ColorConstants.TEXT_DARK_BLACK,
                      fontSize: 16,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorConstants.GREY_OUTLINE,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    focusColor: ColorConstants.GREY_OUTLINE,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorConstants.GREY_OUTLINE,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ).copyWith(hintText: 'Write Something....'),
                  validator: (value) =>
                      value!.isEmpty ? "Enter something" : null,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {},
                  onFieldSubmitted: (val) {},
                ),
              ],
            ),
            // _size(height: MediaQuery.of(context).size.height / 5),
            //Spacer(),
            _size(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    file == null
                        ? TapWidget(
                            onTap: () {
                              if (!disbaleUpload) {
                                if (assignmentDetailProvider
                                            ?.assignments.allowMultiple ==
                                        0 &&
                                    assignmentDetailProvider
                                            ?.assignments.totalAttempts ==
                                        1)
                                  AlertsWidget.showCustomDialog(
                                      context: context,
                                      title: "Reached maximum attempts",
                                      text: "",
                                      icon:
                                          'assets/images/circle_alert_fill.svg',
                                      showCancel: false,
                                      onOkClick: () async {
                                        // Navigator.pop(context);
                                      });
                                else
                                  _attachFile();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: MediaQuery.of(context).size.width * 0.65,
                              decoration: BoxDecoration(
                                 gradient: LinearGradient(colors: [
                  ColorConstants.GRADIENT_ORANGE,
                  ColorConstants.GRADIENT_RED,
                ]),
                                  color: disbaleUpload
                                      ? ColorConstants.GREY_4
                                      : ColorConstants().primaryColor(),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 4),
                                child: assignmentDetailProvider!.isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Attach File',
                                            style: Styles.textExtraBold(
                                                size: 14,
                                                color: ColorConstants()
                                                    .primaryForgroundColor()),
                                          ),
                                          _size(width: 10),
                                          Icon(
                                            Icons.attach_file,
                                            color: ColorConstants.WHITE,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  file!.path.split("/").last,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              TapWidget(
                                onTap: () {
                                  setState(() {
                                    file = null;
                                  });
                                },
                                child: Icon(
                                  Icons.delete,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                    _size(),
                    TapWidget(
                      onTap: () {
                        if (!disbaleUpload) _submitAssignment();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                           gradient: LinearGradient(colors: [
                  ColorConstants.GRADIENT_ORANGE,
                  ColorConstants.GRADIENT_RED,
                ]),
                            color: disbaleUpload
                                ? ColorConstants.GREY_4
                                : ColorConstants().primaryColor(),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
                          child: assignmentDetailProvider!.isLoading
                              ? Center(child: CircularProgressIndicator())
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Upload assignment',
                                      style: Styles.textExtraBold(
                                          size: 14,
                                          color: ColorConstants()
                                              .primaryForgroundColor()),
                                    ),
                                    _size(width: 10),
                                    Icon(Icons.file_upload_outlined,
                                        color: ColorConstants.WHITE)
                                  ],
                                ),
                        ),
                      ),
                    ),
                    _size(height: 15),
                    if (assignmentDetailProvider?.assignment?.totalAttempts !=
                        0)
                      Row(
                        children: [
                          Text(
                            '${assignmentDetailProvider?.assignment?.totalAttempts} ',
                            style: Styles.regular(
                                size: 14, color: ColorConstants.RED),
                          ),
                          assignmentDetailProvider?.assignment?.totalAttempts ==
                                      0 ||
                                  assignmentDetailProvider
                                          ?.assignment?.totalAttempts ==
                                      1
                              ? Text(
                                  'Attempt',
                                  style: Styles.regular(
                                      size: 14, color: ColorConstants.RED),
                                )
                              : Text(
                                  'Attempts',
                                  style: Styles.regular(
                                      size: 14, color: ColorConstants.RED),
                                ),
                          if (assignmentDetailProvider
                                  ?.assignment?.totalAttempts !=
                              0)
                            Text(
                              ' Taken',
                              style: Styles.regular(
                                  size: 14, color: ColorConstants.RED),
                            ),
                        ],
                      ),
                    _size(height: 15),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TapWidget(
                  onTap: () {
                    Navigator.push(
                        context,
                        NextPageRoute(
                            ReviewSubmissions(
                              maxMarks: assignmentDetailProvider
                                  ?.assignments.maximumMarks,
                              contentId: widget.id,
                            ),
                            isMaintainState: true));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: ColorConstants().primaryColor())),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'View submissions',
                          style: Styles.textRegular(
                              color: ColorConstants().primaryColor()),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            _size(height: 50)
          ],
        ),
      ),
    );
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
          //reverse attempt order

          _attempts = new List.from(_attempts!.reversed);
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

  void _attachFile() async {
    if (await Permission.storage.request().isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'jpg', 'jpeg', 'png']);
      if (result != null) {
        setState(() {
          file = File(result.files.first.path!);
        });
      }
    }
  }

  void _getData() {
    BlocProvider.of<HomeBloc>(context)
        .add(AssignmentSubmissionsEvent(request: widget.id));
  }

  void _submitAssignment() async {
    if (file != null) {
      bool res = await assignmentDetailProvider!.uploadAssignment(
          notes: _userNotes.text, path: file!.path, id: widget.id);
      if (res) {
        _getData();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Assignment submitted successfully")));
        setState(() {
          file = null;
        });
        _userNotes.clear();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Something went wrong")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please attach a file")));
    }
  }
}
