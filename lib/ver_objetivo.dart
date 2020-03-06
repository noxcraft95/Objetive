import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:objetive/models/nodo_item.dart';

void main() => runApp(new VerObjetivo());

class VerObjetivo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ItemObjetivo itemObjetivo = ModalRoute.of(context).settings.arguments;

    print(itemObjetivo);
    return new MaterialApp(
      title: 'Objetivo',
      theme: new ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: new MyHomePage(title:itemObjetivo.titulo,itemObjetivo: itemObjetivo,),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key,this.title, this.itemObjetivo}) : super(key: key);
  final String title;
  final ItemObjetivo itemObjetivo;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> opcionesRealizado = <String>['', 'Sin realizar', 'Realizado'];
  String realizado = '';
  Icon icono = Icon(Icons.work, color: Colors.orange);

  @override
  Widget build(BuildContext context) {
  print(widget.itemObjetivo);
    return new Scaffold(
      appBar: new AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.brown[400],
                  Colors.brown[900],
                ],
                begin: const FractionalOffset(0.0, 0.7),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
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
                    initialValue: widget.itemObjetivo.titulo,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.title, color: Colors.green),
                      hintText: 'Introduce el objetivo',
                      labelText: 'Objetivo',
                      filled: true,
                      border: UnderlineInputBorder(),
                    ),
                    maxLength: 25,
                  ),
                  SizedBox(height: 12),
                  new TextFormField(
                    initialValue: widget.itemObjetivo.descripcion,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.description, color: Colors.green),
                      hintText: 'Descripción del objetivo',
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 2,
                    minLines: 1,
                    maxLength: 50,
                  ),
                  SizedBox(height: 12),
                  new TextFormField(
                    initialValue: widget.itemObjetivo.planAccion,
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
                    minLines: 1,
                    maxLength: 50,
                  ),
                  SizedBox(height: 12),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Flexible(
                        child: new TextFormField(
                          initialValue: widget.itemObjetivo.fechaCreacion,
                          enabled: false,
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.calendar_today,
                                color: Colors.green),
                            hintText: 'Creación:',
                            labelText: 'Creación:',
                            filled: true,
                            border: UnderlineInputBorder(),
                          ),
                          maxLength: 10,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      new Flexible(
                        child: new TextFormField(
                          initialValue: widget.itemObjetivo.fechaRealizar,
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.calendar_today,
                                color: Colors.green),
                            hintText: 'Realizar el:',
                            labelText: 'Realizar el:',
                            filled: true,
                            border: UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.datetime,
                          maxLength: 10,
                        ),
                      ),
                    ],
                  ),
                  new FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: icono,
                        ),
                        isEmpty: realizado == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton(
                            hint: Text("¿Realizado?"),
                            value: widget.itemObjetivo.realizado,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
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
                                widget.itemObjetivo.realizado = newValue;
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
