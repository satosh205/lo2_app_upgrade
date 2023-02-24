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
        required this.image,
        required this.name,
        required this.resume,
        required this.profileVideo,
        required this.education,
        required this.experience,
        required this.certificate,
        required this.extraActivities,
        required this.portfolioSocial,
        required this.portfolioProfile,
        required this.portfolio,
        required this.baseFileUrl,
         required this.recentActivity,
         required this.profileCompletion
    });

    String image;
    String name;
    List<Resume> resume;
    String profileVideo;
    List<CommonProfession> education;
    List<CommonProfession> experience;
    List<CommonProfession> certificate;
    List<CommonProfession> extraActivities;
    List<PortfolioSocial> portfolioSocial;
    List<PortfolioProfile> portfolioProfile;
    List<Portfolio> portfolio;
    String baseFileUrl;
    List<RecentActivity> recentActivity;
    int profileCompletion;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        image: json["image"],
        name: json["name"],
        resume: List<Resume>.from(json["resume"].map((x) => Resume.fromJson(x))),
        profileVideo: json["profile_video"],
        profileCompletion: int.parse('${json["profile_completion"] ?? 0}') ,
        education: List<CommonProfession>.from(json["Education"].map((x) => CommonProfession.fromJson(x))),
        experience: List<CommonProfession>.from(json["Experience"].reversed.map((x) => CommonProfession.fromJson(x))),
        // certificate: List<CommonProfession>.from(json["Certificate"].reversed.map((x) => CommonProfession.fromJson(x))),
        certificate: List<CommonProfession>.from(json["Certificate"].map((x) => CommonProfession.fromJson(x))),
        extraActivities: List<CommonProfession>.from(json["extra_activities"].map((x) => CommonProfession.fromJson(x))),
        portfolioSocial: List<PortfolioSocial>.from(json["portfolio_social"].map((x) => PortfolioSocial.fromJson(x))),
        portfolioProfile: List<PortfolioProfile>.from(json["portfolio_profile"].map((x) => PortfolioProfile.fromJson(x))),
        portfolio: json.containsKey("portfolio") == true ? List<Portfolio>.from(json["portfolio"].reversed.map((x) => Portfolio.fromJson(x))) : [],
        baseFileUrl: json.containsKey("base_file_url") == true ? json["base_file_url"] : "",
          recentActivity: List<RecentActivity>.from(json["recent_activity"].map((x) => RecentActivity.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "resume": List<dynamic>.from(resume.map((x) => x.toJson())),
        "profile_video": profileVideo,
        "Education": List<dynamic>.from(education.map((x) => x.toJson())),
        "Experience": List<dynamic>.from(experience.map((x) => x.toJson())).reversed,
        "Certificate": List<dynamic>.from(certificate.map((x) => x.toJson())).reversed,
        "extra_activities": List<dynamic>.from(extraActivities.map((x) => x.toJson())),
        "portfolio_social": List<dynamic>.from(portfolioSocial.map((x) => x.toJson())),
        "portfolio_profile": List<dynamic>.from(portfolioProfile.map((x) => x.toJson())),
        "portfolio":  List<dynamic>.from(portfolio.map((x) => x.toJson())).reversed,
        "base_file_url": baseFileUrl,
        "profile_completion" : profileCompletion,
        "recent_activity": List<dynamic>.from(recentActivity.map((x) => x.toJson())),
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
        required this.employmentType,
        required this.currentlyWorkHere,
        required this.curricularType,
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
    String employmentType;
    String currentlyWorkHere;
    String curricularType;
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
        employmentType: json["employment_type"],
        currentlyWorkHere: json["currently_work_here"],
        curricularType: json["curricular_type"],
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
        "employment_type": employmentType,
        "currently_work_here": currentlyWorkHere,
        "curricular_type": curricularType,
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
        required this.portfolioFile,
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
    String portfolioFile;
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
        portfolioFile: json["portfolio_file"],
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
        "portfolio_file": portfolioFile,
        "id": id,
    };
}

class PortfolioProfile {
    PortfolioProfile({
        required this.headline,
        required this.country,
        required this.city,
        required this.aboutMe,
        required this.id,
    });

    String headline;
    String country;
    String city;
    String aboutMe;
    int id;

    factory PortfolioProfile.fromJson(Map<String, dynamic> json) => PortfolioProfile(
        headline: json["headline"],
        country: json["country"],
        city: json["city"],
        aboutMe: json["about_me"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "headline": headline,
        "country": country,
        "city": city,
        "about_me": aboutMe,
        "id": id,
    };
}

class PortfolioSocial {
    PortfolioSocial({
        required this.mobNum,
        required this.email,
        required this.linkedin,
        required this.bee,
        required this.dribble,
        required this.insta,
        required this.facebook,
        required this.twitter,
        required this.pinterest,
        required this.other,
        required this.siteUrl,
        required this.mobNumHidden,
        required this.emailHidden,
        required this.id,
    });

    String mobNum;
    String email;
    String linkedin;
    String bee;
    String dribble;
    String insta;
    String facebook;
    String twitter;
    String pinterest;
    String other;
    String siteUrl;
    String mobNumHidden;
    String emailHidden;
    int id;

    factory PortfolioSocial.fromJson(Map<String, dynamic> json) => PortfolioSocial(
        mobNum: json["mob_num"],
        email: json["email"],
        linkedin: json["linkedin"],
        bee: json["bee"],
        dribble: json["dribble"],
        insta: json["insta"],
        facebook: json["facebook"],
        twitter: json["twitter"],
        pinterest: json["pinterest"],
        other: json["other"],
        siteUrl: json["site_url"],
        mobNumHidden: json["mob_num_hidden"],
        emailHidden: json["email_hidden"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "mob_num": mobNum,
        "email": email,
        "linkedin": linkedin,
        "bee": bee,
        "dribble": dribble,
        "insta": insta,
        "facebook": facebook,
        "twitter": twitter,
        "pinterest": pinterest,
        "other": other,
        "site_url": siteUrl,
        "mob_num_hidden": mobNumHidden,
        "email_hidden": emailHidden,
        "id": id,
    };
}

class Resume {
    Resume({
        required this.url,
        required this.id,
    });

    String url;
    int id;

    factory Resume.fromJson(Map<String, dynamic> json) => Resume(
        url: json["url"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "id": id,
    };
}


class RecentActivity {
    RecentActivity({
        this.id,
        this.viewCount,
        this.title,
        this.description,
        this.resourcePath,
        this.resourcePathThumbnail,
        this.contentType,
        this.categoryId,
        this.profileImage,
        this.name,
        this.createdAt
    });

    int? id;
    int? viewCount;
    String? title;
    String? description;
    String? resourcePath;
    String? resourcePathThumbnail;
    String? contentType;
    int? categoryId;
    String? profileImage;
    String? name;
    String? createdAt;

    factory RecentActivity.fromJson(Map<String, dynamic> json) => RecentActivity(
        id: json["id"],
        viewCount: json["view_count"],
        title: json["title"] ?? "",
        description: json["description"],
        resourcePath: json["resource_path"],
        resourcePathThumbnail: json["resource_path_thumbnail"] ?? "",
        contentType: json["content_type"],
        categoryId: json["category_id"],
        profileImage: json["profile_image"],
        name: json["name"], createdAt: json['created_at'],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "view_count": viewCount,
        "title": title,
        "description": description,
        "resource_path": resourcePath,
        "resource_path_thumbnail": resourcePathThumbnail,
        "content_type": contentType,
        "category_id": categoryId,
        "profile_image": profileImage,
        "name": name,
        "created_at" : createdAt
    };
}
