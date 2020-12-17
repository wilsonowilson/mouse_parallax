# mouse_parallax

A Pointer-Based Animation Package.
The goal of this package is to make mouse and touch based 
parallax effects as simple as possible.

## Setting up

To get started with the Parallax effect, use a `ParallaxStack`

 ```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ParallaxStack(
          layers: [],
        ),
      ),
    );
  }
}
 ```

The layers property takes a list of `ParallaxLayers`. These layers allow
you to define the animatable properties of the stack.


 ```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ParallaxStack(
          layers: [
            ParallaxLayer(
              yRotation: -0.35,
              xOffset: 60,
              enable3D: true,
              center: true,
              child: Container(
                width: 250,
                height: 250,
                color: Colors.black,
              ),
            ),
            ParallaxLayer(
              yRotation: -0.4,
              xOffset: 80,
              enable3D: true,
              center: true,
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 ```

That example yields this result:

![Parallax image](https://raw.githubusercontent.com/wilsonowilson/mouse_parallax/master/assets/demo.gif)
