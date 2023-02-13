import 'dart:math' as math;
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/job_domain_detail_resp.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class LineChartWidget extends StatefulWidget {
  final int? domainid;

  const LineChartWidget({super.key, required this.domainid});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  final List<Color> gradientColors = [
    Color(0xff3EBDA0),
    Color(0xff3EBDA0),
  ];
  bool _isLoading = true;
  JobDomainResponse? domainData;
  double maxX = 0;
  double maxY = 0;
  double minX = 2090;
  double minY = 2090;

  @override
  void initState() {
    getDomainData(widget.domainid!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is JobDomainDetailState) {
            handleDomainDetial(state);
          }
        },
        child: ScreenWithLoader(
          isLoading: _isLoading,
          body: _isLoading
              ? SizedBox()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height(context) * 0.4,
                        child: LineChart(
                          LineChartData(
                            minX: minX,
                            maxX: maxX,
                            minY: minY,
                            maxY: maxY,
                            baselineX: 200,
                            titlesData: FlTitlesData(
                                topTitles: AxisTitles(),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                show: true,
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false, interval: 100),
                                    axisNameWidget: Text(
                                      'No. of jobs',
                                      style: Styles.regular(size: 12),
                                    )),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                  axisNameWidget: Text(
                                      '${domainData?.data?.graphText}',
                                      style: Styles.regular(size: 12)),
                                )),
                            gridData: FlGridData(
                              // verticalInterval: 10,
                              show: true,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: const Color(0xff37434d),
                                  strokeWidth: 0.3,
                                );
                              },
                              drawVerticalLine: false,
                              getDrawingVerticalLine: (value) {
                                return FlLine(
                                  color: const Color(0xff37434d),
                                  strokeWidth: 0.3,
                                );
                              },
                            ),
                            borderData: FlBorderData(
                              show: false,
                              border: Border.all(
                                  color: const Color(0xff37434d), width: 1),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: domainData!.data!.graphArr
                                    .map((e) => FlSpot(double.parse(e[0]),
                                        double.parse('${e[1]}')))
                                    .toList(),
                                isCurved: true,
                                color: gradientColors[0],
                                barWidth: 1.2,
                                belowBarData: BarAreaData(
                                    show: true,
                                    color: gradientColors[0].withOpacity(0.3)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Table(
                        children: [
                          TableRow(children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 12),
                                child: Text(
                                  "Job Roles",
                                  style: Styles.regular(size: 12),
                                )),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Text(
                                  "Salary Range",
                                  style: Styles.regular(size: 12),
                                )),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Text(
                                  "Annual Growth",
                                  style: Styles.regular(size: 12),
                                )),
                          ]),
                        ],
                      ),
                      Table(
                        children: domainData!.data!.list
                            .map((e) => TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                    child: Text(
                                      '${e.title}',
                                      style: Styles.bold(size: 12),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 25),
                                      child: Text(
                                        '${e.salary}',
                                        style: Styles.regular(size: 12),
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 25),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                              e.growthType != 'up'
                                                  ? '-${e.growth}%'
                                                  : '+${e.growth}%',
                                              style: Styles.regular(
                                                  size: 12,
                                                  color: e.growthType != 'up'
                                                      ? ColorConstants.RED
                                                      : gradientColors[0])),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Transform(
                                            alignment: Alignment.center,
                                            transform: e.growthType != 'up'
                                                ? Matrix4.rotationX(math.pi)
                                                : Matrix4.rotationY(0),
                                            child: SvgPicture.asset(
                                              'assets/images/growth_up.svg',
                                              color: e.growthType != 'up'
                                                  ? ColorConstants.RED
                                                  : null,
                                            ),
                                          )
                                        ],
                                      ))
                                ]))
                            .toList(),
                        // children: [
                        //   TableRow(children: [
                        //     Text("Job Roles"),
                        //     Text("Salary Range"),
                        //     Text("Annual Growth"),
                        //   ]),
                        // ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 20),
                      //   child: Center(
                      //       child: Container(
                      //     padding: EdgeInsets.symmetric(horizontal: 12),
                      //     child: Column(
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             SizedBox(
                      //                 width: width(context) * 0.4,
                      //                 child: Text(
                      //                   'Job Roles',
                      //                   style: Styles.regular(size: 12),
                      //                 )),
                      //             SizedBox(
                      //               width: width(context) * 0.6,
                      //               child: Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.spaceBetween,
                      //                 children: [
                      //                   Text(
                      //                     'Salary Range',
                      //                     style: Styles.regular(size: 12),
                      //                   ),
                      //                   Spacer(),
                      //                   Text('Annual Growth',
                      //                       style: Styles.regular(size: 12)),
                      //                   // Transform.rotate(
                      //                   //   angle: growthType != 'up' ? 15 * math.pi / 180: 0.0,
                      //                 ],
                      //               ),
                      //             )
                      //           ],
                      //         ),
                      //         Divider()
                      //       ],
                      //     ),
                      //   )),
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 20),
                      //   child: Center(
                      //       child: Column(
                      //           children: domainData!.data!.list
                      //               .map((e) => card(e.title, e.salary,
                      //                   e.growth, e.growthType))
                      //               .toList())),
                      // ),
// card('Ui desing', 'sdf', 'sdfsd'),

                      //     CustomOutlineButton(
                      //   strokeWidth: 2,
                      //   radius: 50,
                      //   gradient: LinearGradient(
                      //     colors: [
                      //       ColorConstants.GRADIENT_ORANGE,
                      //       ColorConstants.GRADIENT_RED
                      //     ],
                      //     begin: Alignment.topLeft,
                      //     end: Alignment.topRight,
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                      //     child: GradientText(
                      //       'View Skill Assessments',
                      //       style: Styles.textRegular(size: 14),
                      //       colors: [
                      //          ColorConstants.GRADIENT_ORANGE,
                      //         ColorConstants.GRADIENT_RED,
                      //       ],
                      //     ),
                      //   ),
                      //   onPressed: () {},
                      // ),
                    ],
                  ),
                ),
        ),
      );

  Widget card(String jobrole, String salaryRange, String annualGrowth,
      String growthType) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: width(context) * 0.4,
                  child: Text(
                    '$jobrole',
                    style: Styles.bold(size: 12),
                  )),
              SizedBox(
                width: width(context) * 0.25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$salaryRange',
                      style: Styles.regular(size: 12),
                    ),
                    Spacer(),
                  ],
                ),
              )
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  void getDomainData(int domainId) {
    BlocProvider.of<HomeBloc>(context)
        .add(JobDomainDetailEvent(domainId: domainId));
  }

  void handleDomainDetial(JobDomainDetailState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          _isLoading = true;
          Log.v("Loading....................GetCoursesState");
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................GetCoursesState");
          _isLoading = false;
          domainData = state.response;
          if (domainData?.data?.graphArr.length != 0) {
            for (int i = 0; i < domainData!.data!.graphArr.length; i++) {
              maxX = max(maxX, double.parse(domainData!.data!.graphArr[i][0]));
              maxY = max(maxY,
                  double.parse(domainData!.data!.graphArr[i][1].toString()));
              minX = min(minX, double.parse(domainData!.data!.graphArr[i][0]));
              minY = min(minY,
                  double.parse(domainData!.data!.graphArr[i][1].toString()));
            }
          }
          //   _getCoursesResp = state.response;
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................GetCoursesState");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }
}
