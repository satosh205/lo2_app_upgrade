import 'package:flutter/material.dart';
import 'package:masterg/data/models/response/auth_response/competition_my_activity.dart';
import 'package:masterg/data/models/response/home_response/portfolio_competition_response.dart';
import 'package:masterg/pages/singularis/competition/competition_my_activity.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

class CompetitionMyActivity extends StatefulWidget {
  final PortfolioCompetitionResponse? completedCompetition;
  final CompetitionMyActivityResponse? myActivity;
  const CompetitionMyActivity(
      {Key? key, this.completedCompetition, this.myActivity})
      : super(key: key);

  @override
  State<CompetitionMyActivity> createState() => _CompetitionMyActivityState();
}

class _CompetitionMyActivityState extends State<CompetitionMyActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: ColorConstants.WHITE,
        leading: IconButton(
          onPressed: ()=> Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: ColorConstants.BLACK,)),
        title: Text('My Activities', style: Styles.semibold(),)),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Column(children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.myActivity?.data.length,
              itemBuilder: (context, index) {
                return CompetitionMyAcitivityCard(
                  image: widget.myActivity?.data[index].pImage,
                  title: widget.myActivity?.data[index].name,
                  totalAct: widget.myActivity?.data[index].totalContents,
                  doneAct:
                      widget.myActivity?.data[index].totalActivitiesCompleted,
                );
              }),
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.completedCompetition?.data.length,
              itemBuilder: (context, index) {
                return CompetitionMyAcitivityCard(
                  image: widget.completedCompetition?.data[index].pImage,
                  title: widget.completedCompetition?.data[index].name,
                  totalAct: widget.completedCompetition?.data[index].totalActivities,
                  doneAct:
                      1000,
                );
              })
        ]),
      ),
    );
  }
}
