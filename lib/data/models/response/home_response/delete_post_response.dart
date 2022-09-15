import 'dart:convert';

DeletePostResponse deletePostResponseFromJson(String str) => DeletePostResponse.fromJson(json.decode(str));

String deletePostResponseToJson(DeletePostResponse data) => json.encode(data.toJson());

class DeletePostResponse {
    DeletePostResponse({
        this.status,
        this.message,
    });

    int? status;
    String? message;

    factory DeletePostResponse.fromJson(Map<String, dynamic> json) => DeletePostResponse(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
