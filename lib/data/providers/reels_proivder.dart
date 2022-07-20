import 'package:flutter/material.dart';

class ReelsProvider extends ChangeNotifier {
  late bool isPaused;
  late bool isMuted;
  late bool volumneIconInView = false;
  ReelsProvider(bool isPaused, isMuted) {
    this.isPaused = isPaused;
    this.isMuted = isMuted;
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

  void showVolumnIcon() {
    this.volumneIconInView = true;
    notifyListeners();
  }

  void hideVolumneIcon() {
    this.volumneIconInView = false;
    notifyListeners();
  }
}
