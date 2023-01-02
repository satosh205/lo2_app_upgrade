// To parse this JSON data, do
//
//     final userJobsListResponse = userJobsListResponseFromJson(jsonString);

import 'dart:convert';

UserJobsListResponse userJobsListResponseFromJson(String str) => UserJobsListResponse.fromJson(json.decode(str));

String userJobsListResponseToJson(UserJobsListResponse data) => json.encode(data.toJson());

class UserJobsListResponse {
  UserJobsListResponse({
    this.list,
    this.status,
    this.error,
  });

  List<ListElement>? list;
  int? status;
  List<dynamic>? error;

  factory UserJobsListResponse.fromJson(Map<String, dynamic> json) => UserJobsListResponse(
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
    status: json["status"],
    error: List<dynamic>.from(json["error"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list!.map((x) => x.toJson())),
    "status": status,
    "error": List<dynamic>.from(error!.map((x) => x)),
  };
}

class ListElement {
  ListElement({
    this.id,
    this.title,
    this.description,
    this.companyId,
    this.domainId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.organizationId,
    this.experience,
    this.location,
    this.isRecommended,
    this.skillNames,
    this.companyName,
    this.domain,
    this.companyThumbnail,
  });

  int? id;
  String? title;
  String? description;
  int? companyId;
  int? domainId;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? organizationId;
  int? experience;
  String? location;
  int? isRecommended;
  String? skillNames;
  String? companyName;
  String? domain;
  String? companyThumbnail;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    companyId: json["company_id"],
    domainId: json["domain_id"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    organizationId: json["organization_id"],
    experience: json["experience"],
    location: json["location"],
    isRecommended: json["is_recommended"] == null ? null : json["is_recommended"],
    skillNames: json["skill_names"],
    companyName: json["company_name"],
    domain: json["domain"],
    companyThumbnail: json["company_thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "company_id": companyId,
    "domain_id": domainId,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "organization_id": organizationId,
    "experience": experience,
    "location": location,
    "is_recommended": isRecommended == null ? null : isRecommended,
    "skill_names": skillNames,
    "company_name": companyName,
    "domain": domain,
    "company_thumbnail": companyThumbnail,
  };
}
