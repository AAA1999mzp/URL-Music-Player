import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/player_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlayerView(),
    );
  }
}
