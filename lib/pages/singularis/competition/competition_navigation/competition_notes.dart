import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CompetitionNotes extends StatefulWidget {
  final int? id;
  final notesUrl;
  const CompetitionNotes({Key? key, this.notesUrl, this.id}) : super(key: key);

  @override
  State<CompetitionNotes> createState() => _CompetitionNotesState();
}

class _CompetitionNotesState extends State<CompetitionNotes> {
  void _updateCourseCompletion(bookmark) async {
    //change bookmark with 25
    print("bookmarkTimer make api ${bookmark}");
    BlocProvider.of<HomeBloc>(context).add(
        UpdateVideoCompletionEvent(bookmark: bookmark, contentId: widget.id));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(
                context,
              ),
              icon: Icon(
                Icons.arrow_back_ios,
                color: ColorConstants.BLACK,
              ),
            ),
            backgroundColor: ColorConstants.WHITE),
        body: Container(
          width: width(context),
          height: height(context),
          child: PDF(
            //swipeHorizontal: true,
            onPageChanged: ((page, total) {
              int pageno = page! + 1;
              print('total page $total and current page $page');
              _updateCourseCompletion(pageno);
            }),
            enableSwipe: true,
            gestureRecognizers: [
              Factory(() => PanGestureRecognizer()),
              Factory(() => VerticalDragGestureRecognizer())
            ].toSet(),
          ).cachedFromUrl(
            widget.notesUrl,
            placeholder: (progress) => Center(child: Text('$progress %')),
            errorWidget: (error) => Center(child: Text(error.toString())),
          ),
        ));
  }
}
