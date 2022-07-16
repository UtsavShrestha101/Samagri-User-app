
import 'package:UIKitIntegration/utils/SizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';
import 'Auth.dart';
import 'FirebaseLoginPage.dart';

class FirebaseRegisterPage extends StatefulWidget {
  @override
  _FirebaseRegisterPageState createState() => _FirebaseRegisterPageState();
}

class _FirebaseRegisterPageState extends State<FirebaseRegisterPage> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  OutlineInputBorder allTFBorder;
  bool showPassword = false;
  bool isRegisterInProgress=false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  initUI() {
    allTFBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(color: customAppTheme.bgLayer4, width: 1.5));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        int themeType = value.themeMode();
        themeData = AppTheme.getThemeFromThemeMode(themeType);
        customAppTheme = AppTheme.getCustomAppTheme(themeType);
        initUI();
        return SafeArea(
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.getThemeFromThemeMode(themeType),
              home: Scaffold(
                  key: _scaffoldKey,
                  body: Container(
                      color: customAppTheme.bgLayer1,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            /*
                            TODO: Add icon
                            Container(
                              child: Image.asset(
                                './assets/icons/food-outline.png',
                                color: themeData.colorScheme.primary,
                                width: 36,
                                height: 36,
                              ),
                            ),*/
                            Container(
                              margin: EdgeInsets.only(top: MySize.size24),
                              child: Text(
                                "Create account".toUpperCase(),
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.headline6,
                                    color: themeData.colorScheme.onBackground,
                                    fontWeight: 700,
                                    letterSpacing: 0.5),
                              ),
                            ),
                            Container(
                              margin: Spacing.fromLTRB(24, 16, 24, 0),
                              child: TextFormField(
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText1,
                                    letterSpacing: 0.1,
                                    color: themeData.colorScheme.onBackground,
                                    fontWeight: 500),
                                decoration: InputDecoration(
                                    hintText: "Email address",
                                    hintStyle: AppTheme.getTextStyle(
                                        themeData.textTheme.subtitle2,
                                        letterSpacing: 0.1,
                                        color:
                                        themeData.colorScheme.onBackground,
                                        fontWeight: 500),
                                    border: allTFBorder,
                                    enabledBorder: allTFBorder,
                                    focusedBorder: allTFBorder,
                                    prefixIcon: Icon(
                                      MdiIcons.emailOutline,
                                      size: MySize.size22,
                                    ),
                                    isDense: true,
                                    contentPadding: Spacing.zero),
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                              ),
                            ),
                            Container(
                              margin: Spacing.fromLTRB(24, 16, 24, 0),
                              child: TextFormField(
                                obscureText: showPassword,
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText1,
                                    letterSpacing: 0.1,
                                    color: themeData.colorScheme.onBackground,
                                    fontWeight: 500),
                                decoration: InputDecoration(
                                  hintStyle: AppTheme.getTextStyle(
                                      themeData.textTheme.subtitle2,
                                      letterSpacing: 0.1,
                                      color: themeData.colorScheme.onBackground,
                                      fontWeight: 500),
                                  hintText: "Password",
                                  border: allTFBorder,
                                  enabledBorder: allTFBorder,
                                  focusedBorder: allTFBorder,
                                  prefixIcon: Icon(
                                    MdiIcons.lockOutline,
                                    size: 22,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    child: Icon(
                                      showPassword
                                          ? MdiIcons.eyeOutline
                                          : MdiIcons.eyeOffOutline,
                                      size: MySize.size22,
                                    ),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(0),
                                ),
                                controller: _passwordController,
                              ),
                            ),
                            Container(
                                margin: Spacing.fromLTRB(24, 24, 24, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(MySize.size48)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: themeData.colorScheme.primary
                                            .withAlpha(100),
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 5), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            MySize.size8)),
                                    color: themeData.colorScheme.primary,
                                    highlightColor:
                                    themeData.colorScheme.primary,
                                    splashColor: Colors.white.withAlpha(100),
                                    padding: EdgeInsets.only(
                                        top: MySize.size16,
                                        bottom: MySize.size16),
                                    onPressed: () {
                                      if (!isRegisterInProgress) {
                                        registerUser();
                                      }
                                    },
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "CREATE",
                                            style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText2,
                                                color: themeData
                                                    .colorScheme.onPrimary,
                                                letterSpacing: 0.8,
                                                fontWeight: 700),
                                          ),
                                        ),
                                        Positioned(
                                          right: 16,
                                          child: isRegisterInProgress
                                              ? Container(
                                            width: MySize.size16,
                                            height: MySize.size16,
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                AlwaysStoppedAnimation<
                                                    Color>(
                                                    themeData
                                                        .colorScheme
                                                        .onPrimary),
                                                strokeWidth: 1.4),
                                          )
                                              : ClipOval(
                                            child: Container(
                                              color: themeData.colorScheme
                                                  .primaryVariant,
                                              // button color
                                              child: SizedBox(
                                                  width: MySize.size30,
                                                  height: MySize.size30,
                                                  child: Icon(
                                                    MdiIcons.arrowRight,
                                                    color: themeData
                                                        .colorScheme
                                                        .onPrimary,
                                                    size: MySize.size18,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            Container(
                              margin: EdgeInsets.only(top: MySize.size16),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FirebaseLoginPage()));
                                },
                                child: Text(
                                  "I have already an account",
                                  style: AppTheme.getTextStyle(
                                      themeData.textTheme.bodyText2,
                                      color: themeData.colorScheme.onBackground,
                                      fontWeight: 500,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            )
                          ],
                        ),
                      )))),
        );
      },
    );
  }

  void _startProgress() {
    setState(() {
      isRegisterInProgress = true;
    });
  }

  void _endProgress() {
    setState(() {
      isRegisterInProgress = false;
    });
  }

  void showSnack(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,color: themeData.colorScheme.onPrimary),
        ),
      ),
      backgroundColor: themeData.colorScheme.primary,
    ));
  }


  void registerUser() {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if(email.isEmpty){
      showSnack("Please fill email");
      return;
    }else if(!Auth.validateEmail(email)){
      showSnack("Please fill email proper");
      return;
    }else if(password.isEmpty){
      showSnack("Please fill password");
      return;
    }
    _startProgress();
    Auth auth = Auth();
    auth
        .signUp(email, password)
        .then((user) => {
          _endProgress(),
              if (user != null)
                {
                  showSnack("Register successfully"),
                }
              else
                {
                  showSnack("Something went wrong"),
                }
            })
        .catchError((error) => {
              _endProgress(),
              if (error.code == Auth.ERROR_EMAIL_ALREADY_IN_USE)
                {showSnack("Email address is already in use")}
              else if (error.code == Auth.ERROR_WEAK_PASSWORD)
                {showSnack("Password is weak")}
              else
                {
                  showSnack(error.code.toString()),
                }
            });

  }

  String validateName(String value) {
    if (value.isEmpty) return "Fill name";
    return null;
  }

  String validateEmail(String value) {
    if (value.isEmpty) return "Fill email";
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!emailValid) {
      return "Fill proper email";
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) return "Fill password";
    return null;
  }
}
