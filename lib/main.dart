import 'package:flutter/material.dart';
import 'package:objetive/ui/home.dart';


void main() async {
  runApp(new MaterialApp(
    //debugShowCheckedModeBanner: false,
    home: new Home(),
    theme: ThemeData(
      primarySwatch: Colors.brown,
    ),
    title: "Objetivos",
  ));
}
