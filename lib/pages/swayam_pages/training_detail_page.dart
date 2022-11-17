// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/training_detail_response.dart';
// import 'package:masterg/data/providers/training_content_provider.dart';
// import 'package:masterg/data/providers/training_detail_provider.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/notification_list_page.dart';
import 'package:masterg/pages/swayam_pages/training_content_page.dart';
import 'package:masterg/pages/swayam_pages/training_content_provider.dart';
import 'package:masterg/pages/swayam_pages/training_detail_provider.dart';
import 'package:masterg/pages/swayam_pages/training_service.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/custom_progress_indicator.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/images.dart';
import 'package:masterg/utils/utility.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class TrainingDetailPage extends StatelessWidget {
  BuildContext? mContext;

  @override
  Widget build(BuildContext context) {
    mContext = context;
    final traininDetailProvider = Provider.of<TrainingDetailProvider>(context);
    return SafeArea(
        child: Scaffold(
      key: traininDetailProvider.scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.PRIMARY_COLOR,
      body: traininDetailProvider.modules!.isNotEmpty
          ? CommonContainer(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: _content(traininDetailProvider)),
              title: traininDetailProvider.program?.name,
              isBackShow: true,
              isNotification: true,
              onSkipClicked: () {
                Navigator.push(context, NextPageRoute(NotificationListPage()));
              },
              onBackPressed: () {
                Navigator.pop(context);
              },
            )
          : Center(
              child: CustomProgressIndicator(true, ColorConstants.GREY),
            ),
    ));
  }

  Widget trainingDetailWidget(TrainingDetailProvider traininDetailProvider) {
    Widget trainingDetailWidget;
    switch (traininDetailProvider.apiStatus) {
      case ApiStatus.INITIAL:
        trainingDetailWidget = Center(
          child: CustomProgressIndicator(true, ColorConstants.GREY),
        );
        break;
      case ApiStatus.LOADING:
        trainingDetailWidget =
            CustomProgressIndicator(true, ColorConstants.GREY);
        break;
      case ApiStatus.SUCCESS:
        trainingDetailWidget = _content(traininDetailProvider);
        break;
      case ApiStatus.ERROR:
        trainingDetailWidget = Center(
          child: Text('${traininDetailProvider.error}'),
        );
        break;
    }
    return trainingDetailWidget;
  }

  Widget _content(TrainingDetailProvider trainingDetailProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 8),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            '${Strings.of(mContext!)?.What_to_expect} ?',
            style: Styles.textBold(
                size: 18, color: ColorConstants.TEXT_DARK_BLACK),
          ),
          Text(
            '${trainingDetailProvider.description}',
            style: Styles.textSemiBold(size: 16, color: Color(0xff444444)),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Icon(Icons.timer),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                children: [
                  Text(
                    '${Strings.of(mContext!)?.Start_date} : ${Utility.convertDateFromMillis(int.parse('${trainingDetailProvider.program?.startDate}'), Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
                    style: Styles.textRegular(size: 12),
                  ),
                  Text(
                    '${Strings.of(mContext!)?.End_date} : ${Utility.convertDateFromMillis(int.parse('${trainingDetailProvider.program!.endDate}'), Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
                    style: Styles.textRegular(size: 12),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.5,
                        color: ColorConstants.PRIMARY_COLOR_DARK
                            .withOpacity(0.44)),
                    color: ColorConstants.PRIMARY_COLOR_DARK.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 5, bottom: 5),
                child: Text(
                  '${trainingDetailProvider.modules?.length}  ${Strings.of(mContext!)?.Modules_included}',
                  style: Styles.textLight(
                      size: 14, color: ColorConstants.PRIMARY_COLOR_DARK),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
               '${ Strings.of(mContext!)?.List_of_modules}',
                style: Styles.textExtraBold(
                    size: 18, color: ColorConstants.ORANGE),
              ),
            ],
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: trainingDetailProvider.modules?.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: _rowItem(
                      trainingDetailProvider.modules!.elementAt(index),
                      trainingDetailProvider, context),
                );
              }),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _rowItem(
      Modules module, TrainingDetailProvider trainingDetailProvider, context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              trainingDetailProvider.scaffoldKey.currentContext! ,
              NextPageRoute(
                  ChangeNotifierProvider<TrainingContentProvier>(
                      create: (context) => TrainingContentProvier(
                          TrainingService(ApiService()), module),
                      child: TrainingContentPage()),
                  isMaintainState: true));
          // FirebaseAnalytics()
          //     .logEvent(name: "training_module_opened", parameters: null);
          // FirebaseAnalytics()
          //     .setCurrentScreen(screenName: "training_module_screen");
        },
        child: Container(
          width:
              MediaQuery.of(trainingDetailProvider.scaffoldKey.currentContext!)
                      .size
                      .width -
                  40,
          decoration: BoxDecoration(
              color: ColorConstants.WHITE,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          padding: EdgeInsets.only(right: 14, top: 5, bottom: 5),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        '${module.image}',
                        height: 57.0,
                        width: 57.0,
                        errorBuilder: (context, url, error) {
                                return Image.asset(
                                   Images.PLACE_HOLDER,
                                                          height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                       
                                );
                              },
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(trainingDetailProvider
                                      .scaffoldKey.currentContext!)
                                  .size
                                  .width /
                              2,
                          child: Wrap(
                            children: [
                              Text(
                                '${module.name}',
                                style: Styles.textBold(size: 16),
                              )
                            ],
                          ),
                        ),
                        Text(
                          '${Strings.of(context)?.Start_date} : ${Utility.convertDateFromMillis(module.startDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
                          style: Styles.textSemiBold(size: 12),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      child: CircularPercentIndicator(
                        radius: 20,
                        lineWidth: 2.0,
                        percent: module.completion is int
                            ? (module.completion as int) / 100
                            : (module.completion as double) / 100,
                        backgroundColor: ColorConstants.GREY,
                        center: new Text(
                          "${module.completion is int ? module.completion as int : (module.completion as double).round()}%",
                          style: Styles.textExtraBold(
                              size: 12, color: ColorConstants.BLACK),
                        ),
                        progressColor: ColorConstants.ACTIVE_TAB,
                      ),
                    ),
                    Text(
                      '${Strings.of(mContext!)?.Completed}',
                      style: Styles.textRegular(
                        size: 10,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
