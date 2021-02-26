import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'mouse_parallax.dart';

/// {@template static_parallax_stack}
/// A Parallax Stack which does not animate its children. It is animated
/// by the [ParallaxStack].
/// {@endtemplate}
class StaticParallaxStack extends MultiChildRenderObjectWidget {
  /// {@macro static_parallax_stack}
  StaticParallaxStack({
    required List<Widget> children,
    required this.xFactor,
    required this.yFactor,
  }) : super(children: children);

  /// The distance the mouse has moved across the x axis
  /// represented by a range of values from -1 to 1
  final double xFactor;

  /// The distance the mouse has moved across the y axis
  /// represented by a range of values from -1 to 1
  final double yFactor;

  @override
  RenderParallaxStack createRenderObject(BuildContext context) {
    return RenderParallaxStack(xFactor, yFactor);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderParallaxStack renderObject) {
    renderObject
      ..xFactor = xFactor
      ..yFactor = yFactor;
  }
}

/// {@template parallax_layer}
/// A layer in the parallax stack.
/// This serves as a blueprint for the transformations of a widget in a
/// [ParallaxStack]. It contains all the animatable properties of the child.
/// This is not a widget.
/// {@endtemplate}
class ParallaxLayer extends ParentDataWidget<ParallaxStackParentData> {
  /// {@macro parallax_layer}
  const ParallaxLayer({
    Key? key,
    required Widget child,
    this.yRotation = 0.0,
    this.xRotation = 0.0,
    this.zRotation = 0.0,
    this.dimensionalOffset = 0.001,
    this.enable3d = true,
    this.xOffset = 0,
    this.yOffset = 0,
    this.offset = const Offset(0, 0),
  }) : super(child: child, key: key);

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

  /// How much the [child] should translate on the horizontal
  /// axis when a pointer event occurs.
  final double xOffset;

  /// How much the [child] should translate on the verical
  /// axis when a pointer event occurs.
  final double yOffset;

  /// The intensity of the 3D animation. By default, it is set to 0.001
  final double dimensionalOffset;

  /// Whether the [child] should be transformed with a 3D-effect.
  /// This simply sets the entry point of the Transformation matrix
  /// to (3,2, 0.001). The intensity of the 3D can be
  /// customized using the [dimensionalOffset] property.
  final bool enable3d;

  /// The offset at which to paint the child in the parent's coordinate system.
  final Offset offset;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is ParallaxStackParentData);
    final parentData = renderObject.parentData as ParallaxStackParentData;
    var needsLayout = false;
    var needsPaint = false;

    if (parentData.xRotation != xRotation) {
      parentData.xRotation = xRotation;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.yRotation != yRotation) {
      parentData.yRotation = yRotation;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.zRotation != zRotation) {
      parentData.zRotation = zRotation;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.dimensionalOffset != dimensionalOffset) {
      parentData.dimensionalOffset = dimensionalOffset;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.enable3d != enable3d) {
      parentData.enable3d = enable3d;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.xOffset != xOffset) {
      parentData.xOffset = xOffset;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.yOffset != yOffset) {
      parentData.yOffset = yOffset;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.offset != offset) {
      parentData.offset = offset;
      needsPaint = true;
      needsLayout = true;
    }

    final targetParent = renderObject.parent;
    if (targetParent is RenderObject) {
      if (needsLayout) targetParent.markNeedsLayout();
      if (needsPaint) targetParent.markNeedsPaint();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => StaticParallaxStack;
}

/// Parent data for use with [StaticParallaxStack].
class ParallaxStackParentData extends ContainerBoxParentData<RenderBox> {
  /// The y rotation of the child's transform
  double? yRotation;

  /// The x rotation of the child's transform
  double? xRotation;

  /// The z rotation of the child's transform
  double? zRotation;

  /// The "v" of setEntry in the child's transformation.
  /// Represents 3D intensity
  double? dimensionalOffset;

  /// The horizontal offset of the child's transformation
  double? xOffset;

  /// The vertical offset of the child's transformation
  double? yOffset;

  /// Whether the child's transform should have a "3D entrypoint"
  bool? enable3d;
}

/// {@template render_static_parallax_stack}
/// Implements the Parallax Stack layout and paint.
/// The [RenderParallaxStack] lays out its children based on their
/// respective offsets. By default, the [StaticParallaxStack]'s size will
/// match it's largest child's size.
///
/// It also takes in an [xFactor] and [yFactor] which are both values from
/// -1 to 1 representing the pointers position on the screen. It uses this
/// to transform the child.
/// {@endtemplate}
class RenderParallaxStack extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, ParallaxStackParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, ParallaxStackParentData> {
  /// {@macro render_static_parallax_stack}
  RenderParallaxStack(double xFactor, double yFactor)
      : _xFactor = xFactor,
        _yFactor = yFactor;
  double _xFactor;
  double _yFactor;

  /// Set the xFactor of the ParallaxStack
  set xFactor(double xFactor) {
    _xFactor = xFactor;
    markNeedsPaint();
    markNeedsLayout();
  }

  /// Set the yFactor of the ParallaxStack
  set yFactor(double yFactor) {
    _yFactor = yFactor;
    markNeedsPaint();
    markNeedsLayout();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! ParallaxStackParentData) {
      child.parentData = ParallaxStackParentData();
    }
  }

  Matrix4 _effectiveTransform(Matrix4 transform) {
    const resolvedAlignment = Alignment.center;
    final result = Matrix4.identity();

    Offset translation;

    translation = resolvedAlignment.alongSize(size);
    result
      ..translate(translation.dx, translation.dy)
      ..multiply(transform)
      ..translate(-translation.dx, -translation.dy);

    return result;
  }

  @override
  bool get sizedByParent => true;
  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final children = getChildrenAsList();
    for (final child in children) {
      child.layout(
        BoxConstraints(
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight,
        ),
      );
    }
    return Size(constraints.maxWidth, constraints.maxHeight);
  }
  // @override
  // void performLayout() {

  // }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in getChildrenAsList()) {
      final childParentData = child.parentData as ParallaxStackParentData;

      final transform = Matrix4.translationValues(
        -(childParentData.xOffset ?? 0) * _xFactor,
        -(childParentData.yOffset ?? 0) * _yFactor,
        0.0,
      );
      if (childParentData.enable3d ?? false)
        transform.setEntry(3, 2, childParentData.dimensionalOffset ?? 0.001);
      final canvas = context.canvas;
      final xRotation = childParentData.xRotation ?? 0.0;
      final yRotation = childParentData.yRotation ?? 0.0;
      final zRotation = childParentData.zRotation ?? 0.0;
      transform
        ..rotateX(xRotation * -_yFactor)
        ..rotateY(yRotation * _xFactor)
        ..rotateZ(zRotation * _xFactor);
      final effectiveTransform = _effectiveTransform(transform);
      canvas
        ..save()
        ..transform(effectiveTransform.storage);
      context.paintChild(child, childParentData.offset + offset);
      canvas.restore();
    }
  }
}
