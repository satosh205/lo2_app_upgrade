import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:masterg/data/providers/assessment_detail_provider.dart';
import 'package:masterg/pages/custom_pages/TapWidget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    assessmentDetailProvider = Provider.of<AssessmentDetailProvider>(context);
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
                children: [],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Submit before: '
                  '${Utility.convertDateFromMillis(assignmentDetailProvider.assignments.endDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
                  style:
                      Styles.semibold(size: 14, color: ColorConstants.BLACK)),
              Text(
                '${assignmentDetailProvider.assessmentResponse!.data!.instruction!.details!.durationInMinutes} mins',
                style: Styles.semibold(size: 14, color: ColorConstants.BLACK),
              ),
            ],
          ),
          _size(height: 15),
          Text(
            assessmentDetailProvider.assignments.title!,
            style:
                Styles.bold(size: 16, color: ColorConstants().primaryColor()),
          ),
          _size(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${assignmentDetailProvider.assignments.maximumMarks} Marks • ',
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            _size(height: 30),
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
                        '${Utility.convertDateFromMillis(assessmentDetailProvider.assessmentResponse!.data!.instruction!.details!.submittedOnDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY_HH_MM__SS)}',
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
