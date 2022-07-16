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

class ShoppingPageShimmerWidget extends StatefulWidget {
  final String refUrl;

  const ShoppingPageShimmerWidget({Key key, this.refUrl}) : super(key: key);

  @override
  _ShoppingPageShimmerWidgetState createState() =>
      _ShoppingPageShimmerWidgetState();
}

class _ShoppingPageShimmerWidgetState extends State<ShoppingPageShimmerWidget> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showProduct = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if(mounted) {
        setState(() {
          showProduct = true;
        });
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
                  "Shimmer Shopping View",
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
                  separatorBuilder: (BuildContext context, int position) {
                    return Divider(
                      height: 1,
                    );
                  },
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int position) {
                    return showProduct
                        ? _createProductView(position)
                        : _shimmerEffect();
                  },
                ),
              ),
            ));
      },
    );
  }

  Widget _shimmerEffect() {
    return Shimmer.fromColors(
        baseColor: customAppTheme.shimmerBaseColor,
        highlightColor: customAppTheme.shimmerHighlightColor,
        child: Container(
          padding: Spacing.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                  height: 80,
                  padding: Spacing.fromLTRB(16, 8, 0, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        height: 8,
                        color: Colors.white,
                        width: double.infinity,
                      ),
                      Container(
                        height: 8,
                        color: Colors.white,
                        width: double.infinity,
                      ),
                      Container(
                        height: 8,
                        color: Colors.white,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
       );
  }

  Widget _createProductView(int index) {
    return Container(
      padding: Spacing.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage("assets/products/product-1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 80,
              padding: Spacing.fromLTRB(16, 8, 0, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "Cosmic GS430 Gaming",
                    style: AppTheme.getTextStyle(themeData.textTheme.subtitle1,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 500),
                  ),
                  Text(
                    "Price \$$index",
                    style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 500),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        MdiIcons.star,
                        color: Colors.yellow,
                        size: MySize.size20,
                      ),
                      Icon(
                        MdiIcons.star,
                        color: Colors.yellow,
                        size: MySize.size20,
                      ),
                      Icon(
                        MdiIcons.star,
                        color: Colors.yellow,
                        size: MySize.size20,
                      ),
                      Icon(
                        MdiIcons.star,
                        color: Colors.yellow,
                        size: MySize.size20,
                      ),
                      Icon(
                        MdiIcons.starHalfFull,
                        color: Colors.yellow,
                        size: MySize.size20,
                      ),
                      Container(
                        padding: Spacing.only(left: 8),
                        child: Text(
                          "18504",
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.caption,
                              fontWeight: 400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

