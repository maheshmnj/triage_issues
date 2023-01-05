import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FlutterTest(),
    );
  }
}

class FlutterTest extends StatefulWidget {
  const FlutterTest({Key? key}) : super(key: key);

  @override
  State<FlutterTest> createState() => _FlutterTestState();
}

class _FlutterTestState extends State<FlutterTest> {
  CameraController? _cameraController;
  List<CameraDescription>? _availableCameras;
  final ValueNotifier<VideoPlayerController?> videoPlayerController =
      ValueNotifier<VideoPlayerController?>(null);
  VideoPlayerController? videoController;
  bool isLoading = false;
  bool isRecording = false;

  @override
  void dispose() {
    // TODO: implement dispose
    videoController!.dispose();
    _cameraController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    _availableCameras ??= await availableCameras();
    _cameraController = CameraController(
      _availableCameras!.first,
      ResolutionPreset.max,
    );
    await _cameraController!.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: isLoading
                ? loading()
                : Center(
                    child: videoController == null
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              _cameraController == null
                                  ? const SizedBox()
                                  : CameraPreview(_cameraController!),
                              Text(
                                !isRecording
                                    ? 'Please, record a video'
                                    : 'Recording',
                                style: TextStyle(
                                    color: isRecording
                                        ? Colors.red
                                        : Colors.black),
                              ),
                            ],
                          )
                        : VideoPlayer(videoController!)),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: ElevatedButton(
                onPressed: !isRecording ? recordVideo : pauseVideoRecording,
                child:
                    Text(isRecording ? 'Stop Video Recording' : 'Record video'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loading() {
    return const Center(child: CircularProgressIndicator());
  }

  Future<void> pauseVideoRecording() async {
    XFile xfile = await _cameraController!.stopVideoRecording();

    videoController = VideoPlayerController.network(xfile.path);

    await videoController!.initialize().then((value) {
      setState(() {
        isRecording = false;
      });
      videoController!.play();
    });
  }

  Future<void> recordVideo() async {
    if (videoController != null) {
      videoController!.dispose();
      videoController = null;
    }
    setState(() {
      isLoading = true;
    });
    _availableCameras ??= await availableCameras();
    _cameraController ??= CameraController(
      _availableCameras!.first,
      ResolutionPreset.max,
    );
    await _cameraController!.initialize();
    setState(() {
      isLoading = false;
    });

    await _cameraController!.startVideoRecording();
    setState(() {
      isRecording = true;
    });
  }
}
