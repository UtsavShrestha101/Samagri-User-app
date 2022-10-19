import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutx/flutx.dart';


class HomeController extends FxController {
  TickerProvider ticker;
  HomeController(this.ticker);
  late AnimationController animationController;
  late AnimationController bellController;
  late Animation<double> scaleAnimation,
      slideAnimation,
      fadeAnimation,
      bellAnimation;
  late Tween<Offset> offset;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: ticker,
    );
    bellController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: ticker,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );

    bellAnimation = Tween<double>(begin: -0.04, end: 0.04).animate(
      CurvedAnimation(
        parent: bellController,
        curve: Curves.linear,
      ),
    );

    offset = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));

    animationController.forward();
    bellController.repeat(reverse: true);

    // intro = Intro(
    //   stepCount: 3,
    //   maskClosable: true,
    //   onHighlightWidgetTap: (introStatus) {
    //     print(introStatus);
    //   },
    //   widgetBuilder: StepWidgetBuilder.useDefaultTheme(
    //     texts: [
    //       'Get your notifications from here',
    //       'Get latest & trending products here',
    //       'Get category wise products here',
    //     ],
    //     buttonTextBuilder: (currPage, totalPage) {
    //       return currPage < totalPage - 1 ? 'Next' : 'Finish';
    //     },
    //   ),
    // );

   
  }

 

  @override
  void dispose() {
    animationController.dispose();
    bellController.dispose();
    super.dispose();
  }

 

  

  

  @override
  String getTag() {
    return "home_controller";
  }
}
