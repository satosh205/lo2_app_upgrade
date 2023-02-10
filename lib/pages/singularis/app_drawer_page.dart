
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:masterg/utils/constant.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/response/auth_response/user_session.dart';
import '../../local/pref/Preference.dart';
import '../../utils/Strings.dart';
import '../../utils/Styles.dart';
import '../../utils/resource/colors.dart';
import '../auth_pages/choose_language.dart';
import '../custom_pages/alert_widgets/alerts_widget.dart';
import '../custom_pages/custom_widgets/NextPageRouting.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => new _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DrawerHeader(
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.all(0.0),
              child: new Container(
                height: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0)),
                    gradient: LinearGradient(begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          ColorConstants.GRADIENT_ORANGE,
                          ColorConstants.GRADIENT_RED,

                        ])
                ),

                child: Container(
                  height: 100,
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          /*Navigator.push(context,
                              NextPageRoute(NewPortfolioPage()));*/
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox(
                            child: Image.network(
                              '${Preference.getString(Preference.PROFILE_IMAGE)}', height: 50, width: 50,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                  SvgPicture.asset(
                                    'assets/images/default_user.svg',
                                    width: 50, height: 50,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome',
                              // '${Preference.getString(Preference.We)}',
                              style: Styles.regular(color: ColorConstants.WHITE,
                                   size: 16),
                            ),
                            SizedBox(
                              width: width(context) * 0.6,
                              child: Text(
                                '${Preference.getString(Preference.FIRST_NAME)}',
                                maxLines: 2,

                                style: Styles.bold(
                                    color: ColorConstants.WHITE, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ),

          SizedBox(height: 40,),
           ListTile(
            hoverColor: Colors.blue,
            dense: true,
            visualDensity: VisualDensity(vertical: -4),
            leading: Icon(
              Icons.share_outlined,
              color: Colors.black,
            ),
            title: Text('Shareapp'),
            onTap: () {},
          ),
           SizedBox(height: 20,),
          ListTile(
            hoverColor: Colors.blue,
            dense: true,
            visualDensity: VisualDensity(vertical: -4),
            leading: Icon(
              Icons.lock_outline_rounded,
              color: Colors.black,
            ),
            title: Text('Change Password'),
            onTap: () {},
          ),
          SizedBox(height: 20,),
           ListTile(
            hoverColor: Colors.blue,
            dense: true,
            visualDensity: VisualDensity(vertical: -4),
            leading:SvgPicture.asset('assets/images/terms.svg',
            color: Colors.black ,
            
            
            ),
            // leading: Icon(
            //   Icons.privacy_tip_outlined,
            //   color: Colors.black,
            // ),
            title: Text('Terms and Conditions'),
            onTap: () {},
          ),
          SizedBox(height: 20,),
          ListTile(
            hoverColor: Colors.blue,
            dense: true,
            visualDensity: VisualDensity(vertical: -4),
            leading:SvgPicture.asset('assets/images/about.svg'),
            title: Text('About Singularis'),
            onTap: () {},
          ),
          SizedBox(height: 200,),
          Divider(),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                hoverColor: Colors.blue,
                dense: true,
                visualDensity: VisualDensity(vertical: -4),
                leading: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                title: Text('Logout'),
                onTap: () async {
                  AlertsWidget.showCustomDialog(
                      context: context,
                      title: '${Strings.of(context)?.leavingSoSoon}',
                      text: '${Strings.of(context)?.areYouSureYouWantToExit}',
                      icon: 'assets/images/circle_alert_fill.svg',
                      onOkClick: () async {
                        UserSession.clearSession();
                        await Hive.deleteFromDisk();
                        Preference.clearPref().then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              NextPageRoute(ChooseLanguage(
                                showEdulystLogo: true,
                              )),
                                  (route) => false);
                        });
                      });
                },
              ),
            ),
          ),
          SizedBox(height: 30,),
        ],
      ),
    );
  }
}