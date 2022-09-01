import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/home_request/track_announcement_request.dart';
import 'package:masterg/data/models/request/home_request/user_tracking_activity.dart';
import 'package:masterg/data/models/response/home_response/get_content_resp.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/app_button.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/swayam_pages/announcement_preview_page.dart';
import 'package:masterg/pages/swayam_pages/survey_questions_page.dart';
// import 'package:masterg/pages/training_pages/survey_questions_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/images.dart';
import 'package:masterg/utils/utility.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

// import 'package:masterg/pages/announecment_pages/announcement_preview_page.dart';

import 'full_video_page.dart';

class AnnouncementDetailsPage extends StatefulWidget {
  ListData? announmentData;
  final String? title;

  AnnouncementDetailsPage({this.announmentData, this.title});

  @override
  _AnnouncementDetailsPageState createState() =>
      _AnnouncementDetailsPageState();
}

class _AnnouncementDetailsPageState extends State<AnnouncementDetailsPage> {
  VideoPlayerController? _controller;
  PageController? _pageController;

  var _selected = 0;
  bool _fullScreen = false;

  var _isLoading = false;
  final picker = ImagePicker();
  String? selectedImage;
  FlickManager? _flickManager;

  String _progress = "";

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void initState() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin?.initialize(initSettings,
        onSelectNotification: _onSelectNotification);

    _pageController =
        PageController(viewportFraction: 1, initialPage: 0, keepPage: true);
    super.initState();
    if (widget.announmentData?.contentType == '2' && Platform.isAndroid) {
      // _controller =
      //     VideoPlayerController.network(widget.announmentData.resourcePath);
      // _controller.addListener(() {
      //   setState(() {});
      // });
      // _controller.setLooping(true);
      // _controller.initialize().then((_) => setState(() {}));
      // _controller.play();
      _flickManager = FlickManager(
          videoPlayerController: VideoPlayerController.network(
              '${widget.announmentData?.resourcePath}'));
    }

    trackData();
    _userTrack();
  }

  @override
  void didChangeDependencies() {
    if (widget.title == Strings.of(context)?.announcements) {
      // FirebaseAnalytics().logEvent(name: "announcement_opened", parameters: {
      //   "title": widget.announmentData.title,
      //   "user_id": UserSession.userId
      // });
      // FirebaseAnalytics()
      //     .setCurrentScreen(screenName: "announcement_details_screen");
    } else {
      // FirebaseAnalytics().logEvent(name: "benefit_opened", parameters: {
      //   "title": widget.announmentData.title,
      //   "user_id": UserSession.userId
      // });
      // FirebaseAnalytics()
      //     .setCurrentScreen(screenName: "benefit_details_screen");
    }
    super.didChangeDependencies();
  }

  void trackData() async {
    Log.v(widget.announmentData?.toJson());
    BlocProvider.of<HomeBloc>(context).add(TrackAnnouncementEvent(
        rewardReq: TrackAnnouncementReq(contentId: widget.announmentData?.id)));
  }

  void _userTrack() {
    BlocProvider.of<HomeBloc>(context).add(UserTrackingActivityEvent(
        trackReq: UserTrackingActivity(
            activityType: "page_change",
            context: "",
            activityTime: DateTime.now(),
            device: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is ActivityAttemptState) _handleResponse(state);
        },
        child: Builder(builder: (_context) {
          return _mainContainer();
        }),
      ),
    );
  }

  @override
  void dispose() {
    _flickManager?.dispose();
    super.dispose();
  }

  final key = new GlobalKey<ScaffoldState>();

  _mainContainer() {
    return ScreenWithLoader(
      isLoading: _isLoading,
      body: CommonContainer(
        scafKey: key,
        child: _rowItem(widget.announmentData!),
        title: widget.title,
        isBackShow: true,
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  _rowItem(ListData item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                    backgroundImage: NetworkImage('${item.thumbnailUrl}'),
                    radius: 20.0),
                _size(width: 10),
                Expanded(
                  child: Text(
                    '${item.title}',
                    style: Styles.textBold(
                        size: 18, color: ColorConstants.TEXT_DARK_BLACK),
                  ),
                ),
              ],
            ),
            _size(height: 10),
            _selectedView(),
            _pageView(),
            //_getAnnouncmentChild(),
            _size(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(Images.CLOCK),
                ),
                _size(width: 5),
                Text(
                  Utility.convertDateFromMillis(
                      item.createdAt!, Strings.REQUIRED_DATE_YYYY_MM_DD),
                  style: Styles.textRegular(size: 14),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: item.tag!.isEmpty
                          ? Colors.transparent
                          : ColorConstants.BG_LIGHT_GREY,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: Text(
                    item.tag ?? '',
                    textAlign: TextAlign.center,
                    style: Styles.textBold(
                        size: 12, color: ColorConstants.DAR_GREY),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onLongPress: () {
                final elements = linkify(
                  '${item.description}',
                  options: LinkifyOptions(humanize: false),
                );
                if (elements != null && elements.length > 0) {
                  elements.forEach((element) {
                    if (element.text.contains("http") ||
                        element.text.contains("www")) {
                      Clipboard.setData(new ClipboardData(text: element.text));
                      key.currentState?.showSnackBar(new SnackBar(
                        content: new Text("Link Copied"),
                      ));
                    }
                  });
                }
              },
              child: Linkify(
                onOpen: _onOpen,
                softWrap: true,
                options: LinkifyOptions(humanize: false),
                text: '${item.description}',
                style: Styles.textRegular(
                    size: 18, color: ColorConstants.TEXT_DARK_BLACK),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: widget.announmentData?.contentType == '11' ||
                  widget.announmentData?.contentType == '12',
              child: Container(
                margin: EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    Visibility(
                      child: InkWell(
                        child: Text(
                          (_progress.isEmpty)
                              ? "My Submission (Click here to view)"
                              : _progress,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              color: ColorConstants.PRIMARY_COLOR,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          if (widget.announmentData?.multipleFileUpload == 0 ||
                              widget.announmentData?.multipleFileUpload ==
                                  null) {
                            Navigator.push(
                                context,
                                NextPageRoute(FullContentPage(
                                  resourcePath:
                                      widget.announmentData?.userSubmittedFile,
                                )));
                          } else {
                            Navigator.push(
                                context,
                                NextPageRoute(AnnouncementPreviewPage(
                                  announmentData: widget.announmentData,
                                  title: '${Strings.of(context)?.announcements}',
                                )));
                          }
                        },
                      ),
                      visible: widget.announmentData?.userSubmittedFile !=
                              null &&
                          widget.announmentData!.userSubmittedFile!.isNotEmpty,
                    ),
                    _size(height: 10),
                    AppButton(
                      isEnabled: widget.announmentData?.isAttempt != 1 ||
                          (widget.announmentData?.isAttempt == 1 &&
                              widget.announmentData?.multipleFileUpload == 1 &&
                              widget.announmentData?.userSubmittedMultipleFile
                                      ?.length !=
                                  null &&
                              int.parse('${widget.announmentData?.userSubmittedMultipleFile
                                      !.length}') <
                                  int.parse('${widget
                                      .announmentData?.multiFileUploadsCount}')),


                      title: (widget.announmentData?.isAttempt == 1 &&
                                  widget.announmentData?.multipleFileUpload !=
                                      1) ||
                              (widget.announmentData?.multipleFileUpload == 1 &&
                                  widget.announmentData
                                          ?.userSubmittedMultipleFile?.length !=
                                      null &&
                                  int.parse('${widget.announmentData
                                          ?.userSubmittedMultipleFile?.length}') >=
                                      int.parse('${widget.announmentData
                                          ?.multiFileUploadsCount}'))
                          ? Strings.of(context)?.submitted
                          : (item.contentType == '12')
                              ? Strings.of(context)?.startSurvey
                              : Strings.of(context)?.submit,
                      onTap: () {
                        if (item.contentType == '12') {
                          Log.v(item.toJson().toString());
                          Navigator.push(
                              context,
                              NextPageRoute(SurveyStartPage(
                                type: 1,
                                contentId: item.programContentId!,
                              )));
                        } else
                          showFileChoosePopup();
                      },
                    ),
                    _size(height: 10),
                    if (widget.announmentData?.multipleFileUpload != null)
                      Text(
                        (_progress.isEmpty)
                            ? "maximum ${int.parse('${widget.announmentData?.multiFileUploadsCount}')} files can be uploaded"
                            : _progress,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorConstants.BLACK,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageView() {
    return SizedBox(
        height: 200.0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            itemBuilder: (context, index) {
              return _pageItem(widget.announmentData!.multiFileUploads![index]);
            },
            itemCount: widget.announmentData?.multiFileUploads?.length,
            scrollDirection: Axis.horizontal,
            onPageChanged: (value) {
              setState(() {
                _selected = value;
              });
            },
            controller: _pageController,
          ),
        ));
  }

  Widget _pageItem(String url) {
    print("amit");
    print(widget.announmentData?.contentType);

    if (url.contains('pdf') ||
        url.contains('ppt') ||
        url.contains('pptx') ||
        url.contains('docx') ||
        url.contains('doc'))
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              NextPageRoute(FullContentPage(
                updatedAt: widget.announmentData?.updatedAt,
                resourcePath: url,
                contentType: "1",
              )));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: MediaQuery.of(context).size.height / 2.5,
          alignment: Alignment.center,
          child: widget.announmentData?.thumbnailUrl != null &&
                  widget.announmentData!.thumbnailUrl!.isNotEmpty
              ? Center(
                  child: Icon(
                    Icons.description,
                    color: ColorConstants.PRIMARY_COLOR,
                    size: 60,
                  ),
                )
              : Center(
                  child: Icon(
                    Icons.description,
                    color: ColorConstants.PRIMARY_COLOR,
                    size: 60,
                  ),
                ),
        ),
      );
    else if (url.contains('mp4') || url.contains('youtube'))
      return Container(
        height: MediaQuery.of(context).size.height / 2.5,
        child: InAppWebView(
          // onWebViewCreated: (c) {
          //   _inAppWebViewController = c;
          // },
          initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                mediaPlaybackRequiresUserGesture: true,
                useShouldOverrideUrlLoading: true,
              ),
              ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true, allowsLinkPreview: false)),
          // initialUrlRequest: URLRequest(
          //     url: Uri.parse(widget.announmentData.resourcePath))
          initialUrlRequest: URLRequest(url: Uri.parse(url)),
        ),
      );
    else
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              NextPageRoute(FullContentPage(
                resourcePath: url,
              )));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: MediaQuery.of(context).size.height / 2.5,
          alignment: Alignment.center,
          child: FadeInImage.assetNetwork(
            placeholder: Images.PLACE_HOLDER,
            image: url,
            height: MediaQuery.of(context).size.height / 2.5,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      );
  }

  _selectedView() {
    print("print listing");
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: List.generate(
          widget.announmentData!.multiFileUploads!.length,
          (index) => Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: _selected == index
                    ? ColorConstants.BG_BLUE_BTN
                    : ColorConstants.BLACK,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _size({double height = 20, double width = 0}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {}
  }

  _getAnnouncmentChild() {
    print("amit");
    Log.v(widget.announmentData?.multiFileUploads.toString());
    if (widget.announmentData?.contentType == '2')
      return Platform.isIOS
          ? Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: InAppWebView(
                // onWebViewCreated: (c) {
                //   _inAppWebViewController = c;
                // },
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      mediaPlaybackRequiresUserGesture: true,
                      useShouldOverrideUrlLoading: true,
                    ),
                    ios: IOSInAppWebViewOptions(
                        allowsInlineMediaPlayback: true,
                        allowsLinkPreview: false)),
                // initialUrlRequest: URLRequest(
                //     url: Uri.parse(widget.announmentData.resourcePath))
                initialUrlRequest: URLRequest(
                    url: Uri.parse('${widget.announmentData?.resourcePath}')),
              ),
            )
          : FlickVideoPlayer(flickManager: _flickManager!);
    else if (widget.announmentData?.contentType == '1' ||
        widget.announmentData?.contentType == '13')
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              NextPageRoute(FullContentPage(
                updatedAt: widget.announmentData?.updatedAt,
                resourcePath: widget.announmentData?.resourcePath,
                contentType: widget.announmentData?.contentType,
              )));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: MediaQuery.of(context).size.height / 2.5,
          alignment: Alignment.center,
          child: widget.announmentData?.thumbnailUrl != null &&
                  widget.announmentData!.thumbnailUrl!.isNotEmpty
              ? FadeInImage.assetNetwork(
                  placeholder: Images.PLACE_HOLDER,
                  image:'${ widget.announmentData?.thumbnailUrl}',
                  height: MediaQuery.of(context).size.height / 2.5,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                )
              : Center(
                  child: Icon(
                    Icons.description,
                    color: ColorConstants.PRIMARY_COLOR,
                    size: 60,
                  ),
                ),
        ),
      );
    else
      return Container(
        height: MediaQuery.of(context).size.height / 2.5,
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                NextPageRoute(FullContentPage(
                  resourcePath: widget.announmentData?.resourcePath,
                  contentType: widget.announmentData?.contentType,
                )));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: FadeInImage.assetNetwork(
              placeholder: Images.PLACE_HOLDER,
              image: '${widget.announmentData?.resourcePath}',
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      );
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      // return await DownloadsPathProvider.downloadsDirectory;
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.request().isGranted;
    return permission;
  }

  final Dio _dio = Dio();

 

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'com.perfetti', 'perfetti', 
        priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    await flutterLocalNotificationsPlugin?.show(
        int.parse(id.substring(id.length - 6)), // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress =
            "Download ${(received / total * 100).toStringAsFixed(0) + "%"}";
      });
    }
  }

  void _handleResponse(ActivityAttemptState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          _isLoading = false;
          AlertsWidget.alertWithOkBtn(
              context: context,
              text: state.response?.message,
              onOkClick: () {
                Navigator.pop(context);
              });
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void showFileChoosePopup() {
    //  Utility.hideKeyboard();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        // return object of type Dialog
        return SimpleDialog(
          backgroundColor: ColorConstants.PRIMARY_COLOR,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: ColorConstants.PRIMARY_COLOR,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('${Strings.of(context)?.takeAPicture}',
                            style: Styles.regularWhite(size: 16)),
                      ),
                      onTap: () {
                        _getImages(ImageSource.camera, RetrieveType.image)
                            .then((value) {
                          Navigator.pop(context);
                          if (value == null || value.isEmpty) return;
                          setState(() {
                            selectedImage = value;
                            uploadImage();
                          });
                        });
                      }),
                  InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('${Strings.of(context)?.pickFromGallery}',
                            style: Styles.regularWhite(size: 16)),
                      ),
                      onTap: () async {
                        _getImages(ImageSource.gallery, RetrieveType.image)
                            .then((value) {
                          Navigator.pop(context);
                          if (value == null || value.isEmpty) return;
                          setState(() {
                            selectedImage = value;
                            uploadImage();
                          });
                        });
                      }),
                  InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('${Strings.of(context)?.takeAVideo}',
                            style: Styles.regularWhite(size: 16)),
                      ),
                      onTap: () {
                        _getImages(ImageSource.camera, RetrieveType.video)
                            .then((value) {
                          Navigator.pop(context);
                          if (value == null || value.isEmpty) return;
                          setState(() {
                            selectedImage = value;
                            uploadImage();
                          });
                        });
                      }),
                  InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('${Strings.of(context)?.pickAVideo}',
                            style: Styles.regularWhite(size: 16)),
                      ),
                      onTap: () async {
                        _getImages(ImageSource.gallery, RetrieveType.video)
                            .then((value) {
                          Navigator.pop(context);
                          if (value == null || value.isEmpty) return;
                          setState(() {
                            selectedImage = value;
                            uploadImage();
                          });
                        });
                      }),
                  InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('${Strings.of(context)?.pickAFile}',
                            style: Styles.regularWhite(size: 16)),
                      ),
                      onTap: () {
                        _getFiles().then((value) {
                          Navigator.pop(context);
                          if (value == null || value.isEmpty) return;
                          setState(() {
                            selectedImage = value;
                            uploadImage();
                          });
                        });
                      }),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<String?> _getImages(ImageSource source, RetrieveType type) async {
    final picker = ImagePicker();
    PickedFile? pickedFile = type == RetrieveType.image
        ? await picker.getImage(source: source)
        : await picker.getVideo(
            source: source, maxDuration: Duration(seconds: 20));
    if (pickedFile != null)
      return pickedFile.path;
    else if (Platform.isAndroid) {
      final LostData response = await picker.getLostData();
      if (response.file != null) {
        return response.file?.path;
      }
    }
    return "";
  }

  Future<String?> _getFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File('${result.files.single.path}');
      return file.path;
    }
    return null;
  }

  void uploadImage() {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: Text("Do you want to upload this file?",
                  style: Styles.textBold()),
              content: Container(
                height: 75,
                child: Center(
                    child: Text(
                  "${selectedImage?.split("/").last}",
                  style: Styles.textBold(),
                )),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      BlocProvider.of<HomeBloc>(context).add(
                          ActivityAttemptEvent(
                              filePath: selectedImage,
                              contentId: widget.announmentData?.id,
                              contentType: int.parse(
                                 '${ widget.announmentData?.contentType}')));
                      Navigator.pop(context);
                      setState(() {
                        _isLoading = true;
                      });
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        selectedImage = null;
                      });
                    },
                    child: Text("No")),
              ],
            ));
    // BlocProvider.of<HomeBloc>(context).add(ActivityAttemptEvent(
    //     filePath: selectedImage,
    //     contentId: widget.announmentData.id,
    //     contentType: int.parse(widget.announmentData.contentType)));
  }

  Future<void> _onSelectNotification(String? json) async {
    print("######");
    print(json);
    final obj = jsonDecode(json!);
    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }
}

const _urlLinkifier = UrlLinkifier();
const _emailLinkifier = EmailLinkifier();
const defaultLinkifiers = [_urlLinkifier, _emailLinkifier];

List<LinkifyElement> linkify(
  String text, {
  LinkifyOptions? options,
  List<Linkifier> linkifiers = defaultLinkifiers,
}) {
  var list = <LinkifyElement>[TextElement(text)];

  if (text == null || text.isEmpty) {
    return [];
  }

  if (linkifiers == null || linkifiers.isEmpty) {
    return list;
  }

  options ??= LinkifyOptions();

  linkifiers.forEach((linkifier) {
    list = linkifier.parse(list, options!);
  });

  return list;
}
