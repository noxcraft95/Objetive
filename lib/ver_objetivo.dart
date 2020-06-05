import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ThreeObjective/models/nodo_item.dart';
import 'package:ThreeObjective/ui/home.dart';
import 'package:ThreeObjective/utils/database_utils.dart';
import 'package:ThreeObjective/utils/date_formatter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';


void main() => runApp(new VerObjetivo());

class VerObjetivo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ItemObjetivo itemObjetivo = ModalRoute.of(context).settings.arguments;

    return new MyHomePage(
      title: itemObjetivo.titulo,
      itemObjetivo: itemObjetivo,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.itemObjetivo}) : super(key: key);
  final String title;
  final ItemObjetivo itemObjetivo;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<String> opcionesRealizado = <String>['','Sin realizar', 'Realizado'];
  Icon icono = Icon(Icons.work, color: Colors.orange);

  final FocusNode _fnFechaRealizar = FocusNode();

  DateTime selectedDate = DateTime.now();
  TextEditingController textTitulo = new TextEditingController();
  TextEditingController textDescripcion = new TextEditingController();
  TextEditingController textPlanAccion = new TextEditingController();
  TextEditingController textFechaRealizar = new TextEditingController();
  String realizado;
  var db = new DatabaseHelper();

  void abrirDatePickerHasta(){
    if(_fnFechaRealizar.hasFocus) {
      _fnFechaRealizar.unfocus();
      DatePicker.showDatePicker(context, showTitleActions: true,
          onChanged: (date) {
            print('change $date');
          },
          onConfirm: (date) async {
            print('confirm $date');
            await db.getConteoFecha(parseFecha(date)).then((fecha) {
              if (fecha >= 3) {
                showToast("La fecha alcanzó el límite de objetivos");
              } else {
                setState(() {
                  textFechaRealizar.text = parseFecha(date);
                  selectedDate = date;
                });
              }
            });
          },
          currentTime: DateTime.now(),
          locale: LocaleType.es);
    }
  }

  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white
    );
  }

  @override
  void initState() {
    super.initState();
    textTitulo.text = widget.itemObjetivo.titulo;
    textDescripcion.text = widget.itemObjetivo.descripcion;
    textPlanAccion.text = widget.itemObjetivo.planAccion;
    textFechaRealizar.text = widget.itemObjetivo.fechaRealizar;
    realizado = widget.itemObjetivo.realizado;

    if (!_fnFechaRealizar.hasListeners) {
      _fnFechaRealizar.addListener(() {
        abrirDatePickerHasta();
      });
    }
  }

  void editarObjetivo() async {
    if(textTitulo.text.length > 0){
      widget.itemObjetivo.titulo = textTitulo.text;
    }else{
      widget.itemObjetivo.titulo = "Sin título";
    }
    widget.itemObjetivo.descripcion = textDescripcion.text;
    widget.itemObjetivo.planAccion = textPlanAccion.text;
    widget.itemObjetivo.fechaRealizar = textFechaRealizar.text;
    widget.itemObjetivo.realizado = realizado;
    var db = new DatabaseHelper();
    int itemSavedId = await db.updateItem(widget.itemObjetivo);

    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  void volverPrincipal(_) {
    while (Navigator.canPop(_)) {
      Navigator.pop(_);
    }
  }

  void volver(context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => volver(context),
        ),
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
                    controller: textTitulo,
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
                    controller: textDescripcion,
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
                    controller: textPlanAccion,
                    decoration: const InputDecoration(
                      icon: const Icon(
                        Icons.pan_tool,
                        color: Colors.green,
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
                          controller: textFechaRealizar,
                          focusNode: _fnFechaRealizar,
                          autofocus: false,
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.calendar_today,
                                color: Colors.green),
                            hintText: 'Realizar el:',
                            labelText: 'Realizar el:',
                            filled: true,
                            border: UnderlineInputBorder(),
                          ),
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
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton(
                            hint: Text("¿Realizado?"),
                            value: realizado,
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
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 20.0),
                      child: new RaisedButton(
                        color: Colors.green,
                        elevation: 5,
                        child: const Text('Editar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        onPressed: () => editarObjetivo(),
                      )),
                ],
              ))),
    );
  }
}
