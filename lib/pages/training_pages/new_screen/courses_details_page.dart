import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/home_bloc.dart';
import '../../../data/models/request/home_request/user_program_subscribe.dart';
import '../../../utils/Styles.dart';
import '../../../utils/resource/colors.dart';
import '../../custom_pages/TapWidget.dart';
import '../../custom_pages/alert_widgets/alerts_widget.dart';

class CoursesDetailsPage extends StatefulWidget {
  final String? imgUrl;
  final String? tagName;
  final int? indexc;
  final String? name;
  final String? description;
  final int? regularPrice;
  final int? salePrice;
  final String? trainer;
  final int? enrolmentCount;
  final int? id;
  final String? type;

  const CoursesDetailsPage(
      {Key? key,
      required this.imgUrl,
      required this.indexc,
      this.tagName,
      this.name,
      this.description,
      this.regularPrice,
      this.salePrice,
      this.trainer,
      this.enrolmentCount,
      this.id,
      this.type})
      : super(key: key);

  @override
  State<CoursesDetailsPage> createState() => _CoursesDetailsPageState();
}

class _CoursesDetailsPageState extends State<CoursesDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.white,
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: ColorConstants.WHITE,

          //top shadow
          boxShadow: [
            BoxShadow(
              color: ColorConstants.BLACK.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 20,
              offset: Offset(0, -2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Text('${widget.enrolmentCount} Students already Enrolled',
                style: Styles.regular(size: 12)),
            SizedBox(
              height: 10,
            ),
            TapWidget(
              onTap: () {
                print('object');
                _subscribeRequest(widget.type, widget.id);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: ColorConstants().primaryColor(),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 4, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Request',
                        style: Styles.textExtraBold(
                            size: 14, color: ColorConstants.WHITE),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('', textScaleFactor: 1),
              background: Hero(
                tag: widget.tagName! + widget.indexc.toString(),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  child: Image.network(
                    widget.imgUrl!,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name.toString(),
                    style: Styles.bold(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(widget.description.toString()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Trainer Name: ',
                        style: Styles.regular(size: 12)),
                    TextSpan(
                        text: '${widget.trainer.toString()}',
                        style: Styles.bold(size: 12)),
                  ])),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (widget.regularPrice != widget.salePrice)
                        Text('₹${widget.regularPrice}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 15,
                              decoration: TextDecoration.lineThrough,
                            )),
                      SizedBox(
                        width: 10,
                      ),
                      if (widget.salePrice != null)
                        Text('₹${widget.salePrice}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: Styles.bold(
                                size: 23, color: ColorConstants.GREEN)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _subscribeRequest(type, id) {
    print(type);
    print(id);
    if (type == "paid") {
      AlertsWidget.showCustomDialog(
          context: context,
          title: "Contact Administrator to get access to this program!!",
          text: "",
          icon: 'assets/images/circle_alert_fill.svg',
          showCancel: false,
          // okText:
          oKText: "Ok",
          onOkClick: () async {
            // Navigator.pop(context);
          });
    }

    if (type == "approve") {
      BlocProvider.of<HomeBloc>(context).add(UserProgramSubscribeEvent(
          subrReq: UserProgramSubscribeReq(programId: id)));

      AlertsWidget.showCustomDialog(
          context: context,
          title: "Approval Request has been sent,",
          text: "You will be assigned to this course soon!!",
          icon: 'assets/images/circle_alert_fill.svg',
          showCancel: false,
          oKText: 'Ok',
          onOkClick: () async {
            // Navigator.pop(context);
          });
    }

    if (type == "open") {
      BlocProvider.of<HomeBloc>(context).add(UserProgramSubscribeEvent(
          subrReq: UserProgramSubscribeReq(programId: id)));

      AlertsWidget.showCustomDialog(
          context: context,
          title: "Subscribed Sucessfully!!",
          text: "",
          icon: 'assets/images/circle_alert_fill.svg',
          showCancel: false,
          onOkClick: () async {
            // Navigator.pop(context);
          });
    }
  }
}
