import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/new_portfolio_response.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';

class AddEducation extends StatefulWidget {
  final CommonProfession? education;
  
  final bool? isEditMode;
  const AddEducation({Key? key, this.isEditMode = false,  this.education}) : super(key: key);

  @override
  State<AddEducation> createState() => _AddActivitiesState();
}

class _AddActivitiesState extends State<AddEducation> {
  TextEditingController schoolController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool? isAddEducationLoading;
   File? uploadImg;


   @override
  void initState() {
    setValues();
    super.initState();
  }

  void setValues(){
    if(widget.isEditMode == true){
      schoolController = TextEditingController(text: widget.education?.institute);
    }
  }
  @override


  Widget build(BuildContext context) {
    return BlocManager(
        initState: (value) {},
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) async {
              if (state is AddActivitiesState) handleAddEducation(state);
            },
    child:Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 130.0),
                        child:
                            Text('Add Education', style: Styles.bold(size: 14)),
                      ),
                      // SizedBox(width: width(context) * 0.2),
                      Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "School*",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff5A5F73)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                        controller: schoolController,
                        hintText:
                            'Ex. Middle East College (MEC), Muscat, Oman'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Degree*",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff5A5F73)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                        controller: degreeController,
                        hintText: 'Ex: Bachelor\'s of Instrumentation'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Start Date*",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff5A5F73)),
                    ),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
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
                                startDate.value.text != ''
                                    ? startDate.value.text
                                    : "Select Date",
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "End date (or expected)*",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff5A5F73)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      try {
                        selectDate(context, endDate, startDate: selectedDate);
                      } catch (e) {
                        endDate = TextEditingController();
                        selectDate(context, endDate, startDate: selectedDate);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
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
                                endDate.value.text != ''
                                    ? endDate.value.text
                                    : "Select Date",
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Description",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff5A5F73)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      controller: descController,
                      maxLine: 6,
                      hintText:
                          'You can mention your Grades, Achievements, Activities or subjects you are studying ',
                    ),
                  ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: const Text(
                      "Featured image*",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff5A5F73)),
                  ),
                   ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        final picker = ImagePicker();
                        final pickedFileC = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 100,
                        );
                        if (pickedFileC != null) {
                          setState(() {
                            uploadImg = File(pickedFileC.path);
                          });
                        } else if (Platform.isAndroid) {
                          final LostData response = await picker.getLostData();
                        }
                      },
                      child: Row(
                        children: [
                          ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: <Color>[
                                      ColorConstants.GRADIENT_ORANGE,
                                      ColorConstants.GRADIENT_RED
                                    ]).createShader(bounds);
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/images/upload_icon.svg'),
                                  Text(
                                    "Upload Image",
                                    style: Styles.bold(size: 12),
                                  ),
                                ],
                              )),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                              uploadImg != null
                                  ? '${uploadImg?.path.split('/').last}'
                                  : "Supported Format: .pdf, .doc, .jpeg",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff929BA3))),
                        ],
                      ),
                    ),
                  ),
                  PortfolioCustomButton(
                    clickAction: () async{
                      Map<String, dynamic> data = Map();

                        try {
                        String? fileName = uploadImg?.path.split('/').last;
                        data['certificate'] = await MultipartFile.fromFile(
                            '${uploadImg?.path}',
                            filename: fileName);
                      } catch (e) {
                        print('something is wrong $e');
                      }
            
                      data["activity_type"] = "Education";   
                      data["title"] = degreeController.value.text;
                      data["description"] = descController.value.text;
                      data["start_date"] =startDate.value.text;
                      data["end_date"] = endDate.value.text;
                      data["institute"] = schoolController.value.text;
                      data["professional_key"] = widget.isEditMode == true ? "education_${widget.education?.id}":   "new_professional"; 
                      data["edit_url_professional"] = "";
                      addEducation(data);
                    },
                  )
                ]))))));
  }
  void addEducation(Map<String, dynamic> data) {
    BlocProvider.of<HomeBloc>(context).add(AddActivitiesEvent(data: data));
  }
  void handleAddEducation(AddActivitiesState state) {
     var addActivitiesState = state;
    setState(() {
      switch (addActivitiesState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading Add Education....................");
          isAddEducationLoading = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Add Education....................");
          isAddEducationLoading = false;
          Navigator.pop(context);
          break;
        case ApiStatus.ERROR:
          Log.v("Error Add Education....................");
          isAddEducationLoading = false;
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
