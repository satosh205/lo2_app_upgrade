import 'package:flutter/material.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

class ChooseOptionDeletion extends StatefulWidget {
  const ChooseOptionDeletion({super.key});

  @override
  State<ChooseOptionDeletion> createState() => _ChooseOptionDeletionState();
}

class _ChooseOptionDeletionState extends State<ChooseOptionDeletion> {

   List<String> options = [
    "Effective Coverage",
    "Productive sales calls",
    "Throughput",
    "Must Sell SKUs",
  ];
  int selectedIndex= 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorConstants.WHITE,
        title: Text('')),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text('Temporarily Deactivate Your Account', style: Styles.bold(size: 16)),
            SizedBox(height: 10),
            Text('Hi s_singh205,'),
            SizedBox(height: 10),

            Text('You can deactivate your account instead of deleting it. This means that your account will be hidden until you reactivate it by logging back in.'),
            SizedBox(height: 10),

            Text('You can only deactivate your account once a week.'),
            SizedBox(height: 10),
Divider(),
 Text('Why are you deactivating your account?', style: Styles.bold(size: 16)),

 DropdownButton<String>(
                            underline: Center(),
                            isExpanded: true,
                            value: options[selectedIndex],
                            items: options.map((value) {
                              return new DropdownMenuItem<String>(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = options.indexOf(value);
                                  });
                                },
                                value: value,
                                child: new Text(
                                  value,
                                  style: Styles.textExtraBold(
                                    size: 16,
                                    color: Color.fromRGBO(28, 37, 85, 1),
                                  ),
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                            onChanged: (_) {},
                          ),

          ],),
        ),
        );
  }
}