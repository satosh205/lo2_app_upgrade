import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/ghome/widget/read_more.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_education.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

import '../../../data/models/response/home_response/new_portfolio_response.dart';

class EducationList extends StatefulWidget {
  final List<CommonProfession> education;
  final String? baseUrl;
  const EducationList({Key? key, required this.education, this.baseUrl})
      : super(key: key);

  @override
  State<EducationList> createState() => _EducationListState();
}

class _EducationListState extends State<EducationList> {

  bool isEducationLoading = false;
  @override
  Widget build(BuildContext context) {
    List<String> listOfMonths = [
      "Janaury",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return BlocManager(
        initState: (value) {},
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) async {
              if (state is SingularisDeletePortfolioState) handleSingularisDeletePortfolioState(state);
            },
            child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: ColorConstants.WHITE,
                  leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: ColorConstants.BLACK,
                      )),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              context: context,
                              enableDrag: true,
                              isScrollControlled: true,
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.7,
                                  child: Container(
                                      height: height(context),
                                      padding: const EdgeInsets.all(8.0),
                                      margin: const EdgeInsets.only(top: 10),
                                      child: AddEducation()),
                                );
                              });
                        },
                        icon: Icon(
                          Icons.add,
                          color: ColorConstants.BLACK,
                        ))
                  ],
                  title: Text(
                    'Education',
                    style: Styles.bold(),
                  ),
                ),
                body: ScreenWithLoader(
                  isLoading: isEducationLoading,
                  body: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                          color: ColorConstants.WHITE,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: widget.education.length,
                              itemBuilder: (context, index) {
                                String startDateString =
                                    "${widget.education[index].startDate}";
                                String endDateString =
                                    "${widget.education[index].endDate}";
                                DateTime startDate = DateFormat("MM/dd/yyyy")
                                    .parse(startDateString);
                                DateTime endDate =
                                    DateFormat("MM/dd/yyyy").parse(endDateString);
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '${widget.baseUrl}${widget.education[index].imageName}',
                                                height: width(context) * 0.3,
                                                width: width(context) * 0.3,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) {
                                                  return Container(
                                                    padding: EdgeInsets.all(14),
                                                    decoration: BoxDecoration(
                                                        color: Color(0xffD5D5D5)),
                                                    child: SvgPicture.asset(
                                                      'assets/images/default_education.svg',
                                                      height: 40,
                                                      width: 40,
                                                      color:
                                                          ColorConstants.GREY_5,
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                    ),
                                                  );
                                                },
                                                placeholder:
                                                    (BuildContext context,
                                                        loadingProgress) {
                                                  return Container(
                                                    padding: EdgeInsets.all(14),
                                                    decoration: BoxDecoration(
                                                        color: Color(0xffD5D5D5)),
                                                    child: SvgPicture.asset(
                                                      'assets/images/default_education.svg',
                                                      height: 40,
                                                      width: 40,
                                                      color:
                                                          ColorConstants.GREY_5,
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                    ),
                                                  );
                                                },
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '${widget.education[index].title}',
                                                style: Styles.bold(size: 16),
                                              ),
                                              SizedBox(height: 4),
                                              SizedBox(
                                                width: width(context) * 0.5,
                                                child: Text(
                                                  '${widget.education[index].institute}',
                                                  style: Styles.regular(size: 14),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${startDate.day} ${listOfMonths[startDate.month]} - ',
                                                    style:
                                                        Styles.regular(size: 14),
                                                  ),
                                                  Text(
                                                    '${endDate.day} ${listOfMonths[endDate.month]}',
                                                    style:
                                                        Styles.regular(size: 14),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Spacer(),
                                          InkWell(
                                              onTap: () async {
                                                await showModalBottomSheet(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20)),
                                                    context: context,
                                                    enableDrag: true,
                                                    isScrollControlled: true,
                                                    builder: (context) {
                                                      return FractionallySizedBox(
                                                        heightFactor: 0.7,
                                                        child: Container(
                                                            height:
                                                                height(context),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10),
                                                            child: AddEducation(
                                                              education:
                                                                  widget.education[
                                                                      index],
                                                              isEditMode: true,
                                                            )),
                                                      );
                                                    });
                                              },
                                              child: SvgPicture.asset(
                                                  'assets/images/edit_portfolio.svg')),
                                          SizedBox(
                                            width: 14,
                                          ),
                                          InkWell(
                                              onTap: () async {
                                                deletePortfolio( widget.education[
                                                                      index].id);
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/delete.svg',
                                                color: Color(0xff0E1638),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ReadMoreText(
                                        viewMore: 'View more',
                                        text: '${widget.education[index].description}',
                                        color: Color(0xff929BA3),
                                      ),
                                      if (index != widget.education.length) Divider(),
                                    ],
                                  ),
                                );
                              }))),
                ))));
  }

   void deletePortfolio(int id) {
    BlocProvider.of<HomeBloc>(context).add(SingularisDeletePortfolioEvent(portfolioId: id));
  }

  void handleSingularisDeletePortfolioState(SingularisDeletePortfolioState state){

   
    setState(() {
      switch (state.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading Add  Certificate....................");
          isEducationLoading = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Add  Certificate....................");
          isEducationLoading = false;
          Navigator.pop(context);
          break;
        case ApiStatus.ERROR:
          Log.v("Error Add Certificate....................");
          isEducationLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });

  }
}
