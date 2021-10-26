import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Text Input Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double shortestSide = MediaQuery.of(context).size.shortestSide;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.red,
                  size: 40,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          width: shortestSide > 600 ? 400 : 250,
                          height: 150,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: shortestSide > 600 ? 360 : 210,
                                child: TextField(
                                  controller: _searchCtrl,
                                  cursorColor: Colors.red,
                                  autofocus: true,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    labelText: "Search by Place Name",
                                    labelStyle:
                                        const TextStyle(color: Colors.red),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color: Colors.grey,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                        width: 2,
                                        color: Colors.red,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(
                                          color: Colors.green,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    label: Text(
                                      "Search",
                                      style: TextStyle(
                                        fontSize: width < 600 ? 12 : 18,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.search_rounded,
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SizedBox(
                                    width: width < 600 ? 5 : 20,
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(
                                          color: Colors.red,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    label: Text(
                                      "Clear",
                                      style: TextStyle(
                                        fontSize: width < 600 ? 12 : 18,
                                      ),
                                    ),
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchCtrl.clear();
                                      FocusScope.of(context).unfocus();
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
