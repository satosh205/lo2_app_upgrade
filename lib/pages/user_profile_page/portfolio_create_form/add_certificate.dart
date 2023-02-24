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

class AddCertificate extends StatefulWidget {
  final bool? isEditMode;
  final CommonProfession? cetificate;
  const AddCertificate({Key? key, this.isEditMode = false, this.cetificate})
      : super(key: key);

  @override
  State<AddCertificate> createState() => _AddCertificateState();
}

class _AddCertificateState extends State<AddCertificate> {
  TextEditingController titleController = TextEditingController();
  TextEditingController startDate = TextEditingController();
  DateTime selectedDate = DateTime.now();

  File? uploadCerti;
  bool? isAddCertificateLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    updateData();
    super.initState();
  }

  void updateData() {
    if (widget.isEditMode == true) {
      titleController =
          TextEditingController(text: '${widget.cetificate?.title}');
      startDate =
          TextEditingController(text: '${widget.cetificate?.startDate}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (value) {},
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) async {
              if (state is AddActivitiesState) handleAddCertificate(state);
            },
            child: SafeArea(
              child: Scaffold(
                  backgroundColor: ColorConstants.WHITE,
                  appBar: AppBar(
                    backgroundColor: ColorConstants.WHITE,
                    elevation: 0,
                    leading: SizedBox(),
                    centerTitle: true,
                    title: Text(
                      widget.isEditMode == true
                          ? "Edit Certificate"
                          : "Add Certificate",
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
                    isLoading: isAddCertificateLoading,
                    body: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Container(
                        height: height(context) * 0.6,
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Row(
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.only(left: 130.0),
                                //       child: Text(
                                //         "",
                                //         style: TextStyle(
                                //             fontSize: 14,
                                //             fontWeight: FontWeight.w600,
                                //             color: Colors.black),
                                //       ),
                                //     ),
                                //     Spacer(),
                                //     IconButton(
                                //         onPressed: () {
                                //           Navigator.pop(context);
                                //         },
                                //         icon: Icon(Icons.close)),
                                //   ],
                                // ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Text(
                                            "Certificate Title*",
                                            style: Styles.regular(
                                                size: 14,
                                                color: Color(0xff0E1638)),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          CustomTextField(
                                              validate: true,
                                              validationString:
                                                  'plese enter title',
                                              controller: titleController,
                                              maxChar: 60,
                                              hintText:
                                                  'Type project title here'),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Date of Receiving*",
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
                                                selectDate(context, startDate);
                                              } catch (e) {
                                                startDate =
                                                    TextEditingController();
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
                                                      startDate.value.text != ""
                                                          ? startDate.value.text
                                                          : "Select Date",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: startDate.value
                                                                      .text !=
                                                                  ""
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
                                                    await ImagePicker()
                                                        .pickImage(
                                                  source: ImageSource.gallery,
                                                  imageQuality: 100,
                                                );
                                                if (pickedFileC != null) {
                                                  setState(() {
                                                    uploadCerti =
                                                        File(pickedFileC.path);
                                                  });
                                                } else if (Platform.isAndroid) {
                                                  final LostData response =
                                                      await picker
                                                          .getLostData();
                                                }
                                              },
                                              uploadText: 'Upload Certificate'),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                  uploadCerti != null
                                                      ? '${uploadCerti?.path.split('/').last}'
                                                      : widget.cetificate
                                                              ?.imageName ??
                                                          "Supported Files: .jpg, .jpeg, .png",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          Color(0xff929BA3))),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          PortfolioCustomButton(
                                            clickAction: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                if (startDate.value.text ==
                                                    '') {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Please choose start date')),
                                                  );
                                                  return;
                                                }
                                                Map<String, dynamic> data =
                                                    Map();
                                                try {
                                                  data["activity_type"] =
                                                      "Certificate";
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
                                                  data['title'] =
                                                      titleController
                                                          .value.text;
                                                  data['start_date'] =
                                                      startDate.value.text;
                                                  data[
                                                      "professional_key"] = widget
                                                              .isEditMode ==
                                                          true
                                                      ? "certificate_${widget.cetificate?.id}"
                                                      : "new_professional";
                                                  data["edit_url_professional"] =
                                                      "${widget.cetificate?.imageName}";

                                                  addCertificate(data);
                                                } catch (e) {
                                                  print('the issue is $e');

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Please upload certificate')),
                                                  );
                                                }
                                              }
                                            },
                                          )
                                        ]))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            )));
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(widget.isEditMode == true
                    ? 'Certificate edited'
                    : 'Certificate added')),
          );
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
        controller.text =
            Utility.convertDateFormat(selectedDate, format: 'yyyy-MM-dd');
      });
  }
}
