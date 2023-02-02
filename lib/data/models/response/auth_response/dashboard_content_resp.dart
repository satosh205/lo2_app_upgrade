// To parse this JSON data, do
//
//     final dashboardContentResponse = dashboardContentResponseFromJson(jsonString);

import 'dart:convert';

/*DashboardContentResponse dashboardContentResponseFromJson(String str) =>
    DashboardContentResponse.fromJson(json.decode(str));

String dashboardContentResponseToJson(DashboardContentResponse data) =>
    json.encode(data.toJson());*/

/*class DashboardContentResponse {
  DashboardContentResponse({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<dynamic>? error;

  factory DashboardContentResponse.fromJson(Map<String, dynamic> json) =>
      DashboardContentResponse(
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
    this.dashboardRecommendedCoursesLimit,
    this.dashboardReelsLimit,
    this.dashboardCarvanLimit,
    this.dashboardFeaturedContentLimit,
    this.dashboardMyCoursesLimit,
    this.dashboardSessionsLimit,
  });

  List<DashboardRecommendedCoursesLimit>? dashboardRecommendedCoursesLimit;
  List<DashboardLimit>? dashboardReelsLimit;
  List<DashboardLimit>? dashboardCarvanLimit;
  List<DashboardFeaturedContentLimit>? dashboardFeaturedContentLimit;
  List<DashboardMyCoursesLimit>? dashboardMyCoursesLimit;
  List<DashboardSessionsLimit>? dashboardSessionsLimit;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        dashboardRecommendedCoursesLimit:
            List<DashboardRecommendedCoursesLimit>.from(
                json["dashboard_recommended_courses_limit"]
                    .map((x) => DashboardRecommendedCoursesLimit.fromJson(x))),
        dashboardReelsLimit: List<DashboardLimit>.from(
            json["dashboard_reels_limit"]
                .map((x) => DashboardLimit.fromJson(x))),
        dashboardCarvanLimit: List<DashboardLimit>.from(
            json["dashboard_carvan_limit"]
                .map((x) => DashboardLimit.fromJson(x))),
        dashboardFeaturedContentLimit: List<DashboardFeaturedContentLimit>.from(
            json["dashboard_featured_content_limit"]
                .map((x) => DashboardFeaturedContentLimit.fromJson(x))),
        dashboardMyCoursesLimit: List<DashboardMyCoursesLimit>.from(
            json["dashboard_my_courses_limit"]
                .map((x) => DashboardMyCoursesLimit.fromJson(x))),
        dashboardSessionsLimit: List<DashboardSessionsLimit>.from(
            json["dashboard_sessions_limit"]
                .map((x) => DashboardSessionsLimit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "dashboard_recommended_courses_limit": List<dynamic>.from(
            dashboardRecommendedCoursesLimit!.map((x) => x.toJson())),
        "dashboard_reels_limit":
            List<dynamic>.from(dashboardReelsLimit!.map((x) => x.toJson())),
        "dashboard_carvan_limit":
            List<dynamic>.from(dashboardCarvanLimit!.map((x) => x.toJson())),
        "dashboard_featured_content_limit": List<dynamic>.from(
            dashboardFeaturedContentLimit!.map((x) => x.toJson())),
        "dashboard_my_courses_limit":
            List<dynamic>.from(dashboardMyCoursesLimit!.map((x) => x.toJson())),
        "dashboard_sessions_limit":
            List<dynamic>.from(dashboardSessionsLimit!.map((x) => x.toJson())),
      };
}

class DashboardLimit {
  DashboardLimit({
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
    this.dimension,
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
    this.multiFileUploadsDimension,
    this.thumbnailUrl,
    this.isAttempt,
    this.userSubmittedFile,
    this.userSubmittedMultipleFile,
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
  int? likeCount;
  int? commentCount;
  int? programContentId;
  int? startDate;
  int? endDate;
  int? isMultilingual;
  int? visibilityValue;
  int? visibility;
  Dimension? dimension;
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
  List<dynamic>? multiFileUploadsCount;
  List<dynamic>? multiFileUploadsDimension;
  String? thumbnailUrl;
  int? isAttempt;
  String? userSubmittedFile;
  List<dynamic>? userSubmittedMultipleFile;

  factory DashboardLimit.fromJson(Map<String, dynamic> json) => DashboardLimit(
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
        commentCount:
            json["comment_count"] == null ? null : json["comment_count"],
        programContentId: json["program_content_id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        isMultilingual: json["is_multilingual"],
        visibilityValue: json["visibility_value"],
        visibility: json["visibility"],
        dimension: Dimension.fromJson(json["dimension"]),
        multiFileUploads: List<String>.from(json["multi_file_uploads"].map((x) => x)),
        viewCount: json["view_count"],
        multipleFileUpload: json["multiple_file_upload"],
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        profileImage: json["profile_image"],
        userStatus: json["user_status"],
        userLikeTrackingsId: json["user_like_trackings_id"],
        userLiked: json["user_liked"],
        resourceType: json["resource_type"],
        multiFileUploadsCount:
            List<dynamic>.from(json["multi_file_uploads_count"].map((x) => x)),
        multiFileUploadsDimension: json["multi_file_uploads_dimension"] == null
            ? null
            : List<dynamic>.from(
                json["multi_file_uploads_dimension"].map((x) => x)),
        thumbnailUrl: json["thumbnail_url"],
        isAttempt: json["is_attempt"],
        userSubmittedFile: json["user_submitted_file"],
        userSubmittedMultipleFile: List<dynamic>.from(
            json["user_submitted_multiple_file"].map((x) => x)),
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
        "comment_count": commentCount == null ? null : commentCount,
        "program_content_id": programContentId,
        "start_date": startDate,
        "end_date": endDate,
        "is_multilingual": isMultilingual,
        "visibility_value": visibilityValue,
        "visibility": visibility,
        "dimension": dimension?.toJson(),
        "multi_file_uploads":
            List<dynamic>.from(multiFileUploads!.map((x) => x)),
        "view_count": viewCount,
        "multiple_file_upload": multipleFileUpload,
        "user_id": userId,
        "name": name,
        "email": email,
        "profile_image": profileImage,
        "user_status": userStatus,
        "user_like_trackings_id": userLikeTrackingsId,
        "user_liked": userLiked,
        "resource_type": resourceType,
        "multi_file_uploads_count":
            List<dynamic>.from(multiFileUploadsCount!.map((x) => x)),
        "multi_file_uploads_dimension": multiFileUploadsDimension == null
            ? null
            : List<dynamic>.from(multiFileUploadsDimension!.map((x) => x)),
        "thumbnail_url": thumbnailUrl,
        "is_attempt": isAttempt,
        "user_submitted_file": userSubmittedFile,
        "user_submitted_multiple_file":
            List<dynamic>.from(userSubmittedMultipleFile!.map((x) => x)),
      };
}

class Dimension {
  Dimension({
    this.height,
    this.width,
  });

  int? height;
  int? width;

  factory Dimension.fromJson(Map<String, dynamic> json) => Dimension(
        height: json["height"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "width": width,
      };
}

class DashboardFeaturedContentLimit {
  DashboardFeaturedContentLimit({
    this.id,
    this.title,
    this.description,
    this.resourcePath,
    this.resourcePathThumbnail,
    this.contentType,
    this.categoryId,
  });

  int? id;
  String? title;
  String? description;
  String? resourcePath;
  String? resourcePathThumbnail;
  String? contentType;
  int? categoryId;

  factory DashboardFeaturedContentLimit.fromJson(Map<String, dynamic> json) =>
      DashboardFeaturedContentLimit(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        resourcePath: json["resource_path"],
        resourcePathThumbnail: json["resource_path_thumbnail"],
        contentType: json["content_type"],
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "resource_path": resourcePath,
        "resource_path_thumbnail": resourcePathThumbnail,
        "content_type": contentType,
        "category_id": categoryId,
      };
}

class DashboardMyCoursesLimit {
  DashboardMyCoursesLimit({
    this.id,
    this.image,
    this.name,
    this.hours,
    this.enrollments,
    this.completion,
  });

  int? id;
  String? image;
  String? name;
  int? hours;
  int? enrollments;
  double? completion;

  factory DashboardMyCoursesLimit.fromJson(Map<String, dynamic> json) =>
      DashboardMyCoursesLimit(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        hours: json["hours"],
        enrollments: json["enrollments"],
        completion: json["completion"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "hours": hours,
        "enrollments": enrollments,
        "completion": completion,
      };
}

class DashboardRecommendedCoursesLimit {
  DashboardRecommendedCoursesLimit({
    this.image,
    this.id,
    this.organizationId,
    this.name,
    this.progName,
    this.description,
    this.progDesc,
    this.isGlobal,
    this.gScore,
    this.viewCount,
    this.categoryId,
    this.categoryName,
    this.regularPrice,
    this.salePrice,
    this.shortCode,
    this.admissionStartDate,
    this.admissionEndDate,
    this.type,
    this.startDate,
    this.endDate,
    this.duration,
    this.contents,
    this.totalCoins,
    this.subscriptionType,
    this.isSubscribed,
    this.approvalStatus,
    this.trainer,
    this.enrolmentCount,
    this.totalView,
    this.completionPer,
  });

  String? image;
  int? id;
  int? organizationId;
  String? name;
  String? progName;
  String? description;
  String? progDesc;
  int? isGlobal;
  int? gScore;
  dynamic viewCount;
  int? categoryId;
  String? categoryName;
  double? regularPrice;
  double? salePrice;
  String? shortCode;
  int? admissionStartDate;
  int? admissionEndDate;
  dynamic type;
  int? startDate;
  int? endDate;
  String? duration;
  String? contents;
  dynamic totalCoins;
  String? subscriptionType;
  bool? isSubscribed;
  String? approvalStatus;
  String? trainer;
  int? enrolmentCount;
  dynamic totalView;
  int? completionPer;

  factory DashboardRecommendedCoursesLimit.fromJson(
          Map<String, dynamic> json) =>
      DashboardRecommendedCoursesLimit(
        image: json["image"],
        id: json["id"],
        organizationId: json["organization_id"],
        name: json["name"],
        progName: json["prog_name"],
        description: json["description"],
        progDesc: json["prog_desc"],
        isGlobal: json["is_global"],
        gScore: json["g_score"] == null ? null : json["g_score"],
        viewCount: json["view_count"],
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        regularPrice:
            json["regular_price"] == null ? null : json["regular_price"],
        salePrice: json["sale_price"] == null ? null : json["sale_price"],
        shortCode: json["short_code"],
        admissionStartDate: json["admission_start_date"],
        admissionEndDate: json["admission_end_date"],
        type: json["type"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        duration: json["duration"],
        contents: json["contents"],
        totalCoins: json["total_coins"],
        subscriptionType: json["subscription_type"],
        isSubscribed: json["is_subscribed"],
        approvalStatus: json["approval_status"],
        trainer: json["trainer"],
        enrolmentCount: json["enrolment_count"],
        totalView: json["total_view"],
        completionPer: json["completion_per"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "id": id,
        "organization_id": organizationId,
        "name": name,
        "prog_name": progName,
        "description": description,
        "prog_desc": progDesc,
        "is_global": isGlobal,
        "g_score": gScore == null ? null : gScore,
        "view_count": viewCount,
        "category_id": categoryId,
        "category_name": categoryName,
        "regular_price": regularPrice == null ? null : regularPrice,
        "sale_price": salePrice == null ? null : salePrice,
        "short_code": shortCode,
        "admission_start_date": admissionStartDate,
        "admission_end_date": admissionEndDate,
        "type": type,
        "start_date": startDate,
        "end_date": endDate,
        "duration": duration,
        "contents": contents,
        "total_coins": totalCoins,
        "subscription_type": subscriptionType,
        "is_subscribed": isSubscribed,
        "approval_status": approvalStatus,
        "trainer": trainer,
        "enrolment_count": enrolmentCount,
        "total_view": totalView,
        "completion_per": completionPer,
      };
}

class DashboardSessionsLimit {
  DashboardSessionsLimit({
    this.id,
    this.contentType,
    this.name,
    this.description,
    this.duration,
    this.fromDate,
    this.trainerName,
    this.programId,
    this.programName,
    this.level,
    this.zoomUrl,
    this.zoomPasskey,
    this.url,
    this.passkey,
    this.callToAction,
    this.endDate,
    this.liveclassStatus,
    this.startTime,
    this.endTime,
  });

  int? id;
  String? contentType;
  String? name;
  String? description;
  int? duration;
  int? fromDate;
  String? trainerName;
  int? programId;
  String? programName;
  String? level;
  String? zoomUrl;
  String? zoomPasskey;
  String? url;
  String? passkey;
  String? callToAction;
  int? endDate;
  String? liveclassStatus;
  String? startTime;
  String? endTime;

  factory DashboardSessionsLimit.fromJson(Map<String, dynamic> json) =>
      DashboardSessionsLimit(
        id: json["id"],
        contentType: json["content_type"],
        name: json["name"],
        description: json["description"],
        duration: json["duration"],
        fromDate: json["from_date"],
        trainerName: json["trainer_name"],
        programId: json["program_id"],
        programName: json["program_name"],
        level: json["level"],
        zoomUrl: json["zoom_url"],
        zoomPasskey: json["zoom_passkey"],
        url: json["url"],
        passkey: json["passkey"] == null ? null : json["passkey"],
        callToAction: json["call_to_action"],
        endDate: json["end_date"],
        liveclassStatus: json["liveclass_status"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content_type": contentType,
        "name": name,
        "description": description,
        "duration": duration,
        "from_date": fromDate,
        "trainer_name": trainerName,
        "program_id": programId,
        "program_name": programName,
        "level": level,
        "zoom_url": zoomUrl,
        "zoom_passkey": zoomPasskey,
        "url": url,
        "passkey": passkey == null ? null : passkey,
        "call_to_action": callToAction,
        "end_date": endDate,
        "liveclass_status": liveclassStatus,
        "start_time": startTime,
        "end_time": endTime,
      };
}*/

class DashboardContentResponse {
  int? status;
  Data? data;
  List<dynamic>? error;

  DashboardContentResponse({
    this.status,
    this.data,
    this.error,
  });

  DashboardContentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] as int?;
    data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null;
    error = json['error'] as List?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status'] = status;
    json['data'] = data?.toJson();
    json['error'] = error;
    return json;
  }
}

class Data {
  List<DashboardRecommendedCoursesLimit>? dashboardRecommendedCoursesLimit;
  List<DashboardReelsLimit>? dashboardReelsLimit;
  List<DashboardCarvanLimit>? dashboardCarvanLimit;
  List<DashboardFeaturedContentLimit>? dashboardFeaturedContentLimit;
  List<DashboardMyCoursesLimit>? dashboardMyCoursesLimit;
  List<DashboardSessionsLimit>? dashboardSessionsLimit;

  Data({
    this.dashboardRecommendedCoursesLimit,
    this.dashboardReelsLimit,
    this.dashboardCarvanLimit,
    this.dashboardFeaturedContentLimit,
    this.dashboardMyCoursesLimit,
    this.dashboardSessionsLimit,
  });

  Data.fromJson(Map<String, dynamic> json) {
    dashboardRecommendedCoursesLimit = (json['dashboard_recommended_courses_limit'] as List?)?.map((dynamic e) => DashboardRecommendedCoursesLimit.fromJson(e as Map<String,dynamic>)).toList();
    dashboardReelsLimit = (json['dashboard_reels_limit'] as List?)?.map((dynamic e) => DashboardReelsLimit.fromJson(e as Map<String,dynamic>)).toList();
    dashboardCarvanLimit = (json['dashboard_carvan_limit'] as List?)?.map((dynamic e) => DashboardCarvanLimit.fromJson(e as Map<String,dynamic>)).toList();
    dashboardFeaturedContentLimit = (json['dashboard_featured_content_limit'] as List?)?.map((dynamic e) => DashboardFeaturedContentLimit.fromJson(e as Map<String,dynamic>)).toList();
    dashboardMyCoursesLimit = (json['dashboard_my_courses_limit'] as List?)?.map((dynamic e) => DashboardMyCoursesLimit.fromJson(e as Map<String,dynamic>)).toList();
    dashboardSessionsLimit = (json['dashboard_sessions_limit'] as List?)?.map((dynamic e) => DashboardSessionsLimit.fromJson(e as Map<String,dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['dashboard_recommended_courses_limit'] = dashboardRecommendedCoursesLimit?.map((e) => e.toJson()).toList();
    json['dashboard_reels_limit'] = dashboardReelsLimit?.map((e) => e.toJson()).toList();
    json['dashboard_carvan_limit'] = dashboardCarvanLimit?.map((e) => e.toJson()).toList();
    json['dashboard_featured_content_limit'] = dashboardFeaturedContentLimit?.map((e) => e.toJson()).toList();
    json['dashboard_my_courses_limit'] = dashboardMyCoursesLimit?.map((e) => e.toJson()).toList();
    json['dashboard_sessions_limit'] = dashboardSessionsLimit?.map((e) => e.toJson()).toList();
    return json;
  }
}

class DashboardRecommendedCoursesLimit {
  String? image;
  int? id;
  int? organizationId;
  String? name;
  String? progName;
  String? description;
  String? progDesc;
  int? isGlobal;
  int? gScore;
  dynamic viewCount;
  int? categoryId;
  String? categoryName;
  double? regularPrice;
  double? salePrice;
  String? shortCode;
  int? admissionStartDate;
  int? admissionEndDate;
  dynamic type;
  int? startDate;
  int? endDate;
  String? duration;
  String? contents;
  dynamic totalCoins;
  String? subscriptionType;
  bool? isSubscribed;
  String? approvalStatus;
  String? trainer;
  int? enrolmentCount;
  dynamic totalView;
  int? completionPer;

  DashboardRecommendedCoursesLimit({
    this.image,
    this.id,
    this.organizationId,
    this.name,
    this.progName,
    this.description,
    this.progDesc,
    this.isGlobal,
    this.gScore,
    this.viewCount,
    this.categoryId,
    this.categoryName,
    this.regularPrice,
    this.salePrice,
    this.shortCode,
    this.admissionStartDate,
    this.admissionEndDate,
    this.type,
    this.startDate,
    this.endDate,
    this.duration,
    this.contents,
    this.totalCoins,
    this.subscriptionType,
    this.isSubscribed,
    this.approvalStatus,
    this.trainer,
    this.enrolmentCount,
    this.totalView,
    this.completionPer,
  });

  DashboardRecommendedCoursesLimit.fromJson(Map<String, dynamic> json) {
    image = json['image'] as String?;
    id = json['id'] as int?;
    organizationId = json['organization_id'] as int?;
    name = json['name'] as String?;
    progName = json['prog_name'] as String?;
    description = json['description'] as String?;
    progDesc = json['prog_desc'] as String?;
    isGlobal = json['is_global'] as int?;
    gScore = json['g_score'] as int?;
    viewCount = json['view_count'];
    categoryId = json['category_id'] as int?;
    categoryName = json['category_name'] as String?;
    regularPrice = json['regular_price'] as double?;
    salePrice = json['sale_price'] as double?;
    shortCode = json['short_code'] as String?;
    admissionStartDate = json['admission_start_date'] as int?;
    admissionEndDate = json['admission_end_date'] as int?;
    type = json['type'];
    startDate = json['start_date'] as int?;
    endDate = json['end_date'] as int?;
    duration = json['duration'] as String?;
    contents = json['contents'] as String?;
    totalCoins = json['total_coins'];
    subscriptionType = json['subscription_type'] as String?;
    isSubscribed = json['is_subscribed'] as bool?;
    approvalStatus = json['approval_status'] as String?;
    trainer = json['trainer'] as String?;
    enrolmentCount = json['enrolment_count'] as int?;
    totalView = json['total_view'];
    completionPer = json['completion_per'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['image'] = image;
    json['id'] = id;
    json['organization_id'] = organizationId;
    json['name'] = name;
    json['prog_name'] = progName;
    json['description'] = description;
    json['prog_desc'] = progDesc;
    json['is_global'] = isGlobal;
    json['g_score'] = gScore;
    json['view_count'] = viewCount;
    json['category_id'] = categoryId;
    json['category_name'] = categoryName;
    json['regular_price'] = regularPrice;
    json['sale_price'] = salePrice;
    json['short_code'] = shortCode;
    json['admission_start_date'] = admissionStartDate;
    json['admission_end_date'] = admissionEndDate;
    json['type'] = type;
    json['start_date'] = startDate;
    json['end_date'] = endDate;
    json['duration'] = duration;
    json['contents'] = contents;
    json['total_coins'] = totalCoins;
    json['subscription_type'] = subscriptionType;
    json['is_subscribed'] = isSubscribed;
    json['approval_status'] = approvalStatus;
    json['trainer'] = trainer;
    json['enrolment_count'] = enrolmentCount;
    json['total_view'] = totalView;
    json['completion_per'] = completionPer;
    return json;
  }
}

class DashboardReelsLimit {
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
  int? likeCount;
  int? programContentId;
  int? startDate;
  int? endDate;
  int? isMultilingual;
  int? visibilityValue;
  int? visibility;
  //Dimension? dimension;
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
  List<dynamic>? multiFileUploadsCount;
  String? thumbnailUrl;
  int? isAttempt;
  String? userSubmittedFile;
  List<dynamic>? userSubmittedMultipleFile;

  DashboardReelsLimit({
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
    this.programContentId,
    this.startDate,
    this.endDate,
    this.isMultilingual,
    this.visibilityValue,
    this.visibility,
    //this.dimension,
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
    this.thumbnailUrl,
    this.isAttempt,
    this.userSubmittedFile,
    this.userSubmittedMultipleFile,
  });

  DashboardReelsLimit.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] as String?;
    description = json['description'] as String?;
    createdAt = json['created_at'] as int?;
    createdBy = json['created_by'] as int?;
    updatedAt = json['updated_at'] as int?;
    updatedBy = json['updated_by'] as int?;
    status = json['status'] as String?;
    parentId = json['parent_id'] as int?;
    categoryId = json['category_id'] as int?;
    contentType = json['content_type'] as String?;
    resourcePath = json['resource_path'] as String?;
    language = json['language'] as String?;
    tag = json['tag'];
    likeCount = json['like_count'] as int?;
    programContentId = json['program_content_id'] as int?;
    startDate = json['start_date'] as int?;
    endDate = json['end_date'] as int?;
    isMultilingual = json['is_multilingual'] as int?;
    visibilityValue = json['visibility_value'] as int?;
    visibility = json['visibility'] as int?;
    //dimension = (json['dimension'] as Map<String,dynamic>?) != null ? Dimension.fromJson(json['dimension'] as Map<String,dynamic>) : null;
    multiFileUploads = (json['multi_file_uploads'] as List?)?.map((dynamic e) => e as String).toList();
    viewCount = json['view_count'] as int?;
    multipleFileUpload = json['multiple_file_upload'];
    userId = json['user_id'] as int?;
    name = json['name'] as String?;
    email = json['email'] as String?;
    profileImage = json['profile_image'] as String?;
    userStatus = json['user_status'] as String?;
    userLikeTrackingsId = json['user_like_trackings_id'];
    userLiked = json['user_liked'] as int?;
    resourceType = json['resource_type'] as String?;
    multiFileUploadsCount = json['multi_file_uploads_count'] as List?;
    thumbnailUrl = json['thumbnail_url'] as String?;
    isAttempt = json['is_attempt'] as int?;
    userSubmittedFile = json['user_submitted_file'] as String?;
    userSubmittedMultipleFile = json['user_submitted_multiple_file'] as List?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['title'] = title;
    json['description'] = description;
    json['created_at'] = createdAt;
    json['created_by'] = createdBy;
    json['updated_at'] = updatedAt;
    json['updated_by'] = updatedBy;
    json['status'] = status;
    json['parent_id'] = parentId;
    json['category_id'] = categoryId;
    json['content_type'] = contentType;
    json['resource_path'] = resourcePath;
    json['language'] = language;
    json['tag'] = tag;
    json['like_count'] = likeCount;
    json['program_content_id'] = programContentId;
    json['start_date'] = startDate;
    json['end_date'] = endDate;
    json['is_multilingual'] = isMultilingual;
    json['visibility_value'] = visibilityValue;
    json['visibility'] = visibility;
    //json['dimension'] = dimension?.toJson();
    json['multi_file_uploads'] = multiFileUploads;
    json['view_count'] = viewCount;
    json['multiple_file_upload'] = multipleFileUpload;
    json['user_id'] = userId;
    json['name'] = name;
    json['email'] = email;
    json['profile_image'] = profileImage;
    json['user_status'] = userStatus;
    json['user_like_trackings_id'] = userLikeTrackingsId;
    json['user_liked'] = userLiked;
    json['resource_type'] = resourceType;
    json['multi_file_uploads_count'] = multiFileUploadsCount;
    json['thumbnail_url'] = thumbnailUrl;
    json['is_attempt'] = isAttempt;
    json['user_submitted_file'] = userSubmittedFile;
    json['user_submitted_multiple_file'] = userSubmittedMultipleFile;
    return json;
  }
}

class Dimension {
  int? height;
  int? width;

  Dimension({
    this.height,
    this.width,
  });

  Dimension.fromJson(Map<String, dynamic> json) {
    height = json['height'] as int?;
    width = json['width'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['height'] = height;
    json['width'] = width;
    return json;
  }
}

class DashboardCarvanLimit {
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
  int? likeCount;
  int? commentCount;
  int? programContentId;
  int? startDate;
  int? endDate;
  int? isMultilingual;
  int? visibilityValue;
  int? visibility;
  Dimension? dimension;
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
  List<dynamic>? multiFileUploadsCount;
  List<dynamic>? multiFileUploadsDimension;
  String? thumbnailUrl;
  int? isAttempt;
  String? userSubmittedFile;
  List<dynamic>? userSubmittedMultipleFile;

  DashboardCarvanLimit({
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
    this.dimension,
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
    this.multiFileUploadsDimension,
    this.thumbnailUrl,
    this.isAttempt,
    this.userSubmittedFile,
    this.userSubmittedMultipleFile,
  });

  DashboardCarvanLimit.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] as String?;
    description = json['description'] as String?;
    createdAt = json['created_at'] as int?;
    createdBy = json['created_by'] as int?;
    updatedAt = json['updated_at'] as int?;
    updatedBy = json['updated_by'] as int?;
    status = json['status'] as String?;
    parentId = json['parent_id'] as int?;
    categoryId = json['category_id'] as int?;
    contentType = json['content_type'] as String?;
    resourcePath = json['resource_path'] as String?;
    language = json['language'] as String?;
    tag = json['tag'];
    likeCount = json['like_count'] as int?;
    commentCount = json['comment_count'] as int?;
    programContentId = json['program_content_id'] as int?;
    startDate = json['start_date'] as int?;
    endDate = json['end_date'] as int?;
    isMultilingual = json['is_multilingual'] as int?;
    visibilityValue = json['visibility_value'] as int?;
    visibility = json['visibility'] as int?;
    dimension = (json['dimension'] as Map<String,dynamic>?) != null ? Dimension.fromJson(json['dimension'] as Map<String,dynamic>) : null;
    multiFileUploads = (json['multi_file_uploads'] as List?)?.map((dynamic e) => e as String).toList();
    viewCount = json['view_count'] as int?;
    multipleFileUpload = json['multiple_file_upload'];
    userId = json['user_id'] as int?;
    name = json['name'] as String?;
    email = json['email'] as String?;
    profileImage = json['profile_image'] as String?;
    userStatus = json['user_status'] as String?;
    userLikeTrackingsId = json['user_like_trackings_id'];
    userLiked = json['user_liked'] as int?;
    resourceType = json['resource_type'] as String?;
    multiFileUploadsCount = json['multi_file_uploads_count'] as List?;
    multiFileUploadsDimension = json['multi_file_uploads_dimension'] as List?;
    thumbnailUrl = json['thumbnail_url'] as String?;
    isAttempt = json['is_attempt'] as int?;
    userSubmittedFile = json['user_submitted_file'] as String?;
    userSubmittedMultipleFile = json['user_submitted_multiple_file'] as List?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['title'] = title;
    json['description'] = description;
    json['created_at'] = createdAt;
    json['created_by'] = createdBy;
    json['updated_at'] = updatedAt;
    json['updated_by'] = updatedBy;
    json['status'] = status;
    json['parent_id'] = parentId;
    json['category_id'] = categoryId;
    json['content_type'] = contentType;
    json['resource_path'] = resourcePath;
    json['language'] = language;
    json['tag'] = tag;
    json['like_count'] = likeCount;
    json['comment_count'] = commentCount;
    json['program_content_id'] = programContentId;
    json['start_date'] = startDate;
    json['end_date'] = endDate;
    json['is_multilingual'] = isMultilingual;
    json['visibility_value'] = visibilityValue;
    json['visibility'] = visibility;
    json['dimension'] = dimension?.toJson();
    json['multi_file_uploads'] = multiFileUploads;
    json['view_count'] = viewCount;
    json['multiple_file_upload'] = multipleFileUpload;
    json['user_id'] = userId;
    json['name'] = name;
    json['email'] = email;
    json['profile_image'] = profileImage;
    json['user_status'] = userStatus;
    json['user_like_trackings_id'] = userLikeTrackingsId;
    json['user_liked'] = userLiked;
    json['resource_type'] = resourceType;
    json['multi_file_uploads_count'] = multiFileUploadsCount;
    json['multi_file_uploads_dimension'] = multiFileUploadsDimension;
    json['thumbnail_url'] = thumbnailUrl;
    json['is_attempt'] = isAttempt;
    json['user_submitted_file'] = userSubmittedFile;
    json['user_submitted_multiple_file'] = userSubmittedMultipleFile;
    return json;
  }
}

/*class Dimension {
  int? height;
  int? width;

  Dimension({
    this.height,
    this.width,
  });

  Dimension.fromJson(Map<String, dynamic> json) {
    height = json['height'] as int?;
    width = json['width'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['height'] = height;
    json['width'] = width;
    return json;
  }
}*/

class DashboardFeaturedContentLimit {
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
  String? resourcePathThumbnail;
  String? language;
  dynamic tag;
  dynamic totalLikes;
  int? programContentId;
  dynamic template;
  int? startDate;
  int? endDate;
  int? isMultilingual;
  int? visibilityValue;
  int? visibility;
  String? multiFileUploads;
  dynamic multipleFileUpload;
  int? viewCount;
  int? likeCount;
  int? commentCount;
  int? isFeatured;
  dynamic userLikeTrackingsId;
  dynamic actionUrl;
  String? youtubeUrl;

  DashboardFeaturedContentLimit({
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
    this.resourcePathThumbnail,
    this.language,
    this.tag,
    this.totalLikes,
    this.programContentId,
    this.template,
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
    this.youtubeUrl,
  });

  DashboardFeaturedContentLimit.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] as String?;
    description = json['description'] as String?;
    createdAt = json['created_at'] as int?;
    createdBy = json['created_by'] as int?;
    updatedAt = json['updated_at'] as int?;
    updatedBy = json['updated_by'] as int?;
    status = json['status'] as String?;
    parentId = json['parent_id'] as int?;
    categoryId = json['category_id'] as int?;
    contentType = json['content_type'] as String?;
    resourcePath = json['resource_path'] as String?;
    resourcePathThumbnail = json['resource_path_thumbnail'] as String?;
    language = json['language'] as String?;
    tag = json['tag'];
    totalLikes = json['total_likes'];
    programContentId = json['program_content_id'] as int?;
    template = json['template'];
    startDate = json['start_date'] as int?;
    endDate = json['end_date'] as int?;
    isMultilingual = json['is_multilingual'] as int?;
    visibilityValue = json['visibility_value'] as int?;
    visibility = json['visibility'] as int?;
    multiFileUploads = json['multi_file_uploads'] as String?;
    multipleFileUpload = json['multiple_file_upload'];
    viewCount = json['view_count'] as int?;
    likeCount = json['like_count'] as int?;
    commentCount = json['comment_count'] as int?;
    isFeatured = json['is_featured'] as int?;
    userLikeTrackingsId = json['user_like_trackings_id'];
    actionUrl = json['action_url'];
    youtubeUrl = json['youtube_url'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['title'] = title;
    json['description'] = description;
    json['created_at'] = createdAt;
    json['created_by'] = createdBy;
    json['updated_at'] = updatedAt;
    json['updated_by'] = updatedBy;
    json['status'] = status;
    json['parent_id'] = parentId;
    json['category_id'] = categoryId;
    json['content_type'] = contentType;
    json['resource_path'] = resourcePath;
    json['resource_path_thumbnail'] = resourcePathThumbnail;
    json['language'] = language;
    json['tag'] = tag;
    json['total_likes'] = totalLikes;
    json['program_content_id'] = programContentId;
    json['template'] = template;
    json['start_date'] = startDate;
    json['end_date'] = endDate;
    json['is_multilingual'] = isMultilingual;
    json['visibility_value'] = visibilityValue;
    json['visibility'] = visibility;
    json['multi_file_uploads'] = multiFileUploads;
    json['multiple_file_upload'] = multipleFileUpload;
    json['view_count'] = viewCount;
    json['like_count'] = likeCount;
    json['comment_count'] = commentCount;
    json['is_featured'] = isFeatured;
    json['user_like_trackings_id'] = userLikeTrackingsId;
    json['action_url'] = actionUrl;
    json['youtube_url'] = youtubeUrl;
    return json;
  }
}

class DashboardMyCoursesLimit {
  int? id;
  String? image;
  String? name;
  int? hours;
  int? enrollments;
  double? completion;

  DashboardMyCoursesLimit({
    this.id,
    this.image,
    this.name,
    this.hours,
    this.enrollments,
    this.completion,
  });

  DashboardMyCoursesLimit.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    image = json['image'] as String?;
    name = json['name'] as String?;
    hours = json['hours'] as int?;
    enrollments = json['enrollments'] as int?;
    completion = json['completion'] ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['image'] = image;
    json['name'] = name;
    json['hours'] = hours;
    json['enrollments'] = enrollments;
    json['completion'] = completion;
    return json;
  }
}

class DashboardSessionsLimit {
  int? id;
  String? contentType;
  String? name;
  String? description;
  int? duration;
  int? fromDate;
  String? trainerName;
  int? programId;
  String? programName;
  String? level;
  dynamic zoomUrl;
  dynamic zoomPasskey;
  String? url;
  String? callToAction;
  int? endDate;
  String? liveclassStatus;
  String? startTime;
  String? endTime;

  DashboardSessionsLimit({
    this.id,
    this.contentType,
    this.name,
    this.description,
    this.duration,
    this.fromDate,
    this.trainerName,
    this.programId,
    this.programName,
    this.level,
    this.zoomUrl,
    this.zoomPasskey,
    this.url,
    this.callToAction,
    this.endDate,
    this.liveclassStatus,
    this.startTime,
    this.endTime,
  });

  DashboardSessionsLimit.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    contentType = json['content_type'] as String?;
    name = json['name'] as String?;
    description = json['description'] as String?;
    duration = json['duration'] as int?;
    fromDate = json['from_date'] as int?;
    trainerName = json['trainer_name'] as String?;
    programId = json['program_id'] as int?;
    programName = json['program_name'] as String?;
    level = json['level'] as String?;
    zoomUrl = json['zoom_url'];
    zoomPasskey = json['zoom_passkey'];
    url = json['url'] as String?;
    callToAction = json['call_to_action'] as String?;
    endDate = json['end_date'] as int?;
    liveclassStatus = json['liveclass_status'] as String?;
    startTime = json['start_time'] as String?;
    endTime = json['end_time'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['content_type'] = contentType;
    json['name'] = name;
    json['description'] = description;
    json['duration'] = duration;
    json['from_date'] = fromDate;
    json['trainer_name'] = trainerName;
    json['program_id'] = programId;
    json['program_name'] = programName;
    json['level'] = level;
    json['zoom_url'] = zoomUrl;
    json['zoom_passkey'] = zoomPasskey;
    json['url'] = url;
    json['call_to_action'] = callToAction;
    json['end_date'] = endDate;
    json['liveclass_status'] = liveclassStatus;
    json['start_time'] = startTime;
    json['end_time'] = endTime;
    return json;
  }
}