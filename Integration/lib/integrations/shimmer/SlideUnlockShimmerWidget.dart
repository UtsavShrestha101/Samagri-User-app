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

import 'package:UIKitIntegration/utils/Generator.dart';
import 'package:UIKitIntegration/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';


class SlideUnlockShimmerWidget extends StatefulWidget {
  final String refUrl;

  const SlideUnlockShimmerWidget({Key key, this.refUrl}) : super(key: key);

  @override
  _SlideUnlockShimmerWidgetState createState() => _SlideUnlockShimmerWidgetState();
}

class _SlideUnlockShimmerWidgetState extends State<SlideUnlockShimmerWidget> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final List<String> days = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  final List<String> months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final DateTime time = DateTime.now();
    final int hour = time.hour;
    final int minute = time.minute;
    final int day = time.weekday;
    final int month = time.month;
    final int dayInMonth = time.day;

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
                  "Shimmer Slide Unlock",
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 48.0,
                      right: 0.0,
                      left: 0.0,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${hour < 10 ? '0$hour' : '$hour'}:${minute < 10 ? '0$minute' : '$minute'}',
                              style: TextStyle(
                                fontSize: 60.0,
                                color: Colors.white,
                              ),
                            ),
                             Padding(
                              padding: Spacing.symmetric(vertical: 4.0),
                            ),
                            Text(
                              '${days[day - 1]}, ${months[month - 1]} $dayInMonth',
                              style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                                  color: themeData.colorScheme.onBackground,
                                  fontWeight: 500),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 24.0,
                        left: 0.0,
                        right: 0.0,
                        child: Center(
                          child: Opacity(
                            opacity: 0.8,
                            child: Shimmer.fromColors(
                              baseColor: customAppTheme.shimmerBaseColor,
                              highlightColor: customAppTheme.shimmerHighlightColor,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    MdiIcons.chevronDoubleRight,
                                    color: themeData.colorScheme.onBackground,
                                    size: MySize.size36,
                                  ),
                                  Text(
                                    'Slide to unlock',
                                    style: AppTheme.getTextStyle(themeData.textTheme.headline5,
                                        color: themeData.colorScheme.onBackground,
                                        fontWeight: 500),
                                  )
                                ],
                              ),

                              loop: 5,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ));
      },
    );
  }
}
