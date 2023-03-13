import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/pages/singularis/job/widgets/blank_widget_page.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../data/api/api_service.dart';
import '../../../data/models/response/home_response/competition_response.dart';
import '../../../utils/Log.dart';
import '../../../utils/Styles.dart';
import '../../../utils/resource/colors.dart';
import '../../../utils/resource/size_constants.dart';
import '../../custom_pages/custom_widgets/NextPageRouting.dart';
import 'job_details_page.dart';
import 'model/ExampleItem.dart';
import 'package:masterg/data/models/response/home_response/user_jobs_list_response.dart';

class JobSearchViewPage extends StatefulWidget {
  final String? appBarTitle;
  final bool? isSearchMode;
  final String? jobRolesId;

  const JobSearchViewPage(
      {Key? key, this.appBarTitle, this.isSearchMode = true, this.jobRolesId})
      : super(key: key);

  @override
  State<JobSearchViewPage> createState() => _JobSearchViewPageState();
}

class _JobSearchViewPageState extends State<JobSearchViewPage> {
  bool? isJobLoading;
  bool? myJobLoading = true;
  List<ListElement>? jobList;
  CompetitionResponse? allJobListResponse;

  ///Search Job New -----
  static const historyLength = 5;

  List<String> _searchHistory = [
    'fuchsia',
    'flutter',
    'widgets',
    'resocoder',
  ];

  late List<String> filteredSearchHistory;

  late String selectedTerm = 'Search Skills...';

  List<String> filterSearchTerms({
    required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: 'null');
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: 'null');
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: 'null');
    //getJobList();
    getMyJobList(false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void getMyJobList(bool jobType) {
    BlocProvider.of<HomeBloc>(context).add(JobCompListFilterEvent(
        isPopular: false,
        isFilter: true,
        ids: widget.jobRolesId,
        jobTypeMyJob: jobType));
  }

  /*void getJobList(){
    BlocProvider.of<HomeBloc>(context).add(UserJobsListEvent());
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          /*if (state is UserJobListState) {
            _handleJobResponse(state);
          }*/
          if (state is JobCompListFilterState) {
            _handlecompetitionListResponse(state);
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
          //body: _makeBody(),
          //body: _searchWidgetList(),
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
            //top: 40,
            right: SizeConstants.JOB_SEARCH_PAGE_MGN,
            bottom: SizeConstants.JOB_SEARCH_PAGE_MGN),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ///Search Job
            //widget.isSearchMode == true ? _searchFilter():SizedBox(),
            SizedBox(
              height: 10.0,
            ),

            ///Job List
            widget.isSearchMode == true
                ? SizedBox(
                    height: 30,
                  )
                : SizedBox(),
            allJobListResponse?.data != null ?
                MultiProvider(providers: [
                    ChangeNotifierProvider<CompetitionResponseProvider>(
                      create: (context) =>
                          CompetitionResponseProvider(allJobListResponse?.data),
                    ),
                  ], child: renderJobList())
                : BlankWidgetPage(),
          ],
        ),
      ),
    );
  }

  //TODO: Search Widget
  Widget _searchWidgetList() {
    return FloatingSearchBar(
      controller: controller,
      body: FloatingSearchBarScrollNotifier(
        /*child: SearchResultsListView(
          searchTerm: selectedTerm,
        ),*/
        child: _makeBody(),
      ),
      //body: _makeBody(),
      transition: CircularFloatingSearchBarTransition(),
      physics: BouncingScrollPhysics(),
      title: Text(
        selectedTerm,
        // selectedTerm ?? 'The Search App',
        //style: Theme.of(context).textTheme.headline6,
        style: TextStyle(fontSize: 14.0),
      ),
      hint: 'Search...',
      actions: [
        FloatingSearchBarAction.searchToClear(),
      ],
      onQueryChanged: (query) {
        setState(() {
          filteredSearchHistory = filterSearchTerms(filter: query);
        });
      },
      onSubmitted: (query) {
        setState(() {
          addSearchTerm(query);
          selectedTerm = query;
        });
        controller.close();
      },
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4,
            child: Builder(
              builder: (context) {
                if (filteredSearchHistory.isEmpty && controller.query.isEmpty) {
                  return Container(
                    height: 56,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Start searching',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  );
                } else if (filteredSearchHistory.isEmpty) {
                  return ListTile(
                    title: Text(controller.query),
                    leading: const Icon(Icons.search),
                    onTap: () {
                      setState(() {
                        addSearchTerm(controller.query);
                        selectedTerm = controller.query;
                      });
                      controller.close();
                    },
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: filteredSearchHistory
                        .map(
                          (term) => ListTile(
                            title: Text(
                              term,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            /*leading: const Icon(Icons.history),
                        trailing: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              deleteSearchTerm(term);
                            });
                          },
                        ),*/
                            onTap: () {
                              setState(() {
                                putSearchTermFirst(term);
                                selectedTerm = term;
                              });
                              controller.close();
                            },
                          ),
                        )
                        .toList(),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget renderJobList() {
    return Consumer<CompetitionResponseProvider>(
        builder: (context, competitionProvider, child) => competitionProvider.list.length != 0 ? ListView.builder(
            // itemCount: allJobListResponse?.data!.length,
            itemCount: competitionProvider.list.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                                padding: EdgeInsets.only(
                                  right: 10.0,
                                ),
                                //child: Image.asset('assets/images/google.png'),
                                child: allJobListResponse
                                            ?.data?[index]!.image !=
                                        null
                                    ? Image.network(
                                        '${allJobListResponse?.data?[index]!.image}')
                                    : Image.asset('assets/images/pb_2.png')),
                          ),
                          Expanded(
                            flex: 9,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    NextPageRoute(JobDetailsPage(
                                      title: allJobListResponse
                                          ?.data![index]!.name,
                                      description: allJobListResponse
                                          ?.data![index]!.description,
                                      location: allJobListResponse
                                          ?.data![index]!.location,
                                      skillNames: allJobListResponse
                                          ?.data![index]!.skillNames,
                                      companyName: allJobListResponse
                                          ?.data![index]!.organizedBy,
                                      domain: allJobListResponse
                                          ?.data![index]!.domainName,
                                      companyThumbnail: allJobListResponse
                                          ?.data![index]!.image,
                                      experience: allJobListResponse
                                          ?.data![index]!.experience,
                                      //jobListDetails: jobList,
                                      id: allJobListResponse?.data![index]!.id,
                                      jobStatus: allJobListResponse
                                          ?.data![index]!.jobStatus,
                                    )));
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 5.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${allJobListResponse?.data![index]!.name}',
                                        style: Styles.bold(
                                            size: 15,
                                            color: ColorConstants.BLACK)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                          '${allJobListResponse?.data![index]!.organizedBy}',
                                          style: Styles.regular(
                                              size: 12,
                                              color: ColorConstants.GREY_3)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              'assets/images/jobicon.png'),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: Text('Exp: ',
                                                style: Styles.regular(
                                                    size: 12,
                                                    color:
                                                        ColorConstants.GREY_3)),
                                          ),
                                          Text(
                                              '${allJobListResponse?.data![index]!.experience} Yrs',
                                              style: Styles.regular(
                                                  size: 12,
                                                  color:
                                                      ColorConstants.GREY_3)),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              size: 16,
                                              color: ColorConstants.GREY_3,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                                '${allJobListResponse?.data![index]!.location}',
                                                style: Styles.regular(
                                                    size: 12,
                                                    color:
                                                        ColorConstants.GREY_3)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(left: 0.0),
                              child: InkWell(
                                onTap: () {
                                  competitionProvider
                                      .updateAppliedStatus(index);
                                  jobApply(
                                      int.parse(
                                        '${allJobListResponse?.data![index]!.id}',
                                      ),
                                      1);
                                },
                                child: GradientText(
                                  competitionProvider.list[index]?.jobStatus !=
                                          null
                                      ? 'Apply'
                                      : 'Applied',
                                  style: Styles.bold(size: competitionProvider.list[index]?.jobStatus ==
                                      null ? 12 : 11),
                                  colors: [
                                    competitionProvider.list[index]?.jobStatus ==
                                            null
                                        ? ColorConstants.GRADIENT_ORANGE
                                        : ColorConstants.GREEN,
                                    competitionProvider
                                                .list[index]?.jobStatus ==
                                            null
                                        ? ColorConstants.GRADIENT_RED
                                        : ColorConstants.GREEN,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: ColorConstants.GREY_3,
                  ),
                ],
              );

              return Text('data');
            }):
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Image.asset('assets/images/no_jobs.png'),
        ));
  }

  void jobApply(int jobId, int? isApplied) {
    BlocProvider.of<HomeBloc>(context).add(CompetitionContentListEvent(
        competitionId: jobId, isApplied: isApplied));
  }

  void _handlecompetitionListResponse(JobCompListFilterState state) {
    var jobCompState = state;
    setState(() {
      switch (jobCompState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          myJobLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("CompetitionState....................");
          allJobListResponse = state.jobListResponse;
          myJobLoading = false;
          break;
        case ApiStatus.ERROR:
          Log.v(
              "Error CompetitionListIDState .....................${jobCompState.error}");
          myJobLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
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
          isJobLoading = false;
          break;
        case ApiStatus.ERROR:
          isJobLoading = false;
          Log.v("Error..........................");
          Log.v(
              "ErrorUserJobListState..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}
