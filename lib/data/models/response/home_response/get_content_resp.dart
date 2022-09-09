// To parse this JSON data, do
//
//     final getContentResp = getContentRespFromJson(jsonString);

import 'dart:convert';

GetContentResp getContentRespFromJson(String str) => GetContentResp.fromJson(json.decode(str));

String getContentRespToJson(GetContentResp data) => json.encode(data.toJson());

class GetContentResp {
    GetContentResp({
        this.status,
        this.data,
        this.error,
    });

    int? status;
    Data? data;
    List<dynamic>? error;

    factory GetContentResp.fromJson(Map<String, dynamic> json) => GetContentResp(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        error: List<dynamic>.from(json["error"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "error": List<dynamic>.from(error!.map((x) => x)),
    };
}

class Data {
    Data({
        this.list,
    });

    List<ListData>? list;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<ListData>.from(json["list"].map((x) => ListData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
    };
}

class ListData {
    ListData({
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
        this.actionUrl,
        this.resourceType,
        this.multiFileUploadsCount,
        this.thumbnailUrl,
        this.userLiked,
        this.isAttempt,
        this.userSubmittedFile,
        this.userSubmittedMultipleFile,
        this.template,
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
    int? multipleFileUpload;
    int? viewCount;
    int? likeCount;
    int? commentCount;
    int? isFeatured;
    int? userLikeTrackingsId;
    dynamic actionUrl;
    String? resourceType;
    dynamic multiFileUploadsCount;
    String? thumbnailUrl;
    int? userLiked;
    int? isAttempt;
    String? userSubmittedFile;
    List<String>? userSubmittedMultipleFile;
    String? template;

    factory ListData.fromJson(Map<String, dynamic> json) => ListData(
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
        tag: json["tag"] ,
        totalLikes: json["total_likes"],
        programContentId: json["program_content_id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        isMultilingual: json["is_multilingual"],
        visibilityValue: json["visibility_value"],
        visibility: json["visibility"],
        multiFileUploads: List<String>.from(json["multi_file_uploads"].map((x) => x)),
        multipleFileUpload: json["multiple_file_upload"] == null ? null : json["multiple_file_upload"],
        viewCount: json["view_count"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        isFeatured: json["is_featured"] == null ? null : json["is_featured"],
        userLikeTrackingsId: json["user_like_trackings_id"] == null ? null : json["user_like_trackings_id"],
        actionUrl: json["action_url"],
        resourceType: json["resource_type"] ,
        multiFileUploadsCount: json["multi_file_uploads_count"],
        thumbnailUrl: json["thumbnail_url"],
        userLiked: json["user_liked"],
        isAttempt: json["is_attempt"],
        userSubmittedFile: json["user_submitted_file"],
        userSubmittedMultipleFile: List<String>.from(json["user_submitted_multiple_file"].map((x) => x)),
        template: json["template"] == null ? null : json["template"],
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
        "tag": tag ,
        "total_likes": totalLikes,
        "program_content_id": programContentId,
        "start_date": startDate,
        "end_date": endDate,
        "is_multilingual": isMultilingual,
        "visibility_value": visibilityValue,
        "visibility": visibility,
        "multi_file_uploads": List<dynamic>.from(multiFileUploads!.map((x) => x)),
        "multiple_file_upload": multipleFileUpload == null ? null : multipleFileUpload,
        "view_count": viewCount,
        "like_count": likeCount,
        "comment_count": commentCount,
        "is_featured": isFeatured == null ? null : isFeatured,
        "user_like_trackings_id": userLikeTrackingsId == null ? null : userLikeTrackingsId,
        "action_url": actionUrl,
        "resource_type": resourceType ,
        "multi_file_uploads_count": multiFileUploadsCount,
        "thumbnail_url": thumbnailUrl,
        "user_liked": userLiked,
        "is_attempt": isAttempt,
        "user_submitted_file": userSubmittedFile,
        "user_submitted_multiple_file": List<dynamic>.from(userSubmittedMultipleFile!.map((x) => x)),
        "template": template == null ? null : template,
    };
}

