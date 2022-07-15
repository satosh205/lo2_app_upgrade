import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:video_player/video_player.dart';

class OfflineVideoScreen extends StatefulWidget {
  final String? url;
  final String? title;
  OfflineVideoScreen({this.url, this.title});

  @override
  _OfflineVideoScreenState createState() => _OfflineVideoScreenState();
}

class _OfflineVideoScreenState extends State<OfflineVideoScreen> {
  // VideoPlayerController _videoController;
  // ChewieController _chewieController;
  // bool _isFullScreen=false;
  // VlcPlayerController _videoPlayerController;
  FlickManager? flickManager;

  bool isLoading = true;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    // if (_isFullScreen==false) {
    //   _chewieController?.dispose();
    //   _videoController?.dispose();
    // }
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlickVideoPlayer(
              flickVideoWithControls: FlickVideoWithControls(
                videoFit: BoxFit.cover,
              ),
              flickManager: flickManager!),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title ?? "",
              style: Styles.textBold(),
            ),
          )
        ],
      ),
    );
  }

  void _getData() async {
    print(widget.url);
    flickManager = FlickManager(
      autoInitialize: true,
      videoPlayerController: VideoPlayerController.network(widget.url!),
    );

    // _videoPlayerController = VideoPlayerController.network(widget.url);
    // print("HEEre1");
    // await _videoPlayerController.initialize();
    // print("HEEre2");
    // _chewieController = ChewieController(
    //     videoPlayerController: _videoPlayerController, autoPlay: true,deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp]);
    // print("HEEre3");
    // setState(() {
    //   isLoading = false;
    // });
  }
}
