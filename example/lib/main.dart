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
      home: Scaffold(
        body: ParallaxStack(
          resetOnExit: true,
          layers: [
            ParallaxLayer(
              yRotation: -0.35,
              xOffset: 60,
              enable3D: true,
              center: true,
              child: Container(
                width: 250,
                height: 250,
                color: Colors.black,
              ),
            ),
            ParallaxLayer(
              yRotation: -0.4,
              xOffset: 80,
              enable3D: true,
              center: true,
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
