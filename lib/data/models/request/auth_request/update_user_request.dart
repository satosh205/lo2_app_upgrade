import 'dart:convert';

import 'package:masterg/data/models/response/home_response/user_info_response.dart';

class UpdateUserRequest {
  String? firstName;
  String? lastName;
  String? gender;
  String? mobileNo;
  String? alternateMobileNo;
  String? emailAddress;
  String? dateOfBirth;
  String? whatsappId;
  String? facebookId;
  String? twitter;
  String? instagram;
  String? spouseFirstName;
  String? spouseLastName;
  String? spouseDob;
  String? spouseOccupation;
  String? educationQualification;
  String? address1;
  String? address2;
  String? landmark;
  String? postOffice;
  int? state;
  int? city;
  String? maritalStatus;
  String? anniversaryDate;
  String? isChildren;
  String? isAgree;
  String? gstNumber;
  String? panNumber;
  String? profilePic;
  List<RelationData>? relationData;

  UpdateUserRequest(
      {this.firstName,
      this.lastName,
      this.gender,
      this.mobileNo,
      this.alternateMobileNo,
      this.emailAddress,
      this.dateOfBirth,
      this.whatsappId,
      this.facebookId,
      this.spouseFirstName,
      this.spouseLastName,
      this.spouseDob,
      this.spouseOccupation,
      this.educationQualification,
      this.address1,
      this.address2,
      this.landmark,
      this.postOffice,
      this.state,
      this.city,
      this.maritalStatus,
      this.anniversaryDate,
      this.isChildren,
      this.isAgree,
      this.twitter,
      this.instagram,
      this.profilePic,
      this.gstNumber,
      this.panNumber,
      this.relationData});

  UpdateUserRequest.fromJson(Map<String?, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    mobileNo = json['mobile_no'];
    alternateMobileNo = json['alternate_mobile_no'];
    emailAddress = json['email_address'];
    dateOfBirth = json['date_of_birth'];
    whatsappId = json['whatsapp_id'];
    facebookId = json['facebook_id'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    spouseFirstName = json['spouse_first_name'];
    spouseLastName = json['spouse_last_name'];
    spouseDob = json['spouse_dob'];
    spouseOccupation = json['spouse_occupation'];
    educationQualification = json['education_qualification'];
    address1 = json['Address1'];
    address2 = json['Address2'];
    landmark = json['landmark'];
    postOffice = json['post_office'];
    state = json['state'];
    profilePic = json['profile_pic'];
    city = json['city'];
    maritalStatus = json['marital_status'];
    anniversaryDate = json['anniversary_date'];
    isChildren = json['is_children'];
    isAgree = json['is_agree'];
    gstNumber = json['gst_number'];
    panNumber = json['pan_number'];
    if (json['relation'] != null) {
      relationData = <RelationData>[];
      json['relation'].forEach((v) {
        relationData?.add(new RelationData.fromJson(v));
      });
    }
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['mobile_no'] = this.mobileNo;
    data['alternate_mobile_no'] = this.alternateMobileNo;
    data['email_address'] = this.emailAddress;
    data['date_of_birth'] = this.dateOfBirth;
    data['whatsapp_id'] = this.whatsappId;
    data['facebook_id'] = this.facebookId;
    data['spouse_first_name'] = this.spouseFirstName;
    data['spouse_last_name'] = this.spouseLastName;
    data['spouse_dob'] = this.spouseDob;
    data['spouse_occupation'] = this.spouseOccupation;
    data['education_qualification'] = this.educationQualification;
    data['Address1'] = this.address1;
    data['Address2'] = this.address2;
    data['post_office'] = this.postOffice;
    data['landmark'] = this.landmark;
    data['state'] = this.state;
    data['city'] = this.city;
    data['marital_status'] = this.maritalStatus;
    data['anniversary_date'] = this.anniversaryDate;
    data['is_children'] = this.isChildren;
    data['is_agree'] = this.isAgree;
    data['gst_number'] = this.gstNumber;
    data['pan_number'] = this.panNumber;
    data['profile_pic'] = profilePic;
    data['twitter'] = this.twitter;
    data['instagram'] = this.instagram;
    if (this.relationData != null) {
      final Map<String?, dynamic> relations = new Map<String?, dynamic>();
      relations['relation'] = this.relationData!.map((v) => v.toJson()).toList();
      data['relation'] = json.encode(relations).toString();
    }
    return data;
  }
}
