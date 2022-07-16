/*
* File : Single Grid Item
* Version : 1.0.0
* */

import 'package:UIKitIntegration/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AppTheme.dart';

class SingleGridItem extends StatefulWidget {
  final String title;
  final String icon;
  final List<SinglePageItem> items;
  final bool isComingSoon;
  final String comingSoonText;
  final String refUrl;

  const SingleGridItem({
    Key key,
    @required this.title,
    @required this.items,
    this.icon,
    this.isComingSoon = false,
    this.comingSoonText = "",
    this.refUrl,
  }) : super(key: key);

  @override
  _SingleGridItemState createState() => _SingleGridItemState();
}

class _SingleGridItemState extends State<SingleGridItem> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    String assetName;
    if (widget.icon == null) {
      assetName = 'assets/icons/rocket-outline.png';
    } else {
      assetName = widget.icon;
    }

    Widget iconWidget = Image.asset(
      assetName,
      color: themeData.colorScheme.primary,
      width: 36,
      height: 36,
    );

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SinglePageHome(
                      title: widget.title,
                      items: widget.items,
                      comingSoonText: widget.comingSoonText,
                      isComingSoon: widget.isComingSoon,
                      refUrl: widget.refUrl,
                    )));
      },
      child: Container(
        decoration: new BoxDecoration(
          color: themeData.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          border: Border.all(width: 1.2, color: themeData.colorScheme.surface),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              iconWidget,
              Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Text(widget.title,
                      style: AppTheme.getTextStyle(
                        themeData.textTheme.bodyText1,
                        fontWeight: 500,
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

class SinglePageItem extends StatelessWidget {
  final String title, icon;
  final Widget navigation;

  const SinglePageItem({
    Key key,
    @required this.title,
    @required this.navigation,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    String assetName;
    if (icon == null) {
      assetName = 'assets/icons/rocket-outline.png';
    } else {
      assetName = icon;
    }

    Widget iconWidget = Image.asset(
      assetName,
      color: themeData.colorScheme.primary,
      width: 36,
      height: 36,
    );
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navigation));
      },
      child: Container(
        decoration: new BoxDecoration(
          color: themeData.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          border: Border.all(width: 1.2, color: themeData.colorScheme.surface),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              iconWidget,
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Text(
                  title,
                  style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                      fontWeight: 500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SinglePageHome extends StatefulWidget {
  final List<SinglePageItem> items;
  final String title;
  final bool isComingSoon;
  final String comingSoonText;
  final String refUrl;

  const SinglePageHome(
      {Key key,
      @required this.items,
      @required this.title,
      this.isComingSoon = true,
      this.comingSoonText = "",
      this.refUrl})
      : super(key: key);

  @override
  _SinglePageHomeState createState() => _SinglePageHomeState();
}

class _SinglePageHomeState extends State<SinglePageHome> {
  ThemeData themeData;


  _launchURL() async {
    String url = widget.refUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.appBarTheme.color,
        title: Text(widget.title,
            style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                fontWeight: 600)),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            MdiIcons.chevronLeft,
            color: themeData.colorScheme.onBackground,
          ),
        ),
        actions: widget.refUrl != null
            ? [
                InkWell(
                  onTap: (){
                    _launchURL();
                  },
                  child: Icon(
                    MdiIcons.codeBraces,
                    color: themeData.colorScheme.onBackground,
                    size: MySize.size24,
                  ),
                )
              ]
            : [],
      ),
      body: Container(
        color: themeData.colorScheme.background,
        height: MySize.safeHeight,
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            GridView.count(
              crossAxisCount: 2,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              padding:
                  EdgeInsets.only(top: 16, left: 12, right: 12, bottom: 16),
              mainAxisSpacing: 16.0,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 16.0,
              children: widget.items,
            ),
            widget.isComingSoon
                ? Container(
                    margin: Spacing.top(8),
                    child: Center(
                      child: Text(
                        widget.comingSoonText,
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.subtitle2,
                            color: themeData.colorScheme.onBackground,
                            fontWeight: 500),
                      ),
                    ))
                : Container()
          ],
        ),
      ),
    );
  }
}
