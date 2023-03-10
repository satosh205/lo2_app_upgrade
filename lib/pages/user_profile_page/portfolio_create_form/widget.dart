import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? style;
  final TextEditingController? controller;
  final int maxLine;
  final bool? validate;
  final String? validationString;
  final int? maxChar;
  const CustomTextField(
      {Key? key,
      required this.hintText,
      this.style,
      this.controller,
      this.maxChar,
      this.maxLine = 1,
      this.validate = false,
      this.validationString = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: maxChar,
        controller: controller,
        validator: (value) {
          if (validate == false) return null;
          if (value == null || value.isEmpty) {
            return validationString;
          }
          return null;
        },
        maxLines: maxLine,
        decoration: InputDecoration(
          hintStyle: Styles.regular(size: 14,color: Color(0xff929BA3)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xffE5E5E5)),
              borderRadius: BorderRadius.circular(10)),
          hintText: hintText,
        ));
  }
}

class GradientText extends StatelessWidget {
  final Widget child;
  const GradientText({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Color(0xfffc7804), ColorConstants.GRADIENT_RED])
            .createShader(bounds);
      },
      child: child,
    );
  }
}

class CustomUpload extends StatelessWidget {
  final String uploadText;
  final Function onClick;
  const CustomUpload(
      {Key? key, required this.uploadText, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Container(
        width: width(context),
        height: height(context) * 0.07,
        decoration: BoxDecoration(
          color: Colors.white,
          
              //  borderSide: const BorderSide(width: 1, color: Color(0xffE5E5E5)),
              // borderRadius: BorderRadius.circular(10)),
          border: Border.all(width: 1.0,color: Color.fromARGB(255, 142, 142, 142)),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: .0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/images/upload_icon.svg'),
                      Text(
                        uploadText,
                        style: Styles.bold(size: 12),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class PortfolioCustomButton extends StatelessWidget {
  final Function clickAction;
  const PortfolioCustomButton({Key? key, required this.clickAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        clickAction();
      },
      child: Container(
        height: height(context) * 0.06,
        width: width(context) ,
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 20,),
        decoration: const BoxDecoration(
            color: Color(0xff0E1638),
            borderRadius: BorderRadius.all(Radius.circular(26))),
        child: const Center(
          child: Text(
            "Save",
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
