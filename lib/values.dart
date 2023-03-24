import 'package:flutter_front/obj.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Values {
  static bool login = false;
  static String server = "http://81.69.99.102:8080";
  static String avatarUrl = "http://81.69.99.102/gobang/avatar/";
  static User user = User(0, "mdd", "", 0, 3, "");
  static List<User> friendList = [];
  static List<Friend> newFriendList = [];
  static List<Room> roomList = [];
  static late WebSocketChannel channel;
  static String wsUrl = "ws://81.69.99.102:8081";
}
