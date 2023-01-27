import 'dart:convert';

AddPortfolioResp addPortfolioRespFromJson(String str) =>
    AddPortfolioResp.fromJson(json.decode(str));

String addPortfolioRespToJson(AddPortfolioResp data) =>
    json.encode(data.toJson());

class AddPortfolioResp {
  AddPortfolioResp({
    required this.status,
    required this.data,
    required this.error,
  });

  int status;
  Data data;
  List<dynamic> error;

  factory AddPortfolioResp.fromJson(Map<String, dynamic> json) =>
      AddPortfolioResp(
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
