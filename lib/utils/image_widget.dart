import 'dart:io';

import 'package:flutter/material.dart';

class ImageChooseWidget extends StatelessWidget {
  final Function()? selectImage;
  final bool isChooseVisible, isFromNetwork;
  final String? image;
  final String? backGroundIcon;
  final Widget? chooseIcon;
  final Color? iconBackColor;
  final double width;
  final double height;
  final double cameraRadius;
  final BoxDecoration? decoration;

  ImageChooseWidget({
    this.selectImage,
    this.chooseIcon,
    this.backGroundIcon,
    this.iconBackColor,
    this.width = 120,
    this.height = 120,
    this.cameraRadius = 20,
    this.decoration,
    this.isChooseVisible = true,
    this.isFromNetwork = false,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomRight, children: <Widget>[
      Container(
        decoration: decoration,
        width: width,
        height: height,
        child: InkWell(
          onTap: () {
            if (selectImage != null) {
              selectImage!();
            }
          },
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: MediaQuery.of(context).size.width / 6,
            child: image == null
                ? Icon(
                    Icons.person,
                    size: 70,
                  )
                : null,
            backgroundImage: image == null
                ? null
                : (isFromNetwork
                    ? NetworkImage(image!)
                    : FileImage(File(image!))) as ImageProvider<Object>?,
          ),
        ),
      ),
      Visibility(
        visible: isChooseVisible,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(cameraRadius)),
          ),
          child: InkWell(
            onTap: () {
              if (selectImage != null) {
                selectImage!();
              }
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: chooseIcon ??
                Icon(
                  Icons.image,
                  color: Colors.black,
                  size: 20,
                ),
          ),
        ),
      )
    ]);
  }
}
