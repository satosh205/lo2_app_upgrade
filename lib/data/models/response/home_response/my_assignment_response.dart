// class MyAssignmentResponse {
//   int? status;
//   Data? data;
//   List<dynamic>? error;

//   MyAssignmentResponse({this.status, this.data, this.error});

//   MyAssignmentResponse.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//     error = json['error'].cast<String>();

//     /*if (json['error'] != null) {
//       error = <Null>[] as List<String>?;
//       json['error'].forEach((v) {
//         error!.add(v);
//       });
//     }*/
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     if (this.error != null) {
//       data['error'] = this.error!.map((v) => v).toList();
//     }
//     return data;
//   }
// }

// class Data {
//   List<AssignmentList>? list;

//   Data({this.list});

//   Data.fromJson(Map<String, dynamic> json) {
//     if (json['list'] != null) {
//       list = <AssignmentList>[];
//       json['list'].forEach((v) {
//         list!.add(new AssignmentList.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.list != null) {
//       data['list'] = this.list!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class AssignmentList {
//   int? contentId;
//   String? title;
//   String? description;
//   int? startDate;
//   int? endDate;
//   int? allowMultiple;
//   int? isGraded;
//   int? submissionMode;
//   int? maximumMarks;
//   String? contentType;
//   int? languageId;
//   int? moduleId;
//   int? totalAttempts;
//   String? file;
//   String? status;
//   int? marks;

//   AssignmentList(
//       {this.contentId,
//       this.title,
//       this.description,
//       this.startDate,
//       this.endDate,
//       this.allowMultiple,
//       this.isGraded,
//       this.submissionMode,
//       this.maximumMarks,
//       this.contentType,
//       this.languageId,
//       this.moduleId,
//       this.totalAttempts,
//       this.file,
//       this.status,
//       this.marks});

//   AssignmentList.fromJson(Map<String, dynamic> json) {
//     contentId = json['content_id'];
//     title = json['title'];
//     description = json['description'];
//     startDate = json['start_date'];
//     endDate = json['end_date'];
//     allowMultiple = json['allow_multiple'];
//     isGraded = json['is_graded'];
//     submissionMode = json['submission_mode'];
//     maximumMarks = json['maximum_marks'];
//     contentType = json['content_type'];
//     languageId = json['language_id'];
//     moduleId = json['module_id'];
//     totalAttempts = json['total_attempts'];
//     file = json['file'];
//     status = json['status'];
//     marks = json['score'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['content_id'] = this.contentId;
//     data['title'] = this.title;
//     data['description'] = this.description;
//     data['start_date'] = this.startDate;
//     data['end_date'] = this.endDate;
//     data['allow_multiple'] = this.allowMultiple;
//     data['is_graded'] = this.isGraded;
//     data['submission_mode'] = this.submissionMode;
//     data['maximum_marks'] = this.maximumMarks;
//     data['content_type'] = this.contentType;
//     data['language_id'] = this.languageId;
//     data['module_id'] = this.moduleId;
//     data['total_attempts'] = this.totalAttempts;
//     data['file'] = this.file;
//     data['status'] = this.status;
//     data['score'] = this.marks;
//     return data;
//   }
// }

// To parse this JSON data, do
//
//     final myAssignmentResponse = myAssignmentResponseFromJson(jsonString);

import 'dart:convert';

MyAssignmentResponse myAssignmentResponseFromJson(String str) =>
    MyAssignmentResponse.fromJson(json.decode(str));

String myAssignmentResponseToJson(MyAssignmentResponse data) =>
    json.encode(data.toJson());

class MyAssignmentResponse {
  MyAssignmentResponse({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<dynamic>? error;

  factory MyAssignmentResponse.fromJson(Map<String, dynamic> json) =>
      MyAssignmentResponse(
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

  List<AssignmentList>? list;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<AssignmentList>.from(
            json["list"].map((x) => AssignmentList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class AssignmentList {
  AssignmentList({
    this.contentId,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.allowMultiple,
    this.isGraded,
    this.submissionMode,
    this.maximumMarks,
    this.contentType,
    this.languageId,
    this.moduleId,
    this.totalAttempts,
    this.score,
    this.status,
    this.file,
  });

  int? contentId;
  String? title;
  String? description;
  int? startDate;
  int? endDate;
  int? allowMultiple;
  int? isGraded;
  int? submissionMode;
  int? maximumMarks;
  String? contentType;
  int? languageId;
  int? moduleId;
  int? totalAttempts;
  dynamic score;
  String? status;
  String? file;

  factory AssignmentList.fromJson(Map<String, dynamic> json) => AssignmentList(
        contentId: json["content_id"],
        title: json["title"],
        description: json["description"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        allowMultiple: json["allow_multiple"],
        isGraded: json["is_graded"],
        submissionMode: json["submission_mode"],
        maximumMarks: json["maximum_marks"],
        contentType: json["content_type"],
        languageId: json["language_id"],
        moduleId: json["module_id"],
        totalAttempts: json["total_attempts"],
        score: json["score"] == null ? null : json["score"],
        status: json["status"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "content_id": contentId,
        "title": title,
        "description": description,
        "start_date": startDate,
        "end_date": endDate,
        "allow_multiple": allowMultiple,
        "is_graded": isGraded,
        "submission_mode": submissionMode,
        "maximum_marks": maximumMarks,
        "content_type": contentType,
        "language_id": languageId,
        "module_id": moduleId,
        "total_attempts": totalAttempts,
        "score": score,
        "status": status,
        "file": file,
      };
}
