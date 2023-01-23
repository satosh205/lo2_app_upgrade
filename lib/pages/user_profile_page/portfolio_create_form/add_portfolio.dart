import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class AddPortfolio extends StatefulWidget {
  const AddPortfolio({Key? key}) : super(key: key);

  @override
  State<AddPortfolio> createState() => _AddPortfolioState();
}

class _AddPortfolioState extends State<AddPortfolio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Add Portfolio",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            actions: const [
              Icon(
                Icons.close,
                color: Colors.black,
              )
            ]),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text(
                  "Project Title*",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5A5F73)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: width(context),
                  height: height(context) * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(width: 1.0, color: const Color(0xffE5E5E5)),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: TextField(
                      decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xffE5E5E5)),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Type project title here..',
                  )),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Project Description*",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5A5F73)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: width(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(width: 1.0, color: const Color(0xffE5E5E5)),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: TextField(
                    maxLines: 8,
                    decoration: InputDecoration(
                      // fillColor: Colors.grey.shade100,
                      // filled: true,
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Color(0xffE5E5E5)),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Type project description here',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Featured image*",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5A5F73)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/images/upload_icon.svg'),
                              Text(
                                "Upload Image",
                                style: Styles.bold(size: 12),
                              ),
                            ],
                          )),
                      SizedBox(
                        width: 4,
                      ),
                      const Text("Supported Format: .pdf, .doc, .jpeg",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff929BA3))),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Associated link (if any)*",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5A5F73)),
                ),
                SizedBox(
                  height: 5,
                ),
                CustomTextField(
                  hintText: 'https//',
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: customUploade(
                        uploadeText: 'Uploade Image',
                      ),
                    ),
                    Text("Supported Format: .pdf, .doc, .jpeg",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff929BA3))),
                  ],
                ),
                customButton()
              ])),
        ));
  }
}
