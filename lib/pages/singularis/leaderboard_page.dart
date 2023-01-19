import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:masterg/utils/constant.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd4d4d4),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromARGB(255, 210, 164, 132),
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        title: const Text(
          "Leaderboard",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Color.fromARGB(255, 210, 164, 132),
              ),
              height: height(context) * 0.3,
              width: width(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  leadercard(),
                  leadercard(),
                  leadercard(),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Text(
                    "Your Position",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xffFF2252)),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    leading: SizedBox(
                      width: width(context) * 0.2,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("13."),
                          ),
                          CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSa69_HGc_i3MXKCPZzCfAjBZC4bXJsn0rS0Ufe6H-ctZz5FbIVaPkd1jCPTpKwPruIT3Q&usqp=CAU")),
                        ],
                      ),
                    ),
                    title: Text("Shresth Bhadani"),
                    subtitle: Text("22 Activities"),
                    trailing: Text("800"),
                  ),
                )),
            Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                  itemCount: 7,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) =>
                      userCard(index + 1)),
            )
          ],
        ),
      ),
    );
  }

  Widget userCard(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: SizedBox(
          width: width(context) * 0.2,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("$index."),
              ),
              CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSa69_HGc_i3MXKCPZzCfAjBZC4bXJsn0rS0Ufe6H-ctZz5FbIVaPkd1jCPTpKwPruIT3Q&usqp=CAU")),
            ],
          ),
        ),
        title: Text("Shresth Bhadani"),
        subtitle: Text("22 Activities"),
        trailing: Text("800"),
      ),
    );
  }

  Widget leadercard() {
    return Column(
      children: [
        const Icon(Icons.headphones),
        const SizedBox(
          height: 10,
        ),
        ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSa69_HGc_i3MXKCPZzCfAjBZC4bXJsn0rS0Ufe6H-ctZz5FbIVaPkd1jCPTpKwPruIT3Q&usqp=CAU"),
            )),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Loream',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Rank 2",
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.red, fontSize: 20),
        ),
        const Text("125 Activities"),
        const Text("1300"),
      ],
    );
  }
}
