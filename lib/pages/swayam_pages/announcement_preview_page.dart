import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/models/request/home_request/track_announcement_request.dart';
import 'package:masterg/data/models/response/home_response/get_content_resp.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
// import 'package:masterg/pages/training_pages/survey_questions_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/images.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'full_video_page.dart';

class AnnouncementPreviewPage extends StatefulWidget {
  ListData? announmentData;
  final String? title;

  AnnouncementPreviewPage({this.announmentData, this.title});

  @override
  _AnnouncementPreviewPageState createState() =>
      _AnnouncementPreviewPageState();
}

class _AnnouncementPreviewPageState extends State<AnnouncementPreviewPage> {
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

  @override
  Widget build(BuildContext context) {
    return _mainContainer();
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
        title: "Content Previews",
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
                   '${ item.title}',
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
              return _pageItem(
                  widget.announmentData!.userSubmittedMultipleFile![index]);
            },
            itemCount: widget.announmentData?.userSubmittedMultipleFile?.length,
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
    if (url.contains('pdf'))
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
              ? FadeInImage.assetNetwork(
                  placeholder: Images.PLACE_HOLDER,
                  image:
                      "https://as2.ftcdn.net/v2/jpg/01/03/75/43/500_F_103754394_xSNhdDOKFusz9Vrb8ZZNLY8SXSwLfaIT.jpg",
                  height: MediaQuery.of(context).size.height / 1.5,
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
          child: widget.announmentData?.thumbnailUrl != null &&
                  widget.announmentData!.thumbnailUrl!.isNotEmpty
              ? FadeInImage.assetNetwork(
                  placeholder: Images.PLACE_HOLDER,
                  image: url,
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
  }

  _selectedView() {
    print("print listing");
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: List.generate(
          widget.announmentData!.userSubmittedMultipleFile!.length,
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
                  image: '${widget.announmentData?.thumbnailUrl}',
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

  Future<String> _getImages(ImageSource source, RetrieveType type) async {
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
        return response.file!.path;
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
                                  '${widget.announmentData?.contentType}')));
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
