import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:masterg/data/providers/mg_assessment_detail_provioder.dart';
import 'package:masterg/pages/custom_pages/TapWidget.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/training_pages/assessment_attempt_page.dart';
import 'package:masterg/pages/training_pages/assessment_review_page.dart';
import 'package:masterg/pages/training_pages/new_screen/assessment_attempt_page.dart';
import 'package:masterg/pages/training_pages/new_screen/assessment_review_page.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/custom_progress_indicator.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:provider/provider.dart';

class MgAssessmentDetailPage extends StatelessWidget {
  BuildContext? mContext;
  late MgAssessmentDetailProvider assessmentDetailProvider;

  @override
  Widget build(BuildContext context) {
    mContext = context;
    assessmentDetailProvider = Provider.of<MgAssessmentDetailProvider>(context);
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.WHITE,
      body: assessmentDetailProvider.assessmentResponse != null
          ? _buildBody()
          : CustomProgressIndicator(true, ColorConstants.WHITE),
    ));
  }

  _buildBody() {
    return Container(
      height: MediaQuery.of(mContext!).size.height,
      width: MediaQuery.of(mContext!).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  TapWidget(
                    onTap: () {
                      Navigator.pop(mContext!);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ColorConstants.WHITE,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: ColorConstants.BLACK,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    assessmentDetailProvider.assessments.title!,
                    textAlign: TextAlign.center,
                    style: Styles.bold(size: 20),
                  ))
                ],
              ),
            ),
            _belowTitle(assessmentDetailProvider),
            _body(),
          ],
        ),
      ),
    );
  }

  _belowTitle(MgAssessmentDetailProvider assessmentProvider) {
    int attempLeft = assessmentDetailProvider
            .assessmentResponse!.data!.instruction!.details!.attemptAllowed! -
        assessmentDetailProvider
            .assessmentResponse!.data!.instruction!.details!.attemptCount!;
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _size(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Submit before: '
                  '${Utility.convertDateFromMillis(assessmentProvider.assessments.endDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
                  style:
                      Styles.semibold(size: 14, color: ColorConstants.BLACK)),
              Text(
                '${assessmentProvider.assessmentResponse!.data!.instruction!.details!.durationInMinutes} mins',
                style: Styles.semibold(size: 14, color: ColorConstants.BLACK),
              ),
            ],
          ),
          _size(height: 15),
          Text(
            assessmentDetailProvider.assessments.title!,
            style:
                Styles.bold(size: 16, color: ColorConstants().primaryColor()),
          ),
          _size(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /*Text(
                      'Maximum Marks',
                      style: Styles.textSemiBold(
                          size: 16, color: ColorConstants.WHITE),
                    ),*/
              Text(
                '${assessmentProvider.assessments.maximumMarks} Marks • ',
                style: Styles.semibold(size: 14, color: ColorConstants.BLACK),
              ),
              Text(
                '$attempLeft attempts available ',
                style: Styles.semibold(size: 14, color: ColorConstants.BLACK),
              )
            ],
          ),
        ],
      ),
    );
  }

  _size({double height = 20}) {
    return SizedBox(
      height: height,
    );
  }

  _body() {
    String attempLeft = assessmentDetailProvider
        .assessmentResponse!.data!.instruction!.details!.attemptCount
        .toString();

    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: ColorConstants.WHITE,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instructions',
                  style: Styles.textExtraBold(
                      size: 18, color: ColorConstants().primaryColor()),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 60),
                  child: Wrap(
                    children: List.generate(
                        assessmentDetailProvider.assessmentResponse!.data!
                            .instruction!.statement!.length,
                        (index) => Html(
                              data: assessmentDetailProvider.assessmentResponse!
                                  .data!.instruction!.statement![index],
                              style: {
                                "p": Style(
                                  fontFamily: 'Nunito_Regular',
                                )
                              },
                            )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            _size(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (assessmentDetailProvider.assessmentResponse!.data!
                        .instruction!.details!.attemptCount! >
                    0)
                  Expanded(
                    child: TapWidget(
                      onTap: () {
                        Navigator.push(
                            mContext!,
                            NextPageRoute(AssessmentReviewPage(
                                contentId: assessmentDetailProvider
                                    .assessments.contentId)));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColorConstants().primaryColor(),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Review',
                                style: Styles.textExtraBold(
                                    size: 14, color: ColorConstants.WHITE),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(width: 15.0),
                Expanded(
                  child: TapWidget(
                    onTap: () async {
                      if (assessmentDetailProvider.assessmentResponse!.data!
                              .instruction!.details!.attemptCount! >=
                          assessmentDetailProvider.assessmentResponse!.data!
                              .instruction!.details!.attemptAllowed!) {
                        Utility.showSnackBar(
                            scaffoldContext: mContext,
                            message: "Maximum attempts reached.");
                      } else {
                        AlertsWidget.showCustomDialog(
                            context: mContext!,
                            title: "Confirm?",
                            text: "Do you want to attempt assessment?",
                            icon: 'assets/images/circle_alert_fill.svg',
                            onCancelClick: () {},
                            onOkClick: () async {
                              await Navigator.push(
                                  mContext!,
                                  NextPageRoute(AssessmentAttemptPage(
                                      contentId: assessmentDetailProvider
                                          .assessments.contentId)));
                              assessmentDetailProvider.getDetails();
                            });
                      }
                    },
                    child: Visibility(
                      visible: assessmentDetailProvider.assessmentResponse!
                              .data!.instruction!.details!.attemptCount! <=
                          assessmentDetailProvider.assessmentResponse!.data!
                              .instruction!.details!.attemptAllowed!,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: (assessmentDetailProvider
                                      .assessmentResponse!
                                      .data!
                                      .instruction!
                                      .details!
                                      .attemptCount! >=
                                  assessmentDetailProvider
                                      .assessmentResponse!
                                      .data!
                                      .instruction!
                                      .details!
                                      .attemptAllowed!)
                              ? ColorConstants.GREY_3
                              : Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                assessmentDetailProvider
                                            .assessmentResponse!
                                            .data!
                                            .instruction!
                                            .details!
                                            .attemptCount! >
                                        0
                                    ? 'Re-Attempt'
                                    : 'Start Test',
                                style: Styles.textExtraBold(
                                    size: 14, color: ColorConstants.BLACK),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _size(height: 10),

            //  assessmentDetailProvider.assessments.attemptCount
            // Text(
            //   '$attempLeft/${assessmentDetailProvider.assessments.attemptAllowed} attempts left ',
            //   style: Styles.regular(size: 12, color: ColorConstants.RED_BG),
            // ),
            _size(height: 20),

            if (assessmentDetailProvider.assessmentResponse!.data!.instruction!
                    .details!.submittedOnDate! !=
                0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last attempt',
                        style: Styles.textRegular(
                            size: 16, color: ColorConstants.BLACK),
                      ),
                      Text(
                        '${Utility.convertDateFromMillis(assessmentDetailProvider.assessmentResponse!.data!.instruction!.details!.submittedOnDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
                        style: Styles.textRegular(
                            size: 12, color: ColorConstants.GREY_4),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          // Text('${assessmentProvider.assessments.negativeMarks}/', style: Styles.textRegular(
                          //     size: 16, color: ColorConstants.GREEN),),
                          // Text('${assessmentProvider.assessments.maximumMarks}', style: Styles.textRegular(
                          //     size: 16, color: ColorConstants.BLACK),),
                        ],
                      ),
                      Text(
                          'Score: ${assessmentDetailProvider.assessmentResponse!.data!.instruction!.details!.score}'),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class AssessmentAnswerTypes extends StatelessWidget {
  Color color;
  String text;

  AssessmentAnswerTypes(this.color, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: color,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: Styles.textRegular(
              size: 13, color: ColorConstants.DARK_BLUE.withOpacity(0.7)),
        )
      ],
    );
  }
}
