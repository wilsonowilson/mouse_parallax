import 'dart:ui';

import 'package:meta/meta.dart';

class ReferencePosition {
  const ReferencePosition(this.x, this.y);

  final double x;
  final double y;
}

class ParallaxFactor {
  ParallaxFactor(this.x, this.y);
  final double x;
  final double y;
}

class ParallaxFactorCalculator {
  ParallaxFactorCalculator({
    @required this.width,
    @required this.height,
    @required this.position,
    this.negative = true,
    this.referencePosition = const ReferencePosition(0.5, 0.5),
  })

  // : assert(
  //         referencePosition > 0,
  //         'Reference position must be a non-zero value',
  //       ),
  //       assert(
  //         referencePosition <= 1,
  //         'Reference position must be greater'
  //         'than zero and less than one',
  //       )

  ;

  final double width;
  final double height;
  final ReferencePosition referencePosition;
  final Offset position;
  final bool negative;

  ParallaxFactor call() {
    final referenceWidth = width * referencePosition.x;
    final referenceHeight = height * referencePosition.y;

    final relativeX = (referenceWidth - position.dx) / referenceWidth;
    final relativeY = (referenceHeight - position.dy) / referenceHeight;

    if (negative) {
      return ParallaxFactor(-relativeX, -relativeY);
    } else {
      return ParallaxFactor(relativeX, relativeY);
    }
  }
}
