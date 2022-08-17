import 'package:flutter/material.dart';

class VideoPlayerProvider extends ChangeNotifier {
  late bool isMute;
  late bool isPlaying = true;
  late bool providerControlEnable = false;
  VideoPlayerProvider(bool isMute) {
    this.isMute = isMute;
    notifyListeners();
  }

  Future<bool> pause() async {
    this.isPlaying = false;
    notifyListeners();
    return true;

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
