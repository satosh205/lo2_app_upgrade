class SignUpResponse {
  SignUpResponse({
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

  factory SignUpResponse.fromJson(Map<String, dynamic> json) => SignUpResponse(
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
    this.token,
    this.user,
  });

  String? token;
  User? user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user!.toJson(),
      };
}

class User {
  User(
      {this.id,
      this.name,
      this.email,
      this.department,
      this.designation,
      this.mobileNo,
      this.profileImage,
      this.showInterest,
      this.defaultVideoUrlOnCategory});

  int? id;
  String? name;
  String? email;
  String? department;
  String? designation;
  String? mobileNo;
  String? profileImage;
  int? showInterest;
  String? defaultVideoUrlOnCategory;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        department: json["department"],
        designation: json["designation"],
        mobileNo: json["mobile_no"],
        profileImage: json["profile_image"],
        showInterest: json["show_interest"],
        defaultVideoUrlOnCategory: json["default_video_url_on_category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "department": department,
        "designation": designation,
        "mobile_no": mobileNo,
        "profile_image": profileImage,
        "show_interest": showInterest,
        "default_video_url_on_category": defaultVideoUrlOnCategory,
      };
}
