import 'package:cached_network_image/cached_network_image.dart';
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
    double barThickness = MediaQuery.of(context).size.height * 0.012;
    double mobileWidth = MediaQuery.of(context).size.width - 50;
    double mobileHeight = MediaQuery.of(context).size.height;

    return Container(
      color: ColorConstants.WHITE,
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity,
            height: mobileHeight * 0.25,
            padding: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: ColorConstants.WHITE,
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xfffc7804), Color(0xffff2252)]),
            ),
            child: Stack(
              children: [
                Positioned(
                    left: mobileWidth * 0.08,
                    top: 8,
                    child:
                        renderProgressBar(percent, barThickness, mobileWidth)),
                Positioned(
                    left: mobileWidth * 0.01,
                    top: 30,
                    child: Text(
                      '50 Points',
                      style: Styles.regular(
                          color: ColorConstants.WHITE, size: 12.5),
                    )),
                Positioned(
                  left: mobileWidth * 0.02,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: ColorConstants.WHITE, width: 2.5)),
                    child: Image.asset('assets/images/check.png'),
                  ),
                ),
                Positioned(
                    left: mobileWidth * 0.59,
                    top: 8,
                    child: renderBar(barThickness, mobileWidth)),
                Positioned(
                    left: mobileWidth * 0.72,
                    top: 8,
                    child: renderBar(barThickness, mobileWidth)),
                Positioned(
                    left: mobileWidth * 0.85,
                    top: 8,
                    child: renderBar(barThickness, mobileWidth)),
                Positioned(
                    left: mobileWidth * 0.97,
                    top: 8,
                    child:
                        renderBar(barThickness, mobileWidth, fullWidth: true)),
                Positioned(
                    left: mobileWidth * 0.53,
                    top: 4,
                    child: renderEllipse('100')),
                Positioned(
                    left: mobileWidth * 0.66,
                    top: 3.8,
                    child: renderEllipse('150')),
                Positioned(
                    left: mobileWidth * 0.79,
                    top: 4,
                    child: renderEllipse('200')),
                Positioned(
                    left: mobileWidth * 0.92,
                    top: 4,
                    child: renderEllipse('250')),
                Positioned(
                    left: 10,
                    bottom: 40,
                    child: renderTopButton(
                        'assets/images/leaderboard.png', 'Your rank: ', '120')),
                Positioned(
                    right: 10,
                    bottom: 40,
                    child: renderTopButton(
                        'assets/images/coin.png', 'Points: ', '50')),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 30,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: ColorConstants.WHITE,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                  ),
                )
              ],
            ),
          ),

          //show other content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Participate & Add to Your Portfolio',
                          style: Styles.regular(
                            color: ColorConstants.GREY_6,
                          )),
                      InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.49,
                                    child: renderFilter(),
                                  );
                                });
                          },
                          child: Icon(Icons.filter_list))
                    ]),
                renderCompetitionCard(),
                renderCompetitionCard(),
                renderCompetitionCard(),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Most popular activities',
                        style: Styles.regular(
                          color: ColorConstants.GREY_6,
                        ))
                  ],
                ),

                //
                Container(
                  height: 250,
                  // color: Colors.green,
                  // padding: EdgeInsets.symmetric(vertical: 20),
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return renderActivityCard();
                      }),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  renderActivityCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: ColorConstants.WHITE,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://s3-ap-south-1.amazonaws.com/blogmindler/bloglive/wp-content/uploads/2022/04/06192628/10-Unusual-Courses-that-You-have-Never-Heard-Before_blog.png',
                  width: 100,
                  height: 120,
                  errorWidget: (context, url, error) => SvgPicture.asset(
                    'assets/images/gscore_postnow_bg.svg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                'Ui Design Test Series',
                style: Styles.bold(),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text('Easy',
                      style: Styles.regular(
                          color: ColorConstants.GREEN_1, size: 12)),
                  SizedBox(
                    width: 4,
                  ),
                  Text('•',
                      style: Styles.regular(
                          color: ColorConstants.GREY_2, size: 12)),
                  SizedBox(
                    width: 4,
                  ),
                  SizedBox(
                      height: 15, child: Image.asset('assets/images/coin.png')),
                  SizedBox(
                    width: 4,
                  ),
                  Text('30 Points',
                      style: Styles.regular(
                          color: ColorConstants.ORANGE_4, size: 12)),
                ],
              ),
            ),
          ]),
    );
  }

  renderCompetitionCard() {
    return Container(
      height: 90,
      width: double.infinity,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: ColorConstants.WHITE,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Row(children: [
        SizedBox(
          width: 70,
          height: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl:
                  'https://s3-ap-south-1.amazonaws.com/blogmindler/bloglive/wp-content/uploads/2022/04/06192628/10-Unusual-Courses-that-You-have-Never-Heard-Before_blog.png',
              width: 100,
              height: 120,
              errorWidget: (context, url, error) => SvgPicture.asset(
                'assets/images/gscore_postnow_bg.svg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coding Competition',
              style: Styles.bold(size: 14),
            ),
            SizedBox(
              height: 2,
            ),
            Row(
              children: [
                Text('Google'),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.48,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xff0E1638),
                )
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text('Easy',
                    style: Styles.regular(
                        color: ColorConstants.GREEN_1, size: 12)),
                SizedBox(
                  width: 4,
                ),
                Text('•',
                    style:
                        Styles.regular(color: ColorConstants.GREY_2, size: 12)),
                SizedBox(
                  width: 4,
                ),
                SizedBox(
                    height: 15, child: Image.asset('assets/images/coin.png')),
                SizedBox(
                  width: 4,
                ),
                Text('30 Points',
                    style: Styles.regular(
                        color: ColorConstants.ORANGE_4, size: 12)),
                SizedBox(
                  width: 4,
                ),
                Text('•',
                    style:
                        Styles.regular(color: ColorConstants.GREY_2, size: 12)),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.calendar_month,
                  size: 20,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '31st December',
                  style: Styles.regular(size: 12, color: Color(0xff5A5F73)),
                )
              ],
            )
          ],
        ),
      ]),
    );
  }

  renderTopButton(String img, String title, String value) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.45,
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
          color: ColorConstants.WHITE.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Container(
          width: 30,
          height: 30,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: ColorConstants.WHITE),
          child: Image.asset(img),
        ),
        SizedBox(
          width: 10,
        ),
        Text(title, style: Styles.semibold(size: 14)),
        Text(value, style: Styles.semibold(size: 16)),
      ]),
    );
  }

  renderBar(barThickness, mobileWidth, {fullWidth = false}) {
    return Container(
        width: fullWidth ? mobileWidth : mobileWidth * 0.07,
        height: barThickness,
        color: ColorConstants.WHITE.withOpacity(0.3));
  }

  renderEllipse(String text) {
    return Column(
      children: [
        Transform.scale(
          scale: 1.35,
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

  renderProgressBar(percent, barThickness, mobileWidth) {
    return Container(
      height: barThickness,
      width: mobileWidth * 0.46,
      decoration: BoxDecoration(
        color: ColorConstants.WHITE.withOpacity(0.3),
      ),
      child: Stack(
        children: [
          Container(
            height: barThickness,
            width: mobileWidth * 0.46 * (percent / 100),
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

  renderFilter() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorConstants.WHITE,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: ColorConstants.GREY_4,
                  borderRadius: BorderRadius.circular(8)),
              width: 48,
              height: 5,
              margin: EdgeInsets.only(top: 8),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'Filter by',
              style: Styles.semibold(size: 16),
            ),
          ),
          Divider(
            color: ColorConstants.GREY_4,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [],
            ),
          )
        ],
      ),
    );
  }
}
