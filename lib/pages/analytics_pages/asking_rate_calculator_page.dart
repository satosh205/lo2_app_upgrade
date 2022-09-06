import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/notification_list_page.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';

class AskingRateCalculatorPage extends StatefulWidget {
  bool? isViewAll;

  AskingRateCalculatorPage({this.isViewAll});

  @override
  _AskingRateCalculatorPageState createState() =>
      _AskingRateCalculatorPageState();
}

class _AskingRateCalculatorPageState extends State<AskingRateCalculatorPage> {
  TextEditingController _totalMSSController =
      new TextEditingController(text: '200');
  TextEditingController _targetedOutletsECController =
      new TextEditingController(text: '200');
  TextEditingController _targetPCController =
      new TextEditingController(text: '25');
  TextEditingController _targetThroughputController =
      new TextEditingController(text: '200');
  var totalMSSFocus = FocusNode();
  var targetedOutletsFocus = FocusNode();
  var targetPCFocus = FocusNode();
  var targetThroughputFocus = FocusNode();
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedGoal = 0;
  List<String> _goalsList = [
    "Effective Coverage",
    "Productive sales calls",
    "Throughput",
    "Must Sell SKUs",
  ];

  // if _selectedGoal = 2, these are used
  double _percentTargeted = 40;
  double _currentlyAchieved = 20;

  // if _selectedGoal = 0, these are used
  double _billedOutlets = 40;
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      isBackShow: false,
      scafKey: _scaffoldKey,
      child: _mainBody(),
      isContainerHeight: !_isLoading ? false : true,
      isScrollable: true,
      // scrollReverse: true,
      bgChildColor: Color.fromRGBO(238, 238, 243, 1),
      title: Strings.of(context)?.askingRateCalculator,
      onBackPressed: () {
        Navigator.pop(context);
      },
      isNotification: true,
      onSkipClicked: () {
        Navigator.push(context, NextPageRoute(NotificationListPage()));
      },
      isLoading: _isLoading,
    );
  }

  _mainBody() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Image.asset(
              "assets/images/calculator.png",
              width: 90,
              height: 90,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 34),
            child: Text(
              '${Strings.of(context)?.Set_your_goals}',
              style: Styles.textBold(
                size: 14,
                color: Color.fromRGBO(28, 37, 85, 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(235, 238, 255, 1),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
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
                      color: Color.fromRGBO(235, 238, 255, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${Strings.of(context)?.Select_your_goal}',
                              style: Styles.textSemiBold(
                                size: 14,
                                color: Color.fromRGBO(28, 37, 85, 0.7),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 17, vertical: 11),
                          width: screenWidth,
                          // height: 41,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 16,
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                              ),
                            ],
                          ),
                          child: DropdownButton<String>(
                            underline: Center(),
                            isExpanded: true,
                            value: _goalsList[_selectedGoal],
                            items: _goalsList.map((value) {
                              return new DropdownMenuItem<String>(
                                onTap: () {
                                  setState(() {
                                    _selectedGoal = _goalsList.indexOf(value);
                                  });
                                },
                                value: value,
                                child: new Text(
                                  value,
                                  style: Styles.textExtraBold(
                                    size: 16,
                                    color: Color.fromRGBO(28, 37, 85, 1),
                                  ),
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                            onChanged: (_) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                  child: Text(
                    "Approx balance man days: ${getBalanceManDays()} Days",
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ),
                _selectedGoal == 0
                    ? _effectiveCoverageCalculator()
                    : _selectedGoal == 1
                        ? _productiveSalesCallsCalculator()
                        : _selectedGoal == 2
                            ? _throughputCalculator()
                            : _selectedGoal == 3
                                ? _mSSCalculator()
                                : Center(),
              ],
            ),
          ),
          SizedBox(
            height: 300,
          ),
        ],
      ),
    );
  }

  _productiveSalesCallsCalculator() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  '${Strings.of(context)?.Target}',
                  style: Styles.textSemiBold(
                    size: 14,
                    color: Color.fromRGBO(28, 37, 85, 0.7),
                  ),
                ),
                width: 100,
              ),
              SizedBox(
                width: 106,
                child: TextField(
                  key: formKey3,
                  controller: _targetPCController,
                  focusNode: targetPCFocus,
                  style: Styles.textBold(
                    size: 32,
                    color: Color.fromRGBO(46, 120, 228, 1),
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                child: Text(
                  '${Strings.of(context)?.Currently_achieved}',
                  style: Styles.textSemiBold(
                    size: 14,
                    color: Color.fromRGBO(28, 37, 85, 0.7),
                  ),
                ),
              ),
              SizedBox(
                width: 106,
                child: TextFormField(
                  initialValue: _currentlyAchieved.round().toString(),
                  textAlign: TextAlign.center,
                  style: Styles.textBold(
                    size: 32,
                    color: Color.fromRGBO(46, 120, 228, 1),
                  ),
                  decoration: InputDecoration(),
                  keyboardType: TextInputType.number,
                  onChanged: (input) {
                    setState(() {
                      _currentlyAchieved = double.parse(input);
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 48,
          ),
          SizedBox(
            height: 38,
            child: MaterialButton(
              color: Color.fromRGBO(46, 120, 228, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                '${Strings.of(context)?.Calculate_now}',
                style: Styles.textExtraBold(
                  size: 14,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
              onPressed: () {
                // calculate productive sales calls
                double value =
                    ((int.parse(_targetPCController.text) * getTotalManDays()) -
                            (_currentlyAchieved * getAchievedManDays())) /
                        getBalanceManDays();

                _showResult(context, value.toStringAsFixed(2));
              },
            ),
          ),
          SizedBox(
            height: 36,
          ),
        ],
      ),
    );
  }

  _throughputCalculator() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    '${Strings.of(context)?.Target}',
                    style: Styles.textSemiBold(
                      size: 14,
                      color: Color.fromRGBO(28, 37, 85, 0.7),
                    ),
                  ),
                  width: 100,
                ),
                SizedBox(
                  width: 106,
                  child: TextField(
                    key: formKey4,
                    controller: _targetThroughputController,
                    focusNode: targetThroughputFocus,
                    textAlign: TextAlign.center,
                    style: Styles.textBold(
                      size: 32,
                      color: Color.fromRGBO(46, 120, 228, 1),
                    ),
                    decoration: InputDecoration(),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                child: Text(
                  '${Strings.of(context)?.Currently_achieved}',
                  style: Styles.textSemiBold(
                    size: 14,
                    color: Color.fromRGBO(28, 37, 85, 0.7),
                  ),
                ),
              ),
              SizedBox(
                width: 106,
                child: TextFormField(
                  initialValue: _currentlyAchieved.round().toString(),
                  textAlign: TextAlign.center,
                  style: Styles.textBold(
                    size: 32,
                    color: Color.fromRGBO(46, 120, 228, 1),
                  ),
                  decoration: InputDecoration(),
                  keyboardType: TextInputType.number,
                  onChanged: (input) {
                    setState(() {
                      _currentlyAchieved = double.parse(input);
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 48,
          ),
          SizedBox(
            height: 38,
            child: MaterialButton(
              color: Color.fromRGBO(46, 120, 228, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                '${Strings.of(context)?.Calculate_now}',
                style: Styles.textExtraBold(
                  size: 14,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
              onPressed: () {
                // calculate throughput
                double value = (int.parse(_targetThroughputController.text) -
                        int.parse(_currentlyAchieved.round().toString())) /
                    getBalanceManDays();

                _showResult(context, value.toStringAsFixed(2));
              },
            ),
          ),
          SizedBox(
            height: 36,
          ),
        ],
      ),
    );
  }

  _mSSCalculator() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    '${Strings.of(context)?.Total_MSS_Points}',
                    style: Styles.textSemiBold(
                      size: 14,
                      color: Color.fromRGBO(28, 37, 85, 0.7),
                    ),
                  ),
                  width: 100,
                ),
                SizedBox(
                  width: 106,
                  child: TextField(
                    key: formKey1,
                    controller: _totalMSSController,
                    focusNode: totalMSSFocus,
                    style: Styles.textBold(
                      size: 32,
                      color: Color.fromRGBO(46, 120, 228, 1),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                child: Text(
                  "Targeted",
                  style: Styles.textSemiBold(
                    size: 14,
                    color: Color.fromRGBO(28, 37, 85, 0.7),
                  ),
                ),
              ),
              SizedBox(
                width: 106,
                child: TextFormField(
                  initialValue: _percentTargeted.round().toString(),
                  textAlign: TextAlign.center,
                  style: Styles.textBold(
                    size: 32,
                    color: Color.fromRGBO(46, 120, 228, 1),
                  ),
                  decoration: InputDecoration(),
                  keyboardType: TextInputType.number,
                  onChanged: (input) {
                    setState(() {
                      _percentTargeted = double.parse(input);
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                child: Text(
                  '${Strings.of(context)?.Currently_achieved}',
                  style: Styles.textSemiBold(
                    size: 14,
                    color: Color.fromRGBO(28, 37, 85, 0.7),
                  ),
                ),
              ),
              SizedBox(
                width: 106,
                child: TextFormField(
                  initialValue: _currentlyAchieved.round().toString(),
                  textAlign: TextAlign.center,
                  style: Styles.textBold(
                    size: 32,
                    color: Color.fromRGBO(46, 120, 228, 1),
                  ),
                  decoration: InputDecoration(),
                  keyboardType: TextInputType.number,
                  onChanged: (input) {
                    setState(() {
                      _currentlyAchieved = double.parse(input);
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 48,
          ),
          SizedBox(
            height: 38,
            child: MaterialButton(
              color: Color.fromRGBO(46, 120, 228, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                '${Strings.of(context)?.Calculate_now}',
                style: Styles.textExtraBold(
                  size: 14,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
              onPressed: () {
                // calculate MSS
                double value = (_percentTargeted - _currentlyAchieved) /
                    getBalanceManDays();

                _showResult(context, value.toStringAsFixed(2));
              },
            ),
          ),
          SizedBox(
            height: 36,
          ),
        ],
      ),
    );
  }

  _effectiveCoverageCalculator() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    '${Strings.of(context)?.Targeted_outlets}',
                    style: Styles.textSemiBold(
                      size: 14,
                      color: Color.fromRGBO(28, 37, 85, 0.7),
                    ),
                  ),
                  width: 100,
                ),
                SizedBox(
                  width: 106,
                  child: TextField(
                    key: formKey2,
                    controller: _targetedOutletsECController,
                    focusNode: targetedOutletsFocus,
                    textAlign: TextAlign.center,
                    style: Styles.textBold(
                      size: 32,
                      color: Color.fromRGBO(46, 120, 228, 1),
                    ),
                    decoration: InputDecoration(),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                child: Text(
                  '${Strings.of(context)?.Billed_outlets}',
                  style: Styles.textSemiBold(
                    size: 14,
                    color: Color.fromRGBO(28, 37, 85, 0.7),
                  ),
                ),
              ),
              SizedBox(
                width: 106,
                child: TextFormField(
                  initialValue: _billedOutlets.round().toString(),
                  textAlign: TextAlign.center,
                  style: Styles.textBold(
                    size: 32,
                    color: Color.fromRGBO(46, 120, 228, 1),
                  ),
                  decoration: InputDecoration(),
                  keyboardType: TextInputType.number,
                  onChanged: (input) {
                    setState(() {
                      _billedOutlets = double.parse(input);
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 48,
          ),
          SizedBox(
            height: 38,
            child: MaterialButton(
              color: Color.fromRGBO(46, 120, 228, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                '${Strings.of(context)?.Calculate_now}',
                style: Styles.textExtraBold(
                  size: 14,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
              onPressed: () {
                // calculate EC
                double value = (int.parse(_targetedOutletsECController.text) -
                        _billedOutlets) /
                    int.parse(_targetedOutletsECController.text);

                _showResult(context, value.toStringAsFixed(2), isECO: true);
              },
            ),
          ),
          SizedBox(
            height: 36,
          ),
        ],
      ),
    );
  }

  _showResult(BuildContext context, String calculatedValue,
      {bool isECO = false}) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String balanceManDays = getBalanceManDays().toString();

    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          children: [
            Container(
              height: screenHeight * 0.5,
              width: screenWidth,
              color: Colors.white,
              child: Column(
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    '${Strings.of(context)?.Calculated_asking_rate}',
                    style: Styles.textExtraBold(
                      size: 22,
                      color: Color.fromRGBO(28, 37, 85, 1),
                    ),
                    maxLines: 1,
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      '${Strings.of(context)?.Manage_your_everyday}',
                      style: Styles.textSemiBold(
                        size: 14,
                        color: Color.fromRGBO(28, 37, 85, 0.8),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  !isECO
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              calculatedValue,
                              style: Styles.textExtraBold(
                                size: 32,
                                color: Color.fromRGBO(28, 37, 85, 1),
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              "/day",
                              style: Styles.textSemiBold(
                                size: 20,
                                color: Color.fromRGBO(28, 37, 85, 1),
                              ),
                              maxLines: 1,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              calculatedValue,
                              style: Styles.textExtraBold(
                                size: 32,
                                color: Color.fromRGBO(28, 37, 85, 1),
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              "%",
                              style: Styles.textSemiBold(
                                size: 20,
                                color: Color.fromRGBO(28, 37, 85, 1),
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                  Text(
                    "${Strings.of(context)?.For_next} $balanceManDays ${Strings.of(context)?.Days}",
                    style: Styles.textSemiBold(
                      size: 14,
                      color: Color.fromRGBO(28, 37, 85, 0.7),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  int getTotalManDays() {
    DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month,
        lastDayOfMonth(DateTime.now()).day);

    return getDifferenceWithoutWeekends(startDate, endDate);
  }

  int getAchievedManDays() {
    DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    DateTime endDate = DateTime.now().subtract(Duration(days: 1));

    return getDifferenceWithoutWeekends(startDate, endDate);
  }

  int getBalanceManDays() {
    return getTotalManDays() - getAchievedManDays();
  }

  int getDifferenceWithoutWeekends(DateTime startDate, DateTime endDate) {
    int nbDays = 0;
    DateTime currentDay = startDate;
    while (currentDay.isBefore(endDate)) {
      currentDay = currentDay.add(Duration(days: 1));
      if (currentDay.weekday != DateTime.sunday) {
        nbDays += 1;
      }
    }
    return nbDays;
  }

  /// The last day of a given month
  static DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }
}
