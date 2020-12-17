import 'dart:ui';

import 'package:meta/meta.dart';

class ParallaxFactor {
  ParallaxFactor(this.x, this.y);
  final double x;
  final double y;
}

class ParallaxFactorCalculator {
  ParallaxFactorCalculator({
    @required this.width,
    @required this.height,
    @required this.referencePosition,
    @required this.position,
    @required this.negative,
  });

  final double width;
  final double height;
  final double referencePosition;
  final Offset position;
  final bool negative;

  ParallaxFactor call() {
    final referenceWidth = width * referencePosition;
    final referenceHeight = height * referencePosition;

    final relativeX = (referenceWidth - position.dx) / referenceWidth;
    final relativeY = (referenceHeight - position.dy) / referenceHeight;

    if (negative) {
      return ParallaxFactor(-relativeX, -relativeY);
    } else {
      return ParallaxFactor(relativeX, relativeY);
    }
  }
}
