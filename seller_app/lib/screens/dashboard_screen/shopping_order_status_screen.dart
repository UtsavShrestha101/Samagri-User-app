/*
* File : Shopping Order Status
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class ShoppingOrderStatusScreen extends StatefulWidget {
  @override
  _ShoppingOrderStatusScreenState createState() =>
      _ShoppingOrderStatusScreenState();
}

class TextIconItem {
  String text;
  IconData iconData;

  TextIconItem(this.text, this.iconData);
}

class _ShoppingOrderStatusScreenState extends State<ShoppingOrderStatusScreen> {
  int _currentStep = 3;


 

  List<TextIconItem> _textIconChoice = [
    TextIconItem("Receipt", MdiIcons.receipt),
    TextIconItem("Cancel", MdiIcons.cancel)
  ];

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.all(0),
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 16),
          height: 200,
          child: PageView(
            pageSnapping: true,
            physics: ClampingScrollPhysics(),
            controller: PageController(
              initialPage: 0,
              viewportFraction: 0.80,
            ),
            onPageChanged: (int page) {
              setState(() {});
            },
            children: <Widget>[
              FxContainer.bordered(
                // margin: EdgeInsets.only(
                //     bottom: 8, right: Language.autoDirection(12, 0)!, top: 8),
                padding: EdgeInsets.only(left: 16),
                child: Container(
                  padding:
                      EdgeInsets.only(left: 8, top: 16, bottom: 16, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FxText.sh1("Order No: 381478", fontWeight: 600),
                              FxText.caption("Placed on april, 14,2020",
                                  fontWeight: 400),
                            ],
                          ),
                          Container(
                            child: PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                                return _textIconChoice
                                    .map((TextIconItem choice) {
                                  return PopupMenuItem(
                                    value: choice,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(choice.iconData,
                                            size: 18,
                                                ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: FxText.b2(
                                            choice.text,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList();
                              },
                              icon: Icon(
                                MdiIcons.dotsVertical,
                              ),
                            ),
                          )
                        ],
                      ),
                      FxText.sh2("Paid", fontWeight: 600),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FxText.sh2("Status : ", fontWeight: 500),
                          FxText.sh1("On the way", fontWeight: 600),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              FxContainer.bordered(
                margin: EdgeInsets.only(bottom: 8, right: 12, left: 12, top: 8),
                padding: EdgeInsets.only(left: 16),
                child: Container(
                  padding:
                      EdgeInsets.only(left: 8, top: 16, bottom: 16, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FxText.sh1("Order No: 47856521", fontWeight: 600),
                              FxText.caption("Placed on feb, 14,2020",
                                  fontWeight: 400),
                            ],
                          ),
                          Container(
                            child: PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                                return _textIconChoice
                                    .map((TextIconItem choice) {
                                  return PopupMenuItem(
                                    value: choice,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(choice.iconData,
                                            size: 18,
                                                ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: FxText.b2(
                                            choice.text,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList();
                              },
                              icon: Icon(
                                MdiIcons.dotsVertical,
                              ),
                            ),
                          )
                        ],
                      ),
                      FxText.sh2("Cash on Delivery", fontWeight: 600),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FxText.sh2("Status : ", fontWeight: 500),
                          FxText.sh1("Delivered", fontWeight: 600),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              FxContainer.bordered(
                // margin: EdgeInsets.only(
                //     top: 8, bottom: 8, left: Language.autoDirection(0, 12)!),
                child: Center(
                  child: FxText.sh1("VIEW ALL",
                      fontWeight: 600,
                      letterSpacing: 0.5,
                      ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: FxSpacing.nBottom(20),
          child: FxText.sh2("STATUS",
              fontWeight: 700,
              ),
        ),
        Container(
          child: Stepper(
            physics: ClampingScrollPhysics(),
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Container();
            },
            currentStep: _currentStep,
            onStepTapped: (pos) {
              setState(() {
                _currentStep = pos;
              });
            },
            steps: <Step>[
              Step(
                isActive: true,
                state: StepState.complete,
                title: FxText.b1('Order placed - 14 April', fontWeight: 600),
                content:
                    FxText.sh2("Order was received by seller", fontWeight: 500),
              ),
              Step(
                isActive: true,
                state: StepState.complete,
                title:
                    FxText.b1('Payment confirmed - 14 april', fontWeight: 600),
                content: SizedBox(
                  child: FxText.sh2("Pay via debit card", fontWeight: 600),
                ),
              ),
              Step(
                isActive: true,
                state: StepState.complete,
                title: FxText.b1('Processing - 16 April', fontWeight: 600),
                content: SizedBox(
                  child: FxText.sh2("It may be take longer time than expected",
                      fontWeight: 500),
                ),
              ),
              Step(
                isActive: true,
                state: StepState.indexed,
                title: FxText.b1('On the way', fontWeight: 600),
                content: SizedBox(
                  child: FxText.sh2(
                      "Jenifer picked your order, you can contact her anytime",
                      fontWeight: 500),
                ),
              ),
              Step(
                state: StepState.indexed,
                title: FxText.b1('Deliver', fontWeight: 600),
                content: SizedBox(
                  child: FxText.sh2("Today at 2:30 PM order has been deliver",
                      fontWeight: 500),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
