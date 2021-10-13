import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

final darkNotifier = ValueNotifier<bool>(false);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: InfiniteListView());
  }
}

class InfiniteListView extends StatefulWidget {
  const InfiniteListView({Key? key}) : super(key: key);

  @override
  _InfiniteListViewState createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  @override
  Widget build(BuildContext context) {
    bool isDark = darkNotifier.value;
    final int length = Colors.primaries.length;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isDark = !isDark;
          darkNotifier.value = isDark;
        },
        tooltip: 'Increment',
        child: Icon(isDark ? Icons.wb_sunny_outlined : Icons.bubble_chart),
      ),
      appBar: AppBar(
        title: Text('ListView example'),
      ),
      body: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.primaries[index % length],
              height: 80,
              alignment: Alignment.center,
              child: Text(
                '${Colors.primaries[index % length]}',
                style: TextStyle(color: Colors.white),
              ),
            );
          }),
    );
  }
}
