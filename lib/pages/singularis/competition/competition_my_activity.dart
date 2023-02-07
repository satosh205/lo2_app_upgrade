import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class CompetitionMyAcitivityCard extends StatefulWidget {
 final String? image;
 final String? title;
 final int? totalAct;
 final int? doneAct;


  const CompetitionMyAcitivityCard({Key? key, this.image, this.title, this.totalAct, this.doneAct}) : super(key: key);

  @override
  State<CompetitionMyAcitivityCard> createState() =>
      _CompetitionMyAcitivityCardState();
}

class _CompetitionMyAcitivityCardState
    extends State<CompetitionMyAcitivityCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context) * 0.8,
      height: height(context) * 0.1,
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xffEDEDED))),
      child: Row(
        children: [
          SizedBox(
            width: width(context) * 0.2,
            height: width(context) * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: '${widget.image}',
                // width: 100,
                // height: 120,
                errorWidget: (context, url, error) => SvgPicture.asset(
                  'assets/images/gscore_postnow_bg.svg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${widget.title}',
                  style: Styles.bold(size: 12),
                ),
                SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${widget.doneAct}', style: Styles.bold(size: 12)),
                     
                      TextSpan(text: '/${widget.totalAct} Activities Done', style: Styles.regular(size: 12)),
                    ],
                  ),
                ),
               Spacer(),
          
                Container(
                  height: 6,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                      color: ColorConstants.GREY,
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Container(
                        height: 10,
                        width:
                            MediaQuery.of(context).size.width * 0.45 * (60 / 100),
                        decoration: BoxDecoration(
                            color: ColorConstants.PROGESSBAR_TEAL,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
