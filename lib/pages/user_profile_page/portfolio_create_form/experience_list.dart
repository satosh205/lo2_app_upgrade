import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/new_portfolio_response.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/ghome/widget/read_more.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_experience.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class ExperienceList extends StatefulWidget {

  final List<CommonProfession>? experience;
  final String? baseUrl;
  
  const ExperienceList({Key? key, this.baseUrl, required this.experience}) : super(key: key);

  @override
  State<ExperienceList> createState() => _ExperienceListState();
}

class _ExperienceListState extends State<ExperienceList> {
  bool isExperienceLoading = false;
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
  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (value) {},
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) async {
              if (state is SingularisDeletePortfolioState)
                handleSingularisDeletePortfolioState(state);
            },
            child:Scaffold(
               appBar: AppBar(
                  title: Text("Experience",
                      style: Styles.bold()),
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
                                      child: AddExperience()),
                                );
                              });
                        },
                        icon: Icon(
                          Icons.add,
                          color: ColorConstants.BLACK,
                        )),
                  ],
                ),
                body: ScreenWithLoader(
                  isLoading: isExperienceLoading,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                        height: height(context) * 0.9,
                        width: width(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              itemCount: widget.experience?.length,
                              itemBuilder: (BuildContext context, int index) {

 String startDateString =
                              "${widget.experience?[index].startDate}";
                     
                          DateTime startDate =
                              DateFormat("dd/MM/yyyy").parse(startDateString);
                     
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width(context) * 0.2,
                            height: width(context) * 0.2,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${widget.baseUrl}${widget.experience?[index].imageName}",
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) => Container(
                                  width: width(context) * 0.2,
                                  height: width(context) * 0.2,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: ColorConstants.DIVIDER,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: SvgPicture.asset(
                                      'assets/images/extra.svg')),
                            ),
                          ),
                          SizedBox(width: 6),
                          SizedBox(
                            width: width(context) * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width(context) * 0.5,
                                      child: Text(
                                        '${widget.experience?[index].title}',
                                        style: Styles.bold(size: 16),
                                      ),
                                    ),
                                     
                                                          SvgPicture.asset(
                                                              'assets/images/edit_portfolio.svg'),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              deletePortfolio(
                                                                  widget
                                                                      .experience![
                                                                          index]
                                                                      .id);
                                                            },
                                                            child: SvgPicture.asset(
                                                                'assets/images/delete.svg'),
                                                          ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '${widget.experience?[index].institute}',
                                  style: Styles.regular(size: 14),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                          children: [
                                          
                                           
                                Text('${widget.experience?[index].curricularType.replaceAll('_', '')} • '),
                                  Text(
                                              '  ${startDate.day} ${listOfMonths[startDate.month - 1]} ',
                                              style: Styles.regular(size: 14),
                                            ),

                                          ],
                                        )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      ReadMoreText(
                        viewMore: 'View more',
                        text: '${widget.experience?[index].description}',
                        color: Color(0xff929BA3),
                      ),
                      if (index != widget.experience?.length) Divider()
                    ],
                  ),
                );

                         
                              }),
                        )),
                  ),
                ))));
  }

  void deletePortfolio(int id) {
    BlocProvider.of<HomeBloc>(context)
        .add(SingularisDeletePortfolioEvent(portfolioId: id));
  }

  void handleSingularisDeletePortfolioState(
      SingularisDeletePortfolioState state) {
    setState(() {
      switch (state.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading Delete Experience....................");
          isExperienceLoading = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Delete  Experience....................");
           isExperienceLoading = false;

          Navigator.pop(context);
          break;
        case ApiStatus.ERROR:
          Log.v("Error Delete Experience....................");
         isExperienceLoading= false;

          break;
        case ApiStatus.INITIAL:
          break;
      }
    }

            );
    
  }
}