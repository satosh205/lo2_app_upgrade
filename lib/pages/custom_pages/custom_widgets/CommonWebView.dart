// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:masterg/utils/Log.dart';

import '../ScreenWithLoader.dart';
import 'CommonAppBar.dart';

class CommonWebView extends StatefulWidget {
  final String? url;
  bool _isLoading = false;
  bool isLandScape, isLocal, fullScreen;

  CommonWebView(
      {this.url,
      Key? key,
      this.isLandScape = true,
      this.isLocal = false,
      this.fullScreen = false})
      : super(key: key);

  @override
  _CommonWebViewState createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView> {
  InAppWebViewController? _webViewController;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    Log.v("url: ${widget.url}");
    super.initState();
    if (widget.isLandScape)
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    if (widget.fullScreen) SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(
              context, DateTime.now().toLocal().millisecondsSinceEpoch);
          return true;
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: CommonAppBar.getAppBar(
              bgColor: Colors.transparent,
              backColor: Colors.black,
              context: context,
              onBackPress: () {
                Navigator.pop(
                    context, DateTime.now().toLocal().millisecondsSinceEpoch);
              }),
          body: ScreenWithLoader(
            isLoading: widget._isLoading,
            body: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(widget.url!)),
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                cacheEnabled: true,
                userAgent: "Chrome/90.0.4430.51",
                useOnLoadResource: true,
                mediaPlaybackRequiresUserGesture: false,
                // debuggingEnabled: true,
              )),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              onLoadStart: (InAppWebViewController controller, Uri? url) async {
                if (url.toString().contains('order-received')) {
                  await Future.delayed(Duration(seconds: 5))
                      .then((value) => Navigator.pop(context, true));
                }
                setState(() {
                  this.url = url.toString();
                });
              },
              onLoadStop: (InAppWebViewController controller, Uri? url) async {
                setState(() {
                  this.url = url.toString();
                });
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                  Log.v(progress);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
