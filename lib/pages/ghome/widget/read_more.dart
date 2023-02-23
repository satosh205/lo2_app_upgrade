import 'package:flutter/material.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/resource/colors.dart';

import '../../../utils/Styles.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final Color? color;
  final String? viewMore;

  ReadMoreText({Key? key, required this.text, this.color, this.viewMore}) : super(key: key);

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool isExpanded = false;


  @override
  Widget build(BuildContext context) {
    final span = TextSpan(text: widget.text);
    final tp =
        TextPainter(text: span, maxLines: 2, textDirection: TextDirection.ltr);
    tp.layout(
        maxWidth: MediaQuery.of(context)
            .size
            .width); // equals the parent screen width
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: Styles.regular(size: 14, color:widget.color??  ColorConstants.BLACK),
          maxLines: isExpanded != true ? 2 : null,
          // overflow: isExpanded,
          // overflow: isExpanded != true ? TextOverflow.fade : null,
        ),
        if (widget.text.length != 0 && tp.didExceedMaxLines)
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? '${Strings.of(context)?.seeLess}' : '... ${widget.viewMore ?? Strings.of(context)?.seeMore}',
              style: Styles.regular(size: 14, color: ColorConstants.GREY_3),
            ),
          ),
      ],
    );
  }
}
