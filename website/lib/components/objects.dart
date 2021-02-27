import 'package:flutter/material.dart';
import 'package:mouse_parallax/mouse_parallax.dart';

class Shade extends StatelessWidget {
  const Shade({
    Key? key,
    this.color = Colors.black12,
  }) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

class BackgroundLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const offset = 30;
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width + offset;
    final maxHeight = size.height + offset;
    return ParallaxLayer(
      xOffset: -offset / 2,
      yOffset: -offset / 2,
      child: OverflowBox(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              // colorFilter: ColorFilter.mode(
              //   Colors.cyan.shade300,
              //   BlendMode.colorBurn,
              // ),
              image: AssetImage(
                'images/Background.jpg',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Sign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ParallaxLayer(
      offset: Offset(0, 50),
      xOffset: -50,
      yOffset: -50,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/Sign.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Scribbles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ParallaxLayer(
      xOffset: -30,
      yOffset: -30,
      offset: Offset(-100, 40),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                'images/Scribbles.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
