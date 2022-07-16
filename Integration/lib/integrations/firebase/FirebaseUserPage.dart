import 'package:UIKitIntegration/integrations/firebase/FirebaseLoginPage.dart';
import 'package:UIKitIntegration/utils/SizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';
import 'Auth.dart';
import 'FirebaseRegisterPage.dart';

class FirebaseUserPage extends StatefulWidget {
  @override
  _FirebaseUserPageState createState() => _FirebaseUserPageState();
}

class _FirebaseUserPageState extends State<FirebaseUserPage> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  String result = "Checking...";

  bool isLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFirebaseUser();
  }

  getFirebaseUser() async {
    Auth auth = Auth();
    FirebaseUser firebaseUser = await auth.getCurrentUser();

    setState(() {
      if (firebaseUser != null) {
        isLoggedIn = true;
        result = "User Logged in\nEmail - " + firebaseUser.email;
      } else {
        isLoggedIn = false;
        result = "User is not logged in";
      }
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
                      "Firebase User",
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.headline6,
                          color: themeData.colorScheme.onBackground,
                          fontWeight: 600),
                    )),
                body: Container(
                    padding: Spacing.fromLTRB(24, 24, 24, 0),
                    color: customAppTheme.bgLayer1,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            result,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText2,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500),
                          ),
                          Container(
                              margin: Spacing.top(16),
                              child: isLoggedIn
                                  ? FlatButton(
                                      onPressed: () {
                                        logout();
                                      },
                                      child: Text(
                                        "Logout",
                                        style: AppTheme.getTextStyle(
                                            themeData.textTheme.bodyText1,
                                            color:
                                                themeData.colorScheme.onPrimary,
                                            fontWeight: 500),
                                      ),
                                      color: themeData.colorScheme.primary,
                                    )
                                  : Column(
                                      children: [
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => FirebaseLoginPage()));
                                          },
                                          child: Text(
                                            "Login",
                                            style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                color: themeData
                                                    .colorScheme.onPrimary,
                                                fontWeight: 500),
                                          ),
                                          color: themeData.colorScheme.primary,
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => FirebaseRegisterPage()));

                                          },
                                          child: Text(
                                            "Register",
                                            style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                color: themeData
                                                    .colorScheme.onPrimary,
                                                fontWeight: 500),
                                          ),
                                          color: themeData.colorScheme.primary,
                                        ),
                                      ],
                                    ))
                        ],
                      ),
                    ))));
      },
    );
  }

  logout() async {
    Auth auth = Auth();
    await auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => FirebaseLoginPage()));

  }
}
