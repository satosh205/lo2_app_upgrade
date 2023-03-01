import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/data/models/response/home_response/competition_response.dart';
import 'package:masterg/data/models/response/home_response/portfolio_competition_response.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/singularis/competition/competition_detail.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class CompetitionListPortfolio extends StatefulWidget {
  final List<PortfolioCompetition>? competitionList;
  const CompetitionListPortfolio({Key? key, required this.competitionList})
      : super(key: key);

  @override
  State<CompetitionListPortfolio> createState() =>
      _CompetitionListPortfolioState();
}

class _CompetitionListPortfolioState extends State<CompetitionListPortfolio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        centerTitle: false,
                  title: Text("Competitions", style: Styles.bold()),
                  elevation: 0.6,
                  backgroundColor: ColorConstants.WHITE,
                  leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: ColorConstants.BLACK,
                      )),
                
               
                ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.competitionList?.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    NextPageRoute(CompetitionDetail(
                      competition: Competition(
                          id: widget.competitionList?[index].pId,
                          name: widget.competitionList?[index].pName,
                          image: widget.competitionList?[index].pImage,
                          gScore:  int.parse('${widget.competitionList?[index].gScore ?? '0'} '),
                          description: "",
                          startDate: widget.competitionList?[index].startDate),
                    )));
              },
              child: Container(
            padding:  const EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: ColorConstants.WHITE,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                            BoxShadow(
                              blurRadius: 16,
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                            ),
                          ],
                  ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                            imageUrl: '${widget.competitionList?[index].pImage}',
                            height: height(context) * 0.12,
                            width: height(context) * 0.12,
                            fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(width: width(context) * 0.03,),

                    Padding(
                      padding: const EdgeInsets.symmetric( vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width(context) * 0.6,
                            child: Text(
                              '${widget.competitionList?[index].pName}',
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.bold(size:14),
                            ),
                           ),
                        
                          Row(
                            children: [
                                Text(
                              'Rank : ${widget.competitionList?[index].rank ?? 0}   ',
                              style: Styles.regular(
                                  size: 12, )),
                              SvgPicture.asset(
                                'assets/images/coin.svg',
                                width: width(context) * 0.03,
                              ),
                              Text(
                                  '  ${widget.competitionList?[index].gScore ?? 0} Points',
                                  style: Styles.semibold(
                                      size: 12, color: ColorConstants.ORANGE)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
