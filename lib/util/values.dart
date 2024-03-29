import 'package:flutter_front/util/obj.dart';
import 'package:flutter_front/util/audioPlay.dart';

class Values {
  static bool login = false;
  static String server = "http://81.69.99.102:8080";
  static String avatarUrl = "http://81.69.99.102/gobang/avatar/";
  static User user = User(0, "mdd", "", 0, 3, "");
  static List<User> friendList = [];
  static List<Friend> newFriendList = [];
  static List<Room> roomList = [];
  static Room currentRoom = Room(0, "0", 0, 0, Values.user, null);
  static MyWebSocket myWebSocket = MyWebSocket();
  static String wsUrl = "ws://81.69.99.102:8081";
  static bool ischat = false;
  static List<Chat> message = [];
  static List<ChessBoard> chessList = [];
  //最近一次落子
  static ChessBoard currentChess = ChessBoard(0, 0, -1, -1, false, false);
  // 棋子防误触，第一次点击则落下虚影，第二次点击相同的位置则真正落子
  static ChessBoard previewChess = ChessBoard(0, 0, -1, -1, false, false);
  static double width = 0;
  static bool turn = true; //是否轮到自己下棋
  static int win = 0; //0代表正在对局，1代表自己胜利，2代表对方胜利
  static bool notice = false;
  static bool connectStatus = true;
  static int remainTime = 60;
  static String audioUri = "http://127.0.0.1:9876/chess.mp3";
  static var audioPlay = AudioPlay();
  static bool judgeconnect = false;
}
