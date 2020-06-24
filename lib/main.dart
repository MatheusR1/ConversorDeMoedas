import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance/quotations?key=94cf1cab';

void main() async {
  http.Response response = await http.get(request);

  runApp(MaterialApp(
    home: Home(), // aqui inicializo a home
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
  double dollar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // esse é a barra de cima.
      backgroundColor: Colors.black, // cor de dundo do app
      appBar: AppBar(
        // defino a barra
        title: Text(' \$ converso \$'),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 150.0, color: Colors.amber),
                        TextField()
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
