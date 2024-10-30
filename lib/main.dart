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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
                child: Text('Scrivi Json'),
              ),
              TextButton(
                onPressed: LeggiJson,
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white)),
                child: Text("Leggi Json"),
              )
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> ScriviJson() async {
    final path = await GetPath();
    final file = File(path);
    final message = {
      'message': 'Benvenuto',
      'time': DateTime.now().toIso8601String()
    };
    final jsonString = jsonEncode(message);
    await file.writeAsString(jsonString);

    if (mounted) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Il JSON è stato scritto con successo");
    }
  }

  Future<String> GetPath() async {
    final dir = await getApplicationCacheDirectory();
    return '${dir.path}/welcome_message.json';
  }

  void LeggiJson() async {
    final path = await GetPath();
    final file = File(path);
    final JsonContent;

    if (file.exists() == true) {
      final JsonContent = await file.readAsString();
      QuickAlert.show(
          context: context, type: QuickAlertType.info, text: JsonContent);
    } else {
      QuickAlert.show(context: context, type: QuickAlertType.error, text: "Il file non esiste");
    }
  }
}
