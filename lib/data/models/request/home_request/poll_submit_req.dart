class PollSubmitRequest {
  int? contentId;
  List<int>? optionId;
  int? questionId;

  PollSubmitRequest({this.contentId, this.optionId, this.questionId});

  PollSubmitRequest.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
    optionId = json['option_id'].cast<int>();
    questionId = json['question_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content_id'] = this.contentId;
    data['option_id'] = this.optionId;
    data['question_id'] = this.questionId;
    return data;
  }
}
