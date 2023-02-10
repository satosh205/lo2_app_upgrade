import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/ghome/video_player_screen.dart';
import 'package:masterg/pages/user_profile_page/mobile_ui_helper.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UploadProfile extends StatefulWidget {
  final bool? editVideo;
  final bool? playVideo;
  const UploadProfile({Key? key, this.editVideo = true, this.playVideo = false})
      : super(key: key);

  @override
  State<UploadProfile> createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  String? selectedImage;
  File? pickedFile;
  List<File> pickedList = [];
  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 10;
  String? _tempDir;
  String? filePath;
  bool? profileLoading = false;
  late VideoPlayerController controller;

  @override
  void initState() {
    initVideo();
    super.initState();
  }

  void initVideo() async {
    if (widget.editVideo == true || widget.playVideo == true) {
      print('start video');
      // controller = VideoPlayerController.network('${Preference.getString(Preference.PROFILE_VIDEO)}')..addListener(() {
      //     setState(() {

      //     });
      //   });
        //   = controller!.initialize();
        //  controller?.play();

      controller = VideoPlayerController.network(
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
      controller.addListener(() {
        print('listining to ');
        setState(() {});
      });
      controller.setLooping(true);
      controller.initialize().then((_) => setState(() {}));
      controller.play();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text(
              widget.editVideo == true ? 'Profile Video' : 'Profile Picture')),
      body: ScreenWithLoader(
        isLoading: profileLoading,
        body: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is UploadProfileState) {
              handleUploadProfile(state);
            }
          },
          child: Column(
            children: [
              // Text('${Preference.getString(Preference.PROFILE_VIDEO)}'),
              if (widget.editVideo == true || widget.playVideo == true) ...[
                Preference.getString(Preference.PROFILE_VIDEO) != null &&
                        Preference.getString(Preference.PROFILE_VIDEO) != ""
                    ? SizedBox(
                        height: height(context) * 0.3,
                        width: width(context),
                        child: VideoPlayer(controller))
                    : SizedBox(),
                    Text('${Preference.getString(Preference.PROFILE_VIDEO)}'),
                Spacer(),
                if (widget.playVideo == false)
                  Container(
                    padding: EdgeInsets.zero,
                    color: ColorConstants.BLACK,
                    width: width(context),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        icon('Edit ', 'assets/images/edit.svg', () {}),
                        icon('Upload ', 'assets/images/camera.svg', () async {
                          _initFilePiker()?.then((value) async {
                            Map<String, dynamic> data = Map();
                            data['video'] = await MultipartFile.fromFile(
                                '${value?.path}',
                                filename: '${value?.path.split('/').last}');
                            BlocProvider.of<HomeBloc>(context)
                                .add(UploadProfileEvent(data: data));
                          });
                        }),
                        icon('Remove ', 'assets/images/delete.svg', () {}),
                      ],
                    ),
                  ),
              ] else ...[
                Preference.getString(Preference.PROFILE_IMAGE) != null
                    ? Expanded(
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  '${Preference.getString(Preference.PROFILE_IMAGE)}',
                              filterQuality: FilterQuality.low,
                              width: width(context),
                              height: height(context) * 0.8,
                              fit: BoxFit.cover,
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.zero,
                              color: ColorConstants.BLACK,
                              width: width(context),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  icon(
                                      'Edit ', 'assets/images/edit.svg', () {}),
                                  icon('Upload ', 'assets/images/camera.svg',
                                      () async {
                                    FilePickerResult? result;
                                    try {
                                      if (await Permission.storage
                                          .request()
                                          .isGranted) {
                                        if (Platform.isIOS) {
                                          result = await FilePicker.platform
                                              .pickFiles(
                                                  allowMultiple: false,
                                                  type: FileType.image,
                                                  allowedExtensions: []);
                                        } else {
                                          result = await FilePicker.platform
                                              .pickFiles(
                                                  allowMultiple: false,
                                                  type: FileType.custom,
                                                  allowedExtensions: [
                                                'jpg',
                                                'png',
                                                'jpeg'
                                              ]);
                                        }
                                      }
                                    } catch (e) {
                                      print('the expection is $e');
                                    }

                                    String? value = result?.paths.first;
                                    if (value != null) {
                                      selectedImage = value;
                                      selectedImage = await _cropImage(value);
                                    }
                                    Map<String, dynamic> data = Map();
                                    data['image'] =
                                        await MultipartFile.fromFile(
                                            '$selectedImage',
                                            filename: selectedImage);
                                    BlocProvider.of<HomeBloc>(context)
                                        .add(UploadProfileEvent(data: data));
                                  }),
                                  icon('Remove ', 'assets/images/delete.svg',
                                      () {}),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        color: ColorConstants.WHITE,
                        height: height(context) * 0.6,
                        width: width(context),
                      ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget icon(String title, String img, Function action) {
    return Expanded(
      child: InkWell(
        onTap: () {
          action();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                '$img',
                color: ColorConstants.WHITE,
              ),
              Text(
                '$title',
                style: Styles.regular(
                  color: ColorConstants.WHITE,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _cropImage(_pickedFile) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: buildUiSettings(context),
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (croppedFile != null) {
        return croppedFile.path;
      }
    }
    return "";
  }

  Future<File?>? _initFilePiker() async {
    FilePickerResult? result;
    if (await Permission.storage.request().isGranted) {
      if (Platform.isIOS) {
        result = await FilePicker.platform.pickFiles(
            allowMultiple: false, type: FileType.video, allowedExtensions: []);
      } else {
        result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.video,
          //allowedExtensions: ['mp4']
        );
      }

      if (result != null) {
        if (File(result.paths[0]!).lengthSync() / 1000000 > 50.0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${Strings.of(context)?.imageVideoSizeLarge} 50MB'),
          ));
        } else {
          pickedList.add(File(result.paths[0]!));
        }
        pickedFile = pickedList.first;
        print('pickedFile ==== ${pickedFile}');

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
    return pickedFile;
  }

  void handleUploadProfile(UploadProfileState state) {
    var portfolioState = state;
    setState(() async {
      switch (portfolioState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Upload Profile Loading....................");
          profileLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Upload Profile Success....................");

          profileLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Profile Updated'),
          ));
          Navigator.pop(context);

          break;

        case ApiStatus.ERROR:
          profileLoading = false;
          Log.v("Upload Profile Error..........................");
          Log.v(
              "Upload Profile Error..........................${portfolioState.error}");

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}
