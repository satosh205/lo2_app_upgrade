import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/pages/user_profile_page/singularis_profile_edit.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  bool editModeEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: ColorConstants.WHITE,
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      ColorConstants.GRADIENT_ORANGE,
                      ColorConstants.GRADIENT_RED
                    ]),
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      padding: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: ColorConstants.WHITE,
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Color(0xfffc7804),
                              ColorConstants.GRADIENT_RED
                            ]),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: ColorConstants.WHITE,
                                  )),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    editModeEnabled = !editModeEnabled;
                                  });
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(editModeEnabled
                                        ? 'assets/images/check.svg'
                                        : 'assets/images/edit.svg'),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      editModeEnabled
                                          ? 'Save'
                                          : 'Edit Portfolio',
                                      style: Styles.regular(
                                          size: 12,
                                          color: ColorConstants.WHITE),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Stack(
                                    children: [
                                      ClipOval(
                                        child: Image.network(
                                          'https://cdn.pixabay.com/photo/2020/05/09/13/29/photographer-5149664_1280.jpg',
                                          filterQuality: FilterQuality.low,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Positioned(
                                        left: 40,
                                        top: 40,
                                        child: InkWell(
                                          onTap: () {
                                            // showBottomSheet(context);
                                            /*Navigator.push(
                                context,
                                NextPageRoute(ChangeImage()));*/
                                          },
                                          child: Container(
                                            height: 30.0,
                                            width: 30.0,
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                  width: 0,
                                                  color: Colors.transparent),
                                              color: Color(0xfffc7804),
                                            ),
                                            child: SvgPicture.asset(
                                                'assets/images/profile_play.svg'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Prince Vishwakarma',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: Styles.bold(
                                                size: 18,
                                                color: ColorConstants.WHITE)),
                                        Text('Flutter Developer',
                                            style: Styles.regular(
                                                size: 12,
                                                color: ColorConstants.WHITE)),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                'assets/images/person_location.svg'),
                                            Text(' New Delhi, India',
                                                style: Styles.regular(
                                                    size: 12,
                                                    color:
                                                        ColorConstants.WHITE))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  editModeEnabled
                                      ? SizedBox(
                                          width: 18,
                                          child: Transform.scale(
                                              scale: 1.4,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditProfilePage()));
                                                },
                                                child: SvgPicture.asset(
                                                    'assets/images/edit.svg'),
                                              )))
                                      : SizedBox(width: 18),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    if (editModeEnabled)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('About'),
                            Spacer(),
                            Transform.scale(
                                scale: 1.4,
                                child: SvgPicture.asset(
                                  'assets/images/edit.svg',
                                  color: ColorConstants.BLACK,
                                )),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Egestas lectus duis Lorem ipsum dolor sit amet, consectetur adipiscing elit. Egestas lectus duis',
                        style:
                            Styles.regular(size: 12, color: Color(0xff5A5F73)),
                      ),
                    ),
                    if (editModeEnabled)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('Contact and social'),
                            Spacer(),
                            Transform.scale(
                                scale: 1.4,
                                child: SvgPicture.asset(
                                  'assets/images/edit.svg',
                                  color: ColorConstants.BLACK,
                                )),
                          ],
                        ),
                      ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SvgPicture.asset('assets/images/call.svg'),
                            SizedBox(width: 1),
                            SvgPicture.asset('assets/images/email.svg'),
                            VerticalDivider(
                              color: Color(0xffECECEC),
                              width: 10,
                              thickness: 2,
                              indent: 10,
                              endIndent: 10,
                            ),
                            SvgPicture.asset('assets/images/linkedin.svg'),
                            SvgPicture.asset('assets/images/behance.svg'),
                            SvgPicture.asset('assets/images/insta.svg'),
                            SvgPicture.asset('assets/images/dribble.svg'),
                            SvgPicture.asset('assets/images/pintrest.svg'),
                            SvgPicture.asset('assets/images/vertical_menu.svg'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                    left: 25,
                    right: 25,
                    top: 170,
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                          color: ColorConstants.WHITE,
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xff898989).withOpacity(0.1),
                                offset: Offset(0, 4.0),
                                blurRadius: 11)
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Rank',
                                  style: Styles.regular(size: 12),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                        height: 30,
                                        child: SvgPicture.asset(
                                            'assets/images/leaderboard.svg')),
                                    SizedBox(width: 4),
                                    ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: <Color>[
                                              Color(0xfffc7804),
                                              ColorConstants.GRADIENT_RED
                                            ]).createShader(bounds);
                                      },
                                      child: Text(
                                        '52',
                                        style: Styles.bold(size: 24),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  'out of 500 Students',
                                  style: Styles.regular(
                                      size: 10, color: Color(0xff5A5F73)),
                                )
                              ],
                            ),
                            SizedBox(width: 20),
                            VerticalDivider(
                              color: Color(0xffECECEC),
                              width: 10,
                              thickness: 2,
                              indent: 10,
                              endIndent: 10,
                            ),
                            SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Points',
                                  style: Styles.regular(size: 12),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                        height: 30,
                                        child: SvgPicture.asset(
                                            'assets/images/coin.svg')),
                                    ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: <Color>[
                                              Color(0xfffc7804),
                                              ColorConstants.GRADIENT_RED
                                            ]).createShader(bounds);
                                      },
                                      child: Text(
                                        '120',
                                        style: Styles.bold(size: 24),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  'gained from 5 activities',
                                  style: Styles.regular(
                                      size: 10, color: Color(0xff5A5F73)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
            Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.94,
                  child: Divider()),
            ),
            if (editModeEnabled)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Resume'),
                    Spacer(),
                    Transform.scale(
                        scale: 1.4,
                        child: SvgPicture.asset(
                          'assets/images/edit.svg',
                          color: ColorConstants.BLACK,
                        )),
                  ],
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/resume.svg'),
                SizedBox(width: 6),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color(0xfffc7804),
                          ColorConstants.GRADIENT_RED
                        ]).createShader(bounds);
                  },
                  child: Text(
                    'View Resume',
                    style: Styles.bold(size: 14),
                  ),
                )
              ],
            ),
            dividerLine(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Skills Level & Badges',
                        style: Styles.semibold(size: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded)
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        skillProgess("3D Animation", 1, 20),
                        skillProgess("3D Animation", 2, 30),
                        skillProgess("3D Animation", 3, 80),
                        skillProgess("3D Animation", 4, 90),
                      ],
                    ),
                  ),
                  dividerLine(),
                  Row(
                    children: [
                      Text(
                        'Portfolio',
                        style: Styles.semibold(size: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                      itemCount: 3,
                      

scrollDirection: Axis.horizontal,itemBuilder: (context, int)=> Container(
  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                                'https://picsum.photos/seed/picsum/300/300',
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.height * 0.3,
                                fit: BoxFit.fill),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Title of the project',
                            style: Styles.bold(),
                          ),
                          Text('for Company Name',
                              style: Styles.semibold(
                                  size: 12, color: Color(0xff929BA3))),
                        ],
                      ),
                    )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dividerLine() {
    return const Divider(
      thickness: 8,
      color: Color(0xffF2F2F2),
    );
  }

  Widget skillProgess(String title, int rating, double percent) {
    String? position;
    String? image = 'assets/images/';
    switch (rating) {
      case 5:
        position = 'LEADER';
        image += 'leader.svg';
        break;

      case 4:
        position = 'EXPERT';
        image += 'expert.svg';
        break;

      case 3:
        position = 'MASTER';
        image += 'master.svg';
        break;

      case 2:
        position = 'Learner';
        image += 'learner.svg';
        break;

      case 1:
        position = 'NOVICE';
        image += 'novice.svg';
        break;
    }
    return Column(
      children: [
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Color(0xfffc7804), ColorConstants.GRADIENT_RED])
                .createShader(bounds);
          },
          child: Text(
            title,
            style: Styles.bold(size: 12),
          ),
        ),
        Transform.scale(
          scale: 0.75,
          child: CircularPercentIndicator(
            radius: 50.0,
            circularStrokeCap: CircularStrokeCap.round,
            lineWidth: 5.0,
            percent: percent / 100,
            center: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Color(0xff000000).withOpacity(0.25),
                      blurRadius: 4.36274)
                ],
                color: ColorConstants.WHITE,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 2),
                  SvgPicture.asset(
                    image,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            Color(0xfffc7804),
                            ColorConstants.GRADIENT_RED
                          ]).createShader(bounds);
                    },
                    child: Text(
                      '$position',
                      style: Styles.bold(size: 9.19),
                    ),
                  ),
                  Stack(
                    children: [
                      Transform.translate(
                        offset: Offset(-1, 9),
                        child: SvgPicture.asset(
                          'assets/images/half_circle.svg',
                          width: 78,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 60,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  Opacity(
                                    opacity: i < rating ? 1 : 0.5,
                                    child: SvgPicture.asset(
                                      'assets/images/star_portfolio_unselected.svg',
                                      width: 10,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            backgroundColor: Color(0xffEFEFEF),
            linearGradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: <Color>[Color(0xfffc7804), ColorConstants.GRADIENT_RED]),
          ),
        ),
      ],
    );
  }
}
