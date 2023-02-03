import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/pages/gcarvaan/createpost/create_gcarvaan_page.dart';
import 'package:masterg/pages/gcarvaan/createpost/create_post_provider.dart';
import 'package:masterg/pages/reels/trim_video/trimmer_view.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoRecordingCameraPage extends StatefulWidget {
  final CreatePostProvider? provider;
  const VideoRecordingCameraPage({Key? key,  this.provider})
      : super(key: key);

  @override
  _VideoRecordingCameraPageState createState() =>
      _VideoRecordingCameraPageState();
}

class _VideoRecordingCameraPageState extends State<VideoRecordingCameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;
  bool isFront = false;
  bool flashOn = false;
  late Timer timer;
  int secondsRemaining = 15;

  @override
  void initState() {
    _initCamera(isFront);
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    removeTimer();
    super.dispose();
  }

  void removeTimer() {
    setState(() {
      timer.cancel();
    });
  }

  _initCamera(bool isfront) async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere((camera) => isfront
        ? camera.lensDirection == CameraLensDirection.front
        : camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      //setState(() => _isRecording = false);
      setState(() {
        _isRecording = false;
      });

      timer.cancel();
      widget.provider?.addToList(file.path);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateGCarvaanPage(
                    isReelsPost: true,
                    fileToUpload: [],
                    filesPath: widget.provider?.files,
                    provider: widget.provider,
                  )));
    } else {
      await _cameraController.prepareForVideoRecording();
      secondsRemaining = 15;
      await _cameraController.startVideoRecording();
      timer = Timer.periodic(Duration(seconds: 1), (_) async {
        if (secondsRemaining != 0) {
          setState(() {
            secondsRemaining--;
          });
        } else {
          setState(() {
            timer.cancel();
            _isRecording = false;
            secondsRemaining = 0;
          });
          final file = await _cameraController.stopVideoRecording();

          widget.provider?.addToList(file.path);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateGCarvaanPage(
                        isReelsPost: true,
                        fileToUpload: [],
                        filesPath: widget.provider?.files,
                        provider: widget.provider,
                      )));
        }
      });
      setState(() => _isRecording = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        bottomSheet: Container(
          height: 70,
          width: MediaQuery.of(context).size.width,
          color: ColorConstants.BLACK,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
              onTap: () {
                widget.provider?.clearList();
                _initFilePiker(widget.provider!, true);
              },
              child: Stack(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: ColorConstants.WHITE,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorConstants.BG_BLUE_BTN,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.add, color: ColorConstants.WHITE),
                    ),
                  )
                ],
              ),
            ),
            Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstants.GREY_2,
                ),
                margin: const EdgeInsets.only(
                  right: 20,
                ),
                child: IconButton(
                    onPressed: () async {
                      setState(() {
                        isFront = !isFront;
                        _isLoading = true;
                      });
                      _initCamera(isFront);
                    },
                    icon: Icon(
                      Icons.flip_camera_android,
                      color: ColorConstants.WHITE,
                    ))),
          ]),
        ),
        body: Center(
          child: Listener(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CameraPreview(
                  _cameraController,
                  child: Stack(
                    // alignment: Alignment.topCenter,
                    children: [
                      /*ClipRRect(
                        borderRadius: BorderRadius.circular(1),
                        child: Container(
                          height: 6,
                          child: LinearProgressIndicator(
                            value: double.tryParse('0.'+progress),// percent filled
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                            backgroundColor: Color(0xFFFFDAB8),
                          ),
                        ),
                      ),*/
                      /*Container(
                        height: 6,
                        width: MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width *
                                (secondsRemaining / 15)),
                        decoration: BoxDecoration(
                            color: ColorConstants.ORANGE,
                            borderRadius: BorderRadius.circular(10)),
                      ),*/

                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              tooltip: 'Close Camera',
                              onPressed: () {
                                print('object');
                                Navigator.of(context).pop(false);
                              },
                            ),
                            if (_isRecording)
                              Text(
                                '${secondsRemaining}:00',
                                style: Styles.boldWhite(),
                              ),
                            IconButton(
                              icon: Icon(
                                flashOn == true
                                    ? Icons.flash_on_sharp
                                    : Icons.flash_off_rounded,
                                color: Colors.white,
                              ),
                              tooltip: 'Flash',
                              onPressed: () {
                                setState(() {
                                  if (flashOn) {
                                    _cameraController
                                        .setFlashMode(FlashMode.off);
                                    flashOn = false;
                                  } else {
                                    _cameraController
                                        .setFlashMode(FlashMode.torch);
                                    flashOn = true;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  //padding: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: FloatingActionButton(
                    backgroundColor: ColorConstants.WHITE,
                    child: _isRecording
                        ? SvgPicture.asset(
                            'assets/images/GReelsS.svg',
                            height: 40,
                            width: 40,
                            allowDrawingOutsideViewBox: true,
                          )
                        : SvgPicture.asset(
                            'assets/images/GReels.svg',
                            height: 40,
                            width: 40,
                            allowDrawingOutsideViewBox: true,
                          ),
                    // child: Icon(_isRecording ? Icons.stop : Icons.circle),
                    onPressed: () => _recordVideo(),
                  ),
                ),
              ],
            ),
          ),

          /*child: Listener(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CameraPreview(_cameraController,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white,),
                        tooltip: 'Close Camera',
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ],
                  ),),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: Icon(_isRecording ? Icons.stop : Icons.circle),
                    onPressed: () => _recordVideo(),
                  ),
                ),
              ],
            ),
          ),*/
        ),
      );
    }
  }

  Future<void> _initFilePiker(CreatePostProvider provider, isVideo) async {
    FilePickerResult? result;
    if (await Permission.storage.request().isGranted) {
      if (Platform.isIOS) {
        result = await FilePicker.platform.pickFiles(
            allowMultiple: false, type: FileType.video, allowedExtensions: []);
      } else {
        result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['mp4']);
      }

      if (result != null) {
        if (File(result.paths.first!).lengthSync() / 1000000 > 100.0) {
          print(
              'THE SIZE is ${File(result.paths.first!).lengthSync() / 1000000}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${Strings.of(context)?.imageVideoSizeLarge}  100MB"),
          ));
        } else if (result.paths.first!.contains('.mp4') ||
            result.paths.first!.contains('.mov')) {
          provider.addToList(result.paths.first);

          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return TrimmerView(File('${provider.files?.first}'),
                  provider: provider);
            }),
          );
          if (provider.files?.length != 0)
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateGCarvaanPage(
                          isReelsPost: true,
                          fileToUpload: [],
                          filesPath: provider.files,
                          provider: provider,
                        )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Only video file is allowed to upload."),
          ));
        }
      }
    }
  }
}
