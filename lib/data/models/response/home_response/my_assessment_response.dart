class MyAssessmentResponse {
  int? status;
  Data? data;
  List<String>? error;

  MyAssessmentResponse({this.status, this.data, this.error});

  MyAssessmentResponse.fromJson(Map<String, dynamic> json) {
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
  List<AssessmentList>? assessmentList;

  Data({this.assessmentList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['assessment_list'] != null) {
      assessmentList = <AssessmentList>[];
      json['assessment_list'].forEach((v) {
        assessmentList!.add(new AssessmentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assessmentList != null) {
      data['assessment_list'] =
          this.assessmentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssessmentList {
  int? contentId;
  String? title;
  String? description;
  int? startDate;
  int? endDate;
  int? maximumMarks;
  int? passingMarks;
  int? questionCount;
  int? attemptAllowed;
  int? durationInMinutes;
  int? attemptCount;
  String? difficultyLevel;
  int? module;
  int? skill;
  int? program;
  int? attemptedOn;
  int? score;

  AssessmentList(
      {this.contentId,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.maximumMarks,
      this.passingMarks,
      this.questionCount,
      this.attemptAllowed,
      this.durationInMinutes,
      this.attemptCount,
      this.difficultyLevel,
      this.module,
      this.skill,
      this.program,
      this.attemptedOn,
      this.score});

  AssessmentList.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    maximumMarks = json['maximum_marks'];
    passingMarks = json['passing_marks'];
    questionCount = json['question_count'];
    attemptAllowed = json['attempt_allowed'];
    durationInMinutes = json['duration_in_minutes'];
    attemptCount = json['attempt_count'];
    difficultyLevel = json['difficulty_level'];
    module = json['module'];
    skill = json['skill'];
    program = json['program'];
    attemptedOn = json['attempted_on'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content_id'] = this.contentId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['maximum_marks'] = this.maximumMarks;
    data['passing_marks'] = this.passingMarks;
    data['question_count'] = this.questionCount;
    data['attempt_allowed'] = this.attemptAllowed;
    data['duration_in_minutes'] = this.durationInMinutes;
    data['attempt_count'] = this.attemptCount;
    data['difficulty_level'] = this.difficultyLevel;
    data['module'] = this.module;
    data['skill'] = this.skill;
    data['program'] = this.program;
    data['attempted_on'] = this.attemptedOn;
    data['score'] = this.score;
    return data;
  }
}
