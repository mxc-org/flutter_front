import 'package:flutter/material.dart';
import 'package:flutter_front/gameUI.dart';
import 'package:flutter_front/values.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

import 'obj.dart';

class RoomUI extends StatefulWidget {
  const RoomUI({super.key});

  @override
  State<RoomUI> createState() => _RoomUIState();
}

class _RoomUIState extends State<RoomUI> {
  List<User> listUser = [];
  final channel = WebSocketChannel.connect(
    Uri.parse("ws://81.69.99.102:8081/play?id=${Values.user.id}"),
  );
  @override
  void initState() {
    getRoomList();
    super.initState();
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
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    handleRoomList(snapshot.data);
                  }
                  return SingleChildScrollView(
                    child: roomListView(),
                  );
                },
              ),
            ),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget roomListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: Values.roomList.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      Values.avatarUrl +
                          Values.roomList[i].userCreator.avatarName,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                height: 30,
                width: 30,
                child: Image.asset('images/VS.jpeg'),
              ),
              const SizedBox(width: 15),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      Values.avatarUrl + Values.roomList[i].userJoin.avatarName,
                    ),
                  ),
                ),
              ),
            ],
          ),
          leading: Container(
            alignment: Alignment.center,
            width: 50,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${Values.roomList[i].id}号房间",
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 9, 9, 9),
              ),
            ),
          ),
          trailing: Text(Values.roomList[i].status),
        );
      },
    );
  }

  void getRoomList() async {
    listUser.clear();
    var response = await http.get(
      Uri.parse("${Values.server}/Room/RoomList"),
    );
    Values.roomList.clear();
    String str = utf8.decode(response.bodyBytes);
    if (str == "") {
      return;
    }
    List<dynamic> ls = json.decode(str);
    for (Map<String, dynamic> mp in ls) {
      Values.roomList.add(Room.mpToRoom(mp));
    }
    setState(() {});
  }

  void handleRoomList(String snapshot) {
    print(snapshot);
  }
}
