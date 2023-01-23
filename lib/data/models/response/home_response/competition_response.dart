import 'dart:convert';

CompetitionResponse? competitionResponseFromJson(String str) => CompetitionResponse.fromJson(json.decode(str));

String competitionResponseToJson(CompetitionResponse? data) => json.encode(data!.toJson());

class CompetitionResponse {
    CompetitionResponse({
        this.status,
        this.data,
        this.error,
    });

    int? status;
    List<Competition?>? data;
    List<dynamic>? error;

    factory CompetitionResponse.fromJson(Map<String, dynamic> json) => CompetitionResponse(
        status: json["status"],
        data: json["data"] == null ? [] : List<Competition?>.from(json["data"]!.map((x) => Competition.fromJson(x))),
        error: json["error"] == null ? [] : List<dynamic>.from(json["error"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())),
        "error": error == null ? [] : List<dynamic>.from(error!.map((x) => x)),
    };
}

class Competition {
    Competition({
        this.id,
        this.parentId,
        this.categoryId,
        this.sessionId,
        this.level,
        this.name,
        this.description,
        this.image,
        this.startDate,
        this.endDate,
        this.duration,
        this.createdBy,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.organizationId,
        this.isGlobalProgram,
        this.registrationNeedApproval,
        this.assignedRuleId,
        this.weightage,
        this.certificateId,
        this.certificateNumberPattern,
        this.certificateLatestNumber,
        this.type,
        this.shortCode,
        this.gScore,
        this.subscriptionType,
        this.isStructured,
        this.isCompetition,
        this.terminationDays,
        this.organizedBy,this.competitionLevel, this.isPopular
    });

    int? id;
    dynamic parentId;
    int? categoryId;
    int? sessionId;
    String? level;
    String? name;
    String? description;
    String? image;
    DateTime? startDate;
    DateTime? endDate;
    dynamic duration;
    int? createdBy;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? organizationId;
    int? isGlobalProgram;
    int? registrationNeedApproval;
    dynamic assignedRuleId;
    double? weightage;
    int? certificateId;
    String? certificateNumberPattern;
    int? certificateLatestNumber;
    dynamic type;
    String? shortCode;
    int? gScore;
    dynamic subscriptionType;
    int? isStructured;
    int? isCompetition;
    dynamic terminationDays;
    String? organizedBy;
    String? competitionLevel;
    int? isPopular;



// "organized_by": null,
//             "competition_level": null,
//             "is_popular": null
    factory Competition.fromJson(Map<String, dynamic> json) => Competition(
        id: json["id"],
        parentId: json["parent_id"],
        categoryId: json["category_id"],
        sessionId: json["session_id"],
        level: json["level"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        duration: json["duration"],
        createdBy: json["created_by"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        organizationId: json["organization_id"],
        isGlobalProgram: json["is_global_program"],
        registrationNeedApproval: json["registration_need_approval"],
        assignedRuleId: json["assigned_rule_id"],
        weightage: json["weightage"],
        certificateId: json["certificate_id"],
        certificateNumberPattern: json["certificate_number_pattern"],
        certificateLatestNumber: json["certificate_latest_number"],
        type: json["type"],
        shortCode: json["short_code"],
        gScore: json["g_score"],
        subscriptionType: json["subscription_type"],
        isStructured: json["is_structured"],
        isCompetition: json["is_competition"],
        terminationDays: json["termination_days"],
        organizedBy: json['organized_by'],
      competitionLevel: json['competition_level'],
      isPopular:  json['is_popular']
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "category_id": categoryId,
        "session_id": sessionId,
        "level": level,
        "name": name,
        "description": description,
        "image": image,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "duration": duration,
        "created_by": createdBy,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "organization_id": organizationId,
        "is_global_program": isGlobalProgram,
        "registration_need_approval": registrationNeedApproval,
        "assigned_rule_id": assignedRuleId,
        "weightage": weightage,
        "certificate_id": certificateId,
        "certificate_number_pattern": certificateNumberPattern,
        "certificate_latest_number": certificateLatestNumber,
        "type": type,
        "short_code": shortCode,
        "g_score": gScore,
        "subscription_type": subscriptionType,
        "is_structured": isStructured,
        "is_competition": isCompetition,
        "termination_days": terminationDays,
        "organized_by" : organizedBy,
        "competition_level" : competitionLevel,
        "is_popular" : isPopular
    };
}
