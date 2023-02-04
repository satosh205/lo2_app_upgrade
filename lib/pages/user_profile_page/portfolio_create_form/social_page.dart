import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/constant.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Contact and Social",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right:8.0),
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                  
                    border: OutlineInputBorder(
                    
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffE5E5E5)),
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
                const SizedBox(
                  height: 20,
                ),
                TextField(
                   keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffE5E5E5)),
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: SizedBox(
                      width: 30,
                      height: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:  [
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
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children:  [
                      SvgPicture.asset('assets/images/close_eye.svg'),
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
                // Container(
                //   width: width(context),
                //   height: height(context) * 0.08,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                //     borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //       children: [
                //         SvgPicture.asset('assets/images/linkedin.svg'),
                //         VerticalDivider(
                //           thickness: 1,
                //           color: Color(0xffE5E5E5),
                //         ),
                //         // SizedBox(
                //         //   width: width(context) * 0.6,
                //         //   child: TextField(
                //         //     controller: linkedinController,
                //         //   ),
                //         // ),
                //         Text("linkedin/",
                //             style: TextStyle(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w400,
                //                 color: Color(0xff929BA3))),
                //         Spacer(),
                //          GradientText(child: Text("Connect linkedin",style: TextStyle(fontSize: 10),))
                //       ],
                //     ),
                //   ),
                // ),
                customField(imgPath:'assets/images/linkedin.svg', hintText: 'Enter your website', controller: siteController ),
                customField(imgPath:'assets/images/linkedin.svg', hintText: 'linkedin/', controller: linkedinController ),
                customField(imgPath:'assets/images/behance.svg', hintText: 'behance.net/', controller: behanceController ),
                customField(imgPath:'assets/images/dribble.svg', hintText: 'dribbble.net/', controller: dribbleController ),
                customField(imgPath:'assets/images/instagram.svg', hintText: 'instgram.com/', controller: instaController ),
                customField(imgPath:'assets/images/facebook.svg', hintText: 'facebook.com/', controller: fbController ),
                customField(imgPath:'assets/images/twitter.svg', hintText: 'twitter.com/', controller: twitterController ),
                customField(imgPath:'assets/images/pintrest.svg', hintText: 'pintrest.com/', controller: pintrestController ),
                const SizedBox(
                  height: 15,
                ),
                // Container(
                //   width: width(context),
                //   height: height(context) * 0.08,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                //     borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //       children: [
                //          SvgPicture.asset('assets/images/behance.svg'),
                //         VerticalDivider(
                //           thickness: 1,
                //           color: Color(0xffE5E5E5),
                //         ),
                //         Text("behance.net/",
                //             style: TextStyle(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w400,
                //                 color: Color(0xff929BA3))),
                //         Spacer(),
                //          GradientText(child: Text("Connect behance",style: TextStyle(fontSize: 10),))
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   width: width(context),
                //   height: height(context) * 0.08,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                //     borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //       children:[
                //          SvgPicture.asset('assets/images/dribble.svg'),
                //         VerticalDivider(
                //           thickness: 1,
                //           color: Color(0xffE5E5E5),
                //         ),
                //         Text("dribbble.net/",
                //             style: TextStyle(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w400,
                //                 color: Color(0xff929BA3))),
                //         Spacer(),
                //          GradientText(child: Text("Connect dribble",style: TextStyle(fontSize: 10),))
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   width: width(context),
                //   height: height(context) * 0.08,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                //     borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //       children:  [
                //          SvgPicture.asset('assets/images/instagram.svg'),
                //         VerticalDivider(
                //           thickness: 1,
                //           color: Color(0xffE5E5E5),
                //         ),
                //         Text("instagram.com/",
                //             style: TextStyle(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w400,
                //                 color: Color(0xff929BA3))),
                //         Spacer(),
                //          GradientText(child: Text("Connect instagram",style: TextStyle(fontSize: 10),))
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   width: width(context),
                //   height: height(context) * 0.08,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                //     borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //       children:  [
                //          SvgPicture.asset('assets/images/facebook.svg'),
                //         VerticalDivider(
                //           thickness: 1,
                //           color: Color(0xffE5E5E5),
                //         ),
                //         Text("facebook.com/",
                //             style: TextStyle(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w400,
                //                 color: Color(0xff929BA3))),
                //         Spacer(),
                //          GradientText(child: Text("Connect facebook",style: TextStyle(fontSize: 10),))
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   width: width(context),
                //   height: height(context) * 0.08,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                //     borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //       children:  [
                //          SvgPicture.asset('assets/images/twitter.svg'),
                //         VerticalDivider(
                //           thickness: 1,
                //           color: Color(0xffE5E5E5),
                //         ),
                //         Text("twitter.com/",
                //             style: TextStyle(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w400,
                //                 color: Color(0xff929BA3))),
                //         Spacer(),
                //          GradientText(child: Text("Connect twitter",style: TextStyle(fontSize: 10),))
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   width: width(context),
                //   height: height(context) * 0.08,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                //     borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //       children:  [
                //          SvgPicture.asset('assets/images/pintrest.svg'),
                //         VerticalDivider(
                //           thickness: 1,
                //           color: Color(0xffE5E5E5),
                //         ),
                //         Text("pinterest.com/",
                //             style: TextStyle(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w400,
                //                 color: Color(0xff929BA3))),
                //         Spacer(),
                //         GradientText(child: Text("Connect pinterest",style: TextStyle(fontSize: 10),))
                //       ],
                //     ),
                //   ),
                // ),
                InkWell(
                  onTap: (){
                    Map<String, dynamic> data = Map();
                    data['mob_num'] = phoneController.value.text;
data["email"] = emailController.value.text;
data["linkedin"] = linkedinController.value.text;
data["bee"] = behanceController.value.text;
data["dribbl"] = dribbleController.value.text;
data["insta"] = instaController.value.text;
data["facebook"] = instaController.value.text;
data["twitter"] = twitterController.value.text;
data["pinterest"] = pintrestController.value.text;
data["other"] = "";
data["site_url"] = siteController.value.text;
data["mob_num_hidden"] = mobileHidden;
data["email_hidden"] = emailHidden;
print(data);
addSocail(data);
                  },
                  child: Container(
                    height: height(context) * 0.06,
                    width: width(context) * 0.8,
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                        color: Color(0xff0E1638),
                        borderRadius: BorderRadius.all(Radius.circular(21))),
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
        ));
  }

  Widget customField({required String imgPath,required String hintText,required TextEditingController controller}){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffE5E5E5)),
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: SizedBox(
                        width: 30,
                        height: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:  [
                              SvgPicture.asset(imgPath),
                            
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


  void addSocail(Map<String, dynamic> data){
    BlocProvider.of<HomeBloc>(context).add(AddSocialEvent(data: data));
  }
}
