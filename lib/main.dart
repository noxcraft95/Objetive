import 'package:flutter/material.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  int _selectedIndex = 0;
  static const TextStyle estiloBottonBar = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Hoy',
      style: estiloBottonBar,
    ),
    Text(
      'Index 1: Calendario',
      style: estiloBottonBar,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Objetivos de hoy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Objetive'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 1;
  List<bool> inputs = new List<bool>();
  @override
  void initState() {
    // TODO: Habrá que traerse de base de datos todos los eventos de "hoy"
    // TODO: y cargar los checkbox de "cumplido"

    setState(() {
      for(int i=0;i<3;i++){
        inputs.add(false);
      }
    });
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void ItemChange(bool val,int index){
    setState(() {
      inputs[index] = val;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Objetivos de hoy'),
      ),
      body: new ListView.builder(
          itemCount: inputs.length,
          itemBuilder: (BuildContext context, int index){
            return new Card(
              child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                  new CheckboxListTile(
                      value: inputs[index],
                      title: new Text('Objetivo ${index}'),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged:(bool val){ItemChange(val, index);}
                  )
                ],
                ),
              ),
            );

          }
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Tareas de hoy'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Calendario'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}