import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:masterg/data/providers/assessment_detail_provider.dart';
import 'package:masterg/pages/custom_pages/TapWidget.dart';
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

class AssessmentDetailPage extends StatefulWidget {
  @override
  State<AssessmentDetailPage> createState() => _AssessmentDetailPageState();
}

class _AssessmentDetailPageState extends State<AssessmentDetailPage> {
  BuildContext? mContext;

  late AssessmentDetailProvider assessmentDetailProvider;
  @override
  void initState() {
    assessmentDetailProvider = Provider.of<AssessmentDetailProvider>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    // assessmentDetailProvider = Provider.of<AssessmentDetailProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Assessment',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.WHITE,
      body: assessmentDetailProvider.assessmentResponse != null
          ? _buildBody()
          : CustomProgressIndicator(true, ColorConstants.WHITE),
    );
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
                  /*TapWidget(
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
                        color: ColorConstants.DARK_BLUE,
                      ),
                    ),
                  ),*/
                  /*Expanded(
                      child: Text(
                    assessmentDetailProvider.assignments.title!,
                    textAlign: TextAlign.center,
                    style: Styles.boldWhite(size: 20),
                  )),*/
                ],
              ),
            ),
            _belowTitle(assessmentDetailProvider),
            _body(assessmentDetailProvider),
          ],
        ),
      ),
    );
  }

  _belowTitle(AssessmentDetailProvider assignmentDetailProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _size(height: 30),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.of(mContext!)!.Start_date!,
                style:
                    Styles.textSemiBold(size: 16, color: ColorConstants.WHITE),
              ),
              Text(
                '${Utility.convertDateFromMillis(assignmentDetailProvider.assignments.startDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
                style: Styles.textExtraBold(
                    size: 14, color: ColorConstants.WHITE.withOpacity(0.7)),
              )
            ],
          ),*/
          //_size(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /*Text(
                Strings.of(mContext!)!.End_date!,
                style:
                    Styles.textSemiBold(size: 16, color: ColorConstants.WHITE),
              ),*/
              Text(
                  'Submit before: '
                  '${Utility.convertDateFromMillis(assignmentDetailProvider.assignments.endDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
                  style: Styles.textExtraBold(
                      size: 14, color: ColorConstants.BLACK)),
              Text(
                '${assignmentDetailProvider.assessmentResponse!.data!.instruction!.details!.durationInMinutes} mins',
                style:
                    Styles.textSemiBold(size: 16, color: ColorConstants.BLACK),
              ),
            ],
          ),
          _size(height: 15),
          Text(
            assessmentDetailProvider.assignments.title!,
            style: Styles.textExtraBold(size: 18, color: ColorConstants.ORANGE),
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
                '${assignmentDetailProvider.assignments.maximumMarks} Marks . ',
                style:
                    Styles.textExtraBold(size: 16, color: ColorConstants.BLACK),
              ),
              Text(
                '${assignmentDetailProvider.assignments.attemptsRemaining} attempts available ',
                style:
                    Styles.textExtraBold(size: 16, color: ColorConstants.BLACK),
              )
            ],
          ),
          _size(height: 15),
          Text(
            assessmentDetailProvider.assignments.description!,
            style: Styles.textRegular(size: 14, color: ColorConstants.BLACK),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                // _size(height: 18),
                /* Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Duration',
                      style: Styles.textSemiBold(
                          size: 16, color: ColorConstants.WHITE),
                    ),
                    Text(
                      '${assignmentDetailProvider.assessmentResponse!.data!.instruction!.details!.durationInMinutes} min',
                      style: Styles.textExtraBold(
                          size: 14, color: ColorConstants.WHITE),
                    )
                  ],
                ),*/

                /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Passing Marks',
                      style: Styles.textSemiBold(
                          size: 16, color: ColorConstants.WHITE),
                    ),
                    Text(
                      '${assignmentDetailProvider.assessmentResponse!.data!.instruction!.details!.passingMarks}',
                      style: Styles.textExtraBold(
                          size: 14, color: ColorConstants.WHITE),
                    )
                  ],
                ),*/
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Difficulty',
                      style: Styles.textSemiBold(
                          size: 16, color: ColorConstants.WHITE),
                    ),
                    Text(
                      '${assignmentDetailProvider.assessmentResponse!.data!.instruction!.details!.difficultyLevel!.toUpperCase()}',
                      style: Styles.textExtraBold(
                          size: 14, color: ColorConstants.WHITE),
                    )
                  ],
                ),*/
                _size(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Attachment',
                //       style: Styles.textSemiBold(
                //           size: 18, color: ColorConstants.WHITE),
                //     ),
                //     Container(
                //       padding: EdgeInsets.all(5),
                //       decoration: BoxDecoration(
                //           color: ColorConstants.GREY,
                //           borderRadius: BorderRadius.all(Radius.circular(12))),
                //       child: Padding(
                //         padding: const EdgeInsets.only(left: 8, right: 8),
                //         child: Text(
                //           'Download',
                //           style: Styles.textExtraBold(
                //               size: 12, color: ColorConstants().primaryColor()),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _size({double height = 20}) {
    return SizedBox(
      height: height,
    );
  }

  _body(AssessmentDetailProvider assignmentDetailProvider) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
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
                      size: 18, color: ColorConstants.ORANGE),
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
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AssessmentAnswerTypes(
                              ColorConstants.ORANGE, 'Answered'),
                          const SizedBox(
                            height: 10,
                          ),
                          AssessmentAnswerTypes(
                              ColorConstants.RED_BG, 'Not Visited'),
                          const SizedBox(
                            height: 10,
                          ),
                          AssessmentAnswerTypes(ColorConstants.DARK_BLUE,
                              'Answered & marked for review'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AssessmentAnswerTypes(
                              ColorConstants.SELECTED_PAGE, 'Not Answered'),
                          const SizedBox(
                            height: 10,
                          ),
                          AssessmentAnswerTypes(
                              ColorConstants.GREEN, 'To be reviewed')
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            _size(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (assessmentDetailProvider.assessmentResponse!.data!
                        .instruction!.details!.attemptCount! >
                    0)
                  /*Column(
                    children: [
                      TapWidget(
                        onTap: () {
                          Navigator.push(
                              mContext!,
                              NextPageRoute(TestReviewPage(
                                  contentId: assessmentDetailProvider
                                      .assignments.programContentId)));
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: ColorConstants().primaryColor(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 4, bottom: 4),
                            child: Row(
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
                      _size(height: 20),
                    ],
                  ),*/ /*

                  Column(
                  children: [
                    TapWidget(
                      onTap: () async {
                        if (assessmentDetailProvider.assessmentResponse!.data!
                                .instruction!.details!.attemptCount! >=
                            assessmentDetailProvider.assessmentResponse!.data!
                                .instruction!.details!.attemptAllowed!) {
                          Utility.showSnackBar(
                              scaffoldContext: mContext,
                              message: "Maximum attempts reached.");
                        } else {
                          await Navigator.push(
                              mContext!,
                              NextPageRoute(TestAttemptPage(
                                  contentId: assessmentDetailProvider
                                      .assignments.programContentId)));
                          assessmentDetailProvider.getDetails();
                        }
                      },
                      child: Visibility(
                        visible: assessmentDetailProvider.assessmentResponse!
                                .data!.instruction!.details!.attemptCount! <=
                            assessmentDetailProvider.assessmentResponse!.data!
                                .instruction!.details!.attemptAllowed!,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: ColorConstants().primaryColor(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 4, bottom: 4),
                            child: Row(
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
                                      size: 14, color: ColorConstants.WHITE),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    _size(height: 20),
                  ],
                ),*/

                  Expanded(
                    /*child: Container(
                      margin: EdgeInsets.only(right: 10.0),
                      color: Colors.amber,
                      height: 100,
                    ),*/
                    child: TapWidget(
                      onTap: () {
                       Navigator.push(
                            mContext!,
                            NextPageRoute(AssessmentReviewPage(
                                contentId: assessmentDetailProvider
                                    .assignments.programContentId)));
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
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  /*child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    color: Colors.amber,
                    height: 100,
                  ),*/
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
                         await Navigator.push(
                            mContext!,
                            NextPageRoute(AssessmentAttemptPage(
                                contentId: assessmentDetailProvider
                                    .assignments.programContentId)));
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
                          //color: ColorConstants().primaryColor(),
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
            Text(
              '${assessmentDetailProvider.assessmentResponse!.data!.instruction!.details!.attemptAllowed! - assessmentDetailProvider.assessmentResponse!.data!.instruction!.details!.attemptCount!}/'
              '${assessmentDetailProvider.assessmentResponse!.data!.instruction!.details!.attemptAllowed!} attempts left ',
              style:
                  Styles.textExtraBold(size: 16, color: ColorConstants.RED_BG),
            ),
            _size(height: 20),
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
                      '15 Mar 22, 09:00 PM',
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
                        Text(
                          '${assignmentDetailProvider.assignments.negativeMarks}/',
                          style: Styles.textRegular(
                              size: 16, color: ColorConstants.GREEN),
                        ),
                        Text(
                          '${assignmentDetailProvider.assignments.maximumMarks}',
                          style: Styles.textRegular(
                              size: 16, color: ColorConstants.BLACK),
                        ),
                      ],
                    ),
                    Text('Scorecard'),
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
