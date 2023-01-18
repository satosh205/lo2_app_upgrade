import 'package:flutter/material.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? middleName;
  String? lastName;
  String? headline;
  String? country;
  String? city;

  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final headlineController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.WHITE,
      appBar: AppBar(
        backgroundColor: ColorConstants.WHITE,
        elevation: 0,
      centerTitle: true,
        title: Text('Edit Profile', style: Styles.semibold(),),
        actions: [
          Icon(
            Icons.cancel,
            color: ColorConstants.BLACK,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

               Stack(
                 children: [
                  Container( 
                    decoration: BoxDecoration( color: Colors.red,shape: BoxShape.circle),
                     height: 120,
                        width: 120,),
                   Positioned(
                    left: 20,

right: 20,     
top: 20,
bottom: 20,                child: ClipRRect(
                        borderRadius: BorderRadius.circular(500),
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network('https://picsum.photos/seed/picsum/300/300'))),
                   ),
                 ],
               ),
              

              inputWidget('First Name*', 'Enter first name', 'Please enter first name', firstNameController),
              inputWidget('Middle Name*', 'Enter your middle name', 'Please Enter your middle name', middleNameController),
              inputWidget('Last Name*', 'Enter your last name', 'Please enter first name', lastNameController),
              inputWidget('Headline*', 'Enter your headline ', 'Please enter headline', headlineController)
            ],
          ),
        ),
      ),
    );
  }


  Widget inputWidget(String title, String hint, String errorMsg, TextEditingController controller){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text('$title', style: Styles.regular(color: Color(0xff5A5F73))),
        SizedBox(height: 6),
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "$hint"),
                ),
      ],),
    );
  }
}
