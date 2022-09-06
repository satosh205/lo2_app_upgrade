import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/auth_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/auth_request/update_user_request.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/city_state_response.dart';
import 'package:masterg/data/models/response/home_response/user_info_response.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/app_button.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/swayam_pages/social_media_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class AddressScreen extends StatefulWidget {
  bool isSkipShow;
  bool isFromProfile;

  AddressScreen({this.isSkipShow = false, this.isFromProfile = false});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();

  final landmarkController = TextEditingController();
  final postofficeController = TextEditingController();
  final cityController = TextEditingController();

  final stateController = TextEditingController();

  final address1Focus = FocusNode();
  final address2Focus = FocusNode();
  final landmarkFocus = FocusNode();
  final postFocus = FocusNode();
  final cityFocus = FocusNode();
  final stateFocus = FocusNode();

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  int? selectedState, selectedCity;
  List<CityStateData>? stateData ;
  List<CityStateData>? cityData;

  UserData user = new UserData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isFromProfile) {
      user = UserData.fromJson(json.decode(UserSession.userData!));
      address1Controller.text = user.address1 ?? "";
      address2Controller.text = user.address2 ?? "";
      postofficeController.text = user.postOffice ?? "";
      landmarkController.text = user.landmark ?? "";
      selectedCity = user.city ?? 0;
      selectedState = int.parse('${user.state}') ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (BuildContext context) {
          getStateList();
        },
        child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UpdateUserState)
                _handleResponse(state);
              else if (state is StateState)
                _handleStateResp(state);
              else if (state is CityState) _handleCityResp(state);
            },
            child: CommonContainer(
              isBackShow: !widget.isSkipShow,
              isLoading: _isLoading,
              child: _makeBody(),
              title: Strings.of(context)?.address,
              onBackPressed: () {
                Navigator.pop(context);
              },
            )));
  }

  _makeBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${Strings.of(context)?.address} 1",
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        readOnly:
                            user.address1 != null && user.address1!.isNotEmpty,
                        controller: address1Controller,
                        focusNode: address1Focus,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                          hintText: "",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '${Strings.of(context)!.address} 1';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {
                          address2Focus.requestFocus();
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "${Strings.of(context)?.address} 2",
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        readOnly:
                            user.address2 != null && user.address2!.isNotEmpty,
                        controller: address2Controller,
                        focusNode: address2Focus,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                          hintText: "",
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {
                          landmarkFocus.nextFocus();
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        '${Strings.of(context)?.landmark}',
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        readOnly:
                            user.landmark != null && user.landmark!.isNotEmpty,
                        controller: landmarkController,
                        focusNode: landmarkFocus,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                          hintText: "",
                        ),
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {
                          postFocus.nextFocus();
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        '${Strings.of(context)?.postOffice}',
                        style: Styles.textRegular(
                            color: ColorConstants.TEXT_DARK_BLACK),
                      ),
                      TextFormField(
                        readOnly: user.postOffice != null &&
                            user.postOffice!.isNotEmpty,
                        controller: postofficeController,
                        focusNode: postFocus,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        style: Styles.textBold(size: 16),
                        decoration: textInputDecoration.copyWith(
                          hintText: "",
                        ),
                        onChanged: (value) {},
                        onFieldSubmitted: (val) {
                          cityFocus.nextFocus();
                        },
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _getStateWidget(),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: _getCityWidget(),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
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
              text: '${loginState.response?.message}',
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
    if (!_formKey.currentState!.validate()) return;
    var req = UpdateUserRequest(
      address1: address1Controller.text.toString(),
      address2: address2Controller.text.toString(),
      postOffice: postofficeController.text.toString(),
      landmark: landmarkController.text.toString(),
      city: selectedCity,
      state: selectedState,
    );
    if (widget.isSkipShow) {
      Navigator.push(
          context,
          NextPageRoute(SocialMediaPage(
            isSkipShow: widget.isSkipShow,
            request: req,
          )));
    } else
      BlocProvider.of<AuthBloc>(context).add(UpdateUserEvent(request: req));
  }

  void _handleStateResp(StateState state) {
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
          stateData?.clear();
          stateData = state.response?.data?.listData;
          // stateData?.addAll(state.response.data.listData);
          bool isAvailable = false;
          stateData?.forEach((element) {
            if (element.id == selectedState) isAvailable = true;
          });
          if (!isAvailable) selectedState = 0;
          if (selectedState! > 0) {
            getCity(selectedState!);
          }
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

  void _handleCityResp(CityState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = false;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          cityData?.clear();
          cityData = state.response?.data?.listData;
          bool isAvailable = false;
          cityData?.forEach((element) {
            if (element.id == selectedCity) isAvailable = true;
          });
          if (!isAvailable) selectedCity = 0;
          _isLoading = false;
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

  _getCityWidget() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
            width: 1.5, color: ColorConstants.DARK_BLUE.withOpacity(0.44)),
      ),
      child: cityData?.length == 0
          ? Container()
          : DropdownButton<int>(
              style: Styles.textBold(color: ColorConstants.TEXT_DARK_BLACK),
              value: selectedCity != 0 ? selectedCity : cityData?.first.id,
              underline: Container(),
              isExpanded: true,
              items: cityData?.map((CityStateData value) {
                return new DropdownMenuItem<int>(
                  value: value.id,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      value.label ?? '',
                      style: Styles.textRegular(
                          color: ColorConstants.TEXT_DARK_BLACK),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                });
              },
            ),
    );
  }

  _getStateWidget() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
            width: 1.5, color: ColorConstants.DARK_BLUE.withOpacity(0.44)),
      ),
      child: stateData?.length == 0
          ? Container()
          : DropdownButton<int>(
              style: Styles.textBold(color: ColorConstants.TEXT_DARK_BLACK),
              value: selectedState != 0 ? selectedState : stateData?.first.id,
              underline: Container(),
              isExpanded: true,
              items: stateData?.map((CityStateData value) {
                return new DropdownMenuItem<int>(
                  value: value.id,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      value.label ?? '',
                      style: Styles.textRegular(
                          color: ColorConstants.TEXT_DARK_BLACK),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                getCity(value!);
                setState(() {
                  selectedState = value;
                });
              },
            ),
    );
  }

  void getStateList() {
    BlocProvider.of<AuthBloc>(context).add(StateEvent());
  }

  void getCity(int stateId) {
    BlocProvider.of<AuthBloc>(context).add(CityEvent(stateId));
  }
}
