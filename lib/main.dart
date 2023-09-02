import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const Game());
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  double ballPosition = 0, ballSpeed = 25;
  int count = 0;
  bool pause = false;
  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    Timer.periodic(const Duration(milliseconds: 15), (timer) {
      if (!pause) {
        setState(() {
          ballPosition += ballSpeed / MediaQuery.of(context).size.height;
          if (ballPosition <= -1 || ballPosition >= 1) {
            ballPosition = 0;
            count = 0;
          }
        });
      }
    });
  }

  void pauseGame() {
    setState(() {
      pause = !pause;
    });
  }

  void changeDirection() {
    setState(() {
      if (!pause) {
        SystemSound.play(SystemSoundType.click);
        ballSpeed = -ballSpeed;
        count++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Count: $count"),
                ElevatedButton(
                  onPressed: () {
                    pauseGame();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: Icon(
                    pause ? Icons.play_arrow : Icons.pause,
                    color: Colors.limeAccent,
                  ),
                )
              ],
            ),
          ),
          body: GestureDetector(
            onTap: () {
              changeDirection();
            },
            child: Container(
              color: Colors.green,
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Divider(
                      thickness: 10,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    alignment: Alignment(0.0, ballPosition),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Colors.limeAccent, shape: BoxShape.circle),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
