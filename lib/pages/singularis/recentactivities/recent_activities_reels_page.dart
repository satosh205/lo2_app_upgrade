
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../blocs/home_bloc.dart';
import '../../../data/api/api_service.dart';
import '../../../data/models/response/home_response/greels_response.dart';
import '../../../utils/Log.dart';
import '../../../utils/resource/colors.dart';
import '../../custom_pages/custom_widgets/NextPageRouting.dart';
import '../../reels/reels_dashboard_page.dart';

class RecentActivitiesReelsPage extends StatefulWidget {
  const RecentActivitiesReelsPage({Key? key}) : super(key: key);

  @override
  State<RecentActivitiesReelsPage> createState() => _RecentActivitiesReelsPageState();
}

class _RecentActivitiesReelsPageState extends State<RecentActivitiesReelsPage> {

  bool isGReelsLoading = true;
  List<GReelsElement>? greelsList;

  @override
  void initState() {
    super.initState();
    _getGReels();
    // _tabController = TabController(length: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) async{
        if (state is GReelsPostState) {
          _handleGReelsResponse(state);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: greelsList != null ?
          Container(
              //height: 250,
              /*child: GridView.builder(
                  itemCount: greelsList?.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      margin: EdgeInsets.only(
                          right: 10, left: 10, top: 4, bottom: 4),
                      child: SizedBox(
                          height: 280,
                          width: 180,
                          child: InkWell(
                              onTap: () {

                              },
                              child: CreateThumnail(
                                  path: greelsList?[index].resourcePath))),
                    );
                  })*/

            child: Container(
              margin: EdgeInsets.only(left: 17, right: 17, top: 4),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: greelsList!.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2 / 3,
                          mainAxisExtent:
                          MediaQuery.of(context).size.height * 0.34,
                          crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, NextPageRoute(ReelsDashboardPage(
                              fromDashboard: true,
                              scrollTo: index,
                            )));
                          },
                          child: CreateThumnail(
                              path: greelsList?[index].resourcePath,
                            viewCount: greelsList?[index].viewCount,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          ): BlankPage(),
        ),
      ),
    );
  }

  void _getGReels() async {
    BlocProvider.of<HomeBloc>(context).add(GReelsPostEvent(userActivity: true));
  }

  void _handleGReelsResponse(GReelsPostState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isGReelsLoading = true;
          break;
        case ApiStatus.SUCCESS:
          greelsList = state.response!.data!.list;

          print('greelsList === ${greelsList!.length}');
          //greelsModel.refreshList(greelsList!);
          Log.v("ReelsUsersState.................... ${greelsList?.length}");

          isGReelsLoading = false;
          break;
        case ApiStatus.ERROR:
          isGReelsLoading = false;

          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

}


class CreateThumnail extends StatelessWidget {
  final String? path;
  final int? viewCount;

  const CreateThumnail({super.key, this.path, this.viewCount});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
        future: getFile(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Center(
                  child: SvgPicture.asset(
                    'assets/images/play.svg',
                    height: 40.0,
                    width: 40.0,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(child: Text('${viewCount!} view',
                    style: TextStyle(
                        color: Colors.white,
                    ),),
                  alignment: Alignment.bottomLeft,),
                ),
              ],
            );
          return Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
              height: 250,
              //margin: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
            ),
          );
        });
  }

  Future<Uint8List?> getFile() async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: path!,
      imageFormat: ImageFormat.PNG,
      timeMs: Duration(seconds: 1).inMilliseconds,
    );
    // if (this.mounted)
    //   setState(() {
    //     imageFile = uint8list;
    //   });
    return uint8list;
  }
}

class BlankPage extends StatelessWidget {
  const BlankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Shimmer.fromColors(
              baseColor: Color(0xffe6e4e6),
              highlightColor: Color(0xffeaf0f3),
              child: Container(
                //height: MediaQuery.of(context).size.height * 0.2,
                height: 250,
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(6)),
              ),
            )),
            Expanded(child: Shimmer.fromColors(
              baseColor: Color(0xffe6e4e6),
              highlightColor: Color(0xffeaf0f3),
              child: Container(
                //height: MediaQuery.of(context).size.height * 0.2,
                height: 250,
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(6)),
              ),
            )),
          ],
        ),

        SizedBox(height: 15,),
        Row(
          children: [
            Expanded(child: Shimmer.fromColors(
              baseColor: Color(0xffe6e4e6),
              highlightColor: Color(0xffeaf0f3),
              child: Container(
                //height: MediaQuery.of(context).size.height * 0.2,
                height: 250,
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(6)),
              ),
            )),
            Expanded(child: Shimmer.fromColors(
              baseColor: Color(0xffe6e4e6),
              highlightColor: Color(0xffeaf0f3),
              child: Container(
                //height: MediaQuery.of(context).size.height * 0.2,
                height: 250,
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(6)),
              ),
            )),
          ],
        ),
        SizedBox(height: 15,),
        Row(
          children: [
            Expanded(child: Shimmer.fromColors(
              baseColor: Color(0xffe6e4e6),
              highlightColor: Color(0xffeaf0f3),
              child: Container(
                //height: MediaQuery.of(context).size.height * 0.2,
                height: 250,
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(6)),
              ),
            )),
            Expanded(child: Shimmer.fromColors(
              baseColor: Color(0xffe6e4e6),
              highlightColor: Color(0xffeaf0f3),
              child: Container(
                //height: MediaQuery.of(context).size.height * 0.2,
                height: 250,
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(6)),
              ),
            )),
          ],
        ),
      ],
    );
  }

}