
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/pages/singularis/job/peger/ExampleItemPager.dart';
import 'package:masterg/pages/singularis/job/widgets/blank_widget_page.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../data/api/api_service.dart';
import '../../../utils/Log.dart';
import '../../../utils/Styles.dart';
import '../../../utils/resource/colors.dart';
import '../../../utils/resource/size_constants.dart';
import '../../custom_pages/custom_widgets/NextPageRouting.dart';
import 'job_details_page.dart';
import 'model/ExampleItem.dart';
import 'package:endless/endless.dart';
import 'package:masterg/data/models/response/home_response/user_jobs_list_response.dart';

class JobSearchViewPage extends StatefulWidget {

  final String? appBarTitle;
  final bool? isSearchMode;
  const JobSearchViewPage({Key? key, this.appBarTitle, this.isSearchMode = true,}) : super(key: key);

  @override
  State<JobSearchViewPage> createState() => _JobSearchViewPageState();
}

class _JobSearchViewPageState extends State<JobSearchViewPage> {

  bool? isJobLoading;
  List<ListElement>? jobList;

  @override
  void initState() {
    super.initState();
    getJobList();
  }

  void getJobList(){
    BlocProvider.of<HomeBloc>(context).add(UserJobsListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is UserJobListState) {
            _handleJobResponse(state);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            elevation: 0.0,
            backgroundColor: ColorConstants.WHITE,
            title: Text(widget.appBarTitle!, style: TextStyle(color: Colors.black),),
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
            left: SizeConstants.JOB_SEARCH_PAGE_MGN,
            top: SizeConstants.JOB_SEARCH_PAGE_MGN,
            right: SizeConstants.JOB_SEARCH_PAGE_MGN,
            bottom: SizeConstants.JOB_SEARCH_PAGE_MGN),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ///Search Job
            widget.isSearchMode == true ? _searchFilter():SizedBox(),

            ///Job List
            widget.isSearchMode == true ? SizedBox(height: 30,):SizedBox(),
            jobList != null ? _recommendedJobsListCard() : BlankWidgetPage(),
          ],
        ),
      ),
    );
  }


  Widget _searchFilter(){
    ExampleItemPager pager = ExampleItemPager();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 0),
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: PaginatedSearchBar<ExampleItem>(
              maxHeight: 300,
              hintText: 'Search',
              emptyBuilder: (context) {
                return const Text("I'm an empty state!");
              },
              /*placeholderBuilder: (context) {
                return const Text("I'm a placeholder state!");
              },*/
              paginationDelegate: EndlessPaginationDelegate(
                pageSize: 20,
                maxPages: 3,
              ),

              /*onSubmit: ({
                required item,
                required searchQuery,
              }) {
                print('item.title=== ${searchQuery}');
                print('item.title=== ${item?.title}');
                //submit(item!, searchQuery);
              },*/

              onSearch: ({
                required pageIndex,
                required pageSize,
                required searchQuery,
              }) async {
                return Future.delayed(const Duration(milliseconds: 1300), () {
                  if (searchQuery == "empty") {
                    return [];
                  }
                  if (pageIndex == 0) {
                    pager = ExampleItemPager();
                  }
                  return pager.nextBatch();
                });
              },
              itemBuilder: (
                  context, {
                    required item,
                    required index,
                  }) {
                return InkWell(
                  onTap: (){
                    print('item.title=== ${item?.title}');
                    pager.nextBatch();
                  },
                    child: Text(item.title));
              },

            ),
          ),
        ),
      ],
    );
  }

  void submit(ExampleItem item, String q){
    print('item.title=== ${item.title}');
  }


  Widget _recommendedJobsListCard() {
    return Container(
      color: ColorConstants.WHITE,
      child: renderJobList(jobList),
    );
  }

  Widget renderJobList(jobList) {
    return ListView.builder(
        itemCount: jobList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
          return Column(
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
                          onTap: () {
                            Navigator.push(
                                context, NextPageRoute(JobDetailsPage(
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
                            ), isMaintainState: true,
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
              ),
              Divider(height: 1,color: ColorConstants.GREY_3,),
            ],
          );

          return Text('data');
        });
  }

  void _handleJobResponse(UserJobListState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isJobLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("UserJobListState....................");
          jobList = state.response!.list!;
          print('jobList====${jobList!.length}');
          isJobLoading = false;
          break;
        case ApiStatus.ERROR:
          isJobLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorUserJobListState..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

}
