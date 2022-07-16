/*
*  (I am already added dummy payment but if you use in production
*  than create token at https://dashboard.stripe.com/   [ Stripe Dashboard ].
* */


/*
 * For Flutter
 * - Add dependencies to pubspec.yaml for Stripe payment
 * - run command "flutter pub get"
 * make sure after run this command you need to re run application.
 * don't use hot reload whenever you adding some dependency.
*/


/* For Android
 * Reference : https://pub.dev/packages/stripe_payment
 * Reference 2 : https://medium.com/flutterdevs/stripe-payment-in-flutter-d7f87f9a193c
 * Requires AndroidX as references
 */

/* For iOS
 * Reference : https://pub.dev/packages/stripe_payment
 * There is no config required
 */

/*
* Make sure all steps you follow as references
* Then enable email/password authentication in your project at https://console.firebase.google.com/
* */


import 'dart:convert';
import 'dart:io';

import 'package:UIKitIntegration/utils/Generator.dart';
import 'package:UIKitIntegration/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';

class StripePaymentWidget extends StatefulWidget {
  final String refUrl;

  const StripePaymentWidget({Key key, this.refUrl}) : super(key: key);

  @override
  _StripePaymentWidgetState createState() => _StripePaymentWidgetState();
}

class _StripePaymentWidgetState extends State<StripePaymentWidget> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;

  Token _paymentToken;
  PaymentMethod _paymentMethod;
  String _error;
  final String _currentSecret = null; //set this yourself, e.g using curl
  PaymentIntentResult _paymentIntent;
  Source _source;

  ScrollController _controller = ScrollController();

  final CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
  );

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  initState() {
    super.initState();

    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_aSaULNS8cJU6Tvo20VAXy6rp",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  createSource() {
    StripePayment.createSourceWithParams(SourceParams(
      type: 'ideal',
      amount: 1099,
      currency: 'eur',
      returnURL: 'https://www.google.com/', //Add redirect URL
    )).then((source) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Received ${source.sourceId}')));
      setState(() {
        _source = source;
      });
    }).catchError(setError);
  }

  createTokenFromCardForm() {
    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Received ${paymentMethod.id}')));
      setState(() {
        _paymentMethod = paymentMethod;
      });
    }).catchError(setError);
  }

  createTokenFromCard() {
    StripePayment.createTokenWithCard(
      testCard,
    ).then((token) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
      setState(() {
        _paymentToken = token;
      });
    }).catchError(setError);
  }

  createFromToken() {
    StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: CreditCard(
          token: _paymentToken.tokenId,
        ),
      ),
    ).then((paymentMethod) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Received ${paymentMethod.id}')));
      setState(() {
        _paymentMethod = paymentMethod;
      });
    }).catchError(setError);
  }

  nativePayment() {
    if (Platform.isIOS) {
      _controller.jumpTo(450);
    }
    StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: "1.20",
        currencyCode: "EUR",
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'DE',
        currencyCode: 'EUR',
        items: [
          ApplePayItem(
            label: 'Test',
            amount: '13',
          )
        ],
      ),
    ).then((token) {
      setState(() {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
        _paymentToken = token;
      });
    }).catchError(setError);
  }

  completeNativePayment() {
    StripePayment.completeNativePayRequest().then((_) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Completed successfully')));
    }).catchError(setError);
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        int themeType = value.themeMode();
        themeData = AppTheme.getThemeFromThemeMode(themeType);
        customAppTheme = AppTheme.getCustomAppTheme(themeType);
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    MdiIcons.chevronLeft,
                    color: themeData.colorScheme.onBackground,
                    size: MySize.size24,
                  ),
                ),
                centerTitle: true,
                title: Text(
                  "Stripe Payment",
                  style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 600),
                ),
                actions: widget.refUrl != null
                    ? [
                        InkWell(
                          onTap: () {
                            Generator.launchUrl(widget.refUrl);
                          },
                          child: Container(
                            margin: Spacing.right(16),
                            child: Icon(
                              MdiIcons.web,
                              color: themeData.colorScheme.onBackground,
                              size: MySize.size24,
                            ),
                          ),
                        )
                      ]
                    : [],
              ),
              body: ListView(
                controller: _controller,
                padding: Spacing.fromLTRB(24,24,24,16),
                children: <Widget>[
                  FlatButton(
                    color: themeData.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      "Create Source",
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.bodyText2,
                          color: themeData.colorScheme.onPrimary,
                          fontWeight: 500),
                    ),
                    onPressed: () {
                      createSource();
                    },
                  ),
                  Divider(),
                  FlatButton(
                    color: themeData.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      "Create Token with Card Form",
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.bodyText2,
                          color: themeData.colorScheme.onPrimary,
                          fontWeight: 500),
                    ),
                    onPressed: () {
                      createTokenFromCardForm();
                    },
                  ),
                  FlatButton(
                    color: themeData.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Text("Create Token with Card",
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.bodyText2,
                            color: themeData.colorScheme.onPrimary,
                            fontWeight: 500)),
                    onPressed: () {
                      createTokenFromCard();
                    },
                  ),
                  FlatButton(
                    color: _paymentToken == null
                        ? customAppTheme.disabledColor
                        : themeData.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Text("Create Payment Method with existing token",
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.bodyText2,
                            color: _paymentToken == null
                                ? customAppTheme.onDisabled
                                : themeData.colorScheme.onPrimary,
                            fontWeight: 500)),
                    onPressed: _paymentToken == null
                        ? () {}
                        : () {
                            createFromToken();
                          },
                  ),
                  Divider(),
                  FlatButton(
                    color: themeData.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Text("Native payment",
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.bodyText2,
                            color: themeData.colorScheme.onPrimary,
                            fontWeight: 500)),
                    onPressed: () {
                      nativePayment();
                    },
                  ),
                  FlatButton(
                    color: themeData.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Text("Complete Native Payment",
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.bodyText2,
                            color: themeData.colorScheme.onPrimary,
                            fontWeight: 500)),
                    onPressed: () {
                      completeNativePayment();
                    },
                  ),
                  Divider(),
                  Text('Current source:'),
                  Text(
                    JsonEncoder.withIndent('  ')
                        .convert(_source?.toJson() ?? {}),
                    style: TextStyle(fontFamily: "Monospace"),
                  ),
                  Divider(),
                  Text('Current token:'),
                  Text(
                    JsonEncoder.withIndent('  ')
                        .convert(_paymentToken?.toJson() ?? {}),
                    style: TextStyle(fontFamily: "Monospace"),
                  ),
                  Divider(),
                  Text('Current payment method:'),
                  Text(
                    JsonEncoder.withIndent('  ')
                        .convert(_paymentMethod?.toJson() ?? {}),
                    style: TextStyle(fontFamily: "Monospace"),
                  ),
                  Divider(),
                  Divider(),
                  Text('Current error: $_error'),
                ],
              ),
            ));
      },
    );
  }
}
