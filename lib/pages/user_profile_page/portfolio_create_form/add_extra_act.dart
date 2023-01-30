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
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';

class AddActivities extends StatefulWidget {
  const AddActivities({Key? key}) : super(key: key);

  @override
  State<AddActivities> createState() => _AddActivitiesState();
}

class _AddActivitiesState extends State<AddActivities> {
  final activitytitleController = TextEditingController();
  final nametitleController = TextEditingController();
  final typetitleController = TextEditingController();
  TextEditingController? startDate;
  TextEditingController? endDate;
  DateTime selectedDate = DateTime.now();

  File? uploadImg;
  File? img;
  bool? isAddActivitiesLoading;
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
                padding: const EdgeInsets.only(top: 50.0),
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
                          SizedBox(
                            width: 50,
                          ),
                          Icon(Icons.close),
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
                                      controller: nametitleController,
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
                                      controller: typetitleController,
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
                                      selectDate(context, startDate!);
                                    } catch (e) {
                                      startDate = TextEditingController();
                                      selectDate(context, startDate!);
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
                                              startDate != null
                                                  ? startDate!.value.text
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
                                            child: InkWell(
                                              onTap: (() async {
                                                DateTime? datePiked =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            (DateTime(2021)),
                                                        lastDate:
                                                            DateTime(2050));
                                                if (datePiked != null) {
                                                  print(
                                                      'Date Selected : ${datePiked.day}--${datePiked.month}--${datePiked.year}');
                                                }
                                              }),
                                              child: SvgPicture.asset(
                                                  'assets/images/selected_calender.svg'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // CustomDescription(
                                //   hintText: 'Describe your work or achievement',
                                // ),
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
                                SizedBox(
                                  height: 5,
                                ),
                                PortfolioCustomButton(
                                  clickAction: () async {
                                    Map<String, dynamic> data = Map();
                                    try {
                                      String? fileName =
                                          img?.path.split('/').last;
                                      data['portfolio_image'] =
                                          await MultipartFile.fromFile(
                                              '${img?.path}',
                                              filename: fileName);
                                    } catch (e) {
                                      print('something is wrong $e');
                                    }
                                    // print('agaoni cliked');

                                    // data['portfolio_title'] =
                                    //     titleController.value.text;

                                    data['activity_title'] =
                                        activitytitleController.value.text;
                                    data['Organisation_title'] =
                                        nametitleController.value.text;
                                    data['activityType_title'] =
                                        typetitleController.value.text;
                                    data['select_date'] =
                                        data['edit_image_type'] = '';

                                    addActivities(data);
                                  },
                                )
                              ]))
                    ])))),
          ))),
    );
  }

  void addActivities(Map<String, dynamic> data) {
    // print(data);
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
          // Navigator.pop(context);
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
