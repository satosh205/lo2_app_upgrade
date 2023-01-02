
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/pages/singularis/job/peger/ExampleItemPager.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../utils/Styles.dart';
import '../../../utils/resource/colors.dart';
import '../../../utils/resource/size_constants.dart';
import 'model/ExampleItem.dart';
import 'package:endless/endless.dart';

class JobDetailsPage extends StatefulWidget {

  final String title;
  const JobDetailsPage({Key? key, required this.title}) : super(key: key);

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetUserProfileState) {
            //_handleResponse(state);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            elevation: 0.0,
            backgroundColor: ColorConstants.WHITE,
            title: Text('Job Detail', style: TextStyle(color: Colors.black),),
          ),
          backgroundColor: ColorConstants.JOB_BG_COLOR,
          body: _makeBody(),
        ),
      ),
    );
  }

  Widget _makeBody() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
            bottom: SizeConstants.JOB_BOTTOM_SCREEN_MGN),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ///Job List
             Divider(height: 1,color: ColorConstants.GREY_3,),
            _jobListCard(),
          ],
        ),
      ),
    );
  }


  void submit(ExampleItem item, String q){
    print('item.title=== ${item.title}');
  }

  Widget _jobListCard() {
    return Container(
      color: ColorConstants.WHITE,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(right: 10.0, ),
                          child: Image.asset('assets/images/google.png'),
                        ),
                      ),

                      Expanded(
                        flex: 9,
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0, ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Interaction Designer',
                                  style: Styles.bold(
                                      size: 16, color: ColorConstants.BLACK)),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                    'Google',
                                    style: Styles.regular(size:12,color: ColorConstants.GREY_3)),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/jobicon.png'),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text('Exp: ',
                                          style: Styles.regular(size:12,color: ColorConstants.GREY_3)),
                                    ),
                                    Text('0 Yrs',
                                        style: Styles.regular(size:12,color: ColorConstants.GREY_3)),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0),
                                      child: Icon(Icons.location_on_outlined, size: 16,
                                        color: ColorConstants.GREY_3,),
                                    ),

                                    Text('Gurgaon',
                                        style: Styles.regular(size:12,color: ColorConstants.GREY_3)
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Apply to this Job',style: Styles.bold(
                      size: 15, color: ColorConstants.RED)),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  color: ColorConstants.WHITE,
                  boxShadow: [
                    BoxShadow(color: Colors.red, spreadRadius: 2),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
