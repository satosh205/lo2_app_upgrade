import 'dart:convert';

import 'package:flutter/material.dart';

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
        this.organizedBy,
        this.competitionLevel,
        this.isPopular,
        this.jobStatus,
        this.domainName,
        this.location,
        this.experience,
        this.skillNames,
    });

    int? id;
    dynamic parentId;
    int? categoryId;
    int? sessionId;
    String? level;
    String? name;
    String? description;
    String? image;
    String? startDate;
    String? endDate;
    dynamic duration;
    int? createdBy;
    String? status;
    String? createdAt;
    String? updatedAt;
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
    String? jobStatus;
    String? domainName;
    String? location;
    String? experience;
    String? skillNames;



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
        startDate: json["start_date"],
        endDate: json["end_date"],
        duration: json["duration"],
        createdBy: json["created_by"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
        gScore: json["score"],
        subscriptionType: json["subscription_type"],
        isStructured: json["is_structured"],
        isCompetition: json["is_competition"],
        terminationDays: json["termination_days"],
        organizedBy: json['organized_by'],
        competitionLevel: json['competition_level'],
        isPopular:  json['is_popular'],
        domainName:  json['domain_name'],
        location:  json['location'],
        experience:  json['experience'],
        skillNames:  json['skill_names'],
        jobStatus:  json['job_status'] != null ? json['job_status'] : null,
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
        "start_date": startDate,
        "end_date": endDate,
        "duration": duration,
        "created_by": createdBy,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
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
        "score": gScore,
        "subscription_type": subscriptionType,
        "is_structured": isStructured,
        "is_competition": isCompetition,
        "termination_days": terminationDays,
        "organized_by" : organizedBy,
        "competition_level" : competitionLevel,
        "is_popular" : isPopular,
        "job_status" : jobStatus,
        "domain_name" : domainName,
        "location" : location,
        "experience" : experience,
        "skill_names" : skillNames,

    };
}



class CompetitionResponseProvider extends ChangeNotifier{
  List<Competition?> list = [];
   
  CompetitionResponseProvider(List<Competition?>? list){
    this.list = list!;
    notifyListeners();
  }

  void updateAppliedStatus(int index){
    this.list[index]?.jobStatus = 'Applied';
    notifyListeners();
  }
  
  
}