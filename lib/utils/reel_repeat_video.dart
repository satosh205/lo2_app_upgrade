import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReelRepeatVideo extends StatefulWidget {
  final String videoUrl;

  ReelRepeatVideo({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _ReelRepeatVideoState createState() => _ReelRepeatVideoState();
}

class _ReelRepeatVideoState extends State<ReelRepeatVideo>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
   bool _showIcon = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
       if (_controller!.value.position.inSeconds >=
            _controller!.value.duration.inSeconds) {
          _controller?.seekTo(Duration(seconds: 0));
          _controller?.play();
        }
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
    return NotificationListener<ScrollNotification>(
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
              children: [
                SizedBox(
                  height:double.infinity,
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
