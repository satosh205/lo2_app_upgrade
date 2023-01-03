import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
class CompetitionDetail extends StatefulWidget {
  const CompetitionDetail({super.key});

  @override
  State<CompetitionDetail> createState() => _CompetitionDetailState();
}

class _CompetitionDetailState extends State<CompetitionDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      appBar: AppBar(
       leading: Icon(Icons.arrow_back_ios_new),
        title: Text('Design Competition')),
        body: SingleChildScrollView(child: Column(children: [
        ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> CompetitionDetail() ));
              },
              child:competitionCard());
            })
        ],)),

    );
  }

  Widget competitionCard(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.15,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,

          children: [
          SvgPicture.asset(
                                          'assets/images/circular_border.svg',
                                        width: 20,
                                        height: 20,
                                        
                                        ),Container(
                                          margin: EdgeInsets.only(top: 4),
                                          height: 75, width:6, decoration: BoxDecoration( color: Color(0xffCECECE), borderRadius: BorderRadius.circular(14)),)
        ],),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.8,
        // height: 100,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color: ColorConstants.WHITE, borderRadius: BorderRadius.circular(4)),
        child: renderAssignmentCard(),)
    ]),
    );
  }

  Widget renderAssignmentCard(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
      Text('Assignment', style: Styles.regular(size: 12, color: ColorConstants.GREY_3)),
      SizedBox(height: 8),
      Text('Redesign home page of a Travel App', style: Styles.bold( size: 12)),
      SizedBox(height: 8),
      Row(
                children: [
                  Text('Easy',
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
                  Text('30 Points',
                      style: Styles.regular(
                          color: ColorConstants.ORANGE_4, size: 12)),
                           SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.calendar_month,
                  size: 20,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '31st December',
                  style: Styles.regular(size: 12, color: Color(0xff5A5F73)),
                )
                ],
              )
    ]);
  }
}