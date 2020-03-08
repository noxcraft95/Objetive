import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:objetive/models/nodo_item.dart';
import 'package:objetive/utils/database_utils.dart';
import 'package:objetive/utils/date_formatter.dart';
import 'package:objetive/ver_objetivo.dart';


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
  final TextEditingController itemControllerFecha =
  new TextEditingController();
  var db = new DatabaseHelper();
  final List<ItemObjetivo> itemList = <ItemObjetivo>[];

  //DatePicker
  final FocusNode _focusNodeFecha = FocusNode();
  final FocusNode _focusNodeFechaBuscar = FocusNode();

  //DatePickerCrear
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateBuscar = DateTime.now();

  Future<Null> _selectorFechaCrear(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 5));
    _focusNodeFecha.unfocus();
    Navigator.pop(context);
    _showItemDialog(context);
    setState(() {
      if (picked != null) {
        selectedDate = picked;
        itemControllerFecha.text = parseFecha(selectedDate);
      }
    });
  }

  //DatePickerBuscar
  Future<Null> _selectorFechaBuscar(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateBuscar,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 5));
    volverPrincipal(context);
    _focusNodeFechaBuscar.unfocus();
    if (picked != null)
      setState(() {
        //Cargamos la fecha actual en la de crear objetivo
        itemControllerFecha.text = parseFecha(picked);
        selectedDateBuscar = picked;
        //Actualizamos la fecha de busqueda a la elegida
        itemControllerFechaBusqueda.text = parseFecha(picked);
        _readItems();
      });
  }

  @override
  void initState() {
    super.initState();
    itemControllerFechaBusqueda.text = parseFecha(DateTime.now());
    _readItems();
    _focusNodeFecha.addListener(() {
      _selectorFechaCrear(context);
    });
    _focusNodeFechaBuscar.addListener(() {
      _selectorFechaBuscar(context);
    });
  }

  @override
  void dispose() {
    _focusNodeFecha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ItemObjetivo itemObjetivo = ModalRoute.of(context).settings.arguments;
    print("1111111111111111111111111111111111111pacoooooo");
    print(itemObjetivo);



    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: new AppBar(
        title: Text("Objetivos"),
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
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
                      final ItemObjetivo itemObjetivo = ModalRoute.of(context).settings.arguments;
                      print("1111111111111111111111111111111111111pacoooooo");
                      print(itemObjetivo);
                      if(itemObjetivo == "Sin Realizar"){
                      return new Column(

                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(right: 15, left: 15),
                            child: new Container(
                              decoration: BoxDecoration(

                                color: Colors.red,

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
                                onLongPress: () => _showDialogUpdate(
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
                      }else{
                        return new Column(

                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(right: 15, left: 15),
                              child: new Container(
                                decoration: BoxDecoration(

                                  color: Colors.green,

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
                                  onLongPress: () => _showDialogUpdate(
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

                      }
                    },
                  )
                : SingleChildScrollView(
                   child:Padding(
                   padding: EdgeInsets.only(right:50,left:50,bottom: 50),
                   child: Column(
                    children: <Widget>[
                      Text("No hay objetivos para este día",
                      style: TextStyle(height: 3, fontSize: 18,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                      Padding(
                        padding: EdgeInsets.only(right:50,left:50,bottom: 50),
                        child:(Image(image: AssetImage('images/noObjetivos.png'),
                        fit: BoxFit.fitHeight,
                        )
                        ),
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

  void volverPrincipal(_) {
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void botonVolverCreacion(_) {
    itemControllerObjetivo.clear();
    itemControllerDescripcion.clear();
    itemControllerFecha.clear();
    volverPrincipal(_);
  }

  void _showDialogUpdate(_, ItemObjetivo item, int index) {
    itemControllerObjetivo.text = item.titulo;
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: itemControllerObjetivo,
            autofocus: false,
            decoration: new InputDecoration(
              labelText: "Actualizar Objetivo",
              icon: new Icon(Icons.note_add),
            ),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              ItemObjetivo itemNew = new ItemObjetivo.fromMap({
                "item_name": itemControllerObjetivo.text,
                "date_created": dateFormatted(),
                "id": item.id
              });
              _handleUpdateItem(index, itemNew);
              itemControllerObjetivo.clear();
              Navigator.pop(context);
            },
            child: new Text("Actualizar")),
        new FlatButton(
            onPressed: () => Navigator.pop(_), child: new Text("Cancelar"))
      ],
    );
    showDialog(context: _, builder: (_) => alert);
  }

  Future<int> _getConteoFecha(String fecha) async {
    return await db.getConteoFecha(fecha);
  }

  void _handleSubmitItem(
      String textObjetivo, String textDescripcion, String textFecha) async {
    itemControllerObjetivo.clear();
    itemControllerDescripcion.clear();
    itemControllerFecha.clear();
    String realizado = "Sin realizar";
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
    setState(() {

    });
  }

  void _onItemTapped(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerObjetivo(),
            settings: RouteSettings(
              arguments: itemList[index],
            )));
  }

  void deleteItem(int id, int index) async {
    int rowsDeleted = await db.deleteItem(id);
    setState(() {
      itemList.removeAt(index);
    });
  }

  void _handleUpdateItem(int index, ItemObjetivo itemObjetivo) async {
    int rowsUpdated = await db.updateItem(itemObjetivo);
    setState(() {
      itemList.removeWhere((element) {
        itemList[index].titulo == itemObjetivo.titulo;
      });
      _readItems();
    });
  }
}
