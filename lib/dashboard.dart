import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:workmanager/workmanager.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  //SECTION - ISOLATE
  bool _isInBackground = false;

  @override
  void initState() {
    super.initState();
    // _logCallNumber();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  callNumber() async {
    bool? res = await FlutterPhoneDirectCaller.callNumber("089510136170");
    if (res != null && res) {
      _logCallNumber();
      _dialogKeterangan(context);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState.inactive) {
    //   setState(() {
    //     _isInBackground = false;
    //   });
    // } else {
    //   setState(() {
    //     _isInBackground = true;
    //   });
    //   // Navigator.pushReplacement(
    //   //   context,
    //   //   MaterialPageRoute(
    //   //     builder: (context) => const DashboardPage(),
    //   //   ),
    //   // );
    //   _logCallNumber();
    //   _dialogKeterangan();
    // }
    switch (state) {
      case AppLifecycleState.resumed:
        // TODO: Handle this case.
        _logCallNumber();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
    print(state);
  }

  _logCallNumber() async {
    final Iterable<CallLogEntry> result = await CallLog.query();
    setState(() {
      _callLogEntries = result;
    });
  }

  _dialogKeterangan(BuildContext context) async {
    String inputText = '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Keterangan'),
          content: TextField(
            onChanged: (text) {
              inputText = text;
            },
            decoration: const InputDecoration(
              hintText: 'Masukkan Keterangan',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(
                  {'inputText': inputText},
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Data yang Dikirim: $inputText'),
                  duration: const Duration(seconds: 10),
                ));
              },
              child: const Text('KIRIM'),
            ),
          ],
        );
      },
    );

    print('Nilai yang dimasukkan: $inputText');
  }

  _notifWorkManager() async {
    await Workmanager().registerOneOffTask(
      DateTime.now().millisecondsSinceEpoch.toString(),
      'simpleTask',
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];

  @override
  Widget build(BuildContext context) {
    // print('apakah sedang di background? => ${_isInBackground}');
    const TextStyle mono = TextStyle(fontFamily: 'monospace');
    List<Widget>? children = <Widget>[];

    for (CallLogEntry entry in _callLogEntries) {
      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Divider(),
            Text('Nomor    : ${entry.number}', style: mono),
            Text(
              'DATE     : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)}',
              style: mono,
            ),
            Text('DURATION : ${entry.duration} Detik', style: mono),
          ],
        ),
      );
    }
    return RefreshIndicator(
      displacement: 250,
      backgroundColor: Colors.yellow,
      color: Colors.red,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 1500));

        final Iterable<CallLogEntry> result = await CallLog.query();
        setState(() {
          _callLogEntries = result;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(title: const Text('call_log example')),
        body: ListView(
          children: [
            Column(
              children: <Widget>[
                //NOTE - Tombol Mengambil data
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        print('menjalankan callNumber');
                        await callNumber();
                        // print('menjalankan workmanager');

                        // await _notifWorkManager();
                        // print('menjalankan keterangan');
                        // await _dialogKeterangan();
                      },
                      child: const Text('Get all'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    title: children.isNotEmpty == true ? children[0] : null,
                  ),
                ),

                // ignore: use_build_context_synchronously

                //NOTE - Tombol Telp
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ElevatedButton(
                //       onPressed: () async {
                //         _callNumber();
                //       },
                //       child: const Text('Call'),
                //     ),
                //   ),
                // ),

                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ElevatedButton(
                //       onPressed: () {
                //         Workmanager().registerOneOffTask(
                //           DateTime.now().millisecondsSinceEpoch.toString(),
                //           'simpleTask',
                //           existingWorkPolicy: ExistingWorkPolicy.replace,
                //         );
                //       },
                //       child: const Text('Get all in background'),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
