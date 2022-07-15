import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/data/models/response/home_response/assignment_detail_response.dart';
import 'package:masterg/data/providers/assignment_detail_provider.dart';
import 'package:masterg/pages/custom_pages/TapWidget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/training_pages/assignment_submissions.dart';
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
  AssignmentDetailPage({required this.id});
  @override
  _AssignmentDetailPageState createState() => _AssignmentDetailPageState();
}

class _AssignmentDetailPageState extends State<AssignmentDetailPage> {
  File? file;
  final _userNotes = TextEditingController(text: "");
  late AssignmentDetailProvider assignmentDetailProvider;

  @override
  void initState() {
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

  Future download(String url, String savePath) async {
    print("HERE!");
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

  @override
  Widget build(BuildContext context) {
    assignmentDetailProvider = Provider.of<AssignmentDetailProvider>(context);
    return Scaffold(
      backgroundColor: ColorConstants.WHITE,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Assessment',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: assignmentDetailProvider.assignment != null
          ? _buildBody()
          : CustomProgressIndicator(true, ColorConstants.WHITE),
    );
  }

  _buildBody() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
            child: Column(children: [
          _belowTitle(assignmentDetailProvider),
          _body(assignmentDetailProvider.assignment!),
        ])));
  }

  _belowTitle(AssignmentDetailProvider assignmentDetailProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Submit before: ${'${Utility.convertDateFromMillis(assignmentDetailProvider.assignment!.endDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY)}'}',
            style: Styles.bold(size: 14, color: ColorConstants.BLACK),
          ),
          _size(height: 10),
          Text('${assignmentDetailProvider.assignments.title}',
              style:
                  Styles.bold(color: ColorConstants.PRIMARY_COLOR, size: 16)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${assignmentDetailProvider.assignments.maximumMarks} Marks',
                style: Styles.bold(size: 14, color: ColorConstants.BLACK),
              ),
              _size(height: 10),
              Text('${assignmentDetailProvider.assignments.description}',
                  style: Styles.regular(size: 14)),
              _size(height: 30),
              Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Assignment file',
                    style: Styles.bold(
                        color: ColorConstants.PRIMARY_COLOR, size: 16)),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
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

                          download(assignmentDetailProvider.assignment!.file!,
                              localPath);
                        } else {
                          Utility.showSnackBar(
                              scaffoldContext: context,
                              message: "Please enable storage permission");
                        }
                      },
                      child: SvgPicture.asset(
                        'assets/images/download_icon.svg',
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
                            NextPageRoute(
                                ReviewSubmissions(
                                  maxMarks: assignmentDetailProvider
                                      .assignments.maximumMarks,
                                  contentId: widget.id,
                                ),
                                isMaintainState: true));
                      },
                      child: SvgPicture.asset(
                        'assets/images/view_icon.svg',
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
                _size(),
                Padding(
                  padding: const EdgeInsets.only(right: 60),
                  child: Text(
                    assignment.description!,
                    style: Styles.textRegular(
                        size: 13, color: ColorConstants.PRIMARY_COLOR),
                  ),
                ),
                _size(height: 20),
                Text(
                  'User notes',
                  style: Styles.textExtraBold(
                      size: 18, color: ColorConstants.PRIMARY_COLOR),
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
                              _attachFile();
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: MediaQuery.of(context).size.width * 0.65,
                              decoration: BoxDecoration(
                                  color: ColorConstants.YELLOW,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 4),
                                child: assignmentDetailProvider.isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Attach File',
                                            style: Styles.textExtraBold(
                                                size: 14,
                                                color: ColorConstants.WHITE),
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
                            children: [
                              Text(
                                file!.path.split("/").last,
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
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
                        _submitAssignment();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: ColorConstants.YELLOW,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
                          child: assignmentDetailProvider.isLoading
                              ? Center(child: CircularProgressIndicator())
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Upload assignment',
                                      style: Styles.textExtraBold(
                                          size: 14,
                                          color: ColorConstants.WHITE),
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
                                  .assignments.maximumMarks,
                              contentId: widget.id,
                            ),
                            isMaintainState: true));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: ColorConstants.PRIMARY_COLOR)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'View submissions',
                          style: Styles.textRegular(
                              color: ColorConstants.PRIMARY_COLOR),
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

  void _submitAssignment() async {
    if (file != null) {
      bool res = await assignmentDetailProvider.uploadAssignment(
          notes: _userNotes.text, path: file!.path, id: widget.id);
      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Assignment submitted successfully")));
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
