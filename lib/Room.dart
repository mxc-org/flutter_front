import 'package:flutter/material.dart';
import 'package:flutter_front/gameUI.dart';
import 'package:flutter_front/values.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'obj.dart';

class RoomUI extends StatefulWidget {
  const RoomUI({super.key});

  @override
  State<RoomUI> createState() => _RoomUIState();
}

class _RoomUIState extends State<RoomUI> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRoomlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/asdfasdf.jpeg"),
            fit: BoxFit.cover,
            opacity: 0.75,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoomListView(),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
                minimumSize: const MaterialStatePropertyAll(Size(0, 50)),
              ),
              child: const Text(
                "创建房间",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (buildContext) => const GameUI(),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
                minimumSize: const MaterialStatePropertyAll(Size(0, 50)),
              ),
              child: const Text(
                "退出房间",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget RoomListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Values.RoomList.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Container(
            alignment: Alignment.center,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(Values.RoomList[i].userIdCreator.toString()),
              Text("VS"),
              Text(Values.RoomList[i].userIdJoin.toString())
            ]),
          ),
          leading: Container(
            // margin: const EdgeInsets.only(left: 10),
            alignment: Alignment.center,
            width: 50,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(Values.RoomList[i].id.toString() + "号房间"),
          ),
          trailing: Text(Values.RoomList[i].status),
        );
      },
    );
  }

  void getRoomlist() async {
    var response = await http.get(
      Uri.parse("${Values.server}/Room/RoomList"),
    );
    Values.RoomList.clear();
    String str = utf8.decode(response.bodyBytes);
    if (str == "") {
      setState(() {});
      return;
    }
    List<dynamic> ls = json.decode(str);
    for (Map<String, dynamic> mp in ls) {
      Values.RoomList.add(Room.mpToRoom(mp));
    }
    setState(() {});
  }
}
