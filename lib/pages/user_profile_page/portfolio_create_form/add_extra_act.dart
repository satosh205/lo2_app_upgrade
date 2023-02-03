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

class AddActivities extends StatefulWidget {
  final bool? isEditMode;
  final CommonProfession? activity;
  const AddActivities({Key? key, this.isEditMode = false, this.activity}) : super(key: key);

  @override
  State<AddActivities> createState() => _AddActivitiesState();
}

class _AddActivitiesState extends State<AddActivities> {
  TextEditingController activitytitleController = TextEditingController();
  TextEditingController organizationController = TextEditingController();
  TextEditingController activityController = TextEditingController();
  TextEditingController descController = TextEditingController();
   TextEditingController startDate =  TextEditingController();
  DateTime selectedDate = DateTime.now();

  File? uploadImg;
  File? img;
  bool? isAddActivitiesLoading = false;

  @override
  void initState() {
    updateValue();
    super.initState();
  }

  void updateValue(){
    if(widget.isEditMode == true){
      activitytitleController = 

       activitytitleController =
          TextEditingController(text: widget.activity?.title);
   organizationController = TextEditingController(text: widget.activity?.institute);
   activityController = TextEditingController(text: widget.activity?.activityType);
   descController = TextEditingController(text: widget.activity?.description);
   startDate = TextEditingController(text: widget.activity?.startDate);



    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (value) {},
      child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) async {
            if (state is AddActivitiesState) handleAddActivities(state);
          },
          child: Scaffold(
              body: ScreenWithLoader(
            isLoading: isAddActivitiesLoading,
            body: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Container(
                    height: height(context) * 0.9,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 85.0),
                            child: Text(
                              "Add Extra Curricular Activities",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                          Spacer(),
                         IconButton(onPressed: (){
                          Navigator.pop(context);
                         }, icon:  Icon(Icons.close)),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    "Activity Title*",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff5A5F73)),
                                  ),
                                ),
                    
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomTextField(
                                      controller: activitytitleController,
                                      hintText: 'Ex. Man of the match'),
                                ),
                    
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Associated Organisation Name*",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff5A5F73)),
                                  ),
                                ),
                    
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomTextField(
                                      controller: organizationController,
                                      hintText:
                                          'Ex. College, Company, NGO, Others'),
                                ),
                    
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Activity Type*",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff5A5F73)),
                                  ),
                                ),
                    
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomTextField(
                                      controller: activityController,
                                      hintText:
                                          'Ex: Sports, Acting, Event Management'),
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
                                                  color: Color(0xff929BA3)),
                                            ),
                                          ),
                                          // Icon(Icons.edit_calendar_outlined)
                    
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
                                SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: descController,
                                  maxLine: 6,
                                  hintText: 'Describe your work or achievement',
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Featured image",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff5A5F73)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
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
                                          uploadImg = File(pickedFileC.path);
                                        });
                                      } else if (Platform.isAndroid) {
                                        final LostData response =
                                            await picker.getLostData();
                                      }
                                    },
                                    child: InkWell(
                                      onTap: ()async{
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
                                                      Color(0xfffc7804),
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
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                PortfolioCustomButton(
                                  clickAction: () async {
            
            
                                    Map<String, dynamic> data = Map();
                                    try {
                                      String? fileName =
                                          uploadImg?.path.split('/').last;
                                      data['certificate'] =
                                          await MultipartFile.fromFile(
                                              '${uploadImg?.path}',
                                              filename: fileName);
                                    } catch (e) {
                                      print('something is wrong $e');
                                    }
            
            
                                data["activity_type"] = 'extra_activities';  
            data["title"] = activitytitleController.value.text;
            data["description"] = descController.value.text;
            data["start_date"] = startDate.value.text;
            data["professional_key"] =  
            widget.isEditMode == true
                 ? "activity_${widget.activity?.id}"
                : "new_professional";
            data["institute"] = organizationController.value.text;
            data["edit_url_professional"] = widget.isEditMode == true && uploadImg?.path == null ? widget.activity?.imageName:"";
            data['curricular_type'] =  activityController.value.text;
            
            
            
                                 
                    
                          
                    
                                    addActivities(data);
                                  },
                                )
                              ]))
                    ])))),
          ))),
    );
  }

  void addActivities(Map<String, dynamic> data) {
    BlocProvider.of<HomeBloc>(context).add(AddActivitiesEvent(data: data));
  }

  void handleAddActivities(AddActivitiesState state) {
    var addActivitiesState = state;
    setState(() {
      switch (addActivitiesState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading Add Activities....................");
          isAddActivitiesLoading = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Add Activities....................");
          isAddActivitiesLoading = false;
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Activities added"),
          ));
          Navigator.pop(context);
          break;
        case ApiStatus.ERROR:
          Log.v("Error Add Activities....................");
          isAddActivitiesLoading = false;
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
