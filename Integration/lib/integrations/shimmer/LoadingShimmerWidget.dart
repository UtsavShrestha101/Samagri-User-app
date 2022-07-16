/*
* This Plugin is Third Party.
* */

/*
 * For Flutter
 * - Add dependencies to pubspec.yaml for shimmer
 * - run command "flutter pub get"
 * make sure after run this command you need to re run application.
 * don't use hot reload whenever you adding some dependency.
*/

/* For Android
 *
 * Reference : https://pub.dev/packages/shimmer
 */

/* For iOS
 * Reference : https://pub.dev/packages/shimmer


*
* Make sure all steps you follow as references
* */

import 'dart:async';
import 'package:UIKitIntegration/utils/Generator.dart';
import 'package:UIKitIntegration/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';

class LoadingShimmerWidget extends StatefulWidget {

  final String refUrl;

   LoadingShimmerWidget({Key key, this.refUrl}) : super(key: key);


  @override
  _LoadingShimmerWidgetState createState() => _LoadingShimmerWidgetState();
}

class _LoadingShimmerWidgetState extends State<LoadingShimmerWidget> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _enabled = true;

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
                  "Shimmer Loading",
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
                width: double.infinity,
                padding:  Spacing.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: customAppTheme.shimmerBaseColor,
                        highlightColor: customAppTheme.shimmerHighlightColor,
                        enabled: _enabled,
                        child: ListView.builder(
                          itemBuilder: (_, __) => Padding(
                            padding:  Spacing.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  color: Colors.white,
                                ),
                                 Padding(
                                  padding: Spacing.symmetric(horizontal: 8.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                       Padding(
                                        padding: Spacing.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                       Padding(
                                        padding: Spacing.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: 40.0,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          itemCount: 6,
                        ),
                      ),
                    ),
                    Padding(
                      padding:  Spacing.symmetric(vertical: 8.0),
                      child: FlatButton(
                          onPressed: () {
                            setState(() {
                              _enabled = !_enabled;
                            });
                          },
                          child: Text(
                            _enabled ? 'Stop' : 'Play',
                            style: Theme.of(context).textTheme.button.copyWith(
                                fontSize: 18.0,
                                color: _enabled ? Colors.redAccent : Colors.green),
                          )),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}