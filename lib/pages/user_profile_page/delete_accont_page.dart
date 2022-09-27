import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

class DeleteAccountPage extends StatefulWidget {
  final imageUrl;
  const DeleteAccountPage({super.key, this.imageUrl});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.WHITE,
      appBar: AppBar(
        centerTitle: true,
           backgroundColor: ColorConstants.WHITE,
elevation: 0.7,
      iconTheme: IconThemeData(color: ColorConstants.BLACK),
      title: Text('Delete Account', style: Styles.bold(),)),
      
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

SizedBox(height: 20),
                           widget.imageUrl != null ?       ClipOval(
                                    child: GestureDetector(
                                      onTap: (){
                                        print('Profile image');
                                        // _showBgProfilePic(context, userProfileDataList!.profileImage!);
                                      },
                                      child: Image.network(
                                        widget.imageUrl,
                                        filterQuality: FilterQuality.low,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/images/default_user.svg',
                                    width: 200,
                                    height: 200,
                                    allowDrawingOutsideViewBox: true,
                                  ),
SizedBox(height: 20),


        Container(
            margin:EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
          child: Text('Deactivate your account insted of deleting?',  style: Styles.bold(size: 16), textAlign: TextAlign.center,)),
SizedBox(height: 10),

    infoCard(Icons.visibility, 'Deactivating your account is temporary', 'Your profile, photos, comments and likes will be hidden until you enable it by logging back in.'),
    infoCard(Icons.info_sharp , 'Deleting your account is permanent', 'Your profile, photos, videos, comments, likes and followers will be permanently deleted.'),
   
Expanded(child: SizedBox()),
      CupertinoButton(
        color: ColorConstants().primaryColor(),
        child: Text('Deactivate Account', style: Styles.regular(size: 12, color: ColorConstants.WHITE),), onPressed: (){}),
        CupertinoButton(
        child: Text('Delete Account', style: Styles.regular(size: 12 ,color:  ColorConstants.BLACK),), onPressed: (){}), SizedBox(height: 10,)
      ],),);
  }

  Widget infoCard(IconData icon, String title, String desc){
return Container(
  margin:EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
  child:   Row(
   
    children: [
  
  Icon(icon)

, 
SizedBox(width: 10),
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(title, style: Styles.bold(size: 14),),
  
  Container(
    width: MediaQuery.of(context).size.width * 0.7,
    child: Text(desc,  style: Styles.regular(size: 12), softWrap: true, maxLines: 3,)),
],)
  

  
  ],),
);
  }
}