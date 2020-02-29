import 'package:flutter/material.dart';
import 'package:objetive/utils/database_utils.dart';


class ItemObjetivo extends StatelessWidget {
  static const String keyTitulo = "titulo";
  static const String keyDescripcion = "descripcion";
  static const String keyPlanAccion = "plan_accion";
  static const String keyFechaCreacion = "fecha_creacion";
  static const String keyFechaRealizar = "fecha_realizar";
  static const String keyRealizado = "realizado";
  static const String keyId = "id";

  String _titulo;
  String _descripcion;
  String _planAccion;
  String _fechaCreacion;
  String _fechaRealizar;
  int _id;
  String _realizado;

  ItemObjetivo(this._titulo,this._descripcion ,this._fechaCreacion, this._fechaRealizar, this._realizado);

  ItemObjetivo.map(dynamic obj) {
    this._titulo = obj[keyTitulo];
    this._descripcion = obj[keyDescripcion];
    this._planAccion = obj[keyPlanAccion];
    this._fechaCreacion = obj[keyFechaCreacion];
    this._fechaRealizar = obj[keyFechaRealizar];
    this._id = obj[keyId];
    this._realizado = obj[keyRealizado];
  }

  String get titulo => _titulo;
  String get descripcion => _descripcion;
  String get planAccion => _planAccion;
  String get fechaCreacion => _fechaCreacion;
  String get fechaRealizar => _fechaRealizar;
  int get id => _id;
  String get realizado => _realizado;

  Map<String, dynamic> toMap() {
    Map map = new Map<String, dynamic>();
    map[keyTitulo] = _titulo;
    map[keyDescripcion] = _descripcion;
    map[keyPlanAccion] = _planAccion ;
    map[keyFechaCreacion] = _fechaCreacion;
    map[keyFechaRealizar] = _fechaRealizar ;
    if (_id != null) {
      map[keyId] = _id;
    }
    map[keyRealizado] = _realizado ;
    return map;
  }

  ItemObjetivo.fromMap(Map<String, dynamic> map) {
    this._titulo = map[keyTitulo];
    this._descripcion = map[keyDescripcion];
    this._planAccion = map[keyPlanAccion];
    this._fechaCreacion = map[keyFechaCreacion];
    this._fechaRealizar = map[keyFechaRealizar];
    this._id = map[keyId];
    this._realizado = map[keyRealizado];
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
          _titulo[0].toUpperCase(),
          style: new TextStyle(color: Colors.white),
        ),
      ),
      title: new Text(_titulo),
      subtitle: new Text(_fechaRealizar),
      trailing: new Text(_realizado),
    );
  }

  void deleteItem(int id) async {
    DatabaseHelper db = new DatabaseHelper();
    int rowsDeleted = await db.deleteItem(id);
    print(rowsDeleted);
  }
}
