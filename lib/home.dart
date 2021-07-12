import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isStart = true;
  String _stopwatchText = '00:00';
  final _stopWatch = new Stopwatch();
  final _timeout = const Duration(seconds: 1);
  var counter;

  var refDb = FirebaseDatabase.instance.reference().child("ayarlar");

  Future<void> artir() async {
    var DataSnap = await refDb.child("counter").get();
    var sayi = DataSnap!.value.toString().substring(10).replaceAll("}", "");
    counter = int.parse(sayi);
    counter += 1;

    var bilgi = HashMap<String, dynamic>();
    bilgi["counter"] = counter;
    refDb.child("counter").update(bilgi);
    debugPrint(counter.toString());
  }

  void _startTimeout() {
    new Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (_stopWatch.isRunning) {
      _startTimeout();
    }
    setState(() {
      _setStopwatchText();
    });
  }

  void _startStopButtonPressed() {
    setState(() {
      if (_stopWatch.isRunning) {
        _isStart = true;
        _stopWatch.stop();

        artir();
      } else {
        _isStart = false;
        _stopWatch.start();
        _startTimeout();
      }
    });
  }

  void _resetButtonPressed() {
    if (_stopWatch.isRunning) {
      _startStopButtonPressed();
    }
    setState(() {
      _stopWatch.reset();
      _setStopwatchText();
    });
  }

  void _setStopwatchText() {
    _stopwatchText =
        (_stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
            ':' +
            (_stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kronometre Deneme'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: FittedBox(
            fit: BoxFit.none,
            child: Text(
              _stopwatchText,
              style: TextStyle(fontSize: 72),
            ),
          ),
        ),
        Center(
          child: Text("Counter Değeri: $counter"),
        ),
        Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Icon(_isStart ? Icons.play_arrow : Icons.stop),
                onPressed: _startStopButtonPressed,
              ),
              RaisedButton(
                child: Text('Reset'),
                onPressed: _resetButtonPressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
