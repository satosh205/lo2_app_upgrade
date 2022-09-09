// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
// import 'package:masterg/blocs/dealer_bloc.dart';
import 'package:masterg/data/api/api_constants.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/content_tags_resp.dart';
// import 'package:masterg/data/models/response/dealer/content_tags_resp.dart';
import 'package:masterg/pages/custom_pages/app_button.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LibraryFilterPage extends StatefulWidget {
  LibraryFilterPage();

  @override
  _LibraryFilterPageState createState() => _LibraryFilterPageState();
}

class _LibraryFilterPageState extends State<LibraryFilterPage> {
  Box? box;
  String _radioValue1 = "";
  bool _isLoading = false;
  List<ListTags>? tagList ;

  @override
  void initState() {
    // FirebaseAnalytics().setCurrentScreen(screenName: "library_filters_screen");
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
              isLoading: _isLoading,
              title: Strings.of(context)?.library,
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
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${Strings.of(context)?.libraryFilters}',
                  style: Styles.textExtraBold(
                      size: 18, color: ColorConstants.TEXT_DARK_BLACK),
                ),
                Expanded(
                    child: ValueListenableBuilder(
                  valueListenable: box!.listenable(),
                  builder: (bc, Box box, child) {
                    if (box.get("libraryFilters") == null ||
                        box.get("libraryFilters").isEmpty) {
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
                        .get("libraryFilters")
                        .map((e) =>
                            ListTags.fromJson(Map<String, dynamic>.from(e)))
                        .cast<ListTags>()
                        .toList();
                    print("#filters");
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: tagList?.length,
                        itemBuilder: (context, index) {
                          return _getRadioButton(
                              '${tagList![index].name}', '${tagList![index].name}',
                              (value) {
                            setState(() {
                              UserSession.libraryTags = value;
                            });
                          });
                        });
                  },
                )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: AppButton(
                    onTap: () {
                      UserSession.libraryTags = _radioValue1;
                      Navigator.pop(context);
                    },
                    title: Strings.of(context)?.saveChanges,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: AppButton(
                    onTap: () {
                      UserSession.libraryTags = "";
                      Navigator.pop(context);
                    },
                    title: "Clear",
                  ),
                )
              ],
            ),
          ),
        ],
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
          title,
          style: Styles.textBold(size: 16, color: ColorConstants.PRIMARY_COLOR),
        ),
        Spacer(),
        Radio(
          activeColor: ColorConstants.PRIMARY_COLOR,
          value: value,
          groupValue: _radioValue1,
          onChanged: (value){
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
    // });
  }

  void getTagList() {
    box = Hive.box("content");
    BlocProvider.of<HomeBloc>(context).add(ContentTagsEvent(
        categoryType: Utility.getCategoryValue(ApiConstants.LIBRARY_TYPE)));
  }
}
