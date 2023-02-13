import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isFill = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController newController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Register with Email",
          style: Styles.semibold(color: ColorConstants.BLACK, size: 16),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: ColorConstants.BLACK,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        height: height(context) * 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[
                                ColorConstants.GRADIENT_ORANGE,
                                ColorConstants.GRADIENT_RED
                              ]).createShader(bounds);
                        },
                        child: Icon(
                          Icons.email_outlined,
                          size: 20,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Email ",
                      style: Styles.textRegular(),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: Container(
                  height: height(context) * 0.1,
                  child: TextField(
                    cursorColor: Color(0xffE5E5E5),
                    autofocus: false,
                    // focusNode: phoneFocus,
                    controller: emailController,
                    // keyboardType: TextInputType.number,
                    style: Styles.bold(
                      color: Color(0xffE5E5E5),
                      size: 14,
                    ),
                    // inputFormatters: <TextInputFormatter>[
                    //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    // ],

                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Color(0xffE5E5E5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Color(0xffE5E5E5),
                          width: 1.5,
                        ),
                      ),
                      fillColor: Color(0xffE5E5E5),
                      hintText: 'example@mail.com',
                      hintStyle: TextStyle(
                        color: Color(0xffE5E5E5),
                      ),
                      isDense: true,
                      prefixIconConstraints:
                          BoxConstraints(minWidth: 0, minHeight: 0),

                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: ColorConstants.WHITE),
                          borderRadius: BorderRadius.circular(10)),

                      helperStyle: Styles.regular(
                          size: 14,
                          color: ColorConstants.GREY_3.withOpacity(0.1)),
                      counterText: "",
                      // enabledBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(
                      //       color: ColorConstants.WHITE, width: 1.5),
                      // ),
                    ),
                    // onChanged: (value) {
                    //   setState(() {});
                    // },
                    // validator: (value) {
                    //   if (value == null) return 'Enter phone number';
                    //   if (value.length != 10) {
                    //     return "Enter valid phone number.";
                    //   }
                    //   return null;
                    // },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              ColorConstants.GRADIENT_ORANGE,
                              ColorConstants.GRADIENT_RED
                            ]).createShader(bounds);
                      },
                      child: Image.asset('assets/images/lock.png'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "New Password ",
                      style: Styles.textRegular(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: Container(
                  height: height(context) * 0.1,
                  child: TextField(
                    obscureText: true,
                    cursorColor: Color(0xffE5E5E5),
                    autofocus: false,
                    // focusNode: phoneFocus,
                    controller: newController,
                    // keyboardType: TextInputType.number,
                    style: Styles.bold(
                      color: Color(0xffE5E5E5),
                      size: 14,
                    ),
                    // inputFormatters: <TextInputFormatter>[
                    //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    // ],
                    maxLength: 8,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Color(0xffE5E5E5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Color(0xffE5E5E5),
                          width: 1.5,
                        ),
                      ),
                      fillColor: Color(0xffE5E5E5),
                      hintText: 'New password',
                      hintStyle: TextStyle(
                        color: Color(0xffE5E5E5),
                      ),
                      isDense: true,
                      prefixIconConstraints:
                          BoxConstraints(minWidth: 0, minHeight: 0),

                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: ColorConstants.WHITE),
                          borderRadius: BorderRadius.circular(10)),

                      helperStyle: Styles.regular(
                          size: 14,
                          color: ColorConstants.GREY_3.withOpacity(0.1)),
                      counterText: "",
                      // enabledBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(
                      //       color: ColorConstants.WHITE, width: 1.5),
                      // ),
                    ),
                    // onChanged: (value) {
                    //   setState(() {});
                    // },
                    // validator: (value) {
                    //   if (value == null) return 'Enter phone number';
                    //   if (value.length != 10) {
                    //     return "Enter valid phone number.";
                    //   }
                    //   return null;
                    // },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              ColorConstants.GRADIENT_ORANGE,
                              ColorConstants.GRADIENT_RED
                            ]).createShader(bounds);
                      },
                      child: Image.asset('assets/images/lock.png'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Confirm Password ",
                      style: Styles.textRegular(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: height(context) * 0.4,
                  child: TextField(
                    obscureText: true,
                    cursorColor: Color(0xffE5E5E5),
                    autofocus: false,
                    // focusNode: phoneFocus,
                    controller: passController,
                    // keyboardType: TextInputType.number,
                    style: Styles.bold(
                      color: Color(0xffE5E5E5),
                      size: 14,
                    ),
                    // inputFormatters: <TextInputFormatter>[
                    //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    // ],
                    maxLength: 8,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Color(0xffE5E5E5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Color(0xffE5E5E5),
                          width: 1.5,
                        ),
                      ),
                      fillColor: Color(0xffE5E5E5),
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(
                        color: Color(0xffE5E5E5),
                      ),
                      isDense: true,
                      prefixIconConstraints:
                          BoxConstraints(minWidth: 0, minHeight: 0),

                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: ColorConstants.WHITE),
                          borderRadius: BorderRadius.circular(10)),

                      helperStyle: Styles.regular(
                          size: 14,
                          color: ColorConstants.GREY_3.withOpacity(0.1)),
                      counterText: "",
                      // enabledBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(
                      //       color: ColorConstants.WHITE, width: 1.5),
                      // ),
                    ),
                    // onChanged: (value) {
                    //   setState(() {});
                    // },
                    // validator: (value) {
                    //   if (value == null) return 'Enter phone number';
                    //   if (value.length != 10) {
                    //     return "Enter valid phone number.";
                    //   }
                    //   return null;
                    // },
                  ),
                ),
              ),
              // SizedBox(
              //   height: 230,
              // ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  Container(
                    height: height(context) * 0.06,
                    decoration: BoxDecoration(
                      color: Color(0xffe9e9e9),
                      borderRadius: BorderRadius.circular(10),
                      gradient: emailController.value.text != '' &&
                              passController.value.text != ''
                          ? LinearGradient(colors: [
                              ColorConstants.GRADIENT_ORANGE,
                              ColorConstants.GRADIENT_RED,
                            ])
                          : null,
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: Styles.regular(
                            size: 16,
                            color: ColorConstants.WHITE,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
