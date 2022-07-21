// ignore_for_file: unused_field, unused_local_variable

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/test_review_response.dart';
import 'package:masterg/main.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/TapWidget.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';

class AssessmentReviewPage extends StatefulWidget {
  final int? contentId;

  AssessmentReviewPage({this.contentId});

  @override
  _AssessmentReviewPageState createState() => _AssessmentReviewPageState();
  var _pageViewController = PageController();
  int? _currentSection = 0;
  var _currentQuestion = 0;
  int? _currentQuestionId;
  //List<Sections> sections = List();
  List<TestReviewBean> _list = [];
  // Map<int, dynamic> _sections = Map();
  int _currentQuestionNumber = 1;
  ScrollController? _questionController;
}

class IdMapper {
  int? questionId;
  String? color;
  int? timeTaken;

  IdMapper({this.questionId, this.color, this.timeTaken});

  IdMapper.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    color = json['color'];
    timeTaken = json['timeTaken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    data['color'] = this.color;
    data['timeTaken'] = this.timeTaken;
    return data;
  }
}

class _AssessmentReviewPageState extends State<AssessmentReviewPage> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  var _isLoading = false;
  var _scaffoldContext;
  late HomeBloc _authBloc;
  bool _showSolution = false;

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
            widget._list.clear();
            for (int i = 0;
                i < state.response!.data!.assessmentReview!.questions!.length;
                i++) {
              widget._list.add(
                TestReviewBean(
                    question:
                        state.response!.data!.assessmentReview!.questions![i],
                    id: state.response!.data!.assessmentReview!.questions![i]
                        .questionId,
                    title: state.response!.data!.assessmentReview!.questions![i]
                        .question),
              );
            }

            if (widget._list.length > 0) {
              widget._currentQuestionId =
                  widget._list.first.question!.questionId;
            }
            // for (TestReviewBean data in widget._list) {
            //   if (widget._sections.containsKey(data.id)) {
            //     List<IdMapper> _sectionQuestionList = List();
            //     widget._sections[data.id].forEach((v) {
            //       _sectionQuestionList.add(IdMapper.fromJson(v));
            //     });
            //     _sectionQuestionList.add(
            //       IdMapper(
            //         questionId: data.question.questionId,
            //         color: "#ffffff",
            //         timeTaken: 0,
            //       ),
            //     );
            //     widget._sections[data.id] =
            //         _sectionQuestionList.map((v) => v.toJson()).toList();
            //   } else {
            //     widget._sections[data.id] = [
            //       IdMapper(
            //         questionId: data.question.questionId,
            //         color: "#ffffff",
            //         timeTaken: 0,
            //       )
            //     ].map((v) => v.toJson()).toList();
            //   }
            // }
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
  void initState() {
    super.initState();
    _downloadListener();
    widget._questionController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    Application(context);
    _authBloc = BlocProvider.of<HomeBloc>(context);
    return BlocManager(
      initState: (context) {
        if (widget._list.length == 0)
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
        child: Builder(builder: (_context) {
          _scaffoldContext = _context;
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  'Review',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              backgroundColor: ColorConstants.WHITE,
              key: _key,
              bottomNavigationBar: widget._list.length == 0
                  ? SizedBox()
                  : BottomAppBar(
                      //color: Color.fromRGBO(238, 238, 243, 1),
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget._currentQuestion == 0
                                ? SizedBox(
                                    width: 100,
                                  )
                                : TapWidget(
                                    onTap: () {
                                      widget._pageViewController.previousPage(
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.ease);
                                    },
                                    child: Container(
                                      width: 100,
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      decoration: BoxDecoration(
                                          //color: Color.fromRGBO(157, 191, 242, 1),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/prev.svg',
                                            width: 15,
                                            height: 15,
                                            allowDrawingOutsideViewBox: true,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Prev",
                                            style: Styles.textBold(
                                                size: 16, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            Container(
                              width: 100,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  //color: ColorConstants.PRIMARY_COLOR,
                                  //borderRadius: BorderRadius.circular(8)
                                  ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${(widget._currentQuestion + 1).toString() + "/" + widget._list.length.toString()}",
                                    style: Styles.textBold(
                                        size: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            TapWidget(
                              onTap: () {
                                print('object');
                                widget._pageViewController.nextPage(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.ease);
                              },
                              child: Container(
                                width: 100,
                                //padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    //color: ColorConstants.PRIMARY_COLOR,
                                    //borderRadius: BorderRadius.circular(8)
                                    ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ((widget._list.length - 1) ==
                                              widget._currentQuestion)
                                          ? ""
                                          : "Next",
                                      style: Styles.textBold(
                                          size: 16, color: Colors.black),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SvgPicture.asset(
                                      'assets/images/next.svg',
                                      width: 15,
                                      height: 15,
                                      allowDrawingOutsideViewBox: true,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
              body: SafeArea(
                child: ScreenWithLoader(
                  body: widget._list.length == 0
                      ? Column(
                          children: [
                            //_heading(),
                            Center(
                              child: Text(_isLoading
                                  ? "Please wait.."
                                  : "No data found"),
                            ),
                          ],
                        )
                      : _content(),
                  isLoading: _isLoading,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _content() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //_heading(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                //color: Color.fromRGBO(238, 238, 243, 1),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
              ),
              child: Column(
                children: [
                  //_questionCount(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 19),
                    child: Divider(),
                  ),
                  _pageView(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _pageView() {
    return Expanded(
      child: Container(
        child: PageView.builder(
          itemBuilder: (context, index) {
            return _pageItem(widget._list[index]);
          },
          onPageChanged: (pageNumber) {
            setState(() {
              widget._currentSection = widget._list[pageNumber].id;
              widget._currentQuestionId =
                  widget._list[pageNumber].question!.questionId;
              widget._currentQuestion = pageNumber;
              _showSolution = false;
              int questionsLength = widget._list.length;
              Utility.waitForMili(200).then((value) {
                if (widget._currentQuestion + 2 >= questionsLength * .6) {
                  if (widget._questionController!.position.pixels !=
                      widget._questionController!.position.maxScrollExtent) {
                    widget._questionController!.jumpTo(
                        ((widget._currentQuestion + 2) * 30).toDouble());
                  }
                } else if ((widget._currentQuestion + 2) <=
                    questionsLength * .3) {
                  if (widget._questionController!.position.pixels != 0) {
                    widget._questionController!.jumpTo(0);
                  }
                }
              });
            });
          },
          controller: widget._pageViewController,
          itemCount: widget._list.length,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  _questionCount() {
    return widget._list.length == 0
        ? SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19),
            child: Container(
              height: 60,
              width: MediaQuery.of(_scaffoldContext).size.width,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: widget._questionController,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    Questions? question = widget._list[index].question;
                    return TapWidget(
                      onTap: () {
                        if (widget._currentQuestionId ==
                            widget._list[index].question!.questionId) {
                          return;
                        }
                        print("HEREE");
                        for (int i = 0; i < widget._list.length; i++) {
                          if (widget._list[i].question!.questionId ==
                              widget._list[index].question!.questionId) {
                            print(widget._list[widget._currentQuestion]
                                .question!.questionId
                                .toString());

                            widget._currentQuestionId =
                                widget._list[index].question!.questionId;
                            widget._currentQuestion = i;
                            widget._pageViewController.animateToPage(i,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.ease);
                            break;
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 32),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.05),
                                  offset: Offset(0, 8),
                                  blurRadius: 16)
                            ],
                            color: Colors.grey[300],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${index + 1}",
                            style: index == widget._currentQuestion
                                ? Styles.textBold()
                                : Styles.textLight(),
                          ),
                        ),
                      ),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: widget._list.length,
                ),
              ),
            ),
          );
  }

  _pageItem(TestReviewBean testAttemptBean) {
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //_questionNumber(testAttemptBean),
            //_size(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                testAttemptBean.question!.question ?? "",
                style: Styles.textRegular(size: 16),
              ),
            ),
            _size(height: 10),
            if (testAttemptBean.question!.questionImage != null)
              for (int i = 0;
                  i < testAttemptBean.question!.questionImage!.length;
                  i++)
                if (testAttemptBean.question!.questionImage![i]
                        .toString()
                        .contains('.mp4') ||
                    testAttemptBean.question!.questionImage![i]
                        .toString()
                        .contains('.mp3'))
                  Container(
                    height: 200,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Center(
                      child: InAppWebView(
                          initialOptions: InAppWebViewGroupOptions(
                              crossPlatform: InAppWebViewOptions(
                                mediaPlaybackRequiresUserGesture: true,
                                useShouldOverrideUrlLoading: true,
                              ),
                              ios: IOSInAppWebViewOptions(
                                  allowsInlineMediaPlayback: true,
                                  allowsLinkPreview: false)),
                          initialUrlRequest: URLRequest(
                              url: Uri.parse(testAttemptBean
                                  .question!.questionImage![i]))),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      testAttemptBean.question!.questionImage![i],
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),

            _size(height: 10),
            // if (testAttemptBean.question.image != null &&
            //     testAttemptBean.question.image.isNotEmpty)
            //   _handleFile(
            //       file: ApiConstants.IMAGE_BASE_URL +

            _solutionType(testAttemptBean.question!.questionTypeId.toString(),
                testAttemptBean),
            _size(height: 10),
            // Visibility(
            //   visible: testAttemptBean.question.explanation != null &&
            //       testAttemptBean.question.explanation.isNotEmpty,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //     child: !_showSolution
            //         ? TapWidget(
            //             onTap: () {
            //               setState(() {
            //                 _showSolution = true;
            //               });
            //             },
            //             child: Container(
            //               padding: const EdgeInsets.all(15),
            //               color: ColorConstants.PRIMARY_COLOR,
            //               child: Text(
            //                 "See Solution",
            //                 style: Styles.boldWhite(),
            //               ),
            //             ),
            //           )
            //         : RichText(
            //             maxLines: 1000,
            //             overflow: TextOverflow.ellipsis,
            //             textAlign: TextAlign.left,
            //             text: TextSpan(children: <TextSpan>[
            //               TextSpan(
            //                 text: 'Solution: ',
            //                 style: Styles.boldBlack(),
            //               ),
            //               TextSpan(
            //                 text:
            //                     "${testAttemptBean.question.explanation ?? ""}",
            //                 style: Styles.regularBlack(),
            //               ),
            //             ]),
            //           ),
            //   ),
            // ),
            // _size(height: 20),
          ],
        ),
      ),
    );
  }

  // _timetakenAvg(TestReviewBean testAttemptBean) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     height: 80,
  //     child: SingleChildScrollView(
  //       padding: const EdgeInsets.symmetric(horizontal: 20),
  //       scrollDirection: Axis.horizontal,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 width: 80,
  //                 alignment: Alignment.centerRight,
  //                 child: Text(
  //                   "${getTime(time: testAttemptBean.question.analytics.batchAvgTime)}s",
  //                   style: Styles.boldBlack(size: 18),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               Row(
  //                 children: [
  //                   Container(
  //                     height: 20,
  //                     width:
  //                         // ignore: null_aware_before_operator
  //                         testAttemptBean.question.analytics.batchAvgTime == 0.0
  //                             ? 2
  //                             : testAttemptBean.question.analytics.batchAvgTime,
  //                     decoration: BoxDecoration(
  //                         color: Color(0xffcbedf7),
  //                         borderRadius: BorderRadius.all(Radius.circular(5))),
  //                   ),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   Container(
  //                     width: 80,
  //                     child: Text(
  //                       "avg time taken to answer correctly",
  //                       maxLines: 2,
  //                       style: Styles.boldGrey(size: 8),
  //                     ),
  //                   )
  //                 ],
  //               )
  //             ],
  //           ),
  //           _size(),
  //           Row(
  //             children: [
  //               Container(
  //                 width: 80,
  //                 alignment: Alignment.centerRight,
  //                 child: Text(
  //                   "${getTime(time: testAttemptBean?.question?.analytics?.timeTaken ?? 0.0)}s",
  //                   style: Styles.boldBlack(size: 18),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               Row(
  //                 children: [
  //                   Container(
  //                     height: 20,
  //                     width: (testAttemptBean?.question?.analytics?.timeTaken ==
  //                             0.0)
  //                         ? 2.0
  //                         : testAttemptBean?.question?.analytics?.timeTaken ??
  //                             0.0,
  //                     decoration: BoxDecoration(
  //                         color: Color(0xff91dbf1),
  //                         borderRadius: BorderRadius.all(Radius.circular(5))),
  //                   ),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   Container(
  //                     width: 60,
  //                     child: Text(
  //                       "time taken by you",
  //                       maxLines: 2,
  //                       style: Styles.boldGrey(size: 8),
  //                     ),
  //                   )
  //                 ],
  //               )
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // String _difficultyImage({String image}) {
  //   if (image.toUpperCase() == "EASY") {
  //     return Images.EASY;
  //   } else if (image.toUpperCase() == "MEDIUM") {
  //     return Images.MEDIUM;
  //   } else if (image.toUpperCase() == "HARD") {
  //     return Images.HARD;
  //   } else {
  //     return Images.VERY_HARD;
  //   }
  // }

  // _difficulty(TestReviewBean testAttemptBean) {
  //   return Row(
  //     mainAxisSize: MainAxisSize.max,
  //     children: [
  //       Expanded(
  //         flex: 1,
  //         child: Column(
  //           children: [
  //             Image.asset(
  //               _difficultyImage(
  //                 image: testAttemptBean.question.analytics.difficultyLevel,
  //               ),
  //               width: 100,
  //               height: 80,
  //             ),
  //             _size(),
  //             RichText(
  //               maxLines: 1000,
  //               overflow: TextOverflow.ellipsis,
  //               textAlign: TextAlign.left,
  //               text: TextSpan(children: <TextSpan>[
  //                 TextSpan(
  //                   text: 'Difficulty: ',
  //                   style: Styles.boldGrey(),
  //                 ),
  //                 TextSpan(
  //                   text:
  //                       "${testAttemptBean.question.analytics.difficultyLevel ?? ""}",
  //                   style: Styles.boldBlack(),
  //                 ),
  //               ]),
  //             )
  //           ],
  //         ),
  //       ),
  //       Expanded(
  //         flex: 1,
  //         child: Visibility(
  //           visible: testAttemptBean.question.questionTypeId != "6",
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Card(
  //                 elevation: 0,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(5),
  //                   ),
  //                   side: BorderSide(color: Colors.grey[300]),
  //                 ),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(5.0),
  //                   child: Icon(
  //                     Icons.check,
  //                     color: Colors.green,
  //                     size: 30,
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "${testAttemptBean.question.analytics.batchCorrectPercentage}%",
  //                     style: Styles.boldBlack(size: 16),
  //                   ),
  //                   Text(
  //                     "Answered correctly",
  //                     style: Styles.boldGrey(size: 12),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  // _correctIncorrect(TestReviewBean testAttemptBean) {
  //   return Align(
  //     alignment: Alignment.centerLeft,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Visibility(
  //             visible: testAttemptBean.question.questionTypeId != "6",
  //             child: testAttemptBean.question.analytics.selectedOption.isEmpty
  //                 ? Container()
  //                 : Container(
  //                     padding: const EdgeInsets.all(5),
  //                     height: 35,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(5),
  //                         bottomLeft: Radius.circular(5),
  //                         bottomRight: testAttemptBean.question.marks == 0.0
  //                             ? Radius.circular(5)
  //                             : Radius.circular(0),
  //                         topRight: testAttemptBean.question.marks == 0.0
  //                             ? Radius.circular(5)
  //                             : Radius.circular(0),
  //                       ),
  //                       color: testAttemptBean.question.analytics.isCorrect
  //                           ? Color(0xffccfcce).withOpacity(0.5)
  //                           : Color(0xffffbebe).withOpacity(0.8),
  //                     ),
  //                     child: Row(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Icon(
  //                           testAttemptBean.question.analytics.isCorrect
  //                               ? Icons.check
  //                               : Icons.close,
  //                           size: 15,
  //                           color: testAttemptBean.question.analytics.isCorrect
  //                               ? Color(0xff368d3a)
  //                               : Color(0xffff6464),
  //                         ),
  //                         Text(
  //                           testAttemptBean.question.analytics.isCorrect
  //                               ? "Correct"
  //                               : "Incorrect",
  //                           style: testAttemptBean.question.analytics.isCorrect
  //                               ? Styles.correctGreen()
  //                               : Styles.incorrectRed(),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //           ),
  //           Visibility(
  //             visible: testAttemptBean.question.marks != 0.0,
  //             child: testAttemptBean.question.questionTypeId == "6"
  //                 ? Container(
  //                     height: 35,
  //                     padding: const EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.only(
  //                         bottomRight: Radius.circular(5),
  //                         topRight: Radius.circular(5),
  //                         topLeft: Radius.circular(
  //                             testAttemptBean.question.questionTypeId == "6"
  //                                 ? 5
  //                                 : 0),
  //                         bottomLeft: Radius.circular(
  //                             testAttemptBean.question.questionTypeId == "6"
  //                                 ? 5
  //                                 : 0),
  //                       ),
  //                       color: testAttemptBean.question.questionTypeId == "6"
  //                           ? Color(0xffccfcce)
  //                           : testAttemptBean.question.analytics.isCorrect
  //                               ? Color(0xffccfcce)
  //                               : Color(0xffffbebe),
  //                     ),
  //                     child: Center(
  //                       child: Text(
  //                         "${testAttemptBean.question.analytics.score}/${testAttemptBean.question.marks}",
  //                         style: testAttemptBean.question.questionTypeId == "6"
  //                             ? Styles.correctGreen()
  //                             : testAttemptBean.question.analytics.isCorrect
  //                                 ? Styles.correctGreen()
  //                                 : Styles.incorrectRed(),
  //                       ),
  //                     ),
  //                   )
  //                 : testAttemptBean.question.analytics.selectedOption.isEmpty
  //                     ? Container()
  //                     : Container(
  //                         height: 35,
  //                         padding: const EdgeInsets.all(10),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.only(
  //                             bottomRight: Radius.circular(5),
  //                             topRight: Radius.circular(5),
  //                             topLeft: Radius.circular(
  //                                 testAttemptBean.question.questionTypeId == "6"
  //                                     ? 5
  //                                     : 0),
  //                             bottomLeft: Radius.circular(
  //                                 testAttemptBean.question.questionTypeId == "6"
  //                                     ? 5
  //                                     : 0),
  //                           ),
  //                           color: testAttemptBean.question.questionTypeId ==
  //                                   "6"
  //                               ? Color(0xffccfcce)
  //                               : testAttemptBean.question.analytics.isCorrect
  //                                   ? Color(0xffccfcce)
  //                                   : Color(0xffffbebe),
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             "${testAttemptBean.question.analytics.score}/${testAttemptBean.question.marks}",
  //                             style: testAttemptBean.question.questionTypeId ==
  //                                     "6"
  //                                 ? Styles.correctGreen()
  //                                 : testAttemptBean.question.analytics.isCorrect
  //                                     ? Styles.correctGreen()
  //                                     : Styles.incorrectRed(),
  //                           ),
  //                         ),
  //                       ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  _size({double height = 10}) {
    return SizedBox(
      height: height,
    );
  }

  _questionNumber(TestReviewBean testAttemptBean) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            "Q.${(widget._currentQuestion + 1).toString().padLeft(2, "0")}",
            style: Styles.textBold(size: 18),
          ),
          Spacer(),
          // Text(
          //   "${getTime(time: testAttemptBean?.question?.analytics?.timeTaken ?? 0)}s",
          //   style: Styles.textBold(),
          // )
        ],
      ),
    );
  }

  String getTime({required double time}) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits((time / 60).truncate())}:${twoDigits((time % 60).truncate())}";
  }

  _solutionType(String type, TestReviewBean testAttemptBean) {
    print('============Type=============');
    print(type);
    switch (type) {
      case "1":
        return _multiChoose(testAttemptBean); //MULTIPLE_CHOICE

      case "2":
      //return _options(testAttemptBean); //SINGLE_INTEGER

      case "3":
        return _multiChoose(testAttemptBean); //MULTIPLE_RESPONSE

      case "4":
      //return _chooseOne(testAttemptBean); //FILL_IN_THE_BLANK

      case "5":
      //return _chooseOne(testAttemptBean); //TRUE_FALSE

      case "6":
      //  return _subjective(testAttemptBean); //SUBJECTIVE

      case "7":
        return Container(); //MATCHING

    }
  }

  Future download2(String url, String savePath) async {
    try {
      _key.currentState!.showSnackBar(
        SnackBar(
          content: Text(
            "Downloading start.",
            style: Styles.boldWhite(),
          ),
          backgroundColor: ColorConstants.BLACK,
          duration: Duration(seconds: 2),
        ),
      );
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: savePath,
        showNotification: true,
        openFileFromNotification: true,
      );
      print(taskId);
    } catch (e) {
      print(e);
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  ReceivePort _port = ReceivePort();

  _downloadListener() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String? id = data[0];
      DownloadTaskStatus? status = data[1];
      int? progress = data[2];
      if (status.toString() == "DownloadTaskStatus(3)" &&
          progress == 100 &&
          id != null) {
        String query = "SELECT * FROM task WHERE task_id='" + id + "'";
        var tasks = FlutterDownloader.loadTasksWithRawQuery(query: query);
        //if the task exists, open it
        if (tasks != null) FlutterDownloader.open(taskId: id);
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  // _subjective(TestReviewBean testAttemptBean) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 20),
  //         child: Text(
  //           testAttemptBean.question.questionType ?? "",
  //           style: Styles.textBold(size: 20),
  //         ),
  //       ),
  //       _size(),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //         child: Text(
  //           testAttemptBean?.question?.solution?.explanation ?? "",
  //           maxLines: 10,
  //           style: Styles.regularBlack(),
  //         ),
  //       ),
  //       _size(),
  //       Container(
  //         width: MediaQuery.of(context).size.width - 40,
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.all(Radius.circular(15)),
  //             border: Border.all(color: Colors.grey)),
  //         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
  //         margin: const EdgeInsets.only(left: 20.0),
  //         child: Text(
  //           testAttemptBean?.question?.studentSolution ?? "",
  //           style: Styles.regularBlack(),
  //           maxLines: 10,
  //         ),
  //       ),
  //       _size(),
  //       if (testAttemptBean.question.analytics.usersFile != null &&
  //           testAttemptBean.question.analytics.usersFile.isNotEmpty)
  //         _handleFile(
  //             file: ApiConstants.IMAGE_BASE_URL +
  //                 testAttemptBean.question.analytics.usersFile),
  //       _size(),
  //     ],
  //   );
  // }

  _options(TestReviewBean testAttemptBean) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              testAttemptBean.question!.questionType ?? "",
              style: Styles.textBold(size: 20),
            ),
          ),
          Column(
            children: List.generate(
              widget._list[widget._currentQuestion].question!.questionOptions!
                  .length,
              (index) {
                Color borderColor;
                if (widget._list[widget._currentQuestion].question!
                        .questionOptions![index].optionId ==
                    int.parse(widget._list[widget._currentQuestion].question!
                        .correctOptions!.first)) {
                  borderColor = Color(0xff66bb6a);
                } else if (widget._list[widget._currentQuestion].question!
                            .questionOptions![index].optionId !=
                        int.parse(widget._list[widget._currentQuestion]
                            .question!.correctOptions!.first) &&
                    widget._list[widget._currentQuestion].question!
                            .questionOptions![index].userAnswer ==
                        1) {
                  borderColor = Colors.red;
                } else {
                  borderColor = Colors.grey;
                }
                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(_scaffoldContext).size.width,
                      height: 60,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Card(
                              elevation: 5,
                              margin: const EdgeInsets.only(right: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                side: BorderSide(
                                    color: borderColor,

                                    // widget
                                    //             ._list[widget._currentQuestion]
                                    //             .question
                                    //             .questionOptions[index]
                                    //             .userAnswer ==
                                    //         1
                                    //     ? Color(0xff66bb6a)
                                    //     : widget
                                    //                     ._list[widget
                                    //                         ._currentQuestion]
                                    //                     .question
                                    //                     .questionOptions[index]
                                    //                     .userAnswer ==
                                    //                 0 &&
                                    //             widget
                                    //                     ._list[widget
                                    //                         ._currentQuestion]
                                    //                     .question
                                    //                     .questionOptions[index]
                                    //                     .optionId !=
                                    //                 widget
                                    //                     ._list[widget
                                    //                         ._currentQuestion]
                                    //                     .question
                                    //                     .correctOptions
                                    //         ? Colors.red
                                    //         : Colors.grey,
                                    width: 1.5),
                              ),
                              child: Container(
                                width:
                                    MediaQuery.of(_scaffoldContext).size.width -
                                        40,
                                height: 55,
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  widget
                                      ._list[widget._currentQuestion]
                                      .question!
                                      .questionOptions![index]
                                      .optionStatement!,
                                  style: Styles.textRegular(size: 12),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 15,
                            left: 30,
                            child:
                                //  widget._list[widget._currentQuestion].question
                                //             .analytics.actionId !=
                                //         1
                                //     ? Container()
                                //     : widget._list[widget._currentQuestion].question
                                //             .options[index].isSelected
                                //         ? Container(
                                //             color: Colors.grey[300],
                                //             child: Padding(
                                //               padding: const EdgeInsets.symmetric(
                                //                   vertical: 3.0, horizontal: 8),
                                //               child: Text(
                                //                 "Your answer",
                                //                 style: Styles.boldBlack(size: 10),
                                //               ),
                                //             ),
                                //           )
                                //         :
                                widget
                                            ._list[widget._currentQuestion]
                                            .question!
                                            .questionOptions![index]
                                            .userAnswer ==
                                        1
                                    ? Container(
                                        color: Colors.grey[300],
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 8),
                                          child: Text(
                                            "Correct Answer",
                                            style: Styles.textBold(size: 10),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                          )
                        ],
                      ),
                    ),
                    _size(),
                    // if (widget._list[widget._currentQuestion].question
                    //             .options[index].image !=
                    //         null &&
                    //     widget._list[widget._currentQuestion].question
                    //         .options[index].image.isNotEmpty)
                    //   _image(
                    //       image: ApiConstants.IMAGE_BASE_URL +
                    //           widget._list[widget._currentQuestion].question
                    //               .options[index].image)
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _multiChoose(TestReviewBean testAttemptBean) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              'Question Type',
              style: Styles.textRegular(size: 12, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Text(
              testAttemptBean.question!.questionType ?? "",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          _size(height: 20),
          Column(
            children: List.generate(
              widget._list[widget._currentQuestion].question!.questionOptions!
                  .length,
              (index) {
                Color bgColor;
                Color txtColor;
                Color borderColor;
                if (widget._list[widget._currentQuestion].question!
                        .questionOptions![index].optionId ==
                    int.parse(widget._list[widget._currentQuestion].question!
                        .correctOptions!.first)) {
                  borderColor = Colors.green;
                  bgColor = Colors.green;
                  txtColor = Colors.white;
                } else if (widget._list[widget._currentQuestion].question!
                            .questionOptions![index].optionId !=
                        int.parse(widget._list[widget._currentQuestion]
                            .question!.correctOptions!.first) &&
                    widget._list[widget._currentQuestion].question!
                            .questionOptions![index].userAnswer ==
                        1) {
                  borderColor = Colors.red;
                  bgColor = Colors.white;
                  txtColor = Colors.red;
                } else {
                  borderColor = Colors.grey;
                  bgColor = Colors.white;
                  txtColor = Colors.black;
                }
                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(_scaffoldContext).size.width,
                      height: 52,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Card(
                              color: bgColor,
                              elevation: 5,
                              margin: const EdgeInsets.only(right: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                side: BorderSide(
                                    color: borderColor,
                                    // widget
                                    //             ._list[widget._currentQuestion]
                                    //             .question
                                    //             .questionOptions[index]
                                    //             .optionId ==
                                    //         int.parse(widget
                                    //             ._list[widget._currentQuestion]
                                    //             .question
                                    //             .correctOptions
                                    //             .first)
                                    // ? Color(0xff66bb6a)
                                    // : widget
                                    //         ._list[widget._currentQuestion]
                                    //         .question
                                    //         .options[index]
                                    //         .isSelected
                                    //     ? Color(0xffff8080)
                                    //     : widget
                                    //             ._list[
                                    //                 widget._currentQuestion]
                                    //             .question
                                    //             .options[index]
                                    //             .isCorrect
                                    //         ? Color(0xff66bb6a)
                                    // : widget
                                    //                 ._list[widget
                                    //                     ._currentQuestion]
                                    //                 .question
                                    //                 .questionOptions[index]
                                    //                 .userAnswer ==
                                    //             0 &&
                                    //         widget
                                    //                 ._list[widget
                                    //                     ._currentQuestion]
                                    //                 .question
                                    //                 .questionOptions[index]
                                    //                 .optionId !=
                                    //             widget
                                    //                 ._list[widget
                                    //                     ._currentQuestion]
                                    //                 .question
                                    //                 .correctOptions
                                    //     ? Colors.red
                                    //     : Colors.grey,
                                    width: 1.5),
                              ),
                              child: Container(
                                width:
                                    MediaQuery.of(_scaffoldContext).size.width -
                                        40,
                                height: 45,
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  widget
                                      ._list[widget._currentQuestion]
                                      .question!
                                      .questionOptions![index]
                                      .optionStatement!,
                                  style: Styles.textRegular(
                                      size: 12, color: txtColor),
                                ),
                              ),
                            ),
                          ),
                          /*Positioned(
                            top: 15,
                            left: 30,
                            child:
                            // widget._list[widget._currentQuestion].question
                            //             .analytics.actionId !=
                            //         1
                            //     ? Container()
                            //     :
                            // widget._list[widget._currentQuestion].question
                            //         .questionOptions[index].userAnswer==1
                            //     ? Container(
                            //         color: Colors.grey[300],
                            //         child: Padding(
                            //           padding: const EdgeInsets.symmetric(
                            //               vertical: 3.0, horizontal: 8),
                            //           child: Text(
                            //             "Your answer",
                            //             style: Styles.boldBlack(size: 10),
                            //           ),
                            //         ),
                            //       )
                            //     :
                            widget._list[widget._currentQuestion].question!
                                .questionOptions![index].optionId ==
                                int.parse(widget
                                    ._list[widget._currentQuestion]
                                    .question!
                                    .correctOptions!
                                    .first)
                                ? Container(
                              color: Colors.grey[300],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 8),
                                child: Text(
                                  "Correct Answer",
                                  style: Styles.textBold(size: 10),
                                ),
                              ),
                            )
                                : SizedBox(),
                          ),*/

                          Positioned(
                            top: 17,
                            right: 10,
                            child:
                                // widget._list[widget._currentQuestion].question
                                //             .analytics.actionId !=
                                //         1
                                //     ? Container()
                                //     :
                                // widget._list[widget._currentQuestion].question
                                //         .questionOptions[index].userAnswer==1
                                //     ? Container(
                                //         color: Colors.grey[300],
                                //         child: Padding(
                                //           padding: const EdgeInsets.symmetric(
                                //               vertical: 3.0, horizontal: 8),
                                //           child: Text(
                                //             "Your answer",
                                //             style: Styles.boldBlack(size: 10),
                                //           ),
                                //         ),
                                //       )
                                //     :
                                widget
                                            ._list[widget._currentQuestion]
                                            .question!
                                            .questionOptions![index]
                                            .userAnswer ==
                                        1
                                    ? Container(
                                        //color: Colors.grey[300],
                                        child: widget
                                                        ._list[widget
                                                            ._currentQuestion]
                                                        .question!
                                                        .questionOptions![index]
                                                        .optionId !=
                                                    int.parse(widget
                                                        ._list[widget
                                                            ._currentQuestion]
                                                        .question!
                                                        .correctOptions!
                                                        .first) &&
                                                widget
                                                        ._list[widget
                                                            ._currentQuestion]
                                                        .question!
                                                        .questionOptions![index]
                                                        .userAnswer ==
                                                    1
                                            ? Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.done_rounded,
                                                color: Colors.white,
                                              ),
                                        /*child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 8),
                                child: Text(
                                  "Your Answer",
                                  style: Styles.textBold(size: 10),
                                ),
                              ),*/
                                      )
                                    : SizedBox(),
                          )
                        ],
                      ),
                    ),
                    _size(),
                    // if (widget._list[widget._currentQuestion].question
                    //             .options[index].image !=
                    //         null &&
                    //     widget._list[widget._currentQuestion].question
                    //         .options[index].image.isNotEmpty)
                    //   _image(
                    //       image: ApiConstants.IMAGE_BASE_URL +
                    //           widget._list[widget._currentQuestion].question
                    //               .options[index].image)
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _chooseOne(TestReviewBean testAttemptBean) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              testAttemptBean.question!.questionType ?? "",
              style: Styles.textBold(size: 20),
            ),
          ),
          Column(
            children: List.generate(
              widget._list[widget._currentQuestion].question!.questionOptions!
                  .length,
              (index) {
                Color borderColor;
                if (widget._list[widget._currentQuestion].question!
                        .questionOptions![index].optionId ==
                    int.parse(widget._list[widget._currentQuestion].question!
                        .correctOptions!.first)) {
                  borderColor = Color(0xff66bb6a);
                } else if (widget._list[widget._currentQuestion].question!
                            .questionOptions![index].optionId !=
                        int.parse(widget._list[widget._currentQuestion]
                            .question!.correctOptions!.first) &&
                    widget._list[widget._currentQuestion].question!
                            .questionOptions![index].userAnswer ==
                        1) {
                  borderColor = Colors.red;
                } else {
                  borderColor = Colors.grey;
                }
                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(_scaffoldContext).size.width,
                      height: 80,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Card(
                              elevation: 5,
                              margin: const EdgeInsets.only(right: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                side: BorderSide(
                                    color: borderColor,

                                    //  widget
                                    //             ._list[widget._currentQuestion]
                                    //             .question
                                    //             .questionOptions[index]
                                    //             .userAnswer ==
                                    //         1
                                    //         &&
                                    //     widget
                                    //         ._list[widget._currentQuestion]
                                    //         .question
                                    //         .options[index]
                                    //         .isSelected
                                    // ? Color(0xff66bb6a)
                                    // : widget
                                    //                 ._list[widget
                                    //                     ._currentQuestion]
                                    //                 .question
                                    //                 .questionOptions[index]
                                    //                 .userAnswer ==
                                    //             0 &&
                                    //         widget
                                    //                 ._list[widget
                                    //                     ._currentQuestion]
                                    //                 .question
                                    //                 .questionOptions[index]
                                    //                 .optionId !=
                                    //             widget
                                    //                 ._list[widget
                                    //                     ._currentQuestion]
                                    //                 .question
                                    //                 .correctOptions
                                    //     ? Colors.red
                                    // : widget
                                    //         ._list[widget._currentQuestion]
                                    //         .question
                                    //         .options[index]
                                    //         .isSelected
                                    //     ? Color(0xffff8080)
                                    //     : widget
                                    //             ._list[
                                    //                 widget._currentQuestion]
                                    //             .question
                                    //             .options[index]
                                    //             .isCorrect
                                    //         ? Color(0xff66bb6a)
                                    // : widget._list[widget._currentQuestion].question.questionOptions[index].userAnswer == 0 &&
                                    //         widget
                                    //                 ._list[widget
                                    //                     ._currentQuestion]
                                    //                 .question
                                    //                 .questionOptions[
                                    //                     index]
                                    //                 .optionId !=
                                    //             widget
                                    //                 ._list[widget._currentQuestion]
                                    //                 .question
                                    //                 .correctOptions
                                    //     ? Colors.red
                                    //     : Colors.grey,
                                    width: 1.5),
                              ),
                              child: Container(
                                width:
                                    MediaQuery.of(_scaffoldContext).size.width -
                                        40,
                                height: 55,
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  widget
                                      ._list[widget._currentQuestion]
                                      .question!
                                      .questionOptions![index]
                                      .optionStatement!,
                                  style: Styles.textRegular(size: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _size(),
                    // if (widget._list[widget._currentQuestion].question
                    //             .options[index].image !=
                    //         null &&
                    //     widget._list[widget._currentQuestion].question
                    //         .options[index].image.isNotEmpty)
                    //   _image(
                    //       image: ApiConstants.IMAGE_BASE_URL +
                    //           widget._list[widget._currentQuestion].question
                    //               .options[index].image)
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
