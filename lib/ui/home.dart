import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ThreeObjective/models/nodo_item.dart';
import 'package:ThreeObjective/utils/database_utils.dart';
import 'package:ThreeObjective/utils/date_formatter.dart';
import 'package:ThreeObjective/ver_objetivo.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Principal
  final TextEditingController itemControllerFechaBusqueda =
      new TextEditingController();
  String realizado = '';

  //Alert Dialog Crear Objetivo
  final TextEditingController itemControllerObjetivo =
      new TextEditingController();
  final TextEditingController itemControllerDescripcion =
      new TextEditingController();
  final TextEditingController itemControllerFecha = new TextEditingController();
  var db = new DatabaseHelper();
  final List<ItemObjetivo> itemList = <ItemObjetivo>[];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  //DatePicker
  final FocusNode _focusNodeFecha = FocusNode();
  final FocusNode _focusNodeFechaBuscar = FocusNode();

  //DatePickerCrear
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateBuscar = DateTime.now();

  Future scheuleAtParticularTime(DateTime timee) async {
    var time = Time(timee.hour, timee.minute, timee.second);
    print(time.toString());
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.showDailyAtTime(0, 'ThreeObjective',
        'Recuerda dedicarle un tiempo a tus objetivos.', time, platformChannelSpecifics);
  }

  Future<String>_obtenerEstado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String contieneDatosPref = prefs.getBool('estado').toString() ?? null;
    return contieneDatosPref;
  }

  @override
  void initState() {
    super.initState();
    itemControllerFechaBusqueda.text = parseFecha(DateTime.now());
    _readItems();

    if (!_focusNodeFecha.hasListeners) {
      _focusNodeFecha.addListener(() {
        //_selectorFechaCrear(context);
        abrirDatePickerCrear();
      });
    }
    if (!_focusNodeFechaBuscar.hasListeners) {
      _focusNodeFechaBuscar.addListener(() {
        //_selectorFechaBuscar(context);
        abrirDatePickerBuscar();
      });
    }

    //Comprobamos si es la primera vez que se hace las notificaciones para activarlas por defecto
    _obtenerEstado().then((value){
        if((value == null || value == "null")){
          var initializationSettingsAndroid =
          new AndroidInitializationSettings('@mipmap/ic_launcher');
          var initializationSettingsIOS = new IOSInitializationSettings();
          var initializationSettings = new InitializationSettings(
              initializationSettingsAndroid, initializationSettingsIOS);

          flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
          flutterLocalNotificationsPlugin.initialize(initializationSettings);
          //Se establece las 17:0:0 por defecto.
          DateTime date = DateTime(2020, 6, 4, 17, 0, 0);
          print("activamos notificaciones por primera instancia: $date");
          scheuleAtParticularTime(
              DateTime.fromMillisecondsSinceEpoch(
                  date.millisecondsSinceEpoch));

        }
      });
}


  void abrirDatePickerBuscar(){
    if(_focusNodeFechaBuscar.hasFocus){
      _focusNodeFechaBuscar.unfocus();
    DatePicker.showDatePicker(context, showTitleActions: true,
        onChanged: (date) {
          print('change $date');
        }, onConfirm: (date) {
          print('confirm $date');
          setState(() {
            //Cargamos la fecha actual en la de crear objetivo
            itemControllerFecha.text = parseFecha(date);
            selectedDateBuscar = date;
            //Actualizamos la fecha de busqueda a la elegida
            itemControllerFechaBusqueda.text = parseFecha(date);
            _readItems();
          });
        }, currentTime: DateTime.now(), locale: LocaleType.es);
    }
  }

  void abrirDatePickerCrear(){
    if(_focusNodeFecha.hasFocus) {
      _focusNodeFecha.unfocus();
      DatePicker.showDatePicker(context, showTitleActions: true,
          onChanged: (date) {
            print('change $date');
          },
          onConfirm: (date) {
            print('confirm $date');
            setState(() {
                selectedDate = date;
                itemControllerFecha.text = parseFecha(selectedDate);
             });;
          },
          currentTime: DateTime.now(),
          locale: LocaleType.es);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ItemObjetivo itemObjetivo = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: new AppBar(


        title: Text("Objetivos"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          // action button
            IconButton(
              icon: new Icon(Icons.date_range,color: Colors.green,size: 36,),
              onPressed: () {
                Navigator.pushNamed(context, '/historico');
              },
              padding: EdgeInsets.only(right: 20),
            ),
          IconButton(
            icon: new Icon(Icons.notifications,color: Colors.orange,size: 36,),
            onPressed: () {
              Navigator.pushNamed(context, '/notificacion');
            },
            padding: EdgeInsets.only(right: 60),
          ),
        ],


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
        centerTitle: true,
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => _showItemDialog(context),
        child: new Icon(Icons.add),
      ),
      body: new Column(
        children: <Widget>[
          new Column(children: <Widget>[
            new Padding(
                padding: EdgeInsets.all(20),
                child: new TextFormField(
                  controller: itemControllerFechaBusqueda,
                  autofocus: false,
                  focusNode: _focusNodeFechaBuscar,
                  textAlign: TextAlign.center,
                  decoration: new InputDecoration(
                    fillColor: Colors.green[100],
                    filled: true,
                    contentPadding: EdgeInsets.all(10),
                    icon: new Icon(
                      Icons.search,
                      color: Colors.green,
                      size: 30,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                )),
          ]),
          new SizedBox(
            height: 10,
          ),
          new Expanded(
            child: itemList.isNotEmpty
                ? new ListView.builder(
                    padding: new EdgeInsets.only(bottom: 72.0),
                    itemCount: itemList.length,
                    itemBuilder: (BuildContext context, int position) {
                      final ItemObjetivo itemObjetivo = itemList[position];
                      return new Column(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(right: 15, left: 15),
                            child: new Container(
                              decoration: BoxDecoration(
                                color: colorFondo(itemObjetivo.realizado.toLowerCase()),

                                border: Border.all(
                                    color: Colors.white,
                                    width: 0,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                      spreadRadius: 0)
                                ],
                              ),
                              padding: new EdgeInsets.only(right: 16.0),
                              child: new ListTile(
                                onTap: () => _onItemTapped(position),
                                onLongPress: () => _showDialogBorrar(
                                    context, itemList[position], position),
                                title: itemList[position],
                              ),
                            ),
                          ),
                          new Divider(
                            color: Colors.transparent,
                          )
                        ],
                      );
                    },
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(right: 50, left: 50, bottom: 50),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "No hay objetivos para este día",
                            style: TextStyle(
                                height: 3,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 50, left: 50, bottom: 50),
                            child: (Image(
                              image: AssetImage('images/noObjetivos.png'),
                              fit: BoxFit.fitHeight,
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showItemDialog(_) {
    final _formKey = GlobalKey<FormState>();
    String labelTextFecha = "Añadir Fecha";
    var alert = new AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new TextFormField(
                controller: itemControllerObjetivo,
                autofocus: false,
                maxLength: 25,
                minLines: 1,
                maxLines: 2,
                decoration: new InputDecoration(
                  labelText: "Añadir Objetivo",
                  hintText: "Insertar Objetivo",
                  icon: new Icon(Icons.title),
                ),
              ),
              new TextFormField(
                controller: itemControllerDescripcion,
                autofocus: false,
                maxLength: 50,
                minLines: 1,
                maxLines: 2,
                decoration: new InputDecoration(
                  labelText: "Descripción",
                  hintText: "Insertar Descripción",
                  icon: new Icon(Icons.description),
                ),
              ),
              new TextFormField(
                controller: itemControllerFecha,
                autofocus: false,
                focusNode: _focusNodeFecha,
                decoration: new InputDecoration(
                  labelText: labelTextFecha,
                  icon: new Icon(Icons.calendar_today),
                ),
                validator: (texto) {
                  if (texto.isEmpty) {
                    return "Selecciona una fecha";
                  } else {
                    if (texto == "_") {
                      itemControllerFecha.text = "";
                      return "Alcanzado máximo de objetivos";
                    }
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () => botonVolverCreacion(_),
            child: new Text("Cancelar")),
        new FlatButton(
            onPressed: () {
              _getConteoFecha(itemControllerFecha.text).then((fecha) {
                if (fecha >= 3) {
                  itemControllerFecha.text = "_";
                }
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  if (itemControllerObjetivo.text == "") {
                    itemControllerObjetivo.text = "Sin título";
                  }

                  _handleSubmitItem(itemControllerObjetivo.text,
                      itemControllerDescripcion.text, itemControllerFecha.text);
                  itemControllerObjetivo.clear();
                  itemControllerDescripcion.clear();
                  itemControllerFecha.clear();

                  volverPrincipal(context);
                }
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              });
            },
            child: new Text("Guardar"))
      ],
    );
    showDialog(context: _, builder: (_) => alert);
  }

  void _showDialogBorrar(_, ItemObjetivo item, index) {
    final _formKey = GlobalKey<FormState>();
    String labelTextFecha = "Añadir Fecha";
    var alert = new AlertDialog(
      content: Container(
        child:
            Text("¿Desea eliminar el objetivo?", textAlign: TextAlign.center),
      ),
      actions: <Widget>[
        new FlatButton.icon(
            icon: Icon(Icons.arrow_back),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () => botonVolverCreacion(_),
            label: Text('Cancelar')),
        new FlatButton.icon(
            icon: Icon(Icons.do_not_disturb),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              deleteItem(item.id, index);
              botonVolverCreacion(_);
            },
            label: Text('Eliminar')),
      ],
    );
    showDialog(context: _, builder: (_) => alert);
  }

  void volverPrincipal(_) {
      Navigator.pop(context);
  }


  void botonVolverCreacion(_) {
    itemControllerObjetivo.clear();
    itemControllerDescripcion.clear();
    itemControllerFecha.clear();
    volverPrincipal(_);
  }

  Future<int> _getConteoFecha(String fecha) async {
    return await db.getConteoFecha(fecha);
  }

  void _handleSubmitItem(
      String textObjetivo, String textDescripcion, String textFecha) async {
    itemControllerObjetivo.clear();
    itemControllerDescripcion.clear();
    itemControllerFecha.clear();
    String realizado = "";
    ItemObjetivo item = new ItemObjetivo(textObjetivo, textDescripcion,
        parseFecha(DateTime.now()), textFecha, realizado);
    int itemSavedId = await db.saveItem(item);
    ItemObjetivo itemObjetivo = await db.getItem(itemSavedId);
    setState(() {
      _readItems();
    });
  }

  void _readItems() async {
    List items = await db.getItemsFecha(parseFecha(selectedDateBuscar));
    itemList.clear();

    items.forEach((noDoItem) {
      ItemObjetivo item = ItemObjetivo.fromMap(noDoItem);
      itemList.add(item);
    });
    setState(() {});
  }

  Color colorFondo(String realizacion) {
    Color color;
    switch (realizacion) {
      case "realizado":
        color = Colors.green[500];
        break;
      case "sin realizar":
        color = Colors.red[500];
        break;
      case "":
        color = Colors.white;
        break;
    }
    return color;
  }

  void _onItemTapped(int index) {
    Navigator.pushNamed(context, '/verObjetivo', arguments: itemList[index])
        .then((value) {
      setState(() {
        _readItems();
      });
    });
  }



  void deleteItem(int id, int index) async {
    int rowsDeleted = await db.deleteItem(id);
    setState(() {
      itemList.removeAt(index);
    });
  }

}
