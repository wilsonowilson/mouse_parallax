import 'package:flutter/material.dart';
import 'package:mouse_parallax/mouse_parallax.dart';

void main() {
  runApp(MyApp());
}

/// Example app.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Example(),
    );
  }
}

/// Example parallax animation
class Example extends StatelessWidget {
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
