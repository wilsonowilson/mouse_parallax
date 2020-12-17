import 'package:flutter/material.dart';
import 'package:mouse_parallax/mouse_parallax.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParallaxStack(
        width: 400,
        height: 400,
        resetOnExit: true,
        layers: [
          ParallaxLayer(
            yRotation: -0.1,
            xOffset: 50,
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
            enable3D: true,
            center: true,
            xOffset: 150,
            yOffset: 30,
            offset: const Offset(40, 40),
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.deepOrange,
              ),
            ),
          ),
        ],
        referencePosition: 0.5,
        useLocalPosition: true,
        touchBased: true,
        detectPlatform: false,
      ),
    );
  }
}
