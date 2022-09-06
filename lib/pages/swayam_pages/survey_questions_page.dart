// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/models/response/home_response/survey_data_resp.dart';
import 'package:masterg/pages/swayam_pages/app_constant.dart';
import 'package:masterg/pages/swayam_pages/app_outline_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:masterg/blocs/bloc_manager.dart';
// import 'package:masterg/blocs/dealer_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/home_request/poll_submit_req.dart';
import 'package:masterg/data/models/request/home_request/submit_survey_req.dart';
// import 'package:masterg/data/models/response/dealer/survey_data_resp.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/app_button.dart';
// import 'package:masterg/pages/custom_pages/app_outline_button.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
// import 'package:masterg/utils/resource/app_constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class SurveyStartPage extends StatefulWidget {
  final int? type;
  int? contentId;

  SurveyStartPage({this.contentId, this.type});

  @override
  _SurveyStartState createState() => _SurveyStartState();
}

class _SurveyStartState extends State<SurveyStartPage> {
  bool? _isLoading = true;
  ListSurvey? _surveyResp;
  int? currentIndex = 0;
  var pageController = PageController();

  @override
  void initState() {
    // FirebaseAnalytics().logEvent(name: "survey_started");
    // TODO: implement initState
    super.initState();
    Log.v(widget.contentId);
    print(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return _verticalList();
  }

  _verticalList() {
    return BlocManager(
        initState: (BuildContext context) {
          getSurveyData();
        },
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is SurveyDataState)
              _handleResponse(state);
            else if (state is SurveySubmitState)
              _handleSurveyResponse(state);
            else if (state is PollSubmitState) _handlePollResponse(state);
          },
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: ColorConstants.PRIMARY_COLOR,
              body: Builder(builder: (_context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: ColorConstants.PRIMARY_COLOR,
                  ),
                  child: ScreenWithLoader(
                    body: _surveyResp == null
                        ? Container()
                        : Column(
                            children: [
                              _getTitleWidget(context),
                              Expanded(child: _getMainBody())
                            ],
                          ),
                    isLoading: _isLoading,
                  ),
                );
              }),
            ),
          ),
        ));
  }

  _getTitleWidget(BuildContext context) {
    double percent = (currentIndex! + 1) / _surveyResp!.questions!.length;
    Log.v("$currentIndex $percent ${_surveyResp!.questions!.length}");
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                  Icons.arrow_back_ios_rounded,
                  color: ColorConstants.DARK_BLUE,
                ),
              )),
          Text(
            widget.type == 1 ? '${Strings.of(context)?.survey}' : "Poll",
            style: Styles.boldWhite(size: 20),
          ),
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 4.0,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.white.withOpacity(0.5),
            percent: percent,
            center: new Text(
              "${currentIndex! + 1}/${_surveyResp!.questions!.length}",
              style: Styles.boldWhite(),
            ),
            progressColor: Colors.white,
          )
        ],
      ),
    );
  }

  _rowItem(Questions item) {
    return Container();
  }

  _size({double height = 20, double width = 0}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  void _handleResponse(SurveyDataState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          _isLoading = false;
          _surveyResp = state.response?.data?.listSurvey;
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void _handleSurveyResponse(SurveySubmitState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          _isLoading = false;
          // FirebaseAnalytics().logEvent(name: "survey_submitted");
          AlertsWidget.alertWithOkBtn(
              context: context,
              text: loginState.response?.message ?? "",
              onOkClick: () {
                Navigator.pop(context);
              });
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void _handlePollResponse(PollSubmitState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          _isLoading = false;
          // FirebaseAnalytics().logEvent(name: "poll_submitted");
          AlertsWidget.alertWithOkBtn(
              context: context,
              text: loginState.response?.message ?? "",
              onOkClick: () {
                Navigator.pop(context);
              });
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void getSurveyData() {
    print("###3");
    print(widget.type);
    BlocProvider.of<HomeBloc>(context)
        .add(SurveyDataEvent(contentId: widget.contentId, type: widget.type));
  }

  _getMainBody() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: ColorConstants.BG_COLOR,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25))),
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: _isLoading == true
            ? Container()
            : PageView(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (page) {
                  setState(() {
                    currentIndex = page;
                  });
                },
                children: _surveyResp!.questions
                    !.map<Widget>((item) => _pageItem(item))
                    .toList(),
              ),
      ),
    );
  }

  _pageItem(Questions item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          item.question ?? "",
          textAlign: TextAlign.center,
          style: Styles.textExtraBold(size: 20),
        ),
        _size(),
        Text(
          '${item.questionType}',
          textAlign: TextAlign.center,
          style: Styles.textSemiBold(size: 16),
        ),
        _size(),
        _getOption(item.questionTypeId!, item.options!),
        Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: widget.type == 1
                    ? AppOutlineButton(
                        textColor: ColorConstants.TEXT_DARK_BLACK,
                        outLineColor: ColorConstants.TEXT_DARK_BLACK,
                        title: Strings.of(context)?.previous,
                        bgColor: currentIndex! > 0
                            ? ColorConstants.WHITE
                            : ColorConstants.DISABLE_COLOR,
                        onTap: () {
                          if (currentIndex! > 0)
                            pageController.jumpToPage(currentIndex! - 1);
                        },
                      )
                    : SizedBox(),
              ),
              _size(width: 20),
              Expanded(
                child: AppButton(
                  color: ColorConstants.PRIMARY_COLOR,
                  title: currentIndex == _surveyResp!.questions!.length - 1
                      ? Strings.of(context)?.submit
                      : Strings.of(context)?.next,
                  onTap: () {
                    if (currentIndex! < _surveyResp!.questions!.length - 1)
                      pageController.jumpToPage(currentIndex! + 1);
                    else
                      submitSurvey();
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _getOption(int quetsionType, List<Options> options) {
    return Column(
        children: options.map<Widget>((item) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: AppOutlineButton(
          textColor: ColorConstants.TEXT_DARK_BLACK,
          outLineColor: ColorConstants.TEXT_DARK_BLACK,
          isCheckVisible: item.attempted == 1,
          bgColor: item.attempted == 0
              ? ColorConstants.WHITE
              : ColorConstants.DISABLE_COLOR,
          title: item.optionStatement,
          onTap: () {
            if (quetsionType != AppConstant.MRQ_TYPE) clearOption(options);
            setState(() {
              item.attempted = item.attempted == 0 ? 1 : 0;
            });
          },
        ),
      );
    }).toList());
  }

  void clearOption(List<Options> options) {
    options.forEach((element) {
      element.attempted = 0;
    });
  }

  void submitSurvey() {
    List<QuestionSubmitted> submitQuestion = [];
    _surveyResp?.questions?.forEach((element) {
      int? questionId = element.questionId;
      List<Options> options =
          element.options!.where((element) => element.attempted == 1).toList();
      List<int> optionsId = [];
      options.forEach((element) {
        optionsId.add(element.optionId!);
      });
      var ques = QuestionSubmitted(questionId: questionId, optionId: optionsId);
      submitQuestion.add(ques);
    });
    setState(() {
      _isLoading = true;
    });
    if (widget.type == 1) {
      BlocProvider.of<HomeBloc>(context).add(SubmitSurveyEvent(
          submitSurveyReq: SubmitSurveyReq(
              contentId: widget.contentId,
              questionSubmitted: submitQuestion,
              isSubmitted: true)));
    } else {
      BlocProvider.of<HomeBloc>(context).add(SubmitPollEvent(
          submitPollReq: PollSubmitRequest(
              contentId: widget.contentId,
              optionId: submitQuestion.first.optionId,
              questionId: submitQuestion.first.questionId)));
    }
  }
}
