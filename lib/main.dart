import 'package:flutter/material.dart';
import 'package:routes_issue/search.dart';
import 'package:routes_issue/video.dart';
import 'package:routes_issue/waveform.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'background_notifier.dart';
import 'camera.dart';
import 'image_picker.dart';

void main() async {
  // setUrlStrategy(PathUrlStrategy());
  runApp(MaterialApp(
    initialRoute: "/home",
    routes: <String, WidgetBuilder>{
      '/home': (BuildContext context) => Home(),
      '/BackgroundNotifier': (BuildContext context) => const BackgroundNotifier(
            title: 'BackgroundNotifier',
          ),
      '/wave_form': (BuildContext context) => const WaveFormSample(),
      '/image_picker': (BuildContext context) => ImagePickerSample(
            title: 'image picker sample',
          ),
      '/video_app': (BuildContext context) => VideoApp(),
      '/camera_app': (BuildContext context) => CameraExampleHome(),
      '/search_app': (BuildContext context) => SearchDemo(),
    },
    onUnknownRoute: (RouteSettings settings) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) =>
            const Scaffold(body: Center(child: Text('404 Not Found'))),
      );
    },
  ));
}

class Home extends StatelessWidget {
  List<String> widgets = [
    'image_picker',
    'wave_form',
    'BackgroundNotifier',
    'video_app',
    'camera_app',
    'search_app'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Screen 1')),
        body: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: widgets.length,
            itemBuilder: (x, y) {
              return ListTile(
                title: Text('${widgets[y]} sample'),
                onTap: () {
                  Navigator.pushNamed(context, '/${widgets[y]}');
                },
              );
            }));
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Example to show case loading local asset',
            ),
            Image.asset(
              'assets/snippet.png',
            ),
            Text(
              '100',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
