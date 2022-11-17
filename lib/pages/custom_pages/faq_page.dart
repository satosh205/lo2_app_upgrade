import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/resource/colors.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({Key? key}) : super(key: key);

  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);

  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  @override
  build(context) => Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          title: const Text('FAQs'),
          backgroundColor: ColorConstants().primaryColor(),
        ),
        body: Accordion(
          maxOpenSections: 1,
          headerBackgroundColorOpened: ColorConstants().primaryColor(),
          scaleWhenAnimating: true,
          openAndCloseAnimation: true,
          headerPadding:
              const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
          sectionClosingHapticFeedback: SectionHapticFeedback.light,
          children: [
            AccordionSection(
              isOpen: true,
              leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
              headerBackgroundColor: ColorConstants.Color_GREEN,
              headerBackgroundColorOpened: ColorConstants().primaryColor(),
              header:
                  Text('How to sign-up on the LnB app?', style: _headerStyle),
              content: Text(
                  'Click on the Login button and go to the Signup option and fill out the details, click the button below to enter on to your Dashboard. To complete the process of signing-up follow the password reset email and try to resign with your new password.',
                  style: _contentStyle),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: true,
              leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
              headerBackgroundColor: ColorConstants.Color_GREEN,
              headerBackgroundColorOpened: ColorConstants().primaryColor(),
              header: Text('How to login into the mobile app?',
                  style: _headerStyle),
              content: Text(
                  'You can enter the registered email and password to login into the app. You can also use your Registered mobile number and OTP to enter the app.',
                  style: _contentStyle),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: true,
              leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
              headerBackgroundColor: ColorConstants.Color_GREEN,
              headerBackgroundColorOpened: ColorConstants().primaryColor(),
              header: Text('How to enroll in a course?', style: _headerStyle),
              content: Text(
                  'Login into your app and scroll down to find the course of your choice. Click on the course icon and then click ${Strings.of(context)?.enrollNow} to add the course in your cart. Enter any coupon code you have and click on Proceed To Checkout. In the next step, enter any missing details in your billing address and click on place order to successfully enroll in any course.',
                  style: _contentStyle),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: true,
              leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
              headerBackgroundColor: ColorConstants.Color_GREEN,
              headerBackgroundColorOpened: ColorConstants().primaryColor(),
              header: Text('How can I access the courses  I am enrolled in?',
                  style: _headerStyle),
              content: Text(
                  'Login into your LnB app and click on the “Learning Dashboard” button on the Bottom of your screen. Now you’ll see all the courses you have enrolled in on the top in Gray color cards. Swipe left or right to see all other courses you have enrolled in.',
                  style: _contentStyle),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: true,
              leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
              headerBackgroundColor: ColorConstants.Color_GREEN,
              headerBackgroundColorOpened: ColorConstants().primaryColor(),
              header: Text(
                  'How can I attend the assessment of my course curriculum ?',
                  style: _headerStyle),
              content: Text(
                  'Go to your course and click on the “Modules” button on the top of the page. Now open any modules that contain the assessment you want to attempt and scroll down to find the Assessment. Click on the “Attempt” button and read the instructions carefully Scroll down on the instruction page to find the “Start Test” button. Attempt the questions in your test and click the “Submit” button to submit your test. You can also jump between questions by clicking the question numbers shown on top of the page.',
                  style: _contentStyle),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
            AccordionSection(
              isOpen: true,
              leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
              headerBackgroundColor: ColorConstants.Color_GREEN,
              headerBackgroundColorOpened: ColorConstants().primaryColor(),
              header:
                  Text('Have any more queries/doubts ?', style: _headerStyle),
              content: Text(
                  'Raise a ticket at learnandbuild.in/support or send us your queries at support@learnandbuild.in and We’ll reach out to you within 24 hours.',
                  style: _contentStyle),
              contentHorizontalPadding: 20,
              contentBorderWidth: 1,
            ),
          ],
        ),
      );
}
