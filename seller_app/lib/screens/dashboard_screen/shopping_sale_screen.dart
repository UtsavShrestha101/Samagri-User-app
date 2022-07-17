import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:myapp/screens/dashboard_screen/shopping_product_screen.dart';

import '../../../utils/generator.dart';

class ShoppingSaleScreen extends StatefulWidget {
  const ShoppingSaleScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ShoppingSaleScreenState createState() => _ShoppingSaleScreenState();
}

class _ShoppingSaleScreenState extends State<ShoppingSaleScreen> {
  String hourTxt = "02", minuteTxt = "46", secondTxt = "40";
  late Timer _timer;
  int _nowTime = 10000;

  double findAspectRatio(double width) {
    //Logic for aspect ratio of grid view
    return (width / 2 - 24) / ((width / 2 - 24) + 52);
  }

  convertTime() {
    int hour = (_nowTime / 3600).floor();
    int minute = ((_nowTime - 3600 * hour) / 60).floor();
    int second = (_nowTime - 3600 * hour - 60 * minute);
    if (hour < 10) {
      setState(() {
        hourTxt = "0" + hour.toString();
      });
    } else {
      setState(() {
        hourTxt = hour.toString();
      });
    }
    if (minute < 10) {
      setState(() {
        minuteTxt = "0" + minute.toString();
      });
    } else {
      setState(() {
        minuteTxt = minute.toString();
      });
    }
    if (second < 10) {
      setState(() {
        secondTxt = "0" + second.toString();
      });
    } else {
      setState(() {
        secondTxt = second.toString();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_nowTime < 1) {
            timer.cancel();
          } else {
            _nowTime = _nowTime - 1;
            convertTime();
          }
        },
      ),
    );
  }

  @override
  dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: FxSpacing.top(FxSpacing.safeAreaTop(context) + 20),
      children: <Widget>[
        Container(
          margin: FxSpacing.x(20),
          child: FxContainer.bordered(
            color: Colors.transparent,
            paddingAll: 0,
            borderRadiusAll: 4,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Stack(
              children: <Widget>[
                Positioned(
                    right: 30,
                    top: 60,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          FxText.sh1(
                            "Hurry up!",
                            fontWeight: 500,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            child: FxText.h6(
                                hourTxt + " : " + minuteTxt + " : " + secondTxt,
                                fontWeight: 500),
                          )
                        ],
                      ),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  child: ClipPath(
                      clipper: _MyCustomClipper(),
                      child: Container(
                        alignment: Alignment.center,
                      )),
                ),
                Positioned(
                  left: 30,
                  top: 50,
                  child: Container(
                    child: FxText.h6(
                      "Happy \nNew Year\nSale".toUpperCase(),
                      fontWeight: 600,
                      letterSpacing: 0.3,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: FxSpacing.nBottom(20),
          child: FxText.sh1("60% OFF", fontWeight: 600),
        ),
        GridView.count(
          padding: FxSpacing.nBottom(20),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: findAspectRatio(MediaQuery.of(context).size.width),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: <Widget>[
            _OfferWidget(
              name: 'Cup cake',
              image: 'assets/images/product/product-1.jpg',
              price: 89,
              buildContext: context,
            ),
            _OfferWidget(
              name: 'Gems',
              image: 'assets/images/product/product-2.jpg',
              price: 111,
              buildContext: context,
            ),
            _OfferWidget(
              name: 'Sandals',
              buildContext: context,
              image: 'assets/images/product/product-8.jpg',
              price: 77,
            ),
            _OfferWidget(
              name: 'Cosmic',
              buildContext: context,
              image: 'assets/images/product/product-7.jpg',
              price: 119,
            ),
          ],
        ),
        Container(
          margin: FxSpacing.nBottom(20),
          child: FxText.sh1("40% OFF", fontWeight: 600),
        ),
        GridView.count(
          padding: EdgeInsets.all(20),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: findAspectRatio(MediaQuery.of(context).size.width),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: <Widget>[
            _OfferWidget(
              name: 'Sandals',
              buildContext: context,
              image: 'assets/images/product-8.jpg',
              price: 77,
            ),
            _OfferWidget(
              name: 'Sandals',
              buildContext: context,
              image: 'assets/images/product-8.jpg',
              price: 77,
            ),
            _OfferWidget(
              name: 'Sandals',
              buildContext: context,
              image: 'assets/images/product-8.jpg',
              price: 77,
            ),
            _OfferWidget(
              name: 'Cosmic',
              buildContext: context,
              image: 'assets/images/product-7.jpg',
              price: 119,
            ),
          ],
        ),
      ],
    ));
  }
}

class _MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width * 0.65, 0.0);
    path.lineTo(size.width * 0.4, size.height);
    path.lineTo(size.width * 0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class _OfferWidget extends StatelessWidget {
  final String image, name;
  final int price;
  final BuildContext buildContext;

  const _OfferWidget({
    Key? key,
    required this.image,
    required this.name,
    required this.price,
    required this.buildContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String heroTag = Generator.randomString(10);
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     buildContext,
        //     MaterialPageRoute(
        //         builder: (context) => ShoppingProductScreen(
        //               heroTag: heroTag,
        //               // image: image,
        //             )));
      },
      child: FxContainer.bordered(
        paddingAll: 8,
        color: Colors.transparent,
        borderRadiusAll: 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Hero(
              tag: heroTag,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        image,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FxText.sh1(name, fontWeight: 600, letterSpacing: 0),
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    child: FxText.b2("\$ " + price.toString(),
                        fontWeight: 700, letterSpacing: 0),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
