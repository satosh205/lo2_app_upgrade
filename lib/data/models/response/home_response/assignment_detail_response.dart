class AssignmentDetailsResponse {
  int? status;
  Data? data;
  List<String>? error;

  AssignmentDetailsResponse({this.status, this.data, this.error});

  AssignmentDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    error = json['error'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

class Data {
  List<Assignment>? list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <Assignment>[];
      json['list'].forEach((v) {
        list!.add(new Assignment.fromJson(v));
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

class Assignment {
  int? contentId;
  String? title;
  String? description;
  int? startDate;
  int? endDate;
  int? allowMultiple;
  int? isGraded;
  int? submissionMode;
  String? contentType;
  int? languageId;
  int? moduleId;
  List<Learners>? learners;
  String? file;

  Assignment(
      {this.contentId,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.allowMultiple,
      this.isGraded,
      this.submissionMode,
      this.contentType,
      this.languageId,
      this.moduleId,
      this.learners,
      this.file});

  Assignment.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    allowMultiple = json['allow_multiple'];
    isGraded = json['is_graded'];
    submissionMode = json['submission_mode'];
    contentType = json['content_type'];
    languageId = json['language_id'];
    moduleId = json['module_id'];
    if (json['learners'] != null) {
      learners = <Learners>[];
      json['learners'].forEach((v) {
        learners!.add(new Learners.fromJson(v));
      });
    }
    file = json['file'];
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
    data['content_type'] = this.contentType;
    data['language_id'] = this.languageId;
    data['module_id'] = this.moduleId;
    if (this.learners != null) {
      data['learners'] = this.learners!.map((v) => v.toJson()).toList();
    }
    data['file'] = this.file;
    return data;
  }
}

class Learners {
  int? id;
  String? name;
  String? image;
  String? email;
  int? status;

  Learners({this.id, this.name, this.image, this.email, this.status});

  Learners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['email'] = this.email;
    data['status'] = this.status;
    return data;
  }
}
