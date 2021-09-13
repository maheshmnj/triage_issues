import 'package:flutter/material.dart';

void main() async {
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
                child: Text('Goto Page2'))));
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Screen 2')),
      body: const Center(
          child: Text(
        "Screen 2",
        style: TextStyle(color: Colors.black),
      )),
    );
  }
}
