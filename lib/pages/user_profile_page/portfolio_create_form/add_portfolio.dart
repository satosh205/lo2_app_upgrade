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

class AddPortfolio extends StatefulWidget {
  const AddPortfolio({Key? key}) : super(key: key);

  @override
  State<AddPortfolio> createState() => _AddPortfolioState();
}

class _AddPortfolioState extends State<AddPortfolio> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final linkController = TextEditingController();
  File? uploadImg;
  File? img;

  bool? isAddPortfolioLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (value) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          if(state is AddPortfolioState) handleAddPortfolio(state);
        },
        child: Scaffold(
            body: ScreenWithLoader(
              isLoading: isAddPortfolioLoading,
              body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: width(context) * 0.34),
                        child: Text(
                          "Add Portfolio",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Icon(Icons.close_outlined),
                    ],
                  ),
                  const Text(
                    "Project Title*",
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
                    hintText: 'Type project title here..',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Project Description*",
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(width: 1.0, color: const Color(0xffE5E5E5)),
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: TextField(
                      controller: descController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xffE5E5E5)),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Type project description here',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Featured image*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5A5F73)),
                  ),
                  SizedBox(height: 8),
                  InkWell(
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
                                    Color(0xfffc7804),
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
                  SizedBox(height: 8),
                  Text(
                    "Associated link (if any)*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5A5F73)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                    controller: linkController,
                    hintText: 'https//',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomUpload(
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
                          uploadText: 'Upload Image',
                        ),
                      ),
                      Text("Supported Format: .pdf, .doc, .jpeg",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff929BA3))),
                    ],
                  ),
                  PortfolioCustomButton(
                    clickAction: () async {
                      Map<String, dynamic> data = Map();
                      try {
                        String? fileName = img?.path.split('/').last;
                        data['portfolio_image'] = await MultipartFile.fromFile(
                            '${img?.path}',
                            filename: fileName);
                      } catch (e) {
                        print('something is wrong $e');
                      }
                      print('agaoni cliked');
            
                      data['portfolio_title'] = titleController.value.text;
                      data['portfolio_link'] = linkController.value.text;
                      data['portfolio_key'] = 'new_portfolio';
                      data['edit_url_portfolio'] = '';
                      data['edit_image_type'] = '';
                      data['desc'] = descController.value.text;
            
                      addPortfolio(data);
                    },
                  )
                ])),
                    ),
            )),
      ),
    );
  }

  void addPortfolio(Map<String, dynamic> data) {
    BlocProvider.of<HomeBloc>(context).add(AddPortfolioEvent(data: data));
  }

  void handleAddPortfolio(AddPortfolioState state) {
    var addPortfolioState = state;
    setState(() {
      switch (addPortfolioState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading Add Portfolio....................");
          isAddPortfolioLoading = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Add Portfolio....................");
          isAddPortfolioLoading = false;
          Navigator.pop(context);
          break;
        case ApiStatus.ERROR:
          Log.v("Error Add Portfolio....................");
          isAddPortfolioLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}
