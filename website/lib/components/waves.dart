import 'package:flutter/material.dart';
import 'package:mouse_parallax/mouse_parallax.dart';

class Wave1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const offset = 90.0;
    const maxWidth = 400.0 + offset;
    const maxHeight = 400.0 + offset;
    return ParallaxLayer(
      offset: Offset(offset, offset + 70),
      xOffset: -offset,
      yOffset: -offset,
      child: Align(
        alignment: Alignment.bottomRight,
        child: AnimatedLayer(
          dx: 0,
          child: Container(
            width: maxWidth,
            height: maxHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'images/Wave 1.png',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Wave2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const offset = 50.0;
    const maxHeight = 300.0 + offset * 2;
    final maxWidth = MediaQuery.of(context).size.width + 200;
    return ParallaxLayer(
      xOffset: -offset,
      yOffset: -offset,
      offset: Offset(0, offset),
      child: OverflowBox(
        maxWidth: maxWidth,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: AnimatedLayer(
            dx: 5,
            dy: 5,
            child: Container(
              width: maxWidth,
              height: maxHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'images/Wave 2.png',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Wave3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const offset = 30.0;
    const maxHeight = 600.0 + offset * 2;
    final maxWidth = MediaQuery.of(context).size.width + 200;
    return ParallaxLayer(
      xOffset: -offset,
      yOffset: -offset,
      offset: Offset(0, -10),
      child: OverflowBox(
        maxWidth: maxWidth,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: AnimatedLayer(
            dx: 10,
            dy: 10,
            child: Container(
              width: maxWidth,
              height: maxHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'images/Wave 3.png',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedLayer extends StatefulWidget {
  const AnimatedLayer({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 2500),
    this.dx = -20,
    this.dy = 20,
  }) : super(key: key);
  final double dx;
  final double dy;
  final Duration duration;
  final Widget child;

  @override
  _AnimatedLayerState createState() => _AnimatedLayerState();
}

class _AnimatedLayerState extends State<AnimatedLayer>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeInOut,
      ),
    );
    _controller!.addStatusListener(_statusListener);
    _controller!.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.removeStatusListener(_statusListener);
    _controller?.dispose();
    super.dispose();
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller?.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _controller?.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation!,
      builder: (context, __) {
        return Transform.translate(
          offset: Offset(
            widget.dx * _animation!.value,
            widget.dy * _animation!.value,
          ),
          child: widget.child,
        );
      },
    );
  }
}
