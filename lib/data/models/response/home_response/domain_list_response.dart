

import 'dart:convert';

DomainListResponse domainListResponseFromJson(String str) => DomainListResponse.fromJson(json.decode(str));

String domainListResponseToJson(DomainListResponse data) => json.encode(data.toJson());

class DomainListResponse {
    DomainListResponse({
        this.data,
        this.status,
        this.error,
    });

    Data? data;
    int? status;
    List<dynamic>? error;

    factory DomainListResponse.fromJson(Map<String, dynamic> json) => DomainListResponse(
        data: Data.fromJson(json["data"]),
        status: json["status"],
        error: List<dynamic>.from(json["error"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "status": status,
        "error": List<dynamic>.from(error!.map((x) => x)),
    };
}

class Data {
    Data({
        required this.list,
    });

    List<ListElement> list;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
    };
}

class ListElement {
    ListElement({
        required this.id,
        required this.name,
        required this.description,
        this.background,
        required this.status,
        required this.organizationId,
        required this.createdAt,
        required this.updatedAt,
        required this.numberOfJobs,
        required this.growth,
        required this.growthType,
        this.skillId,
    });

    int id;
    String name;
    String description;
    dynamic background;
    String status;
    int organizationId;
    DateTime createdAt;
    DateTime updatedAt;
    String numberOfJobs;
    String growth;
    String growthType;
    dynamic skillId;

    factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        background: json["background"],
        status: json["status"],
        organizationId: json["organization_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        numberOfJobs: json["number_of_jobs"],
        growth: json["growth"],
        growthType: json["growth_type"],
        skillId: json["skill_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "background": background,
        "status": status,
        "organization_id": organizationId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "number_of_jobs": numberOfJobs,
        "growth": growth,
        "growth_type": growthType,
        "skill_id": skillId,
    };
}
