import 'package:flutter/material.dart';

class CreatePostProvider extends ChangeNotifier {
  List<String?>? files = [];

  CreatePostProvider(List<String?>? files) {
    if (files != null) {
      this.files = files;
    }

    notifyListeners();
  }

  void addToList(String? path) {
    this.files!.insert(0, path);
    notifyListeners();
  }

  void removeFromList(int index) {
    this.files!.removeAt(index);
    notifyListeners();
  }

  void clearList() {
    this.files!.clear();
    notifyListeners();
  }
}
