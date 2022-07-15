// To parse this JSON data, do
//
//     final joyConentListResponse = joyConentListResponseFromJson(jsonString);
//     final album = albumFromJson(jsonString);
//     final track = trackFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

JoyConentListResponse joyConentListResponseFromJson(String str) =>
    JoyConentListResponse.fromJson(json.decode(str));

String joyConentListResponseToJson(JoyConentListResponse data) =>
    json.encode(data.toJson());

class JoyConentListResponse {
  JoyConentListResponse({
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

  factory JoyConentListResponse.fromJson(Map<String, dynamic> json) =>
      JoyConentListResponse(
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

  List<JoyContentListElement>? list;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<JoyContentListElement>.from(
            json["list"].map((x) => JoyContentListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class JoyContentListElement extends ChangeNotifier {
  JoyContentListElement({
    this.id,
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
    this.totalLikes,
    this.programContentId,
    this.startDate,
    this.endDate,
    this.isMultilingual,
    this.visibilityValue,
    this.visibility,
    this.multiFileUploads,
    this.multipleFileUpload,
    this.viewCount,
    this.likeCount,
    this.commentCount,
    this.isFeatured,
    this.userLikeTrackingsId,
    this.multiFileUploadsCount,
    this.thumbnailUrl,
    this.userLiked,
    this.isAttempt,
    this.userSubmittedFile,
    this.userSubmittedMultipleFile,
    this.resourceType,
  });

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
  dynamic totalLikes;
  int? programContentId;
  int? startDate;
  int? endDate;
  int? isMultilingual;
  int? visibilityValue;
  int? visibility;
  List<String>? multiFileUploads;
  dynamic multipleFileUpload;
  int? viewCount;
  dynamic likeCount;
  dynamic commentCount;
  int? isFeatured;
  dynamic userLikeTrackingsId;
  List<dynamic>? multiFileUploadsCount;
  String? thumbnailUrl;
  int? userLiked;
  int? isAttempt;
  String? userSubmittedFile;
  List<dynamic>? userSubmittedMultipleFile;
  String? resourceType;

  factory JoyContentListElement.fromJson(Map<String, dynamic> json) =>
      JoyContentListElement(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        updatedAt: json["updated_at"],
        updatedBy: json["updated_by"],
        status: json["status"],
        parentId: json["parent_id"],
        categoryId: json["category_id"],
        contentType: json["content_type"],
        resourcePath: json["resource_path"],
        language: json["language"],
        tag: json["tag"] == null ? null : json["tag"],
        totalLikes: json["total_likes"],
        programContentId: json["program_content_id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        isMultilingual: json["is_multilingual"],
        visibilityValue: json["visibility_value"],
        visibility: json["visibility"],
        multiFileUploads:
            List<String>.from(json["multi_file_uploads"].map((x) => x)),
        multipleFileUpload: json["multiple_file_upload"],
        viewCount: json["view_count"] == null ? null : json["view_count"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        isFeatured: json["is_featured"],
        userLikeTrackingsId: json["user_like_trackings_id"],
        multiFileUploadsCount:
            List<dynamic>.from(json["multi_file_uploads_count"].map((x) => x)),
        thumbnailUrl: json["thumbnail_url"],
        userLiked: json["user_liked"],
        isAttempt: json["is_attempt"],
        userSubmittedFile: json["user_submitted_file"],
        userSubmittedMultipleFile: List<dynamic>.from(
            json["user_submitted_multiple_file"].map((x) => x)),
        resourceType:
            json["resource_type"] == null ? null : json["resource_type"],
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
        "parent_id": parentId,
        "category_id": categoryId,
        "content_type": contentType,
        "resource_path": resourcePath,
        "language": language,
        "tag": tag == null ? null : tag,
        "total_likes": totalLikes,
        "program_content_id": programContentId,
        "start_date": startDate,
        "end_date": endDate,
        "is_multilingual": isMultilingual,
        "visibility_value": visibilityValue,
        "visibility": visibility,
        "multi_file_uploads":
            List<dynamic>.from(multiFileUploads!.map((x) => x)),
        "multiple_file_upload": multipleFileUpload,
        "view_count": viewCount == null ? null : viewCount,
        "like_count": likeCount,
        "comment_count": commentCount,
        "is_featured": isFeatured,
        "user_like_trackings_id": userLikeTrackingsId,
        "multi_file_uploads_count":
            List<dynamic>.from(multiFileUploadsCount!.map((x) => x)),
        "thumbnail_url": thumbnailUrl,
        "user_liked": userLiked,
        "is_attempt": isAttempt,
        "user_submitted_file": userSubmittedFile,
        "user_submitted_multiple_file":
            List<dynamic>.from(userSubmittedMultipleFile!.map((x) => x)),
        "resource_type": resourceType == null ? null : resourceType,
      };
}

class JoyContentListModel extends ChangeNotifier {
  List<JoyContentListElement>? _list = [];
  List<JoyContentListElement>? get list => _list;
  JoyContentListModel(List<JoyContentListElement>? list) {
    this._list = list;
    notifyListeners();
  }

  void updateList(List<JoyContentListElement> newData) {
    this._list!.addAll(newData);
    notifyListeners();
  }

  void refreshList(List<JoyContentListElement> list) {
    this._list = list;
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

  void decreaseLikeCount(int posdId) {
    for (var i = 0; i < _list!.length; i++) {
      if (_list![i].id == posdId) {
        _list![i].likeCount = _list![i].likeCount! - 1;
        _list![i].userLiked = 0;
        notifyListeners();
      }
    }
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
