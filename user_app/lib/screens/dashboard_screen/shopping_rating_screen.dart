import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../utils/generator.dart';

class ShoppingRatingScreen extends StatefulWidget {
  @override
  _ShoppingRatingScreenState createState() => _ShoppingRatingScreenState();
}

class _ShoppingRatingScreenState extends State<ShoppingRatingScreen> {
  int _currentStep = 4;

 

  void _showDialog() {
    showDialog(
        context: context, builder: (BuildContext context) => RatingDialog());
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(MdiIcons.chevronLeft),
          ),
          title: FxText.h6("Rating", fontWeight: 600),
        ),
        body: ListView(
          children: <Widget>[
            Stepper(
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
                  title: FxText.b1('Order placed - 14 April',
                      letterSpacing: 0.2),
                  content: SizedBox(
                    child: FxText.sh2("Order was received by seller",
                        ),
                  ),
                ),
                Step(
                  isActive: true,
                  state: StepState.complete,
                  title: FxText.b1('Payment confirmed - 14 april',
                      letterSpacing: 0.2),
                  content: SizedBox(
                    child: FxText.sh2("Pay via debit card",
                        ),
                  ),
                ),
                Step(
                  isActive: true,
                  state: StepState.complete,
                  title: FxText.b1('Processing - 16 April',
                      letterSpacing: 0.2),
                  content: SizedBox(
                    child: FxText.sh2(
                        "It may be take longer time than expected",
                        ),
                  ),
                ),
                Step(
                  isActive: true,
                  state: StepState.complete,
                  title: FxText.b1('Delivered - 2:30 PM, 18 April',
                      letterSpacing: 0.2),
                  content: SizedBox(
                    child: FxText.sh2(
                        "Today at 2:30 PM order has been delivered",
                        ),
                  ),
                ),
                Step(
                    isActive: true,
                    state: StepState.indexed,
                    title: FxText.b1('Review \& Rating',
                        letterSpacing: 0.2,
                        fontWeight: 700),
                    content: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FxText("It's time to rate a product"),
                        ],
                      ),
                    )),
              ],
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () {
                    _showDialog();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(FxSpacing.xy(16, 0))),
                  child: FxText.b1("Rate".toUpperCase(),
                      letterSpacing: 0.5,
                      wordSpacing: 0.5)),
            ),
          ],
        ));
  }
}

class RatingDialog extends StatefulWidget {
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _selectRate = 5;
  late ThemeData theme;

 

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: FxSpacing.x(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FxText.h6("Enjoying product?",
                      fontWeight: 700, letterSpacing: 0),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    child: FxText.b2("How would you rate our service?",
                        fontWeight: 500, letterSpacing: 0.3),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return Padding(
                          padding: EdgeInsets.all(2),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectRate = index + 1;
                                });
                              },
                              child: index < _selectRate
                                  ? Icon(Icons.star,
                                      size: 32, color: Generator.starColor)
                                  : Icon(Icons.star_border,
                                      size: 32, color: Generator.starColor)),
                        );
                      }),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 12),
                      child: FxText.caption("Maybe next time",
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
