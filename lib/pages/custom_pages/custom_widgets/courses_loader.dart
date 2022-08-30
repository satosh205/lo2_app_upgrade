import 'package:flutter/material.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:shimmer/shimmer.dart';

class CoursesLoader extends StatelessWidget {
  CoursesLoader({this.expanded = true});
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return expanded
        ? Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  height: 67,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Shimmer.fromColors(
                    baseColor: ColorConstants.GREY_4,
                    highlightColor: ColorConstants.GREY_4,
                    enabled: true,
                    child: ListView.separated(
                      separatorBuilder: (ctx, index) {
                        return Divider(
                          thickness: 1,
                          color: Color.fromRGBO(127, 137, 197, 0.16),
                          height: 1,
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, __) => Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        margin: EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        width: 172,
                      ),
                      itemCount: 6,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[200],
                  ),
                )
              ],
            ),
          )
        : Container(
            height: 67,
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Shimmer.fromColors(
              baseColor: ColorConstants.GREY_4,
                    highlightColor: ColorConstants.GREY_4,
              enabled: true,
              child: ListView.separated(
                separatorBuilder: (ctx, index) {
                  return Divider(
                    thickness: 1,
                    color: Color.fromRGBO(127, 137, 197, 0.16),
                    height: 1,
                  );
                },
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, __) => Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  margin: EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  width: 172,
                ),
                itemCount: 6,
              ),
            ),
          );
  }
}
