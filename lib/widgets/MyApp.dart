import 'package:flutter/material.dart';

import 'Home.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Home(title: 'Weather'),
      debugShowCheckedModeBanner: false,
    );
  }
}