import 'package:cirilla/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class Position extends StatefulWidget {
  final AudioPlayer? player;
  final TextStyle? stylePosition;
  final TextStyle? styleDuration;
  Position({required this.player, this.stylePosition, this.styleDuration});
  _PositionState createState() => _PositionState();
}

class _PositionState extends State<Position> {
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
              return Row(
                children: [
                  SizedBox(
                      width: position.inMilliseconds.toDouble() > 3599070.0 ? 39 : 33,
                      child: Text(formatPosition(position: position) ?? '$position', style: widget.stylePosition)),
                  Text('/'),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 6),
                    child: Text(formatPosition(position: duration) ?? '$duration', style: widget.styleDuration),
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
