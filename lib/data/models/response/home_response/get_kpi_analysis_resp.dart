// To parse this JSON data, do
//
//     final getKpiAnalysisResp = getKpiAnalysisRespFromJson(jsonString);

import 'dart:convert';

GetKpiAnalysisResp getKpiAnalysisRespFromJson(String str) =>
    GetKpiAnalysisResp.fromJson(json.decode(str));

String getKpiAnalysisRespToJson(GetKpiAnalysisResp data) =>
    json.encode(data.toJson());

class GetKpiAnalysisResp {
  GetKpiAnalysisResp({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<dynamic>? error;

  factory GetKpiAnalysisResp.fromJson(Map<String, dynamic> json) =>
      GetKpiAnalysisResp(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        error: List<dynamic>.from(json["error"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
        "error": List<dynamic>.from(error!.map((x) => x)),
      };
}

class Data {
  Data({
    this.kpiData,
  });

  List<KpiDatum>? kpiData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        kpiData: List<KpiDatum>.from(
            json["kpi_data"].map((x) => KpiDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "kpi_data": List<dynamic>.from(kpiData!.map((x) => x.toJson())),
      };
}

class KpiDatum {
  KpiDatum({
    this.kpiId,
    this.kpiName,
    this.kpiDescription,
    this.kpiCreatedAt,
    this.organizationId,
    this.columns,
  });

  int? kpiId;
  String? kpiName;
  String? kpiDescription;
  DateTime? kpiCreatedAt;
  int? organizationId;
  List<Map<String, dynamic>>? columns;

  factory KpiDatum.fromJson(Map<String, dynamic> json) =>
      KpiDatum(
        kpiId: json["kpi_id"],
        kpiName: json["kpi_name"],
        kpiDescription: json["kpi_description"],
        kpiCreatedAt: DateTime.parse(json["kpi_created_at"]),
        organizationId: json["organization_id"],
        columns: List<Map<String, dynamic>>.from(json["columns"].map((x) => x)),
      );

  Map<String, dynamic> toJson() =>
      {
        "kpi_id": kpiId,
        "kpi_name": kpiName,
        "kpi_description": kpiDescription,
        "kpi_created_at": kpiCreatedAt!.toIso8601String(),
        "organization_id": organizationId,
        "columns": List<dynamic>.from(columns!.map((x) => x)),
      };
}

class Column {
  Column({
    this.year,
    this.month,
    this.allIndiaRank,
    this.branchRank,
    this.areaRank,
  });

  int? year;
  int? month;
  String? allIndiaRank;
  String? branchRank;
  String? areaRank;

  factory Column.fromJson(Map<String, dynamic> json) =>
      Column(
        year: json["year"],
        month: json["month"],
        allIndiaRank: json["All India Rank"],
        branchRank: json["Branch Rank"],
        areaRank: json["Area Rank"],
      );

  Map<String, dynamic> toJson() =>
      {
        "year": year,
        "month": month,
        "All India Rank": allIndiaRank,
        "Branch Rank": branchRank,
        "Area Rank": areaRank,
      };
}
