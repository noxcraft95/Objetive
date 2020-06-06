import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notificacion extends StatefulWidget {
  @override
  _NotificacionState createState() => _NotificacionState();
}

class _NotificacionState extends State<Notificacion> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isSwitched = false;
  String hora = "";

  @override
  initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    //Carga el estado de las preferencias. (true por defecto)
    _obtenerEstado().then((value) {
      setState(() {
        isSwitched = value;
      });
    });
    //Carga la hora seleccionada de las preferencias, 17:0:0 por defecto.
    _obtenerHora().then((value) {
      setState(() {
        hora = value;
      });
    });
  }

  Future<bool> _obtenerEstado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('estado') ?? true;
  }

  Future<String> _obtenerHora() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('horaAviso') ?? "17:0:0";
  }

  _guardarHoraEstado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('estado', isSwitched);
    await prefs.setString('horaAviso', hora);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: new AppBar(
          title: Text("Recordatorio"),
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
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'La aplicación le recordará diariamente que\n debe dedicarle un tiempo a sus objetivos:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontStyle: FontStyle.italic),
              ),
              new SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Recordatorio:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        print(isSwitched);
                        if (isSwitched) {
                          //Activamos notificaciones
                          int h = int.parse(hora.split(":").elementAt(0));
                          int m = int.parse(hora.split(":").elementAt(1));
                          int s = int.parse(hora.split(":").elementAt(2));
                          DateTime date = DateTime(2020, 6, 4, h, m, s);
                          print("activamos notificaciones: $date");
                          scheuleAtParticularTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  date.millisecondsSinceEpoch));
                        } else {
                          // Desactivar notificaciones
                          flutterLocalNotificationsPlugin.cancelAll();
                        }
                        _guardarHoraEstado();
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ],
              ),
              new SizedBox(
                height: 30.0,
              ),
              new Text(
                '$hora',
                style: TextStyle(height: 1, fontSize: 40),
              ),
              new SizedBox(
                height: 30.0,
              ),
              RaisedButton(
                  color: Colors.green,
                  elevation: 5,
                  padding: EdgeInsets.all(12),
                  child: const Text('Selecciona la hora de recordatorio',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  onPressed: () {
                    DatePicker.showTimePicker(context, showTitleActions: true,
                        onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      print('confirm $date');
                      setState(() {
                        hora = date.hour.toString() +
                            ':' +
                            date.minute.toString() +
                            ':' +
                            date.second.toString();
                        print(hora);
                      });
                      _guardarHoraEstado();
                      if (isSwitched) {
                        scheuleAtParticularTime(
                            DateTime.fromMillisecondsSinceEpoch(
                                date.millisecondsSinceEpoch));
                      }
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void volverPrincipal(_) {
    Navigator.pop(context);
  }

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
    flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'ThreeObjective',
        'Recuerda dedicarle un tiempo a tus objetivos.',
        time,
        platformChannelSpecifics);
    print('scheduled');
    Fluttertoast.showToast(
        msg:
            "Tus notificaciones fueron programadas: ${time.hour} : ${time.minute} : ${time.second}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        // also possible "TOP" and "CENTER"
        backgroundColor: Colors.grey,
        textColor: Colors.white);
  }
}
