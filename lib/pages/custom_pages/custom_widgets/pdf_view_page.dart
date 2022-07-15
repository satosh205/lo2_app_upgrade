import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../../../utils/resource/colors.dart';

class PdfViewPage extends StatefulWidget {
  final String url;
  final bool callBack;
  PdfViewPage({required this.url, required this.callBack});

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late String url;

  @override
  void initState() {
    //_getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: widget.callBack == true
          ? AppBar(
              elevation: 0,
              backgroundColor: ColorConstants.WHITE,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
                color: ColorConstants.BLACK,
              ),
            )
          : null,
      body: Stack(
        children: [
          Positioned(
            right: 3.0,
            top: 40.0,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              child: Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ),
          _pageView(),
        ],
      ),
    );
  }

  /* void _getData() async {
    var res = await AuthProvider.notesRequestStatic(
        request: widget.contentId.toString(), url: ApiConstants.NOTES_DATA);
    print(res);
    _response = NotesResponse.fromJson(json.decode(res)).data;
    url = _response.content.fileDetails.first.fileUrl;
    print(ApiConstants.IMAGE_BASE_URL + url);
    // doc = await PDFDocument.fromURL(ApiConstants.IMAGE_BASE_URL+url,
    //  cacheManager: CacheManager(
    //       Config(
    //         "customCacheKey",
    //         stalePeriod: const Duration(days: 2),
    //         maxNrOfCacheObjects: 10,
    //       ),
    //     ),
    // );
    _isLoading = false;
    setState(() {});
  }*/

  Widget _pageView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Text("Test", style: Styles.boldBlack(size: 16),),
          //Text( "Test Demo", style: Styles.regularBlack(size: 15), overflow: TextOverflow.ellipsis,),
          _size(),
          _pageItem(),
        ],
      ),
    );
  }

  Widget _pageItem() {
    print('call Pdf view');
    print(widget.url);

    return Expanded(
        child: RotatedBox(
      quarterTurns: 1,
      child: PDF(
        //swipeHorizontal: true,
        enableSwipe: true,
        gestureRecognizers: [
          Factory(() => PanGestureRecognizer()),
          Factory(() => VerticalDragGestureRecognizer())
        ].toSet(),
      ).cachedFromUrl(
        //ApiConstants.IMAGE_BASE_URL + url,
        widget.url,
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),
    ));

    /*child:
        PDF(
          swipeHorizontal: false,
          enableSwipe: true,
          gestureRecognizers: [
            Factory(() => PanGestureRecognizer()),
            Factory(() => VerticalDragGestureRecognizer())
          ].toSet(),
        ).cachedFromUrl(
          //ApiConstants.IMAGE_BASE_URL + url,
          widget.url,
          placeholder: (progress) => Center(child: Text('$progress %')),
          errorWidget: (error) => Center(child: Text(error.toString())),
        ));*/
  }

  _size({double height = 10}) {
    return SizedBox(
      height: height,
    );
  }
}
