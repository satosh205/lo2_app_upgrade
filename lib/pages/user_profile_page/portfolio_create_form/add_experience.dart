import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

  const AddExperience({Key? key, this.isEditMode, this.experience})
      : super(key: key);

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
    if (widget.isEditMode == true) {
      titleController =
          TextEditingController(text: '${widget.experience?.title}');
      nameController =
          TextEditingController(text: '${widget.experience?.institute}');
      descController =
          TextEditingController(text: '${widget.experience?.description}');
      startDate =
          TextEditingController(text: '${widget.experience?.startDate}');
      endDate = TextEditingController(text: '${widget.experience?.endDate}');
      employmentType = '${widget.experience?.employmentType}';
      isclicked = widget.experience?.currentlyWorkHere == 'true' ||
              widget.experience?.currentlyWorkHere == 'on'
          ? true
          : false;
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
            child: Scaffold(
                backgroundColor: ColorConstants.WHITE,
                appBar: AppBar(
                  backgroundColor: ColorConstants.WHITE,
                  elevation: 0,
                  leading: SizedBox(),
                  centerTitle: true,
                  title: Text(
                    widget.isEditMode == true
                        ? "Edit Experience"
                        : "Add Experience",
                    style: Styles.bold(size: 14, color: Color(0xff0E1638)),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_outlined,
                            color: Color(0xff0E1638))),
                  ],
                ),
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
                              // Row(
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.only(left: 130.0),
                              //       child: Text(
                              //         "Add Experience",
                              //         style: TextStyle(
                              //             fontSize: 14,
                              //             fontWeight: FontWeight.w600,
                              //             color: Colors.black),
                              //       ),
                              //     ),
                              //     Spacer(),
                              //     IconButton(
                              //         onPressed: () => Navigator.pop(context),
                              //         icon: Icon(Icons.close)),
                              //   ],
                              // ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 14),
                                  child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Position Title*",
                                            style: Styles.regular(
                                                size: 14,
                                                color: Color(0xff0E1638)),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          CustomTextField(
                                              validate: true,
                                              maxChar: 50,
                                              validationString:
                                                  'please enter position title',
                                              controller: titleController,
                                              hintText: 'Ex. Ui Designer'),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Company Name*",
                                            style: Styles.regular(
                                                size: 14,
                                                color: Color(0xff0E1638)),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          CustomTextField(
                                              validate: true,
                                              maxChar: 50,
                                              validationString:
                                                  'Please enter company name',
                                              controller: nameController,
                                              hintText:
                                                  'Ex: Google, Microsoft'),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Employment type*",
                                            style: Styles.regular(
                                                size: 14,
                                                color: Color(0xff0E1638)),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Radio(
                                                  visualDensity:
                                                      const VisualDensity(
                                                    horizontal: VisualDensity
                                                        .minimumDensity,
                                                  ),
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  value: "full_time",
                                                  groupValue: employmentType,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      employmentType =
                                                          value.toString();
                                                    });
                                                  }),
                                              SizedBox(
                                                width: width(context) * 0.02,
                                              ),
                                              Text("Full-Time"),
                                              Spacer(),
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
                                              Spacer(),
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
                                            style: Styles.regular(
                                                size: 14,
                                                color: Color(0xff0E1638)),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              try {
                                                selectDate(context, startDate!);
                                              } catch (e) {
                                                startDate =
                                                    TextEditingController();
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
                                                    color: const Color.fromARGB(
                                                        255, 142, 142, 142)),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10.0)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      startDate!.value.text !=
                                                              ''
                                                          ? startDate!
                                                              .value.text
                                                          : "Select Date",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: startDate!
                                                                      .value
                                                                      .text !=
                                                                  ''
                                                              ? ColorConstants
                                                                  .BLACK
                                                              : Color(
                                                                  0xff929BA3)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                  visualDensity:
                                                      const VisualDensity(
                                                    horizontal: VisualDensity
                                                        .minimumDensity,
                                                  ),
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  value: isclicked,
                                                  onChanged: (bool) {
                                                    setState(() {
                                                      isclicked = bool;
                                                    });
                                                  }),
                                              Text("  I currently work here",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff929BA3)))
                                            ],
                                          ),
                                          Text(
                                            "End date (or expected)",
                                            style: Styles.regular(
                                                size: 14,
                                                color: Color(0xff0E1638)),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (isclicked == true) return;
                                              if (startDate!.value.text == '') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Please choose start date first')),
                                                );
                                              }
                                              try {
                                                selectDate(context, endDate!,
                                                    startDate: selectedDate);
                                              } catch (e) {
                                                endDate =
                                                    TextEditingController();
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
                                                    color: const Color.fromARGB(
                                                        255, 142, 142, 142)),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10.0)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      endDate!.value.text !=
                                                                  '' &&
                                                              isclicked == false
                                                          ? endDate!.value.text
                                                          : "Select Date",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: endDate!.value
                                                                      .text !=
                                                                  ''
                                                              ? ColorConstants
                                                                  .BLACK
                                                              : Color(
                                                                  0xff929BA3)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                              "Description*",
                                              style: Styles.regular(
                                                  size: 14,
                                                  color: Color(0xff0E1638)),
                                            ),
                                          ),
                                          CustomTextField(
                                            controller: descController,
                                            maxLine: 6,
                                            validate: true,
                                            maxChar: 500,
                                            validationString:
                                                'Please enter describe',
                                            hintText:
                                                'Describe your work or achievement',
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text('Featured Image*',
                                                  style: Styles.regular(
                                                      size: 14,
                                                      color:
                                                          Color(0xff0E1638)))),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                  onTap: () async {
                                                    FilePickerResult? result;

                                                    if (Platform.isIOS) {
                                                      result = await FilePicker
                                                          .platform
                                                          .pickFiles(
                                                        allowMultiple: false,
                                                        type: FileType.image,
                                                      );
                                                      if (result != null)
                                                        setState(() {
                                                          uploadCerti = File(
                                                              result!.files
                                                                  .first.path!);
                                                        });
                                                    } else {
                                                      final pickedFileC =
                                                          await ImagePicker()
                                                              .pickImage(
                                                        source:
                                                            ImageSource.gallery,
                                                        imageQuality: 100,
                                                      );
                                                      if (pickedFileC != null) {
                                                        setState(() {
                                                          uploadCerti = File(
                                                              pickedFileC.path);
                                                        });
                                                      }
                                                    }
                                                    // final picker = ImagePicker();
                                                    // final pickedFileC =
                                                    //     await ImagePicker().pickImage(
                                                    //   source: ImageSource.gallery,
                                                    //   imageQuality: 100,
                                                    // );
                                                    // if (pickedFileC != null) {
                                                    //   setState(() {

                                                    //     uploadCerti = File(pickedFileC.path);
                                                    //   });
                                                    // } else if (Platform.isAndroid) {
                                                    //   final LostData response =
                                                    //       await picker.getLostData();
                                                    // }
                                                  },
                                                  child: Row(children: [
                                                    ShaderMask(
                                                        blendMode:
                                                            BlendMode.srcIn,
                                                        shaderCallback:
                                                            (Rect bounds) {
                                                          return LinearGradient(
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                              colors: <Color>[
                                                                ColorConstants
                                                                    .GRADIENT_ORANGE,
                                                                ColorConstants
                                                                    .GRADIENT_RED
                                                              ]).createShader(
                                                              bounds);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                                'assets/images/upload_icon.svg'),
                                                            Text(
                                                              "Upload Image  ",
                                                              style:
                                                                  Styles.bold(
                                                                      size: 12),
                                                            ),
                                                          ],
                                                        )),
                                                    Text(
                                                      uploadCerti != null
                                                          ? ' ${uploadCerti?.path.split('/').last}'
                                                          : widget.experience
                                                                  ?.imageName ??
                                                              " Supported Files: .jpeg, .png, .jpg",
                                                      style: Styles.regular(
                                                          size: 10,
                                                          color: Color(
                                                              0xff0E1638)),
                                                    ),
                                                  ]))),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          PortfolioCustomButton(
                                            clickAction: () async {
                                              DateTime startD = DateFormat(
                                                      "yyyy-MM-dd")
                                                  .parse(
                                                      '${startDate?.value.text}');
                                              DateTime endD = DateFormat(
                                                      "yyyy-MM-dd")
                                                  .parse(
                                                      '${endDate?.value.text}');

                                              if (startD.isAfter(endD) ||
                                                  startD == endD) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'End date must be grater than start date')));
                                                return;
                                              }

                                              if (!_formKey.currentState!
                                                  .validate()) return;
                                              print(
                                                  'employmentType=== ${employmentType}');
                                              if (employmentType == "") {
                                                print('employmentType=== if');

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Please choose employment type')),
                                                );
                                              } else if (startDate
                                                      ?.value.text ==
                                                  '') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Please choose start date')),
                                                );
                                              } else if (_formKey.currentState!
                                                  .validate()) {
                                                Map<String, dynamic> data =
                                                    Map();

                                                try {
                                                  if (widget.isEditMode ==
                                                      true) {
                                                    if (uploadCerti?.path !=
                                                        null) {
                                                      String? fileName =
                                                          uploadCerti?.path
                                                              .split('/')
                                                              .last;

                                                      data['certificate'] =
                                                          await MultipartFile
                                                              .fromFile(
                                                                  '${uploadCerti?.path}',
                                                                  filename:
                                                                      fileName);
                                                    }
                                                  } else {
                                                    String? fileName =
                                                        uploadCerti?.path
                                                            .split('/')
                                                            .last;

                                                    data['certificate'] =
                                                        await MultipartFile
                                                            .fromFile(
                                                                '${uploadCerti?.path}',
                                                                filename:
                                                                    fileName);
                                                  }
                                                  data["activity_type"] =
                                                      'Experience';
                                                  data["title"] =
                                                      titleController
                                                          .value.text;
                                                  data["description"] =
                                                      descController.value.text;
                                                  data["start_date"] =
                                                      startDate?.value.text;
                                                  data["end_date"] =
                                                      endDate?.value.text;
                                                  data["institute"] =
                                                      nameController.value.text;
                                                  data[
                                                      "professional_key"] = widget
                                                              .isEditMode ==
                                                          true
                                                      ? "experience_${widget.experience?.id}"
                                                      : 'new_professional';
                                                  data["edit_url_professional"] =
                                                      widget.isEditMode == true
                                                          ? '${widget.experience?.imageName}'
                                                          : '';
                                                  data['employment_type'] =
                                                      employmentType;
                                                  data['currently_work_here'] =
                                                      isclicked;

                                                  addExperience(data);
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Please add feature image')),
                                                  );
                                                }
                                              }
                                            },
                                          )
                                        ]),
                                  ))
                            ]),
                          )),
                        ))))));
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(widget.isEditMode == true
                    ? 'Experience updated'
                    : 'Experience added')),
          );
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
        controller.text =
            Utility.convertDateFormat(selectedDate, format: 'yyyy-MM-dd');
      });
  }
}
