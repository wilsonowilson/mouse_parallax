import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'parallax_factor_calculator.dart';

part 'animations.dart';

/// A layer in the parallax stack.
/// This serves as a blueprint for the transformations of a widget in a
/// [ParallaxStack]. It contains all the animatable properties of the child.
/// This is not a widget.
@immutable
class ParallaxLayer {
  /// Creates a Parallax layer. It contains all the animatable properties of
  /// the child, as well as properties like [center] and [offset] which
  /// are used to position it.
  ParallaxLayer({
    @required this.child,
    this.xOffset = 0.0,
    this.yOffset = 0.0,
    this.xRotation = 0.0,
    this.yRotation = 0.0,
    this.zRotation = 0.0,
    this.enable3D = false,
    this.center = false,
    this.offset = const Offset(0, 0),
    this.dimensionalOffset = 0.001,
  }) {
    if (!enable3D) {
      assert(
        dimensionalOffset == null,
        'You should only use a dimensional offset when 3D is enabled. '
        'To enable3D, set the `enable3D` property to true.',
      );
    }
  }

  /// The Widget which should be animated. This must not be null.
  final Widget child;

  /// How much the [child] should translate on the horizontal axis when a
  /// pointer event occurs.
  final double xOffset;

  /// How much the [child] should translate on the verical axis when a
  /// pointer event occurs.
  final double yOffset;

  /// How much the [child] should rotate on the x axis when
  /// a pointer event occurs. The nature of the rotation is up-down
  final double xRotation;

  /// How much the [child] should rotate on the y axis when
  /// a pointer event occurs. The nature of the rotation is left-right
  final double yRotation;

  /// How much the [child] should rotate on the z axis when
  /// a pointer event occurs. If you actually want to "spin" the
  /// widget as the pointer moves across the screen, use this.
  final double zRotation;

  /// Whether the [child] should be transformed with a 3D-effect.
  /// This simply sets the entry point of the Transformation matrix
  /// to (3,2, 0.001). The intensity of the 3D can be
  /// customized using the [dimensionalOffset] property.
  final bool enable3D;

  /// Whether the [child] should be positioned in the
  /// center of the [ParallaxStack]. This automatically wraps
  /// the child in a [Center] widget.  This property is only
  /// here to make positioning a [ParallaxLayer] more intuitive.
  /// You can still wrap your child in a [Center]
  /// or [Positioned] widget.
  final bool center;

  /// The offset of the [child]  in the Parallax Stack.
  /// This works similar to the [Positioned] widget or the
  /// translate constructor of the [Transform] widget.
  /// Just like the [center] property, this property is only
  /// here to make positioning a [ParallaxLayer] more intuitive.
  /// You can still wrap your child in a [Center]
  /// or [Positioned] widget.
  final Offset offset;

  /// The intensity of the 3D animation.
  final double dimensionalOffset;
}

typedef _OnHoverCallback = void Function(
  PointerEvent hoverEvent,
  BoxConstraints constraints,
);

class _PointerListener extends StatelessWidget {
  const _PointerListener({
    Key key,
    @required this.child,
    @required this.onEnter,
    @required this.onExit,
    @required this.onHover,
    this.touchBased = false,
  }) : super(key: key);

  final _OnHoverCallback onEnter;
  final _OnHoverCallback onExit;
  final _OnHoverCallback onHover;
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

/// A Widget that allows you to stack parallax layers.
/// This is a wrapper around the [Stack] widget so it behaves similarly to it.
/// By default, it expands to fill the parent, so it's size can be adjusted
/// by wrapping it with a [SizedBox], [Container] or similar.
class ParallaxStack extends StatefulWidget {
  /// A Widget that allows you to stack parallax layers.
  /// This is a wrapper around the [Stack] widget so it behaves similarly to it.
  /// By default, it expands to fill the parent, so it's size can be adjusted
  /// by wrapping it with a [SizedBox], [Container] or similar. It also
  /// comes with a [width] and [height] property for more intuitive sizing.
  ParallaxStack({
    Key key,
    @required this.layers,
    @required this.touchBased,
    this.useLocalPosition = false,
    this.referencePosition = -0.5,
    this.detectPlatform = false,
    this.drag = const Duration(milliseconds: 100),
    this.resetOnExit = false,
    this.width,
    this.height,
    this.dragCurve = Curves.ease,
    this.resetDuration = const Duration(milliseconds: 1200),
    this.resetCurve = Curves.ease,
  }) : super(key: key);

  /// A list of [ParallaxLayer]s which will be mapped to widget depending
  /// on the properties of the layer.
  final List<ParallaxLayer> layers;

  /// Where the parallax effect should be referenced from. This is a scale
  /// from 0-1. Its default value is 0.5, meaning that the
  ///  parallax is referenced from the center.
  final double referencePosition;

  /// Whether the parallax should be referenced from the size and position
  /// of the [ParallaxStack]. If it is false, the Parallax will be measured
  /// based on the width and height of the screen. Otherwise, it will be
  /// measured based on the size of the [ParallaxStack]. It is recommended
  /// to set this to true.
  final bool useLocalPosition;

  /// The width of the [ParallaxStack]
  final double width;

  /// The height of the [ParallaxStack]
  final double height;

  /// Whether the [ParallaxStack] should listen to touch or mouse events
  /// based on the current Platform. If it is set to true, it will listen
  /// to touch events on Android and IOS, while MacOS, Linux, and Windows
  /// will use hover events.
  final bool detectPlatform;

  /// Whether the [ParallaxStack] should work with touch events.
  /// This can be automatically configured for each platform using
  /// the [detectPlatform] property of the [ParallaxStack].
  final bool touchBased;

  /// Whether the animation should reset to the default position when
  /// the pointer leaves the hover region.
  final bool resetOnExit;

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
      child: _PointerListener(
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

    if (e.center) child = Center(child: e.child);
    return Transform.translate(
      offset: e.offset,
      // Custom implicitly animated widget.
      child: _AnimatedTransform(
        duration: hovering ? widget.drag : widget.resetDuration,
        curve: hovering ? widget.dragCurve : widget.resetCurve,
        yRotation: e.yRotation * xFactor,
        enable3d: e.enable3D,
        dimensionalOffset: e.dimensionalOffset,
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

    final factor = RangeParallaxFactorCalculator(
      width: width,
      height: height,
      referencePosition:
          ReferencePosition(widget.referencePosition, widget.referencePosition),
      position: position,
      negative: true,
    ).calculate();

    setState(() {
      xFactor = factor.x;
      yFactor = factor.y;
    });
  }
}
