import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/game/fightUI.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_front/util/obj.dart';
import 'package:flutter_front/util/values.dart';

class InvitedUI extends StatefulWidget {
  const InvitedUI({super.key});

  @override
  State<InvitedUI> createState() => _InvitedUIState();
}

class _InvitedUIState extends State<InvitedUI> {
  List<Invitation> invitationList = [];

  @override
  void initState() {
    super.initState();
    getInvitaionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("对战请求"),
        backgroundColor: const Color.fromARGB(127, 255, 153, 0),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: myListView(),
        ),
      ),
    );
  }

  Widget myListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: invitationList.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(invitationList[i].Inviter.username),
          leading: Container(
            margin: const EdgeInsets.only(left: 10),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  "${Values.avatarUrl}${invitationList[i].Inviter.avatarName}",
                ),
              ),
            ),
          ),
          trailing: TextButton(
            onPressed: () {
              onAcceptPressed(invitationList[i]);
            },
            child: const Text(
              "接受",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  void onAcceptPressed(Invitation invitation) async {
    var response = await http.post(
      Uri.parse("${Values.server}/Invitation/HandleInvitation"),
      body: {
        "invitationId": invitation.id.toString(),
        "isAccept": true.toString(),
      },
    );
    String str = utf8.decode(response.bodyBytes);
    Values.currentRoom = Room.mpToRoom(jsonDecode(str));
    Values.turn = false;
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (buildContext) => const FightUI(),
      ),
    );
  }

  void getInvitaionList() async {
    invitationList.clear();
    var response = await http.get(
      Uri.parse(
        "${Values.server}/Invitation/InvitationList?userId=${Values.user.id}",
      ),
    );
    String str = utf8.decode(response.bodyBytes);
    List<dynamic> ls = json.decode(str);
    for (int i = 0; i < ls.length; i++) {
      Invitation invitation = Invitation.mpToInvitation(ls[i]);
      if (invitation.isValid) {
        invitationList.add(invitation);
      }
    }
    setState(() {});
  }

  showSingleActionDialog(String content) {
    showDialog(
      context: context,
      builder: (buildContext) => AlertDialog(
        title: const Text("提示"),
        content: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "确定",
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
