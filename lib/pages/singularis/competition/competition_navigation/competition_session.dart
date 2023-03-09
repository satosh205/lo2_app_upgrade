import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/competition_content_list_resp.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:url_launcher/url_launcher.dart';

class CompetitionSession extends StatefulWidget {
  final CompetitionContent? data;
  const CompetitionSession({Key? key, this.data}) : super(key: key);

  @override
  State<CompetitionSession> createState() => _CompetitionSessionState();
}

class _CompetitionSessionState extends State<CompetitionSession> {
  bool isLoading = false;
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

    String startDateString = "${widget.data?.startDate}";

    DateTime startDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").parse(startDateString);
    String pmTime = DateFormat('h:mm a').format(startDate);
    DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String formatted = formatter.format(now);
    now = DateFormat("yyyy-MM-dd HH:mm:ss").parse(formatted);

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
        body: ScreenWithLoader(
          isLoading: isLoading,
          body: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is ZoomOpenUrlState) handleOpenUrlState(state);
            },
            child: Container(
                color: ColorConstants.WHITE,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.data?.contentTypeLabel ?? ''}',
                              style: Styles.bold(size: 14),
                            ),
                            Text(
                              '${widget.data?.isJoined ?? ''}',
                              style: Styles.bold(size: 14),
                            ),
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
                                        '${widget.data?.baseFileUrl}${widget.data?.presenterImage}',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${widget.data?.presenter}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                        SizedBox(height: 6),
                                        Text('${widget.data?.title}',
                                            style: Styles.regular(
                                                size: 12,
                                                color: Color(0xff929BA3)))
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
                                      'Start Date: ',
                                      style: Styles.regular(
                                          size: 14, color: Color(0xFF5A5F73)),
                                    ),
                                    Text(
                                      '${Utility.ordinal(startDate.day)} ${listOfMonths[startDate.month - 1]} | $pmTime',

                                      // ${startDate.hour}:${startDate.minute}:${startDate.second}',
                                      style: Styles.regular(
                                          size: 14, color: Color(0xff0E1638)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Duration:',
                                      style: Styles.regular(
                                          size: 14, color: Color(0xFF5A5F73)),
                                    ),
                                    Text(
                                      ' ${widget.data?.duration} mins',
                                      style: Styles.regular(
                                          size: 14, color: Color(0xff0E1638)),
                                    )
                                  ],
                                )
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 12),
                        child: Text(
                          '${widget.data?.description}',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xff5A5F73)),
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
                              BlocProvider.of<HomeBloc>(context)
                                      .add(ZoomOpenUrlEvent(contentId: widget.data?.id));
                              
                              if (now.isAfter(startDate.add(Duration(
                                  minutes: int.parse(
                                      '${widget.data?.duration}'))))) {
                                        return;
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(SnackBar(
                                //   content: Text(
                                //       '${widget.data?.contentTypeLabel} ended'),
                                // ));
                              } else if (now.isAfter(startDate.subtract(Duration(minutes: 15)))) {
                                if ('${widget.data?.zoomUrl}' != '')
                                  launchUrl(
                                      Uri.parse('${widget.data?.zoomUrl}'));
                                else {
                                  //make api call for url
                                      BlocProvider.of<HomeBloc>(context)
                                      .add(ZoomOpenUrlEvent(contentId: widget.data?.id));
                                }
                              } else
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      '${widget.data?.contentTypeLabel} starts in ${startDate.subtract(Duration(minutes: 15)).difference(now).inMinutes} mins'),
                                ));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.all(20.0),
                              decoration:  BoxDecoration(
                                  color:  now.isAfter(startDate.add(Duration(
                                  minutes: int.parse(
                                      '${widget.data?.duration}')))) ?Color(0xff0E1638).withOpacity(0.3):   Color(0xff0E1638),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(21))),
                              child: Center(
                                child: Text(
                            now.isAfter(startDate.add(Duration(
                                  minutes: int.parse(
                                      '${widget.data?.duration}'))))  ? 'Concluded'   :   'Join',
                                  style: Styles.semibold(
                                      size: 14, color: ColorConstants.WHITE),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                      )
                    ])),
          ),
        ));
  }

  void handleOpenUrlState(ZoomOpenUrlState state) {
      switch (state.apiState) {
        case ApiStatus.LOADING:
          Log.v("Zoom Open Url Loading....................");
          isLoading = true;
          setState(() {
            
          });
          break;
        case ApiStatus.SUCCESS:
          Log.v("Zoom Open Url Success....................");
          isLoading = false;
          setState(() {});
          if (state.response?.status == 0) {
              if (widget.data?.openUrl != '')
            launchUrl(Uri.parse('${widget.data?.openUrl}'));
            else  if (widget.data?.zoomUrl != '')
            launchUrl(Uri.parse('${widget.data?.zoomUrl}'));
          
       else      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${state.response?.error?.first}'),
            ));
          } else if (state.response?.data?.list?.joinUrl != '')
            launchUrl(Uri.parse('${state.response?.data?.list?.joinUrl}'));
          else if (widget.data?.openUrl != '')
            launchUrl(Uri.parse('${widget.data?.openUrl}'));
          else
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('${widget.data?.contentTypeLabel} not started yet!'),
            ));
          break;

        case ApiStatus.ERROR:
          isLoading = false;
          setState(() {
            
          });
          Log.v("Zoom open url Error..........................");
          break;
        case ApiStatus.INITIAL:
          break;
      }
   
  }
}
