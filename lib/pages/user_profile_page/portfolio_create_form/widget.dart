import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? style;
  const CustomTextField({Key? key, required this.hintText, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context),
      height: height(context) * 0.07,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1.0, color: const Color(0xffE5E5E5)),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xffE5E5E5)),
              borderRadius: BorderRadius.circular(10)),
          hintText: hintText,
        ),
      ),
    );
  }
}

class customUploade extends StatelessWidget {
  final String uploadeText;
  const customUploade({Key? key, required this.uploadeText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context),
      height: height(context) * 0.07,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1.0, color: const Color(0xffE5E5E5)),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: .0),
        child: Row(
          children: [
            ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        Color(0xfffc7804),
                        ColorConstants.GRADIENT_RED
                      ]).createShader(bounds);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 90.0),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/images/upload_icon.svg'),
                      Text(
                        uploadeText,
                        style: Styles.bold(size: 12),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class customButton extends StatelessWidget {
  final String? buttonText;
  const customButton({Key? key, this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context) * 0.06,
      width: width(context) * 0.9,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
          color: Color(0xff0E1638),
          borderRadius: BorderRadius.all(Radius.circular(21))),
      child: const Center(
        child: Text(
          "Save",
          style: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CustomDescription extends StatelessWidget {
  final String? hintText;
  const CustomDescription({Key? key, this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width(context),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1.0, color: const Color(0xffE5E5E5)),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: TextField(
          maxLines: 6,
          decoration: InputDecoration(
            // fillColor: Colors.grey.shade100,
            // filled: true,
            border: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: Color(0xffE5E5E5)),
                borderRadius: BorderRadius.circular(10)),
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}
