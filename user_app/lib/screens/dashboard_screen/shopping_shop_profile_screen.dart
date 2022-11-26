import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/screens/dashboard_screen/shopping_chat_send_screen.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_category_context_seller.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scroll_to_id/scroll_to_id.dart';

import '../../controller/category_tag_controller.dart';
import '../../models/seller_model.dart';
import '../../models/user_model.dart';
import '../../models/user_model_firebase.dart';
import '../../services/follow_unfollow_storage/follow_unfollow_feature.dart';
import '../../widget/our_all_content.dart';
import '../../widget/our_all_content_seller.dart';
import '../../widget/our_category_context.dart';
import '../../widget/our_elevated_button.dart';
import '../../widget/our_profile_detail_number_column.dart';
import '../../widget/our_shimmer_widget.dart';
import '../../widget/our_sized_box.dart';
import '../../widget/our_spinner.dart';

class ShoppingShopProfileScreen extends StatefulWidget {
  final String shopName;
  final UserModel userModel;
  final String shopOwnerUID;
  const ShoppingShopProfileScreen(
      {Key? key,
      required this.shopName,
      required this.shopOwnerUID,
      required this.userModel})
      : super(key: key);

  @override
  State<ShoppingShopProfileScreen> createState() =>
      _ShoppingShopProfileScreenState();
}

class _ShoppingShopProfileScreenState extends State<ShoppingShopProfileScreen> {
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
  final scrollController = ScrollController();

  late ScrollToId scrollToId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<CategoryTagController>().initialize();
    scrollToId = ScrollToId(scrollController: scrollController);
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // print(scrollToId.idPosition());
  }
  void followersBottomSheet(BuildContext context, List likesUid) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(10),
            vertical: ScreenUtil().setSp(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Followers',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(20),
                    color: logoColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Divider(),
              // Column(
              //   children: likesUid.map((e) => Text(e)).toList(),
              // )
              Expanded(
                child: likesUid.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: likesUid.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Users")
                                .doc(likesUid[index])
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                FirebaseUser11Model userModel =
                                    FirebaseUser11Model.fromMap(snapshot.data);
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setSp(10),
                                    vertical: ScreenUtil().setSp(10),
                                  ),
                                  child: Row(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.start,
                                    children: [
                                      userModel.imageUrl != ""
                                          ? CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: ScreenUtil().setSp(20),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  ScreenUtil().setSp(25),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: userModel.imageUrl,

                                                  // Image.network(
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                    "assets/images/profile_holder.png",
                                                    width: double.infinity,
                                                    height:
                                                        ScreenUtil().setSp(125),
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    "assets/images/profile_holder.png",
                                                    width: double.infinity,
                                                    height:
                                                        ScreenUtil().setSp(125),
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                  height:
                                                      ScreenUtil().setSp(70),
                                                  width: ScreenUtil().setSp(70),
                                                  fit: BoxFit.cover,
                                                  //   )
                                                ),
                                              ))
                                          : CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: ScreenUtil().setSp(20),
                                              child: Text(
                                                userModel.name[0].toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: ScreenUtil().setSp(
                                                    20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                        width: ScreenUtil().setSp(20),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userModel.name,
                                            style: TextStyle(
                                                color: darklogoColor,
                                                fontSize:
                                                    ScreenUtil().setSp(15),
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setSp(4.5),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Center(
                                child: OurSpinner(),
                              );
                            },
                          );
                        })
                    : Center(
                        child: Text(
                          "No Followers",
                          style: TextStyle(
                            color: logoColor,
                            fontSize: ScreenUtil().setSp(20),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: darklogoColor,
            size: ScreenUtil().setSp(25),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.userModel.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            color: logoColor,
            fontSize: ScreenUtil().setSp(20),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
               var a = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      FirebaseUser11Model userModel11 = FirebaseUser11Model.fromMap(a);
              Navigator.push(context, PageTransition(child: MessageSendScreen(
                firebaseUser11: userModel11,
                userModel: widget.userModel,
              ), type: PageTransitionType.leftToRight,),);
              // print("Chat Screen");
              // print(widget.userModel.name);
            },
            child: Icon(
              MdiIcons.chatOutline,
                      color: darklogoColor,
                      size: ScreenUtil().setSp(25),
            ),

          ),
          SizedBox(
            width: ScreenUtil().setSp(7.5),
          ),
        ],
      ),

      body: SafeArea(
        child: Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setSp(10),
              // left: ScreenUtil().setSp(10),
              // right: ScreenUtil().setSp(10),
            ),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                InteractiveScrollViewer(children: [
                  ScrollContent(
                    id: "AAAAA",
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setSp(10),
                        vertical: ScreenUtil().setSp(5),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Sellers")
                            .where("uid", isEqualTo: widget.shopOwnerUID)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.length > 0) {
                              return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: snapshot.data!.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    FirebaseSellerModel userModel =
                                        FirebaseSellerModel.fromMap(
                                            snapshot.data!.docs[index]);
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: userModel.imageUrl != ""
                                                  ? CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      radius: ScreenUtil()
                                                          .setSp(35),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          ScreenUtil()
                                                              .setSp(35),
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: userModel
                                                              .imageUrl,

                                                          // Image.network(
                                                          placeholder:
                                                              (context, url) =>
                                                                  Image.asset(
                                                            "assets/images/profile_holder.png",
                                                            width:
                                                                double.infinity,
                                                            height: ScreenUtil()
                                                                .setSp(125),
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            "assets/images/profile_holder.png",
                                                            width:
                                                                double.infinity,
                                                            height: ScreenUtil()
                                                                .setSp(125),
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          ),
                                                          height: ScreenUtil()
                                                              .setSp(70),
                                                          width: ScreenUtil()
                                                              .setSp(70),
                                                          fit: BoxFit.cover,
                                                          //   )
                                                        ),
                                                      ),
                                                    )
                                                  : CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      radius: ScreenUtil()
                                                          .setSp(35),
                                                      child: Text(
                                                        userModel.name[0]
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(
                                                            30,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setSp(10),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      OurProfileDetailNumberColumn(
                                                        function: () {
                                                          // print("POSTS");
                                                          // HomeVideoCheck().check();
                                                        },
                                                        title: "Products",
                                                        number: userModel
                                                            .product
                                                            .toString(),
                                                      ),
                                                      OurProfileDetailNumberColumn(
                                                        function: () {
                                                          followersBottomSheet(
                                                              context,
                                                              userModel
                                                                  .followerList);
                                                        },
                                                        title: "Followers",
                                                        number: userModel
                                                            .follower
                                                            .toString(),
                                                      ),
                                                      // OurProfileDetailNumberColumn(
                                                      //   function: () {
                                                      //     // followingBottomSheet(
                                                      //     //     context,
                                                      //     //     userModel
                                                      //     //         .followingList);
                                                      //   },
                                                      //   title: "Following",
                                                      //   number: userModel
                                                      //       .following
                                                      //       .toString(),
                                                      // ),
                                                    ],
                                                  ),
                                                  // OurSizedBox(),
                                                  // Row(
                                                  //   children: [
                                                  //     Expanded(
                                                  //       child: OurElevatedButton(
                                                  //         title: "Edit",
                                                  //         function: () {
                                                  //           // Navigator.push(
                                                  //           //   context,
                                                  //           //   PageTransition(
                                                  //           //     type:
                                                  //           //         PageTransitionType
                                                  //           //             .leftToRight,
                                                  //           //     child: EditScreen(
                                                  //           //       usernmae: userModel
                                                  //           //           .user_name,
                                                  //           //       bio:
                                                  //           //           userModel.bio,
                                                  //           //       userModel:
                                                  //           //           userModel,
                                                  //           //     ),
                                                  //           //   ),
                                                  //           // );
                                                  //         },
                                                  //       ),
                                                  //     ),
                                                  //     SizedBox(
                                                  //       width: ScreenUtil()
                                                  //           .setSp(20),
                                                  //     ),
                                                  //     Expanded(
                                                  //       child: OurElevatedButton(
                                                  //         title: "Logout",
                                                  //         function: () async {
                                                  //           // await AuthenticationService()
                                                  //           //     .logout();
                                                  //         },
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  userModel.followerList
                                                          .contains(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                      ? Row(
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(
                                                                width:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            200),
                                                                child:
                                                                    OurElevatedButton(
                                                                  title:
                                                                      "Unfollow",
                                                                  function: () {
                                                                    FollowUnfollowDetailFirebase()
                                                                        .unfollow(
                                                                            userModel);
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox(
                                                          width: ScreenUtil()
                                                              .setSp(200),
                                                          child:
                                                              OurElevatedButton(
                                                            title: "Follow",
                                                            function: () {
                                                              FollowUnfollowDetailFirebase()
                                                                  .follow(
                                                                      userModel);
                                                            },
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        OurSizedBox(),
                                        Text(
                                          userModel.name,
                                          style: TextStyle(
                                            color: darklogoColor,
                                            fontSize: ScreenUtil().setSp(17.5),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        OurSizedBox(),
                                        userModel.location.isNotEmpty
                                            ? Text(
                                                userModel.location,
                                                style: TextStyle(
                                                    color: darklogoColor,
                                                    fontSize: ScreenUtil()
                                                        .setSp(13.5),
                                                    fontWeight:
                                                        FontWeight.w300),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : Container(),
                                        Divider(
                                          color: logoColor,
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              return Text("data2");
                            }
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Expanded(
                                  //   child: ShimmerWidget.circular(
                                  //     height: ScreenUtil().setSp(75),
                                  //     width: ScreenUtil().setSp(75),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    width: ScreenUtil().setSp(10),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      ScreenUtil().setSp(2),
                                                ),
                                                child: Column(
                                                  children: [
                                                    ShimmerWidget.rectangular(
                                                      height:
                                                          ScreenUtil().setSp(
                                                        12.5,
                                                      ),
                                                      width: ScreenUtil()
                                                          .setSp(100),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          ScreenUtil().setSp(5),
                                                    ),
                                                    ShimmerWidget.rectangular(
                                                      height:
                                                          ScreenUtil().setSp(
                                                        15,
                                                      ),
                                                      width: ScreenUtil()
                                                          .setSp(20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      ScreenUtil().setSp(2),
                                                ),
                                                child: Column(
                                                  children: [
                                                    ShimmerWidget.rectangular(
                                                      height:
                                                          ScreenUtil().setSp(
                                                        12.5,
                                                      ),
                                                      width: ScreenUtil()
                                                          .setSp(100),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          ScreenUtil().setSp(5),
                                                    ),
                                                    ShimmerWidget.rectangular(
                                                      height:
                                                          ScreenUtil().setSp(
                                                        15,
                                                      ),
                                                      width: ScreenUtil()
                                                          .setSp(20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      ScreenUtil().setSp(2),
                                                ),
                                                child: Column(
                                                  children: [
                                                    ShimmerWidget.rectangular(
                                                      height:
                                                          ScreenUtil().setSp(
                                                        12.5,
                                                      ),
                                                      width: ScreenUtil()
                                                          .setSp(100),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          ScreenUtil().setSp(5),
                                                    ),
                                                    ShimmerWidget.rectangular(
                                                      height:
                                                          ScreenUtil().setSp(
                                                        15,
                                                      ),
                                                      width: ScreenUtil()
                                                          .setSp(20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        OurSizedBox(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ShimmerWidget.rectangular(
                                              height: ScreenUtil().setSp(
                                                12.5,
                                              ),
                                              width: ScreenUtil().setSp(100),
                                            ),
                                            ShimmerWidget.rectangular(
                                              height: ScreenUtil().setSp(
                                                12.5,
                                              ),
                                              width: ScreenUtil().setSp(100),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              OurSizedBox(),
                              ShimmerWidget.rectangular(
                                height: ScreenUtil().setSp(
                                  12.5,
                                ),
                                width: ScreenUtil().setSp(100),
                              ),
                              SizedBox(
                                height: ScreenUtil().setSp(4.5),
                              ),
                              ShimmerWidget.rectangular(
                                height: ScreenUtil().setSp(
                                  8.5,
                                ),
                                width: ScreenUtil().setSp(150),
                              ),
                              Divider(
                                color: logoColor,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    // child: ClipRRect(
                    //   borderRadius: BorderRadius.circular(
                    //     ScreenUtil().setSp(17.5),
                    //   ),
                    //   child: Container(
                    //     margin: EdgeInsets.symmetric(
                    //       vertical: ScreenUtil().setSp(10),
                    //     ),
                    //     child: Image.network(
                    //       widget.userModel.imageUrl,
                    //       width: 200,
                    //       height: 200,
                    //     ),
                    //   ),
                    // ),
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
                            2.5,
                          ),
                        ),
                        child: SizedBox(
                          // key: key,
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
                                                      15,
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
                                                  vertical:
                                                      ScreenUtil().setSp(2),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      ScreenUtil().setSp(5),
                                                  vertical:
                                                      ScreenUtil().setSp(5),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    items[index],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
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

                  ScrollContent(
                    id: "All",
                    child: OurAllSellerContext(
                      ownerUid: widget.shopOwnerUID,
                      category: "All",
                    ),
                  ),
                  ScrollContent(
                    id: "Grocery",
                    child: OurCategorySellerContext(
                      ownerUid: widget.shopOwnerUID,
                      category: "Grocery",
                    ),
                  ),
                  ScrollContent(
                    id: "Electronic",
                    child: OurCategorySellerContext(
                      ownerUid: widget.shopOwnerUID,
                      category: "Electronic",
                    ),
                  ),
                  ScrollContent(
                    id: "Beverage",
                    child: OurCategorySellerContext(
                      ownerUid: widget.shopOwnerUID,
                      category: "Beverage",
                    ),
                  ),
                  ScrollContent(
                    id: "Personal care",
                    child: OurCategorySellerContext(
                      ownerUid: widget.shopOwnerUID,
                      category: "Personal care",
                    ),
                  ),
                  ScrollContent(
                    id: "Fashain and apparel",
                    child: OurCategorySellerContext(
                      ownerUid: widget.shopOwnerUID,
                      category: "Fashain and apparel",
                    ),
                  ),
                  ScrollContent(
                    id: "Baby care",
                    child: OurCategorySellerContext(
                      ownerUid: widget.shopOwnerUID,
                      category: "Baby care",
                    ),
                  ),
                  ScrollContent(
                    id: "Bakery and dairy",
                    child: OurCategorySellerContext(
                      ownerUid: widget.shopOwnerUID,
                      category: "Bakery and dairy",
                    ),
                  ),
                  ScrollContent(
                    id: "Eggs and meat",
                    child: OurCategorySellerContext(
                      ownerUid: widget.shopOwnerUID,
                      category: "Eggs and meat",
                    ),
                  ),
                  ScrollContent(
                    id: "Household items",
                    child: OurCategorySellerContext(
                      ownerUid: widget.shopOwnerUID,
                      category: "Household items",
                    ),
                  ),
                  ScrollContent(
                    id: "Kitchen and pet food",
                    child: OurCategorySellerContext(
                      ownerUid: widget.shopOwnerUID,
                      category: "Kitchen and pet food",
                    ),
                  ),
                  //           "Vegitable and fruits",
                  // "Beauty",
                  ScrollContent(
                    id: "Vegetable and fruits",
                    child: OurCategorySellerContext(
                      ownerUid: widget.shopOwnerUID,
                      category: "Vegetable and fruits",
                    ),
                  ),
                  ScrollContent(
                    id: "Beauty",
                    child: OurCategorySellerContext(
                      ownerUid: widget.shopOwnerUID,
                      category: "Beauty",
                    ),
                  ),
                ], scrollToId: scrollToId)
              ],
            )),
      ),
    );
  }
}
