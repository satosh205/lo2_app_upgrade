import 'package:flutter/material.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/providers/notes_detail_provider.dart';
// import 'package:masterg/data/providers/training_content_provider.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/notification_list_page.dart';
import 'package:masterg/pages/swayam_pages/notes_details_page.dart';
import 'package:masterg/pages/swayam_pages/training_content_provider.dart';
// import 'package:masterg/pages/home_pages/notification_list_page.dart';
import 'package:masterg/pages/training_pages/custom_dialog.dart';
// import 'package:masterg/pages/training_pages/notes_details_page.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/custom_progress_indicator.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/images.dart';
import 'package:provider/provider.dart';

class TrainingContentPage extends StatelessWidget {
  BuildContext? mContext;

  @override
  Widget build(BuildContext context) {
    print("REBUILT");
    mContext = context;
    final traininDetailProvider = Provider.of<TrainingContentProvier>(context);
    return SafeArea(
        child: Scaffold(
       key: traininDetailProvider.scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.PRIMARY_COLOR,
      body: traininDetailProvider.trainingModuleResponse != null
          ? CommonContainer(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: _content(traininDetailProvider)
                  // child: _content(traininDetailProvider)
                  ),
              title: traininDetailProvider.modules?.name,
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

  Widget trainingModuleWidget(TrainingContentProvier traininDetailProvider) {
    Widget trainingDetailWidget;
    switch (traininDetailProvider.apiStatus) {
      case ApiStatus.INITIAL:
        trainingDetailWidget = Center(
          child: CustomProgressIndicator(true, ColorConstants.GREY),
        );
        break;
      case ApiStatus.LOADING:
        trainingDetailWidget = Center(
          child: CustomProgressIndicator(true, ColorConstants.GREY),
        );
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

  Widget _content(TrainingContentProvier trainingDetailProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 8),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              '${Strings.of(mContext!)?.Content}',
              style:
                  Styles.textExtraBold(size: 18, color: ColorConstants.ORANGE),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: trainingDetailProvider.content?.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return moduleWidget(
                  trainingDetailProvider.content?.elementAt(index)['type'],
                  trainingDetailProvider);
            },
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget moduleWidget(
      String type, TrainingContentProvier trainingDetailProvider) {
    debugPrint('content type --- ${type}');
    String? title;
    String? subTitle;
    String? imagePath;
    switch (type) {
      case 'scorm':
        title = '${Strings.of(mContext!)?.Scorm}';
        subTitle =
            "${trainingDetailProvider.trainingModuleResponse?.data?.module?.elementAt(0).content?.scorm?.length} ${Strings.of(mContext!)?.Scorm}";
        imagePath = Images.SCORM;
        break;
      case 'sessions':
        title = '${Strings.of(mContext!)?.Live_sessions}';
        subTitle =
            "${trainingDetailProvider.trainingModuleResponse?.data?.module?.elementAt(0).content?.sessions?.length} sessions";
        imagePath = Images.LIVE_SESSIONS;
        break;
      case 'notes':
        // title = '${Strings.of(mContext!)?.Notes +" & "+Strings.of(mContext).Videos;
        title = '${Strings.of(mContext!)?.Notes} & ${Strings.of(mContext!)?.Videos}';
        subTitle =
            "${trainingDetailProvider.trainingModuleResponse?.data?.module?.elementAt(0).content?.learningShots?.length} note";
        imagePath = Images.NOTES;
        break;
      case 'assignments':
        title = '${Strings.of(mContext!)?.Assignment}';
        subTitle =
            "${trainingDetailProvider.trainingModuleResponse?.data?.module?.elementAt(0).content?.assignments?.length} assignment";
        imagePath = Images.ASSIGNMENT;
        break;
      case 'assessments':
        title = "Assessment";
        subTitle =
            "${trainingDetailProvider.trainingModuleResponse?.data?.module?.elementAt(0).content?.assessments?.length} assessments";
        imagePath = Images.ASSIGNMENT;
        break;
      case 'polls':
        title = "Polls";
        subTitle =
            "${trainingDetailProvider.trainingModuleResponse?.data?.module?.elementAt(0).content?.polls?.length} poll";
        imagePath = Images.SURVEY;
        break;
      case 'survey':
        title = '${Strings.of(mContext!)?.survey}';
        subTitle =
            "${trainingDetailProvider.trainingModuleResponse?.data?.module?.elementAt(0).content?.survey?.length} survey";
        imagePath = Images.SURVEY;
        break;
    }
    return InkWell(
      onTap: () {
        if (type == 'sessions') {
          if (trainingDetailProvider.trainingModuleResponse?.data?.module
                  ?.elementAt(0)
                  .content
                  ?.sessions?.isNotEmpty == true)
            showDialog(
                context: mContext!,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    type: 'Live Sessions',
                    data: trainingDetailProvider
                        .trainingModuleResponse?.data?.module
                        ?.elementAt(0)
                        .content,
                    imagePath: imagePath,
                  );
                });
        } else if (type == 'polls') {
          if (trainingDetailProvider.trainingModuleResponse?.data?.module
                  ?.elementAt(0)
                  .content
                  ?.assessments
                 ?.isNotEmpty == true)
            showDialog(
                context: mContext!,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    type: 'Polls',
                    data: trainingDetailProvider
                        .trainingModuleResponse?.data?.module
                        ?.elementAt(0)
                        .content,
                    imagePath: imagePath,
                  );
                });
        } else if (type == 'assignments') {
          if (trainingDetailProvider.trainingModuleResponse?.data?.module
                  ?.elementAt(0)
                  .content
                  ?.assignments
                  ?.isNotEmpty == true)
            showDialog(
                context: mContext!,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    type: 'Assignment',
                    data: trainingDetailProvider
                        .trainingModuleResponse?.data?.module
                        ?.elementAt(0)
                        .content,
                    imagePath: imagePath,
                  );
                });
        } else if (type == 'notes') {
          if (trainingDetailProvider.trainingModuleResponse?.data?.module
                  ?.elementAt(0)
                  .content
                  ?.learningShots
                 ?.isNotEmpty == true)
            Navigator.push(
                mContext!,
                NextPageRoute(
                    ChangeNotifierProvider<NotesDetailProvider>(
                        create: (context) => NotesDetailProvider(
                            TrainingService(ApiService()),
                            trainingDetailProvider
                                .trainingModuleResponse?.data?.module
                                ?.elementAt(0)
                                .content
                                ?.learningShots),
                        child: NotesDetailsPage()),
                    isMaintainState: true));
        } else if (type == 'scorm') {
          if (trainingDetailProvider.trainingModuleResponse?.data?.module
                  ?.elementAt(0)
                  .content
                  ?.scorm
                  ?.isNotEmpty == true)
            showDialog(
                context: mContext!,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    type: 'Scorm',
                    data: trainingDetailProvider
                        .trainingModuleResponse?.data?.module
                        ?.elementAt(0)
                        .content,
                    imagePath: imagePath,
                  );
                });
        } else if (type == 'survey') {
          if (trainingDetailProvider.trainingModuleResponse?.data?.module
                  ?.elementAt(0)
                  .content
                  ?.survey
                 ?.isNotEmpty == true)
            showDialog(
                context: mContext!,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    type: 'Survey',
                    data: trainingDetailProvider
                        .trainingModuleResponse?.data?.module
                        ?.elementAt(0)
                        .content,
                    imagePath: imagePath,
                  );
                });
        } else if (type == 'assessments') {
          if (trainingDetailProvider.trainingModuleResponse?.data?.module
                  ?.elementAt(0)
                  .content
                  ?.assessments
                ?.isNotEmpty == true)
            showDialog(
                context: mContext! ,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    type: 'Assessments',
                    data: trainingDetailProvider
                        .trainingModuleResponse?.data?.module
                        ?.elementAt(0)
                        .content,
                    imagePath: imagePath,
                  );
                });
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset('$imagePath'),
              Text(
                '$title',
                style: Styles.textBold(
                    size: 16, color: ColorConstants.TEXT_DARK_BLACK),
              ),
              Text(
                '$subTitle',
                style: Styles.textRegular(size: 10, color: Color(0xff444444)),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
