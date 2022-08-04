import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/training_pages/new_screen/assessment_review_page.dart';
import 'package:shimmer/shimmer.dart';

import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../data/api/api_service.dart';
import '../../../data/models/response/home_response/my_assessment_response.dart';
import '../../../data/models/response/home_response/test_review_response.dart';
import '../../../utils/Styles.dart';
import '../../../utils/resource/colors.dart';
import '../../../utils/widget_size.dart';

class AssessmentYourReportPage extends StatefulWidget {
  final int? contentId;
  const AssessmentYourReportPage({Key? key, this.contentId}) : super(key: key);

  @override
  State<AssessmentYourReportPage> createState() =>
      _AssessmentYourReportPageState();
}

class _AssessmentYourReportPageState extends State<AssessmentYourReportPage> {
  List<AssessmentList>? assessmentList = [];
  var _isLoading = true;
  late HomeBloc _authBloc;
  List<TestReviewBean> _list = [];
  int? _currentQuestionId;
  bool _showSubmitDialog = false;
  int skippedCount = 0;
  int correctCount = 0;
  int questionCount = 0;
  int scoreCount = 0;
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

              questionCount =
                  state.response!.data!.assessmentReview!.questionCount!;

              if (_list[i].question!.isCorrect == 0) {
                skippedCount++;
              }
              if (_list[i].question!.isCorrect == 1) {
                correctCount++;
              }
              scoreCount = state.response!.data!.assessmentReview!.score!;

              //TODO: Get Selected Option
              int count = state.response!.data!.assessmentReview!.questions![i]
                  .questionOptions!.length;
              for (int j = 0; j < count; j++) {
                if (state.response!.data!.assessmentReview!.questions![i]
                        .questionOptions![j].userAnswer ==
                    1) {
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
                  break;
                }
              }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.WHITE,
      appBar: AppBar(
        title: Text("Your Report", style: Styles.bold(size: 18)),
        centerTitle: true,
        backgroundColor: ColorConstants.WHITE,
        elevation: 0.0,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.black,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: _mainBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 50,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text('Back'),
                ),
                backgroundColor: ColorConstants().primaryColor(),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 50,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      NextPageRoute(
                          AssessmentReviewPage(contentId: widget.contentId)));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text('Go to Review'),
                ),
                backgroundColor: ColorConstants().primaryColor(),
              ),
            )
          ]),
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
          },
          child: _list.isNotEmpty
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                decoration: BoxDecoration(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Score',
                                      style: Styles.textRegular(
                                          size: 16, color: Colors.black),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text('${scoreCount.toString()}',
                                          style: Styles.DMSansbold(
                                              size: 20, color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: WidgetSize.REPORT_LINE_HEIGHT,
                              width: 1,
                              color: Colors.grey[200],
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                decoration: BoxDecoration(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Rank',
                                      style: Styles.textRegular(
                                          size: 16, color: Colors.black),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text('0',
                                          style: Styles.DMSansbold(
                                              size: 20, color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: WidgetSize.REPORT_LINE_HEIGHT,
                              width: 1,
                              color: Colors.grey[200],
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                decoration: BoxDecoration(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Correct',
                                      style: Styles.textRegular(
                                          size: 16, color: Colors.black),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                          '${correctCount.toString()}/${questionCount.toString()}',
                                          style: Styles.DMSansbold(
                                              size: 20, color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: WidgetSize.REPORT_LINE_HEIGHT,
                              width: 1,
                              color: Colors.grey[200],
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                decoration: BoxDecoration(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Skipped',
                                      style: Styles.textRegular(
                                          size: 16, color: Colors.black),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text('${skippedCount.toString()}',
                                          style: Styles.DMSansbold(
                                              size: 20, color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                        child: Text('Your Answers',
                            style: Styles.textRegular(
                                size: 16, color: Colors.black)),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 350,
                        child: GridView.builder(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5),
                          itemCount: _list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _list[index].question!.isCorrect != 0
                                ? Container(
                                    child: Card(
                                      color:
                                          _list[index].question!.isCorrect == 1
                                              ? ColorConstants.GREEN
                                              : ColorConstants.RED_BG,
                                      child: Center(
                                        //child: Text('${index + 1}' , style: Styles.textRegular(size: 16, color: Colors.white),),
                                        child: Text(
                                          '${index + 1}: ${selectedOptionList[index]}',
                                          style: Styles.textRegular(
                                              size: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox();
                          },
                        ),
                      ),
                    ],
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
