import 'dart:convert';

import 'package:flutter/material.dart';

GCarvaanPostResponse gCarvaanPostResponseFromJson(String str) =>
    GCarvaanPostResponse.fromJson(json.decode(str));

String gCarvaanPostResponseToJson(GCarvaanPostResponse data) =>
    json.encode(data.toJson());

class GCarvaanPostResponse {
  GCarvaanPostResponse({
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

  factory GCarvaanPostResponse.fromJson(Map<String, dynamic> json) =>
      GCarvaanPostResponse(
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

  // void updateCommentCount(int i) {
  //   data.list[i].commentCount++;
  //   notifyListeners();
  // }
}

class Data {
  Data({
    this.list,
  });

  List<GCarvaanPostElement>? list;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<GCarvaanPostElement>.from(
            json["list"].map((x) => GCarvaanPostElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class GCarvaanPostElement extends ChangeNotifier {
  GCarvaanPostElement({
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
    this.likeCount,
    this.commentCount,
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
    this.userStatus,
    this.userLikeTrackingsId,
    this.userLiked,
    this.resourceType,
    this.multiFileUploadsCount,
    this.isAttempt,
    this.userSubmittedFile,
    this.userSubmittedMultipleFile,
    this.dimension,this.multiFileUploadsDimension,this.size
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
  dynamic tag;
  dynamic likeCount;
  dynamic commentCount;
  int? programContentId;
  dynamic startDate;
  dynamic endDate;
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
  String? userStatus;
  dynamic userLikeTrackingsId;
  int? userLiked;
  String? resourceType;
  dynamic multiFileUploadsCount;
  int? isAttempt;
  String? userSubmittedFile;
  List<dynamic>? userSubmittedMultipleFile;
  Dimension? dimension;
  List<Dimension>? multiFileUploadsDimension;
  Size? size;

  factory GCarvaanPostElement.fromJson(Map<String, dynamic> json) =>
      GCarvaanPostElement(
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
        tag: json["tag"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        programContentId: json["program_content_id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        isMultilingual: json["is_multilingual"],
        visibilityValue: json["visibility_value"],
        visibility: json["visibility"],
        multiFileUploads:
            List<String>.from(json["multi_file_uploads"].map((x) => x)),
        viewCount: json["view_count"] == null ? null : json["view_count"],
        multipleFileUpload: json["multiple_file_upload"],
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        profileImage: json["profile_image"],
        userStatus: json['user_status'],
        userLikeTrackingsId: json["user_like_trackings_id"],
        userLiked: json["user_liked"],
        resourceType:
            json["resource_type"] == null ? null : json["resource_type"],
        multiFileUploadsCount: json["multi_file_uploads_count"],
        isAttempt: json["is_attempt"],
        userSubmittedFile: json["user_submitted_file"],
        dimension: Dimension.fromJson(json["dimension"]),
         multiFileUploadsDimension: List<Dimension>.from(json["multi_file_uploads_dimension"].map((x) => Dimension.fromJson(x))),
       
        userSubmittedMultipleFile: List<dynamic>.from(
            json["user_submitted_multiple_file"].map((x) => x)),
        size: json["size"],

            
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
        "tag": tag,
        "like_count": likeCount,
        "comment_count": commentCount,
        "program_content_id": programContentId,
        "start_date": startDate,
        "end_date": endDate,
        "is_multilingual": isMultilingual,
        "visibility_value": visibilityValue,
        "visibility": visibility,
        "multi_file_uploads":
            List<dynamic>.from(multiFileUploads!.map((x) => x)),
        "view_count": viewCount == null ? null : viewCount,
        "multiple_file_upload": multipleFileUpload,
        "user_id": userId,
        "name": name,
        "email": email,
        "profile_image": profileImage,
        "user_status" : userStatus,
        "user_like_trackings_id": userLikeTrackingsId,
        "user_liked": userLiked,
        "resource_type": resourceType == null ? null : resourceType,
        "multi_file_uploads_count": multiFileUploadsCount,
        "is_attempt": isAttempt,
        "user_submitted_file": userSubmittedFile,
        "user_submitted_multiple_file":
            List<dynamic>.from(userSubmittedMultipleFile!.map((x) => x)),

             "dimension": dimension == null ? null : dimension?.toJson(),
             "multi_file_uploads_dimension": List<dynamic>.from(multiFileUploadsDimension!.map((x) => x.toJson())),
        "size": size,

      };
}


class Dimension {
    Dimension({
        this.height,
        this.width,
    });

    int? height;
    int? width;

    factory Dimension.fromJson(Map<String, dynamic>? json) => Dimension(
        height: json?["height"],
        width: json?["width"],
    );

    Map<String, dynamic> toJson() => {
        "height": height,
        "width": width,
    };
}


class GCarvaanListModel extends ChangeNotifier {
  List<GCarvaanPostElement>? _list = [];
  List<GCarvaanPostElement>? get list => _list;
  GCarvaanListModel(List<GCarvaanPostElement>? list) {
    this._list = list;
    notifyListeners();
  }

  void updateList(List<GCarvaanPostElement> newData) {
    this._list!.addAll(newData);

       var seen = Set<GCarvaanPostElement>();
List<GCarvaanPostElement> uniquelist = _list!.where((element) => seen.add(element)).toList();

 this._list = uniquelist;

    notifyListeners();
  }

  void refreshList(List<GCarvaanPostElement> list) {
    this._list = list;
     var seen = Set<GCarvaanPostElement>();
List<GCarvaanPostElement> uniquelist = _list!.where((element) => seen.add(element)).toList();

 this._list = uniquelist ;
    notifyListeners();
  }

  void updateComment(postId, value) {
    _list!.where((element) => element.id == postId).first.commentCount = value;
    notifyListeners();
  }

  void incrementCommentCount(postId) {
    _list!.where((element) => element.id == postId).first.commentCount++;
    notifyListeners();
  }

  int getLikeCount(index) {
    return _list![index].likeCount;
  }

  void incrementLike(index) {
    _list![index].likeCount++;
    notifyListeners();
  }
  
  void updateSize(Size size, int index){
    _list![index].size = size;
    notifyListeners();
  }
  double? getHeight(postId) {
   return  _list!.where((element) => element.id == postId).first.size?.height;
    
    // return _list![index].size?.height;
  }
  double? getWidth(index) {
    return _list![index].size?.width;
  }
  void decrementLike(index) {
    _list![index].likeCount--;
    notifyListeners();
  }

  bool isLiked(index) {
    return _list![index].userLiked == 1;
  }

  void updateIsLiked(index, int liked) {
    _list![index].userLiked = liked;
    notifyListeners();
  }

  void hidePost(index) {
    _list?.removeAt(index);
    this._list = _list;
    notifyListeners();
  }
}
