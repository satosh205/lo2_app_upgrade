import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_portfolio.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/utility.dart';

class AddEducation extends StatefulWidget {
  const AddEducation({Key? key}) : super(key: key);

  @override
  State<AddEducation> createState() => _AddEducationState();
}

class _AddEducationState extends State<AddEducation> {
  TextEditingController? titleController;
   TextEditingController? degreeController;
  TextEditingController? descController;
  TextEditingController? startDate;
  TextEditingController? endDate;
  DateTime selectedDate = DateTime.now();
  bool? isAddEducationLoading;
  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (value) {},
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) async {
              if (state is AddEducationState) handleAddEducation(state);
            },
    child:Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 50.0),
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
                      SizedBox(width: 70),
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
                        controller: titleController,
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
                                startDate != null
                                    ? startDate!.value.text
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
                        selectDate(context, endDate!, startDate: selectedDate);
                      } catch (e) {
                        endDate = TextEditingController();
                        selectDate(context, endDate!, startDate: selectedDate);
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
                                endDate != null
                                    ? endDate!.value.text
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
                  PortfolioCustomButton(
                    clickAction: () async{
                      

                    },
                  )
                ]))))));
  }
  void addEducation(Map<String, dynamic> data) {
    // print(data);
    BlocProvider.of<HomeBloc>(context).add(AddEducationEvent(data: data));
  }
  void handleAddEducation(AddEducationState state) {
     var addEducationState = state;
    setState(() {
      switch (addEducationState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading Add Education....................");
          isAddEducationLoading = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Add Education....................");
          isAddEducationLoading = false;
          // Navigator.pop(context);
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
