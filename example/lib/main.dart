//ignore_for_file: public_member_api_docs
import 'package:example/examples/background_animation.dart';
import 'package:flutter/material.dart';
import 'package:mouse_parallax/mouse_parallax.dart';

void main() {
  runApp(MyApp());
}

/// Example app.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Example1(),
    );
  }
}

class Example1 extends StatelessWidget {
  const Example1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParallaxStack(
        layers: [
          ParallaxLayer(
            yRotation: 0.35,
            xOffset: 60,
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                color: Colors.black,
              ),
            ),
          ),
          ParallaxLayer(
            yRotation: 0.35,
            xOffset: 80,
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
