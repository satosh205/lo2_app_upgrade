import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CompetitionYoutubePlayer extends StatefulWidget {
  final videoUrl;
  final id;
  const CompetitionYoutubePlayer({Key? key, this.videoUrl, this.id}) : super(key: key);

  @override
  State<CompetitionYoutubePlayer> createState() =>
      _CompetitionYoutubePlayerState();
}

class _CompetitionYoutubePlayerState extends State<CompetitionYoutubePlayer> {

 

  bool isLoading = true;
  YoutubePlayerController? _videoPlayerController;
  int currentMin = 0, prevMin = 0;

   void listenVideoChanges() {
    _videoPlayerController?.addListener(() {
      currentMin = _videoPlayerController!.value.position.inMinutes;
      print("currentMin ${currentMin}");
      print("bookmarkTimerPrevious ${prevMin}");
      if (currentMin != 0 && prevMin != currentMin) {
        print("bookmarkTimer ${currentMin}");
        prevMin = currentMin;
        _updateCourseCompletion(currentMin);
      }
    });
  }

  

  @override
  void initState() {
     _updateCourseCompletion(0);

    _videoPlayerController = YoutubePlayerController(
              initialVideoId:
                  YoutubePlayer.convertUrlToId('${widget.videoUrl}')!);
    // _getData(_videoPlayerController);
    listenVideoChanges();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    super.initState();
  }


  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }


  VideoPlayerController getController() {
    return VideoPlayerController.network(widget.videoUrl);
  }

 

  void _updateCourseCompletion(bookmark) async {
    //change bookmark with 25
    print("bookmarkTimer make api ${bookmark}");
    BlocProvider.of<HomeBloc>(context).add(UpdateVideoCompletionEvent(
        bookmark: bookmark, contentId: widget.id));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoutubePlayer(
          controller: _videoPlayerController!),
    );
  }
}
