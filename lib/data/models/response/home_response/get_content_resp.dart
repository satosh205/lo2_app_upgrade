class GetContentResp {
  int? status;
  Data? data;
  List<String>? error;

  GetContentResp({this.status, this.data, this.error});

  GetContentResp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['error'] != null) {
      error = <String>[];
      json['error'].forEach((v) {
        error!.add(v);
      });
    }
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
  List<ListData>? list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ListData>[];
      json['list'].forEach((v) {
        list!.add(new ListData.fromJson(v));
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

class ListData {
  int? id;
  String? title;
  String? description;
  int? createdAt;
  int? createdBy;
  int? updatedAt;
  int? updatedBy;
  String? status;
  int? parentId;
  int? categoryId;
  int? contentId;
  int? programContentId;
  String? contentType;
  String? resourcePath;
  List<String>? multiFileUploads;
  String? thumbnailUrl;
  String? userSubmittedFile;
  List<String>? userSubmittedMultipleFile;
  String? language;
  String? tag = '';
  int? startDate;
  int? endDate;
  int? isMultilingual;
  int? questionCount;
  int? isAttempt;
  int? multipleFileUpload;
  String? multiFileUploadsCount;

  ListData(
      {this.id,
      this.title,
      this.description,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.status,
      this.userSubmittedFile,
      this.userSubmittedMultipleFile,
      this.parentId,
      this.categoryId,
      this.contentType,
      this.resourcePath,
      this.multiFileUploads,
      this.language,
      this.tag,
      this.startDate,
      this.endDate,
      this.programContentId,
      this.isMultilingual,
      this.thumbnailUrl,
      this.isAttempt,
      this.multiFileUploadsCount,
      this.multipleFileUpload,
      this.questionCount});

  ListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    status = json['status'];
    parentId = json['parent_id'];
    categoryId = json['category_id'];
    contentType = json['content_type'];
    resourcePath = json['resource_path'];
    language = json['language'];
    tag = json['tag'] is String ? json['tag'] : '';
    startDate = json['start_date'];
    endDate = json['end_date'];
    isMultilingual = json['is_multilingual'];
    questionCount = json['question_count'];
    contentId = json['content_id'] != null ? json['content_id'] : null;
    isAttempt = json['is_attempt'];
    multiFileUploadsCount = json['multi_file_uploads_count'];
    multipleFileUpload = json['multiple_file_upload'];
    multiFileUploads = json['multi_file_uploads'].cast<String>();
    thumbnailUrl = json['thumbnail_url'];
    programContentId = json['program_content_id'];
    userSubmittedFile = json['user_submitted_file'];
    userSubmittedMultipleFile =
        json['user_submitted_multiple_file'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['status'] = this.status;
    data['parent_id'] = this.parentId;
    data['category_id'] = this.categoryId;
    data['content_type'] = this.contentType;
    data['resource_path'] = this.resourcePath;
    data['multi_file_uploads'] = this.multiFileUploads;
    data['language'] = this.language;
    data['tag'] = this.tag;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['is_multilingual'] = this.isMultilingual;
    data['question_count'] = this.questionCount;
    data['content_id'] = this.contentId;
    data['is_attempt'] = this.isAttempt;
    data['multi_file_uploads_count'] = this.multiFileUploadsCount;
    data['multiple_file_upload'] = this.multipleFileUpload;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['program_content_id'] = this.programContentId;
    data['user_submitted_file'] = this.userSubmittedFile;
    data['user_submitted_multiple_file'] = this.userSubmittedMultipleFile;
    return data;
  }
}

class MultiFileUploads {
  List<String>? video;
  List<String>? image;

  MultiFileUploads({this.video, this.image});

  MultiFileUploads.fromJson(Map<String, dynamic> json) {
    video = json['video'].cast<String>();
    image = json['image'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video'] = this.video;
    data['image'] = this.image;
    return data;
  }
}
