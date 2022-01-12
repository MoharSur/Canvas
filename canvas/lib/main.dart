// ignore_for_file: use_key_in_widget_constructors

import 'package:canvas/paintboard.dart';
import 'package:canvas/portrait.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'landscape.dart';


void main(){

  GetIt.I.registerSingleton(PaintBoard(), instanceName: 'board');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constraints) {
          if (constraints.maxHeight > constraints.maxWidth) {
            return const Portrait();
          }
          return const LandScape();
        },
      ),
    );
  }

}
