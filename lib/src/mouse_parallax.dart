import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mouse_parallax/src/parallax_factor_calculator.dart';

import 'animations.dart';

class ParallaxLayer {
  const ParallaxLayer({
    @required this.child,
    this.xOffset = 0.0,
    this.yOffset = 0.0,
    this.xRotation = 0.0,
    this.yRotation = 0.0,
    this.zRotation = 0.0,
    this.enable3D = false,
    this.center = false,
    this.offset = const Offset(0, 0),
  });

  final Widget child;
  final double xOffset;
  final double yOffset;
  final double xRotation;
  final double yRotation;
  final double zRotation;
  final bool enable3D;
  final bool center;
  final Offset offset;
}

typedef OnHoverCallback = void Function(
    PointerEvent hoverEvent, BoxConstraints constraints);

class PointerListener extends StatelessWidget {
  const PointerListener({
    Key key,
    @required this.child,
    @required this.onEnter,
    @required this.onExit,
    @required this.onHover,
    this.touchBased = false,
  }) : super(key: key);

  final OnHoverCallback onEnter;
  final OnHoverCallback onExit;
  final OnHoverCallback onHover;
  final bool touchBased;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget listener;

    return LayoutBuilder(builder: (context, constraints) {
      if (touchBased == true)
        listener = Listener(
          onPointerHover: (e) => onHover(e, constraints),
          onPointerDown: (e) => onEnter(e, constraints),
          onPointerUp: (e) => onExit(e, constraints),
          child: child,
        );
      listener = MouseRegion(
        onHover: (e) => onHover(e, constraints),
        onEnter: (e) => onEnter(e, constraints),
        onExit: (e) => onExit(e, constraints),
        child: child,
      );
      return listener;
    });
  }
}

class ParallaxStack extends StatefulWidget {
  const ParallaxStack({
    Key key,
    @required this.layers,
    @required this.touchBased,
    this.useLocalPosition = false,
    this.referencePosition = -0.5,
    this.detectPlatform = false,
    this.drag = const Duration(milliseconds: 100),
    this.dimensionalOffset = 0.001,
    this.resetOnExit = false,
    this.width,
    this.height,
    this.dragCurve = Curves.ease,
    this.resetDuration = const Duration(milliseconds: 1200),
    this.resetCurve = Curves.easeInOutCubic,
  }) : super(key: key);

  final List<ParallaxLayer> layers;
  final double referencePosition;
  final bool useLocalPosition;
  final double dimensionalOffset;
  final double width;
  final double height;
  final bool detectPlatform;
  final bool touchBased;
  final bool resetOnExit;
  final Curve dragCurve;
  final Duration resetDuration;
  final Curve resetCurve;

  final Duration drag;

  @override
  _ParallaxStackState createState() => _ParallaxStackState();
}

class _ParallaxStackState extends State<ParallaxStack> {
  bool hovering = false;
  double xFactor = 0.0;
  double yFactor = 0.0;

  @override
  Widget build(BuildContext context) {
    var touchBased = widget.touchBased;
    if (widget.detectPlatform) {
      touchBased = Platform.isAndroid || Platform.isIOS;
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: PointerListener(
        touchBased: touchBased,
        onEnter: (e, x) => setState(() => hovering = true),
        onExit: (e, x) => setState(() {
          setState(() => hovering = false);
          if (widget.resetOnExit) {
            setState(() {
              xFactor = 0.0;
              yFactor = 0.0;
            });
          }
        }),
        onHover: _mapPointerEventToFactor,
        child: Stack(
          children: widget.layers.map(_mapParallaxLayerToWidget).toList(),
        ),
      ),
    );
  }

  Widget _mapParallaxLayerToWidget(ParallaxLayer e) {
    var child = e.child;

    final transform = Matrix4.identity();
    if (e.enable3D) transform.setEntry(3, 2, 0.001);

    if (e.center) child = Center(child: e.child);
    return Transform.translate(
      offset: e.offset,
      child: AnimatedTransform(
        duration: hovering ? widget.drag : widget.resetDuration,
        curve: hovering ? widget.dragCurve : widget.resetCurve,
        yRotation: e.yRotation * xFactor,
        zRotation: e.zRotation * xFactor,
        xRotation: e.xRotation * yFactor,
        xOffset: e.xOffset * xFactor,
        yOffset: e.yOffset * yFactor,
        child: child,
      ),
    );
  }

  void _mapPointerEventToFactor(PointerEvent e, BoxConstraints constraints) {
    final local = widget.useLocalPosition;
    final screenSize = MediaQuery.of(context).size;
    final width = local ? constraints.maxWidth : screenSize.width;
    final height = local ? constraints.maxHeight : screenSize.height;
    final position = local ? e.localPosition : e.position;

    final factor = ParallaxFactorCalculator(
      width: width,
      height: height,
      referencePosition:
          ReferencePosition(widget.referencePosition, widget.referencePosition),
      position: position,
      negative: true,
    ).call();

    setState(() {
      xFactor = factor.x;
      yFactor = factor.y;
    });
  }
}
