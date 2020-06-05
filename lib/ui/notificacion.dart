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
    _obtenerEstado().then((value){
      setState(() {
        isSwitched = value;
      });
    });
    //Carga la hora seleccionada de las preferencias, 17:0:0 por defecto.
    _obtenerHora().then((value){
      setState(() {
        hora = value;
      });
    });


  }

  Future<bool>_obtenerEstado() async {
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
        appBar: new AppBar(
          title: new Text('Recordatorio'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new SizedBox(
                height: 30.0,
              ),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    print(isSwitched);
                    if(isSwitched){
                      //Activamos notificaciones
                      int h = int.parse(hora.split(":").elementAt(0));
                      int m = int.parse(hora.split(":").elementAt(1));
                      int s = int.parse(hora.split(":").elementAt(2));
                      DateTime date = DateTime(2020, 6, 4, h, m, s);
                      print("activamos notificaciones: $date");
                      scheuleAtParticularTime(
                          DateTime.fromMillisecondsSinceEpoch(
                              date.millisecondsSinceEpoch));

                    }else{
                      // Desactivar notificaciones
                      flutterLocalNotificationsPlugin.cancelAll();
                    }
                    _guardarHoraEstado();
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              new SizedBox(
                height: 30.0,
              ),
              new Text(
                '$hora'
              ),
              new SizedBox(
                height: 30.0,
              ),
              FlatButton(
                color: Colors.green,
                  onPressed: () {
                    DatePicker.showTimePicker(context, showTitleActions: true,
                        onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          print('confirm $date');
                          setState(() {
                            hora =  date.hour.toString()+':'+date.minute.toString()+':'+date.second.toString();
                            print(hora);
                          });
                          _guardarHoraEstado();
                         if(isSwitched){
                           scheuleAtParticularTime(
                               DateTime.fromMillisecondsSinceEpoch(
                                   date.millisecondsSinceEpoch));
                         }
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    'Selecciona la hora de recordatorio',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w900),
                  )),
            ],
          ),
        ),
      ),
    );
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
    flutterLocalNotificationsPlugin.showDailyAtTime(0, 'ThreeObjective',
        'Recuerda dedicarle un tiempo a tus objetivos.', time, platformChannelSpecifics);
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
