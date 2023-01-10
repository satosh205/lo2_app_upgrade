import 'package:flutter/material.dart';

class CreatePostProvider extends ChangeNotifier {
  bool? isUploadingPost;
  List<String?>? files = [];

  CreatePostProvider(List<String?>? files, bool? isUploading) {
   if(isUploadingPost != null)   this.isUploadingPost = isUploading;

    if (files != null) {
      this.files = files;
    }
    print('updating post to ${this.isUploadingPost}');

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

  void postStatus(bool isUploading ){
    this.isUploadingPost = isUploading;
    print('updating post status to ${this.isUploadingPost}');
    notifyListeners();
  }

  bool? getPostStatus(){
    print('updating post status return ${this.isUploadingPost}');
    return this.isUploadingPost;
  }
}
