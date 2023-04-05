import 'dart:convert';

import 'package:flutter_front/values.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class User {
  int id;
  String username;
  String password;
  int totalMatches;
  int winMatches;
  late double winPercentage;
  String avatarName;
  bool isFriend = false;

  User(this.id, this.username, this.password, this.totalMatches,
      this.winMatches, this.avatarName,
      {bool? isFriend}) {
    winPercentage = 0;
    if (totalMatches != 0) {
      winPercentage = winMatches / totalMatches;
    }
    if (isFriend != null) {
      this.isFriend = isFriend;
    }
  }

  static User mpToUser(Map<String, dynamic> mp) {
    User user = User(
      mp["id"],
      mp["username"],
      mp["password"],
      mp["totalMatches"],
      mp["winMatches"],
      mp["avatarName"],
    );
    return user;
  }

  static User jsonToUser(String str) {
    Map<String, dynamic> mp = jsonDecode(str);
    return mpToUser(mp);
  }
}

class Friend {
  int id;
  int userIdFrom;
  int userIdTo;
  bool status;
  User userFrom;
  User userTo;
  Friend(
    this.id,
    this.userIdFrom,
    this.userIdTo,
    this.status,
    this.userFrom,
    this.userTo,
  );
  static Friend mpToFriend(Map<String, dynamic> mp) {
    Friend friend = Friend(
      mp["id"],
      mp["userIdFrom"],
      mp["userIdTo"],
      mp["status"],
      User.mpToUser(mp["userFrom"]),
      User.mpToUser(mp["userTo"]),
    );
    return friend;
  }

  static Friend jsonToFriend(String str) {
    Map<String, dynamic> mp = jsonDecode(str);
    return mpToFriend(mp);
  }
}

class Room {
  int id;
  String status;
  int userIdCreator;
  int userIdJoin;
  User userCreator;
  User? userJoin;
  Room(this.id, this.status, this.userIdCreator, this.userIdJoin,
      this.userCreator, this.userJoin);
  static Room mpToRoom(Map<String, dynamic> mp) {
    Room room = Room(
      mp["id"],
      mp["status"],
      mp["userIdCreator"],
      mp["userIdJoin"] ?? 0,
      User.mpToUser(mp["userCreator"]),
      mp["userJoin"] == null ? null : User.mpToUser(mp["userJoin"]),
    );
    return room;
  }

  static Room jsonToFriend(String str) {
    Map<String, dynamic> mp = jsonDecode(str);
    return mpToRoom(mp);
  }
}

class Match {
  int id;
  int roomId;
  String info;
  Match(this.id, this.roomId, this.info);
}

class ChessBoard {
  int userId;
  int opponentId;
  int x;
  int y;
  int roomId;
  int count;
  bool isWin;
  ChessBoard(
    this.userId,
    this.opponentId,
    this.x,
    this.y,
    this.roomId,
    this.count,
    this.isWin,
  );
}

class Chat {
  String content;
  int fromId;
  DateTime time;
  int toId;
  Chat(this.content, this.fromId, this.time, this.toId);
  static Chat mpToChat(Map<String, dynamic> mp) {
    Chat chat = Chat(
      mp["content"],
      mp["fromId"],
      DateTime.parse(mp["time"]),
      mp["toId"],
    );
    return chat;
  }

  static Chat jsonToChat(String str) {
    Map<String, dynamic> mp = jsonDecode(str);
    return mpToChat(mp);
  }
}

class MyWebSocket {
  static late WebSocketChannel channel;

  void connect() {
    channel = WebSocketChannel.connect(
      Uri.parse("${Values.wsUrl}/play?id=${Values.user.id}"),
    );
    channel.stream.listen((event) {
      print("收到了websocket信息: $event");
      Map<String, dynamic> mp = json.decode(event);
      if (mp["name"] == "Room") {
        handleRoom(mp["content"]);
      }
      if (mp["name"] == "Chat") {
        getMessage(mp["content"]);
      }
    });
  }

  void close() {
    channel.sink.close();
  }

  void getMessage(Map<String, dynamic> mp) {
    Values.message.add(Chat.mpToChat(mp));
  }

  void handleRoom(Map<String, dynamic> mp) {
    int nowId = mp["id"];
    int roomIndex = -1;
    for (int i = 0; i < Values.roomList.length; i++) {
      if (Values.roomList[i].id == nowId) {
        roomIndex = i;
        break;
      }
    }
    if (roomIndex != -1) {
      Values.roomList[roomIndex] = Room.mpToRoom(mp);
    } else {
      Values.roomList.add(Room.mpToRoom(mp));
    }
    if (Values.currentRoom.id == nowId) {
      Values.currentRoom = Room.mpToRoom(mp);
    }
  }

  void dispose() {
    channel.sink.close();
  }

  void _sendMessage(String text) {
    channel.sink.add(text);
  }
}
