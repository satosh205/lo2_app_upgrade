import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:masterg/utils/constant.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CompetitionNotes extends StatefulWidget {
  final notesUrl;
  const CompetitionNotes({Key? key, this.notesUrl}) : super(key: key);

  @override
  State<CompetitionNotes> createState() => _CompetitionNotesState();
}

class _CompetitionNotesState extends State<CompetitionNotes> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      width: width(context),
      height: height(context),
      child: PDF(
                        //swipeHorizontal: true,
                        onPageChanged: ((page, total ) {
                          print('total page $total and current page $page');
                        }),
                        enableSwipe: true,
                        gestureRecognizers: [
                          Factory(() => PanGestureRecognizer()),
                          Factory(() => VerticalDragGestureRecognizer())
                        ].toSet(),
                      ).cachedFromUrl(
                        widget.notesUrl,
                        placeholder: (progress) =>
                            Center(child: Text('$progress %')),
                        errorWidget: (error) =>
                            Center(child: Text(error.toString())),
                      ),
    ));
  }
}