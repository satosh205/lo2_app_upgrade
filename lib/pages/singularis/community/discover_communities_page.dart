
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../utils/Styles.dart';
import '../../../utils/resource/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class DiscoverCommunitiesPage extends StatefulWidget {
  const DiscoverCommunitiesPage({Key? key}) : super(key: key);

  @override
  State<DiscoverCommunitiesPage> createState() => _DiscoverCommunitiesPageState();
}

class _DiscoverCommunitiesPageState extends State<DiscoverCommunitiesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          //if (state is JoyContentListState) _handleJoyContentListResponse(state);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            elevation: 0,
            title: Text('Discover Communities',
              style: TextStyle(color: Colors.black),),
          ),
          backgroundColor: ColorConstants.WHITE,
          body: Column(
            children: [
              Divider(height: 1, color: ColorConstants.GREY_3,),
              _contentBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentBody() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(
                        right: 10.0,
                      ),
                      child: Image.asset('assets/images/pb_2.png', height: 60, width: 60,),
                      /*child: jobList?[index].companyThumbnail != null
                          ? Image.network(
                          jobList?[index].companyThumbnail)
                          : Image.asset('assets/images/pb_2.png')*/
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: InkWell(
                    onTap: () {
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 5.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Technology',
                              style: Styles.bold(
                                  size: 14, color: ColorConstants.BLACK)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text('Following',
                        style: Styles.bold(
                            size: 12, color: ColorConstants.GREY_3)),
                  ),
                ),
              ],
            ),
            Divider(height: 2, color: ColorConstants.GREY_3,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(
                      right: 10.0,
                    ),
                    child: Image.asset('assets/images/pb_2.png', height: 60, width: 60,),
                    /*child: jobList?[index].companyThumbnail != null
                          ? Image.network(
                          jobList?[index].companyThumbnail)
                          : Image.asset('assets/images/pb_2.png')*/
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: InkWell(
                    onTap: () {
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 5.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Management',
                              style: Styles.bold(
                                  size: 14, color: ColorConstants.BLACK)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0),
                    child: GradientText(
                      'Follow',
                      style: Styles.bold(size: 12),
                      colors: [
                        ColorConstants.GRADIENT_ORANGE,
                        ColorConstants.GRADIENT_RED,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 2, color: ColorConstants.GREY_3,),
          ],
        ),
      ),
    );
  }
}
