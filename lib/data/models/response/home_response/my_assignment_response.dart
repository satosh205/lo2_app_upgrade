class MyAssignmentResponse {
  int? status;
  Data? data;
  List<dynamic>? error;

  MyAssignmentResponse({this.status, this.data, this.error});

  MyAssignmentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    error = json['error'].cast<String>();

    /*if (json['error'] != null) {
      error = <Null>[] as List<String>?;
      json['error'].forEach((v) {
        error!.add(v);
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.error != null) {
      data['error'] = this.error!.map((v) => v).toList();
    }
    return data;
  }
}

class Data {
  List<AssignmentList>? list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <AssignmentList>[];
      json['list'].forEach((v) {
        list!.add(new AssignmentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssignmentList {
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
  String? file;
  String? status;

  AssignmentList(
      {this.contentId,
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
      this.file,
      this.status});

  AssignmentList.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    allowMultiple = json['allow_multiple'];
    isGraded = json['is_graded'];
    submissionMode = json['submission_mode'];
    maximumMarks = json['maximum_marks'];
    contentType = json['content_type'];
    languageId = json['language_id'];
    moduleId = json['module_id'];
    totalAttempts = json['total_attempts'];
    file = json['file'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content_id'] = this.contentId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['allow_multiple'] = this.allowMultiple;
    data['is_graded'] = this.isGraded;
    data['submission_mode'] = this.submissionMode;
    data['maximum_marks'] = this.maximumMarks;
    data['content_type'] = this.contentType;
    data['language_id'] = this.languageId;
    data['module_id'] = this.moduleId;
    data['total_attempts'] = this.totalAttempts;
    data['file'] = this.file;
    data['status'] = this.status;
    return data;
  }
}
