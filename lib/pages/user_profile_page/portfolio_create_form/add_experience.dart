import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/new_portfolio_response.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';

class AddExperience extends StatefulWidget {
  final bool? isEditMode;
  final CommonProfession? experience;

  const AddExperience({Key? key, this.isEditMode,  this.experience}) : super(key: key);

  @override
  State<AddExperience> createState() => _AddExperienceState();
}

class _AddExperienceState extends State<AddExperience> {
  TextEditingController titleController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String employmentType = "";
  bool? isclicked = false;
  TextEditingController? startDate = TextEditingController();
  TextEditingController? endDate = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool? isAddExperienceLoading = false;
  File? uploadCerti;


  final _formKey = GlobalKey<FormState>();
  File? file;

  @override
  void initState() {
 if(widget.isEditMode == true){
     titleController = TextEditingController(text: '${widget.experience?.title}');
nameController = TextEditingController(text: '${widget.experience?.institute}');
descController = TextEditingController(text: '${widget.experience?.description}');
startDate = TextEditingController(text: '${widget.experience?.startDate}');
endDate = TextEditingController(text: '${widget.experience?.endDate}');
employmentType = '${widget.experience?.employmentType}';
   isclicked  = widget.experience?.currentlyWorkHere.length == 0 ? false : true;
 }

 
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (value) {},
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) async {
              if (state is AddActivitiesState) handleAddExperience(state);
            },
            child: SafeArea(
              child: Scaffold(
                  body: ScreenWithLoader(
                isLoading: isAddExperienceLoading,
                body: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                        height: height(context) * 0.9,
                        child: SingleChildScrollView(
                            child: Form(
                          key: _formKey,
                          child: Column(children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 130.0),
                                  child: Text(
                                    "Add Experience",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: Icon(Icons.close)),
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      const Text(
                                        "Position Title*",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff5A5F73)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      CustomTextField(
                                          validate: true,
                                          validationString:
                                              'please enter position title',
                                          controller: titleController,
                                          hintText: 'Ex. Ui Designer'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Company Name*",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff5A5F73)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      CustomTextField(
                                          validate: true,
                                          validationString:
                                              'plese enter company name',
                                          controller: nameController,
                                          hintText: 'Ex: Google, Microsoft'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Employment type*",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff5A5F73)),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Radio(
                                              value: "full_time",
                                              groupValue: employmentType,
                                              onChanged: (value) {
                                                setState(() {
                                                  employmentType =
                                                      value.toString();
                                                });
                                              }),
                                          Text("Full-Time"),
                                          Radio(
                                              value: "part_time",
                                              groupValue: employmentType,
                                              onChanged: (value) {
                                                setState(() {
                                                  employmentType =
                                                      value.toString();
                                                });
                                              }),
                                          Text("Part-Time"),
                                          Radio(
                                              value: "internship",
                                              groupValue: employmentType,
                                              onChanged: (value) {
                                                setState(() {
                                                  employmentType =
                                                      value.toString();
                                                });
                                              }),
                                          Text("Internship"),
                                        ],
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
                                            selectDate(context, startDate!);
                                          } catch (e) {
                                            startDate = TextEditingController();
                                            selectDate(context, startDate!);
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
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10.0)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  startDate!.value.text != ''
                                                      ? startDate!.value.text
                                                      : "Select Date",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff929BA3)),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),

                                                child: SvgPicture.asset(
                                                    'assets/images/selected_calender.svg'),
                                                // ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                              value: isclicked,
                                              onChanged: (bool) {
                                                setState(() {
                                                  isclicked = bool;
                                                });
                                              }),
                                          Text("I currently work here",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff929BA3)))
                                        ],
                                      ),
                                      Text(
                                        "End date (or expected)",
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
                                            selectDate(context, endDate!,
                                                startDate: selectedDate);
                                          } catch (e) {
                                            endDate = TextEditingController();
                                            selectDate(context, endDate!,
                                                startDate: selectedDate);
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
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10.0)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  endDate != null
                                                      ? endDate!.value.text
                                                      : "Select Date",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff929BA3)),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),

                                                child: SvgPicture.asset(
                                                    'assets/images/selected_calender.svg'),
                                                // ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
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
                                      CustomTextField(
                                        controller: descController,
                                        maxLine: 6,
                                        hintText:
                                            'Describe your work or achievement',
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
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
                                            SvgPicture.asset(
                                                'assets/images/upload_icon.svg'),
                                            Text(
                                              "Upload Image",
                                              style: Styles.bold(size: 12),
                                            ),
                                          ],
                                        )),
                                    
                                    ]))),

                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                        uploadCerti != null
                                            ? '${ uploadCerti?.path.split('/').last}'
                                            : "Supported Format: .pdf, .doc, .jpeg",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff929BA3))),

                                    PortfolioCustomButton(
                                        clickAction: () async {
                                          if (employmentType == "") {
                                            const SnackBar(
                                                content: Text(
                                                    'Please choose employment type*'));
                                          } else if (startDate?.value.text ==
                                              '') {
                                            const SnackBar(
                                                content: Text(
                                                    'Please choose start date'));
                                          } else if (_formKey.currentState!
                                              .validate()) {
                                            Map<String, dynamic> data = Map();
                                     
                                            try {

                                              if (widget.isEditMode == true) {
                                               
                                                if ( uploadCerti?.path != null) {
                                                
                                                  String? fileName = uploadCerti
                                                      ?.path
                                                      .split('/')
                                                      .last;
                                                 
                                                  data['certificate'] =
                                                      await MultipartFile.fromFile(
                                                          '${uploadCerti?.path}',
                                                          filename: fileName);
                                                }
                                              } else {
                                                String? fileName = uploadCerti
                                                    ?.path
                                                    .split('/')
                                                    .last;
                                                
                                                data['certificate'] =
                                                    await MultipartFile.fromFile(
                                                        '${uploadCerti?.path}',
                                                        filename: fileName);
                                              }
                                              data["activity_type"] =
                                                  'Experience';
                                              data["title"] =
                                                  titleController.value.text;
                                              data["description"] =
                                                  descController.value.text;
                                              data["start_date"] =
                                                  startDate?.value.text;
                                              data["end_date"] =
                                                  endDate?.value.text;
                                              data["institute"] =
                                                  nameController.value.text;
                                              data["professional_key"] =
                                                  'new_professional';
                                              data["edit_url_professional"] = widget.isEditMode == true ? '${widget.experience?.imageName}':  '' ;
                                              data['curricular_type'] =
                                                  employmentType;
                                                  data['currently_work_here'] = isclicked;

                                              addExperience(data);
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Please upload file')),
                                              );
                                            }
                                          }
                                        },
                                      )
                          ]),
                        ))]),
              )),
            )))))));
  }

  void addExperience(Map<String, dynamic> data) {
    print(data);
    BlocProvider.of<HomeBloc>(context).add(AddActivitiesEvent(data: data));
  }

  void handleAddExperience(AddActivitiesState state) {
    var addExperienceState = state;
    setState(() {
      switch (addExperienceState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading Add Experience....................");
          isAddExperienceLoading = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Add Experience....................");
          isAddExperienceLoading = false;
          Navigator.pop(context);
          break;
        case ApiStatus.ERROR:
          Log.v("Error Add Experience....................");
          isAddExperienceLoading = false;
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
        controller.text = Utility.convertDateFormat(selectedDate, format: 'yyyy-MM-dd');
      });
  }
}
