import 'package:audio_session/audio_session.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlParser;
import 'package:just_audio/just_audio.dart';

import 'audio/control_buttons.dart';
import 'audio/position.dart';
import 'audio/progress_bar.dart';

class Audio extends StatefulWidget {
  final Map<String, dynamic>? block;

  Audio({this.block});

  @override
  _AudioState createState() => _AudioState();
}

class _AudioState extends State<Audio> with Utility {
  AudioPlayer? _player;
  late SliderThemeData _sliderThemeData;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    _player!.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace stackTrace) {
      print(e);
    });
    try {
      dom.Document document = htmlParser.parse(widget.block!['innerHTML']);
      dom.Element audio = document.getElementsByTagName('audio')[0];
      String uri = get(audio.attributes, ['src'], '');
      await _player!.setAudioSource(AudioSource.uri(
        Uri.parse(uri),
      ));
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _player!.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    double sizeIcon = 20;
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(24)),
      height: 42,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ControlButtons(
            player: _player,
            padding: EdgeInsetsDirectional.only(start: 12, end: 6),
            iconLoading: Container(
              width: sizeIcon,
              height: sizeIcon,
              child: CircularProgressIndicator(),
            ),
            iconPlay: Icon(
              Icons.play_arrow,
              size: sizeIcon,
            ),
            iconPause: Icon(
              Icons.pause,
              size: sizeIcon,
            ),
            iconReplay: Icon(
              Icons.replay,
              size: sizeIcon,
            ),
          ),
          Position(
            player: _player,
            stylePosition: Theme.of(context).textTheme.caption,
            styleDuration: Theme.of(context).textTheme.caption,
          ),
          Expanded(
            child: ProgressBar(
              player: _player,
              sliderThemeProgress: _sliderThemeData.copyWith(
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.3),
                inactiveTrackColor: Theme.of(context).colorScheme.surface,
                trackShape: CustomTrackShape(),
                // overlayColor: Colors.red.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0),
              ),
              sliderThemeLineaProgress: _sliderThemeData.copyWith(
                inactiveTrackColor: Colors.transparent,
                activeTrackColor: Theme.of(context).primaryColor,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 0.0,
                ),
                trackShape: CustomTrackShape(),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0),
              ),
              onChangeEnd: (newPosition) {
                _player!.seek(newPosition);
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              _showSliderDialog(
                context: context,
                title: "volume",
                divisions: 10,
                min: 0.0,
                max: 1.0,
                stream: _player!.volumeStream,
                onChanged: _player!.setVolume,
              );
            },
            child: Container(
              padding: const EdgeInsets.only(
                left: 6.0,
                right: 6.0,
              ),
              child: Icon(
                Icons.volume_up,
                size: sizeIcon,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.only(
                left: 6.0,
                right: 12.0,
              ),
              child: Icon(
                Icons.more_vert_sharp,
                size: sizeIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(fontFamily: 'Fixed', fontWeight: FontWeight.bold, fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
