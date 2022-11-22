import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

// ignore: must_be_immutable
class CommentBox extends StatefulWidget {
  Widget? child;
  dynamic formKey;
  dynamic sendButtonMethod;
  dynamic commentController;
  String? userImage;
  String? labelText;
  String? errorText;
  Widget? sendWidget;
  Color? backgroundColor;
  Color? textColor;
  bool withBorder;
  Widget? header;
  FocusNode? focusNode;
  CommentBox(
      {this.child,
      this.header,
      this.sendButtonMethod,
      this.formKey,
      this.commentController,
      this.sendWidget,
      this.userImage,
      this.labelText,
      this.focusNode,
      this.errorText,
      this.withBorder = true,
      this.backgroundColor,
      this.textColor});

  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  String commentText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: widget.child!),
        Divider(
          height: 1,
          color: ColorConstants.GREY_4,
        ),
        widget.header ?? SizedBox.shrink(),

        Container(
          height: 80,
          color: ColorConstants.WHITE,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.75,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                    color: ColorConstants.TEXT_FIELD_BG,
                    borderRadius: BorderRadius.circular(22)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                  child: TextField(
                    style:
                        Styles.regular(size: 14, color: ColorConstants.BLACK),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    controller: widget.commentController,
                    onChanged: (value) {
                      setState(() {
                        commentText = value;
                      });
                    },

                    maxLines: 4,
                    minLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '${Strings.of(context)?.writeYourComment}',
                      hintStyle: Styles.regular(
                          size: 14, color: ColorConstants.GREY_4),
                    ),
                    // controller: fieldText,
                  ),
                )),
            InkWell(
              child: GestureDetector(
                onTap: widget.sendButtonMethod,
                child: SvgPicture.asset(
                  'assets/images/send_icon.svg',
                  color: ColorConstants().primaryColor(),
                  height: 50,
                  width: 50,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ),
          ]),
        )

        // ListTile(
        //   tileColor: widget.backgroundColor,
        //   leading: SizedBox(),
        //   title: Container(
        //       height: 60,
        //       color: Color(0xffbbcecf),
        //       child: Padding(
        //         padding:
        //             const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        //         child: TextField(
        //           inputFormatters: [
        //             LengthLimitingTextInputFormatter(100),
        //           ],
        //           decoration: InputDecoration(
        //             border: InputBorder.none,
        //             hintText: 'Type a message',
        //             suffixIcon: IconButton(
        //               icon: Icon(Icons.send, color: Colors.black),
        //               onPressed: () {
        //                 // //send message
        //                 // sendMessage(fieldText.text);
        //                 // fieldText.clear();
        //               },
        //             ),
        //           ),
        //           // controller: fieldText,
        //         ),
        //       )),
        //   // title: Form(
        //   //   key: widget.formKey,
        //   //   child: TextFormField(
        //   //     maxLines: 4,
        //   //     minLines: 1,
        //   //     focusNode: widget.focusNode,
        //   //     cursorColor: widget.textColor,
        //   //     style: TextStyle(color: widget.textColor),
        //   //     controller: widget.commentController,
        //   //     onChanged: (value) {
        //   //       setState(() {
        //   //         commentText = value;
        //   //       });
        //   //     },
        //   //     decoration: InputDecoration(
        //   //       enabledBorder: !widget.withBorder
        //   //           ? InputBorder.none
        //   //           : UnderlineInputBorder(
        //   //               borderSide: BorderSide(color: widget.textColor),
        //   //             ),
        //   //       focusedBorder: !widget.withBorder
        //   //           ? InputBorder.none
        //   //           : UnderlineInputBorder(
        //   //               borderSide: BorderSide(color: widget.textColor),
        //   //             ),
        //   //       border: !widget.withBorder
        //   //           ? InputBorder.none
        //   //           : UnderlineInputBorder(
        //   //               borderSide: BorderSide(color: widget.textColor),
        //   //             ),
        //   //       labelText: widget.labelText,
        //   //       focusColor: widget.textColor,
        //   //       fillColor: widget.textColor,
        //   //       labelStyle: TextStyle(color: widget.textColor),
        //   //     ),
        //   //     validator: (value) => value.isEmpty ? widget.errorText : null,
        //   //   ),
        //   // ),

        //   trailing: SizedBox(),
        //   // trailing: GestureDetector(
        //   //   onTap: widget.sendButtonMethod,
        //   //   child: SvgPicture.asset(
        //   //     'assets/images/send_icon.svg',
        //   //     height: 75,
        //   //     width: 173,
        //   //     allowDrawingOutsideViewBox: true,
        //   //   ),
        //   // )
        // ),
      ],
    );
  }
}
