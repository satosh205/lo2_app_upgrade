import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadFileScreen extends StatefulWidget {
  final String fileUrl;

  DownloadFileScreen({required this.fileUrl});

  @override
  _DownloadFileScreenState createState() => _DownloadFileScreenState();
}

class _DownloadFileScreenState extends State<DownloadFileScreen> {
  bool downloading = false;
  String? progressString;
  String? filePath;

  Future<void> downloadFile() async {
    setState(() {
      downloading = true;
    });

    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/my_file.pdf';
    print('the path is $filePath');

    final response = await http.get(Uri.parse(widget.fileUrl));
    print('the path is downlaoded $filePath');

    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    setState(() {
      downloading = false;
      progressString = null;
      this.filePath = filePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download File'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (downloading) CircularProgressIndicator(),
            if (progressString != null) Text(progressString!),
            if (filePath != null)
              ElevatedButton(
                onPressed: () {
                  // Open the downloaded file using the default app
                  Platform.isAndroid
                      ? Process.run('am', ['start', '-a', 'android.intent.action.VIEW', '-d', filePath!])
                      : throw Exception('Platform not supported');
                },
                child: Text('Open File'),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: downloadFile,
        child: Icon(Icons.file_download),
      ),
    );
  }
}
