import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';

class PointHistory extends StatefulWidget {
  const PointHistory({Key? key}) : super(key: key);

  @override
  State<PointHistory> createState() => _PointHistoryState();
}

class _PointHistoryState extends State<PointHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Point History",style: Styles.textBold()),
        leading: Icon(Icons.arrow_back_ios_new_outlined),
        
    
      ),
    body: ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
      return Container(
        height: height(context)*0.7,
        width: width(context),
        child: SingleChildScrollView(
          child: ListTile(
            leading: SvgPicture.asset('assets/images/coin.svg'),
            title: Text.rich(
        TextSpan(
          text: '20',
          style: Styles.bold(),
          children: [
            
              TextSpan(
                text: 'earned from Activity',style: Styles.DMSansregular()
          )])))));
        
      
      
    })

    );
    
  }
}