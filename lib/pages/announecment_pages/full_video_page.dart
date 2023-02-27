import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:open_filex/open_filex.dart';
//import 'package:open_file_safe/open_file_safe.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class FullContentPage extends StatefulWidget {
  String? resourcePath, contentType;
  int? updatedAt;
  bool isLandscape;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FullContentPage(
      {this.resourcePath,
      this.contentType,
      this.isLandscape = false,
      this.updatedAt});

  @override
  _FullContentPageState createState() => _FullContentPageState();
}

class _FullContentPageState extends State<FullContentPage> {
  VideoPlayerController? _controller;
  bool _isLoading = false;
  String? localPath;

  @override
  void initState() {
    if (widget.contentType == '2') {
      _controller = VideoPlayerController.network(widget.resourcePath!);
      _controller!.addListener(() {
        setState(() {});
      });
      _controller!.setLooping(true);
      _controller!.initialize().then((_) => setState(() {}));
      _controller!.play();
    }
    print(
        "http://drive.google.com/viewerng/viewer?embedded=true&url=${widget.resourcePath}");
    _isLoading = widget.contentType == '1' || widget.contentType == '13';
    if (_isLoading) {
      _download();
    }
    if (widget.isLandscape)
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    if (_controller != null) _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: widget._scaffoldKey,
        body: Builder(builder: (_context) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  _getAnnouncmentChild(),
                  _getTitleWidget(context),
                ],
              ));
        }),
      ),
    );
  }

  _getTitleWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: ColorConstants.WHITE,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: ColorConstants.DARK_BLUE,
                ),
              )),
          Text(
            "",
            style: Styles.boldWhite(size: 20),
          ),
        ],
      ),
    );
  }

  _getAnnouncmentChild() {
    Log.v(widget.resourcePath);
    if (widget.contentType == '2')
      return _controller!.value.isInitialized
          ? Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller!),
                ControlsOverlay(controller: _controller),
                VideoProgressIndicator(_controller!, allowScrubbing: true),
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
    else if (widget.contentType == '1')
      return _getWebview();
    else if (widget.contentType == '13')
      return _getWebview();
    else
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: PhotoView(
          imageProvider: NetworkImage(widget.resourcePath!),
        ),
      );
  }

  _getWebview() {
    return Center(
        child: _isLoading
            ? Container(
                width: 100,
                height: 100,
                decoration: new BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      Strings.of(context)!.loading!,
                      style: Styles.boldWhite(size: 16),
                    ),
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ColorConstants.WHITE),
                    ),
                  ],
                ),
              )
            : Container());
  }

  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.request().isGranted;
    return permission;
  }

  final Dio _dio = Dio();

  Future<void> _download() async {
    var dir = await getApplicationDocumentsDirectory();
    final isPermissionStatusGranted = await _requestPermissions();
    if (isPermissionStatusGranted) {
      String ext = widget.resourcePath!.split(".").last;
      Log.v("Extention ----- $ext");
      final savePath = path.join(dir.path,
          "${widget.resourcePath?.split("/").last.split(".").first ?? "File"} - ${widget.updatedAt ?? ""}.$ext");
      print(savePath);
      if (await File(savePath).exists()) {
        // if (Platform.isAndroid) {
        Navigator.pop(context);
        //await OpenFile.open(savePath);
        await OpenFilex.open(savePath);
      } else {
        await _startDownload(savePath);
      }
    }
  }

  Future<void> _startDownload(String savePath) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(widget.resourcePath!, savePath,
          onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
      if (response.statusCode == 200) {
        // if (Platform.isAndroid) {
        print(savePath);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
        //await OpenFile.open(savePath);
        await OpenFilex.open(savePath);
      }
      Log.v(savePath);
    } catch (ex) {
      Log.v(ex);
      result['error'] = ex.toString();
    }
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {}
  }
}

class ControlsOverlay extends StatelessWidget {
  const ControlsOverlay({Key? key, this.controller}) : super(key: key);

  final VideoPlayerController? controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller!.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller!.value.isPlaying
                ? controller!.pause()
                : controller!.play();
          },
        ),
      ],
    );
  }
}
