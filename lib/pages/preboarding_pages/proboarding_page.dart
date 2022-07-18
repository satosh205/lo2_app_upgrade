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
            Text('${Preference.getString(Preference.USER_TOKEN)}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            TapWidget(
              onTap: () {
                Navigator.push(context, NextPageRoute(ChooseLanguage()));
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
          Expanded(
            flex: 6,
            child: Container(
              color: Color(0xffF7F7F7),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Image.asset(PreBoardingData.getDat()[index]['image'],
                      height: 300, width: 300),
                ),
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
              style: Styles.textRegular(size: 30)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
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
        'text1': 'Take the first\nleap',
        'text2': ''''The first step can be daunting but we're ready to guide'''
      },
      1: {
        'image': Images.PRE_BOARDING_2,
        'text1': 'Accomplish more\nwith us',
        'text2': "Let's travel on the path of success together."
      },
      2: {
        'image': Images.PRE_BOARDING_3,
        'text1': 'We Succeed when\nYou Succeed',
        'text2':
            "We update with the expanding tech market, come succeed with us."
      },
      // 3: {
      //   'image': Images.PRE_BOARDING_4,
      //   'bg': Images.PRE_BOARDING_BG_4,
      //   'text1': 'Career set karo',
      //   'text2': 'with ImaginXP Coach'
      // },
    };
  }
}
