import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
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

class AddPortfolio extends StatefulWidget {
  final bool? editMode;
  final Portfolio? portfolio;
  final String? baseUrl;
  const AddPortfolio({
    Key? key,
    this.editMode = false,
    this.portfolio,
    this.baseUrl = "",
  }) : super(key: key);

  @override
  State<AddPortfolio> createState() => _AddPortfolioState();
}

class _AddPortfolioState extends State<AddPortfolio> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  File? uploadImg;
  File? file;

  bool? isAddPortfolioLoading = false;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    updateValue();
    super.initState();
  }

  void updateValue() {
    if (widget.editMode == true) {
      titleController =
          TextEditingController(text: widget.portfolio?.portfolioTitle);
      descController = TextEditingController(text: widget.portfolio?.desc);
      linkController =
          TextEditingController(text: widget.portfolio?.portfolioLink);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (value) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          if (state is AddPortfolioState) handleAddPortfolio(state);
        },
        child: Scaffold(
            appBar: AppBar(
               backgroundColor: ColorConstants.WHITE,
                elevation: 0,
                leading: SizedBox(),
              centerTitle: true,
              title: Text(
                widget.editMode == true ? "Edit Portfolio" : "Add Portfolio",
                style: Styles.bold(size: 14, color: Color(0xff0E1638)),
              ),
              actions: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_outlined, color: Color(0xff0E1638))),
              ],
            ),
            body: SafeArea(
              child: ScreenWithLoader(
                isLoading: isAddPortfolioLoading,
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: SingleChildScrollView(
                      child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   children: [
                          //     Padding(
                          //       padding: EdgeInsets.only(
                          //           left: width(context) * 0.34),
                          //       child: Text(
                          //         widget.editMode == true
                          //             ? "Edit Portfolio"
                          //             : "Add Portfolio",
                          //         style: Styles.bold(
                          //             size: 14, color: Color(0xff0E1638)),
                          //       ),
                          //     ),
                          //     Expanded(child: SizedBox()),

                          //   ],
                          // ),
                          Text(
                            "Project Title*",
                            style: Styles.regular(
                                size: 14, color: Color(0xff0E1638)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            validate: true,
                            validationString: 'Please enter title',
                            controller: titleController,
                            hintText: 'Type project title here..',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Project Description*",
                            style: Styles.regular(
                                size: 14, color: Color(0xff0E1638)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            validate: true,
                            validationString: 'Please enter description',
                            controller: descController,
                            hintText: 'Type project description here',
                            maxLine: 8,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Featured image*",
                            style: Styles.regular(
                                size: 14, color: Color(0xff0E1638)),
                          ),
                          SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              FilePickerResult? result;

                              if (Platform.isIOS) {
                                result = await FilePicker.platform.pickFiles(
                                  allowMultiple: false,
                                  type: FileType.image,
                                );
                                if (result != null)
                                  setState(() {
                                    uploadImg = File(result!.files.first.path!);
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
                                SizedBox(
                                  width: width(context) * 0.6,
                                  child: Text(
                                      uploadImg != null
                                          ? '${uploadImg?.path.split('/').last}'
                                          : widget.portfolio?.imageName ??
                                              "Supported Files: .jpeg, .png, .jpg",
                                      softWrap: true,
                                      maxLines: 3,
                                      style: Styles.regular(
                                          size: 12, color: Color(0xff929BA3))),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Associated link (if any)",
                            style: Styles.regular(
                                size: 14, color: Color(0xff0E1638)),
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
                                    FilePickerResult? result;

                                    if (Platform.isIOS) {
                                      result =
                                          await FilePicker.platform.pickFiles(
                                        allowMultiple: false,
                                        type: FileType.any,
                                      );
                                      if (result != null)
                                        setState(() {
                                          uploadImg =
                                              File(result!.files.first.path!);
                                        });
                                    } else {
                                      FilePickerResult? pickedFileC =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.any,
                                      );
                                      if (pickedFileC != null) {
                                        setState(() {
                                          file = File(
                                              pickedFileC.files.first.path!);
                                        });
                                      }
                                    }
                                  },
                                  uploadText: 'Upload File',
                                ),
                              ),
                              SizedBox(
                                width: width(context) * 0.6,
                                child: Text(
                                    file != null
                                        ? '${file?.path.split('/').last}'
                                        : widget.portfolio?.portfolioFile ??
                                            "Supported Files: Documents, Image, Video",
                                    maxLines: 3,
                                    style: Styles.regular(
                                        size: 12, color: Color(0xff929BA3))),
                              ),
                            ],
                          ),
                          PortfolioCustomButton(clickAction: () async {
                            if (_formKey.currentState!.validate()) {
                              Map<String, dynamic> data = Map();
                              try {
                                if (widget.editMode == true) {
                                  if (uploadImg?.path != null) {
                                    String? portfolioImage =
                                        uploadImg?.path.split('/').last;
                                    data['portfolio_image'] =
                                        await MultipartFile.fromFile(
                                            '${uploadImg?.path}',
                                            filename: portfolioImage);
                                  }
                                  if (file?.path != null) {
                                    String? portfolioFile =
                                        file?.path.split('/').last;
                                    data['portfolio_file'] =
                                        await MultipartFile.fromFile(
                                            '${file?.path}',
                                            filename: portfolioFile);
                                  }
                                } else {
                                  String? portfolioImage =
                                      uploadImg?.path.split('/').last;
                                  String? portfolioFile =
                                      file?.path.split('/').last;
                                  data['portfolio_image'] =
                                      await MultipartFile.fromFile(
                                          '${uploadImg?.path}',
                                          filename: portfolioImage);

                                  data['portfolio_file'] =
                                      await MultipartFile.fromFile(
                                          '${file?.path}',
                                          filename: portfolioFile);
                                }
                              } catch (e) {}

                              if (widget.editMode == false &&
                                  (file?.path == null ||
                                      uploadImg?.path == null)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(file?.path == null
                                            ? 'Please upload file'
                                            : 'Please add feature image')));
                              } else {
                                data['portfolio_title'] =
                                    titleController.value.text;
                                data['portfolio_link'] =
                                    linkController.value.text;
                                data['portfolio_key'] = widget.editMode == true
                                    ? "portfolio_${widget.portfolio?.id}"
                                    : 'new_portfolio';
                                data['edit_file_portfolio'] =
                                    '${widget.portfolio?.portfolioFile}';
                                data['edit_url_portfolio'] =
                                    '${widget.portfolio?.imageName}';
                                // data['edit_file_portfolio'] = '${widget.baseUrl}${widget.portfolio?.portfolioFile}';
                                // data['edit_url_portfolio'] ='${widget.baseUrl}${widget.portfolio?.imageName}';
                                data['desc'] = descController.value.text;
                                print(data);

                                addPortfolio(data);
                              }
                            }
                          })
                        ]),
                  )),
                ),
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(widget.editMode == true ?'Portfolio updated' : 'Portfolio created'),
          ));
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
