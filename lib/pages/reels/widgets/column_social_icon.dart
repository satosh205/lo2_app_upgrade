import 'package:flutter/material.dart';
import 'package:masterg/pages/reels/theme/colors.dart';

Widget getAlbum(albumImg) {
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
        // shape: BoxShape.circle,
        // color: black
        ),
    child: Stack(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(shape: BoxShape.circle, color: black),
        ),
        Center(
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(albumImg), fit: BoxFit.cover)),
          ),
        )
      ],
    ),
  );
}

Widget getIcons(icon, count, size, {color = white}) {
  return Container(
    child: Column(
      children: <Widget>[
        Icon(icon, color: color, size: size),
        SizedBox(
          height: 5,
        ),
        Text(
          count,
          style: TextStyle(
              color: white, fontSize: 12, fontWeight: FontWeight.w700),
        )
      ],
    ),
  );
}

Widget getProfile(img) {
  print(img);
  return Container(
    width: 36.56,
    height: 38.64,
    decoration: BoxDecoration(
        // border: Border.all(color: white),
        shape: BoxShape.circle,
        image: DecorationImage(
            image: img.toString().isNotEmpty &&
                    img != null &&
                    (img.toString().contains('jpg') ||
                        img.toString().contains('png') ||
                        img.toString().contains('jpeg'))
                ? NetworkImage(img)
                : NetworkImage(
                    'https://learningoxygen.com/theme1/images/profile/default.png'),
            fit: BoxFit.cover)),
  );
}
