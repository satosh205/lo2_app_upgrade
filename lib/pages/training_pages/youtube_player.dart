import 'package:flutter/material.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoScreen extends StatefulWidget {
  final String? url;

  final String? title;

  YouTubeVideoScreen({this.url, this.title});

  @override
  _YouTubeVideoScreenState createState() => _YouTubeVideoScreenState();
}

class _YouTubeVideoScreenState extends State<YouTubeVideoScreen> {
  YoutubePlayerController? _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  void initVideo() async {
    if (widget.url != null) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.url!)!,
        flags: YoutubePlayerFlags(
            forceHD: true, mute: false, autoPlay: true, hideControls: false),
      );
    }
  }

  @override
  void dispose() {
    print('HERE');
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _isFullScreen ? null : AppBar(), body: _portrait());
  }

  Widget _portrait() {
    return _youtubeWidget();
  }

  Widget _youtubeWidget() {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
      ),
      builder: (bc, player) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            player,
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.title ?? "",
                style: Styles.textBold(),
              ),
            )
          ],
        );
      },
      onEnterFullScreen: () {
        setState(() {
          _isFullScreen = true;
        });
      },
      onExitFullScreen: () {
        setState(() {
          _isFullScreen = false;
        });
      },
    );
  }
}
