/*
* This Plugin is still in developer preview.
* */

/*
 * For Flutter
 * - Add dependencies to pubspec.yaml for admob_flutter
 * - run command "flutter pub get"
 * make sure after run this command you need to re run application.
 * don't use hot reload whenever you adding some dependency.
 *
 * Add this line to starting point of your app ../lib/main.dart

Admob.initialize();
// Admob.initialize(testDeviceIds: ['YOUR DEVICE ID']);

*/

/* For Android
 * There is no any configuration
 * Reference : https://pub.dev/packages/admob_flutter
 * Add this line to ../main/AndroidManifest.xml
 *

<manifest>
  <application>
    <meta-data
      android:name="com.google.android.gms.ads.APPLICATION_ID"
      android:value="ca-app-pub-3940256099942544~3347511713"/>
  </application>
</manifest>

 *
*/

/* For iOS
 * Reference : https://pub.dev/packages/admob_flutter
 * Add this lines to ../Runner/Info.plist

<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
<key>io.flutter.embedded_views_preview</key>
<true/>

*
*
* Make sure all steps you follow as references
* */

import 'dart:async';
import 'dart:io';
import 'package:UIKitIntegration/integrations/admob/AdmobUtil.dart';
import 'package:UIKitIntegration/utils/Generator.dart';
import 'package:UIKitIntegration/utils/SizeConfig.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';


class InterstitialAdmobWidget extends StatefulWidget {


  final String refUrl;

  const InterstitialAdmobWidget({Key key, this.refUrl}) : super(key: key);


  @override
  _InterstitialAdmobWidgetState createState() => _InterstitialAdmobWidgetState();
}

class _InterstitialAdmobWidgetState extends State<InterstitialAdmobWidget> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AdmobInterstitial interstitialAd;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        AdmobUtil.handleEvent(event, args, 'Interstitial',_scaffoldKey);
      },
    );
    interstitialAd.load();
  }


  String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return AdmobUtil.IosInterstitialId;
    } else if (Platform.isAndroid) {
      return AdmobUtil.AndroidInterstitialId;
    }
    return null;
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
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
                  "Admob Interstitial",
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
              body: Container(
                child: Center(
                  child: FlatButton(
                    color: themeData.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      "Show Interstitial",
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.bodyText2,
                          color: themeData.colorScheme.onPrimary,
                          fontWeight: 500),
                    ),
                    onPressed: () async {
                      if (await interstitialAd.isLoaded) {
                        interstitialAd.show();
                      } else {
                        AdmobUtil.showSnackBar(
                            'Interstitial ad is still loading...',_scaffoldKey);
                      }
                    },
                  ),
                ),
              ),
            ));
      },
    );
  }
}
