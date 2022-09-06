import 'dart:io';

import 'package:file_picker/file_picker.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/home_request/submit_feedback_req.dart';
import 'package:masterg/data/models/response/home_response/topics_resp.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/app_button.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:permission_handler/permission_handler.dart';

class WriteFeedbackPage extends StatefulWidget {
  int type;

  WriteFeedbackPage(this.type);

  @override
  _WriteFeedbackPageState createState() => _WriteFeedbackPageState();
}

class _WriteFeedbackPageState extends State<WriteFeedbackPage> {
  final titleController = TextEditingController();
  final topicController = TextEditingController();
  final descController = TextEditingController();
  final emailController = TextEditingController();

  final titleFocus = FocusNode();
  final topicFocus = FocusNode();
  final descFocus = FocusNode();
  final emailFocus = FocusNode();

  bool _isLoading = false;
  String? selectTopics;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File? selectedFile;

  List<ListTopics>? listData;

  @override
  void initState() {
    // FirebaseAnalytics().logEvent(name: "write_idea_opened", parameters: null);
    // FirebaseAnalytics().setCurrentScreen(screenName: "write_feedback_screen");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (BuildContext context) {
          _getTopics();
        },
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is SubmitFeedbackState) _handleResponse(state);
              if (state is TopicsState) _handleTopicResponse(state);
            },
            child: CommonContainer(
              isBackShow: false,
              isLoading: _isLoading,
              child: _makeBody(),
              title: widget.type == 1
                  ? Strings.of(context)?.writeFeedback
                  : Strings.of(context)?.Idea_Factory,
              onBackPressed: () {
                Navigator.pop(context);
              },
            )));
  }

  _makeBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${Strings.of(context)?.title}',
            style: Styles.textRegular(color: ColorConstants.TEXT_DARK_BLACK),
          ),
          TextFormField(
            controller: titleController,
            focusNode: titleFocus,
            style: Styles.textBold(size: 16),
            decoration: textInputDecoration.copyWith(
              hintText: Strings.of(context)?.title,
            ),
            validator: (value) =>
                value!.isEmpty ? Strings.of(context)?.title : null,
            textInputAction: TextInputAction.next,
            onChanged: (value) {},
            onFieldSubmitted: (val) {
              topicFocus.requestFocus();
            },
          ),
          SizedBox(height: 20.0),
          Text(
            "username",
            style: Styles.textRegular(color: ColorConstants.TEXT_DARK_BLACK),
          ),
          TextFormField(
            controller: emailController,
            focusNode: emailFocus,
            style: Styles.textBold(size: 16),
            decoration: textInputDecoration.copyWith(
              hintText: Strings.of(context)?.enterEmail,
            ),
            validator: (value) =>
                value!.isEmpty ? Strings.of(context)?.enterEmail : null,
            textInputAction: TextInputAction.next,
            onChanged: (value) {},
            onFieldSubmitted: (val) {
              topicFocus.requestFocus();
            },
          ),
          SizedBox(height: 20.0),
          Text(
            '${Strings.of(context)?.topic}',
            style: Styles.textRegular(color: ColorConstants.TEXT_DARK_BLACK),
          ),
          _getTopicWidget(),
          SizedBox(height: 20.0),
          Text(
            '${Strings.of(context)?.description}',
            style: Styles.textRegular(color: ColorConstants.TEXT_DARK_BLACK),
          ),
          TextFormField(
            controller: descController,
            focusNode: descFocus,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            maxLines: 5,
            style: Styles.textBold(size: 16),
            decoration: textInputDecoration.copyWith(
              hintText: Strings.of(context)?.description,
            ),
            validator: (value) =>
                value!.isEmpty ? Strings.of(context)!.description : null,
            onChanged: (value) {},
            onFieldSubmitted: (val) {},
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '${Strings.of(context)?.attachFile}',
            style: Styles.textRegular(color: ColorConstants.TEXT_DARK_BLACK),
          ),
          selectedFile != null
              ? ListTile(
                  leading: Icon(Icons.attach_file_rounded),
                  title: Text(selectedFile!.path.split("/").last),
                  trailing: InkWell(
                      onTap: () {
                        setState(() {
                          selectedFile = null;
                        });
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                      )),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: AppButton(
                    onTap: () async {
                      if (await Permission.storage.request().isGranted) {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          File file = File(result.files.single.path!);
                          setState(() {
                            selectedFile = file;
                          });
                        }
                      }
                    },
                    title: Strings.of(context)?.attachFile,
                  ),
                ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: AppButton(
              onTap: () {
                submitFeedback();
              },
              title: Strings.of(context)?.submit,
            ),
          )
        ],
      ),
    );
  }

  void _handleResponse(SubmitFeedbackState state) {
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

  void submitFeedback() {
    print(selectedFile?.path);
    BlocProvider.of<HomeBloc>(context).add(SubmitFeedbackEvent(
        feedbackReq: FeedbackReq(
            topic: selectTopics,
            type: widget.type,
            email: emailController.text.toString(),
            title: titleController.text.toString(),
            description: descController.text.toString(),
            filePath: selectedFile?.path ?? "")));
  }

  _getTopicWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
            width: 1.5, color: ColorConstants.DARK_BLUE.withOpacity(0.44)),
      ),
      child: listData?.length == 0
          ? Container()
          : DropdownButton<String>(
              style: Styles.textBold(color: ColorConstants.TEXT_DARK_BLACK),
              value: selectTopics ?? listData?.first.title,
              underline: Container(),
              isExpanded: true,
              items: listData?.map((ListTopics value) {
                return new DropdownMenuItem<String>(
                  value: value.title,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      value.title ?? '',
                      style: Styles.textRegular(
                          color: ColorConstants.TEXT_DARK_BLACK),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectTopics = value;
                });
              },
            ),
    );
  }

  void _getTopics() {
    BlocProvider.of<HomeBloc>(context).add(TopicsEvent());
  }

  void _handleTopicResponse(TopicsState state) {
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
          listData?.clear();
          listData = state.response?.data?.listTopics;
          // listData?.addAll(state.response?.data?.listTopics);
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
}
