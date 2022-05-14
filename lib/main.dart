import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

var request = Uri.https('api.hgbrasil.com','/finance');
void main()async{
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,)
          ),
          focusedBorder: OutlineInputBorder(
             borderSide: BorderSide(
            color: Colors.amber,

          )
      ),
      hintStyle: TextStyle(color: Colors.amber)
    ),
  ),
  ));
}

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  
  double dolar = 0 ;
  double euro = 0 ;

  void _realChanged(String texto){
    double real = double.parse(texto);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String texto){
    double _dolar = double.parse(texto);
    realController.text = (_dolar * dolar).toStringAsFixed(2);
    euroController.text = (_dolar*dolar/euro).toStringAsFixed(2);
  }

  void _euroChanged(String texto){
    double _euro = double.parse(texto);
    realController.text = (_euro*euro).toStringAsFixed(2);
    dolarController.text = (_euro * euro/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
       title: Text('Conversor de Moedas'),
      backgroundColor: Colors.amber,
      centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: pegarDados(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
              default:
              if (snapshot.hasError){
                return Center(
                child: Text(
                  "Erro ao carregar os dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
              }else{
                dolar = snapshot.data!['results']['currencies']['USD']['buy'];
                euro = snapshot.data!['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.monetization_on,
                      size: 150,
                      color:Colors.amber
                      ),

                    //  construirTextField('Reais', 'R\$',realController,_realChanged),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: _realChanged,
                      controller: realController,
                        decoration: InputDecoration(
                          labelText: 'Reais',
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: 'R\$',
                        ),
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25,
                        ),
                      ),
                      Divider(),
                    //  construirTextField("Dolares", 'US\$',dolarController, _dolarChanged ),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: _dolarChanged,
                      controller: dolarController,
                        decoration: InputDecoration(
                          labelText: 'Dolares',
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: 'US\$',
                        ),
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25,
                        ),
                      ),
                      Divider(),
                    //  construirTextField('Euros', '£',euroController, _euroChanged),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: _euroChanged,
                      controller: euroController,
                        decoration: InputDecoration(
                          labelText: 'Euros',
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: '£',
                        ),
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25,
                        ),
                      ),
                    
                    ],
                  ),
                  );
              }
          }
        },
        ),
    );
    
  }
}

Widget construirTextField(String text, String prefixo){
  return TextField(
                        // keyboardType: TextInputType.number,
                        // onChanged: _euroChanged,
                        // controller: euroController,
                        decoration: InputDecoration(
                          labelText: text,
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: prefixo,
                        ),
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25,
                        ),
                      );
}
Future<Map> pegarDados() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}