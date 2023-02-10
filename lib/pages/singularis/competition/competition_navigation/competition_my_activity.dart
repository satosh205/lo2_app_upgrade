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
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: ColorConstants.BLACK,
              )),
          title: Text(
            'My Activities',
            style: Styles.semibold(),
          )),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: SingleChildScrollView(
          child: Column(children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.myActivity?.data.length,
                 physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return CompetitionMyAcitivityCard(
                    image: widget.myActivity?.data[index].pImage,
                    title: widget.myActivity?.data[index].name,
                    totalAct: widget.myActivity?.data[index].totalContents,
                    doneAct:
                        widget.myActivity?.data[index].totalActivitiesCompleted,
                    id: widget.myActivity?.data[index].id,
                    score: widget.myActivity?.data[index].gscore,
                    desc: widget.myActivity?.data[index].desc,
                    date: widget.myActivity?.data[index].starDate,
                    difficulty: widget.myActivity?.data[index].competitionLevel,
                    conductedBy: widget.myActivity?.data[index].organizedBy,
                    activityStatus: widget.myActivity?.data[index].activityStatus ?? '',
                   
                    
                  );
                }),
        
                //competed list
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.completedCompetition?.data.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return CompetitionMyAcitivityCard(
                    image: widget.completedCompetition?.data[index].pImage,
                    title: widget.completedCompetition?.data[index].name,
                    totalAct:
                        widget.completedCompetition?.data[index].totalActivities,
                    doneAct: widget.completedCompetition?.data[index].completedActivity,
                     id: widget.completedCompetition?.data[index].pId,
                    score: widget.completedCompetition?.data[index].gScore,
                    desc: widget.completedCompetition?.data[index].desc,
                    date: widget.completedCompetition?.data[index].startDate,
                    difficulty: widget.completedCompetition?.data[index].competitionLevel,
                    conductedBy: widget.completedCompetition?.data[index].organizedBy,
                     activityStatus: null,
                      rank: widget.completedCompetition?.data[index].rank,
                  );
                })
          ]),
        ),
      ),
    );
  }
}
