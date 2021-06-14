import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomePage(),
      // debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  Future<void> _setAndToast() async {
    await FlutterClipboard.copy('\u200e'); // left-to-right mark
    await Fluttertoast.showToast(msg: 'Clipboard set');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Left-to-right mark'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _setAndToast,
              child: Text('Set clipboard')
            ),
          ],
        ),
      ),
    );
  }
}
