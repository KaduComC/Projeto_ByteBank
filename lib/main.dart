import 'package:flutter/material.dart';

import 'screens/dashboard.dart';

void main() {
  runApp(const ByteBank());
}

class ByteBank extends StatelessWidget {
  const ByteBank({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        appBarTheme: AppBarTheme(color: Colors.blue[900]),
      ),
      home: const Dashboard(),
    );
  }
}
