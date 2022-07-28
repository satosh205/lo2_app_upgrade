import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../data/api/api_service.dart';
import '../../../data/models/response/home_response/my_assessment_response.dart';
import '../../../data/models/response/home_response/test_review_response.dart';
import '../../../utils/Styles.dart';
import '../../../utils/resource/colors.dart';
import '../../custom_pages/alert_widgets/alerts_widget.dart';
import '../../custom_pages/custom_widgets/NextPageRouting.dart';
import '../../ghome/home_page.dart';
import 'assessment_your_report_page.dart';

class AssessmentYourAnswersPage extends StatefulWidget {
  final int? contentId;
  final bool isReview;
  final bool isOptionSelected;
  final Function? sendValue;

  const AssessmentYourAnswersPage({
    Key? key,
    this.contentId,
    required this.isReview,
    required this.isOptionSelected,
    required this.sendValue,
  }) : super(key: key);

  @override
  State<AssessmentYourAnswersPage> createState() =>
      _AssessmentYourAnswersPageState();
}

class _AssessmentYourAnswersPageState extends State<AssessmentYourAnswersPage> {
  List<AssessmentList>? assessmentList = [];
  var _isLoading = true;
  late HomeBloc _authBloc;
  List<TestReviewBean> _list = [];
  int? _currentQuestionId;
  bool _showSubmitDialog = false;
  String selectedOption = '';
  List selectedOptionList = [];

  @override
  void initState() {
    super.initState();
  }

  void _handleAttemptTestResponse(ReviewTestState state) {
    try {
      switch (state.apiState) {
        case ApiStatus.LOADING:
          this.setState(() {
            _isLoading = true;
          });
          break;
        case ApiStatus.SUCCESS:
          if (state.response!.data != null) {
            _list.clear();
            selectedOptionList.clear();
            for (int i = 0;
                i < state.response!.data!.assessmentReview!.questions!.length;
                i++) {
              _list.add(
                TestReviewBean(
                    question:
                        state.response!.data!.assessmentReview!.questions![i],
                    id: state.response!.data!.assessmentReview!.questions![i]
                        .questionId,
                    title: state.response!.data!.assessmentReview!.questions![i]
                        .question),
              );
              //TODO: Get Selected Option
              /*int count = state.response!.data!.assessmentReview!.questions![i]
                  .questionOptions!.length;
              for (int j = 0; j < count; j++) {
                if (state.response!.data!.assessmentReview!.questions![i]
                    .questionOptions![j].userAnswer == 1) {

                  int value = j;
                  if (value == 0) {
                    selectedOption = 'a';
                  } else if (value == 1) {
                    selectedOption = 'b';
                  } else if (value == 2) {
                    selectedOption = 'c';
                  } else if (value == 3) {
                    selectedOption = 'd';
                  }
                  selectedOptionList.add(selectedOption);
                }else{
                  selectedOptionList.add("");
                }
              }*/

            }

            if (_list.length > 0) {
              _currentQuestionId = _list.first.question!.questionId;
            }
          }
          this.setState(() {
            _isLoading = false;
          });
          break;
        case ApiStatus.ERROR:
          this.setState(() {
            _isLoading = false;
          });
          break;
        case ApiStatus.INITIAL:
          break;
      }
    } catch (e) {}
  }

  void _submitAnswers() {
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => AssessmentYourReportPage(
    //               contentId: widget.contentId,
    //             ))).then((value) => Navigator.pop(context));
    _authBloc.add(SubmitAnswerEvent(request: widget.contentId.toString()));
  }

  void _handleSubmitAnswerResponse(SubmitAnswerState state) {
    try {
      setState(() {
        switch (state.apiState) {
          case ApiStatus.LOADING:
            _isLoading = true;
            break;
          case ApiStatus.SUCCESS:
            _isLoading = false;
            widget.sendValue!(true);

            AlertsWidget.alertWithOkBtn(
              context: context,
              onOkClick: () {
                /*Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => homePage()));*/
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AssessmentYourReportPage(
                              contentId: widget.contentId,
                            ))).then((value) => Navigator.pop(context));
              },
              text:
                  "Your answers are saved successfully. Results will be declared soon.",
            );
            break;
          case ApiStatus.ERROR:
            widget.sendValue!(false);
            Navigator.pop(context);
            _isLoading = false;
            break;
          case ApiStatus.INITIAL:
            break;
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.WHITE,
      appBar: AppBar(
        title: Text("Your Answers", style: Styles.bold(size: 18)),
        centerTitle: false,
        backgroundColor: ColorConstants.WHITE,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 30.0, top: 10.0, right: 30.0, bottom: 10.0),
          child: Container(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        height: 23,
                        width: 23,
                        decoration: BoxDecoration(
                          color: ColorConstants.PRIMARY_COLOR,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                      Text(' Answers'),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 23,
                        width: 23,
                        decoration: BoxDecoration(
                          color: ColorConstants.GREY_3,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                      Text(' Skipped'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    //AssessmentYourReportPage
                    /*Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) => AssessmentYourReportPage(
                               contentId: widget.contentId,)));*/

                    if (widget.isReview) {
                      Navigator.pushAndRemoveUntil(
                          context, NextPageRoute(homePage()), (route) => false);
                    } else {
                      if (!widget.isOptionSelected) {
                        AlertsWidget.alertWithOkCancelBtn(
                          context: context,
                          onOkClick: () {
                            /*widget._stopWatchTimer.onExecute
                                 .add(StopWatchExecute.reset);
                             widget._allTimer!.cancel();*/
                            print('ANSWER 1');
                            _submitAnswers();
                          },
                          text:
                              "You still have time left. Do you want to submit your test now?",
                          title: "Finish Assessment",
                        );
                      } else {
                        AlertsWidget.alertWithOkBtn(
                          context: context,
                          onOkClick: () {
                            _showSubmitDialog = true;
                            _submitAnswers();
                          },
                          text: "Save the answer of your Ques",
                        );
                      }
                    }
                  },
                  child: Container(
                    height: 50,
                    color: ColorConstants.PRIMARY_COLOR,
                    child: Center(
                        child: Text(
                      'Submit Test',
                      style: Styles.textRegular(size: 16),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _mainBody(),
    );
  }

  _mainBody() {
    _authBloc = BlocProvider.of<HomeBloc>(context);
    return BlocManager(
        initState: (context) {
          if (_list.length == 0)
            _authBloc.add(
              ReviewTestEvent(
                request: widget.contentId.toString(),
              ),
            );
        },
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is ReviewTestState) _handleAttemptTestResponse(state);
            if (state is SubmitAnswerState) _handleSubmitAnswerResponse(state);
          },
          child: _list.isNotEmpty
              ? Container(
                  child: GridView.builder(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5),
                    itemCount: _list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Card(
                          color: _list[index].question!.isCorrect == 0
                              ? ColorConstants.GREY_3
                              : ColorConstants.PRIMARY_COLOR,
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: Styles.textRegular(
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : _emptyBody(),
        ));
  }

  _emptyBody() {
    return Container(
      child: GridView.builder(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: ColorConstants.GREY_4,
              child: Card(
                color: ColorConstants.GREY_3,
              ),
            ),
          );
        },
      ),
    );
  }
}
