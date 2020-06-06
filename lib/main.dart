import 'package:ThreeObjective/ui/historico.dart';
import 'package:ThreeObjective/ui/notificacion.dart';
import 'package:flutter/material.dart';
import 'package:ThreeObjective/ui/home.dart';
import 'package:ThreeObjective/ver_objetivo.dart';


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
      '/notificacion': (context) => Notificacion(),
    },
  ));
}
