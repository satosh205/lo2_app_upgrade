class AssignmentSubmissionResponse {
  int? status;
  Data? data;
  List<String?>? error;

  AssignmentSubmissionResponse({this.status, this.data, this.error});

  AssignmentSubmissionResponse.fromJson(Map<String, dynamic> json) {
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
  List<AssessmentDetails>? assessmentDetails;

  Data({this.assessmentDetails});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['assessment_details'] != null) {
      assessmentDetails = <AssessmentDetails>[];
      json['assessment_details'].forEach((v) {
        assessmentDetails!.add(new AssessmentDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assessmentDetails != null) {
      data['assessment_details'] =
          this.assessmentDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssessmentDetails {
  int? id;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  String? file;
  int? allowMultiple;
  int? isGraded;
  int? submissionMode;
  String? learnerName;
  List<SubmissionDetails>? submissionDetails;

  AssessmentDetails(
      {this.id,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.file,
      this.allowMultiple,
      this.isGraded,
      this.submissionMode,
      this.learnerName,
      this.submissionDetails,});

  AssessmentDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    file = json['file'];
    allowMultiple = json['allow_multiple'];
    isGraded = json['is_graded'];
    submissionMode = json['submission_mode'];
    learnerName = json['learner_name'];
    if (json['submission_details'] != null) {
      submissionDetails = <SubmissionDetails>[];
      json['submission_details'].forEach((v) {
        submissionDetails!.add(new SubmissionDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['file'] = this.file;
    data['allow_multiple'] = this.allowMultiple;
    data['is_graded'] = this.isGraded;
    data['submission_mode'] = this.submissionMode;
    data['learner_name'] = this.learnerName;
    if (this.submissionDetails != null) {
      data['submission_details'] =
          this.submissionDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubmissionDetails {
  int? id;
  int? contentId;
  int? userId;
  String? marksObtained;
  int? isPassed;
  String? userNotes;
  String? teacherNotes;
  String? teacherFile;
  int? reviewStatus;
  String? file;
  int? createdAt;
  int? updatedAt;
  String? title;

  SubmissionDetails(
      {this.id,
      this.contentId,
      this.userId,
      this.marksObtained,
      this.isPassed,
      this.userNotes,
      this.teacherNotes,
      this.reviewStatus,
      this.file,
      this.createdAt,
      this.title,
      this.updatedAt,
      this.teacherFile
      });

  SubmissionDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contentId = json['content_id'];
    userId = json['user_id'];
    marksObtained = json['marks_obtained'];
    isPassed = json['is_passed'];
    userNotes = json['user_notes'];
    teacherNotes = json['teacher_notes'];
    reviewStatus = json['review_status'];
    file = json['file'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    teacherFile = json['teacher_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content_id'] = this.contentId;
    data['user_id'] = this.userId;
    data['marks_obtained'] = this.marksObtained;
    data['is_passed'] = this.isPassed;
    data['user_notes'] = this.userNotes;
    data['teacher_notes'] = this.teacherNotes;
    data['review_status'] = this.reviewStatus;
    data['file'] = this.file;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['title'] = this.title;
    data['teacher_file'] = this.teacherFile;
    return data;
  }
}
