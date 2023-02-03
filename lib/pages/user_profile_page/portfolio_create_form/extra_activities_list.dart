import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_extra_act.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class ExtraActivitiesList extends StatefulWidget {
  const ExtraActivitiesList({Key? key}) : super(key: key);

  @override
  State<ExtraActivitiesList> createState() => _ExtraActivitiesListState();
}

class _ExtraActivitiesListState extends State<ExtraActivitiesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Extra currricular Activities",style: Styles.bold()),
                  elevation: 0,
                  backgroundColor: ColorConstants.WHITE,
                  leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: ColorConstants.BLACK,
                      )),
                      actions: [
                         IconButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              context: context,
                              enableDrag: true,
                              isScrollControlled: true,
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.7,
                                  child: Container(
                                      height: height(context),
                                      padding: const EdgeInsets.all(8.0),
                                      margin: const EdgeInsets.only(top: 10),
                                      child: AddActivities()),
                                );
                              });
                        },
                        icon: Icon(
                          Icons.add,
                          color: ColorConstants.BLACK,
                        )),
                  ],
                      
    ),
    body: Container(
      height: height(context)*0.9,
      width: width(context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) { 
           return Container(
                    margin: EdgeInsets.only(right: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: width(context) * 0.2,
                                height: width(context) * 0.2,
                                // child: CachedNetworkImage(
                                //   imageUrl:
                                //       "${portfolioResponse?.data.baseFileUrl}${extraActivities?[index].imageName}",
                                //   progressIndicatorBuilder:
                                //       (context, url, downloadProgress) =>
                                //           CircularProgressIndicator(
                                //               value: downloadProgress.progress),
                                //   errorWidget: (context, url, error) => Container(
                                //       width: width(context) * 0.2,
                                //       height: width(context) * 0.2,
                                //       padding: EdgeInsets.all(8),
                                //       decoration: BoxDecoration(
                                //           color: ColorConstants.DIVIDER,
                                //           borderRadius: BorderRadius.circular(8)),
                                      child: SvgPicture.asset(
                                          'assets/images/extra.svg')),
                                          SizedBox(width: 5,),
                                
                              
                               Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width(context)*0.5,
                                          child: Text(
                                            maxLines:2,
                                            
                                            // '${extraActivities?[index].title}',
                                           'Man of Match in Interstate Cricket  Tournament', style: Styles.bold(size: 14),
                                          ),
                                        ),
                                        SizedBox(width: 30,),
 SvgPicture.asset('assets/images/edit_portfolio.svg'),
                     SizedBox(width: 10,),
                      SvgPicture.asset('assets/images/delete.svg'),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                     
                                     'unocorn pvt',
                                      style: Styles.regular(size: 14),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    // Text('${extraActivities?[index].title}'),
                                    Text("man of the match in cricket turnament")
                                  ],
                                
                              
                            
                          
                        //   SizedBox(
                        //     height: 4,
                        //   ),
                        // //   ReadMoreText(
                        //     viewMore: 'View more',
                        //     // text: '${extraActivities?[index].description}',
                        //     color: Color(0xff929BA3),
                        //   ),
                        //   // if (index != extraActivities?.length) Divider()
                        // ],
                               )])]),
                    )
    );}),
      )));
                
              }
       }