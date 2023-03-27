import 'package:flutter_front/obj.dart';

class Values {
  static bool login = false;
  static String server = "http://81.69.99.102:8080";
  static String avatarUrl = "http://81.69.99.102/gobang/avatar/";
  static User user = User(0, "mdd", "", 0, 3, "");
  static List<User> friendList = [];
  static List<Friend> newFriendList = [];
  static List<Room> roomList = [];
  static late Room currentRoom;
  static MyWebSocket myWebSocket = MyWebSocket();
  static String wsUrl = "ws://81.69.99.102:8081";
}
