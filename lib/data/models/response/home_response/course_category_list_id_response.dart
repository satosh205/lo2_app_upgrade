class CourseCategoryListIdResponse {
  CourseCategoryListIdResponse({
    this.status,
    this.data,
    this.error,
    this.name,
    this.founded,
    this.members,
  });

  int? status;
  Data? data;
  List<dynamic>? error;
  String? name;
  int? founded;
  List<String>? members;

  factory CourseCategoryListIdResponse.fromJson(Map<String, dynamic> json) =>
      CourseCategoryListIdResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null
            ? null
            : List<dynamic>.from(json["error"].map((x) => x)),
        name: json["name"] == null ? null : json["name"],
        founded: json["founded"] == null ? null : json["founded"],
        members: json["members"] == null
            ? null
            : List<String>.from(json["members"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data!.toJson(),
        "error":
            error == null ? null : List<dynamic>.from(error!.map((x) => x)),
        "name": name == null ? null : name,
        "founded": founded == null ? null : founded,
        "members":
            members == null ? null : List<dynamic>.from(members!.map((x) => x)),
      };
}

class Data {
  Data({
    this.programs,
  });

  List<MProgram>? programs;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        programs: List<MProgram>.from(
            json["programs"].map((x) => MProgram.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "MPrograms": List<dynamic>.from(programs!.map((x) => x.toJson())),
      };
}

class MProgram {
  MProgram(
      {this.id,
      this.organizationId,
      this.name,
      this.description,
      this.categoryId,
      this.regularPrice,
      this.salePrice,
      this.categoryName,
      this.admissionStartDate,
      this.admissionEndDate,
      this.type,
      this.startDate,
      this.endDate,
      this.image,
      this.duration,
      this.contents,
      this.totalCoins,
      this.trainer,
      this.totalView,
      this.completionPer,
      this.subscriptionType,
      this.isSubscribed});

  int? id;
  int? organizationId;
  String? name;
  String? description;
  int? categoryId;
  int? regularPrice;
  int? salePrice;
  int? admissionStartDate;
  int? admissionEndDate;
  String? type;
  String? categoryName;
  int? startDate;
  int? endDate;
  String? image;
  String? duration;
  String? contents;
  int? totalCoins;
  String? trainer;
  dynamic totalView;
  int? completionPer;
  String? subscriptionType;
  bool? isSubscribed;

  factory MProgram.fromJson(Map<String, dynamic> json) => MProgram(
      id: json["id"],
      organizationId: json["organization_id"],
      name: json["name"],
      description: json["description"],
      categoryId: json["category_id"],
      regularPrice: json["regular_price"],
      salePrice: json["sale_price"],
      admissionStartDate: json["admission_start_date"],
      admissionEndDate: json["admission_end_date"],
      type: json["type"],
      categoryName: json['category_name'],
      startDate: json["start_date"],
      endDate: json["end_date"],
      image: json["image"],
      duration: json["duration"],
      contents: json["contents"],
      totalCoins: json["total_coins"],
      trainer: json["trainer"],
      totalView: json["total_view"],
      completionPer: json["completion_per"],
      subscriptionType: json['subscription_type'],
      isSubscribed: json['is_subscribed']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "name": name,
        "description": description,
        "category_id": categoryId,
        "regular_price": regularPrice,
        "sale_price": salePrice,
        "admission_start_date": admissionStartDate,
        "admission_end_date": admissionEndDate,
        "type": type,
        "category_name": categoryName,
        "start_date": startDate,
        "end_date": endDate,
        "image": image,
        "duration": duration,
        "contents": contents,
        "total_coins": totalCoins,
        "trainer": trainer,
        "total_view": totalView,
        "completion_per": completionPer,
        "subscription_type": subscriptionType,
        "is_subscribed": isSubscribed
      };
}
