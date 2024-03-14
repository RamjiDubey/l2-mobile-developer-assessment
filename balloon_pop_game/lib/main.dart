import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(BalloonPopGame());
}

class BalloonPopGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balloon Pop Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int missed = 0;
  int secondsLeft = 120;
  late Timer timer;
  List<Balloon> balloons = [];

  @override
  void initState() {
    super.initState();
    startTimer();
    generateBalloons();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        setState(() {
          secondsLeft--;
        });
      } else {
        timer.cancel();
        showEndDialog();
      }
    });
  }

  void generateBalloons() {
    Timer.periodic(Duration(milliseconds: 1500), (timer) {
      if (secondsLeft > 0) {
        setState(() {
          balloons.add(Balloon());
        });
      } else {
        timer.cancel();
      }
    });
  }

  void popBalloon(Balloon balloon) {
    setState(() {
      if (balloons.contains(balloon)) {
        balloons.remove(balloon);
        score += 2;
      } else {
        missed++;
        score--;
      }
    });
  }

  void showEndDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("Score: $score\nBalloons Missed: $missed"),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      missed = 0;
      secondsLeft = 120;
      balloons.clear();
    });
    startTimer();
    generateBalloons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Balloon Pop Game"),
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              "$secondsLeft",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTapDown: (details) {
                Balloon? tappedBalloon;
                balloons.forEach((balloon) {
                  if (balloon.popRegion.contains(details.globalPosition)) {
                    tappedBalloon = balloon;
                    return;
                  }
                });
                if (tappedBalloon != null) {
                  popBalloon(tappedBalloon!);
                }
              },
              child: Stack(
                children: balloons,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

FlatButton({required Null Function() onPressed, required Text child}) {
}

class Balloon extends StatelessWidget {
  final double size = Random().nextDouble() * 50 + 50;
  final Offset position = Offset(
    Random().nextDouble() * 300 + 50,
    Random().nextDouble() * 300 + 50,
  );
  final Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  final Rect popRegion;

  Balloon() : popRegion = Rect.fromCircle(center: Offset(0, 0), radius: 50);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: () {
          // Do nothing, balloon should be popped via parent GestureDetector
        },
        child: Container(
          width: size,
          height: size * 1.5,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
