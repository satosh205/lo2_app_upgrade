// class LoginResponse {
//   int? status;
//   String? message;

//   LoginResponse({this.status, this.message});

//   LoginResponse.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     return data;
//   }
// }






// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    LoginResponse({
        this.status,
        this.error,
        this.data,
        this.message,
    });

    int? status;
    List<String>? error;
    Data? data;
    String? message;

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        error: List<String>.from(json["error"].map((x) => x)),
        data: Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": List<dynamic>.from(error!.map((x) => x)),
        "data": data?.toJson(),
        "message": message,
    };
}

class Data {
    Data({
        this.otp,
    });

    String? otp;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        otp: json["otp"],
    );

    Map<String, dynamic> toJson() => {
        "otp": otp,
    };
}
