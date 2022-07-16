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
*
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

//BannerAdmobWidget
class BannerAdmobWidget extends StatefulWidget {
  final String refUrl;

  const BannerAdmobWidget({Key key, this.refUrl}) : super(key: key);

  @override
  _BannerAdmobWidgetState createState() => _BannerAdmobWidgetState();
}

class _BannerAdmobWidgetState extends State<BannerAdmobWidget> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AdmobBannerSize bannerSize;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bannerSize = AdmobBannerSize.BANNER;
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return AdmobUtil.IosBannerId;
    } else if (Platform.isAndroid) {
      return AdmobUtil.AndroidBannerId;
    }
    return null;
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
                  "Admob Banner",
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
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 40,
                        itemBuilder: (BuildContext context, int index) {
                          if (index != 0 && index % 6 == 0) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  child: AdmobBanner(
                                    adUnitId: getBannerAdUnitId(),
                                    adSize: bannerSize,
                                    listener: (AdmobAdEvent event,
                                        Map<String, dynamic> args) {
                                      AdmobUtil.handleEvent(event, args, 'Banner',_scaffoldKey);
                                    },
                                    onBannerCreated:
                                        (AdmobBannerController controller) {
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: Text("index " + index.toString()),
                                ),
                              ],
                            );
                          }
                          return ListTile(
                            title: Text("index " + index.toString()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}

