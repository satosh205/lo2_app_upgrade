import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/user_profile_page/mobile_ui_helper.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadProfile extends StatefulWidget {
  const UploadProfile({Key? key,  }) : super(key: key);

  @override
  State<UploadProfile> createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  String? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Profile Picture')),

      body:Preference.getString(Preference.PROFILE_IMAGE)  != null  ?  
      Column(
        children: [
          CachedNetworkImage(
                                                    imageUrl:
                                                        '${Preference.getString(Preference.PROFILE_IMAGE)}',
                                                    filterQuality:
                                                        FilterQuality.low,
                                                    width:width(context),
                                                    height: height(context) * 0.8,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Spacer(),
                                                  Container(
            padding: EdgeInsets.zero,
color: ColorConstants.BLACK,
            width: width(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               icon('Edit ', 'assets/images/edit.svg', (){}),
               icon('Upload ', 'assets/images/camera.svg', ()async{
                                    FilePickerResult? result;
                    try {
                      if (await Permission.storage.request().isGranted) {
                        if (Platform.isIOS) {
                          result = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.image,
                              allowedExtensions: []);
                        } else {
                          result = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'png', 'jpeg']);
                        }
                      }
                    } catch (e) {
                      print('the expection is $e');
                    }

                     String? value = result?.paths.first;
                      if (value != null) {
                        selectedImage = value;
                        selectedImage = await _cropImage(value);
                      }
                      Map<String, dynamic> data = Map();
                     data['image'] =
                                  await MultipartFile.fromFile('$selectedImage',
                                      filename: selectedImage);
    BlocProvider.of<HomeBloc>(context).add(UploadProfileEvent(data: data));

               }),
               icon('Remove ', 'assets/images/delete.svg', (){}),
              ],
            ),
          ),
        ],
      )
                                                : Container(color: ColorConstants.WHITE, height: height(context) * 0.6, width: width(context),) ,
    );
  }
  Widget icon(String title, String img, Function action){
    return Expanded(
      child: InkWell(
        onTap: (){
          action();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('$img', color: ColorConstants.WHITE,),
              Text('$title', style: Styles.regular(color: ColorConstants.WHITE,),),
          ],),
        ),
      ),
    );
  }


  Future<String> _cropImage(_pickedFile) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: buildUiSettings(context),
      
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (croppedFile != null) {
        return croppedFile.path;
      }
    }
    return "";
  }
}