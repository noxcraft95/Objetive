import 'package:flutter/material.dart';
import 'package:ThreeObjective/models/nodo_item.dart';
import 'package:ThreeObjective/utils/database_utils.dart';
import 'package:ThreeObjective/utils/date_formatter.dart';

class Historico extends StatefulWidget {
  @override
  _HistoricoState createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  //Principal
  final TextEditingController itemControllerFechaHasta =
      new TextEditingController();
  String realizado = '';

  final TextEditingController itemControllerFecha = new TextEditingController();
  var db = new DatabaseHelper();
  List<ItemObjetivo> itemList = <ItemObjetivo>[];

  //DatePicker
  final FocusNode _focusNodeFechaDesde = FocusNode();
  final FocusNode _focusNodeFechaHasta = FocusNode();

  //DatePickerDesde
  DateTime selectedDate = DateTime(DateTime.now().year);
  DateTime selectedDateHasta = DateTime.now();

  Future<Null> _selectorFechaDesde(BuildContext context) async {
    if (_focusNodeFechaDesde.hasFocus) {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(DateTime.now().year - 5),
          lastDate: DateTime(DateTime.now().year + 5));
      _focusNodeFechaDesde.unfocus();
      setState(() {
        if (picked != null) {
          selectedDate = picked;
          itemControllerFecha.text = parseFecha(selectedDate);
        }
      });
    }
  }

  //DatePickerBuscar
  Future<Null> _selectorFechaBuscar(BuildContext context) async {
    if (_focusNodeFechaHasta.hasFocus) {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDateHasta,
          firstDate: DateTime(DateTime
              .now()
              .year - 5),
          lastDate: DateTime(DateTime
              .now()
              .year + 5));
      _focusNodeFechaHasta.unfocus();
      if (picked != null)
        setState(() {
          //Cargamos la fecha actual en la de crear objetivo
          itemControllerFechaHasta.text = parseFecha(picked);
          selectedDateHasta = picked;
          _readItems();
        });
    }
  }

  @override
  void initState() {
    super.initState();
    itemControllerFecha.text = parseFecha(selectedDate);
    itemControllerFechaHasta.text = parseFecha(selectedDateHasta);
    _readItems();

    if (!_focusNodeFechaDesde.hasListeners) {
      _focusNodeFechaDesde.addListener(() {
        _selectorFechaDesde(context);
      });
    }
    if (!_focusNodeFechaHasta.hasListeners) {
      _focusNodeFechaHasta.addListener(() {
        _selectorFechaBuscar(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ItemObjetivo itemObjetivo = ModalRoute.of(context).settings.arguments;

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
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Padding( padding: EdgeInsets.all(20),
                  child:new TextFormField(
                  controller: itemControllerFecha,
                  autofocus: false,
                  focusNode: _focusNodeFechaDesde,
                  textAlign: TextAlign.center,
                  decoration: new InputDecoration(
                    fillColor: Colors.green[100],
                    filled: true,
                    contentPadding: EdgeInsets.all(10),
                    icon: new Icon(
                      Icons.calendar_today,
                      color: Colors.green,
                      size: 30,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
    ),
              ),
              Flexible(
                child: Padding( 
                  padding: EdgeInsets.all(20),
                  child: new TextFormField(
                  controller: itemControllerFechaHasta,
                  autofocus: false,
                  focusNode: _focusNodeFechaHasta,
                  textAlign: TextAlign.center,
                  decoration: new InputDecoration(
                    icon: new Icon(
                      Icons.calendar_today,
                      color: Colors.green,
                      size: 30,
                    ),
                    fillColor: Colors.green[100],
                    filled: true,
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          new SizedBox(
            height: 10,
          ),
          new Expanded(
            child: itemList.isNotEmpty
                ? new ListView.separated(
                    separatorBuilder: (context, index) => calculaColorDivider(itemList, index),
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
                            "No hay objetivos para este intervalo",
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
            onPressed: () => volverPrincipal(_),
            label: Text('Cancelar')),
        new FlatButton.icon(
            icon: Icon(Icons.do_not_disturb),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              deleteItem(item.id, index);
              volverPrincipal(_);
            },
            label: Text('Eliminar')),
      ],
    );
    showDialog(context: _, builder: (_) => alert);
  }

  Future<int> _getConteoFecha(String fecha) async {
    return await db.getConteoFecha(fecha);
  }

  void _readItems() async {
    itemList = await db.getItemsRangoFecha(
        parseFecha(selectedDate), parseFecha(selectedDateHasta));

    setState(() {});
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

  void volver(context) {
    Navigator.pop(context);
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
}
