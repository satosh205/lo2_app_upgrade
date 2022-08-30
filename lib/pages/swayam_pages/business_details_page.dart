import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/auth_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/auth_request/update_user_request.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/user_info_response.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/app_button.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/swayam_pages/language_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class BusinessDetailsPage extends StatefulWidget {
  bool? isSkipShow;
  UpdateUserRequest? request;
  bool? isFromProfile;

  BusinessDetailsPage(
      {this.isSkipShow = false, this.request, this.isFromProfile = false});

  @override
  _BusinessDetailsPageState createState() => _BusinessDetailsPageState();
}

class _BusinessDetailsPageState extends State<BusinessDetailsPage> {
  final gstController = TextEditingController();
  final panController = TextEditingController();

  final gstFocus = FocusNode();
  final panFocus = FocusNode();
  bool _isLoading = false;

  UserData user = new UserData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isFromProfile == true) {
      user = UserData.fromJson(json.decode('${UserSession.userData}'));
      // gstController.text = user.gstNumber ?? "";
      // panController.text = user.panNumber ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UpdateUserState) _handleResponse(state);
            },
            child: CommonContainer(
              isBackShow: true,
              isSkipEnable: widget.isSkipShow,
              onSkipClicked: () {},
              isLoading: _isLoading,
              child: _makeBody(),
              title: Strings.of(context)?.businessDetails,
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
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${Strings.of(context)?.gstNumber}',
                  style:
                      Styles.textRegular(color: ColorConstants.TEXT_DARK_BLACK),
                ),
                TextFormField(
                  readOnly: true,
                  controller: gstController,
                  focusNode: gstFocus,
                  style: Styles.textBold(size: 16),
                  decoration: textInputDecoration.copyWith(
                    hintText: "",
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  onFieldSubmitted: (val) {
                    panFocus.requestFocus();
                  },
                ),
                SizedBox(height: 20.0),
                Text(
                  '${Strings.of(context)?.panNumber}',
                  style:
                      Styles.textRegular(color: ColorConstants.TEXT_DARK_BLACK),
                ),
                TextFormField(
                  readOnly: true,
                  controller: panController,
                  focusNode: panFocus,
                  textInputAction: TextInputAction.done,
                  style: Styles.textBold(size: 16),
                  decoration: textInputDecoration.copyWith(
                    hintText: "",
                  ),
                  onChanged: (value) {},
                  onFieldSubmitted: (val) {},
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: AppButton(
              onTap: () {
                saveChanges();
              },
              title: '${Strings.of(context)?.saveChanges}',
            ),
          )
        ],
      ),
    );
  }

  void _handleResponse(UpdateUserState state) {
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
              text: '${loginState.response?.error}',
              onOkClick: () {
                if (widget.isSkipShow == true) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      NextPageRoute(LanguagePage(
                        languageType: 1,
                        isFromLogin: true,
                      )),
                      (Route<dynamic> route) => false);
                } else
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

  void saveChanges() {
    if (widget.isSkipShow == true) {
      widget.request?.gstNumber = gstController.text.toString();
      widget.request?.panNumber = panController.text.toString();
      BlocProvider.of<AuthBloc>(context)
          .add(UpdateUserEvent(request: widget.request));
    } else {
      var req = UpdateUserRequest(
        gstNumber: gstController.text.toString(),
        panNumber: panController.text.toString(),
      );
      BlocProvider.of<AuthBloc>(context).add(UpdateUserEvent(request: req));
    }
  }
}
