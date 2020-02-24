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
  Icon icono = Icon(Icons.work, color: Colors.orange);

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
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                children: <Widget>[
                  SizedBox(height: 12),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.title, color: Colors.green),
                      hintText: 'Introduce el objetivo',
                      labelText: 'Objetivo',
                      filled: true,
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.description, color: Colors.green),
                      hintText: 'Descripción del objetivo',
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                  ),
                  SizedBox(height: 12),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(
                        Icons.pan_tool,
                        color: Colors.orange,
                      ),
                      hintText: 'Plan de acción',
                      labelText: 'Plan de acción',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 2,
                  ),
                  SizedBox(height: 12),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Flexible(
                        child: new TextFormField(
                          enabled: false,
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.calendar_today,
                                color: Colors.green),
                            hintText: 'Creación:',
                            labelText: 'Creación:',
                            filled: true,
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      new Flexible(
                        child: new TextFormField(
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.calendar_today,
                                color: Colors.green),
                            hintText: 'Realizar el:',
                            labelText: 'Realizar el:',
                            filled: true,
                            border: UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ],
                  ),
                  new FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: icono,
                          labelText: '¿Realizado?',
                        ),
                        isEmpty: realizado == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton(
                            value: realizado,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                print(newValue == "Sin realizar");
                                switch (newValue) {
                                  case "Sin realizar":
                                    icono = Icon(Icons.work, color: Colors.red);
                                    break;
                                  case "Realizado":
                                    icono =
                                        Icon(Icons.work, color: Colors.green);
                                    break;
                                  default:
                                    icono = icono =
                                        Icon(Icons.work, color: Colors.orange);
                                }
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
