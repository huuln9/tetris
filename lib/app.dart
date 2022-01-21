import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const numInRow = 20;
const numInCol = numInRow * 28;

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var gameStarted = false;
  var shapeArr = [
    [10, 29, 30, 31], // 0
    [10, 30, 31, 50],
    [9, 10, 11, 30],
    [10, 29, 30, 50],
    [10, 30, 50, 70], // 4
    [9, 10, 11, 12],
    [9, 10, 30, 31], // 6
    [11, 30, 31, 50],
    [10, 11, 30, 31], // 8
  ];
  var shapeLandedArr = [];
  var shape = [];

  static var randomNum = Random();
  void generateNewShape() {
    int rNum = randomNum.nextInt(4);
    shape = shapeArr[rNum];
  }

  void startGame() {
    generateNewShape();

    const duration = Duration(milliseconds: 200);
    Timer.periodic(duration, (Timer timer) {
      // moveDown();
      if (landed()) {
        timer.cancel();
        // generateNewShape();
      }
      // if (landed()) {
      //   timer.cancel();
      //   _showGameOverScreen();
      // }
    });
  }

  void scrollShape() {
    setState(() {
      if (listEquals(shape, shapeArr[0])) {
        shape = shapeArr[1];
      } else if (listEquals(shape, shapeArr[1])) {
        shape = shapeArr[2];
      } else if (listEquals(shape, shapeArr[2])) {
        shape = shapeArr[3];
      } else if (listEquals(shape, shapeArr[3])) {
        shape = shapeArr[1];
      } else if (listEquals(shape, shapeArr[4])) {
        shape = shapeArr[5];
      } else if (listEquals(shape, shapeArr[5])) {
        shape = shapeArr[4];
      } else if (listEquals(shape, shapeArr[6])) {
        shape = shapeArr[7];
      } else if (listEquals(shape, shapeArr[7])) {
        shape = shapeArr[6];
      }
    });
  }

  void moveDown() {
    setState(() {
      for (var i = 0; i < shape.length; i++) {
        shape[i] += 20;
      }
    });
  }

  bool landed() {
    for (var i = 0; i < shape.length; i++) {
      if (shape[i] >= 540) {
        return true;
      }
    }
    return false;
  }

  void _showGameOverScreen() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text('G A M E  O V E R')),
          content: const Text("You are lose!"),
          actions: <Widget>[
            TextButton(
              onPressed: () => {},
              child: const Text(
                'PLAY AGAIN',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numInRow),
              itemCount: numInCol,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: gameStarted
                      ? Container(
                          color: shape.contains(index)
                              ? Colors.red
                              : Colors.grey[900],
                          child: Text(
                            index.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 6),
                          ),
                        )
                      : Container(
                          color: Colors.grey[900],
                          child: Text(
                            index.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 6),
                          ),
                        ),
                );
              },
            ),
          ),
          Expanded(
            child: gameStarted
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: IconButton(
                          onPressed: () => setState(() {}),
                          icon: const Icon(
                            Icons.arrow_back_outlined,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: IconButton(
                          onPressed: () => scrollShape(),
                          icon: const Icon(
                            Icons.refresh,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: IconButton(
                          onPressed: () => setState(() {}),
                          icon: const Icon(
                            Icons.arrow_forward_outlined,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : IconButton(
                    onPressed: () => {
                      startGame(),
                      setState(() {
                        gameStarted = true;
                      })
                    },
                    icon: const Icon(
                      Icons.play_arrow,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
