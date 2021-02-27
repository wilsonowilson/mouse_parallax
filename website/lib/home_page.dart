import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mouse_parallax/mouse_parallax.dart';

import 'components/info.dart';
import 'components/objects.dart';
import 'components/waves.dart';

const drag = Duration(milliseconds: 1800);
const curve = Curves.easeOutQuint;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParallaxStack(
        drag: drag,
        dragCurve: curve,
        layers: [
          BackgroundLayer(),
          Shade(color: Color.fromRGBO(20, 20, 35, 0.8)),
          Wave3(),
          const Shade(color: Colors.black26),
          Scribbles(),
          Wave2(),
          const Shade(),
          Wave1(),
          Sign(),
          MoreInfo(),
        ],
      ),
    );
  }
}
