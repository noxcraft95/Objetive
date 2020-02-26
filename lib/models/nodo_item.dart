import 'package:flutter/material.dart';
import 'package:objetive/utils/database_utils.dart';
import 'package:objetive/utils/date_formatter.dart';


class ItemObjetivo extends StatelessWidget {
  static const String keyTitulo = "titulo";
  static const String keyDescripcion = "descripcion";
  static const String keyPlanAccion = "plan_accion";
  static const String keyFechaCreacion = "fecha_creacion";
  static const String keyFechaRealizar = "fecha_Realizar";
  static const String keyRealizado = "realizado";
  static const String keyId = "id";

  String _titulo;
  String _descripcion;
  String _planAccion;
  String _fechaCreacion;
  String _fechaRealizar;
  int _id;
  bool realizado;

  ItemObjetivo(this._titulo, this._fechaCreacion);

  ItemObjetivo.map(dynamic obj) {
    this._titulo = obj[keyTitulo];
    this._fechaCreacion = obj[keyFechaCreacion];
    this._id = obj[keyId];
  }

  String get titulo => _titulo;
  String get fechaCreacion => _fechaCreacion;
  int get id => _id;

  Map<String, dynamic> toMap() {
    Map map = new Map<String, dynamic>();
    map[keyTitulo] = _titulo;
    map[keyFechaCreacion] = _fechaCreacion;
    if (_id != null) {
      map[keyId] = _id;
    }
    return map;
  }

  ItemObjetivo.fromMap(Map<String, dynamic> map) {
    this._titulo = map[keyTitulo];
    this._fechaCreacion = map[keyFechaCreacion];
    this._id = map[keyId];
  }

  @override
  Widget build(BuildContext context) {
    /*return new Container(
      padding: new EdgeInsets.all(8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            _itemName,
            style: new TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: new Text(
              "Created on $_dateCreated",
              style: new TextStyle(fontSize: 14.0,
                  fontStyle: FontStyle.italic),
            ),
          )
        ],
      ),
    );*/
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: Colors.orange,
        child: new Text(
          _titulo[0],
          style: new TextStyle(color: Colors.white),
        ),
      ),
      title: new Text(_titulo),
      subtitle: new Text(_fechaCreacion),

    );
  }

  void deleteItem(int id) async {
    DatabaseHelper db = new DatabaseHelper();
    int rowsDeleted = await db.deleteItem(id);
    print(rowsDeleted);
  }
}
