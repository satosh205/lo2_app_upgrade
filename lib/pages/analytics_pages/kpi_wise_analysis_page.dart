import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as TextElement;
import 'package:charts_flutter/src/text_style.dart' as style;
//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/response/home_response/get_kpi_analysis_resp.dart';

int value = 0;
bool isDrawn = false;

class KPIWiseAnalysisPage extends StatefulWidget {
  @override
  _KPIWiseAnalysisPageState createState() => _KPIWiseAnalysisPageState();
}

class _KPIWiseAnalysisPageState extends State<KPIWiseAnalysisPage> {
  bool _isLoading = true;

  List<KpiDatum> _getKpiAnalysisResp = [];

  Map<int, bool> isExpandedMap = new Map();
  var colorCodes = [
    '#FF5733',
    '#FFE933',
    '#74FF33',
    '#33CAFF',
    '#FF33FC',
    '#FF3333'
  ];
  Map<String, Map<String, String>> titleCodes = new Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getKPIWiseData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            Log.v("Loading....................KPI build");
            if (state is GetKPIAnalysisState) _handleAnnouncmentData(state);
          },
          child: _buildMain(),
        ));
  }

  _buildMain() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.only(top: 20),
        child: material.Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                '${Strings.of(context)?.KPIs_assigned}',
                style: Styles.textExtraBold(
                  size: 18,
                  color: Color.fromRGBO(255, 141, 41, 1),
                ),
              ),
            ),
            SizedBox(
              height: 11,
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box("analytics").listenable(),
              builder: (bc, Box box, child) {
                if (box.get("kpiData") == null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (box.get("kpiData").isEmpty) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 1.8,
                    child: Center(
                      child: Text(
                        "No data",
                        style: Styles.textBold(),
                      ),
                    ),
                  );
                }
                _getKpiAnalysisResp = box
                    .get("kpiData")
                    .map((e) => KpiDatum.fromJson(Map<String, dynamic>.from(e)))
                    .cast<KpiDatum>()
                    .toList();
                return SizedBox(
                  width: screenWidth,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _getKpiAnalysisResp.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      List<Map<String, dynamic>> columnData = [];
                      _getKpiAnalysisResp[index].columns?.forEach((element) {
                        columnData.add(getSalesData(
                            element, '${_getKpiAnalysisResp[index].kpiName}'));
                      });
                      List<charts.Series<OrdinalSales, String>> seriesList =
                          getChatData(columnData,
                              '${_getKpiAnalysisResp[index].kpiName}');
                      isExpandedMap.putIfAbsent(
                          index, () => index == 0 ? true : false);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpandedMap.update(index, (value) => !value);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(235, 238, 255, 1),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(
                                  isExpandedMap[index] == true ? 0 : 8),
                              bottomLeft: Radius.circular(
                                  isExpandedMap[index] == true ? 0 : 8),
                              topRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            ),
                          ),
                          child: material.Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(
                                        isExpandedMap[index] == true ? 0 : 8),
                                    bottomLeft: Radius.circular(
                                        isExpandedMap[index] == true ? 0 : 8),
                                    topRight: Radius.circular(8),
                                    topLeft: Radius.circular(8),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 16,
                                      color: Color.fromRGBO(0, 0, 0, 0.05),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: isExpandedMap[index] == true
                                        ? Color.fromRGBO(235, 238, 255, 1)
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        (index + 1).toString(),
                                        style: Styles.textSemiBold(
                                          size: 12,
                                          color: Color.fromRGBO(52, 50, 58, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        '${_getKpiAnalysisResp[index].kpiName}',
                                        style: Styles.textExtraBold(
                                          size: 14,
                                          color:
                                              Color.fromRGBO(28, 37, 85, 0.9),
                                        ),
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              isExpandedMap[index] == true
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: material.Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${Strings.of(context)?.Monthly_performance}',
                                            style: Styles.textBold(
                                              size: 16,
                                              color:
                                                  Color.fromRGBO(28, 37, 85, 1),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          _getTitleBanner(index),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Stack(
                                            alignment: Alignment.centerLeft,
                                            children: [
                                              SizedBox(
                                                height: 200,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Builder(
                                                    builder: (context) {
                                                      return charts.BarChart(
                                                        seriesList,
                                                        behaviors: [
                                                          charts.LinePointHighlighter(
                                                              radiusPaddingPx:
                                                                  0,
                                                              defaultRadiusPx:
                                                                  0,
                                                              showHorizontalFollowLine:
                                                                  charts
                                                                      .LinePointHighlighterFollowLineType
                                                                      .none,
                                                              showVerticalFollowLine:
                                                                  charts
                                                                      .LinePointHighlighterFollowLineType
                                                                      .none,
                                                              symbolRenderer:
                                                                  CustomCircleSymbolRenderer())
                                                        ],
                                                        animate: false,
                                                        selectionModels: [
                                                          new charts
                                                              .SelectionModelConfig(
                                                            type: charts
                                                                .SelectionModelType
                                                                .info,
                                                            changedListener:
                                                                _onSelectionChanged,
                                                          )
                                                        ],

                                                        // Configure a stroke width to enable borders on the bars.
                                                        defaultRenderer: new charts
                                                            .BarRendererConfig(
                                                          groupingType: charts
                                                              .BarGroupingType
                                                              .grouped,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              RotatedBox(
                                                quarterTurns: 3,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Rank",
                                                      style:
                                                          Styles.textSemiBold(
                                                        size: 10,
                                                        color: Color.fromRGBO(
                                                            28, 37, 85, 0.6),
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.black,
                                                      size: 16,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Month",
                                                style: Styles.textSemiBold(
                                                  size: 10,
                                                  color: Color.fromRGBO(
                                                      28, 37, 85, 0.6),
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: Colors.black,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Center(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: 400,
            ),
          ],
        ),
      ),
    );
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    OrdinalSales time;
    final measures = <String, num>{};
    isDrawn = false;
    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures['${datumPair.series.displayName}'] = datumPair.datum.sales;
      });
      value = time.sales;
    }

    // Log.v("time : ${time.sales}");
  }

  getChatData(List<Map<String, dynamic>> listData, String kpiName) {
    List<charts.Series<OrdinalSales, String>> seriesList = [];
    listData.forEach((columnData) {
      Log.v("data $columnData");
      columnData.keys.forEach((element) {
        seriesList.add(new charts.Series<OrdinalSales, String>(
          id: element,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: columnData[element],
          colorFn: (_, __) =>
              charts.Color.fromHex(code: '${titleCodes[kpiName]![element]}'),
          fillColorFn: (_, __) =>
              charts.Color.fromHex(code: '${titleCodes[kpiName]![element]}'),
        ));
      });
    });
    return seriesList;
  }

  void _getKPIWiseData() {
    Log.v("Loading....................GetKPI_getHomeData");
    BlocProvider.of<HomeBloc>(context).add(GetKPIAnalysisEvent());
  }

  void _handleAnnouncmentData(GetKPIAnalysisState state) {
    var loginState = state;
    // setState(() {
    switch (loginState.apiState) {
      case ApiStatus.LOADING:
        _isLoading = true;
        Log.v("Loading....................GetCoursesState");
        break;
      case ApiStatus.SUCCESS:
        Log.v("Success....................GetCoursesState");
        _isLoading = false;
        // _getKpiAnalysisResp = state.response;
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
    // });
  }

  Widget getTitleWidget(String title, String colorCode) {
    return Row(
      children: [
        Container(
          height: 2,
          width: 16,
          decoration: BoxDecoration(
            color: HexColor.fromHex(colorCode),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: Styles.textSemiBold(
            size: 10,
            color: Color.fromRGBO(28, 37, 85, 0.8),
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Map<String, dynamic> getSalesData(
      Map<String, dynamic> columMap, String kpiName) {
    Log.v(columMap);
    Map<String, dynamic> salesData = Map();
    var random = Random();
    Map<String, String> colors = Map();
    columMap.keys.forEach((element) {
      if (element != 'year' && element != 'month') {
        Log.v(columMap['month'].toString() + "'" + columMap['year'].toString());
        List<OrdinalSales> data = [];
        if (titleCodes.containsKey(kpiName)) {
          colors[element] = '${titleCodes[kpiName]![element]}';
        } else
          colors[element] = colorCodes[random.nextInt(6)];
        data.add(
          new OrdinalSales(
            columMap['month'].toString() + "'" + columMap['year'].toString(),
            int.parse(columMap[element]),
          ),
        );
        salesData[element] = data;
      }
    });
    titleCodes[kpiName] = colors;
    return salesData;
  }

  _getTitleBanner(int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.centerRight,
        child: Wrap(
          alignment: WrapAlignment.end,
          children: titleCodes[_getKpiAnalysisResp[index].kpiName]!
              .keys
              .map((e) => getTitleWidget(e,
                  '${titleCodes['${_getKpiAnalysisResp[index].kpiName}']![e]}'))
              .toList(),
        ),
      ),
    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      charts.Color? fillColor,
      charts.FillPatternType? fillPattern,
      charts.Color? strokeColor,
      double? strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    // canvas.drawRect(
    //     Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10,
    //         bounds.height + 10),
    //     fill: charts.Color.transparent);
    var textStyle = style.TextStyle();
    textStyle.color = charts.Color.black;
    textStyle.fontSize = 15;
    if (isDrawn == false) {
      canvas.drawText(
          TextElement.TextElement(value.toString(), style: textStyle),
          (bounds.left).round(),
          (bounds.top - 28).round());
      isDrawn = true;
    }
  }
}
