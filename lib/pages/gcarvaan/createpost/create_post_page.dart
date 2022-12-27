import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterg/pages/gcarvaan/createpost/pdf_view.dart';
import 'package:masterg/pages/gcarvaan/createpost/share_post.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

VideoPlayerController? _controller;

class CreatePostPage extends StatefulWidget {
  final bool isReelsPage;

  const CreatePostPage({Key? key, this.isReelsPage = false}) : super(key: key);
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  List<MultipartFile> listFiles = [];
  List<String> localFiles = [];
  File? pickedFile;
  File? imageFile;
  List<File> pickedList = [];
  List<File?> readyToPost = [];
  bool isMultiSelectEnabled = false;
  Box? box;
  File? selectedFile;
  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 10;
  String? _tempDir;
  String? filePath;

  @override
  void initState() {
    super.initState();
    // getTemporaryDirectory().then((d) => _tempDir = d.path);
    // getLocalData();
  }

  @override
  void dispose() {
    // flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.WHITE,
        // automaticallyImplyLeading: widget.isReelsPage ? true : false,
        elevation: 0,
        title: Text(
          widget.isReelsPage ? 'New Reels' : 'New Post',
          style: Styles.bold(size: 14, color: ColorConstants.BLACK),
        ),

        centerTitle: true,
        actions: [
          if (pickedFile != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () async {
                    print('Click On Next');
                    if (pickedFile != null) {
                      // Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => SharePost(
                                  // postDocPath: pickedFile,
                                  fileToUpload: listFiles,
                                  isReelsPost: widget.isReelsPage,
                                  filesPath: readyToPost
                                      .map((e) => e!.path)
                                      .toList())));
                    }
                  },
                  child: Text(
                    'Next',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _makeBody(),
    );
  }

  Widget _makeBody() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: pickedFile != null
              ? pickedFile!.path.contains('.pdf')
                  ? PDFScreen(path: pickedFile!.path)
                  : pickedFile!.path.contains('.mp4')
                      ? filePath != null
                          ? Image.file(
                              File(filePath!),
                              height: 350,
                              fit: BoxFit.cover,
                            )
                          : ShowImage(
                              path: pickedList[0]
                                  .path) //No Floatting Button Click
                      /*PlayVideo(
                          videoPath: pickedFile.path,
                        )*/
                      : pickedFile!.path.contains('doc') ||
                              pickedFile!.path.contains('docx')
                          ? Column(children: [
                              Image.asset(
                                'assets/images/docx.png',
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                              Text('${pickedFile!.path.split('/').last}',
                                  style: Styles.textRegular()),
                            ])
                          : Image.file(
                              pickedFile!,
                              height: 350,
                              fit: BoxFit.cover,
                            )
              : SizedBox(
                  child: Center(
                      child: Text(
                  'Image / Video No Found\nChoose to View',
                  style: Styles.textRegular(),
                  textAlign: TextAlign.center,
                ))),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          color: ColorConstants.WHITE,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    _initFilePiker();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/create_post_icon.svg',
                        color: ColorConstants.BLACK,
                        height: 28,
                        width: 28,
                        allowDrawingOutsideViewBox: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0, left: 10.0),
                        child: Text(
                          '${Strings.of(context)?.Gallery}',
                          style: Styles.semibold(
                              size: 14, color: ColorConstants.BLACK),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!widget.isReelsPage)
                  InkWell(
                    onTap: () async {
                      _getImages();

                      // if (widget.isReelsPage)
                      //   _getVideo();
                      // else
                      //   _getImages();
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/camera_icon.svg',
                          height: 20,
                          width: 20,
                          color: ColorConstants().primaryColor(),
                          allowDrawingOutsideViewBox: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0, left: 10),
                          child: Text(
                            '${Strings.of(context)?.camera}',
                            style: Styles.semibold(
                                size: 14, color: ColorConstants.BLACK),
                          ),
                        ),
                      ],
                    ),
                  )
              ]),
        ),
        if (pickedList != null)
          Expanded(
            child: Container(
              color: ColorConstants.WHITE,
              child: showAllSelectedImages(pickedList, context),
            ),
          ),
      ],
    );
  }

  // Widget _content() {
  //   return Container(
  //     child: SingleChildScrollView(
  //       child: Container(
  //         color: ColorConstants.WHITE,
  //         child: Column(
  //           children: [
  //             Container(
  //               width: MediaQuery.of(context).size.width,
  //               height: 50.0,
  //               color: ColorConstants.WHITE,
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   IconButton(
  //                       onPressed: () async {
  //                         await _initFilePiker();
  //                         setState(() {});
  //                       },
  //                       icon: Icon(
  //                         Icons.add_photo_alternate_outlined,
  //                         color: ColorConstants.BLACK,
  //                       )),
  //                   Padding(
  //                     padding: const EdgeInsets.only(right: 15.0),
  //                     child: Text(
  //                       'Gallery',
  //                       style: TextStyle(color: ColorConstants.BLACK),
  //                     ),
  //                   ),
  //                   if (!widget.isReelsPage)
  //                     Row(
  //                       children: [
  //                         IconButton(
  //                             onPressed: () {
  //                               _initCamera();
  //                             },
  //                             icon: Icon(
  //                               Icons.camera_alt_outlined,
  //                               color: ColorConstants.BLACK,
  //                             )),
  //                         Padding(
  //                           padding: const EdgeInsets.only(right: 10.0),
  //                           child: Text(
  //                             'Camera',
  //                             style: TextStyle(color: ColorConstants.BLACK),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                 ],
  //               ),
  //             ),
  //             if (pickedList != null)
  //               Container(
  //                   height: MediaQuery.of(context).size.height,
  //                   child: showAllSelectedImages(pickedList, context)),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Future<Uint8List?> getFile(path) async {
    final uint8list = VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth:
          128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    return uint8list;
  }

  Widget showAllSelectedImages(pickedList, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: GridView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: pickedList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 3 / 4,
            crossAxisCount: 4,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onLongPress: () {
                setState(() {
                  isMultiSelectEnabled = !isMultiSelectEnabled;
                  if (!readyToPost.contains(pickedList[index])) {
                    readyToPost.add(pickedList[index]);
                    pickedFile = pickedList[index];
                  }
                });
              },
              onTap: () async {
                if (isMultiSelectEnabled) {
                  if (readyToPost.contains(pickedList[index])) {
                    if (readyToPost.length != 1) {
                      readyToPost.remove(pickedList[index]);
                      pickedFile = readyToPost[readyToPost.length - 1];
                    }
                  } else {
                    readyToPost.add(pickedList[index]);
                    pickedFile = pickedList[index];
                  }
                } else {
                  readyToPost.clear();
                  selectedFile = pickedList[index];
                  readyToPost.add(pickedList[index]);
                  pickedFile = pickedList[index];

                  //New Code
                  if (selectedFile!.path.toString().contains('mp4')) {
                    final thumbnail = await VideoThumbnail.thumbnailFile(
                        video: selectedFile!.path.toString(),
                        thumbnailPath: _tempDir,
                        imageFormat: _format,
                        quality: _quality);
                    setState(() {
                      final file = File(thumbnail!);
                      filePath = file.path;
                    });
                  }
                }

                if (pickedFile!.path.contains('doc') ||
                    pickedFile!.path.contains('docx')) {
                  OpenFile.open('$pickedFile');
                }
                if (pickedFile!.path.contains('pdf')) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext dialogContext) {
                      Future.delayed(
                        Duration(seconds: 2),
                      );
                      // holding this dialog context

                      return AlertDialog(
                        contentPadding: EdgeInsets.all(2),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${pickedFile!.path.split('/').last}'),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.cancel),
                            ),
                          ],
                        ),
                        content: PDFScreen(
                          path: pickedFile!.path,
                        ),
                      );
                    },
                  );
                }

                setState(() {});
              },
              child: Transform.scale(
                scale: 1,
                child: ColorFiltered(
                  colorFilter: readyToPost.contains(pickedList[index]) == true
                      ? ColorFilter.mode(ColorConstants.BLACK.withOpacity(0.7),
                          BlendMode.dstATop)
                      : ColorFilter.mode(
                          Colors.black.withOpacity(1), BlendMode.dstATop),
                  child: Stack(
                    children: [
                      pickedList[index].path.contains('.mp4')
                          ? ShowImage(path: pickedList[index].path)
                          : pickedList[index].path.contains('.pdf')
                              ? Container(
                                  color: ColorConstants.WHITE,
                                  child: Stack(children: [
                                    Image.asset(
                                      'assets/images/pdf.png',
                                      fit: BoxFit.contain,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                    ),
                                    Text(
                                      '${pickedList[index].path.split('/').last}',
                                      style: Styles.textRegular(
                                        size: 12,
                                      ),
                                    )
                                  ]),
                                )
                              : pickedList[index].path.contains('.doc') ||
                                      pickedList[index].path.contains('.docx')
                                  ? Container(
                                      color: ColorConstants.WHITE,
                                      child: Image.asset(
                                        'assets/images/docx.png',
                                        fit: BoxFit.contain,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                      ),
                                    )
                                  : Image.file(
                                      pickedList[index],
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                    ),
                      if (isMultiSelectEnabled)
                        Positioned(
                            top: 8,
                            left: 8,
                            child:
                                readyToPost.contains(pickedList[index]) == true
                                    ? SvgPicture.asset(
                                        'assets/images/selected_icon.svg',
                                        height: 18,
                                        width: 18,
                                        allowDrawingOutsideViewBox: true,
                                      )
                                    : Icon(CupertinoIcons.circle,
                                        size: 20, color: ColorConstants.WHITE))
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  String getFileName(String _path) {
    return path.basename(_path);
  }

  //void _initFilePiker({type = null}) async {
  void _initFilePiker() async {
    FilePickerResult? result;
    if (await Permission.storage.request().isGranted) {
      if (Platform.isIOS) {
        result = await FilePicker.platform.pickFiles(
            allowMultiple: widget.isReelsPage == true ? false : true,
            type: widget.isReelsPage == true ? FileType.video : FileType.media,
            allowedExtensions: widget.isReelsPage == true ? [] : []);
      } else {
        result = await FilePicker.platform.pickFiles(
            allowMultiple: widget.isReelsPage == true ? false : true,
            type:
                widget.isReelsPage == true ? FileType.custom : FileType.custom,
            allowedExtensions: widget.isReelsPage == true
                ? ['mp4']
                : ['jpg', 'jpeg', 'png', 'mp4']);
      }

      if (result != null) {
        if (widget.isReelsPage) {
          for (int i = 0; i < result.paths.length; i++) {
            //pickedList.add(File(result.paths[i]));
            if (result.paths[i]!.contains('.mp4')) {
              //insert showing wrong image
              // pickedList.insert(0, File(result.paths[i]));
              //if (File(result.paths[i]!).lengthSync() / 1000000 > 5.0) {
              if (File(result.paths[i]!).lengthSync() / 1000000 > 50.0) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('${Strings.of(context)?.imageVideoSizeLarge} 50MB'),
                ));
              } else
                pickedList.add(File(result.paths[i]!));
            } else {
              Utility.showSnackBar(
                  scaffoldContext: context,
                  message: '${Strings.of(context)?.only4ImagesVideosAllowed}');
            }
          }
        } else {
          for (int i = 0; i < result.paths.length; i++) {
            //pickedList.add(File(result.paths[i]));
            pickedList.insert(0, File(result.paths[i]!));
          }
        }
        readyToPost = [];
        readyToPost.add(pickedList.first);
        pickedFile = pickedList.first;

        // setLocalData();

        if (result.paths.toString().contains('mp4')) {
          final thumbnail = await VideoThumbnail.thumbnailFile(
              video: result.paths[0].toString(),
              thumbnailPath: _tempDir,
              imageFormat: _format,
              quality: _quality);
          setState(() {
            final file = File(thumbnail!);
            filePath = file.path;
          });
        }
      }
    }
  }

  Future<String?> _getImages() async {
    final picker = ImagePicker();
    final pickedFileC = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxWidth: 900,
        maxHeight: 450);
    if (pickedFileC != null) {
      setState(() {
        pickedList.insert(0, File(pickedFileC.path));
        readyToPost = [];
        readyToPost.add(pickedList.first);
        pickedFile = pickedList.first;
      });
    } else if (Platform.isAndroid) {
      final LostData response = await picker.getLostData();
      if (response.file != null) {
        return response.file!.path;
      }
    }
    return null;
  }
}

class ShowImage extends StatefulWidget {
  final String? path;
  ShowImage({Key? key, this.path}) : super(key: key);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  Uint8List? imageFile;
  @override
  void initState() {
    super.initState();

    print('============widget.path');
    print(widget.path);
    getFile();
  }

  Future<Uint8List?> getFile() async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: widget.path!,
      imageFormat: ImageFormat.PNG,
    );
    setState(() {
      imageFile = uint8list;
    });
    return uint8list;
  }

  @override
  Widget build(BuildContext context) {
    return imageFile != null
        ? Image.memory(
            imageFile!,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
          )
        : Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Center(child: Text('Loading Image')));
  }
}

class PlayVideo extends StatefulWidget {
  final videoPath;
  PlayVideo({Key? key, this.videoPath}) : super(key: key);

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  String? path;
  @override
  void initState() {
    super.initState();
    // makeDelay();
    _controller = VideoPlayerController.network(widget.videoPath);
    _controller!.addListener(() {});
    _controller!.setLooping(false);
    _controller!.initialize().then((_) => setState(() {}));
    _controller!.play();
    setState(() {});
  }

  // void makeDelay() async {
  //   path = '';
  //   await Future.delayed(Duration(seconds: 3));
  //   path = widget.videoPath;
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null
        ? FlickVideoPlayer(
            flickVideoWithControls: FlickVideoWithControls(
              videoFit: BoxFit.cover,
            ),
            flickManager: FlickManager(
                // autoPlay: false,
                videoPlayerController: _controller!))
        : Container(
            child: Text('Loading video'),
          );
  }
}

//  Widget showSelectedImages(selectedFiles) {
//     return GridView.builder(
//       itemCount: selectedFiles.length,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 4, crossAxisSpacing: 2.0, mainAxisSpacing: 0.0),
//       itemBuilder: (BuildContext context, int index) {
//         return GestureDetector(
//             onTap: () {
//               setState(() {
//                 print(index);
//                 imageFile = selectedFiles[index];
//               });
//             },
//             child: Stack(
//               children: [
//                 Image.file(
//                   selectedFiles[index],
//                   height: 200,
//                   fit: BoxFit.cover,
//                 ),
//               ],
//             ));
//       },
//     );
//   }
