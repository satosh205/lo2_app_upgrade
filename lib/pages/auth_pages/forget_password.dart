import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:masterg/utils/validation.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController verifyController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var _pin;
    final String? hintText;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.WHITE,
          elevation: 0.0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: ColorConstants.BLACK,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Forgot Password",
            style: Styles.semibold(color: ColorConstants.BLACK, size: 16),
          ),
        ),
        body: Container(
            height: height(context) * 0.9,
            color: ColorConstants.WHITE,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 20),
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
                            child: Icon(Icons.mail_outline_outlined),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Enter your registered email",
                            style: Styles.textRegular(),
                          )
                        ],
                      ),
                    ),
                    textFieldStackWidget(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Enter code received on your email ",
                        style: Styles.textRegular(),
                      ),
                    ),
                    Container(
                      // color: Colors.red,
                      height: height(context) * 0.1,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Stack(children: [
                            TextFormField(
                              cursorColor: Color(0xffE5E5E5),
                              autofocus: false,
                              // focusNode: phoneFocus,
                              controller: verifyController,
                              keyboardType: TextInputType.number,
                              // style: Styles.bold(
                              //   color: Color(0xffE5E5E5),
                              //   size: 14,
                              // ),
                              style: TextStyle(
                                letterSpacing: 100.0,
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              maxLength: 4,
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
                                hintText: '•      •      •      •',
                                hintStyle: TextStyle(
                                  color: Color(0xffE5E5E5),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    top: 20, bottom: 20, right: 100, left: 10),
                                prefixIconConstraints:
                                    BoxConstraints(minWidth: 0, minHeight: 0),

                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: ColorConstants.WHITE),
                                    borderRadius: BorderRadius.circular(10)),

                                helperStyle: Styles.regular(
                                    size: 14,
                                    color:
                                        ColorConstants.GREY_3.withOpacity(0.1)),
                                counterText: "",
                                // enabledBorder: UnderlineInputBorder(
                                //   borderSide: BorderSide(
                                //       color: ColorConstants.WHITE, width: 1.5),
                                // ),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null) return 'Enter phone number';
                                if (value.length != 10) {
                                  return "Enter valid phone number.";
                                }
                                return null;
                              },
                            ),
                            Positioned(
                                top: 0,
                                bottom: 20,
                                right: 20,
                                child: InkWell(
                                  onTap: () {
                                    if (emailController.text
                                        .toString()
                                        .trim()
                                        .isNotEmpty) {
                                      if (emailController.text
                                              .toString()
                                              .length ==
                                          10) {
                                        // doLogin();
                                      } else {
                                        Utility.showSnackBar(
                                            scaffoldContext: context,
                                            message:
                                                'Enter valid phone number.');
                                      }
                                    } else {
                                      Utility.showSnackBar(
                                          scaffoldContext: context,
                                          message: 'Enter phone number.');
                                    }
                                  },
                                  child: Center(
                                    child: ShaderMask(
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
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 25),
                                        child: Text(
                                          "Verify code",
                                          style: Styles.regular(
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                          ])),
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
                      padding: const EdgeInsets.only(
                        left: 2,
                        right: 2,
                      ),
                      child: Container(
                        height: height(context) * 0.1,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            cursorColor: Color(0xffE5E5E5),
                            autofocus: false,
                            // focusNode: phoneFocus,
                            controller: newController,
                            keyboardType: TextInputType.number,
                            style: Styles.bold(
                              color: Color(0xffE5E5E5),
                              size: 14,
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            maxLength: 4,
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
                              hintText: 'New Password',
                              hintStyle: TextStyle(
                                color: Color(0xffE5E5E5),
                              ),
                              isDense: true,
                              prefixIconConstraints:
                                  BoxConstraints(minWidth: 0, minHeight: 0),

                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: ColorConstants.WHITE),
                                  borderRadius: BorderRadius.circular(10)),

                              helperStyle: Styles.regular(
                                  size: 14,
                                  color:
                                      ColorConstants.GREY_3.withOpacity(0.1)),
                              counterText: "",
                              // enabledBorder: UnderlineInputBorder(
                              //   borderSide: BorderSide(
                              //       color: ColorConstants.WHITE, width: 1.5),
                              // ),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                            validator: (value) {
                              if (value == null) return 'Enter phone number';
                              if (value.length != 10) {
                                return "Enter valid phone number.";
                              }
                              return null;
                            },
                          ),
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
                      padding: const EdgeInsets.only(
                        left: 2,
                        right: 2,
                      ),
                      child: Container(
                        height: height(context) * 0.1,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            cursorColor: Color(0xffE5E5E5),
                            autofocus: false,
                            // focusNode: phoneFocus,
                            controller: passController,
                            keyboardType: TextInputType.number,
                            style: Styles.bold(
                              color: Color(0xffE5E5E5),
                              size: 14,
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            maxLength: 4,
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
                                  borderSide: BorderSide(
                                      width: 1, color: ColorConstants.WHITE),
                                  borderRadius: BorderRadius.circular(10)),

                              helperStyle: Styles.regular(
                                  size: 14,
                                  color:
                                      ColorConstants.GREY_3.withOpacity(0.1)),
                              counterText: "",
                              // enabledBorder: UnderlineInputBorder(
                              //   borderSide: BorderSide(
                              //       color: ColorConstants.WHITE, width: 1.5),
                              // ),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                            validator: (value) {
                              if (value == null) return 'Enter phone number';
                              if (value.length != 10) {
                                return "Enter valid phone number.";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          height: height(context) * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: height(context) * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    ColorConstants.GRADIENT_ORANGE,
                                    ColorConstants.GRADIENT_RED,
                                  ]),
                                ),
                                child: Center(
                                  child: Text(
                                    'Back to Login',
                                    style: Styles.regular(
                                      size: 16,
                                      color: ColorConstants.WHITE,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ]),
            )));
  }

  Widget textFieldStackWidget() {
      var _formKey = GlobalKey<FormState>();

    return Form(
      key:  _formKey,
      child: Container(
        height: height(context) * 0.1,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(children: [
              TextFormField(
                cursorColor: Color(0xffE5E5E5),
                autofocus: false,
                controller: emailController,
                validator: (val) {
                  return validateEmail(val!);
                },
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
                  
                  contentPadding:
                      EdgeInsets.only(top: 20, bottom: 20, right: 100, left: 10),
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 0, minHeight: 0),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: ColorConstants.WHITE),
                      borderRadius: BorderRadius.circular(10)),
                  helperStyle: Styles.regular(
                      size: 14, color: ColorConstants.GREY_3.withOpacity(0.1)),
                  counterText: "",
                ),
               
              ),
              Positioned(
                  top: 0,
                  bottom: 10,
                  right: 20,
                  child: InkWell(
                    onTap: () {
    if( _formKey.currentState!.validate()){
print('ncie');
    }
    
    
                      // if (emailController.text.toString().trim().isNotEmpty) {
                      //   if (emailController.text.toString().length == 10) {
                      //     // doLogin();
                      //   } else {
                      //     Utility.showSnackBar(
                      //         scaffoldContext: context,
                      //         message: 'Enter valid phone number.');
                      //   }
                      // } else {
                      //   Utility.showSnackBar(
                      //       scaffoldContext: context,
                      //       message: 'Enter phone number.');
                      // }
                    },
                    child: Container(
                      // height: height(context) * 0.07,
                      // width: width(context) * 0.3,
    
                      child: Center(
                        child: ShaderMask(
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
                          child: Text(
                            "Send code",
                            style: Styles.regular(
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))
            ])),
      ),
    );
  }
}
