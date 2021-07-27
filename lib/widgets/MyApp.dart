import 'package:flutter/material.dart';

import 'Home.dart';

class MyApp extends StatelessWidget {
  MyApp(String ville) {
    this.ville = ville;
  }

  String ville;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Home(ville, title: 'Weather'),
      debugShowCheckedModeBanner: false,
    );
  }
}
