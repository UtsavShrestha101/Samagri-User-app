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
 * There is no any configuration
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

class PostShimmerWidget extends StatefulWidget {
  final String refUrl;

  const PostShimmerWidget({Key key, this.refUrl}) : super(key: key);

  @override
  _PostShimmerWidgetState createState() => _PostShimmerWidgetState();
}

class _PostShimmerWidgetState extends State<PostShimmerWidget> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showPost = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //If you using real life then make it uncomment
    /*Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showPost = true;
      });
    });*/


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
                  "Shimmer Post",
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
                  child: ListView.separated(
                      itemBuilder: (BuildContext context, int position) {
                        return showPost
                            ? _createPost()
                            : _createShimmerEffect();
                      },
                      separatorBuilder: (BuildContext context, int position) {
                        return Divider(
                          height: 1,
                        );
                      },
                      itemCount: 3)),
            ));
      },
    );
  }


  Widget _createShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: customAppTheme.shimmerBaseColor,
      highlightColor: customAppTheme.shimmerHighlightColor,
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: Spacing.fromLTRB(8, 12, 8, 4),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.white,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8, 8, 4, 12),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(2),
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            padding: EdgeInsets.all(2),
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40),
                            padding: EdgeInsets.all(2),
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.only(left: 4),
                            child: Container(
                              color: Colors.white,
                              height: 8,
                              width: 48,
                            )),
                      ),
                      Icon(
                        MdiIcons.dotsVertical,
                        color: themeData.colorScheme.onBackground,
                        size: MySize.size24,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 4),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          color: Colors.white,
                          height: 8,
                          width: double.infinity,
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createPost() {
    //Your after loading widget
    return Container();
  }
}
