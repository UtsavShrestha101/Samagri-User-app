/*
 * For Flutter
 * - Add dependencies to pubspec.yaml for quick shortcuts
 * - run command "flutter pub get"
 * make sure after run this command you need to re run application.
 * don't use hot reload whenever you adding some dependency.
*/

/* For Android & iOS
 * Reference : https://pub.dev/packages/quick_actions
 * Nothing to config for both platforms
 */

/*
* Make sure all steps you follow as references
* */


import 'package:UIKitIntegration/integrations/firebase/FirebaseLoginPage.dart';
import 'package:UIKitIntegration/utils/Generator.dart';
import 'package:UIKitIntegration/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';

class QuickActionsWidget extends StatefulWidget {
  final String refUrl;

  const QuickActionsWidget({Key key, this.refUrl}) : super(key: key);

  @override
  _QuickActionsWidgetState createState() => _QuickActionsWidgetState();
}

class _QuickActionsWidgetState extends State<QuickActionsWidget> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String shortcut;
  QuickActions quickActions;

  @override
  void initState() {
    super.initState();
    quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      print(shortcutType);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FirebaseLoginPage()));
    });
  }

  createShortcuts() async {

    await quickActions.setShortcutItems(<ShortcutItem>[
      // NOTE: This first action icon will only work on iOS.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
        type: 'action_one',
        localizedTitle: 'Login',
        icon: 'AppIcon',
      ),
      // NOTE: This second action icon will only work on Android.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
          type: 'action_two',
          localizedTitle: 'Register',
          icon: 'ic_launcher'),
    ]);

    showSnack('Shortcut is created');

  }

  deleteShortcuts() async{
    await quickActions.clearShortcutItems();
    showSnack('Shortcut is deleted');
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
                  "Quick Actions",
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
                margin: Spacing.all(24),
                child:  Column(
                        children: [
                          Text(
                              "When shortcut is created then go to app icon and press to see all shortcuts."),
                          Container(
                            margin: Spacing.top(16),
                            child: FlatButton(
                              color: themeData.colorScheme.primary,
                              child: Text(
                                'Create Shortcut',
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText2,
                                    color: themeData.colorScheme.onPrimary),
                              ),
                              onPressed: createShortcuts,
                            ),
                          ),
                          Container(
                            margin: Spacing.top(16),
                            child: FlatButton(
                              color: themeData.colorScheme.primary,
                              child: Text(
                                'Delete Shortcut',
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText2,
                                    color: themeData.colorScheme.onPrimary),
                              ),
                              onPressed: deleteShortcuts,
                            ),
                          ),
                        ],
                      ),
              ),
            ));
      },
    );
  }

  void showSnack(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
              color: themeData.colorScheme.onPrimary),
        ),
      ),
      backgroundColor: themeData.colorScheme.primary,
    ));
  }
}
