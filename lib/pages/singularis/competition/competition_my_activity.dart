import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/data/models/response/home_response/competition_response.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/singularis/competition/competition_detail.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class CompetitionMyAcitivityCard extends StatefulWidget {
  final String? image;
  final String? title;
  final int? totalAct;
  final int? doneAct;

  final int? id;
  final int? score;
  final String? desc;
  final String? date;
  final String? difficulty;
  final String? conductedBy;
  final String? activityStatus;
  final int? rank;

  const CompetitionMyAcitivityCard(
      {Key? key,
      this.image,
      this.title,
      this.totalAct,
      this.doneAct,
      this.id,
      this.score,
      this.desc,
      this.date,
      this.difficulty,
      this.conductedBy,
      this.activityStatus,
      this.rank})
      : super(key: key);

  @override
  State<CompetitionMyAcitivityCard> createState() =>
      _CompetitionMyAcitivityCardState();
}

class _CompetitionMyAcitivityCardState
    extends State<CompetitionMyAcitivityCard> {
  @override
  Widget build(BuildContext context) {
    // double percent = widget.doneAct/ widget.totalAct ;
    double percent =
        double.parse('${widget.doneAct}') / double.parse('${widget.totalAct}');
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            NextPageRoute(CompetitionDetail(
              competition: Competition(
                image: widget.image,
                  id: widget.id,
                  level: widget.difficulty,
                  description: widget.desc,
                  gScore: widget.score ?? 0,
                  startDate: widget.date,
                  name: widget.title),
            )));
      },
      child: Container(
        width: width(context) * 0.8,
        height: height(context) * 0.12,
        margin: EdgeInsets.symmetric(vertical: 17, horizontal: 6),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xffEDEDED))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/comp_emp.png',
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
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
                        TextSpan(
                            text: '${widget.doneAct}',
                            style: Styles.bold(size: 12)),
                        TextSpan(
                            text: '/${widget.totalAct} Activities Done',
                            style: Styles.regular(size: 12)),
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
                          width: MediaQuery.of(context).size.width *
                              0.45 *
                              (percent / 100),
                          decoration: BoxDecoration(
                              color: ColorConstants.PROGESSBAR_TEAL,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                  ),
                  if (widget.activityStatus != null &&
                      widget.activityStatus != '')
                    Text(
                      '${widget.activityStatus}',
                      style: Styles.regular(size: 11, color: ColorConstants.GREEN_1),
                    ),
                  SizedBox(
                    height: 6,
                  ),
                  if (widget.activityStatus == null)
                    Row(
                      children: [
                        Text('Rank: ${widget.rank}',
                            style: Styles.regular(size: 12)),
                        SizedBox(
                          width: 4,
                        ),
                        SizedBox(
                            height: 15,
                            child: Image.asset('assets/images/coin.png')),
                        SizedBox(
                          width: 4,
                        ),
                        Text('${widget.score ?? 0} Points',
                            style: Styles.regular(size: 12)),
                      ],
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
