import 'package:flutter/material.dart';

class VideoPlayerProvider extends ChangeNotifier {
  late bool isMute;
  late bool isPlaying = true;
  late bool providerControlEnable = false;
  VideoPlayerProvider(bool isMute) {
    this.isMute = isMute;
    notifyListeners();
  }

  void pause() {
    this.isPlaying = false;

    notifyListeners();
  }

  void enableProviderControl() {
    providerControlEnable = true;
    notifyListeners();
  }

  void disableProivderControl() {
    providerControlEnable = false;
    notifyListeners();
  }

  void play() {
    this.isPlaying = true;
    notifyListeners();
  }

  void mute() {
    this.isMute = true;
    notifyListeners();
  }

  void unMute() {
    this.isMute = false;
    notifyListeners();
  }
}
