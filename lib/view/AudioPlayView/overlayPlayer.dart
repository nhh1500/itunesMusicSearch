import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/viewModel/audioPlayer.dart';

class OverlayPlayer extends StatefulWidget {
  const OverlayPlayer({super.key});

  @override
  State<OverlayPlayer> createState() => _OverlayPlayerState();
}

class _OverlayPlayerState extends State<OverlayPlayer> {
  late final AudioPlayerVM player;
  @override
  void initState() {
    super.initState();
    player = Get.find<AudioPlayerVM>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: Colors.pink,
        child: Icon(Icons.add),
      ),
    );
  }
}
