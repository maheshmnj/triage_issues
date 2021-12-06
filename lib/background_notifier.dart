import 'package:flutter/material.dart';

class BackgroundNotifier extends StatefulWidget {
  const BackgroundNotifier({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<BackgroundNotifier> createState() => _BackgroundNotifierState();
}

class _BackgroundNotifierState extends State<BackgroundNotifier>
    with WidgetsBindingObserver {
  int _counter = 0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        print('app went to background counter is $_counter');

        /// TODO: CALL YOUR METHOD HERE

        break;
      case AppLifecycleState.resumed:
        print('app brought to foreground counter is $_counter');

        /// TODO: CALL YOUR METHOD HERE

        break;
      default:
        print('app state changed $state');
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
