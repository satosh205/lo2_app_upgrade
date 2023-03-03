
class OnlyVerifyOtpResponse {
  OnlyVerifyOtpResponse({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<dynamic>? error;

  factory OnlyVerifyOtpResponse.fromJson(Map<String, dynamic> json) => OnlyVerifyOtpResponse(
    status: json["status"] == null ? null : json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    error: json["error"] == null
        ? null
        : List<dynamic>.from(json["error"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "data": data == null ? null : data!.toJson(),
    "error":
    error == null ? null : List<dynamic>.from(error!.map((x) => x)),
  };
}

class Data {
  Data({
    this.message,
  });

  String? message;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}

