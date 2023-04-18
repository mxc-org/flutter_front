import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front/values.dart';

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
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        CircularProgressIndicator(
          value: 1.0 - Values.remainTime / 90,
        )
      ],
    );
  }
}
