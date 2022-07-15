import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

class Calendar extends StatefulWidget {
  final Function? sendValue;

  const Calendar({super.key, this.sendValue});
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDate = DateTime.now();
  DateTime todayDate = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime startDate = DateTime(2022, 6, 1);
  late int currentDateSelectedIndex;
  bool isScrolled = false;
  ScrollController scrollController =
      ScrollController(); //To Track Scroll of ListView
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
  List<String> listOfDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  Widget build(BuildContext context) {
    final String formatted = formatter.format(todayDate);
    //string to date
    todayDate = DateTime.parse(formatted);

    currentDateSelectedIndex = selectedDate.difference(startDate).inDays;
    if (!isScrolled) {
      Future.delayed(Duration(seconds: 1), () {}).then((value) {
        scrollController.animateTo(
          currentDateSelectedIndex * 60.0,
          duration: Duration(milliseconds: 1),
          curve: Curves.linear,
        );
      });
      isScrolled = true;
    }

    int dayDiff = DateTime.parse(formatter.format(selectedDate))
        .difference(todayDate)
        .inDays;
    return Column(
      children: [
        //To Show Current Date
        Container(
            alignment: Alignment.centerLeft,
            child: Text(
              listOfDays[selectedDate.weekday - 1].toString() +
                  ', ' +
                  selectedDate.day.toString() +
                  ' ' +
                  listOfMonths[selectedDate.month - 1] +
                  ', ' +
                  selectedDate.year.toString(),
              style: Styles.regular(size: 14),
            )),
        Container(
            alignment: Alignment.centerLeft,
            child: Text(
              dayDiff == 0
                  ? "Today"
                  : dayDiff == -1
                      ? "Yesterday"
                      : dayDiff == 1
                          ? "Tomorrow"
                          : dayDiff < -1
                              ? "${dayDiff.abs()} days ago"
                              : "$dayDiff days",
              style: Styles.bold(size: 18),
            )),
        SizedBox(height: 10),
        //To show Calendar Widget
        Container(
            height: 80,
            child: Container(
                child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: 10);
              },
              itemCount: 730,
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      currentDateSelectedIndex = index;
                      selectedDate = startDate.add(Duration(days: index));
                      widget.sendValue!(selectedDate);
                    });
                  },
                  child: Container(
                    height: 80,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentDateSelectedIndex == index
                          ? ColorConstants.PRIMARY_COLOR
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          listOfMonths[
                                  startDate.add(Duration(days: index)).month -
                                      1]
                              .toString()
                              .substring(0, 3),
                          style: TextStyle(
                              fontSize: 16,
                              color: currentDateSelectedIndex == index
                                  ? Colors.white
                                  : Colors.grey),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          startDate.add(Duration(days: index)).day.toString(),
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: currentDateSelectedIndex == index
                                  ? Colors.white
                                  : ColorConstants.BLACK),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          listOfDays[
                                  startDate.add(Duration(days: index)).weekday -
                                      1]
                              .toString()
                              .substring(0, 3),
                          style: TextStyle(
                              fontSize: 16,
                              color: currentDateSelectedIndex == index
                                  ? Colors.white
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ))),
      ],
    );
  }
}
