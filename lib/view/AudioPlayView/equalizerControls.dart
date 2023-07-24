import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Widget to control equalizer
class EqualizerControls extends StatelessWidget {
  final AndroidEqualizer equalizer;

  const EqualizerControls({
    Key? key,
    required this.equalizer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AndroidEqualizerParameters>(
      future: equalizer.parameters,
      builder: (context, snapshot) {
        final parameters = snapshot.data;
        if (parameters == null) return const SizedBox();
        return Container(
          height: 200,
          width: 200,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              for (var band in parameters.bands)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<double>(
                          stream: band.gainStream,
                          builder: (context, snapshot) {
                            return VerticalSlider(
                              min: parameters.minDecibels,
                              max: parameters.maxDecibels,
                              value: band.gain,
                              onChanged: band.setGain,
                            );
                          },
                        ),
                      ),
                      Text('${band.centerFrequency.round()} Hz'),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class VerticalSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;

  const VerticalSlider({
    Key? key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      alignment: Alignment.bottomCenter,
      child: Transform.rotate(
        angle: -pi / 2,
        child: Container(
          width: 400.0,
          height: 400.0,
          alignment: Alignment.center,
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
