import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_certificate.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class CertificateList extends StatefulWidget {
  const CertificateList({Key? key}) : super(key: key);

  @override
  State<CertificateList> createState() => _CertificateListState();
}

class _CertificateListState extends State<CertificateList> {
  

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
        appBar: AppBar(
          title: Text("Certificate",style: Styles.bold()),
                  elevation: 0,
                  backgroundColor: ColorConstants.WHITE,
                  leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: ColorConstants.BLACK,
                      )),
                      actions: [
                         IconButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              context: context,
                              enableDrag: true,
                              isScrollControlled: true,
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.7,
                                  child: Container(
                                      height: height(context),
                                      padding: const EdgeInsets.all(8.0),
                                      margin: const EdgeInsets.only(top: 10),
                                      child: AddCertificate()),
                                );
                              });
                        },
                        icon: Icon(
                          Icons.add,
                          color: ColorConstants.BLACK,
                        )),
                  ],
                      
    ),
    body: Container(
      
      height: height(context)*0.9,
      width: width(context),
      child: ListView.builder(
        itemCount: 2,
        itemBuilder:(context, index) {

         return Container(
          height: height(context)*0.9,
          width: width(context),
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width(context) * 0.7,
                        height: width(context) * 0.45,
                        
                         
                   child:  Image.asset(
                            "assets/images/certificate_dummy.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                  ]));
        
      })));
    
  

  
    
  }
}