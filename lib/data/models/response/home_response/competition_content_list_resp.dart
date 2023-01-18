import 'dart:convert';

CompetitionContentListResponse? competitionContentListResponseFromJson(
        String str) =>
    CompetitionContentListResponse.fromJson(json.decode(str));

String competitionContentListResponseToJson(
        CompetitionContentListResponse? data) =>
    json.encode(data!.toJson());

class CompetitionContentListResponse {
  CompetitionContentListResponse({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<dynamic>? error;

  factory CompetitionContentListResponse.fromJson(Map<String, dynamic> json) =>
      CompetitionContentListResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        error: json["error"] == null
            ? []
            : List<dynamic>.from(json["error"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
        "error": error == null ? [] : List<dynamic>.from(error!.map((x) => x)),
      };
}

class Data {
  Data({
    this.list,
  });

  List<ListElement?>? list;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: json["list"] == null
            ? []
            : List<ListElement?>.from(
                json["list"]!.map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x!.toJson())),
      };
}

class ListElement {
  ListElement({
    this.image,
    this.id,
    this.authorId,
    this.referenceId,
    this.referenceAuthorId,
    this.moduleId,
    this.title,
    this.content,
    this.description,
    this.createdAt,
    this.contentType,
    this.pageCount,
    this.expectedDuration,
    this.endDate,
    this.startDate,
    this.completionPercentage,
    this.userId,
    this.gScore,
  });

  String? image;
  int? id;
  int? authorId;
  int? referenceId;
  int? referenceAuthorId;
  int? moduleId;
  String? title;
  String? content;
  String? description;
  DateTime? createdAt;
  String? contentType;
  int? pageCount;
  int? expectedDuration;
  DateTime? endDate;
  DateTime? startDate;
  dynamic completionPercentage;
  dynamic userId;
  dynamic gScore;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        image: json["image"] ?? "",
        id: json["id"],
        authorId: json["author_id"],
        referenceId: json["reference_id"],
        referenceAuthorId: json["reference_author_id"],
        moduleId: json["module_id"],
        title: json["title"],
        content: json["content"] ?? "",
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        contentType: json["content_type"],
        pageCount: json["page_count"],
        expectedDuration: json["expected_duration"],
        endDate: DateTime.parse(json["end_date"]),
        startDate: DateTime.parse(json["start_date"]),
        completionPercentage: json["completion_percentage"],
        userId: json["user_id"],
        gScore: json["g_score"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "id": id,
        "author_id": authorId,
        "reference_id": referenceId,
        "reference_author_id": referenceAuthorId,
        "module_id": moduleId,
        "title": title,
        "content": content,
        "description": description,
        "created_at": createdAt,
        "content_type": contentType,
        "page_count": pageCount,
        "expected_duration": expectedDuration,
        "end_date": endDate,
        "start_date": startDate,
        "completion_percentage": completionPercentage,
        "user_id": userId,
        "g_score": gScore,
      };
}
