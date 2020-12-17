import 'package:flutter/material.dart';

class AnimatedTransform extends ImplicitlyAnimatedWidget {
  const AnimatedTransform({
    Key key,
    @required this.child,
    @required Duration duration,
    this.yRotation = 0,
    this.xRotation = 0,
    this.zRotation = 0,
    this.xOffset = 0,
    this.yOffset = 0,
    Curve curve = Curves.ease,
    VoidCallback onEnd,
  }) : super(
          key: key,
          curve: curve,
          duration: duration,
          onEnd: onEnd,
        );

  final Widget child;

  final double yRotation;
  final double xRotation;
  final double zRotation;
  final double xOffset;
  final double yOffset;

  @override
  _AnimatedTransformState createState() => _AnimatedTransformState();
}

class _AnimatedTransformState
    extends AnimatedWidgetBaseState<AnimatedTransform> {
  Tween<double> _yRotation;
  Tween<double> _xRotation;
  Tween<double> _zRotation;
  Tween<double> _xOffset;
  Tween<double> _yOffset;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _yRotation = visitor(_yRotation, widget.yRotation,
        (dynamic e) => Tween<double>(begin: e as double)) as Tween<double>;
    _zRotation = visitor(_zRotation, widget.zRotation,
        (dynamic e) => Tween<double>(begin: e as double)) as Tween<double>;
    _xRotation = visitor(
      _xRotation,
      widget.xRotation,
      (dynamic e) => Tween<double>(begin: e as double),
    ) as Tween<double>;
    _xOffset = visitor(
      _xOffset,
      widget.xOffset,
      (dynamic e) => Tween<double>(begin: e as double),
    ) as Tween<double>;
    _yOffset = visitor(
      _yOffset,
      widget.yOffset,
      (dynamic e) => Tween<double>(begin: e as double),
    ) as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
        _xOffset?.evaluate(animation) ?? 0,
        _yOffset?.evaluate(animation) ?? 0,
      ),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(_yRotation.evaluate(animation))
          ..rotateX(_xRotation?.evaluate(animation))
          ..rotateZ(_zRotation?.evaluate(animation)),
        alignment: Alignment.center,
        child: widget?.child,
      ),
    );
  }
}
