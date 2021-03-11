import 'package:flutter/material.dart';

import 'config.dart';

class OneRating extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'unstar.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'unstar.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'unstar.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'unstar.png', height: 18, width: 18),
        ],
      ),
    );
  }
}

class TwoRatings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'unstar.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'unstar.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'unstar.png', height: 18, width: 18),
        ],
      ),
    );
  }
}

class ThreeRatings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'unstar.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'unstar.png', height: 18, width: 18),
        ],
      ),
    );
  }
}

class FourRatings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'unstar.png', height: 18, width: 18),
        ],
      ),
    );
  }
}

class FiveRatings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Image.asset(Config.PNG_PATH + 'star.png', height: 18, width: 18),
        ],
      ),
    );
  }
}