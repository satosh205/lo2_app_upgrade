// import 'dart:convert';

// PortfolioResponse portfolioResponseFromJson(String str) =>
//     PortfolioResponse.fromJson(json.decode(str));

// String portfolioResponseToJson(PortfolioResponse data) =>
//     json.encode(data.toJson());

// class PortfolioResponse {
//   PortfolioResponse({
//     required this.status,
//     required this.data,
//     required this.error,
//   });

//   int status;
//   Data data;
//   List<dynamic> error;

//   factory PortfolioResponse.fromJson(Map<String, dynamic> json) =>
//       PortfolioResponse(
//         status: json["status"],
//         data: Data.fromJson(json["data"]),
//         error: List<dynamic>.from(json["error"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data.toJson(),
//         "error": List<dynamic>.from(error.map((x) => x)),
//       };
// }

// class Data {
//   Data({
//     required this.profileCompletionPer,
//     required this.userResume,
//     required this.lookingForInternship,
//     required this.lookingForPlacement,
//     required this.portfolio,
//     required this.skill,
//     required this.contactNo,
//     required this.message,
//     required this.facebook,
//     required this.insta,
//     required this.linkedin,
//     required this.siteUrl,
//     required this.bee,
//     required this.other,
//     required this.twitter,
//     required this.pinterest,
//     required this.education,
//     required this.experience,
//     required this.certificate,
//     required this.extraActivities,
//     required this.fileBaseurl
//   });

//   int profileCompletionPer;
//   String userResume;
//   String lookingForInternship;
//   String lookingForPlacement;
//   List<Portfolio> portfolio;
//   List<Skill> skill;
//   String contactNo;
//   String message;
//   String facebook;
//   String insta;
//   String linkedin;
//   String siteUrl;
//   String bee;
//   String other;
//   String twitter;
//   String pinterest;
//   List<CommonProfession> education;
//   List<CommonProfession> experience;
//   List<CommonProfession> certificate;
//   List<CommonProfession> extraActivities;
//   String? fileBaseurl;

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         profileCompletionPer: json["profile_completion_per"],
//         userResume: json["user_resume"],
//         lookingForInternship: json["looking_for_internship"],
//         lookingForPlacement: json["looking_for_placement"],
//         portfolio: List<Portfolio>.from(
//             json["portfolio"].map((x) => Portfolio.fromJson(x))),
//         skill: List<Skill>.from(json["skill"].map((x) => Skill.fromJson(x))),
//         contactNo: json["contact_no"],
//         message: json["message"],
//         facebook: json["facebook"],
//         insta: json["insta"],
//         linkedin: json["linkedin"],
//         siteUrl: json["site_url"],
//         bee: json["bee"],
//         other: json["other"],
//         twitter: json["twitter"],
//         pinterest: json["pinterest"],
//         fileBaseurl: json["base_file_url"],
//         education: List<CommonProfession>.from(
//             json["Education"].map((x) => CommonProfession.fromJson(x))),
//         experience: List<CommonProfession>.from(
//             json["Experience"].map((x) => CommonProfession.fromJson(x))),
//         certificate: List<CommonProfession>.from(
//             json["Certificate"].map((x) => CommonProfession.fromJson(x))),
//         extraActivities: List<CommonProfession>.from(
//             json["extra_activities"].map((x) => CommonProfession.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "profile_completion_per": profileCompletionPer,
//         "user_resume": userResume,
//         "looking_for_internship": lookingForInternship,
//         "looking_for_placement": lookingForPlacement,
//         "portfolio": List<dynamic>.from(portfolio.map((x) => x.toJson())),
//         "skill": List<dynamic>.from(skill.map((x) => x.toJson())),
//         "contact_no": contactNo,
//         "message": message,
//         "facebook": facebook,
//         "insta": insta,
//         "linkedin": linkedin,
//         "site_url": siteUrl,
//         "bee": bee,
//         "other": other,
//         "twitter": twitter,
//         "pinterest": pinterest,
//         "Education": List<dynamic>.from(education.map((x) => x.toJson())),
//         "Experience": List<dynamic>.from(experience.map((x) => x.toJson())),
//         "Certificate": List<dynamic>.from(certificate.map((x) => x.toJson())),
//         "extra_activities":
//             List<dynamic>.from(extraActivities.map((x) => x.toJson())),
//       };
// }

// class CommonProfession {
//   CommonProfession({
//     required this.activityType,
//     required this.title,
//     required this.description,
//     required this.startDate,
//     required this.endDate,
//     required this.institute,
//     required this.certificate,
//     required this.action,
//     required this.professionalKey,
//     required this.editUrlProfessional,
//     required this.imageName,
//     required this.id,
//   });

//   String activityType;
//   String title;
//   String description;
//   String startDate;
//   String endDate;
//   String institute;
//   String certificate;
//   String action;
//   String professionalKey;
//   String editUrlProfessional;
//   String imageName;
//   int id;

//   factory CommonProfession.fromJson(Map<String, dynamic> json) =>
//       CommonProfession(
//         activityType: json["activity_type"],
//         title: json["title"],
//         description: json["description"],
//         startDate: json["start_date"],
//         endDate: json["end_date"],
//         institute: json["institute"],
//         certificate: json["certificate"],
//         action: json["action"],
//         professionalKey: json["professional_key"],
//         editUrlProfessional: json["edit_url_professional"],
//         imageName: json["image_name"],
//         id: json['id']
//       );

//   Map<String, dynamic> toJson() => {
//         "activity_type": activityType,
//         "title": title,
//         "description": description,
//         "start_date": startDate,
//         "end_date": endDate,
//         "institute": institute,
//         "certificate": certificate,
//         "action": action,
//         "professional_key": professionalKey,
//         "edit_url_professional": editUrlProfessional,
//         "image_name": imageName,
//         "id" : id
//       };
// }

// class Portfolio {
//   Portfolio({
//     required this.portfolioTitle,
//     required this.portfolioLink,
//     required this.action,
//     required this.portfolioKey,
//     required this.editUrlPortfolio,
//     required this.editImageType,
//     required this.imageName,
//      this.desc
//   });

//   String portfolioTitle;
//   String portfolioLink;
//   String action;
//   String portfolioKey;
//   String editUrlPortfolio;
//   String editImageType;
//   String imageName;
//   String? desc;

//   factory Portfolio.fromJson(Map<String, dynamic> json) => Portfolio(
//         portfolioTitle: json["portfolio_title"],
//         portfolioLink: json["portfolio_link"],
//         action: json["action"],
//         portfolioKey: json["portfolio_key"],
//         editUrlPortfolio: json["edit_url_portfolio"],
//         editImageType: json["edit_image_type"],
//         imageName: json["image_name"],
//         desc: json["desc"] ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "portfolio_title": portfolioTitle,
//         "portfolio_link": portfolioLink,
//         "action": action,
//         "portfolio_key": portfolioKey,
//         "edit_url_portfolio": editUrlPortfolio,
//         "edit_image_type": editImageType,
//         "image_name": imageName,
//         "desc": desc ?? "",
//       };
// }

// class Skill {
//   Skill({
//     required this.skillTitle,
//     required this.skillPercentage,
//     required this.skillKey,
//     required this.editUrlSkill,
//     required this.imageName,
//   });

//   String skillTitle;
//   String skillPercentage;
//   String skillKey;
//   String editUrlSkill;
//   String imageName;

//   factory Skill.fromJson(Map<String, dynamic> json) => Skill(
//         skillTitle: json["skill_title"],
//         skillPercentage: json["skill_percentage"],
//         skillKey: json["skill_key"],
//         editUrlSkill: json["edit_url_skill"],
//         imageName: json["image_name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "skill_title": skillTitle,
//         "skill_percentage": skillPercentage,
//         "skill_key": skillKey,
//         "edit_url_skill": editUrlSkill,
//         "image_name": imageName,
//       };
// }



// To parse this JSON data, do
//
//     final portfolioResponse = portfolioResponseFromJson(jsonString);

import 'dart:convert';

PortfolioResponse portfolioResponseFromJson(String str) => PortfolioResponse.fromJson(json.decode(str));

String portfolioResponseToJson(PortfolioResponse data) => json.encode(data.toJson());

class PortfolioResponse {
    PortfolioResponse({
        required this.status,
        required this.data,
        required this.error,
    });

    int status;
    Data data;
    List<dynamic> error;

    factory PortfolioResponse.fromJson(Map<String, dynamic> json) => PortfolioResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        error: List<dynamic>.from(json["error"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "error": List<dynamic>.from(error.map((x) => x)),
    };
}

class Data {
    Data({
        required this.profileCompletionPer,
        this.userResume,
        required this.lookingForInternship,
        required this.lookingForPlacement,
        required this.education,
        required this.experience,
        required this.certificate,
        required this.extraActivities,
        required this.portfolio,
        required this.baseFileUrl,
    });

    int profileCompletionPer;
    dynamic userResume;
    String lookingForInternship;
    String lookingForPlacement;
    List<CommonProfession> education;
    List<CommonProfession> experience;
    List<CommonProfession> certificate;
    List<CommonProfession> extraActivities;
    List<Portfolio> portfolio;
    String baseFileUrl;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        profileCompletionPer: json["profile_completion_per"],
        userResume: json["user_resume"],
        lookingForInternship: json["looking_for_internship"],
        lookingForPlacement: json["looking_for_placement"],
        education: List<CommonProfession>.from(json["Education"].map((x) => CommonProfession.fromJson(x))),
        experience: List<CommonProfession>.from(json["Experience"].map((x) => CommonProfession.fromJson(x))),
        certificate: List<CommonProfession>.from(json["Certificate"].map((x) => CommonProfession.fromJson(x))),
        extraActivities: List<CommonProfession>.from(json["extra_activities"].map((x) => CommonProfession.fromJson(x))),
        portfolio: List<Portfolio>.from(json["portfolio"].map((x) => Portfolio.fromJson(x))),
        baseFileUrl: json["base_file_url"],
    );

    Map<String, dynamic> toJson() => {
        "profile_completion_per": profileCompletionPer,
        "user_resume": userResume,
        "looking_for_internship": lookingForInternship,
        "looking_for_placement": lookingForPlacement,
        "Education": List<dynamic>.from(education.map((x) => x.toJson())),
        "Experience": List<dynamic>.from(experience.map((x) => x.toJson())),
        "Certificate": List<dynamic>.from(certificate.map((x) => x.toJson())),
        "extra_activities": List<dynamic>.from(extraActivities.map((x) => x.toJson())),
        "portfolio": List<dynamic>.from(portfolio.map((x) => x.toJson())),
        "base_file_url": baseFileUrl,
    };
}

class CommonProfession {
    CommonProfession({
        required this.activityType,
        required this.title,
        required this.description,
        required this.startDate,
        required this.endDate,
        required this.institute,
        required this.certificate,
        required this.action,
        required this.professionalKey,
        required this.editUrlProfessional,
        required this.imageName,
        required this.id,
    });

    String activityType;
    String title;
    String description;
    String startDate;
    String endDate;
    String institute;
    String certificate;
    String action;
    String professionalKey;
    String editUrlProfessional;
    String imageName;
    int id;

    factory CommonProfession.fromJson(Map<String, dynamic> json) => CommonProfession(
        activityType: json["activity_type"],
        title: json["title"],
        description: json["description"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        institute: json["institute"],
        certificate: json["certificate"],
        action: json["action"],
        professionalKey: json["professional_key"],
        editUrlProfessional: json["edit_url_professional"],
        imageName: json["image_name"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "activity_type": activityType,
        "title": title,
        "description": description,
        "start_date": startDate,
        "end_date": endDate,
        "institute": institute,
        "certificate": certificate,
        "action": action,
        "professional_key": professionalKey,
        "edit_url_professional": editUrlProfessional,
        "image_name": imageName,
        "id": id,
    };
}

class Portfolio {
    Portfolio({
        required this.portfolioTitle,
        required this.portfolioLink,
        required this.action,
        required this.portfolioKey,
        required this.editUrlPortfolio,
        required this.editImageType,
        required this.desc,
        required this.imageName,
        required this.id,
    });

    String portfolioTitle;
    String portfolioLink;
    String action;
    String portfolioKey;
    String editUrlPortfolio;
    String editImageType;
    String desc;
    String imageName;
    int id;

    factory Portfolio.fromJson(Map<String, dynamic> json) => Portfolio(
        portfolioTitle: json["portfolio_title"],
        portfolioLink: json["portfolio_link"],
        action: json["action"],
        portfolioKey: json["portfolio_key"],
        editUrlPortfolio: json["edit_url_portfolio"],
        editImageType: json["edit_image_type"],
        desc: json["desc"],
        imageName: json["image_name"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "portfolio_title": portfolioTitle,
        "portfolio_link": portfolioLink,
        "action": action,
        "portfolio_key": portfolioKey,
        "edit_url_portfolio": editUrlPortfolio,
        "edit_image_type": editImageType,
        "desc": desc,
        "image_name": imageName,
        "id": id,
    };
}
