import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

class Competetion extends StatefulWidget {
  const Competetion({Key? key}) : super(key: key);

  @override
  _CompetetionState createState() => _CompetetionState();
}

class _CompetetionState extends State<Competetion> {
  @override
  Widget build(BuildContext context) {
    int percent = 30;
    double barThickness = MediaQuery.of(context).size.height * 0.02;

    return Container(
      child: Column(children: [
        Container(
          width: double.infinity,
          height: 200,
          padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Color(0xfffc7804), Color(0xffff2252)]),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                  left: 33,
                  top: 4.5,
                  child: renderProgressBar(percent, barThickness)),
              Positioned(left: 2, top: 30, child: Text('50 Points')),

              Positioned(
                left: 10,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: ColorConstants.WHITE, width: 2.5)),
                  child: Image.asset('assets/images/check.png'),
                ),
              ),
              Positioned(
                  left: 160 + MediaQuery.of(context).size.width * 0.1,
                  top: 4.5,
                  child: renderBar(barThickness)),
              Positioned(
                  left: 215 + MediaQuery.of(context).size.width * 0.1,
                  top: 4.5,
                  child: renderBar(barThickness)),
              Positioned(left: 175, top: 4, child: renderEllipse('100')),
              Positioned(left: 230, top: 3.8, child: renderEllipse('100')),

              // renderEllipse('12'),
              // renderBar(),
              // renderEllipse('12'),
              // renderBar(),
              // renderEllipse('12'),
              // Expanded(
              //   child: renderBar(),
              // ),
            ],
          ),
        )
      ]),
    );
  }

  renderBar(barThickness) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.1,
        height: barThickness,
        color: ColorConstants.WHITE.withOpacity(0.3));
  }

  renderEllipse(String text) {
    return Column(
      children: [
        Transform.scale(
          scale: 1.6,
          child: SvgPicture.asset('assets/images/ellipse.svg'),
        ),
        SizedBox(
          height: 10,
        ),
        Text('$text',
            style: Styles.regular(color: ColorConstants.WHITE, size: 12.5))
      ],
    );
  }

  renderProgressBar(percent, barThickness) {
    return Container(
      height: barThickness,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        color: ColorConstants.WHITE.withOpacity(0.3),
      ),
      child: Stack(
        children: [
          Container(
            height: barThickness,
            width: MediaQuery.of(context).size.width * 0.4 * (percent / 100),
            decoration: BoxDecoration(
              color: ColorConstants.YELLOW.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
            child: Opacity(
              opacity: 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                child: SvgPicture.asset(
                  'assets/images/whiteStripe.svg',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
