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
      home: const MyHomePage(title: 'Json'),
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
  String jsonMessage = "";
  final TextEditingController txt = TextEditingController();
  final TextEditingController textInput = TextEditingController();

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
              SizedBox(
                width: 255.0,
                height: 100,
                child: TextField(
                    controller: textInput,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Scrivi'),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: null,
                    onChanged: textChanged),
              ),
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
              SizedBox(
                width: 255.0,
                height: 100,
                child: TextField(
                  controller: txt,
                  readOnly: true,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Tempo'),
                ),
              )
            ]),
      ),
    );
  }

  // ignore: duplicate_ignore
  // ignore: non_constant_identifier_names
  Future<void> ScriviJson() async {
    final path = await GetPath();
    final file = File(path);

    try {
      String jsonString1 = await file.readAsString();

      final message = {
        'message': ((jsonMessage.isEmpty) ? "Benvenuto" : jsonMessage),
        'time': DateTime.now().add(const Duration(hours: 1)).toIso8601String()
      };

      final stringJsonMessage = jsonEncode(message);
      jsonString1 += stringJsonMessage;

      await file.writeAsString(jsonString1);

      txt.text += '\n${message["time"]}';

      if (mounted) {
        _showAlertSuccess("Il file è stato scritto con successo");
      }
    } catch (e) {
      final message = {
        'message': ((jsonMessage.isEmpty) ? "Benvenuto" : jsonMessage),
        'time': DateTime.now().add(const Duration(hours: 1)).toIso8601String()
      };

      final jsonString = jsonEncode(message);
      await file.writeAsString(jsonString);

      txt.text +=
          DateTime.now().add(const Duration(hours: 1)).toIso8601String();
      if (mounted) {
        _showAlertSuccess("Il file è stato scritto con successo");
      }
    }
  }

  void _showAlertSuccess(String s) {
    QuickAlert.show(context: context, text: s, type: QuickAlertType.success);
  }

  void _showAlertError(String s) {
    QuickAlert.show(context: context, text: s, type: QuickAlertType.error);
  }

  void _showAlertInfo(String s) {
    QuickAlert.show(context: context, text: s, type: QuickAlertType.info);
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
      _showAlertSuccess(JsonContent);
    } else {
      _showAlertError("Errore, il file non esiste");
    }
  }

  void CancellaJson() async {
    final path = await GetPath();
    final file = File(path);

    try {
      if (await file.exists()) {
        file.delete();
        _showAlertSuccess("File Json eliminato");
      } else {
        _showAlertInfo("Il file che si vuole eliminare non esiste");
      }
    } catch (e) {
      _showAlertError("Errore durante l'eliminazione del file ${e.toString()}");
    }

    txt.text = "";
    textInput.text = "";
  }

  void textChanged(String value) {
    jsonMessage = value;
  }
}
