import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front/util/values.dart';

class RemainTimeWidget extends StatefulWidget {
  const RemainTimeWidget({super.key});

  @override
  State<RemainTimeWidget> createState() => _RemainTimeWidgetState();
}

class _RemainTimeWidgetState extends State<RemainTimeWidget> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          "${Values.remainTime}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold 
          ),
        ),
        CircularProgressIndicator(
          value: 1 - Values.remainTime / 60,
          backgroundColor: Colors.brown,
          color: const Color.fromARGB(255, 255, 230, 192),
        )
      ],
    );
  }
}
