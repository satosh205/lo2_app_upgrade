import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/constant.dart';

class AddCertificate extends StatefulWidget {
  const AddCertificate({Key? key}) : super(key: key);

  @override
  State<AddCertificate> createState() => _AddCertificateState();
}

class _AddCertificateState extends State<AddCertificate> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final linkController = TextEditingController();
  File? uploadCerti;
  File? img;
  bool? isAddPortfolioLoading = false;
  @override
  Widget build(BuildContext context) {
    var path;

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Container(
        height: height(context) * 0.6,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 130.0),
                    child: Text(
                      "Add Certificate",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                  ),
                  Icon(Icons.close),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text(
                          "Certificate*",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
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
                            onClick: () async {
                              final picker = ImagePicker();
                              final pickedFileC = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 100,
                              );
                              if (pickedFileC != null) {
                                setState(() {
                                  img = File(pickedFileC.path);
                                });
                              } else if (Platform.isAndroid) {
                                final LostData response =
                                    await picker.getLostData();
                              }
                            },
                            uploadText: 'Upload Certificate'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                                uploadCerti != null
                                    ? '${uploadCerti?.path.split('/').last}'
                                    : "Supported Files: .jpeg, .png",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff929BA3))),
                          ),
                        ),
                        PortfolioCustomButton(
                          clickAction: () async {
                            Map<String, dynamic> data = Map();
                            try {
                              String? fileName =
                                  uploadCerti?.path.split('/').last;
                              data['certificate_image'] =
                                  await MultipartFile.fromFile(
                                      '${uploadCerti?.path}',
                                      filename: fileName);
                            } catch (e) {
                              print('something is wrong $e');
                            }
                            print('agaoni cliked');

                            data['portfolio_title'] =
                                titleController.value.text;

                            data['edit_image_type'] = '';
                          },
                        )
                      ]))),
            ],
          ),
        ),
      ),
    ));
  }
}
