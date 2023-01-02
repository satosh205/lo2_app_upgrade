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
        Container(
                  height: 233,
                  // color: Colors.green,
                  // padding: EdgeInsets.symmetric(vertical: 20),
                  margin: EdgeInsets.only(top: 8, bottom: 20),
                  child: ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(onTap: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> CompetitionDetail() ));
                        },
                        child:competitionCard());
                      }),
                )
        ],)),

    );
  }

  Widget competitionCard(){
    return Container(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

          children: [
          SvgPicture.asset(
                                          'assets/images/circular_border.svg',
                                        width: 20,
                                        height: 20,
                                        ),Container(height: 30, width: 10, color: Color(0xffCECECE))
        ],),
      ),
      Container(
        decoration: BoxDecoration(color: ColorConstants.WHITE, borderRadius: BorderRadius.circular(8)),
        child: Text('nice'),)
    ]),
    );
  }
}