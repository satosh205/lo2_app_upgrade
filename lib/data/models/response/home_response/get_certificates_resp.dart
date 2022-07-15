// To parse this JSON data, do
//
//     final getCertificatesResp = getCertificatesRespFromJson(jsonString);

import 'dart:convert';

GetCertificatesResp getCertificatesRespFromJson(String str) =>
    GetCertificatesResp.fromJson(json.decode(str));

String getCertificatesRespToJson(GetCertificatesResp data) =>
    json.encode(data.toJson());

class GetCertificatesResp {
  GetCertificatesResp({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<dynamic>? error;

  factory GetCertificatesResp.fromJson(Map<String, dynamic> json) =>
      GetCertificatesResp(
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
    this.kpiCertificatesData,
  });

  List<KpiCertificatesDatum>? kpiCertificatesData;

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(
        kpiCertificatesData: List<KpiCertificatesDatum>.from(
            json["kpi_certificates_data"]
                .map((x) => KpiCertificatesDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "kpi_certificates_data":
        List<dynamic>.from(kpiCertificatesData!.map((x) => x.toJson())),
      };
}

class KpiCertificatesDatum {
  KpiCertificatesDatum({
    this.kpiId,
    this.kpiName,
    this.kpiDescription,
    this.kpiCreatedAt,
    this.organizationId,
    this.certificateName,
    this.year,
    this.month,
    this.kpiCertificateCreatedAt,
  });

  int? kpiId;
  String? kpiName;
  String? kpiDescription;
  DateTime? kpiCreatedAt;
  int? organizationId;
  String? certificateName;
  int? year;
  int? month;
  DateTime? kpiCertificateCreatedAt;

  factory KpiCertificatesDatum.fromJson(Map<String, dynamic> json) =>
      KpiCertificatesDatum(
        kpiId: json["kpi_id"],
        kpiName: json["kpi_name"],
        kpiDescription: json["kpi_description"],
        kpiCreatedAt: DateTime.parse(json["kpi_created_at"]),
        organizationId: json["organization_id"],
        certificateName: json["certificate_name"],
        year: json["year"],
        month: json["month"],
        kpiCertificateCreatedAt:
        DateTime.parse(json["kpi_certificate_created_at"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "kpi_id": kpiId,
        "kpi_name": kpiName,
        "kpi_description": kpiDescription,
        "kpi_created_at": kpiCreatedAt!.toIso8601String(),
        "organization_id": organizationId,
        "certificate_name": certificateName,
        "year": year,
        "month": month,
        "kpi_certificate_created_at": kpiCertificateCreatedAt!.toIso8601String(),
      };
}
