import 'package:flutter/material.dart';
import 'package:objetive/ui/home.dart';
import 'package:objetive/ver_objetivo.dart';


void main() async {
  runApp(new MaterialApp(
    //debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.brown,
    ),
    title: "Objetivos",
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (context) => Home(),
      '/verObjetivo': (context) => VerObjetivo(),
    },
  ));
}
