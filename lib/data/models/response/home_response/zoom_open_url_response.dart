import 'dart:convert';

ZoomOpenUrlResponse zoomOpenUrlResponseFromJson(String str) => ZoomOpenUrlResponse.fromJson(json.decode(str));

String zoomOpenUrlResponseToJson(ZoomOpenUrlResponse data) => json.encode(data.toJson());

class ZoomOpenUrlResponse {
    ZoomOpenUrlResponse({
        this.status,
        this.data,
        this.error,
    });

    int? status;
    Data? data;
    List<dynamic>? error;

    factory ZoomOpenUrlResponse.fromJson(Map<String, dynamic> json) => ZoomOpenUrlResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        error: List<dynamic>.from(json["error"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "error": List<dynamic>.from(error!.map((x) => x)),
    };
}

class Data {
    Data({
        this.list,
    });

    ListClass? list;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        list:json["list"] != null ?  ListClass.fromJson(json["list"]) : null,
    );

    Map<String, dynamic> toJson() => {
        "list": list?.toJson(),
    };
}

class ListClass {
    ListClass({
        this.registrantId,
        this.id,
        this.topic,
        this.startTime,
        this.joinUrl,
    });

    String? registrantId;
    int? id;
    String? topic;
    String? startTime;
    String? joinUrl;

    factory ListClass.fromJson(Map<String, dynamic> json) => ListClass(
        registrantId: json["registrant_id"],
        id: json["id"],
        topic: json["topic"],
        startTime: json["start_time"],
        joinUrl: json["join_url"],
    );

    Map<String, dynamic> toJson() => {
        "registrant_id": registrantId,
        "id": id,
        "topic": topic,
        "start_time": startTime,
        "join_url": joinUrl,
    };
}
