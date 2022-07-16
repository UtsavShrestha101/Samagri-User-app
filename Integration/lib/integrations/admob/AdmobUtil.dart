import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class AdmobUtil{

  //If you using in production you generate Admob IDs

  static String IosAppId = "ca-app-pub-3940256099942544~1458002511";
  static String AndroidAppId = "ca-app-pub-3940256099942544~3347511713";

  static String IosInterstitialId = "ca-app-pub-3940256099942544/4411468910";
  static String AndroidInterstitialId = "ca-app-pub-3940256099942544/1033173712";

  static String IosBannerId = "ca-app-pub-3940256099942544/2934735716";
  static String AndroidBannerId = "ca-app-pub-3940256099942544/6300978111";

  static String IosRewardId = "ca-app-pub-3940256099942544/1712485313";
  static String AndroidRewardId = "ca-app-pub-3940256099942544/5224354917";

  static void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType,GlobalKey<ScaffoldState> _scaffoldKey) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!',_scaffoldKey);
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!',_scaffoldKey);
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!',_scaffoldKey);
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(',_scaffoldKey);
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: _scaffoldKey.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                _scaffoldKey.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  static void showSnackBar(String content,GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}