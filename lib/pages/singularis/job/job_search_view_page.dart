
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

class JobSearchViewPage extends StatefulWidget {

  final String appBarTitle;
  const JobSearchViewPage({Key? key, required this.appBarTitle}) : super(key: key);

  @override
  State<JobSearchViewPage> createState() => _JobSearchViewPageState();
}

class _JobSearchViewPageState extends State<JobSearchViewPage> {
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
            backgroundColor: ColorConstants.JOB_BG_COLOR,
            title: Text(widget.appBarTitle, style: TextStyle(color: Colors.black),),
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
            left: SizeConstants.JOB_LEFT_SCREEN_MGN,
            //top: SizeConstants.JOB_TOP_SCREEN_MGN,
            top: 17,
            right: SizeConstants.JOB_RIGHT_SCREEN_MGN,
            bottom: SizeConstants.JOB_BOTTOM_SCREEN_MGN),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ///Search Job
            _searchFilter(),

            ///Job List
            SizedBox(height: 50,),
            _jobListCard(),
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

  Widget _jobListCard() {
    return Container(
      color: ColorConstants.WHITE,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text('Jobs based on your Portfolio',
                style: Styles.regular(size:16,color: ColorConstants.BLACK)),
          ),
          Divider(height: 1,color: ColorConstants.GREY_3,),

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
          ),

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
          ),
        ],
      ),
    );
  }

}
