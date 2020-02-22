import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/Objetivo.dart';

void main() => runApp(new VerObjetivo());

class VerObjetivo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Objetivo',
      theme: new ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: new MyHomePage(title: 'Objetivo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> opcionesRealizado = <String>['', 'Sin realizar', 'Realizado'];
  String realizado = '';
  Objetivo objetivo = new Objetivo();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.title),
                      hintText: 'Introduce el objetivo',
                      labelText: 'Objetivo',
                    ),
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.description),
                      hintText: 'Descripción del objetivo',
                      labelText: 'Descripción',
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.description),
                      hintText: 'Plan de acción',
                      labelText: 'Plan de acción',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.calendar_today),
                      hintText: 'Fecha de creación',
                      labelText: 'Fecha de creación',
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.calendar_today),
                      hintText: 'Fecha a realizar',
                      labelText: 'Fecha a realizar',
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  new FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.work),
                          labelText: '¿Realizado?',
                        ),
                        isEmpty: realizado == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton(
                            value: realizado,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                objetivo.realizado = newValue;
                                realizado = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: opcionesRealizado.map((String value) {
                              return new DropdownMenuItem(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new RaisedButton(
                        child: const Text('Editar'),
                        onPressed: null,
                      )),
                ],
              ))),
    );
  }
}