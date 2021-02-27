import 'package:flutter/material.dart';
import 'package:mouse_parallax/mouse_parallax.dart';

import '../components/info.dart';
import '../components/objects.dart';
import '../components/waves.dart';

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
          const Shade(color: Colors.black45),
          Wave3(),
          const Shade(color: Colors.black38),
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
