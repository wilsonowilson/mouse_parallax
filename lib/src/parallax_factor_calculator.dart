import 'dart:ui';

import 'package:flutter/material.dart';

/// A simple wrapper for the x & y values of the
/// Parallax Stack's reference position.
class ReferencePosition {
  /// A simple wrapper for the x & y values of the
  /// Parallax Stack's reference position.
  const ReferencePosition(this.x, this.y)
      : assert(
          x >= 0 && x <= 1 && y >= 0 && y <= 1,
          'The reference position must be between or equal to zero and one',
        );

  /// The reference position on the x axis. By default, it is set to 0.5
  final double x;

  /// The reference position on the y axis. By default, it is set to 0.5
  final double y;
}

/// A wrapper for the calculated x & y factors of Parallax events.
class ParallaxFactor {
  /// A wrapper for the calculated x & y factors of Parallax events.
  ParallaxFactor(this.x, this.y);

  /// The generated x reference. When [ReferencePosition.x] is 0.5,
  /// it is between -1 and 1,
  final double x;

  /// The generated y reference. When [ReferencePosition.y] is 0.5,
  /// it is between -1 and 1,
  final double y;
}

/// A caclulator used to generate reference positions for parallax.
abstract class ParallaxFactorCalculator {
  /// A caclulator used to generate reference positions for parallax.
  ParallaxFactorCalculator({
    this.width,
    this.height,
    this.referencePosition,
    this.position,
  });

  /// Used to calculate the necessary parallax factor.
  ParallaxFactor calculate();

  /// The width of the screen
  final double width;

  /// The height of the screen
  final double height;

  /// The reference position of the screen
  final ReferencePosition referencePosition;

  /// The position of the cursor.
  final Offset position;
}

/// A calculator for reference positions between -1 and 1
class RangeParallaxFactorCalculator implements ParallaxFactorCalculator {
  /// A calculator for reference positions between -1 and 1
  RangeParallaxFactorCalculator({
    @required this.width,
    @required this.height,
    @required this.position,
    this.negative = true,
    this.referencePosition = const ReferencePosition(0.5, 0.5),
  });

  @override
  final double width;
  @override
  final double height;
  @override
  final ReferencePosition referencePosition;
  @override
  final Offset position;

  /// Whether the value should be negated.
  final bool negative;

  @override
  ParallaxFactor calculate() {
    final referenceWidth = width * referencePosition.x;
    final referenceHeight = height * referencePosition.y;

    final relativeX = ((referenceWidth - position.dx) / width) * 2;
    final relativeY = ((referenceHeight - position.dy) / height) * 2;

    if (negative) {
      return ParallaxFactor(-relativeX, -relativeY);
    } else {
      return ParallaxFactor(relativeX, relativeY);
    }
  }
}
