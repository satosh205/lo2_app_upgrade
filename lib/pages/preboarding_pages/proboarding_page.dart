import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/main.dart';
import 'package:masterg/pages/auth_pages/choose_language.dart';
import 'package:masterg/pages/auth_pages/sign_up_screen.dart';
import 'package:masterg/pages/custom_pages/TapWidget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/images.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../utils/utility.dart';
import '../auth_pages/singularis_login_username_pass.dart';

class PreBoardingPage extends StatefulWidget {
  @override
  _PreBoardingPageState createState() => _PreBoardingPageState();
}

class _PreBoardingPageState extends State<PreBoardingPage> {
  List<Widget> _pages = [];
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((duration) {
        _pages.add(_pageItem(0));
        _pages.add(_pageItem(1));
        _pages.add(_pageItem(2));
        setState(() {});
      });
    }
    //Preference.setBool(Preference.IS_ON_BOARDING_COMPLETE, true);
  }

  @override
  Widget build(BuildContext context) {
    Application(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              _pageView(),
              _loginRegisterWidget(_currentIndex),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginRegisterWidget(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
      child: Container(
        color: Colors.white,
        // alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _dots(index),
            SizedBox(height: 30,),
            TapWidget(
              onTap: () async{

                /*Navigator.push(
                    context,
                    NextPageRoute(
                        SignUpScreen()
                      //   ChooseLanguage(
                      //   showEdulystLogo: true,
                      // )
                    ));*/

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SingularisLogin()));


                /*if(await Utility.getCurrentLocale() == 'en-IN'){

                }else{

                }*/
              },
              /*child: Image.asset(
                "assets/images/next.png",
                height: 50,
                width: 50,
              ),*/
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient:
                  LinearGradient(colors: [
                    ColorConstants.GRADIENT_ORANGE,
                    ColorConstants.GRADIENT_RED,]),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Get Started', style: TextStyle(color: Colors.white, fontSize: 16,
                        fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _pageView() {
    return Expanded(
      child: PageView.builder(
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: _pages[index],
          );
        },
        allowImplicitScrolling: false,
        itemCount: _pages.length,
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        controller: PageController(
          viewportFraction: 1,
          initialPage: 0,
        ),
      ),
    );
  }

  Widget _pageItem(int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          //_buildContentTitle(index),
          SizedBox(
            height: 10,
          ),
          Container(
            //height: 300,
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Image.asset(PreBoardingData.getDat()[index]['image'],
                    fit: BoxFit.cover, height: 300, width: double.infinity),
              ),
            ),
          ),

          SizedBox(
            height: 70,
          ),
          _buildContentTitle(index),

          Expanded(
            flex: 20,
            child: _buildContent(index),
          )
        ],
      ),
    );
  }

  _dots(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DotsIndicator(
          dotsCount: 3,
          position: index.toDouble(),
          decorator: DotsDecorator(
            size: const Size.square(8.0),
            color: Color(0xffCCCACA),
            activeColor: ColorConstants.GRADIENT_ORANGE,
            activeSize: const Size(30.0, 8.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ],
    );
  }

  _dot(bool index) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: index ? ColorConstants().primaryColor() : ColorConstants.WHITE,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }

  _buildContent(int index) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /*Text(
              PreBoardingData.getDat()[index]['text1'],
              style: Styles.textRegular(size: 28)
                  .copyWith(fontWeight: FontWeight.bold),
            ),*/
            //SizedBox(height: 18),
            Flexible(
              child: Text(
                PreBoardingData.getDat()[index]['text2'],
                style: Styles.textRegular(size: 16,),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildContentTitle(int index) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GradientText(
              PreBoardingData.getDat()[index]['text1'],
              style: Styles.textRegular(size: 20).copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              colors: [
                ColorConstants.GRADIENT_ORANGE,
                ColorConstants.GRADIENT_RED,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PreBoardingData {
  static Map<int, dynamic> getDat() {
    return {
      0: {
        'image': Images.PRE_BOARDING_1,
        'text1': 'Innovative Ecosystem for Upskilling & Employability',
        'text2': '''Explore opportunities, Prove skills and Get hired'''
      },
      1: {
        'image': Images.PRE_BOARDING_2,
        'text1': 'Get access to 100+ opportunities in Future Skill Domains.',
        'text2':
            "Get Access to personalized opportunities, Participate in Live projects, Build portfolio, prepare for interviews and get hired."
      },
      2: {
        'image': Images.PRE_BOARDING_3,
        'text1': 'Assess yourself and Identify your skill gap',
        'text2':
            "Take Assessments on multiple skills, Up-skill through personalised recommendations, and Callibrate your skill-score for better opportunities."
      },
    };
  }
}

//"different tech\n\nSjill-ful projects\n\nJob Oriented-"