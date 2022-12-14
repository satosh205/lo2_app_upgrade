class popularCourses {
  Data? data;
  int? status;
  List<dynamic>? error;

  popularCourses({this.data, this.status, this.error});

  popularCourses.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
    if (json['error'] != null) {
      error = List<dynamic>.from(json["error"].map((x) => x));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    if (this.error != null) {
      data['error'] = this.error!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  List<PopularCourses>? list;
  List<ShortTerm>? shortTerm;
  List<Recommended>? recommended;
  List<MostViewed>? mostViewed;
  List<HighlyRated>? highlyRated;
  List<OtherLearners>? otherLearners;

  Data(
      {this.list,
      this.shortTerm,
      this.recommended,
      this.mostViewed,
      this.highlyRated,
      this.otherLearners});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <PopularCourses>[];
      json['list'].forEach((v) {
        list!.add(new PopularCourses.fromJson(v));
      });
    }
    if (json['short_term'] != null) {
      shortTerm = <ShortTerm>[];
      json['short_term'].forEach((v) {
        shortTerm!.add(new ShortTerm.fromJson(v));
      });
    }
    if (json['recommended'] != null) {
      recommended = <Recommended>[];
      json['recommended'].forEach((v) {
        recommended!.add(new Recommended.fromJson(v));
      });
    }
    if (json['most_viewed'] != null) {
      mostViewed = <MostViewed>[];
      json['most_viewed'].forEach((v) {
        mostViewed!.add(new MostViewed.fromJson(v));
      });
    }
    if (json['highly_rated'] != null) {
      highlyRated = <HighlyRated>[];
      json['highly_rated'].forEach((v) {
        highlyRated!.add(new HighlyRated.fromJson(v));
      });
    }
    if (json['other_learners'] != null) {
      otherLearners = <OtherLearners>[];
      json['other_learners'].forEach((v) {
        otherLearners!.add(new OtherLearners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    if (this.shortTerm != null) {
      data['short_term'] = this.shortTerm!.map((v) => v.toJson()).toList();
    }
    if (this.recommended != null) {
      data['recommended'] = this.recommended!.map((v) => v.toJson()).toList();
    }
    if (this.mostViewed != null) {
      data['most_viewed'] = this.mostViewed!.map((v) => v.toJson()).toList();
    }
    if (this.highlyRated != null) {
      data['highly_rated'] = this.highlyRated!.map((v) => v.toJson()).toList();
    }
    if (this.otherLearners != null) {
      data['other_learners'] =
          this.otherLearners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShortTerm {
  int? id;
  int? organizationId;
  String? name;
  String? description;
  int? categoryId;
  int? regularPrice;
  int? salePrice;
  String? shortCode;
  int? admissionStartDate;
  int? admissionEndDate;
  String? type;
  int? startDate;
  int? endDate;
  String? image;
  String? duration;
  String? contents;
  int? totalCoins;
  String? trainer;
  String? totalView;
  String? subscriptionType;
  bool? isSubscribed;
  int? completionPer;
  int? enrolmentCount;

  ShortTerm(
      {this.id,
      this.organizationId,
      this.name,
      this.description,
      this.categoryId,
      this.regularPrice,
      this.salePrice,
      this.shortCode,
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
      this.subscriptionType,
      this.isSubscribed,
      this.enrolmentCount,
      this.completionPer});

  ShortTerm.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationId = json['organization_id'];
    name = json['name'];
    description = json['description'];
    categoryId = json['category_id'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    admissionStartDate = json['admission_start_date'];
    admissionEndDate = json['admission_end_date'];
    type = json['type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'];
    duration = json['duration'];
    contents = json['contents'];
    totalCoins = json['total_coins'];
    trainer = json['trainer'];
    shortCode = json['short_code'];
    totalView = json['total_view'];
    subscriptionType = json['subscription_type'];
    isSubscribed = json['is_subscribed'];
    shortCode = json['short_code'];
    completionPer = json['completion_per'];
    enrolmentCount = json['enrolment_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organization_id'] = this.organizationId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['category_id'] = this.categoryId;
    data['regular_price'] = this.regularPrice;
    data['short_code'] = this.shortCode;
    data['sale_price'] = this.salePrice;
    data['admission_start_date'] = this.admissionStartDate;
    data['admission_end_date'] = this.admissionEndDate;
    data['type'] = this.type;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['image'] = this.image;
    data['duration'] = this.duration;
    data['contents'] = this.contents;
    data['total_coins'] = this.totalCoins;
    data['trainer'] = this.trainer;
    data['total_view'] = this.totalView;
    data['completion_per'] = this.completionPer;
    data['is_subscribed'] = this.isSubscribed;
    data['subscription_type'] = this.subscriptionType;
    data['enrolment_count'] = this.enrolmentCount;
    data['short_code'] = this.shortCode;
    return data;
  }
}

class Recommended {
  int? id;
  int? organizationId;
  String? name;
  String? description;
  int? categoryId;
  int? regularPrice;
  String? shortCode;
  String? categoryName;
  int? salePrice;
  int? admissionStartDate;
  int? admissionEndDate;
  String? type;
  int? startDate;
  int? endDate;
  String? image;
  String? duration;
  String? contents;
  int? totalCoins;
  String? trainer;
  String? totalView;
  String? subscriptionType;
  bool? isSubscribed;
  int? completionPer;
  int? enrolmentCount;
  String? approvalStatus;

  Recommended(
      {this.id,
      this.organizationId,
      this.name,
      this.description,
      this.categoryId,
      this.regularPrice,
      this.salePrice,
      this.admissionStartDate,
      this.admissionEndDate,
      this.type,
      this.startDate,
      this.endDate,
      this.image,
      this.duration,
      this.contents,
      this.totalCoins,
      this.shortCode,
      this.trainer,
      this.totalView,
      this.subscriptionType,
      this.isSubscribed,
      this.enrolmentCount,
      this.categoryName,
      this.completionPer,
      this.approvalStatus});

  Recommended.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationId = json['organization_id'];
    name = json['name'];
    description = json['description'];
    categoryId = json['category_id'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    categoryName = json['category_name'];
    admissionStartDate = json['admission_start_date'];
    admissionEndDate = json['admission_end_date'];
    type = json['type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'];
    duration = json['duration'];
    contents = json['contents'];
    totalCoins = json['total_coins'];
    trainer = json['trainer'];
    totalView = json['total_view'];
    subscriptionType = json['subscription_type'];
    isSubscribed = json['is_subscribed'];
    completionPer = json['completion_per'];
    enrolmentCount = json['enrolment_count'];
    shortCode = json['short_code'];
    approvalStatus = json['approval_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organization_id'] = this.organizationId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['category_id'] = this.categoryId;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['admission_start_date'] = this.admissionStartDate;
    data['admission_end_date'] = this.admissionEndDate;
    data['type'] = this.type;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['image'] = this.image;
    data['category_name'] = this.categoryName;
    data['duration'] = this.duration;
    data['contents'] = this.contents;
    data['total_coins'] = this.totalCoins;
    data['trainer'] = this.trainer;
    data['total_view'] = this.totalView;
    data['short_code'] = this.shortCode;
    data['completion_per'] = this.completionPer;
    data['is_subscribed'] = this.isSubscribed;
    data['subscription_type'] = this.subscriptionType;
    data['enrolment_count'] = this.enrolmentCount;
    data['approval_status'] = this.approvalStatus;
    return data;
  }
}

class HighlyRated {
  int? id;
  int? organizationId;
  String? name;
  String? description;
  int? categoryId;
  int? regularPrice;
  String? shortCode;
  int? salePrice;
  int? admissionStartDate;
  int? admissionEndDate;
  String? type;
  int? startDate;
  int? endDate;
  String? image;
  String? duration;
  String? contents;
  int? totalCoins;
  String? trainer;
  String? totalView;
  String? subscriptionType;
  bool? isSubscribed;
  int? completionPer;
  int? enrolmentCount;

  HighlyRated(
      {this.id,
      this.organizationId,
      this.name,
      this.description,
      this.categoryId,
      this.regularPrice,
      this.salePrice,
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
      this.shortCode,
      this.totalView,
      this.subscriptionType,
      this.isSubscribed,
      this.enrolmentCount,
      this.completionPer});

  HighlyRated.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationId = json['organization_id'];
    name = json['name'];
    description = json['description'];
    categoryId = json['category_id'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    admissionStartDate = json['admission_start_date'];
    admissionEndDate = json['admission_end_date'];
    type = json['type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'];
    duration = json['duration'];
    contents = json['contents'];
    totalCoins = json['total_coins'];
    trainer = json['trainer'];
    totalView = json['total_view'];
    subscriptionType = json['subscription_type'];
    isSubscribed = json['is_subscribed'];
    completionPer = json['completion_per'];
    enrolmentCount = json['enrolment_count'];
    shortCode = json['short_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organization_id'] = this.organizationId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['category_id'] = this.categoryId;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['admission_start_date'] = this.admissionStartDate;
    data['admission_end_date'] = this.admissionEndDate;
    data['type'] = this.type;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['image'] = this.image;
    data['duration'] = this.duration;
    data['contents'] = this.contents;
    data['total_coins'] = this.totalCoins;
    data['trainer'] = this.trainer;
    data['total_view'] = this.totalView;
    data['completion_per'] = this.completionPer;
    data['is_subscribed'] = this.isSubscribed;
    data['subscription_type'] = this.subscriptionType;
    data['enrolment_count'] = this.enrolmentCount;
    data['short_code'] = this.shortCode;
    return data;
  }
}

class OtherLearners {
  int? id;
  int? organizationId;
  String? name;
  String? description;
  int? categoryId;
  int? regularPrice;
  String? shortCode;
  int? salePrice;
  int? admissionStartDate;
  int? admissionEndDate;
  String? type;
  int? startDate;
  int? endDate;
  String? image;
  String? duration;
  String? contents;
  int? totalCoins;
  String? trainer;
  String? totalView;
  String? subscriptionType;
  bool? isSubscribed;
  int? completionPer;
  int? enrolmentCount;
  String? approvalStatus;

  OtherLearners(
      {this.id,
      this.organizationId,
      this.name,
      this.description,
      this.categoryId,
      this.regularPrice,
      this.salePrice,
      this.admissionStartDate,
      this.admissionEndDate,
      this.type,
      this.startDate,
      this.endDate,
      this.image,
      this.shortCode,
      this.duration,
      this.contents,
      this.totalCoins,
      this.trainer,
      this.totalView,
      this.subscriptionType,
      this.isSubscribed,
      this.enrolmentCount,
      this.completionPer,
      this.approvalStatus});

  OtherLearners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationId = json['organization_id'];
    name = json['name'];
    description = json['description'];
    categoryId = json['category_id'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    admissionStartDate = json['admission_start_date'];
    admissionEndDate = json['admission_end_date'];
    type = json['type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'];
    duration = json['duration'];
    contents = json['contents'];
    totalCoins = json['total_coins'];
    trainer = json['trainer'];
    totalView = json['total_view'];
    subscriptionType = json['subscription_type'];
    isSubscribed = json['is_subscribed'];
    completionPer = json['completion_per'];
    shortCode = json['short_code'];
    enrolmentCount = json['enrolment_count'];
    approvalStatus = json['approval_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organization_id'] = this.organizationId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['category_id'] = this.categoryId;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['admission_start_date'] = this.admissionStartDate;
    data['admission_end_date'] = this.admissionEndDate;
    data['type'] = this.type;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['image'] = this.image;
    data['duration'] = this.duration;
    data['contents'] = this.contents;
    data['total_coins'] = this.totalCoins;
    data['trainer'] = this.trainer;
    data['total_view'] = this.totalView;
    data['completion_per'] = this.completionPer;
    data['is_subscribed'] = this.isSubscribed;
    data['subscription_type'] = this.subscriptionType;
    data['enrolment_count'] = this.enrolmentCount;
    data['short_code'] = this.shortCode;
    data['approval_status'] = this.approvalStatus;
    return data;
  }
}

class MostViewed {
  int? id;
  int? organizationId;
  String? name;
  String? description;
  int? categoryId;
  int? regularPrice;
  String? shortCode;
  int? salePrice;
  int? admissionStartDate;
  int? admissionEndDate;
  String? type;
  int? startDate;
  int? endDate;
  String? image;
  String? duration;
  String? contents;
  int? totalCoins;
  String? trainer;
  String? totalView;
  String? subscriptionType;
  bool? isSubscribed;
  int? completionPer;
  int? enrolmentCount;

  MostViewed(
      {this.id,
      this.organizationId,
      this.name,
      this.description,
      this.categoryId,
      this.regularPrice,
      this.salePrice,
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
      this.subscriptionType,
      this.isSubscribed,
      this.shortCode,
      this.enrolmentCount,
      this.completionPer});

  MostViewed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationId = json['organization_id'];
    name = json['name'];
    description = json['description'];
    categoryId = json['category_id'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    admissionStartDate = json['admission_start_date'];
    admissionEndDate = json['admission_end_date'];
    type = json['type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'];
    duration = json['duration'];
    contents = json['contents'];
    totalCoins = json['total_coins'];
    trainer = json['trainer'];
    totalView = json['total_view'];
    subscriptionType = json['subscription_type'];
    isSubscribed = json['is_subscribed'];
    completionPer = json['completion_per'];
    enrolmentCount = json['enrolment_count'];
    shortCode = json['short_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organization_id'] = this.organizationId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['category_id'] = this.categoryId;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['admission_start_date'] = this.admissionStartDate;
    data['admission_end_date'] = this.admissionEndDate;
    data['type'] = this.type;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['image'] = this.image;
    data['duration'] = this.duration;
    data['contents'] = this.contents;
    data['total_coins'] = this.totalCoins;
    data['trainer'] = this.trainer;
    data['total_view'] = this.totalView;
    data['completion_per'] = this.completionPer;
    data['is_subscribed'] = this.isSubscribed;
    data['subscription_type'] = this.subscriptionType;
    data['enrolment_count'] = this.enrolmentCount;
    data['short_code'] = this.shortCode;
    return data;
  }
}

class PopularCourses {
  int? id;
  int? organizationId;
  String? name;
  String? description;
  int? categoryId;
  int? regularPrice;
  int? salePrice;
  String? shortCode;
  int? admissionStartDate;
  int? admissionEndDate;
  String? type;
  int? startDate;
  int? endDate;
  String? image;
  String? duration;
  String? contents;
  int? totalCoins;
  String? trainer;
  String? totalView;
  String? subscriptionType;
  bool? isSubscribed;
  int? enrolmentCount;
  int? completionPer;
  String? approvalStatus;

  PopularCourses(
      {this.id,
      this.organizationId,
      this.name,
      this.description,
      this.categoryId,
      this.regularPrice,
      this.salePrice,
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
      this.shortCode,
      this.totalView,
      this.subscriptionType,
      this.isSubscribed,
      this.enrolmentCount,
      this.completionPer,
      this.approvalStatus});

  PopularCourses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationId = json['organization_id'];
    name = json['name'];
    description = json['description'];
    categoryId = json['category_id'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    admissionStartDate = json['admission_start_date'];
    admissionEndDate = json['admission_end_date'];
    type = json['type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'];
    duration = json['duration'];
    contents = json['contents'];
    totalCoins = json['total_coins'];
    trainer = json['trainer'];
    totalView = json['total_view'];
    subscriptionType = json['subscription_type'];
    isSubscribed = json['is_subscribed'];
    enrolmentCount = json['enrolment_count'];
    completionPer = json['completion_per'];
    shortCode = json['short_code'];
    approvalStatus = json['approval_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organization_id'] = this.organizationId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['category_id'] = this.categoryId;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['admission_start_date'] = this.admissionStartDate;
    data['admission_end_date'] = this.admissionEndDate;
    data['type'] = this.type;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['image'] = this.image;
    data['duration'] = this.duration;
    data['contents'] = this.contents;
    data['total_coins'] = this.totalCoins;
    data['trainer'] = this.trainer;
    data['total_view'] = this.totalView;
    data['completion_per'] = this.completionPer;
    data['is_subscribed'] = this.isSubscribed;
    data['subscription_type'] = this.subscriptionType;
    data['enrolment_count'] = this.enrolmentCount;
    data['short_code'] = this.shortCode;
    data['approval_status'] = this.approvalStatus;
    return data;
  }
}
