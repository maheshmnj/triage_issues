// ISSUE: https://github.com/flutter/flutter/issues/90451

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter ios Video Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> urlList = [
    "https://jsoncompare.org/LearningContainer/SampleFiles/Video/MP4/sample-mp4-file.mp4",
    'https://jsoncompare.org/LearningContainer/SampleFiles/Video/MP4/Sample-MP4-Video-File-for-Testing.mp4',
    "https://jsoncompare.org/LearningContainer/SampleFiles/Video/MP4/sample-mp4-file.mp4",
  ];
  int current = 0;
  VideoPlayerController? _controller;

  // var s =   VideoPlayerController.network("asd").preloadTag("");
  void _incrementCounter() async {
    if (_controller != null) {
      await _controller!.pause();
      await _controller!.dispose();
      _controller = null;
    }
    _controller = VideoPlayerController.network(
      urlList[current],
    );
    _controller!.initialize().then((value) {
      setState(() {
        _controller!.setVolume(0);
        _controller!.play();
        _controller!.setLooping(true);
      });
    });
  }

  @override
  void initState() {
    _incrementCounter();
    super.initState();
  }

  var colorList = [Colors.red, Colors.green, Colors.black];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.amber,
        // height: 300,
        // width: 300,
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 3,
          itemBuilder: (context, index) {
            if (current != index) {
              _incrementCounter();
              current = index;
            }

            return Container(
              color: colorList[index],
              child: Center(
                child: _controller != null
                    ? Container(
                        padding: const EdgeInsets.all(20),
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              VideoPlayer(_controller!),
                              // VideoProgressIndicator(_controller, allowScrubbing: true),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.cyan,
                      ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller!.setVolume(0.5);
            _controller!.play();
          });
        },
        tooltip: 'Play',
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
