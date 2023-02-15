import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
   bool _showIcon = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        setState(() {});
      })
      ..initialize().then((_) {
        setState(() {});
      });
      _controller?.play();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollEndNotification) {
            final RenderObject? renderObject = context.findRenderObject();
            final RenderAbstractViewport? viewport =
                RenderAbstractViewport.of(renderObject);
            final double offset =
                viewport!.getOffsetToReveal(renderObject!, 0.0).offset;
            print('hello $offset');
            if (offset < 0.0) {
              _controller?.pause();
              _isPlaying = false;
              _showIcon = true;
              Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  _showIcon = false;
                });
              });
            } else {
              _controller?.play();
              _isPlaying = true;
              _showIcon = true;
              Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  _showIcon = false;
                });
              });
            }
          }
          return true;
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              // _isPlaying = !_isPlaying;
              // if (_isPlaying) {
              //   _controller?.play();
              // } else {
              //   _controller?.pause();
              // }



              _isPlaying = !_isPlaying;
              _showIcon = true;
              Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  _showIcon = false;
                });
              });
              if (_isPlaying) {
                _controller?.play();
              } else {
                _controller?.pause();
              }
            });
          },
          child: VisibilityDetector(
              key: ObjectKey(_controller),
              onVisibilityChanged: (visibility) {
                if (visibility.visibleFraction == 0 && this.mounted) {
                  _controller?.pause(); //pausing  functionality
                } else {
                  _controller?.play(); //playing functionality
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    child: AspectRatio(
                      aspectRatio: MediaQuery.of(context).size.width/300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: VideoPlayer(_controller!)),
                    ),
                  ),
                  Align(
                alignment: Alignment.center,
                child: _showIcon
                    ? Icon(
                       _isPlaying ?  Icons.pause :  Icons.play_arrow,
                        size: 50.0,
                        color: Colors.white,
                      )
                    : SizedBox(),
              ),
                ],
              )),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
