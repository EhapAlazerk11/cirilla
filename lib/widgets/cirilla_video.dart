import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';

class CirillaVideo extends StatefulWidget {
  final String url;

  const CirillaVideo({Key? key, required this.url}) : super(key: key);

  @override
  _CirillaVideoState createState() => _CirillaVideoState();
}

class _CirillaVideoState extends State<CirillaVideo> with Utility, LoadingMixin {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void didChangeDependencies() async {
    await initializePlayer();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.url);
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

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
          ? Chewie(controller: _chewieController!)
          : entryLoading(context),
    );
  }
}
