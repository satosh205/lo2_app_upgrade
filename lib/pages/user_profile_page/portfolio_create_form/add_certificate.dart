import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';

class AddCertificate extends StatefulWidget {
  const AddCertificate({Key? key}) : super(key: key);

  @override
  State<AddCertificate> createState() => _AddCertificateState();
}

class _AddCertificateState extends State<AddCertificate> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title:  Center(
              child: Text(
                "Add Certificate",
                style: Styles.regular(
                    size: 14,
                    color: Colors.black),
              ),
            ),
            actions: const [
              Icon(
                Icons.close,
                color: Colors.black,
              )
            ]),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                "Add Certificate",
                style: Styles.regular(
                    size: 14,
                    color: Colors.black),
              ),

              IconButton(
                onPressed: ()=> Navigator.pop(context),
                icon:  Icon(
                Icons.close,
                color: Colors.black,
              ),)
                        ],
                      ),
                   Text(
                    "Certificate*",
                    style: Styles.regular(
                        size: 14,
                        color: Color(0xff5A5F73)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                    controller: titleController,
                    hintText: 'Type project title here'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Start Date*",
                    style: Styles.regular(
                        size: 14,
                        color: Color(0xff5A5F73)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: width(context),
                    height: height(context) * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1.0, color: const Color(0xffE5E5E5)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Select Date",
                            style: Styles.regular(
                                size: 14,
                                color: Color(0xff929BA3)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SvgPicture.asset(
                              'assets/images/selected_calender.svg'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  CustomUpload(
                    onClick: (){},
                    uploadText: 'Upload Certificate'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text("Supported Files: .jpeg, .png",
                          style: Styles.regular(
                              size: 10,
                              color: Color(0xff929BA3))),
                    ),
                  ),
                  PortfolioCustomButton(clickAction: (){},)
                ]))));
  }
}
