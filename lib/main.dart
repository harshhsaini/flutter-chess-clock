import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(ChessClockApp());
}

class ChessClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChessClock(),
    );
  }
}

class ChessClock extends StatefulWidget {
  @override
  _ChessClockState createState() => _ChessClockState();
}

class _ChessClockState extends State<ChessClock> {
  static const int startTime = 300; // 5 minutes per player
  int playerOneTime = startTime;
  int playerTwoTime = startTime;
  bool isPlayerOneTurn = true;
  Timer? timer;

  void toggleTimer() {
    if (timer == null || !timer!.isActive) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (isPlayerOneTurn) {
            if (playerOneTime > 0) {
              playerOneTime--;
            } else {
              timer.cancel();
            }
          } else {
            if (playerTwoTime > 0) {
              playerTwoTime--;
            } else {
              timer.cancel();
            }
          }
        });
      });
    }
  }

  void switchTurn() {
    setState(() {
      isPlayerOneTurn = !isPlayerOneTurn;
    });
    toggleTimer();
  }

  void resetClock() {
    setState(() {
      playerOneTime = startTime;
      playerTwoTime = startTime;
      isPlayerOneTurn = true;
    });
    timer?.cancel();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "$minutes:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chess Clock"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: isPlayerOneTurn ? switchTurn : null,
              child: Container(
                color: isPlayerOneTurn ? Colors.green : Colors.grey,
                child: Center(
                  child: Text(
                    formatTime(playerOneTime),
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Divider(height: 2, color: Colors.black),
          Expanded(
            child: GestureDetector(
              onTap: !isPlayerOneTurn ? switchTurn : null,
              child: Container(
                color: !isPlayerOneTurn ? Colors.red : Colors.grey,
                child: Center(
                  child: Text(
                    formatTime(playerTwoTime),
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: toggleTimer,
                  child: Text("Start/Pause"),
                ),
                ElevatedButton(
                  onPressed: resetClock,
                  child: Text("Reset"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
