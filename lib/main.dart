import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_call/dashboard.dart';
import 'package:workmanager/workmanager.dart';

///TOP-LEVEL FUNCTION PROVIDED FOR WORK MANAGER AS CALLBACK
void callbackDispatcher() {
  Workmanager().executeTask((dynamic task, dynamic inputData) async {
    // print('Background Services are Working!');
    try {
      // final Iterable<CallLogEntry> cLog = await CallLog.get();
      // print('Queried call log entries');
      // for (CallLogEntry entry in cLog) {
      //   print('NUMBER     : ${entry.number}');
      //   print(
      //       'DATE : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)}');
      //   print('DURATION   : ${entry.duration}');
      //   print('-------------------------------------');
      // }

      return true;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      return true;
    }
  });
}

void main() {
  runApp(MyApp());
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
}

/// example widget for call log plugin
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const DashboardPage(),
    );
  }
}
