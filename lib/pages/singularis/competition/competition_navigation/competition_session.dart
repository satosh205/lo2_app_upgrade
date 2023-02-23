import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masterg/data/models/response/home_response/competition_content_list_resp.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CompetitionSession extends StatelessWidget {
  final CompetitionContent? data;
  const CompetitionSession({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    String startDateString = "${data?.startDate}";

    DateTime startDate = DateFormat("yyyy-MM-dd").parse(startDateString);
    return Scaffold(
      appBar: AppBar(
          elevation: 0.3,
          backgroundColor: ColorConstants.WHITE,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorConstants.BLACK,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Interview',
            style: Styles.bold(
              color: ColorConstants.BLACK,
            ),
          )),
      body: Container(
          color: ColorConstants.WHITE,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Container(
            //     decoration: const BoxDecoration(
            //         color: Color(0xffBDBDBD),
            //         borderRadius:
            //             BorderRadius.all(Radius.circular(10))),

            //     // color: Color(0xffBDBDBD),
            //     width: 60,
            //     height: 5,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     'Schedule an Interview with',
            //     style: Styles.bold(
            //       size: 14,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${data?.contentTypeLabel}',
                    style: Styles.bold(size: 14),
                  ),
                  Text(
                    '${data?.isJoined}',
                    style: Styles.bold(size: 14),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Color(0xffFFF1F1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              "https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=327&q=80",
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${data?.presenter}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                              Text('${data?.title}',
                                  style: Styles.regular(
                                      size: 12, color: Color(0xff929BA3)))
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Due Date:',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF5A5F73)),
                          ),
                          Text(
                            '${startDate.day} ${listOfMonths[startDate.month - 1]}',
                            style: Styles.regular(size: 14),
                          )
                        ],
                      )
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 12),
              child: Text(
                '${data?.description}',
                style: TextStyle(
                    fontWeight: FontWeight.w400, color: Color(0xff5A5F73)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Spacer(),
            Center(
              child: GestureDetector(
                  onTap: () {
                    //open session
                    print('open session');
                    launchUrl(Uri.parse('${data?.content}'));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                        color: Color(0xff0E1638),
                        borderRadius: BorderRadius.all(Radius.circular(21))),
                    child:  Center(
                      child: Text(
                        'Join',
                        style: Styles.semibold(size: 14, color: ColorConstants.WHITE),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )),
            )
          ])),
    );
  }
}
