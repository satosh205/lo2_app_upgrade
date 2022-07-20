import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:masterg/utils/resource/colors.dart';

List<PlatformUiSettings>? buildUiSettings(BuildContext context) {
  return [
    AndroidUiSettings(
        toolbarTitle: '',
        toolbarColor: ColorConstants().primaryColor(),
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false),
    IOSUiSettings(
      title: '',
    ),
  ];
}
