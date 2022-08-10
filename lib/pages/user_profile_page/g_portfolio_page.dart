import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/delete_portfolio_response.dart';
import 'package:masterg/data/models/response/home_response/list_portfolio_responsed.dart';
import 'package:masterg/data/models/response/home_response/top_scroing_user_response.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/user_profile_page/create_portfolio.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/resource/size_constants.dart';

class GPortfolioPage extends StatefulWidget {
  final String? profileUrl;
  final String? name;
  final int? score;
  final bool? editEnable;
  final int? userId;
  final List<TopScoringElement>? topScoringUsers;

  const GPortfolioPage(
      {Key? key,
      this.profileUrl,
      this.name,
      this.score,
      this.topScoringUsers,
      this.userId,
      this.editEnable})
      : super(key: key);

  @override
  State<GPortfolioPage> createState() => _GPortfolioPageState();
}

class _GPortfolioPageState extends State<GPortfolioPage> {
  int listCount = 0;
  String titleChild = '';
  late List<TopScoringElement> topScoringUsers;
  late List<PortfolioElement> listPortfolioBrand;
  late List<PortfolioElement> listPortfolioAward;
  late List<PortfolioElement> listPortfolioProject;
  late List<PortfolioElement> listPortfolioCertification;

  late DeletePortfolioResponse deletePortfolioResp;
  bool isTopScoringListLoading = true;
  bool isPortfolioListLoading = true;
  bool isDeletePortfolioLoading = true;
  String typeValue = '';
  int? deleteIndex;
  String deleteType = '';
  bool flagShimmer = false;

  @override
  void initState() {
    super.initState();
    if (widget.editEnable == true) {
      //_getTopScoringUsers();
      Timer(Duration(seconds: 2), () {
        setState(() {
          flagShimmer = true;
        });
      });
    }
    apiFetch();
  }

  void _getTopScoringUsers() {
    BlocProvider.of<HomeBloc>(context)
        .add(topScoringUsersEvent(userId: widget.userId));
  }

  Future<void> _listPortfolio(String type) async {
    setState(() {
      typeValue = type;
    });
    print(typeValue);
    print(type);
    BlocProvider.of<HomeBloc>(context)
        .add(ListPortfolioEvent(type: type, userId: widget.userId));
  }

  Future<void> _deletePortfolio(int id, int index) async {
    BlocProvider.of<HomeBloc>(context).add(DeletePortfolioEvent(id: id));
  }

  Future<void> apiFetch() async {
    if (widget.editEnable == true) {
      _getTopScoringUsers();
    }
    //await _listPortfolio('');
    await _listPortfolio('brand');
    await _listPortfolio('award');
    await _listPortfolio('project');
    await _listPortfolio('certification');
  }

  void fetchResults() {
    sleep(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Colors.orangeAccent, //or set color with: Color(0xFF0000FF)
    ));

    //, award, project
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is topScoringUsersState) {
            _handleTopScoringUsersResponse(state);
          }
          if (state is ListPortfolioState) {
            _handleListPortfolioResponse(state);
          }

          if (state is DeletePortfolioState) {
            _handleDeletePortfolioResponse(state);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Text('G Portfolio'),
          ),
          body: _makeBody(),
        ),
      ),
    );
  }

  Widget _makeBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          //TODO:User Information
          Container(
            height: 180.0,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  height: 80.0,
                  width: 80.0,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 0, color: Colors.transparent),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 100,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: ClipOval(
                        child: Image.network(
                      widget.profileUrl!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.name!,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                //widget.score
                widget.score != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              'GScore',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Image.asset(
                            "assets/images/coin.png",
                            width: 25,
                            height: 25,
                            fit: BoxFit.fill,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              widget.score.toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                        child: Container(
                          color: Colors.grey,
                          height: 15.0,
                          width: 150.0,
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),

          //TODO: Brand Associations
          listPortfolioBrand != null || widget.editEnable == true
              ? Container(
                  height: 110.0,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${Strings.of(context)?.branchAssociation}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: SizeConstants.BRAND_IMG_HEIGHT,
                        margin: EdgeInsets.only(top: 10.0),
                        child: ListView.builder(
                            itemCount: listPortfolioBrand != null
                                ? listPortfolioBrand.length + 1
                                : 1,
                            //itemCount: 2 + 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (listPortfolioBrand != null) {
                                if (index < listPortfolioBrand.length) {
                                  return listPortfolioBrand != null
                                      ? Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 5.0, right: 5),
                                              width: 100,
                                              height: SizeConstants
                                                  .BRAND_IMG_HEIGHT,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(3.0),
                                                child: Image.network(
                                                  listPortfolioBrand[index]
                                                      .image!,
                                                  fit: BoxFit.cover,
                                                  height: 200,
                                                ),
                                              ),
                                            ),
                                            widget.editEnable == true
                                                ? Positioned.fill(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: InkWell(
                                                        onTap: () {
                                                          AlertsWidget
                                                              .alertWithOkCancelBtn(
                                                            context: context,
                                                            text:
                                                                "${Strings.of(context)?.areYourSureYouWantToDelete}",
                                                            title:
                                                                "${Strings.of(context)?.alert}",
                                                            okText:
                                                                "${Strings.of(context)?.yes}",
                                                            cancelText:
                                                                "${Strings.of(context)?.no}",
                                                            onOkClick:
                                                                () async {
                                                              //call delete api
                                                              deleteIndex =
                                                                  index;
                                                              deleteType =
                                                                  'brand';
                                                              _deletePortfolio(
                                                                  listPortfolioBrand[
                                                                          index]
                                                                      .id!,
                                                                  index);
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 20.0,
                                                          width: 20.0,
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            border: Border.all(
                                                                width: 0,
                                                                color: Colors
                                                                    .transparent),
                                                            color: Colors
                                                                .grey[200],
                                                          ),
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 14,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        )
                                      : SizedBox();
                                } else {
                                  if (widget.editEnable! == true) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            NextPageRoute(CreatePortfolioPage(
                                              title:
                                                  "${Strings.of(context)?.branchAssociation}",
                                              portfolioType: 'brand',
                                            )));
                                      },
                                      child: new Container(
                                        width: 80.0,
                                        margin: EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.red,
                                        ),
                                        child: new Center(
                                          child: new Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }
                              } else {
                                if (widget.editEnable == true) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          NextPageRoute(CreatePortfolioPage(
                                            title:
                                                "${Strings.of(context)?.branchAssociation}",
                                            portfolioType: 'brand',
                                          )));
                                    },
                                    child: new Container(
                                      width: 80.0,
                                      margin: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.red,
                                      ),
                                      child: new Center(
                                        child: new Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }
                            }),
                      ),
                    ],
                  ),
                )
              : SizedBox(),

          //TODO: Awards
          listPortfolioAward != null || widget.editEnable == true
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${Strings.of(context)?.awards}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          widget.editEnable == true
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        NextPageRoute(CreatePortfolioPage(
                                          title:
                                              '${Strings.of(context)?.awardsAssociations}',
                                          portfolioType: 'award',
                                        )));
                                  },
                                  child: Container(
                                    height: 25.0,
                                    width: 25.0,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          width: 0, color: Colors.transparent),
                                      color: Colors.red,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        //height: 300,
                        constraints: new BoxConstraints(
                          minHeight: 100.0,
                          maxHeight: 300.0,
                        ),
                        margin: EdgeInsets.only(top: 10.0),
                        child: ListView.builder(
                            itemCount: listPortfolioAward != null
                                ? listPortfolioAward.length
                                : 0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Card(
                                    child: Container(
                                      height: 80,
                                      padding: EdgeInsets.only(top: 0.0),
                                      child: ListTile(
                                        leading: ClipOval(
                                            child: Image.network(
                                          listPortfolioAward[index].image!,
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                        )),
                                        title: Text(
                                            listPortfolioAward[index].title!,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Text(
                                          listPortfolioAward[index]
                                              .description!,
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ),
                                  widget.editEnable == true
                                      ? Positioned.fill(
                                          right: 10.0,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: () {
                                                AlertsWidget
                                                    .alertWithOkCancelBtn(
                                                  context: context,
                                                  text:
                                                      "${Strings.of(context)?.areYourSureYouWantToDelete}",
                                                  title:
                                                      "${Strings.of(context)?.alert}",
                                                  okText:
                                                      "${Strings.of(context)?.yes}",
                                                  cancelText:
                                                      "${Strings.of(context)?.no}",
                                                  onOkClick: () async {
                                                    //call delete api
                                                    deleteIndex = index;
                                                    deleteType = 'award';
                                                    _deletePortfolio(
                                                        listPortfolioAward[
                                                                index]
                                                            .id!,
                                                        index);
                                                  },
                                                );
                                              },
                                              child: Container(
                                                height: 20.0,
                                                width: 20.0,
                                                padding: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  border: Border.all(
                                                      width: 0,
                                                      color:
                                                          Colors.transparent),
                                                  color: Colors.grey[200],
                                                ),
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
                )
              : SizedBox(),

          //TODO: Projects
          listPortfolioProject != null || widget.editEnable == true
              ? Container(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${Strings.of(context)?.projects}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        margin: EdgeInsets.only(top: 10.0),
                        child: ListView.builder(
                            itemCount: listPortfolioProject != null
                                ? listPortfolioProject.length + 1
                                : 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (listPortfolioProject != null) {
                                if (index < listPortfolioProject.length) {
                                  return listPortfolioProject != null
                                      ? Stack(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 10.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.network(
                                                      listPortfolioProject[
                                                              index]
                                                          .image!,
                                                      fit: BoxFit.fitWidth,
                                                      height: 200.0,
                                                      width: 300.0,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Text(
                                                        listPortfolioProject[
                                                                index]
                                                            .title!,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 3.0),
                                                    child: Text(
                                                      listPortfolioProject[
                                                              index]
                                                          .description!,
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            widget.editEnable == true
                                                ? Positioned.fill(
                                                    right: 10.0,
                                                    top: 8.0,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: InkWell(
                                                        onTap: () {
                                                          AlertsWidget
                                                              .alertWithOkCancelBtn(
                                                            context: context,
                                                            text:
                                                                "${Strings.of(context)?.areYourSureYouWantToDelete}",
                                                            title:
                                                                "${Strings.of(context)?.alert}",
                                                            okText:
                                                                "${Strings.of(context)?.yes}",
                                                            cancelText:
                                                                "${Strings.of(context)?.no}",
                                                            onOkClick:
                                                                () async {
                                                              //call delete api
                                                              deleteIndex =
                                                                  index;
                                                              deleteType =
                                                                  'project';
                                                              _deletePortfolio(
                                                                  listPortfolioProject[
                                                                          index]
                                                                      .id!,
                                                                  index);
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 20.0,
                                                          width: 20.0,
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            border: Border.all(
                                                                width: 0,
                                                                color: Colors
                                                                    .transparent),
                                                            color: Colors
                                                                .grey[200],
                                                          ),
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 14,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        )
                                      : SizedBox();
                                } else {
                                  if (widget.editEnable == true) {
                                    return Row(
                                      children: [
                                        flagShimmer == false
                                            ? Container(
                                                //width: MediaQuery.of(context).size.width,
                                                height: 300,
                                                margin:
                                                    EdgeInsets.only(top: 10.0),
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0,
                                                      left: 10.0,
                                                      right: 10.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        enabled: true,
                                                        child: Container(
                                                          color: Colors.grey,
                                                          height: 200.0,
                                                          width: 300.0,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5.0),
                                                        child:
                                                            Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey[300]!,
                                                          highlightColor:
                                                              Colors.grey[100]!,
                                                          enabled: true,
                                                          child: Container(
                                                            color: Colors.grey,
                                                            height: 15.0,
                                                            width: 130.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0),
                                                        child:
                                                            Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey[300]!,
                                                          highlightColor:
                                                              Colors.grey[100]!,
                                                          enabled: true,
                                                          child: Container(
                                                            color: Colors.grey,
                                                            height: 15.0,
                                                            width: 250.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    NextPageRoute(
                                                        CreatePortfolioPage(
                                                      title:
                                                          'Projects Associations',
                                                      portfolioType: 'project',
                                                    )));
                                              },
                                              child: Container(
                                                width: 150.0,
                                                height: 150.0,
                                                margin: EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0,
                                                    bottom: 80.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color: Colors.red,
                                                ),
                                                child: new Center(
                                                  child: new Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }
                              } else {
                                if (widget.editEnable == true) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              NextPageRoute(CreatePortfolioPage(
                                                title: 'Projects Associations',
                                                portfolioType: 'project',
                                              )));
                                        },
                                        child: Container(
                                          width: 150.0,
                                          height: 150.0,
                                          margin: EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              bottom: 80.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            color: Colors.red,
                                          ),
                                          child: new Center(
                                            child: new Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              }
                            }),
                      ),
                    ],
                  ),
                )
              : SizedBox(),

          //TODO: Rank
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Rank',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 300,
                  constraints: new BoxConstraints(
                    minHeight: 100.0,
                    maxHeight: 300.0,
                  ),
                  margin: EdgeInsets.only(top: 10.0),
                  child: ListView.builder(
                      itemCount: widget.editEnable! && topScoringUsers != null
                          ? topScoringUsers.length
                          : widget.topScoringUsers != null
                              ? widget.topScoringUsers!.length
                              : 0,
                      //itemCount: 2,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      //physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Container(
                            height: 80,
                            padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 15),
                                      child: Text(
                                          widget.editEnable!
                                              ? topScoringUsers[index].score !=
                                                      null
                                                  ? topScoringUsers[index]
                                                      .score
                                                      .toString()
                                                  : '0'
                                              : widget.topScoringUsers![index]
                                                          .score !=
                                                      null
                                                  ? widget
                                                      .topScoringUsers![index]
                                                      .score
                                                      .toString()
                                                  : '0',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    ClipOval(
                                        child: Image.network(
                                      widget.editEnable!
                                          ? topScoringUsers[index].profileImage!
                                          : widget.topScoringUsers![index]
                                                      .profileImage !=
                                                  null
                                              ? widget.topScoringUsers![index]
                                                  .profileImage!
                                              : 'https://learningoxygen.com/theme1/images/profile/default.png',
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    )),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Text(
                                          widget.editEnable!
                                              ? topScoringUsers[index].name!
                                              : widget.topScoringUsers![index]
                                                  .name!,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                )),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/coin.png",
                                        width: 25,
                                        height: 25,
                                        fit: BoxFit.fill,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 10),
                                        child: Text(
                                            widget.editEnable!
                                                ? topScoringUsers[index]
                                                            .score !=
                                                        null
                                                    ? topScoringUsers[index]
                                                        .score
                                                        .toString()
                                                    : '0'
                                                : widget.topScoringUsers![index]
                                                            .score !=
                                                        null
                                                    ? widget
                                                        .topScoringUsers![index]
                                                        .score
                                                        .toString()
                                                    : '0',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),

          //TODO: Certification
          listPortfolioCertification != null || widget.editEnable == true
              ? Container(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Certification',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        //width: MediaQuery.of(context).size.width,
                        height: 300,
                        margin: EdgeInsets.only(top: 10.0),
                        child: ListView.builder(
                            itemCount: listPortfolioCertification != null
                                ? listPortfolioCertification.length + 1
                                : 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (listPortfolioCertification != null) {
                                if (index < listPortfolioCertification.length) {
                                  return listPortfolioCertification != null
                                      ? Stack(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 10.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.network(
                                                      listPortfolioCertification[
                                                              index]
                                                          .image!,
                                                      fit: BoxFit.fitWidth,
                                                      height: 200.0,
                                                      width: 300.0,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Text(
                                                        listPortfolioCertification[
                                                                index]
                                                            .title!,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 3.0),
                                                    child: Text(
                                                      listPortfolioCertification[
                                                              index]
                                                          .description!,
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            widget.editEnable == true
                                                ? Positioned.fill(
                                                    right: 10.0,
                                                    top: 8.0,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: InkWell(
                                                        onTap: () {
                                                          AlertsWidget
                                                              .alertWithOkCancelBtn(
                                                            context: context,
                                                            text:
                                                                "Are you sure you want to delete.",
                                                            title: "Alert!",
                                                            okText: "Yes",
                                                            cancelText: "No",
                                                            onOkClick:
                                                                () async {
                                                              //call delete api
                                                              deleteIndex =
                                                                  index;
                                                              deleteType =
                                                                  'certification';
                                                              _deletePortfolio(
                                                                  listPortfolioCertification[
                                                                          index]
                                                                      .id!,
                                                                  index);
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 20.0,
                                                          width: 20.0,
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            border: Border.all(
                                                                width: 0,
                                                                color: Colors
                                                                    .transparent),
                                                            color: Colors
                                                                .grey[200],
                                                          ),
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 14,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        )
                                      : SizedBox();
                                } else {
                                  if (widget.editEnable == true) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                NextPageRoute(
                                                    CreatePortfolioPage(
                                                  title: 'Certification',
                                                  portfolioType:
                                                      'certification',
                                                )));
                                          },
                                          child: Container(
                                            width: 150.0,
                                            height: 150.0,
                                            margin: EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                bottom: 80.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: Colors.red,
                                            ),
                                            child: new Center(
                                              child: new Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }
                              } else {
                                if (widget.editEnable == true) {
                                  return Row(
                                    children: [
                                      flagShimmer == false
                                          ? Container(
                                              //width: MediaQuery.of(context).size.width,
                                              height: 300,
                                              margin:
                                                  EdgeInsets.only(top: 10.0),
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    top: 10.0,
                                                    left: 10.0,
                                                    right: 10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      enabled: true,
                                                      child: Container(
                                                        color: Colors.grey,
                                                        height: 200.0,
                                                        width: 300.0,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0),
                                                      child: Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        enabled: true,
                                                        child: Container(
                                                          color: Colors.grey,
                                                          height: 15.0,
                                                          width: 130.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0),
                                                      child: Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        enabled: true,
                                                        child: Container(
                                                          color: Colors.grey,
                                                          height: 15.0,
                                                          width: 250.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  NextPageRoute(
                                                      CreatePortfolioPage(
                                                    title: 'Certification',
                                                    portfolioType:
                                                        'certification',
                                                  )));
                                            },
                                            child: Container(
                                              width: 150.0,
                                              height: 150.0,
                                              margin: EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 10.0,
                                                  bottom: 80.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                color: Colors.red,
                                              ),
                                              child: new Center(
                                                child: new Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              }
                            }),
                      )
                    ],
                  ),
                )
              : Container(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Certification',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        margin: EdgeInsets.only(top: 10.0),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                enabled: true,
                                child: Container(
                                  color: Colors.grey,
                                  height: 200.0,
                                  width: 300.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  enabled: true,
                                  child: Container(
                                    color: Colors.grey,
                                    height: 15.0,
                                    width: 130.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  enabled: true,
                                  child: Container(
                                    color: Colors.grey,
                                    height: 15.0,
                                    width: 250.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  void _handleTopScoringUsersResponse(topScoringUsersState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isTopScoringListLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("TopScoringUsersState....................");
          topScoringUsers = state.response!.data!;
          isTopScoringListLoading = false;
          break;
        case ApiStatus.ERROR:
          isTopScoringListLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleListPortfolioResponse(ListPortfolioState state) {
    print('handleListPortfolioResponse');
    var listPortfolioState = state;
    setState(() {
      switch (listPortfolioState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isPortfolioListLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("TopScoringUsersState data....................");

          if (state.response!.data!.list != null) {
            for (int i = 0; i < state.response!.data!.list!.length; i++) {
              if (state.response!.data!.list![i].type == 'brand') {
                listPortfolioBrand = state.response!.data!.list!;
              } else if (state.response!.data!.list![i].type == 'award') {
                listPortfolioAward = state.response!.data!.list!;
              } else if (state.response!.data!.list![i].type == 'project') {
                listPortfolioProject = state.response!.data!.list!;
              } else if (state.response!.data!.list![i].type ==
                  'certification') {
                listPortfolioCertification = state.response!.data!.list!;
              }
            }
          }
          isPortfolioListLoading = false;
          break;
        case ApiStatus.ERROR:
          isPortfolioListLoading = false;
          Log.v("Error..........................");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleDeletePortfolioResponse(DeletePortfolioState state) {
    var deletePortfolio = state;
    setState(() {
      switch (deletePortfolio.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isDeletePortfolioLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("DeletePortfolioResponseState....................");
          deletePortfolioResp = state.response!;

          print(deleteType);
          print(deleteIndex);

          if (deleteType == 'brand') {
            listPortfolioBrand.removeAt(deleteIndex!);
          } else if (deleteType == 'award') {
            listPortfolioAward.removeAt(deleteIndex!);
          } else if (deleteType == 'project') {
            listPortfolioProject.removeAt(deleteIndex!);
          } else if (deleteType == 'certification') {
            listPortfolioCertification.removeAt(deleteIndex!);
          }

          isDeletePortfolioLoading = false;
          break;
        case ApiStatus.ERROR:
          isDeletePortfolioLoading = false;
          Log.v("Error..........................");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}

//ListPortfolioEvent


/*
widget.editEnable == true ? Container(
height: 290,
width: MediaQuery.of(context).size.width,
color: Colors.white,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
width: MediaQuery.of(context).size.width,
height: 280,
margin: EdgeInsets.only(top: 10.0),
child:  Container(
padding: EdgeInsets.only(
top: 10.0, left: 10.0, right: 10.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Shimmer.fromColors(
baseColor: Colors.grey[300],
highlightColor: Colors.grey[100],
enabled: true,
child: Container(
color: Colors.grey,
height: 200.0,
width: 300.0,
),
),
Padding(
padding: const EdgeInsets.only(top: 5.0),
child: Shimmer.fromColors(
baseColor: Colors.grey[300],
highlightColor: Colors.grey[100],
enabled: true,
child: Container(
color: Colors.grey,
height: 15.0,
width: 130.0,
),
),
),
Padding(
padding: const EdgeInsets.only(top: 10.0),
child: Shimmer.fromColors(
baseColor: Colors.grey[300],
highlightColor: Colors.grey[100],
enabled: true,
child: Container(
color: Colors.grey,
height: 15.0,
width: 250.0,
),
),
),
],
),
),
),
],
),
) : SizedBox(),*/
