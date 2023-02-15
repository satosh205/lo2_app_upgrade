
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../data/models/response/home_response/competition_response.dart';
import '../../../utils/Styles.dart';
import '../../../utils/resource/colors.dart';
import '../../../utils/resource/size_constants.dart';
import '../../custom_pages/custom_widgets/NextPageRouting.dart';
import 'job_details_page.dart';

class MyJobAllViewListPage extends StatefulWidget {

 final CompetitionResponse? myJobResponse;
 const MyJobAllViewListPage({Key? key, this.myJobResponse,}) : super(key: key);


  @override
  State<MyJobAllViewListPage> createState() => _MyJobAllViewListPageState();
}

class _MyJobAllViewListPageState extends State<MyJobAllViewListPage> {

  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {

        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            elevation: 0.0,
            backgroundColor: ColorConstants.WHITE,
            title: Text('My Jobs', style: TextStyle(color: Colors.black),),
          ),
          backgroundColor: ColorConstants.JOB_BG_COLOR,
          body: _myJobSectionCard(),
        ),
      ),
    );
  }

  Widget _myJobSectionCard() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.myJobResponse?.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      NextPageRoute(JobDetailsPage(
                        title: widget.myJobResponse?.data![index]!.name,
                        description: widget.myJobResponse?.data![index]!.description,
                        location: widget.myJobResponse?.data![index]!.location,
                        skillNames: widget.myJobResponse?.data![index]!.skillNames,
                        companyName: widget.myJobResponse?.data![index]!.organizedBy,
                        domain: widget.myJobResponse?.data![index]!.domainName,
                        companyThumbnail: widget.myJobResponse?.data![index]!.image,
                        experience: widget.myJobResponse?.data![index]!.experience,
                        //jobListDetails: jobList,
                        id: widget.myJobResponse?.data![index]!.id,
                        jobStatus: widget.myJobResponse?.data![index]!.jobStatus,
                      )));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorConstants.WHITE),
                        color: ColorConstants.WHITE,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 7.0, top: 15.0, right: 7.0, bottom: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(
                                      right: 10.0,
                                    ),
                                    child: widget.myJobResponse?.data![index]!.image != null
                                        ? Image.network('${widget.myJobResponse?.data![index]!.image}', height: 60, width: 80,)
                                        : Image.asset('assets/images/pb_2.png')),

                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${widget.myJobResponse?.data![index]!.name}'),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text('${widget.myJobResponse?.data![index]!.organizedBy}'),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),

                          widget.myJobResponse?.data![index]!.jobStatus != null ? Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Text( widget.myJobResponse?.data![index]!.jobStatus == 'under_review' ?
                            'Application Under Process' :
                            widget.myJobResponse?.data![index]!.jobStatus == 'shortlisted' ?
                            'Application Shortlisted' :
                            widget.myJobResponse?.data![index]!.jobStatus == 'rejected' ?
                            'Unable To Offer You A Position' :
                            '${widget.myJobResponse?.data![index]!.jobStatus}',
                              style: TextStyle(color: widget.myJobResponse?.data![index]!.jobStatus == 'rejected' ?
                              ColorConstants.VIEW_ALL : Colors.green, fontSize: 12),),
                          ):Text(''),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }

}


class BlankWidgetPage extends StatelessWidget {
  const BlankWidgetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 70.0),
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
                    child: Image.asset('assets/images/blank.png'),
                  ),
                ),

                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0, ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xffe6e4e6),
                          highlightColor: Color(0xffeaf0f3),
                          child: Container(
                              height: 13,
                              margin: EdgeInsets.only(left: 2),
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              )),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Shimmer.fromColors(
                            baseColor: Color(0xffe6e4e6),
                            highlightColor: Color(0xffeaf0f3),
                            child: Container(
                                height: 13,
                                margin: EdgeInsets.only(left: 2),
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                )),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Color(0xffe6e4e6),
                                highlightColor: Color(0xffeaf0f3),
                                child: Container(
                                    height: 13,
                                    margin: EdgeInsets.only(left: 2),
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Shimmer.fromColors(
                                  baseColor: Color(0xffe6e4e6),
                                  highlightColor: Color(0xffeaf0f3),
                                  child: Container(
                                      height: 13,
                                      margin: EdgeInsets.only(left: 2),
                                      width: 60,
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
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1,color: ColorConstants.GREY_3,),
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
                    child: Image.asset('assets/images/blank.png'),
                  ),
                ),

                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0, ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xffe6e4e6),
                          highlightColor: Color(0xffeaf0f3),
                          child: Container(
                              height: 13,
                              margin: EdgeInsets.only(left: 2),
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              )),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Shimmer.fromColors(
                            baseColor: Color(0xffe6e4e6),
                            highlightColor: Color(0xffeaf0f3),
                            child: Container(
                                height: 13,
                                margin: EdgeInsets.only(left: 2),
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                )),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Color(0xffe6e4e6),
                                highlightColor: Color(0xffeaf0f3),
                                child: Container(
                                    height: 13,
                                    margin: EdgeInsets.only(left: 2),
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Shimmer.fromColors(
                                  baseColor: Color(0xffe6e4e6),
                                  highlightColor: Color(0xffeaf0f3),
                                  child: Container(
                                      height: 13,
                                      margin: EdgeInsets.only(left: 2),
                                      width: 60,
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
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1,color: ColorConstants.GREY_3,),
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
                    child: Image.asset('assets/images/blank.png'),
                  ),
                ),

                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0, ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xffe6e4e6),
                          highlightColor: Color(0xffeaf0f3),
                          child: Container(
                              height: 13,
                              margin: EdgeInsets.only(left: 2),
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              )),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Shimmer.fromColors(
                            baseColor: Color(0xffe6e4e6),
                            highlightColor: Color(0xffeaf0f3),
                            child: Container(
                                height: 13,
                                margin: EdgeInsets.only(left: 2),
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                )),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Color(0xffe6e4e6),
                                highlightColor: Color(0xffeaf0f3),
                                child: Container(
                                    height: 13,
                                    margin: EdgeInsets.only(left: 2),
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Shimmer.fromColors(
                                  baseColor: Color(0xffe6e4e6),
                                  highlightColor: Color(0xffeaf0f3),
                                  child: Container(
                                      height: 13,
                                      margin: EdgeInsets.only(left: 2),
                                      width: 60,
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}