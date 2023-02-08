
import 'dart:convert';

DomainFilterListResponse domainFilterListResponseFromJson(String str) => DomainFilterListResponse.fromJson(json.decode(str));

String domainFilterListResponseToJson(DomainFilterListResponse data) => json.encode(data.toJson());

class DomainFilterListResponse {
    DomainFilterListResponse({
        this.data,
        this.status,
        this.error,
    });

    Data? data;
    int? status;
    List<dynamic>? error;

    factory DomainFilterListResponse.fromJson(Map<String, dynamic> json) => DomainFilterListResponse(
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
        required this.title,
        required this.description,
        required this.companyId,
        required this.domainId,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.organizationId,
        required this.experience,
        required this.location,
        required this.isRecommended,
        required this.salary,
        required this.growth,
        required this.growthType,
    });

    int id;
    String title;
    String description;
    int companyId;
    int domainId;
    Status status;
    DateTime createdAt;
    DateTime updatedAt;
    int organizationId;
    int experience;
    Location location;
    int isRecommended;
    String salary;
    String growth;
    GrowthType growthType;

    factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        companyId: json["company_id"],
        domainId: json["domain_id"],
        status: statusValues.map[json["status"]]!,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        organizationId: json["organization_id"],
        experience: json["experience"],
        location: locationValues.map[json["location"]]!,
        isRecommended: json["is_recommended"],
        salary: json["salary"],
        growth: json["growth"],
        growthType: growthTypeValues.map[json["growth_type"]]!,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "company_id": companyId,
        "domain_id": domainId,
        "status": statusValues.reverse[status],
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "organization_id": organizationId,
        "experience": experience,
        "location": locationValues.reverse[location],
        "is_recommended": isRecommended,
        "salary": salary,
        "growth": growth,
        "growth_type": growthTypeValues.reverse[growthType],
    };
}

enum GrowthType { UP, DOWN }

final growthTypeValues = EnumValues({
    "down": GrowthType.DOWN,
    "up": GrowthType.UP
});

enum Location { GURUGRAM, NOIDA, GHZ }

final locationValues = EnumValues({
    "GHZ": Location.GHZ,
    "Gurugram": Location.GURUGRAM,
    "Noida": Location.NOIDA
});

enum Status { ACTIVE }

final statusValues = EnumValues({
    "Active": Status.ACTIVE
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
