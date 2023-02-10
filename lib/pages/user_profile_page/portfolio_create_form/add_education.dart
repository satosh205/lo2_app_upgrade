import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';

class AddEducation extends StatefulWidget {
  final CommonProfession? education;

  final bool? isEditMode;
  const AddEducation({Key? key, this.isEditMode = false, this.education})
      : super(key: key);

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
  bool isAddEducationLoading = false;
  File? uploadImg;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    setValues();
    super.initState();
  }

  void setValues() {
    if (widget.isEditMode == true) {
      schoolController =
          TextEditingController(text: widget.education?.institute);
      degreeController = TextEditingController(text: widget.education?.title);
      descController =
          TextEditingController(text: widget.education?.description);
      startDate = TextEditingController(text: widget.education?.startDate);
      endDate = TextEditingController(text: widget.education?.endDate);
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
            child: Scaffold(
                backgroundColor: ColorConstants.WHITE,
                appBar: AppBar(
                  backgroundColor: ColorConstants.WHITE,
                  elevation: 0,
                  leading: SizedBox(),
                  centerTitle: true,
                  title: Text(
                      widget.isEditMode == true
                          ? 'Edit Education'
                          : 'Add Education',
                      style: Styles.bold(size: 14)),
                  actions: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_outlined,
                            color: Color(0xff0E1638))),
                  ],
                ),
                body: ScreenWithLoader(
                  isLoading: isAddEducationLoading,
                  body: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: SingleChildScrollView(
                            child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row(
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.only(left: 130.0),
                                //       child: Text(widget.isEditMode == true ? 'Edit Education' :  'Add Education',
                                //           style: Styles.bold(size: 14)),
                                //     ),
                                //     // SizedBox(width: width(context) * 0.2),
                                //     Spacer(),
                                //     IconButton(
                                //       onPressed: () => Navigator.pop(context),
                                //       icon: Icon(
                                //         Icons.close,
                                //         color: Colors.black,
                                //       ),
                                //     )
                                //   ],
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "School*",
                                    style: Styles.regular(
                                        size: 14, color: Color(0xff0E1638)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomTextField(
                                      validate: true,
                                      validationString: 'Please enter School',
                                      controller: schoolController,
                                      maxChar: 50,
                                      hintText:
                                          'Ex. Middle East College (MEC), Muscat, Oman'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Degree*",
                                    style: Styles.regular(
                                        size: 14, color: Color(0xff0E1638)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomTextField(
                                      validate: true,
                                      validationString: 'Please enter Degree*',
                                      controller: degreeController,
                                      maxChar: 50,
                                      hintText:
                                          'Ex: Bachelor\'s of Instrumentation'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Start Date*",
                                    style: Styles.regular(
                                        size: 14, color: Color(0xff0E1638)),
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
                                              startDate.value.text != ''
                                                  ? startDate.value.text
                                                  : "Select Date",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color:startDate.value.text != '' ? ColorConstants.BLACK:  Color(0xff929BA3)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
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
                                    style: Styles.regular(
                                        size: 14, color: Color(0xff0E1638)),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (startDate.value.text != '') {
                                      try {
                                        selectDate(context, endDate,
                                            startDate: selectedDate);
                                      } catch (e) {
                                        endDate = TextEditingController();
                                        selectDate(context, endDate,
                                            startDate: selectedDate);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Please choose start date first'),
                                      ));
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
                                              endDate.value.text != ''
                                                  ? endDate.value.text
                                                  : "Select Date",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color:endDate.value.text != '' ? ColorConstants.BLACK:  Color(0xff929BA3)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
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
                                    style: Styles.regular(
                                        size: 14, color: Color(0xff0E1638)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomTextField(
                                    validate: true,
                                    validationString:
                                        'Please enter Description',
                                    controller: descController,
                                    maxLine: 6,
                                    maxChar: 500,
                                    hintText:
                                        'You can mention your Grades, Achievements, Activities or subjects you are studying ',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Featured image*",
                                    style: Styles.regular(
                                        size: 14, color: Color(0xff0E1638)),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () async {
                                      // final picker = ImagePicker();
                                      // final pickedFileC =
                                      //     await ImagePicker().pickImage(
                                      //   source: ImageSource.gallery,
                                      //   imageQuality: 100,
                                      // );
                                      // if (pickedFileC != null) {
                                      //   setState(() {
                                      //     uploadImg = File(pickedFileC.path);
                                      //   });
                                      // } else if (Platform.isAndroid) {
                                      //   final LostData response =
                                      //       await picker.getLostData();
                                      // }

                                      FilePickerResult? result;

                                      if (Platform.isIOS) {
                                        result =
                                            await FilePicker.platform.pickFiles(
                                          allowMultiple: false,
                                          type: FileType.image,
                                        );
                                        if (result != null)
                                          setState(() {
                                            uploadImg =
                                                File(result!.files.first.path!);
                                          });
                                      } else {
                                        final pickedFileC =
                                            await ImagePicker().pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 100,
                                        );
                                        if (pickedFileC != null) {
                                          setState(() {
                                            uploadImg = File(pickedFileC.path);
                                          });
                                        }
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
                                                    ColorConstants
                                                        .GRADIENT_ORANGE,
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
                                        SizedBox(
                                          width: 4,
                                        ),
                                        SizedBox(
                                          width: width(context) * 0.6,
                                          child: Text(
                                              uploadImg != null
                                                  ? '${uploadImg?.path.split('/').last}'
                                                  : widget.education
                                                          ?.imageName ??
                                                      "Supported Files: .jpeg, .png, .jpg",
                                              maxLines: 2,
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff929BA3))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                PortfolioCustomButton(
                                  clickAction: () async {
                                    if(!_formKey.currentState!
                                        .validate())return;
                                        
                                           if (startDate.value.text == '') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please choose start date')),
                                      );
                                    } 
                                    else if(endDate.value.text == ''){
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please choose end date')),
                                      );
                                    }
                                    else if (_formKey.currentState!
                                        .validate()) {
                                      Map<String, dynamic> data = Map();

                                      try {
                                        if (widget.isEditMode == true) {
                                          if (uploadImg?.path != null) {
                                            String? fileName =
                                                uploadImg?.path.split('/').last;
                                            data['certificate'] =
                                                await MultipartFile.fromFile(
                                                    '${uploadImg?.path}',
                                                    filename: fileName);
                                          }
                                        } else if (startDate.value.text == '') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Please select start date'),
                                          ));
                                        } else {
                                          String? fileName =
                                              uploadImg?.path.split('/').last;
                                          data['certificate'] =
                                              await MultipartFile.fromFile(
                                                  '${uploadImg?.path}',
                                                  filename: fileName);
                                        }
                                        data["activity_type"] = "Education";
                                        data["title"] =
                                            degreeController.value.text;
                                        data["description"] =
                                            descController.value.text;
                                        data["start_date"] =
                                            startDate.value.text;
                                        data["end_date"] = endDate.value.text;
                                        data["institute"] =
                                            schoolController.value.text;
                                        data["professional_key"] = widget
                                                    .isEditMode ==
                                                true
                                            ? "education_${widget.education?.id}"
                                            : "new_professional";
                                        data["edit_url_professional"] =
                                            widget.isEditMode == true &&
                                                    uploadImg?.path == null
                                                ? widget.education?.imageName
                                                : "";

                                        addEducation(data);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Please add feature image')),
                                        );
                                      }
                                    }
                                  },
                                )
                              ]),
                        ))),
                  ),
                ))));
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
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text(widget.isEditMode == true ?'Education updated' : 'Education added'),
            ));
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
        controller.text =
            Utility.convertDateFormat(selectedDate, format: 'yyyy-MM-dd');
      });
  }
}
