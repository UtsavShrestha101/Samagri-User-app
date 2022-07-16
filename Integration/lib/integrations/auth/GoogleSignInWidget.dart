/*
 * For Flutter
 * - Add dependencies to pubspec.yaml for google signin
 * - run command "flutter pub get"
 * make sure after run this command you need to re run application.
 * don't use hot reload whenever you adding some dependency.
*/

/*
* Make sure you have already created firebase project and add files as google-services files into projects.
* */

/* For Android
 * Reference : https://pub.dev/packages/google_sign_in
 * You need google-services.json file
 */

/* For iOS
 * Reference : https://pub.dev/packages/google_sign_in
 * You need GoogleService-Info.plist file
 * There is some code add into ../ios/Runner/Info.plist file
 */

/*
* Make sure all steps you follow as references
* */

import 'package:UIKitIntegration/utils/Generator.dart';
import 'package:UIKitIntegration/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';

class GoogleSignInWidget extends StatefulWidget {
  final String refUrl;

  const GoogleSignInWidget({Key key, this.refUrl}) : super(key: key);

  @override
  _GoogleSignInWidgetState createState() => _GoogleSignInWidgetState();
}

class _GoogleSignInWidgetState extends State<GoogleSignInWidget> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {}
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    if (_currentUser != null) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ListTile(
              leading: GoogleUserCircleAvatar(
                identity: _currentUser,
              ),
              title: Text(_currentUser.displayName ?? ''),
              subtitle: Text(_currentUser.email ?? ''),
            ),
            Text(
              "Signed in successfully.",
              style: AppTheme.getTextStyle(
                themeData.textTheme.bodyText2,
                color: themeData.colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            FlatButton(
              color: themeData.colorScheme.primary,
              child: Text(
                'SIGN OUT',
                style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                    color: themeData.colorScheme.onPrimary),
              ),
              onPressed: _handleSignOut,
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "You are not currently signed in.",
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                  color: themeData.colorScheme.onBackground),
              textAlign: TextAlign.center,
            ),
            FlatButton(
              color: themeData.colorScheme.primary,
              child: Text(
                'SIGN IN',
                style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                    color: themeData.colorScheme.onPrimary),
              ),
              onPressed: _handleSignIn,
            ),
          ],
        ),
      );
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
                  "Google signin",
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
              body: _buildBody(),
            ));
      },
    );
  }
}
