import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardLoader extends StatelessWidget {
  CardLoader({this.direction = Axis.vertical});
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: direction == Axis.vertical
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.width / 1.68,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
              child: ListView.builder(
                scrollDirection: direction,
                itemBuilder: (_, __) => Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        width: double.infinity,
                        height: 150,
                      ),
                      Padding(padding: EdgeInsets.all(4)),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                  )),
                              width: double.infinity,
                              height: 40,
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 5)),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12))),
                              width: double.infinity,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                itemCount: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
