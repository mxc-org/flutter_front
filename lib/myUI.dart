import 'package:flutter/material.dart';

class MyUI extends StatefulWidget {
  const MyUI({super.key});

  @override
  State<MyUI> createState() => _MyUIState();
}

class _MyUIState extends State<MyUI> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color.fromARGB(127, 255, 153, 0),
              ),
              child: Column(
                children: [
                  //个人头像和昵称展示
                  Row(
                    children: [
                      //头像
                      Container(
                        margin: const EdgeInsets.only(left: 20, top: 20),
                        width: 80,
                        height: 80,
                        child: Image(image: AssetImage("images/userpic.png")),
                      ),
                      //用户名
                      Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text("这是用户名mxc", style: TextStyle(fontSize: 24)),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //对局胜率信息展示
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text("胜局", style: TextStyle(fontSize: 20)),
                            Text("0", style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text("败局", style: TextStyle(fontSize: 20)),
                            Text("0", style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text("胜率", style: TextStyle(fontSize: 20)),
                            Text("0", style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            //其他一些选项，例如修改用户名
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: ElevatedButton(
                style: const ButtonStyle(
                  // alignment: Alignment.centerLeft,
                  minimumSize: MaterialStatePropertyAll(
                    Size(double.infinity, 50),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "修改用户名",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: ElevatedButton(
                style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(
                    Size(double.infinity, 50),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "修改头像",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: ElevatedButton(
                style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(
                    Size(double.infinity, 50),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "修改密码",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
        Container(
          alignment: AlignmentDirectional.bottomCenter,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange),
            ),
            onPressed: () {},
            child: const Text(
              "退出登录",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }
}
