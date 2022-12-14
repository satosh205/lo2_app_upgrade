import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/create_post_response.dart';
import 'package:masterg/data/models/response/home_response/gcarvaan_post_reponse.dart';
import 'package:masterg/pages/gcarvaan/components/gcarvaan_card_post.dart';
import 'package:masterg/pages/gcarvaan/createpost/create_gcarvaan_page.dart';
import 'package:masterg/pages/gcarvaan/createpost/create_post_provider.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../utils/Strings.dart';
import '../../../utils/constant.dart';

class GCarvaanPostPage extends StatefulWidget {
  List<MultipartFile>? fileToUpload;
  String? desc;
  List<String?>? filesPath;
  bool? formCreatePost;
  bool fromDashboard;

  GCarvaanPostPage(
      {Key? key,
      this.fileToUpload,
      this.desc,
      this.filesPath,
      this.formCreatePost,
      this.fromDashboard = false})
      : super(key: key);

  @override
  _GCarvaanPostPageState createState() => _GCarvaanPostPageState();
}

bool visible = false;
bool isGCarvaanPostLoading = true;

class _GCarvaanPostPageState extends State<GCarvaanPostPage> {
  // Download download = new Download();
  Box? box;
  List<GCarvaanPostElement>? gcarvaanPosts;
  //List<GCarvaanPostElement> showList = [];
  bool isPostedLoading = false;
  CreatePostResponse? responseData;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int callCount = 0;

  @override
  void initState() {
    super.initState();

    gcarvaanPosts = [];
    if (widget.formCreatePost!) {
      createPost();
    } else {
      _getPosts(++callCount);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getPosts(callCount, {postId}) {
    box = Hive.box(DB.CONTENT);
    if (widget.formCreatePost == false && callCount == 1) {
      try {
        gcarvaanPosts = box!
            .get("gcarvaan_post")
            .map((e) =>
                GCarvaanPostElement.fromJson(Map<String, dynamic>.from(e)))
            .cast<GCarvaanPostElement>()
            .toList();

        Future.delayed(Duration(milliseconds: 50)).then((value) {
          _refreshController.requestRefresh();
        });
      } catch (e) {
        print('Something went wrong while fetching data form hive: $e');
      }
    }
    BlocProvider.of<HomeBloc>(context)
        .add(GCarvaanPostEvent(callCount: callCount, postId: postId));
  }

  void createPost() {
    if (widget.fileToUpload != null) {
      setState(() {
        isPostedLoading = true;
      });

      BlocProvider.of<HomeBloc>(context).add(CreatePostEvent(
          files: widget.fileToUpload,
          contentType: 2,
          title: '',
          description: widget.desc,
          postType: 'caravan',
          filePath: widget.filesPath));

      widget.fileToUpload = null;
      widget.desc = null;
      widget.filesPath = null;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<GCarvaanListModel>(
            create: (context) => GCarvaanListModel(gcarvaanPosts),
          ),
          ChangeNotifierProvider<CreatePostProvider>(
            create: (context) => CreatePostProvider([]),
          ),
        ],
        child: Scaffold(
            backgroundColor: widget.fromDashboard == true
                ? ColorConstants.WHITE
                : ColorConstants.SECTION_DIVIDER,
            body: SmartRefresher(
              // physics: BouncingScrollPhysics(),
              enablePullDown: !widget.fromDashboard,
              enablePullUp: !widget.fromDashboard,
              controller: _refreshController,
              onRefresh: () async {
                callCount = 0;
                gcarvaanPosts = [];
                widget.formCreatePost = true;
                _getPosts(++callCount);
                Future.delayed(Duration(seconds: 2)).then((_) {
                  setState(() {
                    isPostedLoading = false;
                  });
                });
              },
              onLoading: () async {
                _getPosts(++callCount);
              },
              footer: CustomFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                builder: (context, mode) {
                  if (mode == LoadStatus.loading) {
                    return Container(
                      color: Colors.white,
                      height: 60.0,
                      child: Container(
                        height: 20.0,
                        width: 20.0,
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  } else
                    return Container(
                      color: Colors.white,
                    );
                },
              ),
              header: CustomHeader(
                // height: MediaQuery.of(context).size.height * 0.1,
                builder: (context, mode) {
                  return Container(
                    height: 20.0,
                    width: 20.0,
                    padding: EdgeInsets.only(left: 10.0, bottom: 10),
                    child: CupertinoActivityIndicator(
                      radius: 10,
                    ),
                  );
                },
              ),
              child: Consumer<GCarvaanListModel>(
                builder: (context, carvaanListModel, child) => BlocManager(
                  initState: (context) {},
                  child: BlocListener<HomeBloc, HomeState>(
                    listener: (context, state) async {
                      if (state is GCarvaanPostState) {
                        _handleGCarvaanPostResponse(state, carvaanListModel);
                      }
                      if (state is CreatePostState) {
                        _handleCreatePostResponse(
                          state,
                        );
                      }
                    },
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (isPostedLoading ||
                                isGCarvaanPostLoading &&
                                    widget.fileToUpload != null)
                              Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 16.0,
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.blue[800]!,
                                          highlightColor: Colors.blue[200]!,
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 8),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 16, top: 8),
                            //   child: Text(
                            //     'Top MasterG',
                            //     style: Styles.regular(
                            //         size: 14, color: ColorConstants.GREY_2),
                            //   ),
                            // ),
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 80,
                            //   child: GCarvaanUserViewPage(),
                            // ),

                            if (!widget.fromDashboard)
                              Consumer<CreatePostProvider>(
                                builder: (context, value, child) => Container(
                                  color: ColorConstants.WHITE,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                      left: 10.0,
                                      top: 10.0,
                                      right: 10.0,
                                      bottom: 10.0),
                                  // height: 80,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => SharePost(
                                              //               isReelsPost: false,
                                              //               fileToUpload: [],
                                              //               filesPath: value.files,
                                              //             )));

                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateGCarvaanPage(
                                                        isReelsPost: false,
                                                        fileToUpload: [],
                                                        filesPath: value.files,
                                                        provider: value,
                                                      ))).then((value) =>
                                              _refreshController
                                                  .requestRefresh());
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 15,
                                          ),
                                          margin: EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                              color:
                                                  ColorConstants.TEXT_FIELD_BG,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Text(
                                              '${Strings.of(context)?.writeAPost}',
                                              style: Styles.regular(
                                                  color: ColorConstants.GREY_4,
                                                  size: 14)),
                                        ),
                                      ),
                                      //SizedBox(height: 10),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              _initFilePiker(value, false);
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/image.svg',
                                                  color: ColorConstants()
                                                      .primaryColor(),
                                                  allowDrawingOutsideViewBox:
                                                      true,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                    '${Strings.of(context)?.photo}',
                                                    style: Styles.regular(
                                                        size: 14))
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 20.0),
                                          InkWell(
                                            onTap: () async {
                                              _initFilePiker(value, true);
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/video.svg',
                                                  color: ColorConstants()
                                                      .primaryColor(),
                                                  allowDrawingOutsideViewBox:
                                                      true,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                    '${Strings.of(context)?.video}',
                                                    style: Styles.regular(
                                                        size: 14))
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            Container(
                              margin: widget.fromDashboard == true
                                  ? null
                                  : const EdgeInsets.only(
                                      top: 3,
                                    ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              width: double.infinity,
                              color: widget.fromDashboard
                                  ? ColorConstants.WHITE
                                  : ColorConstants.SECTION_DIVIDER,
                              child: Container(
                                child: _postListWidget(
                                    carvaanListModel.list, carvaanListModel),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }

  void _initFilePiker(CreatePostProvider provider, isVideo) async {
    FilePickerResult? result;
    if (await Permission.storage.request().isGranted) {
      if (Platform.isIOS) {
        result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: isVideo ? FileType.video : FileType.image,
            allowedExtensions: []);
      } else {
        result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.custom,
            allowedExtensions: isVideo ? ['mp4'] : ['jpg', 'png', 'jpeg']);
      }

      if (result != null) {
        for (int i = 0; i < result.paths.length; i++) {
          if (i == 4) break;
          if (File(result.paths[i]!).lengthSync() / 1000000 > 8.0) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${Strings.of(context)?.imageVideoSizeLarge}'),
            ));
          } else {
            provider.addToList(result.paths[i]);
          }
        }

        if (provider.files!.length > 4) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${Strings.of(context)?.only4ImagesVideosAllowed}'),
          ));
        }

        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateGCarvaanPage(
                        isReelsPost: false,
                        fileToUpload: [],
                        filesPath: provider.files,
                        provider: provider)))
            .then((value) => _refreshController.requestRefresh());
      }
    }
  }

  // Future<String> _getImages(CreatePostProvider provider) async {
  //   final picker = ImagePicker();
  //   final pickedFileC = await ImagePicker().pickImage(
  //       source: ImageSource.camera,
  //       imageQuality: 25,
  //       maxWidth: 900,
  //       maxHeight: 450);
  //   if (pickedFileC != null) {
  //     //return pickedFile.path;
  //     provider.addToList(pickedFileC.path);
  //   } else if (Platform.isAndroid) {
  //     final LostData response = await picker.getLostData();
  //     if (response.file != null) {
  //       return response.file.path;
  //     }
  //   }
  //   return null;
  // }

  Widget _postListWidget(gcarvaanPosts, GCarvaanListModel value) {
    if (value.list?.length == 0 && isGCarvaanPostLoading == false)
      return Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
          child:
              Center(child: Text('${Strings.of(context)?.noPostAvailable}')));

    // if (widget.fromDashboard == true && gcarvaanPosts.length != 0 ||
    //     value.list?.length != 0)
    //   return GCarvaanCardPost(
    //     index: 0,
    //     value: value,
    //     userStatus: gcarvaanPosts[0].userStatus,
    //     image_path: gcarvaanPosts[0].resourcePath,
    //     date: gcarvaanPosts[0].createdAt.toString(),
    //     description: gcarvaanPosts[0].description,
    //     commentCount: gcarvaanPosts[0].commentCount ?? 0,
    //     user_name: gcarvaanPosts[0].name,
    //     profile_path: gcarvaanPosts[0].profileImage,
    //     likeCount: gcarvaanPosts[0].likeCount ?? 0,
    //     viewCount: gcarvaanPosts[0].viewCount ?? 0,
    //     islikedPost: gcarvaanPosts[0].userLiked == 1 ? true : false,
    //     contentId: gcarvaanPosts[0].id,
    //     fileList: gcarvaanPosts[0].multiFileUploads,
    //     comment_visible: false,
    //     height: gcarvaanPosts[0].dimension.height,
    //     dimension: gcarvaanPosts[0].multiFileUploadsDimension,
    //     width: gcarvaanPosts[0].dimension.width,
    //     resourceType: gcarvaanPosts[0].resourceType,
    //     userID: gcarvaanPosts[0].userId,
    //   );
    // else
    return gcarvaanPosts.length != 0 || value.list?.length != 0
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: gcarvaanPosts == null
                ? 0
                : widget.fromDashboard == true
                    ? 1
                    : gcarvaanPosts.length,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return gcarvaanPosts != null &&
                      gcarvaanPosts[index].resourcePath != null
                  ? GCarvaanCardPost(
                      index: index,
                      value: value,
                      userStatus: gcarvaanPosts[index].userStatus,
                      image_path: gcarvaanPosts[index].resourcePath,
                      date: gcarvaanPosts[index].createdAt.toString(),
                      description: gcarvaanPosts[index].description,
                      commentCount: gcarvaanPosts[index].commentCount ?? 0,
                      user_name: gcarvaanPosts[index].name,
                      profile_path: gcarvaanPosts[index].profileImage,
                      likeCount: gcarvaanPosts[index].likeCount ?? 0,
                      viewCount: gcarvaanPosts[index].viewCount ?? 0,
                      islikedPost:
                          gcarvaanPosts[index].userLiked == 1 ? true : false,
                      contentId: gcarvaanPosts[index].id,
                      fileList: gcarvaanPosts[index].multiFileUploads,
                      comment_visible: false,
                      height: gcarvaanPosts[index].dimension.height,
                      dimension: gcarvaanPosts[index].multiFileUploadsDimension,
                      width: gcarvaanPosts[index].dimension.width,
                      resourceType: gcarvaanPosts[index].resourceType,
                      userID: gcarvaanPosts[index].userId,
                    )
                  : Container();
            })
        : _emptyPostListWidget();

    //TODO: OLd Code
    /*return box != null ? ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (bc, Box box, child) {
              if (box.get("gcarvaan_post") == null) {
                */
    /*return Shimmer.fromColors(
                  baseColor: Color(0xffe6e4e6),
                  highlightColor: Color(0xffeaf0f3),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                  ),
                );*/

    /*return GCarvaanCardBlankPost();
              } else if (box.get("gcarvaan_post").isEmpty &&
                  gcarvaanPosts == null) {
                return Container(
                  height: 290,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "No Post Available",
                      style: Styles.textBold(),
                    ),
                  ),
                );
              }
              // List<GCarvaanPostElement> temp = [];

              if (gcarvaanPosts == null || gcarvaanPosts.length == 0) {
                gcarvaanPosts = box
                    .get("gcarvaan_post")
                    .map((e) => GCarvaanPostElement.fromJson(
                        Map<String, dynamic>.from(e)))
                    .cast<GCarvaanPostElement>()
                    .toList();
              }

              //remove duplicate from gcarvaan
              List<GCarvaanPostElement> temp = [];
              for (var i = 0; i < gcarvaanPosts.length; i++) {
                if (temp.contains(gcarvaanPosts[i])) {
                  gcarvaanPosts.remove(gcarvaanPosts[i]);
                } else {
                  temp.add(gcarvaanPosts[i]);
                }
              }
              gcarvaanPosts = [];
              gcarvaanPosts.addAll(temp);

              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  //itemCount: gcarvaanPosts.length

                  itemCount: gcarvaanPosts == null ? 0 : gcarvaanPosts.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return gcarvaanPosts != null &&
                            gcarvaanPosts[index].resourcePath != null
                        ? GCarvaanCardPost(
                            image_path: gcarvaanPosts[index].resourcePath,
                            date: gcarvaanPosts[index].createdAt.toString(),
                            description: gcarvaanPosts[index].description,
                            commentCount:
                                gcarvaanPosts[index].commentCount ?? 0,
                            user_name: gcarvaanPosts[index].name,
                            profile_path: gcarvaanPosts[index].profileImage,
                            likeCount: gcarvaanPosts[index].likeCount ?? 0,
                            viewCount: gcarvaanPosts[index].viewCount ?? 0,
                            islikedPost: gcarvaanPosts[index].userLiked == 1
                                ? true
                                : false,
                            contentId: gcarvaanPosts[index].id,
                            fileList: gcarvaanPosts[index].multiFileUploads,
                            comment_visible: false,
                          )
                        : Container();
                  });
            },
          )
        : Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
            ),
          );*/
  }

  Widget _emptyPostListWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: Center(
                child: ClipOval(
                    child: Shimmer.fromColors(
                  baseColor: Color(0xffe6e4e6),
                  highlightColor: Color(0xffeaf0f3),
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 2),
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      )),
                )),
              )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Color(0xffe6e4e6),
                        highlightColor: Color(0xffeaf0f3),
                        child: Container(
                            height: 13,
                            margin: EdgeInsets.only(left: 2),
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 5.0),
                      child: Shimmer.fromColors(
                        baseColor: Color(0xffe6e4e6),
                        highlightColor: Color(0xffeaf0f3),
                        child: Container(
                            height: 12,
                            margin: EdgeInsets.only(left: 2),
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(bottom: 7, left: 4, top: 5.0, right: 20.0),
          child: Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
                height: 13,
                margin: EdgeInsets.only(left: 2),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                )),
          ),
        ),
        Container(
          height: 330,
          child: Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
                height: 330,
                margin: EdgeInsets.only(left: 2),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0.0, top: 7.0),
          child: Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
                height: 13,
                margin: EdgeInsets.only(left: 0),
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                )),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: Center(
                child: ClipOval(
                    child: Shimmer.fromColors(
                  baseColor: Color(0xffe6e4e6),
                  highlightColor: Color(0xffeaf0f3),
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 2),
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      )),
                )),
              )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Color(0xffe6e4e6),
                        highlightColor: Color(0xffeaf0f3),
                        child: Container(
                            height: 13,
                            margin: EdgeInsets.only(left: 2),
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 5.0),
                      child: Shimmer.fromColors(
                        baseColor: Color(0xffe6e4e6),
                        highlightColor: Color(0xffeaf0f3),
                        child: Container(
                            height: 12,
                            margin: EdgeInsets.only(left: 2),
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(bottom: 7, left: 4, top: 5.0, right: 20.0),
          child: Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
                height: 13,
                margin: EdgeInsets.only(left: 2),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                )),
          ),
        ),
        Container(
          height: 330,
          child: Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
                height: 330,
                margin: EdgeInsets.only(left: 2),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0.0, top: 7.0),
          child: Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
                height: 13,
                margin: EdgeInsets.only(left: 0),
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                )),
          ),
        ),
      ],
    );
  }

  void _handleGCarvaanPostResponse(
      GCarvaanPostState state, GCarvaanListModel model) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");

//  gcarvaanPosts = box
//                     !.get("gcarvaan_post")
//                     .map((e) => GCarvaanPostElement.fromJson(
//                         Map<String, dynamic>.from(e)))
//                     .cast<GCarvaanPostElement>()
//                     .toList();

          isGCarvaanPostLoading = true;

          break;
        case ApiStatus.SUCCESS:
          isPostedLoading = false;
          isGCarvaanPostLoading = false;

          //gcarvaanPosts = state.response.data.list;
          //if (state.response.data.list.length == 1) {

          //adding for removing duplicate post
          // if (gcarvaanPosts?.first.id != state.response!.data!.list?.first.id) {
          //   gcarvaanPosts!.addAll(state.response!.data!.list!);
          // } else {
          //   gcarvaanPosts = [];
          //   gcarvaanPosts!.addAll(state.response!.data!.list!);
          // }

          gcarvaanPosts!.addAll(state.response!.data!.list!);

          var seen = Set<GCarvaanPostElement>();
          List<GCarvaanPostElement> uniquelist =
              gcarvaanPosts!.where((element) => seen.add(element)).toList();

          gcarvaanPosts = uniquelist;
          if (model.list?.length == 0 ||
              model.list!.isEmpty ||
              model.list?.first.id != gcarvaanPosts?.first.id)
            model.refreshList(gcarvaanPosts!);
          _refreshController.refreshCompleted();
          _refreshController.loadComplete();
          break;
        case ApiStatus.ERROR:
          isGCarvaanPostLoading = false;

          Log.v(
            "Error..........................",
          );
          Log.v("ErrorHome..........................${loginState.error}");
          _refreshController.refreshFailed();
          _refreshController.loadFailed();

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
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
            isPostedLoading = true;
            // callCount = 1;
            // //_getPosts(callCount, postId: state.response.data.id);
            // _getPosts(callCount);
            _refreshController.requestRefresh();
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
    getFile();
  }

  Future<Uint8List?> getFile() async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: widget.path!,
      imageFormat: ImageFormat.PNG,
      timeMs: Duration(seconds: 1).inMilliseconds,
    );
    if (this.mounted)
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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          )
        : Text('loading image');
  }
}
