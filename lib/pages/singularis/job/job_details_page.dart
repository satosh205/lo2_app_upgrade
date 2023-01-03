
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/pages/singularis/job/peger/ExampleItemPager.dart';
import 'package:masterg/pages/singularis/job/widgets/blank_widget_page.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../utils/Styles.dart';
import '../../../utils/resource/colors.dart';
import '../../../utils/resource/size_constants.dart';
import '../../custom_pages/custom_widgets/NextPageRouting.dart';
import 'model/ExampleItem.dart';
import 'package:masterg/data/models/response/home_response/user_jobs_list_response.dart';
import 'package:endless/endless.dart';

class JobDetailsPage extends StatefulWidget {

  final String? title;
  final String? description;
  final String? location;
  final String? skillNames;
  final String? companyName;
  final String? domain;
  final String? companyThumbnail;
  final int? experience;
  final List<ListElement>? jobListDetails;
  final int? id;

  const JobDetailsPage({Key? key,
    this.title,
    this.description,
    this.location,
    this.skillNames,
    this.companyName,
    this.domain,
    this.companyThumbnail,
    this.experience,
    this.jobListDetails,
    this.id,
  }) : super(key: key);

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {

  @override
  void initState() {
    super.initState();
  }


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
            _jobDetailsWidget(),

            ///Similar Jobs
            SizedBox(height: 30,),
            widget.jobListDetails != null ? _recommendedJobsListCard() : BlankWidgetPage(),
          ],
        ),
      ),
    );
  }


  void submit(ExampleItem item, String q){
    print('item.title=== ${item.title}');
  }

  Widget _jobDetailsWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Job Title Block
          Container(
            color: ColorConstants.WHITE,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 0.0),
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
                            child: widget.companyThumbnail != null ?
                            Image.network(widget.companyThumbnail!):
                            Image.asset('assets/images/pb_2.png'),
                          ),
                        ),

                        Expanded(
                          flex: 9,
                          child: Text('${widget.title}',
                              style: Styles.bold(
                                  size: 16, color: ColorConstants.BLACK)),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 40.0),
                  padding: EdgeInsets.only(left: 5.0, ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text('${widget.companyName}',
                            style: Styles.regular(size:12,color: ColorConstants.GREY_3)),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            //Image.asset('assets/images/jobicon.png'),
                            Icon(Icons.card_travel_sharp, size: 16,
                              color: ColorConstants.GREY_3,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('Exp: ',
                                  style: Styles.regular(size:12,color: ColorConstants.GREY_3)),
                            ),
                            Text('${widget.experience}  Yrs',
                                style: Styles.regular(size:12,color: ColorConstants.GREY_3)),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 16,
                              color: ColorConstants.GREY_3,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('${widget.location}',
                                  style: Styles.regular(size:12,color: ColorConstants.GREY_3)
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child:
                              Text('Domain:',
                                  style: Styles.regular(size:13,color: ColorConstants.GREY_1)
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('${widget.domain}',
                                  style: Styles.regular(size:12,color: ColorConstants.GREY_3)
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                        child: Text('Good to have skills',
                            style: Styles.regular(size:13,color: ColorConstants.GREY_1)
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 3.0),
                        child: Text('${widget.skillNames}',
                            style: Styles.regular(size:12,color: ColorConstants.GREY_3)
                        ),
                      ),
                    ],
                  ),
                ),

                ///Apply This Job Button
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Apply to this Job',style: Styles.regular(
                        size: 15, color: ColorConstants.RED)),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    color: ColorConstants.WHITE,
                    boxShadow: [
                      BoxShadow(color: Colors.red, spreadRadius: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///Job Description Block
          Container(
            margin: EdgeInsets.only(top: 15.0,),

            width: MediaQuery.of(context).size.width,
            color: ColorConstants.WHITE,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text('Job Description',
                      style: Styles.bold(size:18,color: ColorConstants.BLACK)),
                ),
                Divider(height: 1,color: ColorConstants.GREY_3,),

                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0, bottom: 20.0),
                  child: Text('${widget.description}',
                      style: Styles.regular(size:13,color: ColorConstants.GREY_3)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  ///Similar Jobs Widget
  Widget _recommendedJobsListCard() {
    return Container(
      color: ColorConstants.WHITE,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text('Similar Jobs',
                style: Styles.bold(size:16,color: ColorConstants.BLACK)),
          ),
          Divider(height: 1,color: ColorConstants.GREY_3,),

          renderJobList(widget.jobListDetails) ,
        ],
      ),
    );
  }

  Widget renderJobList(jobList){
    return ListView.builder(
        itemCount: jobList?.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
          return jobList[index].id != widget.id ? Column(
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
                            //child: Image.asset('assets/images/google.png'),
                            child: jobList?[index].companyThumbnail != null ?
                            Image.network(jobList?[index].companyThumbnail):
                            Image.asset('assets/images/pb_2.png')
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: InkWell(
                          onTap: (){
                            Navigator.pushReplacement(context, NextPageRoute(JobDetailsPage(
                              title: jobList[index].title,
                              description: jobList[index].description,
                              location: jobList[index].location,
                              skillNames: jobList[index].skillNames,
                              companyName: jobList[index].companyName,
                              domain: jobList[index].domain,
                              companyThumbnail: jobList[index].companyThumbnail,
                              experience: jobList[index].experience,
                              jobListDetails: jobList,
                              id: jobList[index].id,
                            )
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 5.0, ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${jobList?[index].title}',
                                    style: Styles.bold(
                                        size: 16, color: ColorConstants.BLACK)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                      '${jobList?[index].companyName}',
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
                                      Text('${jobList?[index].experience} Yrs',
                                          style: Styles.regular(size:12,color: ColorConstants.GREY_3)),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0),
                                        child: Icon(Icons.location_on_outlined, size: 16,
                                          color: ColorConstants.GREY_3,),
                                      ),

                                      Text('${jobList?[index].location}',
                                          style: Styles.regular(size:12,color: ColorConstants.GREY_3)
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text('Apply',style: Styles.bold(
                              size: 15, color: ColorConstants.ORANGE)),),
                      ),
                    ],
                  ),
                ),
                /*decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorConstants.WHITE,
                  boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 3),
                  ],
                ),*/
              ),
              Divider(height: 1,color: ColorConstants.GREY_3,),
            ],
          ):SizedBox();
        });
  }

}
