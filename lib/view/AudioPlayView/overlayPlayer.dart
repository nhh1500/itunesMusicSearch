import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/viewModel/overlayPlayerVM.dart';

class OverlayPlayer extends StatefulWidget {
  const OverlayPlayer({super.key});

  @override
  State<OverlayPlayer> createState() => _OverlayPlayerState();
}

class _OverlayPlayerState extends State<OverlayPlayer> {
  //AudioPlayerVM player = Get.find<AudioPlayerVM>();
  OverLayPlayerVM overlay = Get.find<OverLayPlayerVM>();
  double height = 50;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double viewInset = MediaQuery.of(context).viewInsets.bottom;

    // return GestureDetector(
    //   onPanUpdate: (details) {
    //     double tapPosition = details.globalPosition.dy;
    //     double bottomOffset = screenHeight - viewInset - tapPosition;
    //     if (bottomOffset > screenHeight) {
    //       bottomOffset = screenHeight;
    //     }
    //     if (bottomOffset < 0) {
    //       bottomOffset = 0;
    //     }
    //     setState(() {
    //       height = bottomOffset;
    //       print(height);
    //     });
    //   },
    //   onPanEnd: (details) {},
    //   child: Container(
    //     height: height,
    //     width: MediaQuery.of(context).size.width,
    //     color: Colors.pink,
    //     child: Icon(Icons.add),
    //   ),
    // );
    return Container();
  }
}
