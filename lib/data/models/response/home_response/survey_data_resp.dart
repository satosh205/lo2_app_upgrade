class SurveyDataResp {
  int? status;
  Data? data;
  List<String>? error;

  SurveyDataResp({this.status, this.data, this.error});

  SurveyDataResp.fromJson(Map<String, dynamic> json,int type) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data'],type) : null;
    error = json['error'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

class Data {
  ListSurvey? listSurvey;

  Data({this.listSurvey});

  Data.fromJson(Map<String, dynamic> json,int type) {
    listSurvey =
        json['list'] != null ? new ListSurvey.fromJson(type==1? json['list'] : json['list'].first) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listSurvey != null) {
      data['list'] = this.listSurvey?.toJson();
    }
    return data;
  }
}

class ListSurvey {
  String? title;
  String? description;
  int? startDate;
  int? endDate;
  int? questionCount;
  List<Questions>? questions;

  ListSurvey(
      {this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.questionCount,
      this.questions});

  ListSurvey.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    questionCount = json['question_count'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions?.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['question_count'] = this.questionCount;
    if (this.questions != null) {
      data['questions'] = this.questions?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int? questionId;
  String? question;
  String? questionType;
  int? questionTypeId;
  int? attempted;
  List<Options>? options;

  Questions(
      {this.questionId,
      this.question,
      this.questionType,
      this.questionTypeId,
      this.attempted,
      this.options});

  Questions.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    question = json['question'];
    questionType = json['question_type'];
    questionTypeId = json['question_type_id'];
    attempted = json['attempted'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options?.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['question'] = this.question;
    data['question_type'] = this.questionType;
    data['question_type_id'] = this.questionTypeId;
    data['attempted'] = this.attempted;
    if (this.options != null) {
      data['options'] = this.options?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  int? optionId;
  String? optionStatement;
  int? attempted;

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
