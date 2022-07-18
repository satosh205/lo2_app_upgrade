import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/home_response/create_post_response.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/gcarvaan/createpost/create_post_page.dart';
import 'package:masterg/pages/gcarvaan/createpost/pdf_view.dart';
import 'package:masterg/pages/ghome/home_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class SharePost extends StatefulWidget {
  final File? postDocPath;
  final List<MultipartFile>? fileToUpload;
  final List<String>? filesPath;
  final bool isReelsPost;

  const SharePost(
      {Key? key,
      this.postDocPath,
      this.fileToUpload,
      this.filesPath,
      this.isReelsPost = false})
      : super(key: key);

  @override
  _SharePostState createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  late FlickManager flickManager;
  bool isPostedLoading = false;
  CreatePostResponse? responseData;
  TextEditingController postDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(widget.postDocPath!),
    );

    print('=====widget.isReelsPost======');
    print(widget.isReelsPost);
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 5,
            width: 48,
            decoration: BoxDecoration(
                color: ColorConstants.START_GREY_BG,
                borderRadius: BorderRadius.circular(8)),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${Strings.of(context)?.CreatePost} ',
            style: Styles.bold(size: 14, color: ColorConstants.BLACK),
          )
        ]),
        centerTitle: true,
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<MenuListProvider>(
            create: (context) => MenuListProvider([]),
          ),
        ],
        child: BlocManager(
            initState: (BuildContext context) {
              //createPost();
            },
            child: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is CreatePostState) _handleCreatePostResponse(state);
              },
              child: ScreenWithLoader(
                  isLoading: isPostedLoading, body: _content()),
            )),
      ),
    );
  }

  Widget _content() {
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
                    //Text('Create Post', style: Styles.textExtraBold()),
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

                    SizedBox(height: size.height * 0.04),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.back, size: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text('${Strings.of(context)?.AddMore} ',
                                style: Styles.bold(
                                    size: 12, color: ColorConstants.BLACK)),
                          ),

                          Expanded(
                            child: SizedBox(),
                          ),
                          //Icon(CupertinoIcons.camera_circle)
                        ],
                      ),
                    ),

                    widget.filesPath != null
                        ? ShowReadyToPost(
                            readyToPost: widget.filesPath,
                          )
                        : widget.postDocPath != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    widget.postDocPath!,
                                    height: 280,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          Consumer<MenuListProvider>(
              builder: (context, value, child) => Positioned(
                    bottom: 0,
                    child: Container(
                      width: size.width,
                      height: size.height * 0.09,
                      decoration: BoxDecoration(
                        color: ColorConstants.WHITE,
                      ),
                      child: InkWell(
                        onTap: () {
                          createPost(value);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                              vertical: size.width * 0.03),
                          decoration: BoxDecoration(
                            color: ColorConstants().buttonColor(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text('${value.list?.length}',
                                style: Styles.regular(
                                    size: 21.12, color: ColorConstants.BLACK)),
                          ),
                        ),
                      ),
                    ),
                  ))
        ]),
      ),
    );
  }

  void createPost(MenuListProvider value) {
    if (!widget.isReelsPost) {
      Navigator.pushAndRemoveUntil(
          context,
          NextPageRoute(
              homePage(
                index: 4,
                fileToUpload: widget.fileToUpload,
                isReelsPost: widget.isReelsPost,
                desc: '${postDescriptionController.value.text}',
                filesPath: widget.filesPath,
                isFromCreatePost: true,
                bottomMenu: value.list,
              ),
              isMaintainState: true),
          (route) => false);
    } else {
      setState(() {
        isPostedLoading = true;
      });
      BlocProvider.of<HomeBloc>(context).add(CreatePostEvent(
          files: widget.fileToUpload,
          contentType: 1,
          title: '',
          description: postDescriptionController.value.text,
          postType: 'reels',
          filePath: widget.filesPath));
    }
  }

  void _handleCreatePostResponse(CreatePostState state) {
    var loginState = state;
    setState(() async {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isPostedLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          isPostedLoading = false;
          responseData = state.response;
          if (responseData!.status == 1) {
            Navigator.pushAndRemoveUntil(
                context,
                NextPageRoute(homePage(index: 3), isMaintainState: true),
                (route) => false);
          }

          break;
        case ApiStatus.ERROR:
          isPostedLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}

class ShowReadyToPost extends StatelessWidget {
  final List<String>? readyToPost;
  const ShowReadyToPost({Key? key, this.readyToPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: readyToPost!.length,
          itemBuilder: (context, index) {
            File pickedFile = File(readyToPost![index]);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Stack(children: [
                  Container(
                    // height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: pickedFile != null
                        ? pickedFile.path.contains('.pdf')
                            ? InkWell(child: PDFScreen(path: pickedFile.path))
                            : pickedFile.path.contains('.mp4')
                                ? ShowImage(path: pickedFile.path)
                                /*PlayVideo(
                                    videoPath: pickedFile.path,
                                   )*/
                                : Image.file(
                                    pickedFile,
                                    height: 350,
                                    fit: BoxFit.cover,
                                  )
                        : SizedBox(),
                  ),
                  Positioned(
                      left: 12,
                      top: 17,
                      child: SvgPicture.asset(
                        'assets/images/selected_icon.svg',
                        height: 22,
                        width: 22,
                        allowDrawingOutsideViewBox: true,
                      ))
                ]),
              ),
            );
          }),
    );
  }
}
