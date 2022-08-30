import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_constants.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/category_response.dart';
import 'package:masterg/data/models/response/home_response/content_tags_resp.dart';
import 'package:masterg/pages/custom_pages/app_button.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AnnouncementFilterPage extends StatefulWidget {
  AnnouncementFilterPage();

  @override
  _AnnouncementFilterPageState createState() => _AnnouncementFilterPageState();
}

class _AnnouncementFilterPageState extends State<AnnouncementFilterPage> {
  String _radioValue1 = "";
  bool _isLoading = false;
  List<ListTags>? tagList;
  Box? box;

  @override
  void initState() {
    getTagList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _mainContainer();
  }

  _mainContainer() {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              // if (state is ContentTagsState) _handleResponse(state);
            },
            child: CommonContainer(
              isBackShow: true,
              child: _body(),
              isLoading: false,
              title: Strings.of(context)?.announcements,
              onBackPressed: () {
                Navigator.pop(context);
              },
            )));
  }

  _size({double height = 20, double width = 0}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  _body() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${Strings.of(context)?.announcementFilters}',
              style: Styles.textExtraBold(
                  size: 18, color: ColorConstants.TEXT_DARK_BLACK),
            ),
            Expanded(
                child: ValueListenableBuilder(
              valueListenable: box!.listenable(),
              builder: (bc, Box box, child) {
                if (box.get("announcementFilters") == null ||
                    box.get("announcementFilters").isEmpty) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        "There are no filters available",
                        style: Styles.textBold(),
                      ),
                    ),
                  );
                }
                tagList = box
                    .get("announcementFilters")
                    .map((e) => ListTags.fromJson(Map<String, dynamic>.from(e)))
                    .cast<ListTags>()
                    .toList();
                print("#filters");
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: tagList?.length,
                    itemBuilder: (context, index) {
                      return _getRadioButton(
                          tagList?[index].name ?? '', '${tagList?[index].name}',
                          (value) {
                        setState(() {
                          UserSession.annoncmentTags = value;
                        });
                      });
                    });
              },
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: AppButton(
                onTap: () {
                  UserSession.annoncmentTags = _radioValue1;
                  Navigator.pop(context);
                },
                title: Strings.of(context)?.saveChanges,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: AppButton(
                onTap: () {
                  UserSession.annoncmentTags = "";
                  Navigator.pop(context);
                },
                title: "Clear",
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getRadioButton(String title, String value, Function onChange) {
    return InkWell(
      onTap: () {
        setState(() {
          _radioValue1 = value;
        });
      },
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        new Text(
          title.trim(),
          style: Styles.textBold(size: 16, color: ColorConstants.PRIMARY_COLOR),
        ),
        Spacer(),
        Radio(
          activeColor: ColorConstants.PRIMARY_COLOR,
          value: value,
          groupValue: _radioValue1,
          onChanged: (value) {
            onChange(value);
          },
        ),
      ]),
    );
  }

  void _handleResponse(ContentTagsState state) {
    var loginState = state;
    //setState(() {
    switch (loginState.apiState) {
      case ApiStatus.LOADING:
        Log.v("Loading....................");
        _isLoading = true;
        break;
      case ApiStatus.SUCCESS:
        Log.v("Success....................");
        _isLoading = false;
        tagList = state.response?.data?.listTags;
        break;
      case ApiStatus.ERROR:
        _isLoading = false;
        Log.v("Error..........................${loginState.error}");
        break;
      case ApiStatus.INITIAL:
        // TODO: Handle this case.
        break;
    }
    //});
  }

  void getTagList() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(ContentTagsEvent(
        categoryType: getCategoryValue(ApiConstants.ANNOUNCEMENT_TYPE)));
  }

  int? getCategoryValue(String type) {
    if (UserSession.categoryData == null) return 0;
    int? contentType = 0;
    CategoryResp? respone =
        CategoryResp.fromJson(json.decode(UserSession.categoryData!));

    for (var element in respone.data!.listData!) {
      if (element.title!.toLowerCase().contains(type.toLowerCase())) {
        contentType = element.id;
        break;
      }
    }
    return contentType;
  }
}
