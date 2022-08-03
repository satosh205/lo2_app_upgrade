class BrandModel {
  String? title;
  String? image;
  int? id;

  BrandModel({
    this.title,
    this.image,
    this.id
  });

  factory BrandModel.fromJson(Map<String, dynamic> parsedJson) {
    return BrandModel(
        title: parsedJson['title'] as String,
        image: parsedJson['image'] as String,
        id: parsedJson['id'] as int,
    );
  }
}



