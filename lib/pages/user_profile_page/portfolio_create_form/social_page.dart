import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/new_portfolio_response.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class SocialPage extends StatefulWidget {
  final PortfolioSocial? social;
  const SocialPage({super.key, this.social});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController behanceController = TextEditingController();
  TextEditingController dribbleController = TextEditingController();
  TextEditingController instaController = TextEditingController();
  TextEditingController fbController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController pintrestController = TextEditingController();
  TextEditingController siteController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  bool mobileHidden = false;
  bool emailHidden = false;
  bool isAddPortfolioLoading = false;

  @override
  void initState() {
    phoneController = TextEditingController(
        text: widget.social?.mobNum ?? Preference.getString(Preference.PHONE));
    emailController = TextEditingController(
        text: widget.social?.email ??
            Preference.getString(Preference.USER_EMAIL));
    linkedinController = TextEditingController(text: widget.social?.linkedin);
    behanceController = TextEditingController(text: widget.social?.bee);
    dribbleController = TextEditingController(text: widget.social?.dribble);
    instaController = TextEditingController(text: widget.social?.insta);
    fbController = TextEditingController(text: widget.social?.facebook);
    twitterController = TextEditingController(text: widget.social?.twitter);
    pintrestController = TextEditingController(text: widget.social?.pinterest);
    siteController = TextEditingController(text: widget.social?.siteUrl);
    otherController = TextEditingController(text: widget.social?.other);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.WHITE,
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: ColorConstants.WHITE,
            centerTitle: true,
            title: Text(
              "Contact and Social",
              style: Styles.bold(size: 14),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              )
            ]),
        body: ScreenWithLoader(
          isLoading: isAddPortfolioLoading,
          body: BlocManager(
              initState: (value) {},
              child: BlocListener<HomeBloc, HomeState>(
                listener: (context, state) async {
                  if (state is AddSocialState) handleAddSocial(state);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xffE5E5E5)),
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: SizedBox(
                              width: 30,
                              height: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset('assets/images/call.svg'),
                                  VerticalDivider(
                                    thickness: 1,
                                    color: Color(0xffE5E5E5),
                                  ),
                                ],
                              ),
                            ),
                            hintText: 'Enter your mobile number',
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              mobileHidden = !mobileHidden;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                mobileHidden
                                    ? SvgPicture.asset(
                                        'assets/images/close_eye.svg')
                                    : Icon(
                                        Icons.remove_red_eye,
                                       size: 15,
                                        color: ColorConstants.GRADIENT_ORANGE,
                                      ),
                                VerticalDivider(),
                                Text(
                                  "Hide contact details on portfolio",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff5A5F73)),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            fillColor: ColorConstants.WHITE,
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xffE5E5E5)),
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: SizedBox(
                              width: 30,
                              height: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset('assets/images/email.svg'),
                                  VerticalDivider(
                                    thickness: 1,
                                    color: Color(0xffE5E5E5),
                                  ),
                                ],
                              ),
                            ),
                            hintText: 'Enter your email address',
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                emailHidden = !emailHidden;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  emailHidden
                                      ? SvgPicture.asset(
                                          'assets/images/close_eye.svg')
                                      : Icon(
                                          Icons.remove_red_eye,
                                          size: 15,
                                            color: ColorConstants.GRADIENT_ORANGE,
                                        ),
                                  VerticalDivider(),
                                  Text(
                                    "Hide email address on portfolio",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff5A5F73)),
                                  )
                                ],
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Text(
                                "Social",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                        customField(
                            imgPath: 'assets/images/google.png',
                            hintText: 'Enter your website',
                            controller: siteController),
                        customField(
                            imgPath: 'assets/images/linkedin.png',
                            hintText: 'linkedin/',
                            controller: linkedinController),
                        customField(
                            imgPath: 'assets/images/behance.png',
                            hintText: 'behance.net/',
                            controller: behanceController),
                        customField(
                            imgPath: 'assets/images/dribble.png',
                            hintText: 'dribbble.net/',
                            controller: dribbleController),
                        customField(
                            imgPath: 'assets/images/instagram.png',
                            hintText: 'instgram.com/',
                            controller: instaController),
                        customField(
                            imgPath: 'assets/images/facebook.png',
                            hintText: 'facebook.com/',
                            controller: fbController),
                        customField(
                            imgPath: 'assets/images/twitter.png',
                            hintText: 'twitter.com/',
                            controller: twitterController),
                        customField(
                            imgPath: 'assets/images/pinterest.png',
                            hintText: 'pintrest.com/',
                            controller: pintrestController),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            if (phoneController.value.text == '') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Phone no is required'),
                              ));
                            } else if (emailController.value.text == '') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Email is required'),
                              ));
                            } else {
                              Map<String, dynamic> data = Map();
                              data["mob_num"] = phoneController.value.text;
                              data["email"] = emailController.value.text;
                              data["linkedin"] = linkedinController.value.text;
                              data["bee"] = behanceController.value.text;
                              data["dribbl"] = dribbleController.value.text;
                              data["insta"] = instaController.value.text;
                              data["facebook"] = fbController.value.text;
                              data["twitter"] = twitterController.value.text;
                              data["pinterest"] = pintrestController.value.text;
                              data["other"] = "";
                              data["site_url"] = siteController.value.text;
                              data["mob_num_hidden"] = mobileHidden;
                              data["email_hidden"] = emailHidden;
                              print(data);
                              Preference.setString(
                                  Preference.PHONE, phoneController.value.text);
                              Preference.setString(Preference.USER_EMAIL,
                                  emailController.value.text);

                              addSocail(data);
                            }
                          },
                          child: Container(
                            height: height(context) * 0.06,
                            width: width(context) * 0.8,
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.all(20.0),
                            decoration: const BoxDecoration(
                                color: Color(0xff0E1638),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(21))),
                            child: const Center(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ));
  }

  Widget customField(
      {required String imgPath,
      required String hintText,
      required TextEditingController controller}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: ColorConstants.WHITE,
          filled: true,
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffE5E5E5)),
              borderRadius: BorderRadius.circular(10)),
          prefixIcon: SizedBox(
            width: 40,
            height: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Image.asset(
                    imgPath,
                  ),
                ),
                // SvgPicture.asset(imgPath),

                VerticalDivider(
                  thickness: 1,
                  color: Color(0xffE5E5E5),
                ),
              ],
            ),
          ),
          hintText: hintText,
        ),
      ),
    );
  }

  void addSocail(Map<String, dynamic> data) {
    BlocProvider.of<HomeBloc>(context).add(AddSocialEvent(data: data));
  }

  void handleAddSocial(AddSocialState state) {
    var addPortfolioState = state;
    setState(() {
      switch (addPortfolioState.apiState) {
        case ApiStatus.LOADING:
          Log.v(" Add social Portfolio....................");
          isAddPortfolioLoading = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Add Social....................");
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Information Successfully Updated'),
          ));
          isAddPortfolioLoading = false;
          break;
        case ApiStatus.ERROR:
          Log.v("Error Add Social....................");
          isAddPortfolioLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}
