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
  final TextEditingController itemController = new TextEditingController();
  var db = new DatabaseHelper();
  final List<NoDoItem> itemList = <NoDoItem>[];

  @override
  void initState() {
    super.initState();
    _readItems();
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
      body: new ListView.builder(
        padding: new EdgeInsets.only(bottom: 72.0),
        itemCount: itemList.length,
        itemBuilder: (BuildContext context, int position) {
          return new Column(
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.only(right: 16.0),
                child: new ListTile(

                  onTap: () => _onItemTapped(position),

                  onLongPress: () =>
                      _showDialogUpdate(context, itemList[position], position),
                  title: itemList[position],
                ),
              ),
              new Divider()
            ],
          );
        },
      ),
    );
  }

  void _showItemDialog(_) {
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: itemController,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Añadir Objetivo",
              hintText: "Insertar Objetivo",
              icon: new Icon(Icons.note_add),
            ),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _handleSubmitItem(itemController.text);
              itemController.clear();
              Navigator.pop(context);
            },
            child: new Text("Guardar")),
        new FlatButton(
            onPressed: () => Navigator.pop(_), child: new Text("Cancelar"))
      ],
    );
    showDialog(context: _, builder: (_) => alert);
  }

  void _showDialogUpdate(_, NoDoItem item, int index) {
    itemController.text = item.itemName;
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: itemController,
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
              NoDoItem itemNew = new NoDoItem.fromMap({
                "item_name": itemController.text,
                "date_created": dateFormatted(),
                "id": item.id
              });
              _handleUpdateItem(index, itemNew);
              itemController.clear();
              Navigator.pop(context);
            },
            child: new Text("Actualizar")),
        new FlatButton(
            onPressed: () => Navigator.pop(_), child: new Text("Cancelar"))
      ],
    );
    showDialog(context: _, builder: (_) => alert);
  }

  void _handleSubmitItem(String text) async {
    itemController.clear();
    NoDoItem item = new NoDoItem(text, dateFormatted());
    int itemSavedId = await db.saveItem(item);
    print(itemSavedId);
    NoDoItem noDoItem = await db.getItem(itemSavedId);
    print(noDoItem.itemName);
    setState(() {
      itemList.add(noDoItem);
    });
  }

  void _readItems() async {
    List items = await db.getItems();
    items.forEach((noDoItem) {
      NoDoItem item = NoDoItem.fromMap(noDoItem);
      setState(() {
        itemList.add(item);
      });
    });
  }
  void _onItemTapped(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerObjetivo()));
  }

  void deleteItem(int id, int index) async {
    int rowsDeleted = await db.deleteItem(id);
    setState(() {
      itemList.removeAt(index);
    });
    print(rowsDeleted);
  }

  void _handleUpdateItem(int index, NoDoItem noDoItem) async {
    int rowsUpdated = await db.updateItem(noDoItem);
    setState(() {
      itemList.removeWhere((element) {
        itemList[index].itemName == noDoItem.itemName;
      });
      _readItems();
    });
    print(rowsUpdated);
  }
}
