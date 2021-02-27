import 'package:flutter/material.dart';
import 'package:mouse_parallax/mouse_parallax.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreInfo extends StatelessWidget {
  const MoreInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ParallaxLayer(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize: 40,
                    fontFamily: 'Quicksand',
                    shadows: [
                      Shadow(
                        blurRadius: 15,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  children: [
                    TextSpan(
                      text: 'Parallax',
                      style: TextStyle(
                        color: Colors.lightBlue.shade100,
                        fontWeight: FontWeight.w900,
                        fontSize: 50,
                      ),
                    ),
                    TextSpan(
                      text: '.dart',
                    ),
                  ]),
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(10),
                child: Icon(Icons.arrow_downward),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return MoreInfoDialog();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MoreInfoDialog extends StatelessWidget {
  const MoreInfoDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          child: Container(
            width: 400,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MOUSE PARALLAX',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'A Pointer-Based Animation Package.\n'
                  'The goal of this package is to make mouse and touch based '
                  'parallax effects as simple as possible.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 35,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      launch('https://github.com/wilsonowilson/mouse_parallax');
                    },
                    child: Text('Get started'),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
