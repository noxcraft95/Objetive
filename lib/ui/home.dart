import 'package:flutter/material.dart';
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
  final TextEditingController itemControllerFechaBuqueda =
      new TextEditingController();

  //Alert Dialog Crear Objetivo
  final TextEditingController itemControllerObjetivo =
      new TextEditingController();
  final TextEditingController itemControllerDescripcion =
      new TextEditingController();
  final TextEditingController itemControllerFecha = new TextEditingController();
  var db = new DatabaseHelper();
  final List<ItemObjetivo> itemList = <ItemObjetivo>[];

  //DatePicker
  final FocusNode _focusNodeFecha = FocusNode();
  final FocusNode _focusNodeFechaBuscar = FocusNode();

  DateTime selectedDate = DateTime.now();
  Future<Null> _selectorFechaCrear(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year+5));
    _focusNodeFecha.unfocus();
    Navigator.pop(context);
    _showItemDialog(context);
    if (picked != null && picked != selectedDate)
      setState(() {
        itemControllerFecha.text = parseFecha(picked);
        selectedDate = picked;
      });
  }

  Future<Null> _selectorFechaBuscar(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year+5));
    volverPrincipal(context);
    _focusNodeFechaBuscar.unfocus();
    if (picked != null && picked != selectedDate)
      setState(() {
        itemControllerFechaBuqueda.text = parseFecha(picked);
      });
  }

  @override
  void initState() {
    super.initState();
    itemControllerFechaBuqueda.text = parseFecha(DateTime.now());
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: new AppBar(
        title: Text("Objetivos"),
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
              child:
            new TextFormField(
              controller: itemControllerFechaBuqueda,
              autofocus: false,
              focusNode: _focusNodeFechaBuscar,
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.all(10),
                icon: new Icon(Icons.search,color: Colors.green,size: 28,),
                border: OutlineInputBorder(),
              ),
            )),
          ]),
          new SizedBox(
            height: 12,
          ),
          new Expanded(
            child: new ListView.builder(
              padding: new EdgeInsets.only(bottom: 72.0),
              itemCount: itemList.length,
              itemBuilder: (BuildContext context, int position) {
                return new Column(
                  children: <Widget>[
                    new Container(
                      padding: new EdgeInsets.only(right: 16.0),
                      child: new ListTile(
                        onTap: () => _onItemTapped(position),
                        onLongPress: () => _showDialogUpdate(
                            context, itemList[position], position),
                        title: itemList[position],
                      ),
                    ),
                    new Divider()
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _showItemDialog(_) {
    var alert = new AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new TextFormField(
              controller: itemControllerObjetivo,
              autofocus: true,
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
              autofocus: true,
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
                labelText: "Añadir Fecha",
                icon: new Icon(Icons.calendar_today),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              if (itemControllerObjetivo.text == "") {
                itemControllerObjetivo.text = "Sin título";
              }

              _handleSubmitItem(itemControllerObjetivo.text,
                  itemControllerDescripcion.text, itemControllerFecha.text);
              itemControllerObjetivo.clear();
              itemControllerDescripcion.clear();
              itemControllerFecha.clear();

              volverPrincipal(context);
            },
            child: new Text("Guardar")),
        new FlatButton(
            onPressed: () => botonVolverCreacion(_),
            child: new Text("Cancelar"))
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
            autofocus: true,
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

  void _handleSubmitItem(
      String textObjetivo, String textDescripcion, String textFecha) async {
    itemControllerObjetivo.clear();
    itemControllerDescripcion.clear();
    itemControllerFecha.clear();
    String realizado = "Sin realizar";
    ItemObjetivo item =
        new ItemObjetivo(textObjetivo,textDescripcion,parseFecha(DateTime.now()), parseFecha(selectedDate), realizado);
    int itemSavedId = await db.saveItem(item);
    print(itemSavedId);
    ItemObjetivo itemObjetivo = await db.getItem(itemSavedId);
    print(itemObjetivo.titulo);
    setState(() {
      itemList.add(itemObjetivo);
    });
  }

  void _readItems() async {
    List items = await db.getItems();
    items.forEach((noDoItem) {
      ItemObjetivo item = ItemObjetivo.fromMap(noDoItem);
      setState(() {
        itemList.add(item);
      });
    });
  }

  void _onItemTapped(int index) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => VerObjetivo()));
  }

  void deleteItem(int id, int index) async {
    int rowsDeleted = await db.deleteItem(id);
    setState(() {
      itemList.removeAt(index);
    });
    print(rowsDeleted);
  }

  void _handleUpdateItem(int index, ItemObjetivo itemObjetivo) async {
    int rowsUpdated = await db.updateItem(itemObjetivo);
    setState(() {
      itemList.removeWhere((element) {
        itemList[index].titulo == itemObjetivo.titulo;
      });
      _readItems();
    });
    print(rowsUpdated);
  }
}
