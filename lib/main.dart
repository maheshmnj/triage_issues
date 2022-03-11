import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const VideoApp());

class VideoApp extends StatefulWidget {
  const VideoApp({final Key? key}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    )
      ..initialize()
      ..setLooping(true)
      ..play().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: ListView(
          children: [
            ..._generateChildren(5),
            const SizedBox(
              height: 200,
              child: WebView(
                initialUrl:
                    'https://www.youtube.com/watch?v=oYnpQ3Mjg_g&ab_channel=TeslaDaily',
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const SizedBox(),
            ),
            ..._generateChildren(10),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  List<Widget> _generateChildren(final int number) {
    final List<Widget> children = [];

    for (var i = 0; i < number; i++) {
      children.add(
        Container(
          height: 80,
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1),
        ),
      );
    }

    return children;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
