import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/constant.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(left:110.0),
            child: Text(
              "Resume",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
          actions:[
            SvgPicture.asset('assets/images/download.svg',),
            SizedBox(width: 10,),
            SvgPicture.asset('assets/images/delete.svg',),
            SizedBox(width: 10,),
            
            Padding(
              padding: EdgeInsets.only(right:8.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  
                ),
              ),
              
            ),
            
          ]),
      body: Container(
        color: Colors.white,
        // width: width(context),
        height: height(context) * 0.9,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top:280),
            child: Column(
              children: [
                SvgPicture.asset('assets/images/no_resume.svg',width: 80,),
                SizedBox(height: 20,),
                
                const Text(
                  "You have not uploaded your resume yet!",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff929BA3)),
                ),
                 SizedBox(
                  height: height(context)*0.34
                ),
                BottomAppBar(
                  
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:110.0),
                        child: Row(
                          children:  [
                            SvgPicture.asset('assets/images/upload_icon.svg'),
                            SizedBox(width: 10,),
                            GradientText(child: Text('Upload Latest'))
                            
                          ],
                        ),
                      ),
                      Text("Supported Format: .pdf, .doc, .jpeg",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff929BA3))),
                    ],
                  ),
                ),
                ),
                
                
              
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
