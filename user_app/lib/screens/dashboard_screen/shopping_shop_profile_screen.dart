import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_category_context_seller.dart';
import 'package:scroll_to_id/scroll_to_id.dart';

import '../../controller/category_tag_controller.dart';
import '../../models/user_model.dart';
import '../../widget/our_all_content.dart';
import '../../widget/our_all_content_seller.dart';
import '../../widget/our_category_context.dart';

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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setSp(17.5),
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setSp(10),
                        ),
                        child: Image.network(
                          widget.userModel.imageUrl,
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ),
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
