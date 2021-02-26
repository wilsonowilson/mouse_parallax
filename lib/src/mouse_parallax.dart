import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'animation.dart';
import 'gestures.dart';
import 'parallax_factor_calculator.dart';
import 'rendering.dart';

/// {@template parallax_stack}
/// A Widget that allows you to stack and animate the children of
/// parallax layers.
/// {@endtemplate}
class ParallaxStack extends StatefulWidget {
  /// {@macro parallax_stack}
  const ParallaxStack({
    Key? key,
    required this.layers,
    this.useLocalPosition = true,
    this.resetOnExit = true,
    this.referencePosition = 0.5,
    this.drag = const Duration(milliseconds: 100),
    this.dragCurve = Curves.ease,
    this.resetDuration = const Duration(milliseconds: 1200),
    this.resetCurve = Curves.ease,
  }) : super(key: key);

  /// Whether the parallax should be referenced from the size and position
  /// of the [ParallaxStack]. If it is false, the Parallax will be measured
  /// based on the width and height of the screen. Otherwise, it will be
  /// measured based on the size of the [ParallaxStack]. It is recommended
  /// to set this to true.
  final bool useLocalPosition;

  /// Whether the animation should reset to the default position when
  /// the pointer leaves the hover region.
  final bool resetOnExit;

  /// Where the parallax effect should be referenced from. This is a scale
  /// from 0-1. Its default value is 0.5, meaning that the
  ///  parallax is referenced from the center.
  final double referencePosition;

  /// A list of [ParallaxLayer]s
  final List<Widget> layers;

  /// The duration of the animation that takes place
  ///  when pointer events occur and when the widget
  /// transforms. By default, it is set to 100 milliseconds.
  final Duration drag;

  /// The duration of the animation that takes place
  ///  when pointer events occur and when the widget
  /// transforms. By default, it is set to [Curves.ease].
  final Curve dragCurve;

  /// How long it should take the widget to reset when the pointer
  /// leaves the hover region.
  final Duration resetDuration;

  /// The curve of the animation that occurs when
  /// the pointer leaves the hover region. It will
  /// only apply when [resetOnExit] is true.

  final Curve resetCurve;
  @override
  _ParallaxStackState createState() => _ParallaxStackState();
}

class _ParallaxStackState extends State<ParallaxStack> {
  double xFactor = 0;
  double yFactor = 0;
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    return PointerListener(
      touchBased: false,
      onEnter: (_, __) => setState(() => hovering = true),
      onExit: (_, __) => setState(() {
        hovering = false;
        if (widget.resetOnExit) {
          xFactor = 0.0;
          yFactor = 0.0;
        }
      }),
      onHover: _mapPointerEventToFactor,
      child: AnimatedParallaxStack(
        children: widget.layers,
        xFactor: xFactor,
        yFactor: yFactor,
        duration: hovering ? widget.drag : widget.resetDuration,
        curve: hovering ? widget.dragCurve : widget.resetCurve,
      ),
    );
  }

  void _mapPointerEventToFactor(PointerEvent e, BoxConstraints constraints) {
    final local = widget.useLocalPosition;
    final screenSize = MediaQuery.of(context).size;
    final width = local ? constraints.maxWidth : screenSize.width;
    final height = local ? constraints.maxHeight : screenSize.height;
    final position = local ? e.localPosition : e.position;

    final factor = RelativeParallaxFactorCalculator(
      width: width,
      height: height,
      position: position,
      negative: false,
      referencePosition: ReferencePosition(
        widget.referencePosition,
        widget.referencePosition,
      ),
    ).calculate();

    setState(() {
      xFactor = factor.x;
      yFactor = factor.y;
    });
  }
}
