// To parse this JSON data, do
//
//     final dashboardViewResponse = dashboardViewResponseFromJson(jsonString);

import 'dart:convert';

DashboardViewResponse dashboardViewResponseFromJson(String str) =>
    DashboardViewResponse.fromJson(json.decode(str));

String dashboardViewResponseToJson(DashboardViewResponse data) =>
    json.encode(data.toJson());

class DashboardViewResponse {
  DashboardViewResponse({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<dynamic>? error;

  factory DashboardViewResponse.fromJson(Map<String, dynamic> json) =>
      DashboardViewResponse(
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
    this.dashboardFeaturedContentLimit,
    this.dashboardSessionsLimit,
    this.dashboardMyCoursesLimit,
    this.dashboardReelsLimit,
    this.dashboardRecommendedCoursesLimit,
    this.dashboardCarvanLimit,
  });

  String? dashboardFeaturedContentLimit;
  String? dashboardSessionsLimit;
  String? dashboardMyCoursesLimit;
  String? dashboardReelsLimit;
  String? dashboardRecommendedCoursesLimit;
  String? dashboardCarvanLimit;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        dashboardFeaturedContentLimit: json["dashboard_featured_content_limit"],
        dashboardSessionsLimit: json["dashboard_sessions_limit"],
        dashboardMyCoursesLimit: json["dashboard_my_courses_limit"],
        dashboardReelsLimit: json["dashboard_reels_limit"],
        dashboardRecommendedCoursesLimit:
            json["dashboard_recommended_courses_limit"],
        dashboardCarvanLimit: json["dashboard_carvan_limit"],
      );

  Map<String, dynamic> toJson() => {
        "dashboard_featured_content_limit": dashboardFeaturedContentLimit,
        "dashboard_sessions_limit": dashboardSessionsLimit,
        "dashboard_my_courses_limit": dashboardMyCoursesLimit,
        "dashboard_reels_limit": dashboardReelsLimit,
        "dashboard_recommended_courses_limit": dashboardRecommendedCoursesLimit,
        "dashboard_carvan_limit": dashboardCarvanLimit,
      };

  map(Function(dynamic e) param0) {}
}
