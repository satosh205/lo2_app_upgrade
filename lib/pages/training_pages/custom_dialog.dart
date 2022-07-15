import 'package:flutter/material.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/training_module_response.dart';
import 'package:masterg/data/providers/assessment_detail_provider.dart';
import 'package:masterg/data/providers/assignment_detail_provider.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/CommonWebView.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/training_pages/assessment_page.dart';
import 'package:masterg/pages/training_pages/assignment_detail_page.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/images.dart';
import 'package:masterg/utils/utility.dart';
import 'package:provider/provider.dart';

class CustomDialogBox extends StatefulWidget {
  final String? type;
  final Content? data;
  final String? imagePath;

  const CustomDialogBox({Key? key, this.type, this.data, this.imagePath})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: ColorConstants.WHITE,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Icon(
              Icons.clear,
              color: ColorConstants.DARK_BLUE,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getContentType(),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: 100,
                      maxHeight: MediaQuery.of(context).size.height / 2),
                  decoration: BoxDecoration(
                      color: ColorConstants.WHITE,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  padding:
                      EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: widget.type == "Live Sessions"
                          ? widget.data!.sessions!.length
                          : widget.type == "videos"
                              ? widget.data!.assessments!.length
                              : widget.type == "Scorm"
                                  ? widget.data!.scorm!.length
                                  : widget.type == "Polls"
                                      ? widget.data!.polls!.length
                                      : widget.type == "Assignment"
                                          ? widget.data!.assignments!.length
                                          : widget.type == "Assessments"
                                              ? widget.data!.assessments!.length
                                              : widget.data!.survey!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        debugPrint('widget type --- ${widget.type}');
                        Map<String, dynamic> data = {};
                        switch (widget.type) {
                          case "Live Sessions":
                            return listViewLiveSessionItem(
                                widget.data!.sessions!.elementAt(index));

                          case "Videos":
                            data = widget.data!.assessments!
                                .elementAt(index)
                                .toJson();
                            break;
                          case "Assignment":
                            return listViewAssignmentItem(
                              widget.data!.assignments!.elementAt(index),
                            );

                          case "Scorm":
                            return listScormItem(
                                widget.data!.scorm!.elementAt(index));

                          case "Assessments":
                            return listViewAssessmentItem(
                                widget.data!.assessments!.elementAt(index),
                                context);

                          case "Survey":
                            return surveyViewItem(
                                widget.data!.survey!.elementAt(index));
                          case "Polls":
                            return surveyViewItem(
                                widget.data!.polls!.elementAt(index));
                        }
                        return listViewItem(data);
                      }),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget listViewLiveSessionItem(Sessions data) {
    debugPrint('data --- ${data}');
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        decoration: BoxDecoration(
            color: ColorConstants.BG_LIGHT_GREY,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: ListTile(
          leading: data.image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    data.image ?? 'https://picsum.photos/200/300',
                    height: 50.0,
                    width: 68.0,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(),
          title: Text('${data.title}'),
          subtitle: data.isLive!
              ? Text(
                  'On-going',
                  style: Styles.textRegular(size: 10),
                )
              : Text(
                  '${Strings.of(context)?.Completed} on : ${Utility.convertDateFromMillis(1000000, Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
                  style: Styles.textRegular(size: 10),
                ),
          trailing: data.isLive!
              ? Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: ColorConstants.Color_GREEN,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      'Click to join',
                      style: Styles.textSemiBold(
                          size: 12, color: ColorConstants.PRIMARY_COLOR),
                    ),
                  ),
                )
              : Container(
                  height: 36,
                  width: 36,
                  child: Image(
                    image: AssetImage(
                      Images.PLAY_ICON,
                    ),
                  )),
        ),
      ),
    );
  }

  Widget surveyViewItem(Polls data) {
    debugPrint('data --- ${data}');
    return InkWell(
      onTap: () {
        // Navigator.pop(context);
        // Navigator.push(
        //     context,
        //     NextPageRoute(
        //         ChangeNotifierProvider<SurveyPageProvider>(
        //             create: (context) => SurveyPageProvider(
        //                 trainingService: TrainingService(ApiService()),
        //                 polls: data),
        //             child: TrainingSurveyPage(
        //               type: data.contentType == "survey" ? 1 : 2,
        //             )),
        //         isMaintainState: true));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          decoration: BoxDecoration(
              color: ColorConstants.BG_LIGHT_GREY,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://picsum.photos/200/300',
                height: 50.0,
                width: 68.0,
                fit: BoxFit.cover,
              ),
            ),
            title: Text('${data.title}'),
            subtitle: Text(
              '${Strings.of(context)?.Start_date} : ${Utility.convertDateFromMillis(data.startDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
              style: Styles.textRegular(size: 10),
            ),
          ),
        ),
      ),
    );
  }

  Widget listViewItem(Map<String, dynamic> data) {
    debugPrint('data --- ${data}');
    return InkWell(
      onTap: () {
        if (widget.type == 'Scorm') {
          Navigator.push(
              context,
              NextPageRoute(CommonWebView(
                url:
                    'https://learningoxygen.com/playAnimatedPPT/${data['program_content_id']}',
              )));
        } else if (widget.type == "Survey") {
          Navigator.pop(context);
          // Navigator.push(
          //     context,
          //     NextPageRoute(
          //         ChangeNotifierProvider<SurveyPageProvider>(
          //             create: (context) => SurveyPageProvider(
          //                 trainingService: TrainingService(ApiService()),
          //                 polls: data as Polls),
          //             child: TrainingSurveyPage(
          //               type: 1,
          //             )),
          //         isMaintainState: true));
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          decoration: BoxDecoration(
              color: ColorConstants.BG_LIGHT_GREY,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListTile(
            leading: data['image'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/200/300',
                      height: 50.0,
                      width: 68.0,
                      fit: BoxFit.cover,
                    ),
                  )
                : SizedBox(),
            title: Text('${data['title']}'),
            subtitle: Text(
              '${Strings.of(context)?.Start_date} : ${Utility.convertDateFromMillis(1000000, Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
              style: Styles.textRegular(size: 10),
            ),
          ),
        ),
      ),
    );
  }

  Widget listScormItem(Scorm data) {
    debugPrint('data --- ${data}');
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
            context,
            NextPageRoute(CommonWebView(
              fullScreen: true,
              url: data.url,
            )));
        // FirebaseAnalytics()
        //     .logEvent(name: "training_content_opened", parameters: null);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          decoration: BoxDecoration(
              color: ColorConstants.BG_LIGHT_GREY,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListTile(
            title: Text(
              '${data.title}',
              style: Styles.textRegular(
                  size: 14, color: ColorConstants.PRIMARY_COLOR),
            ),
          ),
        ),
      ),
    );
  }

  Widget listViewAssignmentItem(
    Assignments data,
  ) {
    debugPrint('data --- ${data}');
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          NextPageRoute(
              ChangeNotifierProvider<AssignmentDetailProvider>(
                  create: (c) => AssignmentDetailProvider(
                      TrainingService(ApiService()), data),
                  child: AssignmentDetailPage(
                    id: data.programContentId,
                  )),
              isMaintainState: true),
        );
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (c) => AssignmentDetailPage(
        //               id: data.programContentId,
        //             )));
        //Navigator.push(context, NextPageRoute(WriteFeedbackPage(1)));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          decoration: BoxDecoration(
              color: ColorConstants.BG_LIGHT_GREY,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListTile(
              // leading: ClipRRect(
              //   borderRadius: BorderRadius.circular(8.0),
              //   child: Image.network(
              //     'https://picsum.photos/200/300',
              //     height: 50.0,
              //     width: 68.0,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              title: Text(
                '${data.title}',
                style: Styles.textRegular(
                    size: 14, color: ColorConstants.PRIMARY_COLOR),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Due date : ${Utility.convertDateFromMillis(data.endDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
                    style: Styles.textRegular(size: 10),
                  ),
                  // Text(
                  //   '${data} attempts remaining',
                  //   style: Styles.textRegular(size: 10),
                  // ),
                ],
              ),
              trailing: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${data.overallScore}/${data.maximumMarks}',
                      style: Styles.textRegular(
                          size: 14,
                          color: ColorConstants.BLACK.withOpacity(0.8)),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget listViewAssessmentItem(Assessments data, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
            context,
            NextPageRoute(
                ChangeNotifierProvider<AssessmentDetailProvider>(
                    create: (context) => AssessmentDetailProvider(
                        TrainingService(ApiService()), data),
                    child: AssessmentDetailPage()),
                isMaintainState: true));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          decoration: BoxDecoration(
              color: ColorConstants.BG_LIGHT_GREY,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListTile(
              // leading: ClipRRect(
              //   borderRadius: BorderRadius.circular(8.0),
              //   child: Image.network(
              //     'https://picsum.photos/200/300',
              //     height: 50.0,
              //     width: 68.0,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              title: Text(
                '${data.title}',
                style: Styles.textRegular(
                    size: 14, color: ColorConstants.PRIMARY_COLOR),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Due date : ${Utility.convertDateFromMillis(data.endDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
                    style: Styles.textRegular(size: 10),
                  ),
                  Text(
                    '${data.attemptsRemaining} attempts remaining',
                    style: Styles.textRegular(size: 10),
                  ),
                ],
              ),
              trailing: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${data.score}/${data.maximumMarks}',
                      style: Styles.textRegular(
                          size: 14,
                          color: ColorConstants.BLACK.withOpacity(0.8)),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget getContentType() {
    String? title;
    String? subContent;
    debugPrint('dialog type --- ${widget.type}');
    switch (widget.type) {
      case "Live Sessions":
        title = widget.type;
        subContent = '${widget.data!.sessions!.length} count';
        break;

      case "Assignment":
        title = widget.type;
        subContent = '${widget.data!.assignments!.length} count';
        break;
      case "Assessments":
        title = widget.type;
        subContent = '${widget.data!.assessments!.length} count';
        break;
      case "Scorm":
        title = widget.type;
        subContent = '${widget.data!.scorm!.length} count';
        break;
      case "Survey":
        title = widget.type;
        subContent = '${widget.data!.survey!.length} count';
        break;
      case "Polls":
        title = widget.type;
        subContent = '${widget.data!.polls!.length} count';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              widget.imagePath!,
              height: 50.0,
              width: 68.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? '',
                style: Styles.textExtraBold(size: 14),
              ),
              Text(
                subContent ?? '',
                style: Styles.textRegular(size: 10),
              )
            ],
          )
        ],
      ),
    );
  }
}
