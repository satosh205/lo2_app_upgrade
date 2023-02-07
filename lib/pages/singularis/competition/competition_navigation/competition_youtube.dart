import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CompetitionYoutubePlayer extends StatefulWidget {
  final videoUrl;
  const CompetitionYoutubePlayer({Key? key, this.videoUrl}) : super(key: key);

  @override
  State<CompetitionYoutubePlayer> createState() => _CompetitionYoutubePlayerState();
}

class _CompetitionYoutubePlayerState extends State<CompetitionYoutubePlayer> {
  @override
  void initState() {
            SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    super.initState();
  }
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: YoutubePlayer(controller: YoutubePlayerController(initialVideoId: YoutubePlayer.convertUrlToId('${widget.videoUrl}')!))),);
  }
}