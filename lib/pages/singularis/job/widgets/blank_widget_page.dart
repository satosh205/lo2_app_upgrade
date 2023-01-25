
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/resource/colors.dart';

class BlankWidgetPage extends StatelessWidget {
  const BlankWidgetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 70.0),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(right: 10.0, ),
                    child: Image.asset('assets/images/blank.png'),
                  ),
                ),

                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0, ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xffe6e4e6),
                          highlightColor: Color(0xffeaf0f3),
                          child: Container(
                              height: 13,
                              margin: EdgeInsets.only(left: 2),
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              )),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Shimmer.fromColors(
                            baseColor: Color(0xffe6e4e6),
                            highlightColor: Color(0xffeaf0f3),
                            child: Container(
                                height: 13,
                                margin: EdgeInsets.only(left: 2),
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                )),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Color(0xffe6e4e6),
                                highlightColor: Color(0xffeaf0f3),
                                child: Container(
                                    height: 13,
                                    margin: EdgeInsets.only(left: 2),
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Shimmer.fromColors(
                                  baseColor: Color(0xffe6e4e6),
                                  highlightColor: Color(0xffeaf0f3),
                                  child: Container(
                                      height: 13,
                                      margin: EdgeInsets.only(left: 2),
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1,color: ColorConstants.GREY_3,),
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(right: 10.0, ),
                    child: Image.asset('assets/images/blank.png'),
                  ),
                ),

                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0, ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xffe6e4e6),
                          highlightColor: Color(0xffeaf0f3),
                          child: Container(
                              height: 13,
                              margin: EdgeInsets.only(left: 2),
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              )),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Shimmer.fromColors(
                            baseColor: Color(0xffe6e4e6),
                            highlightColor: Color(0xffeaf0f3),
                            child: Container(
                                height: 13,
                                margin: EdgeInsets.only(left: 2),
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                )),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Color(0xffe6e4e6),
                                highlightColor: Color(0xffeaf0f3),
                                child: Container(
                                    height: 13,
                                    margin: EdgeInsets.only(left: 2),
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Shimmer.fromColors(
                                  baseColor: Color(0xffe6e4e6),
                                  highlightColor: Color(0xffeaf0f3),
                                  child: Container(
                                      height: 13,
                                      margin: EdgeInsets.only(left: 2),
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1,color: ColorConstants.GREY_3,),
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(right: 10.0, ),
                    child: Image.asset('assets/images/blank.png'),
                  ),
                ),

                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0, ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xffe6e4e6),
                          highlightColor: Color(0xffeaf0f3),
                          child: Container(
                              height: 13,
                              margin: EdgeInsets.only(left: 2),
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              )),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Shimmer.fromColors(
                            baseColor: Color(0xffe6e4e6),
                            highlightColor: Color(0xffeaf0f3),
                            child: Container(
                                height: 13,
                                margin: EdgeInsets.only(left: 2),
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                )),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Color(0xffe6e4e6),
                                highlightColor: Color(0xffeaf0f3),
                                child: Container(
                                    height: 13,
                                    margin: EdgeInsets.only(left: 2),
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Shimmer.fromColors(
                                  baseColor: Color(0xffe6e4e6),
                                  highlightColor: Color(0xffeaf0f3),
                                  child: Container(
                                      height: 13,
                                      margin: EdgeInsets.only(left: 2),
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}