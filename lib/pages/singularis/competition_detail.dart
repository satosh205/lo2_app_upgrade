import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
                                          height: 30, width: 8, decoration: BoxDecoration( color: Color(0xffCECECE), borderRadius: BorderRadius.circular(14)),)
        ],),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.75,
        // height: 100,
        decoration: BoxDecoration(color: ColorConstants.WHITE, borderRadius: BorderRadius.circular(8)),
        child: Text('nice'),)
    ]),
    );
  }
}