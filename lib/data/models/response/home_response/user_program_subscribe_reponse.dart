

import 'dart:convert';

UserProgramSubscribeRes userProgramSubscribeResFromJson(String str) => UserProgramSubscribeRes.fromJson(json.decode(str));

String userProgramSubscribeResToJson(UserProgramSubscribeRes data) => json.encode(data.toJson());

class UserProgramSubscribeRes {
    UserProgramSubscribeRes({
        this.status,
        this.data,
        this.error,
    });

    int? status;
    List<String>? data;
    List<dynamic>? error;

    factory UserProgramSubscribeRes.fromJson(Map<String, dynamic> json) => UserProgramSubscribeRes(
        status: json["status"],
        data: List<String>.from(json["data"].map((x) => x)),
        error: List<dynamic>.from(json["error"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x)),
        "error": List<dynamic>.from(error!.map((x) => x)),
    };
}
