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
import 'package:masterg/pages/swayam_pages/business_details_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class SocialMediaPage extends StatefulWidget {
  bool? isSkipShow;
  UpdateUserRequest? request;
  bool? isFromProfile;

  SocialMediaPage(
      {this.isSkipShow = false, this.request, this.isFromProfile = false});

  @override
  _SocialMediaPageState createState() => _SocialMediaPageState();
}

class _SocialMediaPageState extends State<SocialMediaPage> {
  final whatsAppController = TextEditingController();
  final fbController = TextEditingController();

  final twitterController = TextEditingController();
  final instaController = TextEditingController();

  final whatsAppFocus = FocusNode();
  final fbFocus = FocusNode();
  final twitterFocus = FocusNode();
  final instaFocus = FocusNode();
  bool _isLoading = false;

  UserData user = new UserData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isFromProfile == true) {
      user = UserData.fromJson(json.decode('${UserSession.userData}'));
      whatsAppController.text = user.whatsappId ?? "";
      fbController.text = user.facebookId ?? "";
      twitterController.text = user.twitter ?? "";
      instaController.text = user.instagram ?? "";
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
              onSkipClicked: () {
                Navigator.push(
                    context,
                    NextPageRoute(BusinessDetailsPage(
                      isSkipShow: widget.isSkipShow,
                      request: widget.request,
                    )));
              },
              isLoading: _isLoading,
              child: _makeBody(),
              title: Strings.of(context)?.socialMedia,
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
                  '${Strings.of(context)?.whatsapp}',
                  style:
                      Styles.textRegular(color: ColorConstants.TEXT_DARK_BLACK),
                ),
                TextFormField(
                  readOnly:
                      user.whatsappId != null && user.whatsappId!.isNotEmpty,
                  controller: whatsAppController,
                  focusNode: whatsAppFocus,
                  style: Styles.textBold(size: 16),
                  decoration: textInputDecoration.copyWith(
                    hintText: "",
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  onFieldSubmitted: (val) {
                    fbFocus.requestFocus();
                  },
                ),
                SizedBox(height: 20.0),
                Text(
                  '${Strings.of(context)?.facebookId}',
                  style:
                      Styles.textRegular(color: ColorConstants.TEXT_DARK_BLACK),
                ),
                TextFormField(
                  readOnly:
                      user.facebookId != null && user.facebookId!.isNotEmpty,
                  controller: fbController,
                  focusNode: fbFocus,
                  textInputAction: TextInputAction.next,
                  style: Styles.textBold(size: 16),
                  decoration: textInputDecoration.copyWith(
                    hintText: "",
                  ),
                  onChanged: (value) {},
                  onFieldSubmitted: (val) {
                    instaFocus.requestFocus();
                  },
                ),
                SizedBox(height: 20.0),
                Text(
                  '${Strings.of(context)?.insta}',
                  style:
                      Styles.textRegular(color: ColorConstants.TEXT_DARK_BLACK),
                ),
                TextFormField(
                  readOnly:
                      user.instagram != null && user.instagram!.isNotEmpty,
                  controller: instaController,
                  focusNode: instaFocus,
                  style: Styles.textBold(size: 16),
                  decoration: textInputDecoration.copyWith(
                    hintText: "",
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  onFieldSubmitted: (val) {
                    twitterFocus.requestFocus();
                  },
                ),
                SizedBox(height: 20.0),
                Text(
                  '${Strings.of(context)?.twitterHandle}',
                  style:
                      Styles.textRegular(color: ColorConstants.TEXT_DARK_BLACK),
                ),
                TextFormField(
                  readOnly: user.twitter != null && user.twitter!.isNotEmpty,
                  controller: twitterController,
                  focusNode: twitterFocus,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.done,
                  style: Styles.textBold(size: 16),
                  decoration: textInputDecoration.copyWith(
                    hintText: "",
                  ),
                  onChanged: (value) {},
                  onFieldSubmitted: (val) {},
                ),
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
              title: Strings.of(context)?.saveChanges,
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
      widget.request?.facebookId = fbController.text.toString();
      widget.request?.twitter = twitterController.text.toString();
      widget.request?.instagram = instaController.text.toString();
      widget.request?.whatsappId = whatsAppController.text.toString();
      Navigator.push(
          context,
          NextPageRoute(BusinessDetailsPage(
            isSkipShow: widget.isSkipShow,
            request: widget.request,
          )));
    } else {
      var req = UpdateUserRequest(
          facebookId: fbController.text.toString(),
          twitter: twitterController.text.toString(),
          instagram: instaController.text.toString(),
          whatsappId: whatsAppController.text.toString());
      BlocProvider.of<AuthBloc>(context).add(UpdateUserEvent(request: req));
    }
  }
}
