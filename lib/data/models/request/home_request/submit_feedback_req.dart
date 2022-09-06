class FeedbackReq {
  String? title;
  String? topic;
  String? email;
  String? description;
  int? type;
  String? filePath;

  FeedbackReq(
      {this.title,
      this.email,
      this.description,
      this.topic,
      this.type,
      this.filePath});

  FeedbackReq.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    topic = json['topic'];
    email = json['email'];
    description = json['description'];
    type = json['type'];
    filePath = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['topic'] = this.topic;
    data['email'] = this.email;
    data['description'] = this.description;
    data['type'] = this.type;
    data['file'] = this.filePath;
    return data;
  }
}
