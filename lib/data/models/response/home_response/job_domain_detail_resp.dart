

import 'dart:convert';

JobDomainResponse jobDomainResponseFromJson(String str) => JobDomainResponse.fromJson(json.decode(str));

String jobDomainResponseToJson(JobDomainResponse data) => json.encode(data.toJson());

class JobDomainResponse {
    JobDomainResponse({
         this.status,
         this.data,
         this.error,
    });

    int? status;
    Data? data;
    List<dynamic>? error;

    factory JobDomainResponse.fromJson(Map<String, dynamic> json) => JobDomainResponse(
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
        required this.list,
        required this.graphText,
        required this.graphArr,
    });

    List<ListElement> list;
    String graphText;
    List<List<dynamic>> graphArr;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
        graphText: json["graphText"],
        graphArr: List<List<dynamic>>.from(json["graphArr"].map((x) => List<dynamic>.from(x.map((x) => x)))),
    );

    Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "graphText": graphText,
        "graphArr": List<dynamic>.from(graphArr.map((x) => List<dynamic>.from(x.map((x) => x)))),
    };
}

class ListElement {
    ListElement({
        required this.id,
        required this.title,
        required this.description,
        required this.status,
        required this.experience,
        required this.location,
        required this.salary,
        required this.growth,
        required this.growthType,
        required this.companyName,
        required this.domainName,
    });

    int id;
    String title;
    String description;
    String status;
    int experience;
    String location;
    String salary;
    String growth;
    String growthType;
    String companyName;
    String domainName;

    factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        experience: json["experience"],
        location: json["location"],
        salary: json["salary"],
        growth: json["growth"],
        growthType: json["growth_type"],
        companyName: json["company_name"],
        domainName: json["domain_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "status": status,
        "experience": experience,
        "location": location,
        "salary": salary,
        "growth": growth,
        "growth_type": growthType,
        "company_name": companyName,
        "domain_name": domainName,
    };
}
