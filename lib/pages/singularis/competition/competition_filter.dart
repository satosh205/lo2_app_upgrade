import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/home_response/domain_filter_list.dart';
import 'package:masterg/data/models/response/home_response/domain_list_response.dart';
import 'package:masterg/pages/singularis/competition/competition_filter_search_result_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';

import '../../custom_pages/custom_widgets/NextPageRouting.dart';

class CompetitionFilter extends StatefulWidget {
  final DomainListResponse? domainList;
  const CompetitionFilter({Key? key, this.domainList}) : super(key: key);

  @override
  State<CompetitionFilter> createState() => _CompetitionFilterState();
}

class _CompetitionFilterState extends State<CompetitionFilter> {
  List<int> selectedIdList = <int>[];
  String seletedIds = '';
  String selectedDifficulty = '';
  DomainFilterListResponse? domainFilterList;
  List<String> difficulty = ['Easy', 'Medium', 'Hard'];

  int selectedIndex = 0;

  @override
  void initState() {
    getFilterList(widget.domainList!.data!.list[0].id.toString());
    getFilterList(widget.domainList!.data!.list[0].id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocManager(
            initState: (BuildContext context) {},
            child: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is DomainFilterListState) {
                  handleDomainFilterListResponse(state);
                }
                // if (state is DomainListState) {
                //   handleDomainListResponse(state);
                // }
                // // if (state is DomainFilterListState) {
                // //   handleDomainFilterListResponse(state);
                // // }
                // if (state is TopScoringUserState) {
                //   handletopScoring(state);
                // }
              },
              child: SafeArea(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ColorConstants.WHITE,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Center(
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         color: ColorConstants.GREY_4,
                      //         borderRadius: BorderRadius.circular(8)),
                      //     width: 48,
                      //     height: 5,
                      //     margin: EdgeInsets.only(top: 8),
                      //   ),
                      // ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              'Filter by',
                              style: Styles.semibold(size: 16),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  selectedIndex = 0;
                                  seletedIds = '';
                                  selectedIdList = [];
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.close))
                          ],
                        ),
                      ),
                      Divider(
                        color: ColorConstants.GREY_4,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: Text(
                                  'Domain',
                                  style: Styles.bold(size: 14),
                                )),
                            Container(
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: List.generate(
                                    widget.domainList!.data!.list.length,
                                    (i) => InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = i;
                                              seletedIds = '';
                                              selectedIdList = [];
                                            });
                                            getFilterList(widget
                                                .domainList!.data!.list[i].id
                                                .toString());
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 5),
                                            child: Chip(
                                              backgroundColor:
                                                  i == selectedIndex
                                                      ? ColorConstants.GREEN
                                                      : Color(0xffF2F2F2),
                                              label: Container(
                                                child: Text(
                                                  '${widget.domainList!.data!.list[i].name}',
                                                  style: Styles.semibold(
                                                      size: 12,
                                                      color: i == selectedIndex
                                                          ? ColorConstants.WHITE
                                                          : ColorConstants
                                                              .BLACK),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: Text(
                                  'Job Roles',
                                  style: Styles.bold(size: 14),
                                )),
                            if (domainFilterList != null)
                              Container(
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: List.generate(
                                      domainFilterList!.data!.list.length,
                                      (i) => InkWell(
                                            onTap: () {
                                              //seletedIds += domainFilterList!.data!.list[i].id.toString() + ',';
                                              if (selectedIdList.contains(
                                                  domainFilterList!
                                                      .data!.list[i].id)) {
                                                selectedIdList.remove(
                                                    domainFilterList!
                                                        .data!.list[i].id);
                                              } else {
                                                selectedIdList.add(
                                                    domainFilterList!
                                                        .data!.list[i].id);
                                              }
                                              print(selectedIdList);

                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 5),
                                              child: Chip(
                                                backgroundColor:
                                                    selectedIdList.contains(
                                                            domainFilterList!
                                                                .data!
                                                                .list[i]
                                                                .id)
                                                        ? ColorConstants.GREEN
                                                        : Color(0xffF2F2F2),
                                                label: Container(
                                                  child: Text(
                                                      '${domainFilterList!.data!.list[i].title}',
                                                      style: Styles.regular(
                                                        size: 12,
                                                        color: selectedIdList
                                                                .contains(
                                                                    domainFilterList!
                                                                        .data!
                                                                        .list[i]
                                                                        .id)
                                                            ? ColorConstants
                                                                .WHITE
                                                            : ColorConstants
                                                                .BLACK,
                                                      )),
                                                ),
                                              ),
                                            ),
                                          )),
                                ),
                              ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: Text(
                                  'Difficulty',
                                  style: Styles.bold(size: 14),
                                )),
                            Container(
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: List.generate(
                                    difficulty.length,
                                    (i) => InkWell(
                                          onTap: () {
                                            if (selectedDifficulty ==
                                                difficulty[i])
                                              selectedDifficulty = '';
                                            else
                                              selectedDifficulty =
                                                  difficulty[i];
                                            setState(() {});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 5),
                                            child: Chip(
                                              backgroundColor:
                                                  selectedDifficulty ==
                                                          difficulty[i]
                                                      ? ColorConstants.GREEN
                                                      : Color(0xffF2F2F2),
                                              label: Container(
                                                child: Text('${difficulty[i]}',
                                                    style: Styles.regular(
                                                      size: 12,
                                                      color:
                                                          selectedDifficulty ==
                                                                  difficulty[i]
                                                              ? ColorConstants
                                                                  .WHITE
                                                              : ColorConstants
                                                                  .BLACK,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        )),
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                bool isFilter;
                                String conSelectValue;
                                if (selectedIdList.length != 0) {
                                  seletedIds = selectedIdList
                                      .toString()
                                      .replaceAll("[", "")
                                      .replaceAll("]", "");
                                }

                                if (selectedIdList.length == 0 &&
                                    selectedDifficulty != '') {
                                  isFilter = true;
                                  conSelectValue =
                                      '&competition_level=${selectedDifficulty.toLowerCase()}';
                                  //getCompetitionList(true, '&competition_level=${selectedDifficulty.toLowerCase()}');
                                } else if (selectedIdList.length == 0) {
                                  isFilter = false;
                                  conSelectValue =
                                      '&competition_level=${selectedDifficulty.toLowerCase()}';
                                  //getCompetitionList(false, '&competition_level=${selectedDifficulty.toLowerCase()}');
                                } else
                                  isFilter = true;
                                conSelectValue = seletedIds +
                                    '&competition_level=${selectedDifficulty.toLowerCase()}';
                                //getCompetitionList(true, seletedIds.substring(0, seletedIds.length - 1) + '&competition_level=${selectedDifficulty.toLowerCase()}');

                                print('Search Jobs');

                                Navigator.push(
                                        context,
                                        NextPageRoute(
                                            CompetitionFilterSearchResultPage(
                                              appBarTitle:
                                                  'Search Competitions',
                                              isSearchMode: isFilter,
                                              jobRolesId: conSelectValue,
                                            ),
                                            isMaintainState: true))
                                    .then((value) => null);
                              },
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(
                                    left: 50, top: 20, right: 50, bottom: 20),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  gradient: LinearGradient(colors: [
                                    ColorConstants.GRADIENT_ORANGE,
                                    ColorConstants.GRADIENT_RED,
                                  ]),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Search Competitions',
                                      style: Styles.regular(
                                        size: 13,
                                        color: ColorConstants.WHITE,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  void getFilterList(String ids) {
    BlocProvider.of<HomeBloc>(context).add(DomainFilterListEvent(ids: ids));
  }

  void handleDomainFilterListResponse(DomainFilterListState state) {
    var popularCompetitionState = state;
    setState(() {
      switch (popularCompetitionState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          // popularCompetitionLoading =
          //     true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Filter list State....................");
          domainFilterList = state.response;
          // popularCompetitionLoading =
          //     false;
          setState(() {});

          break;
        case ApiStatus.ERROR:
          Log.v(
              "Filter list CompetitionListIDState ..........................${popularCompetitionState.error}");
          // popularCompetitionLoading =
          //     false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}
