import 'package:flutter/material.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/reels/widgets/column_social_icon.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class LeftPanel extends StatelessWidget {
  final String? name;
  final String? caption;
  final int? viewCounts;
  final String? createdAt;
  final String? profileImg;
  final String? userStatus;
  const LeftPanel(
      {Key? key,
      required this.size,
      this.name,
      this.caption,
      this.viewCounts,
      this.createdAt,
      this.userStatus,
      this.profileImg})
      : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    var millis = int.parse(createdAt!);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
      millis * 1000,
    );

    final now = DateTime.now();

    // String calculateTimeDifferenceBetween(
    //     DateTime startDate, DateTime endDate) {
    //   int seconds = endDate.difference(startDate).inSeconds;
    //   if (seconds < 60)
    //     {
    //        if(seconds.abs() < 4) return 'Just Now';
    //     return '${seconds.abs()} s';
    //     }
    //   else if (seconds >= 60 && seconds < 3600)
    //     return '${startDate.difference(endDate).inMinutes.abs()} m';
    //   else if (seconds >= 3600 && seconds < 86400)
    //     return '${startDate.difference(endDate).inHours.abs()} h';
    //   else
    //     return '${startDate.difference(endDate).inDays.abs()} d';
    // }

String calculateTimeDifferenceBetween(DateTime startDate, DateTime endDate) {
      int seconds = endDate.difference(startDate).inSeconds;
      if (seconds < 60){
        if(seconds.abs() < 4) return '${Strings.of(context)?.justNow}';
        return '${seconds.abs()} ${Strings.of(context)?.s}';
      }
        
      else if (seconds >= 60 && seconds < 3600)
        return '${startDate.difference(endDate).inMinutes.abs()} ${Strings.of(context)?.m}';
      else if (seconds >= 3600 && seconds < 86400)
        return '${startDate.difference(endDate).inHours.abs()} ${Strings.of(context)?.h}';
      else {
        // convert day to month
        int days = startDate.difference(endDate).inDays.abs();
        if (days < 30 && days > 7) {
          return '${(startDate.difference(endDate).inDays ~/ 7).abs()} ${Strings.of(context)?.w}';
        }
        if (days > 30) {
          int month = (startDate.difference(endDate).inDays ~/ 30).abs();
          return '$month ${Strings.of(context)?.mos}';
        } else
          return '${startDate.difference(endDate).inDays.abs()} ${Strings.of(context)?.d}';
      }
    }
    return Container(
      width: size.width * 0.8,
      height: size.height,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getProfile(profileImg, userStatus == 'active'),
              SizedBox(
                width: 10,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width(context) * 0.55,
                      child: Text(name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                          style: Styles.semibold(
                              size: 14,  color: userStatus != "active" ?  ColorConstants.GREY_3.withOpacity(0.8) : ColorConstants.WHITE)),
                    ),
                    Text(
                      calculateTimeDifferenceBetween(
                          DateTime.parse(date.toString().substring(0, 19)),
                          now),
                      style:
                          Styles.regular(size: 12, color: ColorConstants.WHITE),
                    ),
                  ]),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          caption != 'null'
              ? Text(
                  caption!,
                  style: Styles.regular(size: 12, color: ColorConstants.WHITE),
                )
              : SizedBox(),
          SizedBox(
            height: 3,
          ),
          Row(children: [
            Text(
              '$viewCounts ${Strings.of(context)?.Views}',
              style: Styles.regular(size: 12, color: ColorConstants.WHITE),
            ),
            if (viewCounts! > 1 &&
                Preference.getInt(Preference.APP_LANGUAGE) == 1)
              Text(
                Preference.getInt(Preference.APP_LANGUAGE) == 1 ? 's' : '',
                style: Styles.regular(size: 12, color: ColorConstants.WHITE),
              ),
          ])
        ],
      ),
    );
  }
}
