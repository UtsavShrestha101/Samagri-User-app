import 'package:UIKitIntegration/integrations/request/api_util.dart';
import 'package:UIKitIntegration/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';

class GETRequestPage extends StatefulWidget {
  @override
  _GETRequestPageState createState() => _GETRequestPageState();
}

class _GETRequestPageState extends State<GETRequestPage> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoginInProgress = false;

  String result="";
  String statusCode="";

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
                  "GET Request",
                  style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 600),
                ),
              ),
              body: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
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
                                borderRadius:
                                    BorderRadius.circular(MySize.size8)),
                            color: themeData.colorScheme.primary,
                            highlightColor: themeData.colorScheme.primary,
                            splashColor: Colors.white.withAlpha(100),
                            padding: EdgeInsets.only(
                                top: MySize.size16, bottom: MySize.size16),
                            onPressed: () {
                              if (!isLoginInProgress) {
                                getRequest();
                              }
                            },
                            child: Stack(
                              overflow: Overflow.visible,
                              alignment: Alignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Request",
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText2,
                                        color:
                                            themeData.colorScheme.onPrimary,
                                        letterSpacing: 0.8,
                                        fontWeight: 700),
                                  ),
                                ),
                                Positioned(
                                  right: 16,
                                  child: isLoginInProgress
                                      ? Container(
                                          width: MySize.size16,
                                          height: MySize.size16,
                                          child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<
                                                          Color>(
                                                      themeData.colorScheme
                                                          .onPrimary),
                                              strokeWidth: 1.4),
                                        )
                                      : ClipOval(
                                          child: Container(
                                            color: themeData
                                                .colorScheme.primaryVariant,
                                            // button color
                                            child: SizedBox(
                                                width: MySize.size30,
                                                height: MySize.size30,
                                                child: Icon(
                                                  MdiIcons.arrowRight,
                                                  color: themeData
                                                      .colorScheme.onPrimary,
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
                      margin: Spacing.fromLTRB(24, 24, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status code - " + statusCode,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText2,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500,
                                letterSpacing: 0),
                          ),
                          Text(
                            "Result - " + result,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText2,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500,
                                letterSpacing: 0),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }

  getRequest() async {
    setState(() {
      isLoginInProgress = true;
    });

    Response response = await ApiUtil.makeGetRequest();

    setState(() {
      statusCode = response.statusCode.toString();
      result = response.body;
      isLoginInProgress = false;
    });
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
