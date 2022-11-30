import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/controller/category_tag_controller.dart';
import 'package:myapp/db/db_helper.dart';
import 'package:myapp/models/recommendation_history_model.dart';
import 'package:myapp/screens/dashboard_screen/shopping_notification_screen.dart';
import 'package:myapp/screens/dashboard_screen/shopping_search_product_screen.dart';
import 'package:myapp/services/current_location/get_current_location.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_category_context.dart';
import 'package:myapp/widget/our_shimmer_widget.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:page_transition/page_transition.dart';
import '../../models/category_model.dart';
import '../../models/lat_long_controller.dart';
import '../../services/network_connection/network_connection.dart';
import '../../widget/our_all_content.dart';
import '../../widget/our_carousel_slider.dart';
import 'package:scroll_to_id/scroll_to_id.dart';

import '../../widget/our_recommendation_widget.dart';

class ShoppingHomeScreen extends StatefulWidget {
  const ShoppingHomeScreen({Key? key}) : super(key: key);

  @override
  _ShoppingHomeScreenState createState() => _ShoppingHomeScreenState();
}

class _ShoppingHomeScreenState extends State<ShoppingHomeScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _search_controller = TextEditingController();
  String category = "All";
  final scrollController = ScrollController();
  final items = [
    "All",
    "Grocery",
    "Electronic",
    "Beverage",
    "Personal care",
    "Fashain and apparel",
    "Baby care",
    "Bakery and dairy",
    "Eggs and meat",
    "Household items",
    "Kitchen and pet food",
    "Vegetable and fruits",
    "Beauty",
  ];

  late Tween<Offset> offset;
  int tag = 0;
  List<Placemark>? placeMarks;
  late AnimationController animationController;
  late AnimationController logoanimationController;
  late Animation<double> bellAnimation;
  late Animation<double> logoAnimation;
  late ScrollToId scrollToId;
  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // print(scrollToId.idPosition());
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Get.find<CheckConnectivity>().initialize();

    showIntroData();
    Get.find<CategoryTagController>().initialize();
    animationController = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );
    bellAnimation = Tween<double>(begin: -0.04, end: 0.04).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );
    scrollToId = ScrollToId(scrollController: scrollController);
    scrollController.addListener(_scrollListener);

    logoAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );
    animationController.repeat(reverse: true);
  }

  Future<void> showIntroData() async {
    await Future.delayed(
      Duration(
        seconds: 1,
      ),
    ).then((value) async {
      if (Hive.box<int>(DatabaseHelper.introHelperDB)
              .get("state", defaultValue: 0) ==
          0) {
        print(Hive.box<int>(DatabaseHelper.introHelperDB).get("state"));
        await Future.delayed(Duration(seconds: 3)).then((value) {
          Intro.of(context).start();

          print("Hello Utsav");
        });
        print("First Time");
        await Hive.box<int>(DatabaseHelper.introHelperDB).put("state", 1);
      } else {
        print(Hive.box<int>(DatabaseHelper.introHelperDB).get("state"));
        print("Already done");
      }
    });
    Position? position = await GetCurrentLocation().getCurrentLocation();
    if (position != null) {
      print(position);
      placeMarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Get.find<LatLongController>()
          .changeLocation(position.latitude, position.longitude);
      Placemark pMark = placeMarks![1];
      print(pMark);
      String completeAddress =
          "${pMark.subLocality}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ";
      print(completeAddress);
      await Hive.box<String>(DatabaseHelper.nearbylocationDB)
          .put("state", completeAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        // drawer: Container(
        //   width: MediaQuery.of(context).size.width * 0.75,
        //   child: Drawer(),
        // ),
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveScrollViewer(
              scrollToId: scrollToId,
              children: [
                ScrollContent(
                  id: "id",
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setSp(7.5),
                      ),
                    ),
                    height: ScreenUtil().setSp(40),
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setSp(2.5),
                      left: ScreenUtil().setSp(10),
                      right: ScreenUtil().setSp(10),
                    ),
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setSp(10),
                      right: ScreenUtil().setSp(10),
                      left: ScreenUtil().setSp(10),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: ScreenUtil().setSp(12.5),
                        ),
                        Expanded(
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RotationTransition(
                                  turns: logoAnimation,
                                  child: Image.asset(
                                    "assets/images/logo.png",
                                    height: ScreenUtil().setSp(22.5),
                                    width: ScreenUtil().setSp(22.5),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setSp(7.5),
                                ),
                                Text(
                                  "Samagri",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: ScreenUtil().setSp(20.5),
                                    color: darklogoColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IntroStepBuilder(
                          order: 1,
                          text: 'Explore products here',
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              ScreenUtil().setSp(50),
                            ),
                          ),
                          builder: (context, key) => InkWell(
                            key: key,
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ShoppingSearchProductScreen(),
                                  type: PageTransitionType.leftToRight,
                                ),
                              );
                            },
                            child: Icon(
                              FeatherIcons.search,
                              color: logoColor,
                              size: ScreenUtil().setSp(22.5),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setSp(12.5),
                        ),
                        IntroStepBuilder(
                          order: 2,
                          text: 'Get your notifications from here',
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              ScreenUtil().setSp(50),
                            ),
                          ),
                          builder: (context, key) => InkWell(
                            key: key,
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ShoppingNotificationScreen(),
                                  type: PageTransitionType.leftToRight,
                                ),
                              );
                            },
                            child: RotationTransition(
                              turns: bellAnimation,
                              child: Icon(
                                FeatherIcons.bell,
                                color: logoColor,
                                size: ScreenUtil().setSp(22.5),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setSp(12.5),
                        ),
                      ],
                    ),
                  ),
                ),
                ScrollContent(
                  id: "Utsav1",
                  child: OurSizedBox(),
                ),
                ScrollContent(
                  id: "id1",
                  child: IntroStepBuilder(
                    order: 3,
                    text: 'Product priority based on location',
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        ScreenUtil().setSp(25),
                      ),
                    ),
                    builder: (context, key) => Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setSp(10),
                      ),
                      child: InkWell(
                        key: key,
                        onTap: () {},
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              FeatherIcons.mapPin,
                              color: logoColor,
                              size: ScreenUtil().setSp(20.5),
                            ),
                            SizedBox(
                              width: ScreenUtil().setSp(12.5),
                            ),
                            Text(
                              "Nearby:",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(17.5),
                                fontWeight: FontWeight.w700,
                                color: darklogoColor,
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setSp(12.5),
                            ),
                            ValueListenableBuilder(
                              valueListenable: Hive.box<String>(
                                      DatabaseHelper.nearbylocationDB)
                                  .listenable(),
                              builder: (context, Box<String> boxs, child) {
                                String value = boxs.get("state",
                                    defaultValue: "Select location")!;
                                print("===========");
                                print(value);
                                print("===========");
                                return Expanded(
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(15),
                                      fontWeight: FontWeight.w500,
                                      color: logoColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ScrollContent(
                  id: "Utsav2",
                  child: OurSizedBox(),
                ),
                ScrollContent(
                  id: "id2",
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setSp(10),
                    ),
                    child: OurCarousel(),
                  ),
                ),
                ScrollContent(
                  id: "Utsav3",
                  child: OurSizedBox(),
                ),
                ScrollContent(
                  id: "id3",
                  child: IntroStepBuilder(
                    order: 4,
                    text: 'Get category wise products here',
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        ScreenUtil().setSp(25),
                      ),
                    ),
                    builder: (context, key) => Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setSp(
                          10,
                        ),
                      ),
                      child: SizedBox(
                        key: key,
                        height: ScreenUtil().setSp(50),
                        child: AnimationLimiter(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: Duration(milliseconds: 700),
                                    child: SlideAnimation(
                                      horizontalOffset:
                                          MediaQuery.of(context).size.width,
                                      child: FadeInAnimation(
                                        child: Obx(
                                          () => InkWell(
                                            onTap: () {
                                              if (index == 0) {
                                                Get.find<
                                                        CategoryTagController>()
                                                    .changeTag(0, "All");
                                                scrollToId.animateTo(
                                                  "All",
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease,
                                                );
                                              } else {
                                                Get.find<
                                                        CategoryTagController>()
                                                    .changeTag(
                                                  index,
                                                  items[index],
                                                );
                                                scrollToId.animateTo(
                                                  items[index],
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease,
                                                );
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  ScreenUtil().setSp(
                                                    20,
                                                  ),
                                                ),
                                                color: index ==
                                                        Get.find<
                                                                CategoryTagController>()
                                                            .tag
                                                            .value
                                                    ? logoColor
                                                        .withOpacity(0.45)
                                                    : Colors.grey
                                                        .withOpacity(0.4),
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    ScreenUtil().setSp(2),
                                                vertical: ScreenUtil().setSp(2),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    ScreenUtil().setSp(5),
                                                vertical: ScreenUtil().setSp(5),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  items[index],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: ScreenUtil()
                                                        .setSp(13.5),
                                                    color: index ==
                                                            Get.find<
                                                                    CategoryTagController>()
                                                                .tag
                                                                .value
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                })),
                      ),
                    ),
                  ),
                ),
                // ScrollContent(
                //   id: "id3",
                //   child: IntroStepBuilder(
                //     order: 4,
                // text: 'Get category wise products here',
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(
                //         ScreenUtil().setSp(25),
                //       ),
                //     ),
                //     builder: (context, key) => Container(
                //       margin: EdgeInsets.symmetric(
                //         horizontal: ScreenUtil().setSp(
                //           10,
                //         ),
                //       ),
                //       child: SizedBox(
                //         key: key,
                //         height: ScreenUtil().setSp(100),
                //         child: AnimationLimiter(
                //           child: StreamBuilder<QuerySnapshot>(
                //             stream: FirebaseFirestore.instance
                //                 .collection("category")
                //                 // .orderBy("timestamp", descending: true)
                //                 .snapshots(),
                //             builder: (BuildContext context,
                //                 AsyncSnapshot<QuerySnapshot> snapshot) {
                //               if (snapshot.hasData) {
                //                 if (snapshot.data!.docs.length > 0) {
                //                   return ListView.builder(
                //                     scrollDirection: Axis.horizontal,
                //                     shrinkWrap: true,
                //                     itemCount: snapshot.data!.docs.length + 1,
                //                     itemBuilder: (context, indexxxx) {
                //                       if (indexxxx == 0) {
                //                         return Obx(
                //                           () => InkWell(
                // onTap: () {
                //   if (indexxxx == 0) {
                //     Get.find<
                //             CategoryTagController>()
                //         .changeTag(0, "All");
                //     scrollToId.animateTo(
                //       "All",
                //       duration: Duration(
                //           milliseconds: 500),
                //       curve: Curves.ease,
                //     );
                //   }
                // },
                //                             child: Container(
                //                               decoration: BoxDecoration(
                //                                 borderRadius:
                //                                     BorderRadius.circular(
                //                                   ScreenUtil().setSp(
                //                                     20,
                //                                   ),
                //                                 ),
                //                                 color: indexxxx ==
                //                                         Get.find<
                //                                                 CategoryTagController>()
                //                                             .tag
                //                                             .value
                //                                     ? darklogoColor
                //                                         .withOpacity(0.45)
                //                                     : Colors.grey
                //                                         .withOpacity(0.4),
                //                               ),
                //                               margin: EdgeInsets.symmetric(
                //                                 horizontal:
                //                                     ScreenUtil().setSp(5),
                //                                 vertical: ScreenUtil().setSp(5),
                //                               ),
                //                               padding: EdgeInsets.symmetric(
                //                                 horizontal:
                //                                     ScreenUtil().setSp(5),
                //                                 vertical: ScreenUtil().setSp(5),
                //                               ),
                //                               child: Column(
                //                                 children: [
                //                                   Spacer(),
                //                                   ClipRRect(
                //                                     borderRadius:
                //                                         BorderRadius.all(
                //                                       Radius.circular(
                //                                         ScreenUtil().setSp(2),
                //                                       ),
                //                                     ),
                //                                     child: Image.network(
                //                                       "https://firebasestorage.googleapis.com/v0/b/ride-sharing-app-1.appspot.com/o/all.jpg?alt=media&token=9465b073-1ea0-44fc-8ee2-4f624c54e9a4",
                //                                       height: ScreenUtil()
                //                                           .setSp(45),
                //                                       width: ScreenUtil()
                //                                           .setSp(45),
                //                                       fit: BoxFit.fill,
                //                                     ),

                //                                     // CachedNetworkImage(
                //                                     //   height: ScreenUtil()
                //                                     //       .setSp(45),
                //                                     //   width: ScreenUtil()
                //                                     //       .setSp(45),
                //                                     //   fit: BoxFit.fill,
                //                                     //   imageUrl:
                //                                     //       "https://firebasestorage.googleapis.com/v0/b/ride-sharing-app-1.appspot.com/o/all.jpg?alt=media&token=9465b073-1ea0-44fc-8ee2-4f624c54e9a4",
                //                                     //   placeholder:
                //                                     //       (context, url) =>
                //                                     //           Image.asset(
                //                                     //     "assets/images/placeholder.png",
                //                                     //     height: ScreenUtil()
                //                                     //         .setSp(45),
                //                                     //     width: ScreenUtil()
                //                                     //         .setSp(45),
                //                                     //     // width: ScreenUtil().setSp(150),
                //                                     //   ),
                //                                     // ),
                //                                   ),
                //                                   SizedBox(
                //                                     height:
                //                                         ScreenUtil().setSp(5),
                //                                   ),
                //                                   Text(
                //                                     "All",
                //                                     style: TextStyle(
                //                                       fontSize: ScreenUtil()
                //                                           .setSp(15),
                //                                       color: logoColor,
                //                                       fontWeight:
                //                                           FontWeight.w500,
                //                                     ),
                //                                   ),
                //                                   Spacer(
                //                                       // flex: 2,
                //                                       ),
                //                                 ],
                //                               ),
                //                             ),
                //                           ),
                //                         );
                //                       }

                //                       // else {
                //                       //   CategoryModel categoryModel =
                //                       //       CategoryModel.fromMap(snapshot
                //                       //           .data!.docs[indexxxx - 1]);

                //                       //   return AnimationConfiguration
                //                       //       .staggeredList(
                // position: indexxxx,
                // duration: Duration(milliseconds: 00),
                //                       //     child: SlideAnimation(
                //                       //       horizontalOffset:
                //                       //           MediaQuery.of(context)
                //                       //               .size
                //                       //               .width,
                //                       //       child: FadeInAnimation(
                //                       //         child: Container(
                // margin: EdgeInsets.symmetric(
                //   horizontal:
                //       ScreenUtil().setSp(2.5),
                //   vertical:
                //       ScreenUtil().setSp(2.5),
                // ),
                //                       //           child: Obx(
                //                       //             () => InkWell(
                //                       //               onTap: () {
                //                       //                 if (indexxxx == 0) {
                //                       //                   Get.find<
                //                       //                           CategoryTagController>()
                //                       //                       .changeTag(
                //                       //                           0, "All");
                //                       //                   scrollToId.animateTo(
                //                       //                     "All",
                //                       //                     duration: Duration(
                //                       //                         milliseconds:
                //                       //                             500),
                //                       //                     curve: Curves.ease,
                //                       //                   );
                //                       //                 } else {
                //                       //                   Get.find<
                //                       //                           CategoryTagController>()
                //                       //                       .changeTag(
                //                       //                     indexxxx,
                //                       //                     categoryModel
                //                       //                         .categoryName,
                //                       //                   );
                //                       //                   scrollToId.animateTo(
                //                       //                     categoryModel
                //                       //                         .categoryName,
                //                       //                     duration: Duration(
                //                       //                         milliseconds:
                //                       //                             500),
                //                       //                     curve: Curves.ease,
                //                       //                   );
                //                       //                 }
                //                       //               },
                //                       //               child: Container(
                //                       //                 decoration: BoxDecoration(
                //                       //                   borderRadius:
                //                       //                       BorderRadius
                //                       //                           .circular(
                //                       //                     ScreenUtil().setSp(
                //                       //                       20,
                //                       //                     ),
                //                       //                   ),
                //                       //                   color: indexxxx ==
                //                       //                           Get.find<
                //                       //                                   CategoryTagController>()
                //                       //                               .tag
                //                       //                               .value
                //                       //                       ? darklogoColor
                //                       //                           .withOpacity(
                //                       //                               0.45)
                //                       //                       : Colors.grey
                //                       //                           .withOpacity(
                //                       //                               0.4),
                //                       //                 ),
                //                       //                 margin:
                //                       //                     EdgeInsets.symmetric(
                //                       //                   horizontal: ScreenUtil()
                //                       //                       .setSp(2.5),
                //                       //                   vertical: ScreenUtil()
                //                       //                       .setSp(2.5),
                //                       //                 ),
                //                       //                 padding:
                //                       //                     EdgeInsets.symmetric(
                //                       //                   horizontal: ScreenUtil()
                //                       //                       .setSp(5),
                //                       //                   vertical: ScreenUtil()
                //                       //                       .setSp(5),
                //                       //                 ),
                //                       //                 child: Column(
                //                       //                   children: [
                //                       //                     Spacer(),
                //                       //                     ClipRRect(
                //                       //                       borderRadius:
                //                       //                           BorderRadius
                //                       //                               .all(
                //                       //                         Radius.circular(
                //                       //                           ScreenUtil()
                //                       //                               .setSp(2),
                //                       //                         ),
                //                       //                       ),
                //                       //                       child:
                //                       //                           CachedNetworkImage(
                //                       //                         height:
                //                       //                             ScreenUtil()
                //                       //                                 .setSp(
                //                       //                                     45),
                //                       //                         width:
                //                       //                             ScreenUtil()
                //                       //                                 .setSp(
                //                       //                                     45),
                //                       //                         fit: BoxFit.fill,
                //                       //                         imageUrl:
                //                       //                             categoryModel
                //                       //                                 .image,
                //                       //                         placeholder:
                //                       //                             (context,
                //                       //                                     url) =>
                //                       //                                 Image
                //                       //                                     .asset(
                //                       //                           "assets/images/placeholder.png",
                //                       //                           height:
                //                       //                               ScreenUtil()
                //                       //                                   .setSp(
                //                       //                                       45),
                //                       //                           width:
                //                       //                               ScreenUtil()
                //                       //                                   .setSp(
                //                       //                                       45),
                //                       //                           // width: ScreenUtil().setSp(150),
                //                       //                         ),
                //                       //                       ),
                //                       //                     ),
                //                       //                     SizedBox(
                //                       //                       height: ScreenUtil()
                //                       //                           .setSp(5),
                //                       //                     ),
                //                       //                     Text(
                //                       //                       categoryModel
                //                       //                           .categoryName,
                //                       //                       style: TextStyle(
                //                       //                         fontSize:
                //                       //                             ScreenUtil()
                //                       //                                 .setSp(
                //                       //                                     15),
                //                       //                         color: logoColor,
                //                       //                         fontWeight:
                //                       //                             FontWeight
                //                       //                                 .w500,
                //                       //                       ),
                //                       //                     ),
                //                       //                     Spacer(
                //                       //                         // flex: 2,
                //                       //                         ),
                //                       //                   ],
                //                       //                 ),
                //                       //               ),
                //                       //             ),
                //                       //           ),
                //                       //         ),
                //                       //       ),
                //                       //     ),
                //                       //   );
                //                       // }
                //                     },
                //                   );
                //                 } else {
                //                   return ListView(
                //                     scrollDirection: Axis.horizontal,
                //                     children: List.generate(
                //                       4,
                //                       (index) => ShimmerWidget.rectangular(
                //                         height: ScreenUtil().setSp(40),
                //                       ),
                //                     ),
                //                   );
                //                 }
                //               } else {
                //                 return ListView(
                //                   scrollDirection: Axis.horizontal,
                //                   children: List.generate(
                //                     4,
                //                     (index) => Container(
                //                       margin: EdgeInsets.symmetric(
                //                         horizontal: ScreenUtil().setSp(5),
                //                         vertical: ScreenUtil().setSp(5),
                //                       ),
                //                       child: ShimmerWidget.rectangular(
                //                         width: ScreenUtil().setSp(150),
                //                         height: ScreenUtil().setSp(10),
                //                       ),
                //                     ),
                //                   ),
                //                 );
                //                 // return Text("data");
                //               }
                //             },
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                ScrollContent(
                  id: "All",
                  child: OurAllContext(
                    category: "All",
                  ),
                ),
                ScrollContent(
                  id: "Grocery",
                  child: OurCategoryContext(
                    category: "Grocery",
                  ),
                ),
                ScrollContent(
                  id: "Electronic",
                  child: OurCategoryContext(
                    category: "Electronic",
                  ),
                ),
                ScrollContent(
                  id: "Beverage",
                  child: OurCategoryContext(
                    category: "Beverage",
                  ),
                ),
                ScrollContent(
                  id: "Personal care",
                  child: OurCategoryContext(
                    category: "Personal care",
                  ),
                ),
                ScrollContent(
                  id: "Fashain and apparel",
                  child: OurCategoryContext(
                    category: "Fashain and apparel",
                  ),
                ),
                ScrollContent(
                  id: "Baby care",
                  child: OurCategoryContext(
                    category: "Baby care",
                  ),
                ),
                ScrollContent(
                  id: "Bakery and dairy",
                  child: OurCategoryContext(
                    category: "Bakery and dairy",
                  ),
                ),
                ScrollContent(
                  id: "Eggs and meat",
                  child: OurCategoryContext(
                    category: "Eggs and meat",
                  ),
                ),
                ScrollContent(
                  id: "Household items",
                  child: OurCategoryContext(
                    category: "Household items",
                  ),
                ),
                ScrollContent(
                  id: "Kitchen and pet food",
                  child: OurCategoryContext(
                    category: "Kitchen and pet food",
                  ),
                ),
                //           "Vegitable and fruits",
                // "Beauty",
                ScrollContent(
                  id: "Vegetable and fruits",
                  child: OurCategoryContext(
                    category: "Vegetable and fruits",
                  ),
                ),
                ScrollContent(
                  id: "Beauty",
                  child: OurCategoryContext(
                    category: "Beauty",
                  ),
                ),

                ScrollContent(
                  id: "Aadbd as",
                  child: OurRecommendationWidget(
                    productUIDhide: "UtsavHAHAHA",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
