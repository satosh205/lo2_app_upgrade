import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:masterg/pages/auth_pages/self_details_page.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../blocs/bloc_manager.dart';
import '../../blocs/home_bloc.dart';
import '../../data/api/api_service.dart';
import '../../utils/Log.dart';
import '../../utils/Strings.dart';
import '../../utils/utility.dart';
import '../custom_pages/ScreenWithLoader.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isFill = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confPassController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isCodeSent = false;
  bool codeVerified = false;
  bool _isLoading = false;
  bool _emailTrue = false;
  bool _codeVerifiedTrue = false;
  int endTime = 0;
  bool verifiedAutoFocus = true;

  @override
  void initState() {
    super.initState();
  }

  void fieldValidation() {
    print('fjskdjk');
    if (!_formKey.currentState!.validate()) return;

    print(';;;;;;;;');
    if(newPassController.text.isEmpty || confPassController.text.isEmpty){
      Utility.showSnackBar(
          scaffoldContext: context, message: 'Enter password and conform password.');
    }else{
      if(newPassController.text.toString().length > 7){
        if(newPassController.text == confPassController.text){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=> SelfDetailsPage(
                email: emailController.text.toString().trim(),
                password: confPassController.text.toString().trim(),
                loginWithEmail: true,
              )));
        }else{
          Utility.showSnackBar(
              scaffoldContext: context, message: 'The password does not match');
        }
      }else{
        Utility.showSnackBar(
            scaffoldContext: context, message: 'Security password min-length 8');
      }
    }
  }

  void sendEmailVerificationCode(String email) {
    BlocProvider.of<HomeBloc>(context).add(EmailCodeSendEvent(email: email, isSignup: 1));
  }

  void verifyOtp(String email, String otp){
    print('verify opt online');
    BlocProvider.of<HomeBloc>(context).add(VerifyEmailCodeEvent(email: email, code: otp));
  }

  void _handleEmailCodeSendResponse(EmailCodeSendState state) {
    print('_handlecompetitionListResponse');
    var emailCodeSendState = state;
    setState(() {
      switch (emailCodeSendState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("EmailCodeSend Suuuuuuuus....................");
          isCodeSent = true;
          _isLoading = false;
          Utility.showSnackBar(scaffoldContext: context, message: 'Verification code sent on your registered email');
          endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
          break;
        case ApiStatus.ERROR:
          Log.v("Error emailCodeSendState ..........................${emailCodeSendState.error}");
          Utility.showSnackBar(
              scaffoldContext: context, message: '${emailCodeSendState.error}');
          _isLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

   void handleVerifyOtp(VerifyEmailCodeState state) {
    var emailCodeSendState = state;
    setState(() {
      switch (emailCodeSendState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          codeVerified = false;
          break;
        case ApiStatus.SUCCESS:
          Log.v("VerifyOtp Suuuuuuuus....................");
         codeVerified = true;
          _codeVerifiedTrue = true;
          _isLoading = false;

          break;
        case ApiStatus.ERROR:
          Log.v("Error handleVerifyOtp ..........................${emailCodeSendState.error}");
          _isLoading = false;
          codeVerified = false;
          Utility.showSnackBar(
              scaffoldContext: context, message: 'Invalid Code');
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) async {
            if (state is EmailCodeSendState) {
              _handleEmailCodeSendResponse(state);
            }
            if(state is VerifyEmailCodeState){
              handleVerifyOtp(state);
            }
          },
          child: Scaffold(
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
            body: SafeArea(
                child: ScreenWithLoader(
              isLoading: _isLoading,
              body: Container(
                height: height(context) * 0.9,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ///Email Field--
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
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
                                width: 8,
                              ),
                              Text(
                                "Email ",
                                style: Styles.textRegular(),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 16, right: 16),
                          child: Container(
                            height: height(context) * 0.1,
                            child: TextFormField(
                              cursorColor: ColorConstants.GRADIENT_RED,
                              autofocus: true,
                              // focusNode: phoneFocus,
                              controller: emailController,
                              // keyboardType: TextInputType.number,
                              style: Styles.regular(
                                color: Color(0xff0E1638),
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
                                suffix: isCodeSent
                                    ? Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: ColorConstants.GREEN,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.done,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ) : GestureDetector(
                                  onTap: () {
                                    codeVerified = false;
                                    _codeVerifiedTrue = false;
                                    otpController.clear();
                                    newPassController.clear();
                                    confPassController.clear();
                                    if (emailController.value.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Please enter email'),
                                      ));
                                    } else if (_emailTrue == false) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Please enter valid email'),
                                      ));
                                    }else{
                                      sendEmailVerificationCode(emailController.value.text);
                                    }
                                  },
                                  child: GradientText(
                                          'Send Code',
                                          style: Styles.regular(size: 14),
                                          colors: _emailTrue == true ?
                                          [ColorConstants.GRADIENT_ORANGE,
                                            ColorConstants.GRADIENT_RED] :
                                          [ColorConstants.UNSELECTED_BUTTON,
                                            ColorConstants.UNSELECTED_BUTTON],
                                        ),
                                  /*child:Text("Send Code", style: TextStyle(color:
                                  isCodeSent == true ? Colors.red: null),),*/
                                ),
                                hintText: 'example@mail.com',
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
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    _emailTrue = false;
                                    isCodeSent = false;
                                    otpController.clear();
                                    newPassController.clear();
                                    confPassController.clear();
                                  } else {
                                    _emailTrue = true;
                                    otpController.clear();
                                    newPassController.clear();
                                    confPassController.clear();
                                  }
                                });
                              },
                              validator: (value) {
                                if (value == '') return 'Email is required';
                                int index = value?.length as int;

                                if (value![index - 1] == '.')
                                  return '${Strings.of(context)?.emailAddressError}';

                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value))
                                  return '${Strings.of(context)?.emailAddressError}';

                                isCodeSent = true;
                                return null;
                              },
                            ),
                          ),
                        ),

                        ///Re-Send Code
                        isCodeSent == true ? Row(
                          children: [
                            Expanded(child: SizedBox(),),
                            CountdownTimer(
                              endTime: endTime,
                              widgetBuilder: (_, CurrentRemainingTime? time) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 20.0, bottom: 15.0),
                                  child: RichText(
                                    text: TextSpan(
                                        text: '',
                                        style: TextStyle(
                                          fontSize: 3,
                                        ),
                                        children: <TextSpan>[
                                          time == null
                                              ? TextSpan(
                                              text:
                                              'Re-send code',
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  _emailTrue = false;
                                                  isCodeSent = false;
                                                  codeVerified = false;
                                                  _codeVerifiedTrue = false;
                                                  otpController.clear();
                                                  newPassController.clear();
                                                  confPassController.clear();
                                                  /*this.setState(() {
                                                    _emailTrue = false;
                                                    isCodeSent = false;
                                                  });*/
                                                  sendEmailVerificationCode(emailController.value.text);
                                                },
                                              style: Styles.regular(
                                                  size: 12,
                                                  color: ColorConstants.BLACK))
                                              : TextSpan(text: 'Resend in ${time.sec} secs', style:Styles.regular(
                                              size: 12,
                                              color: ColorConstants.BLACK) ),
                                        ]),
                                  ),
                                );
                              },
                            ),
                          ],
                        ) : SizedBox(),

                        ///enter email Code--
                        isCodeSent == true ? Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Text(
                                "Enter code received on your email ",
                                style: Styles.textRegular(),
                              ),
                            ],
                          ),
                        ): SizedBox(),
                        isCodeSent == true ? Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 16, right: 16),
                          child: Container(
                            height: height(context) * 0.1,
                            child: Stack(
                              children: [
                                TextFormField(
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  cursorColor: codeVerified == false ? ColorConstants.GRADIENT_RED: Colors.white,
                                  controller: otpController,
                                  style: Styles.otp(
                                    color: Colors.black,
                                    size: 14,
                                    letterSpacing: 40
                                  ),
                                  maxLength: 4,
                                  onChanged: (value){
                                    setState(() {
                                      if(value.length == 4){
                                        codeVerified = true;
                                      }else{
                                        codeVerified = false;
                                      }
                                    });
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
                                    // suffix: GestureDetector(
                                    //   onTap: () {
                                    //     print('object');
                                    //     //isCodeSent
                                    //   },
                                    //   child: GradientText(
                                    //     'Verify Code',
                                    //     style: Styles.regular(size: 14),
                                    //     colors: [
                                    //       isCodeSent != true
                                    //           ? ColorConstants.GRADIENT_ORANGE
                                    //           : ColorConstants.UNSELECTED_BUTTON,
                                    //       isCodeSent != true
                                    //           ? ColorConstants.GRADIENT_RED
                                    //           : ColorConstants.UNSELECTED_BUTTON,
                                    //     ],
                                    //   ),
                                    // ),

                                    fillColor: Color(0xffE5E5E5),
                                    hintText: '••••',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    isDense: true,
                                    prefixIconConstraints: BoxConstraints(
                                        minWidth: 0, minHeight: 0),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: ColorConstants.WHITE),
                                        borderRadius:
                                            BorderRadius.circular(10)),

                                    helperStyle: Styles.regular(
                                        size: 14,
                                        color: ColorConstants.GREY_3
                                            .withOpacity(0.1)),
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  top: 14,
                                  //bottom: 14,
                                  child: _codeVerifiedTrue
                                      ? Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: ColorConstants.GREEN,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.done,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      print('object ${otpController.value.text.length}');

                                      if(otpController.value.text.isEmpty){
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('Please enter verification code'),
                                        ));
                                      }else if(codeVerified == false){
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('Please enter valid 4 digit code'),
                                        ));
                                      }else{
                                        verifyOtp(emailController.value.text, otpController.value.text);
                                      }
                                    },
                                    child: GradientText(
                                      'Verify Code',
                                      style: Styles.regular(size: 14),
                                      colors: codeVerified == true ?
                                        [ColorConstants.GRADIENT_ORANGE,
                                        ColorConstants.GRADIENT_RED,] :
                                        [ColorConstants.UNSELECTED_BUTTON,
                                        ColorConstants.UNSELECTED_BUTTON,],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ): SizedBox(),

                        ///Password
                        _codeVerifiedTrue == true ? Column(
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
                                    //child: Image.asset('assets/images/lock.png'),
                                    child: Icon(
                                      Icons.lock_outline,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Password ",
                                    style: Styles.textRegular(),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 16, right: 16),
                              child: Container(
                                height: height(context) * 0.1,
                                child: TextField(
                                  obscureText: true,
                                  cursorColor: ColorConstants.GRADIENT_RED,
                                  autofocus: false,
                                  // focusNode: phoneFocus,
                                  controller: newPassController,
                                  // keyboardType: TextInputType.number,
                                  style: Styles.bold(
                                    color: Colors.black,
                                    size: 14,
                                  ),
                                  // inputFormatters: <TextInputFormatter>[
                                  //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  // ],
                                  maxLength: 20,
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
                                    hintText: 'password',
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
                                    //child: Image.asset('assets/images/lock.png'),
                                    child: Icon(
                                      Icons.lock_outline,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
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
                                  top: 8.0, left: 16, right: 16),
                              child: Container(
                                height: height(context) * 0.4,
                                child: TextField(
                                  obscureText: true,
                                  cursorColor: ColorConstants.GRADIENT_RED,
                                  autofocus: false,
                                  // focusNode: phoneFocus,
                                  controller: confPassController,
                                  // keyboardType: TextInputType.number,
                                  style: Styles.bold(
                                    color: Colors.black,
                                    size: 14,
                                  ),
                                  // inputFormatters: <TextInputFormatter>[
                                  //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  // ],
                                  maxLength: 20,
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
                          ],
                        ):SizedBox(),

                        _codeVerifiedTrue == true ? Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: height(context) * 0.06,
                                  decoration: BoxDecoration(
                                    //color: Color(0xffe9e9e9),
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: emailController.value.text != '' &&
                                            newPassController.value.text != ''
                                        ? LinearGradient(colors: [
                                            ColorConstants.GRADIENT_ORANGE,
                                            ColorConstants.GRADIENT_RED,
                                          ])
                                        : LinearGradient(colors: [
                                            ColorConstants.UNSELECTED_BUTTON,
                                            ColorConstants.UNSELECTED_BUTTON,
                                          ]),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      fieldValidation();
                                      // sendEmailVerificationCode();
                                    },
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
                        ):SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            )),
          ),
        ));
  }
}
