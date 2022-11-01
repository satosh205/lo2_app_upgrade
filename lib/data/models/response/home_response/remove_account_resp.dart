

import 'dart:convert';

RemoveAccountResponse removeAccountResponseFromJson(String str) => RemoveAccountResponse.fromJson(json.decode(str));

String removeAccountResponseToJson(RemoveAccountResponse data) => json.encode(data.toJson());

class RemoveAccountResponse {
    RemoveAccountResponse({
        this.status,
        this.data,
        this.error,
    });

    int? status;
    List<String>? data;
    List<dynamic>? error;

    factory RemoveAccountResponse.fromJson(Map<String, dynamic> json) => RemoveAccountResponse(
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
