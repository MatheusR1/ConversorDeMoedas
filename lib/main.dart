import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance/quotations?key=94cf1cab';

void main() async {
  http.Response response = await http.get(request);

  runApp(MaterialApp(
    home: Home(), // aqui inicializo a home
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body)["results"]["currencies"];
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _realcontroller = TextEditingController();
  final _dollarcontroller = TextEditingController();
  final _eurocontroller = TextEditingController();

  double dollar;
  double euro;

  void _clearAll() {
    _realcontroller.text = "";
    _dollarcontroller.text = "";
    _eurocontroller.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    dynamic real = double.parse(text);
    _dollarcontroller.text= (real / dollar).toStringAsPrecision(4);
    _eurocontroller.text = (real / euro).toStringAsPrecision(4);
  }

  void _dollarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dollar = double.parse(text);
    _realcontroller.text = (dollar * this.dollar).toStringAsPrecision(4);
    _eurocontroller.text = (dollar * this.dollar / euro).toStringAsPrecision(4);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    _realcontroller.text = (euro * this.euro).toStringAsPrecision(4);
    _eurocontroller.text = (euro * this.euro / dollar).toStringAsPrecision(4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // esse é a barra de cima.
      backgroundColor: Colors.black, // cor de dundo do app
      appBar: AppBar(
        // defino a barra
        title: Text(' \$ Conversor \$'),
        backgroundColor: Colors.amber, // defino a cor da barra
        centerTitle: true, // aqui centralizo o titulo
      ),
      body: FutureBuilder(
        future: getData(), // os dados chegam do furuto .
        builder: (BuildContext context, AsyncSnapshot snapshot) {
//          Widget child;
//
//          if(snapshot.connectionState!= ConnectionState.done){
//              child= CircularProgressIndicator();
//
////                dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
//          }else{
//
//              if (snapshot.hasData){
//                print(snapshot.data);
//
//                child=Text(' recebido ');
//
//              }else{
//                child=Text('erro!');
//              }
//
//          }
//
//          return child;

          //  o snap é quem faz a conecção , pare v estado da conecção

          switch (snapshot.connectionState) {
            case (ConnectionState.none):
              return CircularProgressIndicator(); // tratando conexao igual a none
            case (ConnectionState.waiting):
              // tratando espera de dados de carregamento
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                // tratando erros na coleta de dados com
                // hasError
                return Center(
                    child: Text(
                  'erro ao carregar dados :(',
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                ));
              } else {
                if (snapshot.hasData) {
                  dollar = snapshot.data["USD"]["buy"];
                  euro = snapshot.data["EUR"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(12.00),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.monetization_on,
                            size: 150.0, color: Colors.amber),
                        builderTextFielde(
                            'Reais', 'R\$', _realcontroller, _realChanged),
                        Divider(),
                        builderTextFielde('Dólares', 'US\$', _dollarcontroller,
                            _dollarChanged),
                        Divider(),
                        builderTextFielde(
                            'Euros', '€', _eurocontroller, _euroChanged)
                      ],
                    ),
                  );
                } else {
                  return Text('Problemas tecnicos,tente mais tarde!');
                }
              }
          }
        },
      ),
    );
  }
}

Widget builderTextFielde(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber, fontSize: 20.0),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
