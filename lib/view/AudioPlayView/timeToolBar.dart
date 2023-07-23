import 'package:flutter/material.dart';

class TimeToolBar extends StatefulWidget {
  final int trackTimeMillis;
  const TimeToolBar({super.key, required this.trackTimeMillis});

  @override
  State<TimeToolBar> createState() => _TimeToolBarState();
}

class _TimeToolBarState extends State<TimeToolBar> {
  double _current = 0;
  String _currentTime = '00:00';
  late final Duration totalTime =
      Duration(milliseconds: widget.trackTimeMillis);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(_currentTime),
            const Spacer(),
            Text(
                '${(totalTime.inMinutes % 60).toString().padLeft(2, '0')}:${(totalTime.inSeconds % 60).toString().padLeft(2, '0')}')
          ],
        ),
        Slider(
          value: _current,
          max: widget.trackTimeMillis.toDouble(),
          divisions: widget.trackTimeMillis,
          label: _currentTime,
          onChanged: (value) {
            setState(() {
              _current = value;
            });
          },
        )
      ],
    );
  }

  String toTime(double timeMillis) {
    return '';
  }

  int msToSecond(int ms) {
    return ms ~/ 1000;
  }
}
