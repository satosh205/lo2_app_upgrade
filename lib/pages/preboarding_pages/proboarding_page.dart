import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/main.dart';
import 'package:masterg/pages/auth_pages/choose_language.dart';
import 'package:masterg/pages/custom_pages/TapWidget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/images.dart';

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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            _pageView(),
            _loginRegisterWidget(_currentIndex),
          ],
        ),
      ),
    );
  }

  Widget _loginRegisterWidget(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Container(
        color: Colors.white,
        // alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _dots(index),
            TapWidget(
              onTap: () {
                Navigator.push(
                    context,
                    NextPageRoute(ChooseLanguage(
                      showEdulystLogo: true,
                    )));
              },
              child: Image.asset(
                "assets/images/next.png",
                height: 50,
                width: 50,
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
            height: 110,
          ),
          Container(
            height: 300,
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
          Expanded(
            flex: 3,
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
            size: const Size.square(10.0),
            color: Color(0xffCCCACA),
            activeColor: Color(0xff939393),
            activeSize: const Size(10.0, 10.0),
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
            Text(
              PreBoardingData.getDat()[index]['text1'],
              style: Styles.textRegular(size: 28)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 18),
            Text(
              PreBoardingData.getDat()[index]['text2'],
              style: Styles.textRegular(size: 16),
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