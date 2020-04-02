import 'package:Objective/ui/historico.dart';
import 'package:flutter/material.dart';
import 'package:Objective/ui/home.dart';
import 'package:Objective/ver_objetivo.dart';


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
      '/historico': (context) => Historico(),
    },
  ));
}
