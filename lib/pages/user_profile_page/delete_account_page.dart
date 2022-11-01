import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/user_profile_page/choose_option_deletion.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

import '../../blocs/bloc_manager.dart';
import '../../data/api/api_service.dart';
import '../../utils/Log.dart';

class DeleteAccountPage extends StatefulWidget {
  final imageUrl;
  const DeleteAccountPage({super.key, this.imageUrl});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (BuildContext context) {},

      child: BlocListener<HomeBloc, HomeState>(
         listener: (context, state) {
            if (state is RemoveAccountState){
                handleRemoveAccount(state);
            }
           
          },
        child: Scaffold(
          backgroundColor: ColorConstants.WHITE,
          appBar: AppBar(
              centerTitle: true,
              backgroundColor: ColorConstants.WHITE,
              elevation: 0.0,
              iconTheme: IconThemeData(color: ColorConstants.BLACK),
              title: Text(
                'Delete Account',
                style: Styles.bold(),
              )),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              widget.imageUrl != null
                  ? ClipOval(
                      child: GestureDetector(
                        onTap: () {
                          print('Profile image');
                          // _showBgProfilePic(context, userProfileDataList!.profileImage!);
                        },
                        child: Image.network(
                          widget.imageUrl,
                          filterQuality: FilterQuality.low,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/images/default_user.svg',
                      width: 200,
                      height: 200,
                      allowDrawingOutsideViewBox: true,
                    ),
              SizedBox(height: 20),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
                  child: Text(
                    'Deactivate your account insted of deleting?',
                    style: Styles.bold(size: 16),
                    textAlign: TextAlign.center,
                  )),
              SizedBox(height: 10),
              infoCard(Icons.visibility, 'Deactivating your account is temporary',
                  'Your profile, photos, comments and likes will be hidden until you enable it by logging back in.'),
              infoCard(Icons.info_sharp, 'Deleting your account is permanent',
                  'Your profile, photos, videos, comments, likes and followers will be permanently deleted.'),
              Expanded(child: SizedBox()),
              CupertinoButton(
                  color: ColorConstants().primaryColor(),
                  child: Text(
                    'Deactivate Account',
                    style: Styles.regular(size: 12, color: ColorConstants.WHITE),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Container(
                                height: 230,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Delete your Instagram Account?',
                                        style: Styles.bold(),
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 10),
                                    Text(
                                      'You\'re requesting to delete. You can stop the deletion process by logging back in before 27 Octboer 2022.',
                                      textAlign: TextAlign.center,
                                    ),
                                    Divider(),
                                    InkWell(
                                      onTap: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             ChooseOptionDeletion()));

                                        deActivateAccount();
                                      },
                                      child: Text(
                                        'Continue Deactivating Account',
                                        style:
                                            Styles.bold(color: ColorConstants.RED),
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(height: 10),
                                    InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel',
                                            style: Styles.regular(size: 14)))
                                  ],
                                ),
                              ));
                        });
                  }),
              CupertinoButton(
                  child: Text(
                    'Delete Account',
                    style: Styles.regular(size: 12, color: ColorConstants.BLACK),
                  ),
                  onPressed: () {
                    deleteAccount();
                  }),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget infoCard(IconData icon, String title, String desc) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Styles.bold(size: 14),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    desc,
                    style: Styles.regular(size: 12),
                    softWrap: true,
                    maxLines: 3,
                  )),
            ],
          )
        ],
      ),
    );
  }

  void deActivateAccount(){
    
    BlocProvider.of<HomeBloc>(context).add(RemoveAccountEvent(type: 'deactivate'));
  }

  void deleteAccount(){
    BlocProvider.of<HomeBloc>(context).add(RemoveAccountEvent(type: 'delete'));

  }

  void handleRemoveAccount(RemoveAccountState state) {
    var removeState = state;
    // setState(() {
    switch (removeState.apiState) {
      case ApiStatus.LOADING:
        isloading = true;
        Log.v("Loading....................Remove Account State");
        break;
      case ApiStatus.SUCCESS:
        Log.v("Success....................Remove Account State");
        isloading = false;

      AlertsWidget.alertWithOkBtn(
                context: context,
                text: '${removeState.response?.message}',
                onOkClick: () {
                  // FocusScope.of(context).unfocus();
                });
       
        break;
      case ApiStatus.ERROR:
        isloading = false;
        Log.v("Error..........................Remove Account State");
        break;
      case ApiStatus.INITIAL:
        break;
    }
    // });
  }

}
