

import 'dart:convert';

TopScoringResponse topScoringResponseFromJson(String str) => TopScoringResponse.fromJson(json.decode(str));

String topScoringResponseToJson(TopScoringResponse data) => json.encode(data.toJson());

class TopScoringResponse {
    TopScoringResponse({
        required this.status,
        required this.data,
        required this.message,
    });

    int status;
    List<Datum?>? data;
    String message;

    factory TopScoringResponse.fromJson(Map<String, dynamic> json) => TopScoringResponse(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x!.toJson())),
        "message": message,
    };
}

class Datum {
    Datum({
        this.id,
        this.name,
        this.email,
        this.profileImage,
        this.score,
        this.rank,
        this.rankOutOf,
        this.scoreRange
    });

    int? id;
    String? name;
    String? email;
    String? profileImage;
    dynamic? score;
    int? rank;
    int? rankOutOf;
    int? scoreRange;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        profileImage: json["profile_image"] ?? "",
        score: json["score"],
        rank: json["rank"],
        rankOutOf: json["rank_out_of"],
        scoreRange : json['score_range'],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "profile_image": profileImage,
        "score": score,
        "rank": rank,
        "rank_out_of": rankOutOf,
        'score_range' : scoreRange
    };
}
