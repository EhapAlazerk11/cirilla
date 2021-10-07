import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:provider/provider.dart';

class VideoWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;
  VideoWidget({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);
  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void didChangeDependencies() {
    initializePlayer();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    String url = get(fields, ['url', 'text'], '');
    _videoPlayerController = VideoPlayerController.network(url);
    await Future.wait([_videoPlayerController!.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoInitialize: true,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    double? height = ConvertData.stringToDouble(get(fields, ["height"], 315), 315);
    double? width = ConvertData.stringToDouble(get(fields, ["width"], 560), 560);

    /// Styles
    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};

    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);

    Map? padding = get(styles, ['padding'], {});
    Map? margin = get(styles, ['margin'], {});

    return Container(
        padding: ConvertData.space(padding, 'padding'),
        margin: ConvertData.space(margin, 'margin'),
        color: background,
        child: LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            double widthView = constraints.maxWidth;
            double heightView = widthView * height / width;
            return _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                ? SizedBox(
                    width: widthView,
                    height: heightView,
                    child: Chewie(
                      controller: _chewieController!,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                    ],
                  );
          },
        ));
  }
}
