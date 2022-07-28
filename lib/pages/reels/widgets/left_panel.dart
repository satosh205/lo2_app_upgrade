import 'package:flutter/material.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/reels/widgets/column_social_icon.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

class LeftPanel extends StatelessWidget {
  final String? name;
  final String? caption;
  final int? viewCounts;
  final String? createdAt;
  final String? profileImg;
  const LeftPanel(
      {Key? key,
      required this.size,
      this.name,
      this.caption,
      this.viewCounts,
      this.createdAt,
      this.profileImg})
      : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
   

    var millis = int.parse(createdAt!);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
      millis * 1000,
    ).toUtc();

    final now = DateTime.now();

    String calculateTimeDifferenceBetween(
        DateTime startDate, DateTime endDate) {
      int seconds = endDate.difference(startDate).inSeconds;
      if (seconds < 60)
        return '$seconds s';
      else if (seconds >= 60 && seconds < 3600)
        return '${startDate.difference(endDate).inMinutes.abs()} m';
      else if (seconds >= 3600 && seconds < 86400)
        return '${startDate.difference(endDate).inHours.abs()} h';
      else
        return '${startDate.difference(endDate).inDays.abs()} d';
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
              getProfile(profileImg),
              SizedBox(
                width: 10,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(name!,
                        style: Styles.semibold(
                            size: 14, color: ColorConstants.WHITE)),
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
              '${viewCounts} view',
              style: Styles.regular(size: 12, color: ColorConstants.WHITE),
            ),
            if (viewCounts! > 1 &&
                Preference.getInt(Preference.APP_LANGUAGE) == 1)
              Text(
                's',
                style: Styles.regular(size: 12, color: ColorConstants.WHITE),
              ),
          ])
        ],
      ),
    );
  }
}
