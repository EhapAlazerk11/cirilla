import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class ProgressBar extends StatefulWidget {
  final AudioPlayer? player;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  final SliderThemeData? sliderThemeProgress;
  final SliderThemeData? sliderThemeLineaProgress;
  ProgressBar(
      {required this.player,
      this.onChanged,
      this.onChangeEnd,
      this.sliderThemeProgress,
      this.sliderThemeLineaProgress});

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
        stream: widget.player!.durationStream,
        builder: (context, snapshot) {
          final duration = snapshot.data ?? Duration.zero;
          return StreamBuilder<PositionData>(
            stream: Rx.combineLatest2<Duration, Duration, PositionData>(
                widget.player!.positionStream,
                widget.player!.bufferedPositionStream,
                (position, bufferedPosition) => PositionData(position, bufferedPosition)),
            builder: (context, snapshot) {
              final positionData = snapshot.data ?? PositionData(Duration.zero, Duration.zero);
              Duration position = positionData.position;
              if (position > duration) {
                position = duration;
              }
              Duration bufferedPosition = positionData.bufferedPosition;
              if (bufferedPosition > duration) {
                bufferedPosition = duration;
              }
              return Stack(
                children: [
                  SliderTheme(
                    data: widget.sliderThemeProgress!,
                    child: ExcludeSemantics(
                      child: Slider(
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble(),
                        value: bufferedPosition.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            _dragValue = value;
                          });
                          if (widget.onChanged != null) {
                            widget.onChanged!(Duration(milliseconds: value.round()));
                          }
                        },
                        onChangeEnd: (value) {
                          if (widget.onChangeEnd != null) {
                            widget.onChangeEnd!(Duration(milliseconds: value.round()));
                          }
                          _dragValue = null;
                        },
                      ),
                    ),
                  ),
                  SliderTheme(
                    data: widget.sliderThemeLineaProgress!,
                    child: Slider(
                      min: 0.0,
                      max: duration.inMilliseconds.toDouble(),
                      value: min(_dragValue ?? position.inMilliseconds.toDouble(), duration.inMilliseconds.toDouble()),
                      onChanged: (value) {
                        setState(() {
                          _dragValue = value;
                        });
                        if (widget.onChanged != null) {
                          widget.onChanged!(Duration(milliseconds: value.round()));
                        }
                      },
                      onChangeEnd: (value) {
                        if (widget.onChangeEnd != null) {
                          widget.onChangeEnd!(Duration(milliseconds: value.round()));
                        }
                        _dragValue = null;
                      },
                    ),
                  ),
                ],
              );
            },
          );
        });
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}
