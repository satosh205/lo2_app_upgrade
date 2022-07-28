import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/save_answer_request.dart';
import 'package:masterg/data/models/response/home_response/test_attempt_response.dart';
import 'package:masterg/main.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/TapWidget.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/ghome/home_page.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'assessment_your_answers_page.dart';

class AssessmentAttemptPage extends StatefulWidget {
  final int? contentId;
  final bool isReview;
  final bool isResumed;

  AssessmentAttemptPage(
      {this.contentId, this.isReview = false, this.isResumed = false});

  @override
  _AssessmentAttemptPageState createState() => _AssessmentAttemptPageState();

  Timer? _allTimer;
  File? _image;
  var _subjectiveController = TextEditingController();
  var _pageViewController = PageController();
  int _currentSection = 0;
  var _currentQuestion = 0;
  var _currentQuestionNumber = 1;
  int? _currentQuestionId;
  ScrollController? _questionController;
  bool? imageClick;
  List<TestAttemptBean> _list = [];
  //Map<int, dynamic> _sections = Map();
  //int _timeType = 0;
  int _attemptId = 0;
  int? _durationMins = 0;
  bool _isSubmit = false;
  bool _showSubmitDialog = false;
  StopWatchTimer _stopWatchTimer = StopWatchTimer();
  bool _pageChange = true;
  List<int> _firstQuestions = [];
  bool _isOptionSelected = false;
  bool _isResumedLoading = false;
  bool _isTestResumed = false;
  bool _lastSave = false;
  bool _isEverythingOver = false;
  //int _timeBoundType = 0;
  DateTime? _serverTime;
  DateTime? _endTime;
  bool _savedAnswer = false;
  bool _isContinued = false;
  bool _subjectiveTimeOver = false;
  bool _isSavedManually = false;
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

class _AssessmentAttemptPageState extends State<AssessmentAttemptPage>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  var _isLoading = false;
  var _scaffoldContext;
  late HomeBloc _authBloc;
  String? _title;

  bool willPop = false;
  //Function eq = const ListEquality().equals;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      print('INACTIVE');
      widget._stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    }
    if (state == AppLifecycleState.resumed) {
      widget._stopWatchTimer.onExecute.add(StopWatchExecute.start);
    }
  }

  void _handleAttemptTestResponse(AttemptTestState state) {
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
            widget._durationMins =
                state.response!.data!.assessmentDetails!.durationInMinutes;
            _title = state.response!.data!.assessmentDetails!.title;
            // widget._endTime = state.response.data.endDateTime.isNotEmpty ? DateTime.parse(
            //     state.response.data.endDateTime.split("+").first): null ;
            // print(widget._endTime);
            //widget._durationMins = 100;

            if (state.response!.data!.assessmentDetails!.questionCount ==
                null) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(milliseconds: 500),
                content: Text("No Data Found"),
              ));
            }
            if (widget._durationMins == null || widget._durationMins == '')
              widget._durationMins = 1800;
            else
              widget._durationMins = widget._durationMins! * 60;
            widget._stopWatchTimer.onExecute.add(StopWatchExecute.start);
            widget._allTimer = Timer.periodic(Duration(seconds: 1), (timer) {
              if (widget._allTimer!.tick == widget._durationMins) {
                widget._isEverythingOver = true;
              }
              setState(() {});
            });
            for (int i = 0;
                i < state.response!.data!.assessmentDetails!.questions!.length;
                i++) {
              widget._list.add(
                TestAttemptBean(
                    question:
                        state.response!.data!.assessmentDetails!.questions![i],
                    id: state.response!.data!.assessmentDetails!.questions![i]
                        .questionId,
                    isVisited: 0,
                    title: state.response!.data!.assessmentDetails!
                        .questions![i].question),
              );
            }
          }
          Utility.waitFor(2).then((value) {
            widget._isResumedLoading = false;
            widget._pageViewController.jumpToPage(widget._currentQuestion);
          });
          _isLoading = false;
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

  void _handleSaveAnswerResponse(SaveAnswerState state) {
    try {
      setState(() {
        switch (state.apiState) {
          case ApiStatus.LOADING:
            _isLoading = true;
            break;
          case ApiStatus.SUCCESS:
            widget._isOptionSelected = false;
            widget._savedAnswer = false;
            widget._isSavedManually = false;

            bool _pageChanged = false;
            if (widget._isContinued == false) {
              print('inside 1');
              print((widget._list.length - 1) == widget._currentQuestion &&
                  widget._lastSave);

              if (widget._isEverythingOver == false) {
                print('Page changeeeeee2');

                print('NEXT PAGE 2');
                _pageChanged = true;
                widget._pageViewController.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.ease,
                );
                // }
              } else {
                _submitAnswers();
              }

              _isLoading = false;
            } else {
              _isLoading = false;
              widget._isContinued = false;
              widget._pageChange = true;
            }
            break;
          case ApiStatus.ERROR:
            _isLoading = false;
            break;
          case ApiStatus.INITIAL:
            break;
        }
      });
    } catch (e) {}
  }

  void _handleSubmitAnswerResponse(SubmitAnswerState state) {
    try {
      setState(() {
        widget._stopWatchTimer.onExecute.add(StopWatchExecute.reset);
        widget._allTimer!.cancel();
        widget._isSubmit = true;
        switch (state.apiState) {
          case ApiStatus.LOADING:
            _isLoading = true;
            break;
          case ApiStatus.SUCCESS:
            _isLoading = false;

            AlertsWidget.alertWithOkBtn(
              context: _scaffoldContext,
              onOkClick: () {
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => homePage()));

                Navigator.pop(context);
              },
              text:
                  "Your answers are saved successfully. Results will be declared soon.",
            );
            break;
          case ApiStatus.ERROR:
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
  void dispose() {
    if (widget._isSubmit || widget._list.length == 0) {
      widget._stopWatchTimer.dispose();
      widget._allTimer?.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    widget._questionController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _downloadListener();
  }

  @override
  Widget build(BuildContext context) {
    Application(context);
    _authBloc = BlocProvider.of<HomeBloc>(context);
    return BlocManager(
      initState: (context) {
        if (widget._list.length == 0) {
          _authBloc.add(
            AttemptTestEvent(
              request: widget.contentId.toString(),
            ),
          );
        }
      },
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is AttemptTestState) _handleAttemptTestResponse(state);
          if (state is SaveAnswerState) _handleSaveAnswerResponse(state);
          if (state is SubmitAnswerState) _handleSubmitAnswerResponse(state);
          // if (state is UploadImageState) _handleUploadImageResponse(state);
        },
        child: Builder(builder: (_context) {
          _scaffoldContext = _context;
          return WillPopScope(
            onWillPop: () async {
              if (willPop) {
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
              backgroundColor: ColorConstants.WHITE,
              key: _key,
              bottomNavigationBar:
                  widget._list.length == 0 ? SizedBox() : _buildBottomAppBar(),
              body: SafeArea(
                child: ScreenWithLoader(
                  body: widget._list.length == 0
                      ? Column(
                          children: [
                            _heading(false),
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

  _saveClick() {
    if (widget._savedAnswer == false) {
      widget._savedAnswer = true;

      _authBloc.add(
        SaveAnswerEvent(
          request: SaveAnswerRequest(
            contentId: widget.contentId.toString(),
            durationSec: widget._stopWatchTimer.secondTime.value.toString(),
            questionId: widget
                ._list[widget._currentQuestion].question!.questionId
                .toString(),
            optionId:
                widget._list[widget._currentQuestion].question!.selectedOption,
          ),
        ),
      );
      if (widget._list[widget._currentQuestion].isBookmark) {
        if (widget
            ._list[widget._currentQuestion].question!.selectedOption.isEmpty) {
          widget._list[widget._currentQuestion].color = ColorConstants.REVIEWED;
        } else {
          widget._list[widget._currentQuestion].color =
              ColorConstants.ANSWERED_REVIEWS;
        }
      } else {
        if (widget
            ._list[widget._currentQuestion].question!.selectedOption.isEmpty) {
          widget._list[widget._currentQuestion].color =
              ColorConstants.NOT_ANSWERED;
        } else {
          widget._list[widget._currentQuestion].color = ColorConstants.ANSWERED;
        }
      }
      widget._list[widget._currentQuestion].question!.timeTaken =
          widget._stopWatchTimer.secondTime.value;
      _setTimer();

      if (((widget._list.length - 1) == widget._currentQuestion)) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AssessmentYourAnswersPage(
            contentId: widget.contentId,
            isReview: widget.isReview,
            isOptionSelected: widget._isOptionSelected,
            sendValue: (value) {
              setState(() {
                willPop = value;
              });
            },
          ),
        );

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => AssessmentYourAnswersPage(
        //               contentId: widget.contentId,
        //               isReview: widget.isReview,
        //               isOptionSelected: widget._isOptionSelected,
        //             ))).then((value) {
        //   widget._savedAnswer = false;
        //   widget._isOptionSelected = false;
        // });
      }
    } else {
      print("Saved question: " +
          widget._list[widget._currentQuestion].question!.questionId
              .toString() +
          "so");
      print("Selected options: " +
          widget._list[widget._currentQuestion].question!.selectedOption
              .toString());
    }
  }

  void _setTimer() {
    if ((widget._list.length - 1) != widget._currentQuestion) {
      if (widget._list[widget._currentQuestion + 1].question?.timeTaken !=
              null &&
          widget._list[widget._currentQuestion + 1].question!.timeTaken != 0) {
        widget._stopWatchTimer.setPresetSecondTime(
            widget._list[widget._currentQuestion + 1].question!.timeTaken!);
      } else {
        widget._stopWatchTimer.onExecute.add(StopWatchExecute.reset);
        widget._stopWatchTimer.onExecute.add(StopWatchExecute.start);
      }
      widget._pageChange = false;
    }
  }

  _heading(bool iscontent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          TapWidget(
            onTap: () {
              if (iscontent) {
                AlertsWidget.alertWithOkCancelBtn(
                  context: _scaffoldContext,
                  onOkClick: () {
                    widget._stopWatchTimer.onExecute
                        .add(StopWatchExecute.reset);
                    widget._allTimer!.cancel();
                    widget._isEverythingOver = true;
                    _saveClick();
                    // _submitAnswers();
                  },
                  text:
                      "Your assessment will be submitted automatically do you want to go back?",
                  title: "Finish Assessment",
                );
              } else {
                Navigator.pop(context);
              }
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Icon(
                Icons.arrow_back,
                color: ColorConstants.DARK_BLUE,
              ),
            ),
          ),
          Expanded(
              child: Text(
            _title ?? "",
            textAlign: TextAlign.center,
            style: Styles.regular(size: 20),
          ))
        ],
      ),
    );
  }

  Widget _content() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _size(),
          _heading(true),
          _timerSubmit(),
          _size(),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  //_size(height: 20),
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
            return widget._isResumedLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _pageItem(widget._list[index]);
          },
          onPageChanged: (pageNumber) {
            setState(() {
              widget._currentSection = 0;
              widget._currentQuestionId =
                  widget._list[pageNumber].question!.questionId;
              widget._currentQuestion = pageNumber;
              widget._list[pageNumber].isVisited = 1;
              final questionsLength = widget._list.length;
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

  _pageItem(TestAttemptBean testAttemptBean) {
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _size(),
            //_mainTimer(testAttemptBean),
            //_questionNumber(testAttemptBean),
            //_size(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                testAttemptBean.question!.question ?? "",
                style: Styles.textExtraBold(size: 16),
              ),
            ),
            _size(height: 15),

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
                    height: 300,
                    width: 300,
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
            _solutionType(testAttemptBean.question!.questionTypeId.toString(),
                testAttemptBean),
            _size(height: 10),
          ],
        ),
      ),
    );
  }

  _size({double height = 10}) {
    return SizedBox(
      height: height,
    );
  }

  String _getAllTime() {
    String _timeH = "";
    String _timeM = "";
    String _timeS = "";
    var localTime;

    localTime = widget._durationMins! - widget._allTimer!.tick;
    if ((localTime / 3600).truncate() < 10) {
      _timeH = "0${(localTime / 3600).truncate()}";
    } else {
      _timeH = (localTime / 3600).truncate().toString();
    }
    _timeM = (((localTime / 60).truncate()) % 60).toString().padLeft(2, '0');
    if ((localTime % 60).truncate() < 10) {
      _timeS = "0${(localTime % 60).truncate()}";
    } else {
      _timeS = (localTime % 60).truncate().toString();
    }

    if (widget._allTimer!.tick == widget._durationMins && !widget._isSubmit) {
      print("TIEM DONE");

      _submitAnswers();
    }

    return "$_timeH:$_timeM:$_timeS";
  }

  _timerSubmit() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      blurRadius: 32,
                      offset: Offset(0, 4))
                ]),
            child: Text(
              "Time left - ${_getAllTime()}",
              style: Styles.textBold(size: 16),
            ),
          ),
          Spacer(),
          /*TapWidget(
            onTap: () {
              if (widget.isReview) {
                Navigator.pushAndRemoveUntil(_scaffoldContext,
                    NextPageRoute(homePage()), (route) => false);
              } else {
                if (!widget._isOptionSelected) {
                  AlertsWidget.alertWithOkCancelBtn(
                    context: _scaffoldContext,
                    onOkClick: () {
                      widget._stopWatchTimer.onExecute
                          .add(StopWatchExecute.reset);
                      widget._allTimer!.cancel();
                      print('ANSWER 1');
                      //_submitAnswers();

                    },
                    text:
                    "You still have time left. Do you want to submit your test now?",
                    title: "Finish Assessment",
                  );
                } else {
                  AlertsWidget.alertWithOkBtn(
                    context: _scaffoldContext,
                    onOkClick: () {
                      widget._showSubmitDialog = true;
                    },
                    text: "You still have time left. Do you want to submit your test now?",
                  );
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.08),
                        blurRadius: 32,
                        offset: Offset(0, 4))
                  ]),
              child: Text(
                "Submit",
                style: Styles.textBold(size: 16),
              ),
            ),
          ),*/
        ],
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
              child: ListView.builder(
                  controller: widget._questionController,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return TapWidget(
                      onTap: () {
                        if (widget._isOptionSelected) {
                          AlertsWidget.alertWithOkBtn(
                              context: _scaffoldContext,
                              text:
                                  "You still have time left. Do you want to submit your test now?tion");
                          return;
                        }
                        print(widget._currentQuestionId);
                        print(widget._list[widget._currentQuestion].question!
                            .questionId);
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
                            widget._stopWatchTimer.onExecute
                                .add(StopWatchExecute.reset);
                            widget._pageViewController.animateToPage(i,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.ease);
                            Utility.waitForMili(200).then((value) {
                              print("###4");

                              widget._stopWatchTimer = StopWatchTimer();

                              widget._stopWatchTimer.setPresetSecondTime(widget
                                  ._list[widget._currentQuestion]
                                  .question!
                                  .timeTaken!);
                              widget._stopWatchTimer.onExecute
                                  .add(StopWatchExecute.start);
                            });

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
                                  color: Colors.grey,
                                  offset: Offset(0, 8),
                                  blurRadius: 30)
                            ],
                            color: widget._list[index].color,
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
                  itemCount: widget._list.length),
            ),
          );
  }

  _questionNumber(TestAttemptBean testAttemptBean) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            "Q.${(widget._currentQuestion + 1).toString().padLeft(2, '0')}",
            style: Styles.textRegular(size: 22),
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: TapWidget(
              onTap: () {
                widget._list[widget._currentQuestion].isBookmark =
                    !widget._list[widget._currentQuestion].isBookmark;
                if (widget._list[widget._currentQuestion].isBookmark) {
                  if (widget._list[widget._currentQuestion].question!
                      .selectedOption.isEmpty) {
                    widget._list[widget._currentQuestion].color =
                        ColorConstants.REVIEWED;
                  } else {
                    widget._list[widget._currentQuestion].color =
                        ColorConstants.ANSWERED_REVIEWS;
                  }
                } else {
                  if (widget._list[widget._currentQuestion].question!
                      .selectedOption.isEmpty) {
                    widget._list[widget._currentQuestion].color =
                        ColorConstants.NOT_ANSWERED;
                  } else {
                    widget._list[widget._currentQuestion].color =
                        ColorConstants.ANSWERED;
                  }
                }
                setState(() {});
              },
              child: Icon(
                widget._list[widget._currentQuestion].isBookmark
                    ? Icons.bookmark_outlined
                    : Icons.bookmark_border_outlined,
                color: ColorConstants.REVIEWED,
                size: 25,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Visibility(
            visible: (widget._list[widget._currentQuestion].question
                        ?.selectedOption.length ??
                    0) >
                0,
            child: TapWidget(
              onTap: () {
                setState(() {
                  widget._list[widget._currentQuestion].question!.selectedOption
                      .clear();
                  for (var data in widget
                      ._list[widget._currentQuestion].question!.options!) {
                    data.selected = false;
                  }

                  widget._isOptionSelected = false;
                });
              },
              child: Text(
                "Clear",
                style: Styles.textBold(),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  _solutionType(String type, TestAttemptBean testAttemptBean) {
    print('============Type=============');
    print(type);
    switch (type) {
      case "1":
        return _multiChoose(testAttemptBean); //MULTIPLE_CHOICE
      case "2":
        return _options(testAttemptBean); //SINGLE_INTEGER
      case "3":
        return _chooseOne(testAttemptBean); //MULTIPLE_RESPONSE

      case "4":
        return _chooseOne(testAttemptBean); //FILL_IN_THE_BLANK

      case "5":
        return _chooseOne(testAttemptBean); //TRUE_FALSE

      case "6":
      //return _subjective(testAttemptBean); //SUBJECTIVE

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
        headers: {"auth": "test_for_sql_encoding"},
        openFileFromNotification: true,
      );
      print(taskId);
    } catch (e) {
      print(e);
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {}

  ReceivePort _port = ReceivePort();

  _downloadListener() {
    FlutterDownloader.registerCallback(downloadCallback);
  }

  _options(TestAttemptBean testAttemptBean) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              testAttemptBean.question!.questionType ?? "",
              style: Styles.textBold(size: 18),
            ),
          ),
          Column(
            children: List.generate(
              widget._list[widget._currentQuestion].question!.options!.length,
              (index) => Column(
                children: [
                  TapWidget(
                    onTap: () {
                      widget._isOptionSelected = true;
                      setState(() {
                        widget._list[widget._currentQuestion].question!
                            .selectedOption
                            .clear();
                        widget._list[widget._currentQuestion].question!
                            .selectedOption
                            .add(widget._list[widget._currentQuestion].question!
                                .options![index].optionId);
                        for (var data = 0;
                            data <
                                widget._list[widget._currentQuestion].question!
                                    .options!.length;
                            data++) {
                          if (widget._list[widget._currentQuestion].question!
                                  .options![data].optionId ==
                              widget._list[widget._currentQuestion].question!
                                  .selectedOption.first) {
                            widget._list[widget._currentQuestion].question!
                                .options![data].selected = true;
                          } else {
                            widget._list[widget._currentQuestion].question!
                                .options![data].selected = false;
                          }
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: widget._list[widget._currentQuestion].question!
                                  .options![index].selected
                              ? ColorConstants.SELECTED_GREEN
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                                blurRadius: 16,
                                offset: Offset(0, 8))
                          ]),
                      child: Container(
                        width: MediaQuery.of(_scaffoldContext).size.width,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 25),
                        child: Text(
                          widget._list[widget._currentQuestion].question!
                              .options![index].optionStatement!,
                          style: widget._list[widget._currentQuestion].question!
                                  .options![index].selected
                              ? Styles.boldWhite(size: 18)
                              : Styles.textRegular(
                                  size: 18,
                                  //color: Color.fromRGBO(28, 37, 85, 0.58)
                                ),
                        ),
                      ),
                    ),
                  ),
                  _size(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _multiChoose(TestAttemptBean testAttemptBean) {
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
              style: Styles.textRegular(size: 18),
            ),
          ),
          _size(height: 20),
          Column(
            children: List.generate(
              widget._list[widget._currentQuestion].question!.options!.length,
              (index) => Column(
                children: [
                  TapWidget(
                    onTap: () {
                      widget._isOptionSelected = true;
                      setState(() {
                        widget._list[widget._currentQuestion].question!
                            .selectedOption
                            .clear();
                        widget._list[widget._currentQuestion].question!
                            .selectedOption
                            .add(widget._list[widget._currentQuestion].question!
                                .options![index].optionId);
                        for (var data = 0;
                            data <
                                widget._list[widget._currentQuestion].question!
                                    .options!.length;
                            data++) {
                          if (widget._list[widget._currentQuestion].question!
                                  .options![data].optionId ==
                              widget._list[widget._currentQuestion].question!
                                  .selectedOption.first) {
                            widget._list[widget._currentQuestion].question!
                                .options![data].selected = true;
                          } else {
                            widget._list[widget._currentQuestion].question!
                                .options![data].selected = false;
                          }
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget._list[widget._currentQuestion].question!
                                .options![index].selected
                            ? ColorConstants.SELECTED_GREEN
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: widget._list[widget._currentQuestion]
                                    .question!.options![index].selected
                                ? ColorConstants.SELECTED_GREEN
                                : Colors.grey),
                        /*boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                                blurRadius: 16,
                                offset: Offset(0, 8))
                          ]*/
                      ),
                      child: Container(
                        width: MediaQuery.of(_scaffoldContext).size.width,
                        //alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        child: Text(
                          widget._list[widget._currentQuestion].question!
                              .options![index].optionStatement!,
                          style: widget._list[widget._currentQuestion].question!
                                  .options![index].selected
                              ? Styles.boldWhite(size: 18)
                              : Styles.textRegular(
                                  size: 14, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  _size(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _chooseOne(TestAttemptBean testAttemptBean) {
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
              style: Styles.textBold(size: 20),
            ),
          ),
          _size(height: 15),
          Column(
            children: List.generate(
              widget._list[widget._currentQuestion].question!.options!.length,
              (index) => Column(
                children: [
                  TapWidget(
                    onTap: () {
                      widget._isOptionSelected = true;
                      setState(() {
                        widget._list[widget._currentQuestion].question!
                            .selectedOption
                            .clear();
                        widget._list[widget._currentQuestion].question!
                            .selectedOption
                            .add(widget._list[widget._currentQuestion].question!
                                .options![index].optionId);
                        for (var data = 0;
                            data <
                                widget._list[widget._currentQuestion].question!
                                    .options!.length;
                            data++) {
                          if (widget._list[widget._currentQuestion].question!
                                  .options![data].optionId ==
                              widget._list[widget._currentQuestion].question!
                                  .selectedOption.first) {
                            widget._list[widget._currentQuestion].question!
                                .options![data].selected = true;
                          } else {
                            widget._list[widget._currentQuestion].question!
                                .options![data].selected = false;
                          }
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: widget._list[widget._currentQuestion].question!
                                  .options![index].selected
                              ? ColorConstants.SELECTED_GREEN
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                                blurRadius: 16,
                                offset: Offset(0, 8))
                          ]),
                      child: Container(
                        width: MediaQuery.of(_scaffoldContext).size.width,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Text(
                          widget._list[widget._currentQuestion].question!
                              .options![index].optionStatement!,
                          style: widget._list[widget._currentQuestion].question!
                                  .options![index].selected
                              ? Styles.boldWhite(size: 18)
                              : Styles.textRegular(
                                  size: 18,
                                  //color: Color.fromRGBO(28, 37, 85, 0.58)
                                ),
                        ),
                      ),
                    ),
                  ),
                  _size(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitAnswers() {
    _authBloc.add(SubmitAnswerEvent(request: widget.contentId.toString()));
  }

  void _handlePreviousButton() {
    widget._pageViewController.previousPage(
      duration: Duration(milliseconds: 100),
      curve: Curves.ease,
    );
  }

  _buildBottomAppBar() {
    if ((widget._list.length - 1) == widget._currentQuestion) {
      widget._lastSave = true;
    }
    return BottomAppBar(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget._currentQuestion == 0
                ? SizedBox(
                    width: 100,
                  )
                : TapWidget(
                    onTap: () {
                      print(widget._isOptionSelected);
                      print(widget._isContinued);
                      if (widget._isOptionSelected) {
                        AlertsWidget.alertWithOkBtn(
                          context: _scaffoldContext,
                          onOkClick: () {
                            widget._showSubmitDialog = true;
                          },
                          text:
                              "You still have time left. Do you want to submit your test now?",
                        );
                        return;
                      }
                      _handlePreviousButton();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          //color: Color.fromRGBO(157, 191, 242, 1),
                          //borderRadius: BorderRadius.circular(8)
                          ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            style:
                                Styles.textBold(size: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
            Container(
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
                    "${(widget._currentQuestion + 1).toString() + "/" + widget._list.length.toString()}",
                    style: Styles.textBold(size: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            TapWidget(
              onTap: () {
                print('object save');
                _saveClick();
                widget._isSavedManually = true;
                // if ((widget._list.length - 1) == widget._currentQuestion) {
                //   widget._lastSave = true;
                //   AlertsWidget.alertWithOkCancelBtn(
                //       context: _scaffoldContext,
                //       onOkClick: () {
                //         //  _saveClick();
                //         widget._stopWatchTimer.onExecute
                //             .add(StopWatchExecute.reset);
                //         widget._allTimer!.cancel();
                //         print('ANSWER SUBMIT');
                //         _saveClick();
                //         widget._isEverythingOver = true;
                //         //_submitAnswers();
                //       },
                //       // okText: "SUBMIT",
                //       // cancelText: "CONTINUE",
                //       text:
                //           "You still have time left. Do you want to submit your test now?",
                //       title: "Finish Assessment",
                //       onCancelClick: () {
                //         widget._isOptionSelected = false;
                //         widget._isContinued = true;
                //         widget._lastSave = false;
                //         _saveClick();
                //       });
                // } else {
                //   _saveClick();
                //   widget._isSavedManually = true;
                // }
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
                      ((widget._list.length - 1) == widget._currentQuestion)
                          ? "Save"
                          : "Next",
                      style: Styles.textBold(size: 16, color: Colors.black),
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
    );
  }
}
