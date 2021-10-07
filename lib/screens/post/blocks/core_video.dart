import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as dom;
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';

class Video extends StatefulWidget {
  final Map<String, dynamic>? block;
  const Video({Key? key, this.block}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> with Utility {
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
    dom.Document document = htmlParser.parse(widget.block!['innerHTML']);

    List<dom.Element> video = document.getElementsByTagName("figure")[0].getElementsByTagName('video');

    if (video.length > 0) {
      String url = get(video[0].attributes, ['src'], '');

      _videoPlayerController = VideoPlayerController.network(url);

      await Future.wait([_videoPlayerController!.initialize()]);

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoInitialize: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
        ],
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.portraitUp,
        ],
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
          ? Chewie(
              controller: _chewieController!,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
              ],
            ),
    );
  }
}
