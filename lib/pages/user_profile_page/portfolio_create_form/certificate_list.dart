import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/new_portfolio_response.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_certificate.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:page_transition/page_transition.dart';

class CertificateList extends StatefulWidget {
  final List<CommonProfession>? certificates;
  final String baseUrl;
  const CertificateList({Key? key, this.certificates, required this.baseUrl})
      : super(key: key);

  @override
  State<CertificateList> createState() => _CertificateListState();
}

class _CertificateListState extends State<CertificateList> {
  List<CommonProfession>? certificates;
  bool deleteCertificate = false;

  @override
  void initState() {
    certificates = widget.certificates;
    // education?.sort((a, b) => b.endDate.compareTo(a.endDate));
    certificates?.sort((b, a)=>a.startDate.compareTo(b.startDate));
    super.initState();
  }

  List<String> listOfMonths = [
    "January",
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Certificates", style: Styles.bold()),
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
                              child: AddCertificate()))
                      .then((value) => updatePortfolioList());

                  // await showModalBottomSheet(
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(20)),
                  //     context: context,
                  //     enableDrag: true,
                  //     isScrollControlled: true,
                  //     builder: (context) {
                  //       return FractionallySizedBox(
                  //         heightFactor: 0.7,
                  //         child: Container(
                  //             height: height(context),
                  //             padding: const EdgeInsets.all(8.0),
                  //             margin: const EdgeInsets.only(top: 10),
                  //             child: AddCertificate()),
                  //       );
                  //     }).then((value) => updatePortfolioList());
                },
                icon: Icon(
                  Icons.add,
                  color: ColorConstants.BLACK,
                )),
          ],
        ),
        body: ScreenWithLoader(
            isLoading: deleteCertificate,
            body: BlocListener<HomeBloc, HomeState>(
                listener: (context, state) async {
                  if (state is SingularisDeletePortfolioState) {
                    handleDeletePortfolio(state);
                  }
                  if (state is PortfolioState) {
                    handlePortfolioState(state);
                  }
                },
                child: Container(
                    height: height(context) * 1,
                    width: width(context),
                    child: ListView.builder(
                        itemCount: certificates?.length,
                        itemBuilder: (context, index) {
                          String startDateString =
                              "${certificates?[index].startDate}";

                          DateTime startDate =
                              DateFormat("yyy-MM-dd").parse(startDateString);
                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  context: context,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return FractionallySizedBox(
                                      heightFactor: 0.9,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${widget.baseUrl}${certificates?[index].imageName}",
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorWidget: (context, url, data) =>
                                            Image.asset(
                                          "assets/images/certificate_dummy.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox(
                                            width: width(context),
                                            height: width(context) * 0.45,
                                            child: CachedNetworkImage(
                                              width: width(context) * 0.7,
                                              height: width(context) * 0.45,
                                              imageUrl:
                                                  "${widget.baseUrl}${certificates?[index].imageName}",
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, data) =>
                                                      Image.asset(
                                                "assets/images/certificate_dummy.png",
                                                fit: BoxFit.cover,
                                              ),
                                            ))),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width(context) * 0.75,
                                          child: Text(
                                            "${certificates?[index].title}",
                                            maxLines: 2,
                                            style: Styles.bold(),
                                          ),
                                        ),
                                        Spacer(),
                                        InkWell(
                                            onTap: () async {
                                              await Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      duration: Duration(
                                                          milliseconds: 350),
                                                      reverseDuration: Duration(
                                                          milliseconds: 350),
                                                      type: PageTransitionType
                                                          .bottomToTop,
                                                      child: AddCertificate(
                                                        isEditMode: true,
                                                        cetificate:
                                                            certificates?[
                                                                index],
                                                      ))).then((value) =>
                                                  updatePortfolioList());
                                            },
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: SvgPicture.asset(
                                                  'assets/images/edit_portfolio.svg'),
                                            )),
                                        SizedBox(
                                          width: 22,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              AlertsWidget.showCustomDialog(
                                                  context: context,
                                                  title: '',
                                                  text:
                                                      'Are you sure you want to delete?',
                                                  icon:
                                                      'assets/images/circle_alert_fill.svg',
                                                  onOkClick: () async {
                                                    deleteResume(
                                                        certificates![index]
                                                            .id);
                                                  });
                                            },
                                            child: SvgPicture.asset(
                                                'assets/images/delete.svg')),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      '${listOfMonths[startDate.month - 1].substring(0, 3)} ${startDate.year.toString().substring(2,4)}',
                                      style: Styles.regular(size: 12),
                                    ),
                                  ]),
                            ),
                          );
                        })))));
  }

  void deleteResume(int id) {
    BlocProvider.of<HomeBloc>(context)
        .add(SingularisDeletePortfolioEvent(portfolioId: id));
  }

  void handleDeletePortfolio(SingularisDeletePortfolioState state) {
    setState(() {
      switch (state.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading Add  Certificate....................");
          deleteCertificate = true;
          updatePortfolioList();
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Add  Certificate....................");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Certificate deleted')),
          );
          deleteCertificate = false;
          break;
        case ApiStatus.ERROR:
          Log.v("Error Add Certificate....................");
          deleteCertificate = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
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
          deleteCertificate = true;
          setState(() {});

          break;
        case ApiStatus.SUCCESS:
          Log.v("PortfolioState Success....................");
          certificates = portfolioState.response?.data.certificate;
    certificates?.sort((b, a)=>a.startDate.compareTo(b.startDate));


          deleteCertificate = false;

          setState(() {});
          break;

        case ApiStatus.ERROR:
          deleteCertificate = false;
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
