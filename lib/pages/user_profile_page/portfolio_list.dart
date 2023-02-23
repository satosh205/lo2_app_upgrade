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
import 'package:page_transition/page_transition.dart';

class PortfolioList extends StatefulWidget {
  final List<Portfolio>? portfolioList;
  final String? baseUrl;
  const PortfolioList(
      {Key? key, required this.portfolioList, required this.baseUrl})
      : super(key: key);

  @override
  State<PortfolioList> createState() => _PortfolioListState();
}

class _PortfolioListState extends State<PortfolioList> {
  bool? isPortfolioLoading = true;
  List<Portfolio>? portfolioList;

  @override
  void initState() {
    updateValue();
    updatePortfolioList();

    super.initState();
  }

  void updateValue() {
    print('update my list');

    if (portfolioList?.length == 0) {
      portfolioList = widget.portfolioList;
    }
    setState(() {});
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
                      await Navigator.push(
                              context,
                              PageTransition(
                                  duration: Duration(milliseconds: 350),
                                  reverseDuration: Duration(milliseconds: 350),
                                  type: PageTransitionType.bottomToTop,
                                  child: AddPortfolio()))
                          .then((value) => updatePortfolioList());
                    },
                    icon: Icon(
                      Icons.add,
                      color: ColorConstants.BLACK,
                    ))
              ],
              title: Text(
                'Portfolio',
                style: Styles.bold(),
              ),
            ),
            body: ScreenWithLoader(
              isLoading: isPortfolioLoading,
              body: ListView.builder(
                  key: const PageStorageKey<String>('portfolioList'),
                  shrinkWrap: true,
                  itemCount: portfolioList?.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 350),
                                reverseDuration: Duration(milliseconds: 350),
                                type: PageTransitionType.bottomToTop,
                                child: PortfolioDetail(
                                  baseUrl: widget.baseUrl,
                                  portfolio: portfolioList![index],
                                )));

                        updatePortfolioList();
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                fadeOutDuration: Duration(seconds: 0),
                                imageUrl:
                                    '${widget.baseUrl}${portfolioList?[index].imageName}',
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    padding: EdgeInsets.all(14),
                                    decoration:
                                        BoxDecoration(color: Color(0xffD5D5D5)),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${portfolioList?[index].portfolioTitle ?? ""}',
                              style: Styles.bold(),
                            ),
                            Text('${portfolioList?[index].desc ?? ""}',
                                style: Styles.semibold(
                                    size: 12, color: Color(0xff929BA3))),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ));
  }

  void updatePortfolioList() {
    print('make api call');
    BlocProvider.of<HomeBloc>(context).add(PortfolioEvent());
  }

  void handlePortfolioState(PortfolioState state) {
    var portfolioState = state;
    setState(() async {
      switch (portfolioState.apiState) {
        case ApiStatus.LOADING:
          Log.v("PortfolioState Loading....................");
          isPortfolioLoading = true;
          setState(() {});

          break;
        case ApiStatus.SUCCESS:
          Log.v("PortfolioState Success....................");
          portfolioList = portfolioState.response?.data.portfolio;
          isPortfolioLoading = false;

          setState(() {});
          break;

        case ApiStatus.ERROR:
          isPortfolioLoading = false;
          setState(() {});

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
