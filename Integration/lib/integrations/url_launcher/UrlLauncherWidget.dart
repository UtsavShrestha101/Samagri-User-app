/*
*  (This is Official Flutter plugin).
* */

/*
 * For Flutter
 * - Add dependencies to pubspec.yaml for Url Laucher
 * - run command "flutter pub get"
 * make sure after run this command you need to re run application.
 * don't use hot reload whenever you adding some dependency.
*/

/* For Android & iOS
 * Reference : https://pub.dev/packages/url_launcher
 * There is no config required
 */

/*
* Make sure all steps you follow as references
* */

import 'dart:io';
import 'package:UIKitIntegration/integrations/request/api_util.dart';
import 'package:UIKitIntegration/utils/Generator.dart';
import 'package:UIKitIntegration/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';

class UrlLauncherWidget extends StatefulWidget {
  final String refUrl;

  const UrlLauncherWidget({Key key, this.refUrl}) : super(key: key);

  @override
  _UrlLauncherWidgetState createState() => _UrlLauncherWidgetState();
}

class _UrlLauncherWidgetState extends State<UrlLauncherWidget> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;

  String url = "http://flutter.dev";
  String mailUrl = "mailto:mail@example.org?subject=Email Test&body=From,\nFlutKit";
  String callUrl = "tel:+1 555 010 999";
  String smsUrl = "sms:5550101234";
  String youtubeUrl = "https://www.youtube.com";

  goToUrl(String url) async {
    if (await canLaunch(url) != null) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
                  "URL Launcher",
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: Spacing.top(16),
                        child: FlatButton(
                          padding: Spacing.fromLTRB(16, 12, 16, 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          color: themeData.colorScheme.primary,
                          highlightColor: themeData.colorScheme.primary,
                          splashColor: Colors.white.withAlpha(100),
                          onPressed: () {
                            goToUrl(url);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                MdiIcons.web,
                                color: themeData.colorScheme.onPrimary,
                              ),
                              Container(
                                margin: Spacing.left(16),
                                child: Text("Go To URL",
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText2,
                                        fontWeight: 600,
                                        color: themeData.colorScheme.onPrimary,
                                        letterSpacing: 0.5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: Spacing.top(16),
                        child: FlatButton(
                          padding: Spacing.fromLTRB(16, 12, 16, 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          color: themeData.colorScheme.primary,
                          highlightColor: themeData.colorScheme.primary,
                          splashColor: Colors.white.withAlpha(100),
                          onPressed: () {
                            goToUrl(mailUrl);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                MdiIcons.emailOutline,
                                color: themeData.colorScheme.onPrimary,
                              ),
                              Container(
                                margin: Spacing.left(16),
                                child: Text("Mail Me",
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText2,
                                        fontWeight: 600,
                                        color: themeData.colorScheme.onPrimary,
                                        letterSpacing: 0.5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: Spacing.top(16),
                        child: FlatButton(
                          padding: Spacing.fromLTRB(16, 12, 16, 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          color: themeData.colorScheme.primary,
                          highlightColor: themeData.colorScheme.primary,
                          splashColor: Colors.white.withAlpha(100),
                          onPressed: () {
                            goToUrl(callUrl);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                MdiIcons.phoneOutline,
                                color: themeData.colorScheme.onPrimary,
                              ),
                              Container(
                                margin: Spacing.left(16),
                                child: Text("Call Me",
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText2,
                                        fontWeight: 600,
                                        color: themeData.colorScheme.onPrimary,
                                        letterSpacing: 0.5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: Spacing.top(16),
                        child: FlatButton(
                          padding: Spacing.fromLTRB(16, 12, 16, 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          color: themeData.colorScheme.primary,
                          highlightColor: themeData.colorScheme.primary,
                          splashColor: Colors.white.withAlpha(100),
                          onPressed: () {
                            goToUrl(smsUrl);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                MdiIcons.chatOutline,
                                color: themeData.colorScheme.onPrimary,
                              ),
                              Container(
                                margin: Spacing.left(16),
                                child: Text("SMS Me",
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText2,
                                        fontWeight: 600,
                                        color: themeData.colorScheme.onPrimary,
                                        letterSpacing: 0.5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: Spacing.top(16),
                        child: FlatButton(
                          padding: Spacing.fromLTRB(16, 12, 16, 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          color: themeData.colorScheme.primary,
                          highlightColor: themeData.colorScheme.primary,
                          splashColor: Colors.white.withAlpha(100),
                          onPressed: () {
                            goToUrl(youtubeUrl);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                MdiIcons.youtube,
                                color: themeData.colorScheme.onPrimary,
                              ),
                              Container(
                                margin: Spacing.left(16),
                                child: Text("Open Youtube",
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText2,
                                        fontWeight: 600,
                                        color: themeData.colorScheme.onPrimary,
                                        letterSpacing: 0.5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
