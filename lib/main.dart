import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  runApp(MaterialApp(
    initialRoute: "/screen1",
    routes: <String, WidgetBuilder>{
      '/screen1': (BuildContext context) => Screen1(),
      '/screen2': (BuildContext context) => Screen2()
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

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Screen 1')),
        body: Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/screen2');
                },
                child: const Text('Goto Page2'))));
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
