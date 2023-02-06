import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/location.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/constant.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final nameController = TextEditingController();
   final headController = TextEditingController(); 
   final countryController = TextEditingController(); 
   final cityController = TextEditingController(); 
   final aboutController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Edit Profile",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            actions:  [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              )
            ]),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("First Name",style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5A5F73)),),
                      SizedBox(height: 10,),
                    CustomTextField(
                      controller: nameController,
                      hintText: 'Full Name'),
                
                const SizedBox(
                  height: 5,
                ),
                
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Headline*",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5A5F73)),
                ),
                const SizedBox(
                  height: 5,
                ),
               CustomTextField(
                controller: headController,
                hintText: 'Enter your Headline'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [Text("0/20")],
                ),
                const Text(
                  "Location",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (() {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationPage()));
                      }),
                      child: SvgPicture.asset('assets/images/location.svg')),
                    SizedBox(width: 10,),
                    
                    GradientText(child: Text("Use current location",style: TextStyle(fontSize: 12),))
                  ],
                ),
                const Text(
                  "Country*",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5A5F73)),
                ),
                const SizedBox(
                  height: 5,
                ),
               CustomTextField(
                controller: countryController,
                hintText: 'Enter your Country'),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "City*",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5A5F73)),
                ),
                const SizedBox(
                  height: 5,
                ),
              CustomTextField(
                controller: cityController,
                hintText: 'Enter your City'),
              SizedBox(height: 20,),
                      const Text(
                  "About me*",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5A5F73)),
                ),
                SizedBox(height: 5,),
                CustomTextField(
                  controller: aboutController,
                  maxLine: 10,
                  hintText: 'Tell everyone something about yourself'),
              

      PortfolioCustomButton(clickAction: (){})
              ])),
        ));
  }
}
