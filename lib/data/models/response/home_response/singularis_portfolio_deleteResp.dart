// To parse this JSON data, do
//
//     final singularisPortfolioDelete = singularisPortfolioDeleteFromJson(jsonString);

import 'dart:convert';

SingularisPortfolioDelete singularisPortfolioDeleteFromJson(String str) => SingularisPortfolioDelete.fromJson(json.decode(str));

String singularisPortfolioDeleteToJson(SingularisPortfolioDelete data) => json.encode(data.toJson());

class SingularisPortfolioDelete {
    SingularisPortfolioDelete({
        required this.data,
        required this.status,
        required this.error,
    });

    Data data;
    int status;
    List<dynamic> error;

    factory SingularisPortfolioDelete.fromJson(Map<String, dynamic> json) => SingularisPortfolioDelete(
        data: Data.fromJson(json["data"]),
        status: json["status"],
        error: List<dynamic>.from(json["error"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "error": List<dynamic>.from(error.map((x) => x)),
    };
}

class Data {
    Data({
        required this.list,
    });

    String list;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: json["list"],
    );

    Map<String, dynamic> toJson() => {
        "list": list,
    };
}
