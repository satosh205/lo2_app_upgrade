import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/utility.dart';

class AddCertificate extends StatefulWidget {
  final bool? isEditMode;
  const AddCertificate({Key? key, this.isEditMode = false}) : super(key: key);

  @override
  State<AddCertificate> createState() => _AddCertificateState();
}

class _AddCertificateState extends State<AddCertificate> {
  final titleController = TextEditingController();
  TextEditingController startDate = TextEditingController();
   DateTime selectedDate = DateTime.now();
  
  File? uploadCerti;
  bool? isAddCertificateLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (value) {},
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) async {
              if (state is AddActivitiesState) handleAddCertificate(state);
            },
            child: Scaffold(
                body: ScreenWithLoader(
                  isLoading: isAddCertificateLoading,
                  body: Padding(
                              padding: const EdgeInsets.only(top: 0.0),
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
                            Spacer(),
                            IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close)),
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
                                  InkWell(
                                    onTap: () {
                                      try {
                                        selectDate(context, startDate);
                                      } catch (e) {
                                        startDate = TextEditingController();
                                        selectDate(context, startDate);
                                      }
                                    },

                                    child: Container(
                                      width: width(context),
                                      height: height(context) * 0.07,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1.0,
                                            color: const Color(0xffE5E5E5)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                           startDate.value.text != "" ?    startDate.value.text:   "Select Date",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff929BA3)),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8.0),
                                            child: SvgPicture.asset(
                                                'assets/images/selected_calender.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                  ),
                                  CustomUpload(
                                      onClick: () async {
                                        final picker = ImagePicker();
                                        final pickedFileC =
                                            await ImagePicker().pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 100,
                                        );
                                        if (pickedFileC != null) {
                                          setState(() {
                                            uploadCerti = File(pickedFileC.path);
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
                                             data["activity_type"] = "Certificate";   
                                        data['certificate'] =
                                            await MultipartFile.fromFile(
                                                '${uploadCerti?.path}',
                                                filename: fileName);
                                      } catch (e) {
                                        print('something is wrong $e');
                                      }
                                   
                
                                      data['title'] =
                                          titleController.value.text;
                                      data['start_date'] = startDate.value.text;
                                      data["professional_key"] = widget.isEditMode == true ? "certificate_id":   "new_professional"; 
                                      data["edit_url_professional"] = "";

                                      addCertificate(data);
                                    },
                                  )
                                ]))),
                      ],
                    ),
                  ),
                              ),
                            ),
                ))));
  }

  void addCertificate(Map<String, dynamic> data) {
    BlocProvider.of<HomeBloc>(context).add(AddActivitiesEvent(data: data));
  }

  void handleAddCertificate(AddActivitiesState state) {
    var addCertificateState = state;
    setState(() {
      switch (addCertificateState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading Add  Certificate....................");
          isAddCertificateLoading = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Add  Certificate....................");
          isAddCertificateLoading = false;
          Navigator.pop(context);
          break;
        case ApiStatus.ERROR:
          Log.v("Error Add Certificate....................");
          isAddCertificateLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

selectDate(BuildContext context, TextEditingController controller,
      {DateTime? startDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: startDate ?? DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        controller.text = Utility.convertDateFormat(selectedDate);
      });
  }
}
