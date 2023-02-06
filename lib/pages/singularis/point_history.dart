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
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text("Point History",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
        leading: Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,),
        
    
      ),
    body: Container(
      height: height(context)*0.5,
      width: width(context),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
        return SingleChildScrollView(
          child: ListTile(
            leading: SvgPicture.asset('assets/images/coin.svg',width: 30,),
            title: Text.rich(
        TextSpan(
          text: '20',
          style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
          children: [
            
              TextSpan(
                text: '  earned from Activity',style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w300),
          )]))));
          
        
        
      }),
    )

    );
    
  }
}