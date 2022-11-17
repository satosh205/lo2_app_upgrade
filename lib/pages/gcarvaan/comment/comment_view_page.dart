import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/gcarvaan_post_reponse.dart';
import 'package:masterg/data/models/response/home_response/get_comment_response.dart';
import 'package:masterg/data/models/response/home_response/post_comment_response.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/gcarvaan/comment/comment_box.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/images.dart';

class CommentViewPage extends StatefulWidget {
  final postId;
  final GCarvaanListModel? value;

  const CommentViewPage({Key? key, this.postId, this.value}) : super(key: key);
  @override
  _CommentViewPageState createState() => _CommentViewPageState();
}

class _CommentViewPageState extends State<CommentViewPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List<CommentListElement>? commentsList = [];
  PostCommentResponse? postCommentResponse;
  bool _isLoading = true;

  final ScrollController _controller = ScrollController();

  final now = DateTime.now();
  void _scrollDown() {
    Future.delayed(Duration(seconds: 1));
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  String calculateTimeDifferenceBetween(DateTime startDate, DateTime endDate) {
      int seconds = endDate.difference(startDate).inSeconds;
      if (seconds < 60)
        {
           if(seconds.abs() < 4) return 'Just Now';
        return '${seconds.abs()} s';
        }
      else if (seconds >= 60 && seconds < 3600)
        return '${startDate.difference(endDate).inMinutes.abs()} m';
      else if (seconds >= 3600 && seconds < 86400)
        return '${startDate.difference(endDate).inHours.abs()} h';
      else {
        // convert day to month
        int days = startDate.difference(endDate).inDays.abs();
        if (days < 30 && days > 7) {
          return '${(startDate.difference(endDate).inDays ~/ 7).abs()} w';
        }
        if (days > 30) {
          int month = (startDate.difference(endDate).inDays ~/ 30).abs();
          return '$month mos';
        } else
          return '${startDate.difference(endDate).inDays.abs()} d';
      }
    }

  // bool _isCommentLoading = true;
  Widget commentChild(List<CommentListElement> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: _controller,
        itemBuilder: (itemBuilder, index) {
          var millis;
          String? userStatusValue = data[index].userStatus?.toLowerCase() ;
          DateTime? date;
          if (data[index].createdAt != null) {
            millis = int.parse(data[index].createdAt.toString());
            date = DateTime.fromMillisecondsSinceEpoch(
              millis * 1000,
            ).toUtc().add(Duration(hours: 5, minutes: 30));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                 userStatusValue !=  "active"  && userStatusValue != null ? SvgPicture.asset(
                                'assets/images/default_user.svg',
                                height: 30,
                                width: 30,
                                allowDrawingOutsideViewBox: true,
                              ) :  Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: new BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                              new BorderRadius.all(Radius.circular(50))),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: data[index].profileImage != null
                            ? NetworkImage(data[index].profileImage!)
                            : NetworkImage(Images.DEFAULT_PROFILE_IMAGES),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${data[index].name}',
                        style:
                            Styles.bold(size: 12, color:  userStatusValue != "active"  && userStatusValue != null?  ColorConstants.GREY_3.withOpacity(0.3) : ColorConstants.BLACK),
                      ),
                    ),

                    Text(
                      data[index].createdAt == null
                          ? 'Just Now'
                          : '${calculateTimeDifferenceBetween(DateTime.parse(date.toString().substring(0, 19)), now)}',
                      style: Styles.regular(size: 12, color:  userStatusValue != "active"  && userStatusValue != null?  ColorConstants.GREY_3.withOpacity(0.3) : ColorConstants.BLACK),
                    ),
                    // Text(
                    //   '${data[index].createdAt.toString()}',

                    // ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    '${data[index].content}',
                    style:
                    userStatusValue !=  "active" && userStatusValue != null ?Styles.regular(size: 14, color: ColorConstants.BLACK) :   Styles.regular(size: 14, color: ColorConstants.BLACK),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Divider(height: 1, color: ColorConstants.GREY_4),
              ],
            ),
          );
        },
        itemCount: data.length,
      ),
    );
  }

  void getComments() {
    BlocProvider.of<HomeBloc>(context)
        .add(GetCommentEvent(postId: widget.postId));
  }

  void postComment(String comment) {
    BlocProvider.of<HomeBloc>(context).add(PostCommentEvent(
        postId: widget.postId, parentId: null, comment: comment));
  }

  @override
  void initState() {
    getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Center(
          child: Container(
            height: 5,
            width: 48,
            decoration: BoxDecoration(
                color: ColorConstants.GREY_4,
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        backgroundColor: ColorConstants.WHITE,
      ),
      body: BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is GetCommentState) _handleCommentResponse(state);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: CommentBox(
              userImage: '${UserSession.userImageUrl}',
              child: _isLoading
                  ? Center(child: Text('${Strings.of(context)?.loadingComment}'))
                  : commentChild(commentsList!),
              labelText: '${Strings.of(context)?.writeAComment}',
              errorText: '${Strings.of(context)?.commentCantBlank}',
              withBorder: true,
              sendButtonMethod: () {
                // if (formKey.currentState.validate()) {
                //   print(commentController.text);

                if (commentController != null &&
                    commentController.text != null &&
                    commentController.text.isNotEmpty) {
                  postComment(commentController.text);
                  commentsList!.insert(
                      0,
                      CommentListElement(
                        name: '${Preference.getString(Preference.FIRST_NAME)}',
                        content: commentController.text,
                        createdAt: null,
                        profileImage:
                            Preference.getString(Preference.PROFILE_IMAGE),
                      ));
                  widget.value!.incrementCommentCount(widget.postId);

                  _scrollDown();
                  commentController.clear();
                  FocusScope.of(context).unfocus();
                }
                // }
              },
              formKey: formKey,
              commentController: commentController,
              backgroundColor: Colors.deepOrangeAccent,
              textColor: Colors.white,
              sendWidget: Icon(Icons.send_sharp,
                  size: 30,
                  color: commentController.text.length > 0
                      ? Colors.white
                      : Colors.white.withOpacity(0.5)),
            ),
          ),
        ),
      ),
    );
  }

  void _handleCommentResponse(GetCommentState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          _isLoading = true;
          Log.v("Loading....................Get Comments");
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................Get Comments");
          commentsList = state.response!.data;
          commentsList = commentsList?.reversed.toList();

          widget.value!.updateComment(widget.postId, commentsList!.length);

          _isLoading = false;

          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................Get Comments");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}
