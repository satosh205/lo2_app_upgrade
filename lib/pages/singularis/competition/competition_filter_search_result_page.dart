import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../data/api/api_service.dart';
import '../../../data/models/response/home_response/competition_response.dart';
import '../../../utils/Log.dart';
import '../../../utils/Styles.dart';
import '../../../utils/constant.dart';
import '../../../utils/resource/colors.dart';
import '../../../utils/utility.dart';
import 'competition_detail.dart';
import 'package:masterg/pages/singularis/job/widgets/blank_widget_page.dart';

class CompetitionFilterSearchResultPage extends StatefulWidget {
  final String? appBarTitle;
  final bool? isSearchMode;
  final bool? isPopular;
  final String? jobRolesId;

  const CompetitionFilterSearchResultPage(
      {Key? key, this.appBarTitle, this.isSearchMode = true, this.isPopular, this.jobRolesId})
      : super(key: key);

  @override
  State<CompetitionFilterSearchResultPage> createState() =>
      _CompetitionFilterSearchResultPageState();
}

class _CompetitionFilterSearchResultPageState extends State<CompetitionFilterSearchResultPage> {

  bool? competitionLoading;
  CompetitionResponse? competitionResponse;
  int listLength = 0;

  @override
  void initState() {
    print('jobRolesId==========');
    getCompetitionList();
    super.initState();
  }

  void getCompetitionList() {
    BlocProvider.of<HomeBloc>(context).add(
        CompetitionListFilterEvent(isPopular: false, isFilter: widget.isSearchMode, ids: widget.jobRolesId));
  }

  void _handleCmpSearchResultListResponse(CompetitionListFilterState state) {
    var competitionState = state;
    setState(() {
      switch (competitionState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          competitionLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("CompetitionState....................");
          competitionResponse = state.competitionFilterResponse;
          competitionLoading = false;
          listLength = int.parse('${competitionResponse?.data!.length}');
          break;
        case ApiStatus.ERROR:
          Log.v(
              "Error CompetitionListIDState ..........................${competitionState.error}");
          competitionLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is CompetitionListFilterState) {
            _handleCmpSearchResultListResponse(state);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            elevation: 0.0,
            backgroundColor: ColorConstants.WHITE,
            title: Text(
              'Search Result',
              style: TextStyle(color: Colors.black),
            ),
          ),
          backgroundColor: ColorConstants.JOB_BG_COLOR,
          body: _comResultCard(),
        ),
      ),
    );
  }


  Widget _comResultCard() {
    return SingleChildScrollView(
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: competitionResponse?.data != null ? ListView.builder(
              itemCount: int.parse('${competitionResponse?.data!.length}') ?? 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompetitionDetail(
                                  competition: competitionResponse?.data?[index])));
                    },
                    child: Column(
                      children: [
                        renderCompetitionCard(
                            '${competitionResponse?.data![index]?.image ?? ''}',
                            '${competitionResponse?.data![index]?.name ?? ''}',
                            '${competitionResponse?.data![index]?.organizedBy ?? ''}',
                            '${competitionResponse?.data![index]?.competitionLevel ?? 'Easy'}',
                            '${competitionResponse?.data![index]?.gScore ?? 0}',
                            '${competitionResponse?.data![index]?.startDate != null ?
                            Utility.ordinalDate(dateVal: "${competitionResponse?.data![index]?.startDate}"): ''}')
                      ],
                    ),
                  ),
                );
              }): BlankWidgetPage(),

      ),
    );
  }

  renderCompetitionCard(String competitionImg, String name, String companyName, String difficulty, String gScore, String date) {
    return Container(
      height: 90,
      width: double.infinity,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: ColorConstants.WHITE,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Row(children: [
        SizedBox(
          width: 70,
          height: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: competitionImg,
              width: 100,
              height: 120,
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/comp_emp.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width(context) * 0.6,
                child: Text(
                  name,
                  style: Styles.bold(size: 14),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  /*if (companyName != '')
                    Text('Conducted by ',
                        style:
                            Styles.regular(size: 10, color: Color(0xff929BA3))),*/
                  if (companyName != '')
                    SizedBox(
                      width: width(context) * 0.4,
                      child: Text(
                        companyName,
                        style: Styles.semibold(size: 12, color: Color(0xff929BA3)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * 0.4,
                  // ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xff0E1638),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text('${difficulty.capital()}',
                      style: Styles.regular(
                          color: ColorConstants.GREEN_1, size: 12)),
                  SizedBox(
                    width: 4,
                  ),
                  Text('•',
                      style: Styles.regular(
                          color: ColorConstants.GREY_2, size: 12)),
                  SizedBox(
                    width: 4,
                  ),
                  SizedBox(
                      height: 15, child: Image.asset('assets/images/coin.png')),
                  SizedBox(
                    width: 4,
                  ),
                  Text('$gScore Points',
                      style: Styles.regular(
                          color: ColorConstants.ORANGE_4, size: 12)),
                  SizedBox(
                    width: 4,
                  ),
                  Text('•',
                      style: Styles.regular(
                          color: ColorConstants.GREY_2, size: 12)),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.calendar_month,
                    size: 16,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    date,
                    style: Styles.regular(size: 12, color: Color(0xff5A5F73)),
                  )
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }

}


extension on String {
  String capital() {
    return this[0].toUpperCase() + this.substring(1);
  }
}