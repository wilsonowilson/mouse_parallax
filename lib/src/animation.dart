import 'package:flutter/material.dart';

import 'rendering.dart';

/// {@template animated_parallax_stack}
/// An [ImplicitlyAnimatedWidget] used to animate the values of the
/// ParallaxStack implicitly.
/// {@endtemplate}
class AnimatedParallaxStack extends ImplicitlyAnimatedWidget {
  /// {@macro animated_parallax_stack}

  AnimatedParallaxStack({
    Key? key,
    Curve curve = Curves.linear,
    required Duration duration,
    required this.children,
    required this.xFactor,
    required this.yFactor,
  }) : super(key: key, duration: duration, curve: curve);

  /// A list of [ParallaxLayer]s.
  final List<ParallaxLayer> children;

  /// The distance the mouse has moved across the x axis of the screen
  /// represented by a range of values from -1 to 1
  final double xFactor;

  /// The distance the mouse has moved across the y axis of the screen
  /// represented by a range of values from -1 to 1
  final double yFactor;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() {
    return _AnimatedParallaxStackState();
  }
}

class _AnimatedParallaxStackState
    extends AnimatedWidgetBaseState<AnimatedParallaxStack> {
  Tween<double>? _xFactor;
  Tween<double>? _yFactor;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _xFactor = visitor(_xFactor, widget.xFactor,
        (dynamic e) => Tween<double>(begin: e as double)) as Tween<double>;
    _yFactor = visitor(_yFactor, widget.yFactor,
        (dynamic e) => Tween<double>(begin: e as double)) as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    return StaticParallaxStack(
      children: widget.children,
      xFactor: _xFactor?.evaluate(animation) ?? 0.0,
      yFactor: _yFactor?.evaluate(animation) ?? 0.0,
    );
  }
}
