import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ControlButtons extends StatelessWidget {
  final AudioPlayer? player;
  final EdgeInsetsDirectional? padding;
  final Widget? iconLoading;
  final Widget? iconPlay;
  final Widget? iconPause;
  final Widget? iconReplay;

  ControlButtons(
      {required this.player, this.padding, this.iconLoading, this.iconPause, this.iconPlay, this.iconReplay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: StreamBuilder<PlayerState>(
        stream: player!.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;
          if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
            return iconLoading!;
          } else if (playing != true) {
            return GestureDetector(
              onTap: player!.play,
              child: iconPlay,
            );
          } else if (processingState != ProcessingState.completed) {
            return GestureDetector(
              onTap: player!.pause,
              child: iconPause,
            );
          } else {
            return GestureDetector(
              onTap: () => player!.seek(Duration.zero, index: player!.effectiveIndices!.first),
              child: iconReplay,
            );
          }
        },
      ),
    );
  }
}
