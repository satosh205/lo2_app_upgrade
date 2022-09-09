import 'package:flutter/material.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/training_module_response.dart';
import 'package:masterg/data/providers/notes_detail_provider.dart';
import 'package:masterg/pages/announecment_pages/full_video_page.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/CommonWebView.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/notification_list_page.dart';
import 'package:masterg/pages/swayam_pages/offline_video_player.dart';
// import 'package:masterg/pages/home_pages/notification_list_page.dart';
import 'package:masterg/pages/training_pages/youtube_player.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/custom_progress_indicator.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import 'offline_video_player.dart';

class NotesDetailsPage extends StatefulWidget {
  @override
  _NotesDetailsPageState createState() => _NotesDetailsPageState();
}

class _NotesDetailsPageState extends State<NotesDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final notesDetailProvider = Provider.of<NotesDetailProvider>(context);
    return SafeArea(
        child: Scaffold(
      key: notesDetailProvider.scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.PRIMARY_COLOR,
      body: CommonContainer(
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: notesWidget(notesDetailProvider)),
        title: 'Notes and Videos',
        // belowTitle: _titleSubContent(notesDetailProvider),
        isBackShow: true,
        isNotification: true,
        onSkipClicked: () {
          Navigator.push(context, NextPageRoute(NotificationListPage()));
        },
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
    ));
  }

  Widget notesWidget(NotesDetailProvider notesDetailProvider) {
    Widget trainingDetailWidget;
    switch (notesDetailProvider.apiStatus) {
      case ApiStatus.INITIAL:
        trainingDetailWidget = Center(
          child: CustomProgressIndicator(true, ColorConstants.WHITE),
        );
        break;
      case ApiStatus.LOADING:
        trainingDetailWidget =
            CustomProgressIndicator(true, ColorConstants.WHITE);
        break;
      case ApiStatus.SUCCESS:
        trainingDetailWidget = _getAnnounecment(notesDetailProvider);
        break;
      case ApiStatus.ERROR:
        trainingDetailWidget = Center(
          child: Text('${notesDetailProvider.error}'),
        );
        break;
    }
    return trainingDetailWidget;
  }

  _size({double height = 20}) {
    return SizedBox(
      height: height,
    );
  }

  _titleSubContent(NotesDetailProvider notesDetailProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Text(
                'Overview',
                style:
                    Styles.textExtraBold(size: 21, color: ColorConstants.WHITE),
              ),
            ],
          ),
          Text(
            'At the end of this unit, you will be able to: 1. Understand the Basics of storage area inspection in lab 2. ',
            style: Styles.semiBoldWhite(
              size: 16,
            ),
          ),
          _size(height: 10)
        ],
      ),
    );
  }

  _getAnnounecment(NotesDetailProvider notesDetailProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notes",
                style: Styles.textExtraBold(
                    size: 18, color: ColorConstants.ORANGE),
              ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  controller: new ScrollController(),
                  itemCount: notesDetailProvider.notes?.length,
                  itemBuilder: (context, index) {
                    return _rowItem(notesDetailProvider.notes!.elementAt(index));
                  })
            ],
          )
        ],
      ),
    );
  }

  _rowItem(LearningShots notes) {
    return InkWell(
      onTap: () {
        if (notes.contentType == "notes") {
          Navigator.push(
              context,
              NextPageRoute(FullContentPage(
                resourcePath: notes.url,
                contentType: "1",
              )));
        }
        if (notes.contentType == "video_yts") {
          Navigator.push(
              context,
              NextPageRoute(YouTubeVideoScreen(
                title: notes.title,
                url: notes.url,
              )));
        }
        if (notes.contentType == "video") {
          Navigator.push(
              context,
              NextPageRoute(OfflineVideoScreen(
                title: notes.title,
                url: notes.url,
                contentId: notes.programContentId,
              )));
        }
      },
      child: Card(
          margin: EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          color: ColorConstants.WHITE,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                    height: 40, width: 40, child: Image.network('${notes.image}')),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${notes.title}',
                        style: Styles.textBold(size: 16),
                      ),
                      Text(
                        'Course: ${notes.description}',
                        style: Styles.textSemiBold(
                            size: 12, color: ColorConstants.DAR_GREY),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
