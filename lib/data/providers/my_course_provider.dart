import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyCourseProvider extends ChangeNotifier {
  late bool isPaused;
  late bool isMuted;
  late String videoUrl;
  // ignore: unused_field
  late VideoPlayerController _controller;

  MyCourseProvider(VideoPlayerController controller) {
    // this._controller = controller;
    notifyListeners();
  }

  void changeController(VideoPlayerController controller) {
    this._controller = controller;
    notifyListeners();
  }

  void pause() {
    this.isPaused = true;
    notifyListeners();
  }

  void play() {
    this.isPaused = false;
    notifyListeners();
  }

  void mute() {
    this.isMuted = true;
    notifyListeners();
  }

  void unMute() {
    this.isMuted = false;
    notifyListeners();
  }

  void updateValue(bool isPausedNew) {
    isPaused = isPausedNew;
    notifyListeners();
  }

  void changeUrl(String url) {
    this.videoUrl = url;
    notifyListeners();
  }
}
