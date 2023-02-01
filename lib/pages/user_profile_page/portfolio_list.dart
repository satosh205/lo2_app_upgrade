import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_portfolio.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

import '../../data/models/response/home_response/new_portfolio_response.dart';


class PortfolioList extends StatefulWidget {
  final List<Portfolio>? portfolioList;
  final String? baseUrl;
  const PortfolioList({Key? key,required this.portfolioList,required this.baseUrl}) : super(key: key);

  @override
  State<PortfolioList> createState() => _PortfolioListState();
}

class _PortfolioListState extends State<PortfolioList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConstants.WHITE,
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, color: ColorConstants.BLACK,)),
        actions: [
          IconButton(onPressed: ()async{
             await showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        context: context,
                                        enableDrag: true,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.7,
                                            child: Container(
                                                height: height(context),
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                margin: const EdgeInsets.only(
                                                    top: 10),
                                                child: AddPortfolio()),
                                          );
                                        });
          }, icon: Icon(Icons.add, color: ColorConstants.BLACK,))
        ],
        title: Text('Portfolio', style: Styles.bold(),),),
      body: ListView.builder(
      shrinkWrap: true,
      itemCount: widget.portfolioList?.length,
      itemBuilder: (context, index){
      return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      '${widget.baseUrl}${widget.portfolioList?[index].imageName}',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width ,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                                  fit: BoxFit.cover,
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.3,
                                                      padding:
                                                          EdgeInsets.all(14),
                                                      decoration: BoxDecoration(
                                                          color: Color(
                                                              0xffD5D5D5)),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                '${widget.portfolioList?[index].portfolioTitle}',
                                                style: Styles.bold(),
                                              ),
                                              Text(
                                                  '${widget.portfolioList?[index].desc}',
                                                  style: Styles.semibold(
                                                      size: 12,
                                                      color:
                                                          Color(0xff929BA3))),
                                            ],
                                          ),
                                        );
    }),);
  }
}