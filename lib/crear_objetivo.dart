import 'package:flutter/material.dart';

class CrearObjetivo extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Crear Objetivo'),
          ),
          body: new StepperBody(),
        ));
  }
}
class MyData {
  String objetivo = '';
  String descripcion = '';
  String fecha = '';
}

class StepperBody extends StatefulWidget {
  @override
  _StepperBodyState createState() => new _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  int currStep = 0;
  static var _focusNode = new FocusNode();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static MyData data = new MyData();


   DateTime selectedDate = DateTime.now();

   Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  @override
  void dispose() {
    //_focusNode.dispose();  //Error al abrir crear objetivo dos veces, se comenta.
    super.dispose();
  }

  List<Step> steps = [
    new Step(
        title: const Text('Objetivo'),
        //subtitle: const Text('Enter your name'),
        isActive: true,
        //state: StepState.error,
        state: StepState.indexed,
        content: new TextFormField(
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
          autocorrect: false,
          onSaved: (String value) {
            data.objetivo = value;
          },
          maxLines: 1,
          //initialValue: 'Aseem Wangoo',
          validator: (value) {
            if (value.isEmpty || value.length < 1) {
              return 'Introduzca el objetivo';
            }
          },
          decoration: new InputDecoration(
              labelText: 'Nombre del objetivo',
              hintText: 'Nombre del objetivo',
              //filled: true,
              icon: const Icon(Icons.forward),
              labelStyle:
              new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )),
    new Step(
        title: const Text('Descripción'),
        //subtitle: const Text('Subtitle'),
        isActive: true,
        //state: StepState.editing,
        state: StepState.indexed,
        content: new TextFormField(
          keyboardType: TextInputType.text,
          autocorrect: false,
          validator: (value) {
            if (value.isEmpty || value.length < 1) {
              return 'Introduzca una descripción';
            }
          },
          onSaved: (String value) {
            data.descripcion = value;
          },
          maxLines: 1,
          decoration: new InputDecoration(
              labelText: 'Descripción del objetivo',
              hintText: 'Introduzca una descripción',
              icon: const Icon(Icons.add_comment),
              labelStyle:
              new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )),
    new Step(
        title: const Text('Fecha del objetivo'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: StepState.indexed,
        // state: StepState.disabled,
        content:
        new TextFormField(
          keyboardType: TextInputType.datetime,
          autocorrect: false,
          validator: (value) {
            if (value.isEmpty) {
              return 'Seleccione una fecha';
            }
          },
          onSaved: (String value) {
            data.fecha = value;
          },

          maxLines: 1,
          decoration: new InputDecoration(
              labelText: 'Selecciona una fecha',
              hintText: 'Fecha del objetivo',
              icon: const Icon(Icons.date_range),

              labelStyle:
              new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )
    ),

    // new Step(
    //     title: const Text('Fifth Step'),
    //     subtitle: const Text('Subtitle'),
    //     isActive: true,
    //     state: StepState.complete,
    //     content: const Text('Enjoy Step Fifth'))
  ];

  @override
  Widget build(BuildContext context) {
    void showSnackBarMessage(String message,
        [MaterialColor color = Colors.red]) {
      Scaffold
          .of(context)
          .showSnackBar(new SnackBar(content: new Text(message)));
    }

    void _submitDetails() {
      final FormState formState = _formKey.currentState;

      if (!formState.validate()) {
        showSnackBarMessage('Rellene todos los campos');
      } else {
        formState.save();
        print("Objetivo: ${data.objetivo}");
        print("Descripcion: ${data.descripcion}");
        print("Fecha: ${data.fecha}");

        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Detalles"),
              //content: new Text("Hello World"),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text("Objetivo : " + data.objetivo),
                    new Text("Descripción : " + data.descripcion),
                    new Text("Fecha a realizar : " + data.fecha),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
      }
    }

    return new Container(
        child: new Form(
          key: _formKey,
          child: new ListView(children: <Widget>[
            new Stepper(
              controlsBuilder:
                  (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: onStepContinue,
                      color: Colors.green,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.blueAccent,
                      child: const Text('Continuar'),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    FlatButton(
                      onPressed: onStepCancel,
                      color: Colors.grey,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.blueAccent,
                      child: const Text('Volver'),
                    ),
                  ],
                );
              },
              steps: steps,
              type: StepperType.vertical,
              currentStep: this.currStep,
              onStepContinue: () {
                setState(() {
                  if (currStep < steps.length - 1) {
                    currStep = currStep + 1;
                  } else {
                    currStep = 0;
                  }
                  // else {
                  // Scaffold
                  //     .of(context)
                  //     .showSnackBar(new SnackBar(content: new Text('$currStep')));

                  // if (currStep == 1) {
                  //   print('First Step');
                  //   print('object' + FocusScope.of(context).toStringDeep());
                  // }

                  // }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (currStep > 0) {
                    currStep = currStep - 1;
                  } else {
                    currStep = 0;
                  }
                });
              },
              onStepTapped: (step) {
                setState(() {
                  currStep = step;
                });
              },
            ),
            new RaisedButton(
              child: new Text(
                'Guardar objetivo',
                style: new TextStyle(color: Colors.white),
              ),
              onPressed: _submitDetails,
              color: Colors.blue,
            ),
          ]),
        ));
  }
}


