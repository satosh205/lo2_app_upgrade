import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/pages/singularis/community/tab2/alumni_voice.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

import '../../data/models/response/home_response/joy_category_response.dart';
class WowStudio extends StatefulWidget {
  const WowStudio({Key? key}) : super(key: key);

  @override
  State<WowStudio> createState() => _WowStudioState();
}

class _WowStudioState extends State<WowStudio> {
  bool _isJoyCategoryLoading = true;
  List<ListElement>? joyCategoryList = [];

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(JoyCategoryEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: ColorConstants.WHITE,
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      ColorConstants.GRADIENT_ORANGE,
                      ColorConstants.GRADIENT_RED
                    ]),
              ),
            )),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: height(context) * 0.18,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    ColorConstants.GRADIENT_ORANGE,
                    ColorConstants.GRADIENT_RED
                  ]),
            ),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: width(context) * 0.1,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: ColorConstants.WHITE,
                        )),
                  ),
                  SizedBox(width: width(context) * 0.3),
                  SvgPicture.asset(
                    'assets/images/wow_studio.svg',
                    height: height(context) * 0.06,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text('Welcome to WOW Studio',
                  textAlign: TextAlign.center,
                  style: Styles.bold(color: ColorConstants.WHITE, size: 16)),
              SizedBox(height: 10),
              Text(
                  'Global community of WOW Alumni, Faculties, Industry Professionals, Recruiters, Policy Makers, and Mentors',
                  textAlign: TextAlign.center,
                  style: Styles.regular(color: ColorConstants.WHITE, size: 12))
            ]),
          ),
         
     AlumniVoice()   ],
      ),
    );
  }

  

  
}
