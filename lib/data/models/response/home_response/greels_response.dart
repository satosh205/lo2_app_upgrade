import 'dart:convert';

import 'package:flutter/material.dart';

GReelsPostResponse gReelsPostResponseFromJson(String str) =>
    GReelsPostResponse.fromJson(json.decode(str));

String gReelsPostResponseToJson(GReelsPostResponse data) =>
    json.encode(data.toJson());

class GReelsPostResponse {
  GReelsPostResponse({
    this.status,
    this.data,
    this.error,
    this.name,
    this.founded,
    this.members,
  });

  int? status;
  Data? data;
  List<dynamic>? error;
  String? name;
  int? founded;
  List<String>? members;

  factory GReelsPostResponse.fromJson(Map<String, dynamic> json) =>
      GReelsPostResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null
            ? null
            : List<dynamic>.from(json["error"].map((x) => x)),
        name: json["name"] == null ? null : json["name"],
        founded: json["founded"] == null ? null : json["founded"],
        members: json["members"] == null
            ? null
            : List<String>.from(json["members"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data!.toJson(),
        "error":
            error == null ? null : List<dynamic>.from(error!.map((x) => x)),
        "name": name == null ? null : name,
        "founded": founded == null ? null : founded,
        "members":
            members == null ? null : List<dynamic>.from(members!.map((x) => x)),
      };
}

class Data {
  Data({
    this.list,
  });

  List<GReelsElement>? list;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<GReelsElement>.from(
            json["list"].map((x) => GReelsElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class GReelsElement extends ChangeNotifier {
  GReelsElement(
      {this.id,
      this.title,
      this.description,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.status,
      this.parentId,
      this.categoryId,
      this.contentType,
      this.resourcePath,
      this.language,
      this.tag,
      this.likeCount,
      this.programContentId,
      this.startDate,
      this.endDate,
      this.isMultilingual,
      this.visibilityValue,
      this.visibility,
      this.multiFileUploads,
      this.viewCount,
      this.multipleFileUpload,
      this.userId,
      this.name,
      this.email,
      this.profileImage,
      this.userLikeTrackingsId,
      this.userLiked,
      this.resourceType,
      this.multiFileUploadsCount,
      this.isAttempt,
      this.userSubmittedFile,
      this.userSubmittedMultipleFile,
      this.thumbnailUrl,
      this.userStatus});

  int? id;
  String? title;
  String? description;
  int? createdAt;
  int? createdBy;
  int? updatedAt;
  int? updatedBy;
  String? status;
  int? parentId;
  int? categoryId;
  String? contentType;
  String? resourcePath;
  String? language;
  String? tag;
  int? likeCount;
  int? programContentId;
  String? userStatus;
  int? startDate;
  int? endDate;
  int? isMultilingual;
  int? visibilityValue;
  int? visibility;
  List<String>? multiFileUploads;
  int? viewCount;
  dynamic multipleFileUpload;
  int? userId;
  String? name;
  String? email;
  String? profileImage;
  int? userLikeTrackingsId;
  int? userLiked;
  String? resourceType;
  List<dynamic>? multiFileUploadsCount;
  int? isAttempt;
  String? userSubmittedFile;
  List<dynamic>? userSubmittedMultipleFile;
  String? thumbnailUrl;

  factory GReelsElement.fromJson(Map<String, dynamic> json) => GReelsElement(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        updatedAt: json["updated_at"],
        updatedBy: json["updated_by"],
        status: json["status"],
        userStatus: json['user_status'],
        parentId: json["parent_id"],
        categoryId: json["category_id"],
        contentType: json["content_type"],
        resourcePath: json["resource_path"],
        language: json["language"],
        tag: json["tag"] == null ? null : json["tag"],
        likeCount: json["like_count"] == null ? null : json["like_count"],
        programContentId: json["program_content_id"],
        startDate: json["start_date"] == null ? null : json["start_date"],
        endDate: json["end_date"] == null ? null : json["end_date"],
        isMultilingual: json["is_multilingual"],
        visibilityValue: json["visibility_value"],
        visibility: json["visibility"],
        multiFileUploads:
            List<String>.from(json["multi_file_uploads"].map((x) => x)),
        viewCount: json["view_count"],
        multipleFileUpload: json["multiple_file_upload"],
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        profileImage:
            json["profile_image"] == null ? null : json["profile_image"],
        userLikeTrackingsId: json["user_like_trackings_id"] == null
            ? null
            : json["user_like_trackings_id"],
        userLiked: json["user_liked"],
        resourceType:
            json["resource_type"] == null ? null : json["resource_type"],
        multiFileUploadsCount:
            List<dynamic>.from(json["multi_file_uploads_count"].map((x) => x)),
        isAttempt: json["is_attempt"],
        userSubmittedFile: json["user_submitted_file"],
        userSubmittedMultipleFile: List<dynamic>.from(
            json["user_submitted_multiple_file"].map((x) => x)),
        thumbnailUrl:
            json["thumbnail_url"] == null ? null : json["thumbnail_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "created_at": createdAt,
        "created_by": createdBy,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "status": status,
        "user_status": userStatus,
        "parent_id": parentId,
        "category_id": categoryId,
        "content_type": contentType,
        "resource_path": resourcePath,
        "language": language,
        "tag": tag == null ? null : tag,
        "like_count": likeCount == null ? null : likeCount,
        "program_content_id": programContentId,
        "start_date": startDate == null ? null : startDate,
        "end_date": endDate == null ? null : endDate,
        "is_multilingual": isMultilingual,
        "visibility_value": visibilityValue,
        "visibility": visibility,
        "multi_file_uploads":
            List<dynamic>.from(multiFileUploads!.map((x) => x)),
        "view_count": viewCount,
        "multiple_file_upload": multipleFileUpload,
        "user_id": userId,
        "name": name,
        "email": email,
        "profile_image": profileImage == null ? null : profileImage,
        "user_like_trackings_id":
            userLikeTrackingsId == null ? null : userLikeTrackingsId,
        "user_liked": userLiked,
        "resource_type": resourceType == null ? null : resourceType,
        "multi_file_uploads_count":
            List<dynamic>.from(multiFileUploadsCount!.map((x) => x)),
        "is_attempt": isAttempt,
        "user_submitted_file": userSubmittedFile,
        "user_submitted_multiple_file":
            List<dynamic>.from(userSubmittedMultipleFile!.map((x) => x)),
        "thumbnail_url": thumbnailUrl == null ? null : thumbnailUrl,
      };
}

class GReelsModel extends ChangeNotifier {
  List<GReelsElement>? _list = [];
  List<GReelsElement>? get list => _list;
  int? currentIndex;
  GReelsModel(List<GReelsElement>? list) {
    this._list = list;
    currentIndex = 0;
    notifyListeners();
  }

  void updateCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void updateList(List<GReelsElement> newData) {
    this._list!.addAll(newData);
    notifyListeners();
  }

  void clear() {
    this._list?.clear();
    notifyListeners();
  }

  void refreshList(List<GReelsElement> list) {
    this._list = list;
    notifyListeners();
  }

  void hidePost(index) {
    _list?.removeAt(index);
    this._list = _list;
    notifyListeners();
  }

  void increaseLikeCount(int postId) {
    for (var i = 0; i < _list!.length; i++) {
      if (_list![i].id == postId) {
        _list![i].likeCount = _list![i].likeCount! + 1;
        _list![i].userLiked = 1;

        notifyListeners();
      }
    }
  }

  //get like count
  int getLikeCount(int postId) {
    for (var i = 0; i < _list!.length; i++) {
      if (_list![i].id == postId) {
        return _list![i].likeCount!;
      }
    }
    return 0;
  }

  int getCurrentIndex() {
    return currentIndex!;
  }

  //check if user liked
  bool isUserLiked(int postId) {
    for (var i = 0; i < _list!.length; i++) {
      if (_list![i].id == postId) {
        if (_list![i].userLiked == 1) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  void decreaseLikeCount(int posdId) {
    for (var i = 0; i < _list!.length; i++) {
      if (_list![i].id == posdId) {
        _list![i].likeCount = _list![i].likeCount! - 1;
        _list![i].userLiked = 0;

        notifyListeners();
      }
    }
  }

//get current post index
  int getCurrentPostIndex(int postId) {
    for (var i = 0; i < _list!.length; i++) {
      if (_list![i].id == postId) {
        return i;
      }
    }
    return 0;
  }

  String? getResourcePath(int contentId) {
    for (var i = 0; i < _list!.length; i++) {
      if (_list![i].id == contentId) {
        return _list![i].resourcePath;
      }
    }
    return null;
  }
}
