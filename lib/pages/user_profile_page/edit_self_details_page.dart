
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:masterg/utils/resource/colors.dart';

import '../../blocs/bloc_manager.dart';
import '../../blocs/home_bloc.dart';
import '../../data/api/api_service.dart';
import '../../data/models/response/auth_response/user_session.dart';
import '../../local/pref/Preference.dart';
import '../../utils/Log.dart';
import '../../utils/Strings.dart';
import '../../utils/Styles.dart';
import '../../utils/config.dart';
import '../../utils/widget_size.dart';
import '../auth_pages/sign_up_screen.dart';
import '../custom_pages/ScreenWithLoader.dart';
import '../custom_pages/alert_widgets/alerts_widget.dart';
import '../custom_pages/custom_widgets/NextPageRouting.dart';

class EditSelfDetailsPage extends StatefulWidget {
  final String? name;
  final String? email;
  final Function? onCalledBack;

  const EditSelfDetailsPage({Key? key, this.name, this.email, this.onCalledBack}) : super(key: key);

  @override
  State<EditSelfDetailsPage> createState() => _EditSelfDetailsPageState();
}

class _EditSelfDetailsPageState extends State<EditSelfDetailsPage> {

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    fullNameController.text = widget.name!;
    emailController.text = widget.email!;
    super.initState();
  }

  void _updateUserProfileImage(String? name, String? email) async {
    if (!_formKey.currentState!.validate()) return;

    print('_updateUserProfileImage');
    print(email);
    BlocProvider.of<HomeBloc>(context).add(UpdateUserProfileImageEvent(name: name, email: email));
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is UpdateUserProfileImageState) {
            _handleUpdateUserProfileImageResponse(state);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            elevation: 0,
            leading: BackButton(color: Colors.black),
            backgroundColor: ColorConstants().primaryColor(),
            actions: [
              IconButton(
                  onPressed: () {
                    AlertsWidget.showCustomDialog(
                        context: context,
                        title: "Leaving so soon…",
                        text: "Are you sure you want to exit?",
                        icon: 'assets/images/circle_alert_fill.svg',
                        onOkClick: () async {
                          UserSession.clearSession();
                          await Hive.deleteFromDisk();
                          Preference.clearPref().then((value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                NextPageRoute(SignUpScreen()),
                                    (route) => false);
                          });
                        });
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ))
            ],
          ),

          //body: _makeBody(),
          body: SafeArea(
            child: ScreenWithLoader(
              isLoading: _isLoading,
              body: _makeBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _makeBody() {
    return Form(
      key: _formKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
        child: Column(
          children: [
            TextFormField(
              controller: fullNameController,
              style: Styles.regular(),
              maxLength: 100,
              decoration: InputDecoration(
                hintText: '${Strings.of(context)?.EnterFullName}',
                helperStyle: Styles.regular(color: ColorConstants.GREY_4),
                counterText: "",
                suffixIconConstraints: BoxConstraints(minWidth: 0),
                // suffixIcon: Text(
                //   fullNameController.value.text.length > 0 ? '' : "*",
                //   style: Styles.regular(color: ColorConstants.RED_BG),
                // ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorConstants().primaryColor(), width: 1.5),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
              validator: (value) {
                if (value!.length == 0)
                  return '${Strings.of(context)?.EnterFullName}';

                return null;
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: emailController,
              style: Styles.regular(),
              decoration: InputDecoration(
                hintText: '${Strings.of(context)?.emailAddress}',
                helperStyle: Styles.regular(color: ColorConstants.GREY_4),
                counterText: "",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorConstants().primaryColor(), width: 1.5),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
              validator: (value) {
                print('the value is $value');
                if (value == '')
                  return 'Email is required';

                if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value!))
                  return '${Strings.of(context)?.emailAddressError}';

                return null;
              },
            ),

            SizedBox(height: 50),
            InkWell(
                onTap: () {
                  _updateUserProfileImage(fullNameController.text.toString(), emailController.text.toString());
                },
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height *
                      WidgetSize.AUTH_BUTTON_SIZE,
                  margin: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                  decoration: BoxDecoration(
                      color: ColorConstants().buttonColor(),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                        '${Strings.of(context)?.continueStr}',
                        style: Styles.regular(
                          color: ColorConstants.BLACK,
                        ),
                      )),
                )),
          ],
        ),
      ),
    );
  }

  _finishEdit(){
    Navigator.pop(context, true);
    widget!.onCalledBack!();
  }

  void _handleUpdateUserProfileImageResponse(UpdateUserProfileImageState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("UserProfileState....................");
          Preference.setString(Preference.PROFILE_IMAGE, '${state.response!.data!.profileImage}');
          Preference.setString(Preference.USER_EMAIL, '${state.response!.data!.email}');
          Preference.setString(Preference.USERNAME, '${state.response!.data!.name}');
          //Navigator.of(context).pop();
          Navigator.pop(context, true);
          widget!.onCalledBack!();
          _isLoading = false;
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }


}

