import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/screens/dashboard_screen/shopping_add_list_screen.dart';
import 'package:myapp/screens/dashboard_screen/shopping_add_product_screen.dart';
import 'package:myapp/screens/dashboard_screen/shopping_chat_screen.dart';
import 'package:myapp/screens/dashboard_screen/shopping_explore_shop.dart';
import 'package:myapp/screens/dashboard_screen/shopping_my_cart_screen.dart';
import 'package:myapp/services/current_location/get_current_location.dart';
import 'package:myapp/services/notification_service/notification_service.dart';
import '../../controller/dashboard_controller.dart';
import '../../models/firebase_user_model.dart';
import '../../services/network_connection/network_connection.dart';
import '../../utils/color.dart';
import 'shopping_home_screen.dart';
import 'shopping_profile_screen.dart';
import 'shopping_sale_screen.dart';
import 'shopping_search_screen.dart';

class ShoppingFullApp extends StatefulWidget {
  @override
  _ShoppingFullAppPageState createState() => _ShoppingFullAppPageState();
}

class _ShoppingFullAppPageState extends State<ShoppingFullApp>
    with SingleTickerProviderStateMixin {
  late Position position;
  getlocation() async {
    print("Inside location");
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      print(position);
      print("UTSAV SHRESTHA");
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((event) {
      print("Hello");
      print(FirebaseMessaging.onMessage.isBroadcast);
      print("Hello");
      print("object 2");
      print(event.data);

      // if (event.data != null) {
      //   print("Hello world");
      NotificationService.display(event);
      // }
    });
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event.data);
      NotificationService.display(event);
    });
    // storeNotificationToken();
  }

  Widget build(BuildContext context) {
    List widgets = [
      const ShoppingHomeScreen(),
      // const ShoppingSearchScreen(),
      ShopExploreScreen(
        pinWidget: Icon(
          Icons.location_pin,
          color: Colors.red,
          size: ScreenUtil().setSp(50),
        ),
        pinColor: Colors.blue,
        addressPlaceHolder: "Loading",
        addressTitle: "Address",
        apiKey: "AIzaSyDnx52eVYK2uBy6dvRO8skJyTctk_4K73s",
        appBarTitle: "Select delivery address",
        confirmButtonColor: logoColor,
        confirmButtonText: "Done",
        confirmButtonTextColor: Colors.white,
        country: "NP",
        language: "en",
        searchHint: "Search",
        // initialLocation: LatLng(
        //   position.latitude,
        //   position.longitude,
        //   // 12.34,
        //   // 23.45
        // ),
      ),
      // ShopAddProductScreen(),
      ShoppingChatScreen(),
      const ShoppingAddListScreen(),
      const ShoppingMyCartScreen(),
      ShoppingProfileScreen()
    ];
    return Obx(() => GestureDetector(
          // onHorizontalDragEnd: (dragDetail) {
          //   if (dragDetail.velocity.pixelsPerSecond.dx < 1) {
          //     if (Get.find<DashboardController>().indexs.value < 4) {
          //       print(Get.find<DashboardController>().indexs.value);
          //       print("Right swipe");
          //       Get.find<DashboardController>().changeIndexs(
          //           Get.find<DashboardController>().indexs.value + 1);
          //     }
          //   } else {
          //     if (Get.find<DashboardController>().indexs.value > 0) {
          //       print(Get.find<DashboardController>().indexs.value);
          //       print("Left swipe");
          //       Get.find<DashboardController>().changeIndexs(
          //           Get.find<DashboardController>().indexs.value - 1);
          //     }
          //   }
          // },
          child: Scaffold(
            bottomNavigationBar: SnakeNavigationBar.color(
              height: ScreenUtil().setSp(50),
              behaviour: SnakeBarBehaviour.floating,
              snakeShape: SnakeShape.circle,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    ScreenUtil().setSp(20),
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
                vertical: ScreenUtil().setSp(10),
              ),
              snakeViewColor: logoColor.withOpacity(0.3),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.blueGrey,
              showUnselectedLabels: false,
              showSelectedLabels: true,
              currentIndex: Get.find<DashboardController>().indexs.value,
              onTap: (index) {
                Get.find<DashboardController>().changeIndexs(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    MdiIcons.storeOutline,
                    color: darklogoColor,
                    size: ScreenUtil().setSp(22.5),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MdiIcons.magnify,
                    color: darklogoColor,
                    size: ScreenUtil().setSp(22.5),
                  ),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    // Icons.list_alt_outlined,
                    MdiIcons.chatOutline,
                    color: darklogoColor,
                    size: ScreenUtil().setSp(22.5),
                  ),
                  label: 'Messages',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    // Icons.list_alt_outlined,
                    MdiIcons.checkAll,
                    color: darklogoColor,
                    size: ScreenUtil().setSp(22.5),
                  ),
                  label: 'Messages',
                ),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(
                        right: ScreenUtil().setSp(10),
                      ),
                      child:
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Icon(
                              MdiIcons.cartOutline,
                              color: darklogoColor,
                              size: ScreenUtil().setSp(22.5),
                            );
                          } else if (snapshot.hasData) {
                            if (snapshot.data!.exists) {
                              FirebaseUserModel firebaseUserModel =
                                  FirebaseUserModel.fromMap(
                                      snapshot.data!.data()!);
                              return Badge(
                                badgeColor: darklogoColor,
                                position: BadgePosition.topEnd(),
                                badgeContent: Text(
                                  firebaseUserModel.cartItemNo.toString(),
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(15),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                child: Icon(
                                  MdiIcons.cartOutline,
                                  color: darklogoColor,
                                  size: ScreenUtil().setSp(22.5),
                                ),
                              );
                            } else {
                              return Icon(
                                MdiIcons.cartOutline,
                                color: darklogoColor,
                                size: ScreenUtil().setSp(22.5),
                              );
                            }
                          }
                          return Icon(
                            MdiIcons.cart,
                            color: darklogoColor,
                            size: ScreenUtil().setSp(22.5),
                          );
                        },
                      ),
                    ),
                    label: 'Add'),
                BottomNavigationBarItem(
                    icon: Icon(
                      MdiIcons.accountOutline,
                      color: darklogoColor,
                      size: ScreenUtil().setSp(22.5),
                    ),
                    label: 'Profile')
              ],
              selectedLabelStyle: const TextStyle(fontSize: 14),
              unselectedLabelStyle: const TextStyle(fontSize: 10),
            ),
            body: widgets[Get.find<DashboardController>().indexs.value],
          ),
        ));
  }
}
