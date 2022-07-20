class TrackAnnouncementReq {
  int? contentId;

  TrackAnnouncementReq({this.contentId});

  TrackAnnouncementReq.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content_id'] = this.contentId;
    return data;
  }
}
