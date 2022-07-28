import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/create_portfolio_response.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:masterg/utils/widget_size.dart';

class CreatePortfolioPage extends StatefulWidget {
  final String? title;
  final String? portfolioType;

  CreatePortfolioPage({this.title, this.portfolioType});

  @override
  _CreatePortfolioPageState createState() => _CreatePortfolioPageState();
}

class _CreatePortfolioPageState extends State<CreatePortfolioPage>
    with SingleTickerProviderStateMixin {
  final titleController = TextEditingController();
  final desController = TextEditingController();
  String? selectedImage;
  bool _isLoading = false;
  late CreatePortfolioResponse createPortfolioResp;
  //String titleError = '' , desError = '';
  bool flagValidation = false;

  @override
  void initState() {
    super.initState();
  }

  void createPortfolio() {
    BlocProvider.of<HomeBloc>(context).add(CreatePortfolioEvent(
        title: titleController.text.toString(),
        description: desController.text.toString(),
        type: widget.portfolioType,
        filePath: selectedImage));
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is CreatePortfolioState) {
              _handleCreatePortfolioResponse(state);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.orangeAccent,
              title: Text(
                widget.title.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SafeArea(
                child: ScreenWithLoader(
              isLoading: _isLoading,
              body: _makeBody(),
            )),
          ),
        ));
  }

  _makeBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //SizedBox(height: 20),
                    TextFormField(
                      controller: titleController,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r"[a-zA-Z -]"))
                      ],
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.grey,
                        hintText: "Brand Title",
                        //make hint text
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: "verdana_regular",
                          fontWeight: FontWeight.w400,
                        ),

                        //create lable
                        labelText: 'Brand Title',
                        //lable style
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: "verdana_regular",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    TextFormField(
                      maxLines: 6,
                      minLines: 4,
                      controller: desController,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.grey,
                        hintText: "Brand Description",
                        //make hint text
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: "verdana_regular",
                          fontWeight: FontWeight.w400,
                        ),

                        //create lable
                        labelText: '',
                        //lable style
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: "verdana_regular",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    SizedBox(height: 40.0),
                    Center(
                      child: Row(
                        children: [
                          selectedImage != null && selectedImage!.isNotEmpty
                              ? Container(
                                  height: 100,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorConstants.APPBAR_COLOR,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: FileImage(File('$selectedImage')),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  child: null /* add child content here */,
                                )
                              : Container(
                                  height: 100,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange,
                                    image: DecorationImage(
                                      image: FileImage(File('$selectedImage')),
                                      fit: BoxFit.none,
                                    ),
                                  ),
                                  child: null /* add child content here */,
                                ),
                          Container(
                              width: 100,
                              height: 40,
                              margin: const EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  //shape: BoxShape.circle,
                                  color: Colors.green),
                              child: IconButton(
                                padding: const EdgeInsets.all(0),
                                icon: Icon(Icons.camera_alt_outlined,
                                    color: Colors.white, size: 15),
                                onPressed: () {
                                  showBottomSheet(context);
                                },
                              )),
                        ],
                      ),
                    ),

                    SizedBox(height: 60.0),
                    InkWell(
                        onTap: () {
                          validation();
                        },
                        child: Container(
                          margin: EdgeInsets.all(0),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height *
                              WidgetSize.AUTH_BUTTON_SIZE,
                          decoration: BoxDecoration(
                              color: flagValidation == true
                                  ? Color(0xffFDE5AD)
                                  : ColorConstants.YELLOW_ACTIVE_BUTTON,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            '${Strings.of(context)?.continueStr}',
                            style: TextStyle(color: ColorConstants.BLACK),
                          )),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _getImages(ImageSource source) async {
    final picker = ImagePicker();
    PickedFile? pickedFile = await picker.getImage(
        source: source, imageQuality: 50, maxWidth: 740, maxHeight: 580);
    if (pickedFile != null)
      return pickedFile.path;
    else if (Platform.isAndroid) {
      final LostData response = await picker.getLostData();
      if (response.file != null) {
        return response.file!.path;
      }
    }
    return "";
  }

  void showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.black,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 10),
                  height: 4,
                  width: 70,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Container(
                child: ListTile(
                  leading: new Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  title: new Text(
                    '${Strings.of(context)!.Gallery}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await _getImages(ImageSource.gallery).then((value) {
                      selectedImage = value;
                      if (selectedImage != null) {
                        // _updateUserProfileImage(selectedImage);
                      }
                      setState(() {});
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey[100],
              ),
              Container(
                child: ListTile(
                  leading: new Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                  title: new Text(
                    '${Strings.of(context)!.Camera}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await _getImages(ImageSource.camera).then((value) {
                      if (value != null) selectedImage = value;
                      setState(() {});
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        });
  }

  void validation() {
    print('selectedImage === ');
    print(selectedImage);

    if (titleController.text.toString().isEmpty) {
      Utility.showSnackBar(
          scaffoldContext: context, message: 'Please enter title.');
    } else if (desController.text.toString().isEmpty) {
      Utility.showSnackBar(
          scaffoldContext: context, message: 'Please enter description.');
    } else if (selectedImage == null) {
      Utility.showSnackBar(
          scaffoldContext: context, message: 'Please select image.');
    } else {
      createPortfolio();
    }
  }

  void _handleCreatePortfolioResponse(CreatePortfolioState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          _isLoading = true;
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          _isLoading = false;
          Log.v("Success....................");
          createPortfolioResp = state.response!;
          Navigator.of(context).pop();
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}
