import 'dart:convert';

DeletePortfolioResponse deletePortfolioResponseFromJson(String str) =>
    DeletePortfolioResponse.fromJson(json.decode(str));

String deletePortfolioResponseToJson(DeletePortfolioResponse data) =>
    json.encode(data.toJson());

class DeletePortfolioResponse {
  DeletePortfolioResponse({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory DeletePortfolioResponse.fromJson(Map<String, dynamic> json) =>
      DeletePortfolioResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
      };
}
