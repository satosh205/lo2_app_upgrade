import 'package:flutter/material.dart';
import 'package:masterg/utils/resource/colors.dart';

class AttemptTestResponse {
  int? status;
  Data? data;
  List<String?>? error;

  AttemptTestResponse({this.status, this.data, this.error});

  AttemptTestResponse.fromJson(Map<String, dynamic> json) {
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
  AssessmentDetails? assessmentDetails;

  Data({this.assessmentDetails});

  Data.fromJson(Map<String, dynamic> json) {
    assessmentDetails = json['assessment_details'] != null
        ? new AssessmentDetails.fromJson(json['assessment_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assessmentDetails != null) {
      data['assessment_details'] = this.assessmentDetails!.toJson();
    }
    return data;
  }
}

class AssessmentDetails {
  String? title;
  String? description;
  int? startDate;
  int? endDate;
  int? maximumMarks;
  int? passingMarks;
  int? questionCount;
  int? negativeMarking;
  int? negativeMarks;
  int? totalAttempts;
  int? attemptCount;
  int? durationInMinutes;
  List<Questions>? questions;

  AssessmentDetails(
      {this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.maximumMarks,
      this.passingMarks,
      this.questionCount,
      this.negativeMarking,
      this.negativeMarks,
      this.totalAttempts,
      this.attemptCount,
      this.durationInMinutes,
      this.questions});

  AssessmentDetails.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    maximumMarks = json['maximum_marks'];
    passingMarks = json['passing_marks'];
    questionCount = json['question_count'];
    negativeMarking = json['negative_marking'];
    negativeMarks = json['negative_marks'];
    totalAttempts = json['total_attempts'];
    attemptCount = json['attempt_count'];
    durationInMinutes = json['duration_in_minutes'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['maximum_marks'] = this.maximumMarks;
    data['passing_marks'] = this.passingMarks;
    data['question_count'] = this.questionCount;
    data['negative_marking'] = this.negativeMarking;
    data['negative_marks'] = this.negativeMarks;
    data['total_attempts'] = this.totalAttempts;
    data['attempt_count'] = this.attemptCount;
    data['duration_in_minutes'] = this.durationInMinutes;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int? questionId;
  String? question;
  String? questionType;
  int? questionTypeId;
  int? negativeMarks;
  int? marks;
  int? attempted;
  String? difficultyLevel;
  List<int?> selectedOption = [];
  int? timeTaken;
  List<Options>? options;
  bool? bookMark;
  List<dynamic>? questionImage = [];

  Questions(
      {this.questionId,
      this.question,
      this.questionType,
      this.questionTypeId,
      this.negativeMarks,
      this.marks,
      this.attempted,
      this.difficultyLevel,
      this.timeTaken,
      this.options,
      this.questionImage});

  Questions.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    question = json['question'];
    questionType = json['question_type'];
    questionTypeId = json['question_type_id'];
    negativeMarks = json['negative_marks'];
    marks = json['marks'];
    attempted = json['attempted'];
    difficultyLevel = json['difficulty_level'];
    timeTaken = json['time_taken'];
    questionImage = json['question_image'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    if (json['question_image'] != null) {
      questionImage = <String>[];
      json['question_image'].forEach((v) {
        questionImage!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['question'] = this.question;
    data['question_type'] = this.questionType;
    data['question_type_id'] = this.questionTypeId;
    data['negative_marks'] = this.negativeMarks;
    data['marks'] = this.marks;
    data['attempted'] = this.attempted;
    data['difficulty_level'] = this.difficultyLevel;
    data['time_taken'] = this.timeTaken;
    if (this.questionImage != null) {
      data['question_image'] = this.questionImage!.map((v) => v).toList();
    }
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  int? optionId;
  String? optionStatement;
  int? attempted;
  bool selected = false;

  Options({this.optionId, this.optionStatement, this.attempted});

  Options.fromJson(Map<String, dynamic> json) {
    optionId = json['option_id'];
    optionStatement = json['option_statement'];
    attempted = json['attempted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option_id'] = this.optionId;
    data['option_statement'] = this.optionStatement;
    data['attempted'] = this.attempted;
    return data;
  }
}

class TestAttemptBean {
  Questions? question;
  int? id;
  Color color;
  int? isVisited = 0;
  String? title;
  bool isBookmark = false;

  TestAttemptBean({
    this.question,
    this.isBookmark = false,
    this.id,
    this.isVisited,
    this.color = ColorConstants.GREY_4,
    this.title,
  });
}
