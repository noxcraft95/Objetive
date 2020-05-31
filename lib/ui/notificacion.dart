import 'package:flutter/material.dart';
import 'package:ThreeObjective/models/nodo_item.dart';
import 'package:ThreeObjective/utils/database_utils.dart';

class Notificacion extends StatefulWidget {
  @override
  _NotificacionState createState() => _NotificacionState();
}

class _NotificacionState extends State<Notificacion> {
  //Principal
  var db = new DatabaseHelper();


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: new AppBar(
        title: Text("Histórico"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => volverPrincipal(context),
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
        centerTitle: true,
      ),
      body: new Column(
      ),
    );
  }

  void volverPrincipal(_) {
    Navigator.pop(context);
  }

  Divider calculaColorDivider(List<ItemObjetivo> lista, index){

    Color color =  Colors.transparent;
    if(index + 1 < lista.length) {
      if (lista[index].fechaRealizar != lista[index + 1].fechaRealizar) {
        color = Colors.brown;
      } else {
        color = Colors.transparent;
      }
    }
    Divider divider = new Divider(color: color);
    return divider;
  }




  void volver(context) {
    Navigator.pop(context);
  }


}
