import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../utils/resource/colors.dart';

class CompetitionFilterSearchResultPage extends StatefulWidget {

  final String? appBarTitle;
  final bool? isSearchMode;
  final String? jobRolesId;

  const CompetitionFilterSearchResultPage(
      {Key? key, this.appBarTitle, this.isSearchMode = true, this.jobRolesId})
      : super(key: key);

  @override
  State<CompetitionFilterSearchResultPage> createState() => _CompetitionFilterSearchResultPageState();
}

class _CompetitionFilterSearchResultPageState extends State<CompetitionFilterSearchResultPage> {
  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {

        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            elevation: 0.0,
            backgroundColor: ColorConstants.WHITE,
            title: Text('Search Result', style: TextStyle(color: Colors.black),),
          ),
          backgroundColor: ColorConstants.JOB_BG_COLOR,
          body: _comResultCard(),
        ),
      ),
    );
  }


  Widget _comResultCard() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Text('Application'),
              );
            },
          )),
    );
  }

}
