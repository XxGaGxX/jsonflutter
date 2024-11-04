// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/quickalert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: ScriviJson,
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white)),
                child: const Text('Scrivi Json'),
              ),
              TextButton(
                onPressed: LeggiJson,
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white)),
                child: const Text("Leggi Json"),
              ),
              TextButton(
                onPressed: CancellaJson,
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white)),
                child: const Text("Cancella Json")),
              const SizedBox(
                width: 255.0,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Scrivi'
                  ),
                ),
              )
      
            ]),
      ),

    );
  }

  // ignore: non_constant_identifier_names
  Future<void> ScriviJson() async {
    final path = await GetPath();
    final file = File(path);
    final message = {
      'message': 'Benvenuto',
      'time': DateTime.now().add(const Duration(hours: 1)).toIso8601String()
    };
    final jsonString = jsonEncode(message);
    await file.writeAsString(jsonString);
    if (mounted) {
      _showAlert("Il file è stato scritto con successo",QuickAlertType.success);
    }
  }

  void _showAlert(String s, QuickAlertType t){
    QuickAlert.show(
          context: context,
          type: t,
          text: s);
  }

  Future<String> GetPath() async {
    final dir = await getApplicationCacheDirectory();
    return '${dir.path}/welcome_message.json';
  }

  void LeggiJson() async {
    final path = await GetPath();
    final file = File(path);

    if (await file.exists()) {
      final JsonContent = await file.readAsString();
      _showAlert(JsonContent,QuickAlertType.info);
    } else {
      _showAlert("Errore, il file non esiste",QuickAlertType.error);
    }
  }

  void CancellaJson() async {
    final path = await GetPath();
    final file = File(path);

    try{
      if(await file.exists()){
      file.delete();
      _showAlert("File Json eliminato", QuickAlertType.success);
    }
    }catch(e){
      _showAlert(e.toString(), QuickAlertType.error);
    }
    
  }
}
