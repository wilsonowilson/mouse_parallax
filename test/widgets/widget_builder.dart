import 'package:flutter/material.dart';
import 'package:mouse_parallax/mouse_parallax.dart';

Widget buildSingleChildParallaxStack({
  double width = 400,
  double height = 400,
  bool shouldCenter = false,
  Offset childOffset = const Offset(0, 0),
}) {
  return MaterialApp(
    home: Scaffold(
      body: ParallaxStack(
        width: width,
        height: height,
        touchBased: false,
        layers: [
          ParallaxLayer(
            offset: childOffset,
            center: shouldCenter,
            child: const Text(
              'XYZ',
              style: TextStyle(fontSize: 80),
            ),
          ),
        ],
      ),
    ),
  );
}
