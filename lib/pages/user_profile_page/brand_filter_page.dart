
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:masterg/utils/resource/colors.dart';

import '../../data/api/api_constants.dart';
import '../../data/models/response/auth_response/user_session.dart';
import '../../utils/utility.dart';
import 'model/BrandModel.dart';

class BrandFilterPage extends StatefulWidget {

  //List<AddressModel> usersFromServer;
  Function onCalledBack;
  String titleName = '';
  String city = '';
  String state = '';
  String zipCode = '';
  String actionType = '';

  BrandFilterPage(this.onCalledBack, this.titleName, this.city, this.state, this.zipCode, this.actionType, {Key? key}): super(key: key);


  @override
  _BrandFilterPageState createState() => _BrandFilterPageState();
}

class Debouncer {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}

class _BrandFilterPageState extends State<BrandFilterPage> {
  // https://jsonplaceholder.typicode.com/users

  final titleController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  List<BrandModel> filteredUsers = [];
  List<BrandModel> addressListData = <BrandModel>[];

  bool flagIndicator = false;
  String strCity = '', strState = '', strZipCode = '';


  @override
  void initState() {
    super.initState();
    /*Services.getUsers().then((usersFromServer) {
      setState(() {
        users = usersFromServer;
        filteredUsers = users;
      });
    });*/

    //fetchProducts('');

    /*setState(() {
      users = widget.usersFromServer;
      filteredUsers = users;
    });*/

    strCity = widget.city;
    strState = widget.state;
    strZipCode = widget.zipCode;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(widget.titleName),
        title: Text('Brand Name'),
        backgroundColor: ColorConstants().primaryColor(),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: titleController,
            autofocus: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              suffixIcon: flagIndicator == true ? IconButton(
                onPressed: (){
                  print('suffixIcon');
                  if(titleController.text.isNotEmpty){
                    Navigator.of(context).pop();
                    widget.onCalledBack(titleController.text.toString(), '', 0);
                  }else{
                    Utility.showSnackBar(
                        scaffoldContext: context, message: 'Please enter brand name.');
                  }
                },
                icon: Icon(Icons.add),
              ):null,
              contentPadding: EdgeInsets.all(15.0),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintText: 'Enter Brand Name',
            ),
            onChanged: (string) {
              _debouncer.run(() {
                setState(() {
                  flagIndicator = true;
                  /*filteredUsers = addressListData
                      .where((u) => (u.addressLine1
                      .toLowerCase()
                      .contains(string.toLowerCase())))
                      .toList();*/
                  fetchProducts(string.toString().trim());
                });
              });
            },
          ),

          flagIndicator == true ? Container(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(),
          ):SizedBox(),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: filteredUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      child: InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              filteredUsers[index].title.toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),

                        //filteredUsers[index].data![index].title.toString(),
                        onTap: (){
                          Navigator.of(context).pop();
                          widget.onCalledBack(filteredUsers[index].title.toString(), filteredUsers[index].image,
                              filteredUsers[index].id);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Future<List<BrandModel>> fetchProducts(String strBrandName) async {
    //List<AddressModel> addressListData = new List<AddressModel>();
    addressListData.clear();
    String url = 'https://qa.learningoxygen.com/api/master-brand-search?key=$strBrandName';
    //final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
    final response = await http.post(Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${UserSession.userToken}",
        ApiConstants.API_KEY: ApiConstants.API_KEY_VALUE
      },);
    Map parsedJson = json.decode(response.body);
    if (response.statusCode == 200) {
      flagIndicator = false;

      print(parsedJson);
      var resultsData = parsedJson['data'] as List;


      print('object===========');
      print(resultsData.length);
      for(int i = 0; i <resultsData.length; i++){
        setState(() {

          print(resultsData[i]['title']);
          //addressListData.add(new BrandModel.fromJson(resultsData[i]['title']));
          addressListData.add(new BrandModel.fromJson(resultsData[i]));

          print(addressListData);

          filteredUsers = addressListData;
        });

        print(resultsData[i]['title']);
      }

      print(resultsData);

    } else {
      throw Exception('Unable to fetch products from the REST API');
    }

    return addressListData;
  }


}