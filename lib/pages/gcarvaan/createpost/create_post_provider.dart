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

  void updateList(List<String?>? list){
    this.files  = list;
    notifyListeners();
  }

  List<String?>? getFiles(){
    return this.files;
  }

  void updateAtIndex(String? path, int index){
    this.files![index] = path;
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
