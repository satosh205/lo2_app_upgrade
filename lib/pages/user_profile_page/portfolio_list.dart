import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_portfolio.dart';
import 'package:masterg/pages/user_profile_page/portfolio_detail.dart';
import 'package:masterg/utils/Log.dart';
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
    bool? isPortfolioLoading = false;
    List<Portfolio>? portfolioList;

    @override
  void initState() {
   updateValue();
    super.initState();
  }
  void updateValue(){
     portfolioList = widget.portfolioList;
     setState(() {
       
     });
  }

  @override
  Widget build(BuildContext context) {

    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is PortfolioState) {
              handlePortfolioState(state);
            }
          },
          child:  Scaffold(
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
                                        }).then((value) =>  BlocProvider.of<HomeBloc>(context).add(PortfolioEvent()));

                                        print('make api call for update');
          }, icon: Icon(Icons.add, color: ColorConstants.BLACK,))
        ],
        title: Text('Portfolio', style: Styles.bold(),),),
      body: ScreenWithLoader(
        isLoading: isPortfolioLoading,
        body: ListView.builder(
        shrinkWrap: true,
        itemCount: portfolioList?.length,
        itemBuilder: (context, index){
        return InkWell(

          onTap: ()async{


 Navigator.of(context).push( PageRouteBuilder(
  transitionDuration: Duration(milliseconds: 600),
  reverseTransitionDuration: Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) =>  PortfolioDetail(
      baseUrl: widget.baseUrl,
      portfolio: portfolioList![index],),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  ));



              //  await showModalBottomSheet(
              //                           shape: RoundedRectangleBorder(
              //                               borderRadius:
              //                                   BorderRadius.circular(20)),
              //                           context: context,
              //                           enableDrag: true,
              //                           isScrollControlled: true,
              //                           builder: (context) {
              //                             return FractionallySizedBox(
              //                               heightFactor: 0.7,
              //                               child: Container(
              //                                   height: height(context),
              //                                   padding:
              //                                       const EdgeInsets.all(8.0),
              //                                   margin: const EdgeInsets.only(
              //                                       top: 10),
              //                                   child: PortfolioDetail(portfolio: portfolioList![index],),
              //                             ));
              //                           });
          },
          child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          '${widget.baseUrl}${portfolioList?[index].imageName}',
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
                                            ),
        );
          }),
      ),)));
  }


  void handlePortfolioState(PortfolioState state) {
    var portfolioState = state;
    setState(() async {
      switch (portfolioState.apiState) {
        case ApiStatus.LOADING:
          Log.v("PortfolioState Loading....................");
          isPortfolioLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("PortfolioState Success....................");
         portfolioList = portfolioState.response?.data.portfolio;
          isPortfolioLoading = false;

          setState(() {});
          break;

        case ApiStatus.ERROR:
          isPortfolioLoading = false;
          Log.v("PortfolioState Error..........................");
          Log.v(
              "PortfolioState Error..........................${portfolioState.error}");

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}