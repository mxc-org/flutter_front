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
  List<User> listUser = [];
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
                minimumSize: const MaterialStatePropertyAll(Size(10, 50)),
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
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
                minimumSize: const MaterialStatePropertyAll(Size(10, 50)),
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
              // Text(Values.RoomList[i].userIdCreator.toString()),
              if (listUser.length != 0)
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          Values.avatarUrl + listUser[i * 2].avatarName),
                    ),
                  ),
                ),
              SizedBox(
                width: 15,
              ),
              Container(
                height: 30,
                width: 30,
                child: Image.asset('images/VS.jpeg'),
              ),
              SizedBox(
                width: 15,
              ),
              if (listUser.length % 2 == 0 && listUser.length != 0)
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          Values.avatarUrl + listUser[i * 2 + 1].avatarName),
                    ),
                  ),
                ),
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
            child: Text(
              Values.RoomList[i].id.toString() + "号房间",
              style:
                  TextStyle(fontSize: 12, color: Color.fromARGB(255, 9, 9, 9)),
            ),
          ),
          trailing: Text(Values.RoomList[i].status),
        );
      },
    );
  }

  void getRoomlist() async {
    listUser.clear();
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
    for (int i = 0; i < Values.RoomList.length; i++) {
      getroomuser(Values.RoomList[i].userIdCreator);
      getroomuser(Values.RoomList[i].userIdJoin);
    }
    setState(() {});
  }

  void getroomuser(int id) async {
    var response = await http.get(
      Uri.parse("${Values.server}/User/FindUserById?id=$id"),
    );
    if (response.bodyBytes == null) {
      return null;
    }
    Map<String, dynamic> ls = json.decode(utf8.decode(response.bodyBytes));
    listUser.add(User.mpToUser(ls));
    setState(() {});
  }
}
