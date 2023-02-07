import 'package:flutter/material.dart';

import '../../../utils/Styles.dart';

class RecentActivitiesPage extends StatefulWidget {
  const RecentActivitiesPage({Key? key}) : super(key: key);

  @override
  State<RecentActivitiesPage> createState() => _RecentActivitiesPageState();
}

class _RecentActivitiesPageState extends State<RecentActivitiesPage> {
  @override
  Widget build(BuildContext context) {
    //return Scaffold(
      /*appBar: AppBar(
          backgroundColor: Color(0xffF2F2F2),
          elevation: 0,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xff0E1638),
              )),
          title: Text(
            'Recent Activities',
            style: Styles.semibold(),
          )),*/
      /*body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 200, color: Colors.green,)
            ],
          )),*/

    //);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              title: Center(
                child: PreferredSize(
                    child: ClipPath(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              ' Bike Guru',
                            ),
                          ],
                        ),
                      ),
                    ),
                    preferredSize: Size.fromHeight(kToolbarHeight + 150)),
              ),
              floating: false,
              pinned: false,
            ),
          ];
        },
        body: Center(
          child: Text("Sample Text"), // Actual body content
        ),
      ),
    );

  }
}
