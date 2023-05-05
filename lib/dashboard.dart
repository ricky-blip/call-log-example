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

  Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];

  _logCallNumber() async {
    final Iterable<CallLogEntry> result = await CallLog.query();
    setState(() {
      _callLogEntries = result;
    });
  }

  Widget _datalogloglog() {
    const TextStyle mono = TextStyle(fontFamily: 'monospace');
    List<Widget>? children = <Widget>[];

    for (CallLogEntry entryKet in _callLogEntries) {
      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Divider(),
            Text('Nomor    : ${entryKet.number}', style: mono),
            Text(
              'DATE     : ${DateTime.fromMillisecondsSinceEpoch(entryKet.timestamp!)}',
              style: mono,
            ),
            Text('DURATION : ${entryKet.duration} Detik', style: mono),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: children.isNotEmpty ? children[0] : const Text('data kosong'),
    );
  }

  _dialogKeterangan(BuildContext context) {
    String inputText = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Keterangan'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _datalogloglog(),
              TextField(
                onChanged: (text) {
                  inputText = text;
                },
                decoration: const InputDecoration(
                  hintText: 'Masukkan Keterangan',
                ),
              ),
            ],
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

  @override
  Widget build(BuildContext context) {
    // print('apakah sedang di background? => ${_isInBackground}');
    // const TextStyle mono = TextStyle(fontFamily: 'monospace');
    // List<Widget>? children = <Widget>[];

    // for (CallLogEntry entry in _callLogEntries) {
    //   children.add(
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: <Widget>[
    //         const Divider(),
    //         Text('Nomor    : ${entry.number}', style: mono),
    //         Text(
    //           'DATE     : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)}',
    //           style: mono,
    //         ),
    //         Text('DURATION : ${entry.duration} Detik', style: mono),
    //       ],
    //     ),
    //   );
    // }
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
                      },
                      child: const Text('Get all'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:
                        //  ListTile(
                        //   title: children.isNotEmpty == true ? children[0] : null,
                        // ),
                        _datalogloglog(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
