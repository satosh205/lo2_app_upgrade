import 'package:flutter/material.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:shimmer/shimmer.dart';

class AnalyticsLoader extends StatelessWidget {
  AnalyticsLoader({this.direction = Axis.vertical});
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Shimmer.fromColors(
        baseColor: ColorConstants.GREY_3,
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
          scrollDirection: direction,
          itemBuilder: (_, __) => Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    height: 25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    height: 25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 25,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          itemCount: 6,
        ),
      ),
    );
  }
}
