import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/home_response/create_post_response.dart';
import 'package:masterg/data/models/response/home_response/gcarvaan_post_reponse.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/gcarvaan/createpost/create_post_provider.dart';
import 'package:masterg/pages/gcarvaan/createpost/pdf_view.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as Thumbnail;
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import '../../../utils/click_picker.dart';
import '../../user_profile_page/mobile_ui_helper.dart';

List<String?>? croppedList;
String? thumnailUrl;

class CreateGCarvaanPage extends StatefulWidget {
  // final File postDocPath;
  final List<MultipartFile>? fileToUpload;
  List<String?>? filesPath;
  final bool isReelsPost;
  final CreatePostProvider? provider;

  CreateGCarvaanPage(
      {Key? key,
      this.fileToUpload,
      this.filesPath,
      this.isReelsPost = false,
      this.provider})
      : super(key: key);

  @override
  _CreateGCarvaanPageState createState() => _CreateGCarvaanPageState();
}

class _CreateGCarvaanPageState extends State<CreateGCarvaanPage> {
  //late FlickManager flickManager;
  bool isPostedLoading = false;
  CreatePostResponse? responseData;
  TextEditingController postDescriptionController = TextEditingController();
  List<GCarvaanPostElement>? gcarvaanPosts;

  @override
  void initState() {
    print('create post now');
    super.initState();
  }

  @override
  void dispose() {
    //flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CreatePostProvider>(
            create: (context) => CreatePostProvider(widget.filesPath, false),
          ),
          ChangeNotifierProvider<MenuListProvider>(
            create: (context) => MenuListProvider([]),
          ),
          ChangeNotifierProvider<GCarvaanListModel>(
            create: (context) => GCarvaanListModel(gcarvaanPosts),
          ),
        ],
        child: WillPopScope(
            // ignore: missing_return
            onWillPop: () async {
              widget.provider?.clearList();
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                    onPressed: () {
                      widget.provider?.clearList();
                      Navigator.pop(context);
                      //Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, color: ColorConstants.BLACK)),
                title: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${Strings.of(context)?.createPost} ',
                    style: Styles.bold(size: 14, color: ColorConstants.BLACK),
                  )
                ]),
                centerTitle: true,
              ),
              body: Consumer2<CreatePostProvider, GCarvaanListModel>(
                builder: (context, value, gcarvaanListModel, child) =>
                    BlocManager(
                        initState: (BuildContext context) {
                          //createPost();
                        },
                        child: BlocListener<HomeBloc, HomeState>(
                          listener: (context, state) {
                            if (state is CreatePostState)
                              _handleCreatePostResponse(state, value);
                          },
                          child: ScreenWithLoader(
                              isLoading: isPostedLoading,
                              body: _content(value)),
                        )),
              ),
            )));
  }

  Widget _content(CreatePostProvider value) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 4),
        height: size.height,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: [
                    /*Center(
                        child: Container(
                      margin: EdgeInsets.only(
                          top: size.height * 0.01, bottom: size.height * 0.02),
                      height: size.height * 0.01,
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorConstants.GREY,
                      ),
                    )),*/
                    //Text('${Strings.of(context)?.create} Post', style: Styles.textExtraBold()),
                    //text field with grey background height
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.02),
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      height: size.height * 0.2,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorConstants.GREY,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: postDescriptionController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                '${Strings.of(context)?.WriteYourPost} ....',
                            hintStyle: Styles.regular(
                                size: 14, color: ColorConstants.GREY_3),
                            helperMaxLines: 4),
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),
                    if (!widget.isReelsPost)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              _initFilePiker(value);
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/image.svg',
                                  color: ColorConstants().primaryColor(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                      '${Strings.of(context)?.photo}/${Strings.of(context)?.video}',
                                      style: Styles.regular(
                                          size: 14,
                                          color: ColorConstants.BLACK)),
                                ),
                              ],
                            ),
                          ),
                          /*InkWell(
                                    onTap: () async {
                                      await _getImages(value);
                                    },
                                    child: SvgPicture.asset(
                                        'assets/images/camera_y.svg'),
                                  ),*/

                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              final cameras = await availableCameras();
                              final firstCamera = cameras.first;

                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TakePictureScreen(
                                          camera: firstCamera))).then(
                                  (files) async {
                                if (files != null) {
                                  value.addToList(files);
                                  croppedList = value.files?.toList();
                                }
                              });
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/camera_y.svg',
                                  color: ColorConstants().primaryColor(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text('${Strings.of(context)?.camera}',
                                      style: Styles.regular(
                                          size: 14,
                                          color: ColorConstants.BLACK)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    value.files != null
                        // ? Text('file path ${value.files.length}')
                        ? ShowReadyToPost(
                            provider: value,
                          )
                        // : widget.postDocPath != null
                        //     ? Padding(
                        //         padding: const EdgeInsets.only(top: 8.0),
                        //         child: ClipRRect(
                        //           borderRadius: BorderRadius.circular(10),
                        //           child: Image.file(
                        //             widget.postDocPath,
                        //             height: 280,
                        //             fit: BoxFit.cover,
                        //           ),
                        //         ),
                        //       )
                        : SizedBox(),

                    // ClipRRect(
                    // borderRadius: BorderRadius.circular(10),
                    //   child: Container(
                    //       child: widget.postDocPath != null
                    //           ? widget.postDocPath.path.contains('.pdf')
                    //               ? PDFScreen(path: widget.postDocPath.path)
                    //               : widget.postDocPath.path.contains('.mp4')
                    //                   ? FlickVideoPlayer(
                    //                       flickManager: flickManager)
                    //                   : Image.file(
                    //                       widget.postDocPath,
                    //                       height: 280,
                    //                       fit: BoxFit.cover,
                    //                     )
                    //           : SizedBox()),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Consumer<MenuListProvider>(
              builder: (context, menuProvider, child) => Positioned(
                    bottom: 0,
                    child: Container(
                      width: size.width,
                      height: size.height * 0.09,
                      decoration: BoxDecoration(
                        color: ColorConstants.WHITE,
                      ),
                      child: InkWell(
                        onTap: () {
                          widget.provider?.updateList(croppedList);
                          if (value.files!.length != 0) {
                            String? firstExtension = value.files?.first
                                ?.split('/')
                                .last
                                .split('.')
                                .last
                                .toString();
                            bool isVideo = true;
                            if (firstExtension == 'mp4' ||
                                firstExtension == 'mov') isVideo = true;
                                print('$thumnailUrl');
                            createPost(menuProvider, isVideo,
                               thumnailUrl);
                            // value.postStatus(true);
                            // Navigator.pop(context);
                          } else {
                            AlertsWidget.showCustomDialog(
                                context: context,
                                title: '',
                                text: "Please upload file",
                                icon: 'assets/images/circle_alert_fill.svg',
                                showCancel: false,
                                oKText: "Ok",
                                onOkClick: () async {
                                  // Navigator.pop(context);
                                });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                              vertical: size.width * 0.03),
                          decoration: BoxDecoration(
                            color: ColorConstants().buttonColor(),
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              ColorConstants.GRADIENT_ORANGE,
                              ColorConstants.GRADIENT_RED,
                            ]),
                          ),
                          child: Center(
                            child: Text('${Strings.of(context)?.Share} ',
                                style: Styles.regular(
                                    size: 16,
                                    color: ColorConstants()
                                        .primaryForgroundColor())),
                          ),
                        ),
                      ),
                    ),
                  ))
        ]),
      ),
    );
  }

  void createPost(MenuListProvider provider, bool isVideo, String? thumbnail) {
    setState(() {
      isPostedLoading = true;
      widget.filesPath = widget.provider?.getFiles();
    });

    if (!widget.isReelsPost) {
      BlocProvider.of<HomeBloc>(context).add(CreatePostEvent(
          //contentType:isVideo == true ? 2  :1 ,
          contentType: isVideo == true ? 2 : 1,
          title: '',
          description: '${postDescriptionController.value.text}',
          postType: 'caravan',
          filePath: widget.filesPath));
    } else {
      print('create reel ${widget.filesPath?.first}');
      BlocProvider.of<HomeBloc>(context).add(CreatePostEvent(
          thumbnail: thumbnail,
          contentType: 2,
          title: '',
          description: postDescriptionController.value.text,
          postType: 'reels',
          filePath: widget.filesPath));
    }
  }

  void _handleCreatePostResponse(
      CreatePostState state, CreatePostProvider provider) {
    var loginState = state;
    setState(() async {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isPostedLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success.................... create post");
          isPostedLoading = false;
          responseData = state.response;
          widget.provider?.clearList();

          if (responseData!.status == 1) {
            if (widget.isReelsPost == true) Navigator.pop(context);
            Navigator.pop(context);
          }
          //  provider.postStatus(false);
          break;
        case ApiStatus.ERROR:
          isPostedLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");
          //  provider.postStatus(false);
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  Future<String?> _getImages(CreatePostProvider provider) async {
    final pickedFileC = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 900, maxHeight: 450);
    if (pickedFileC != null) {
      provider.addToList(pickedFileC.path);
      croppedList = provider.files?.toList();
    }
    return null;
  }

  void _initFilePiker(CreatePostProvider provider) async {
    FilePickerResult? result;
    //if (await Permission.storage.request().isGranted) {
    if (Platform.isIOS) {
      result = await FilePicker.platform.pickFiles(
          allowMultiple: true, type: FileType.media, allowedExtensions: []);
    } else {
      result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          onFileLoading: (path) {
            print('File $path is loading');
          },
          allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4']);
    }

    if (result != null) {
      for (int i = 0; i < result.paths.length; i++) {
        if (i == 4) break;
        if (File(result.paths[i]!).lengthSync() / 1000000 > 100.0) {
          print('THE SIZE IS ${File(result.paths[i]!).lengthSync() / 1000000}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${Strings.of(context)?.imageVideoSizeLarge} 100 MB'),
          ));
        } else
          provider.addToList(result.paths[i]);

        croppedList = provider.files?.toList();
      }

      if (provider.files!.length > 4) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Only 4 images/videos are allowed"),
        ));
      }
    }
    //}
  }
}

class ShowReadyToPost extends StatefulWidget {
  final CreatePostProvider? provider;
  const ShowReadyToPost({Key? key, this.provider}) : super(key: key);

  @override
  _ShowReadyToPostState createState() => _ShowReadyToPostState();
}

class _ShowReadyToPostState extends State<ShowReadyToPost> {
  List<PlatformUiSettings>? buildUiSettings(BuildContext context) {
    return [
      AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: ColorConstants().primaryColor(),
          toolbarWidgetColor: Colors.white,
          hideBottomControls: !Platform.isAndroid,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: '',
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    setValue();
  }

  void setValue() {
    List<String?>? readyToPost;
    readyToPost = widget.provider!.files;
    croppedList = readyToPost?.toList();
  }

  Future<String> _cropImage(_pickedFile) async {
    if (_pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: buildUiSettings(context),
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (croppedFile != null) {
        return croppedFile.path;
      }
    }
    return _pickedFile;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: croppedList!.length,
          itemBuilder: (context, index) {
            File pickedFile = File(croppedList![index]!);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Stack(children: [
                  Container(
                    // height: MediaQuery.of(context).size.height * 0.1,
                    color: ColorConstants.GREY,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: pickedFile != null
                        ? pickedFile.path.contains('.pdf')
                            ? InkWell(child: PDFScreen(path: pickedFile.path))
                            : pickedFile.path.contains('.mp4') ||
                                    pickedFile.path.contains('.mov') ||
                                    pickedFile.path.contains('.hevc') ||
                                    pickedFile.path.contains('.h.265')
                                ? ShowImage(path: pickedFile.path)
                                : Image.file(
                                    pickedFile,
                                    height: 240,
                                    fit: BoxFit.contain,
                                  )
                        : SizedBox(),
                  ),
                  if (pickedFile.path.contains('.mp4') ||
                      pickedFile.path.contains('.mov') ||
                      pickedFile.path.contains('.hevc') ||
                      pickedFile.path.contains('.h.265'))
                    Positioned.fill(
                        child: Align(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/images/play_video_icon.svg',
                              height: 50,
                              width: 50,
                              allowDrawingOutsideViewBox: true,
                            ))),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: ColorConstants.BLACK, shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: () {
                          AlertsWidget.showCustomDialog(
                              context: context,
                              title: "${Strings.of(context)?.deletePost}!",
                              text: "${Strings.of(context)?.areYouSureDelete}",
                              icon: 'assets/images/circle_alert_fill.svg',
                              onOkClick: () async {
                                widget.provider!.removeFromList(index);

                                setState(() {
                                  croppedList = widget.provider?.files;
                                });
                              });
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.delete_forever,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  if (!(pickedFile.path.contains('.mp4') ||
                      pickedFile.path.contains('.mov') ||
                      pickedFile.path.contains('.hevc') ||
                      pickedFile.path.contains('.h.265')))
                    Positioned(
                      left: 5,
                      top: 5,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorConstants.BLACK,
                            shape: BoxShape.circle),
                        child: IconButton(
                          onPressed: () {
                            AlertsWidget.showCustomDialog(
                                context: context,
                                title: "",
                                text: "Are you sure you want to Crop.",
                                icon: 'assets/images/circle_alert_fill.svg',
                                onOkClick: () async {
                                  String croppedPath = await _cropImage(
                                      widget.provider!.files?[index]);
                                  if (widget.provider!.files?[index] !=
                                      croppedPath)
                                    setState(() {
                                      croppedList![index] = croppedPath;
                                    });
                                });
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Icon(Icons.crop, size: 15, color: Colors.white),
                        ),
                      ),
                    ),
                ]),
              ),
            );
          }),
    );
  }
}

class ShowImage extends StatelessWidget {
  final String? path;
  ShowImage({Key? key, this.path}) : super(key: key);

  Uint8List? imageFile;
  Future<File> writeToFile(Uint8List data) async {
    final directory = await getTemporaryDirectory(); // get cache directory
    final file = File(
        '${directory.path}/example.jpg'); // create new file in cache directory
    await file.writeAsBytes(data); // write the data to the file
    return file; // return the file
  }

  Future<Uint8List?> getFile() async {
    final uint8list = await Thumbnail.VideoThumbnail.thumbnailData(
      video: path!,
      imageFormat: Thumbnail.ImageFormat.PNG,
      quality: 10,
    );
    File file = await writeToFile(uint8list!);
    thumnailUrl = file.path;

    return uint8list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: getFile(), // async work
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          );
        }

        return Shimmer.fromColors(
          baseColor: Color(0xffe6e4e6),
          highlightColor: Color(0xffeaf0f3),
          child: Container(
              height: 400,
              margin: EdgeInsets.only(left: 2),
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
              )),
        );
      },
    );
  }
}
