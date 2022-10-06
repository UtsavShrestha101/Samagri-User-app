import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/widget/our_search_product_tile.dart';
import 'package:myapp/widget/our_shimeer_text.dart';
import 'package:myapp/widget/our_spinner.dart';
import '../../models/product_model.dart';
import '../../utils/color.dart';
import '../../widget/our_sized_box.dart';
// import '../../widget/our_product_item_list_tile.dart';

class ShoppingFavouriteScreen extends StatefulWidget {
  const ShoppingFavouriteScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingFavouriteScreen> createState() =>
      _ShoppingFavouriteScreenState();
}

class _ShoppingFavouriteScreenState extends State<ShoppingFavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(10),
            vertical: ScreenUtil().setSp(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      MdiIcons.chevronLeft,
                      size: ScreenUtil().setSp(35),
                      color: darklogoColor,
                    ),
                  ),
                  Expanded(
                    child: OurShimmerText(
                      title: "My Favourites",
                    ),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("Favorites")
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: OurSpinner(),
                      );
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.docs.length > 0) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            String uid = snapshot.data!.docs[index]["uid"];
                            return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("All")
                                  .where("uid", isEqualTo: uid)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.docs.length > 0) {
                                    ProductModel productModel =
                                        ProductModel.fromMap(
                                            snapshot.data!.docs[0]);
                                    return Container(
                                      // margin: EdgeInsets.only(top: 20),
                                      child: OurSearchProductListTile(
                                        buildContext: context,
                                        productModel: productModel,
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              },
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/logo.png",
                                fit: BoxFit.contain,
                                height: ScreenUtil().setSp(150),
                                width: ScreenUtil().setSp(150),
                              ),
                              OurSizedBox(),
                              Text(
                                "We're sorry",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: logoColor,
                                  fontSize: ScreenUtil().setSp(17.5),
                                ),
                              ),
                              OurSizedBox(),
                              Text(
                                "No item added to favourite list",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: ScreenUtil().setSp(15),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.contain,
                              height: ScreenUtil().setSp(150),
                              width: ScreenUtil().setSp(150),
                            ),
                            OurSizedBox(),
                            Text(
                              "We're sorry",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: logoColor,
                                fontSize: ScreenUtil().setSp(17.5),
                              ),
                            ),
                            OurSizedBox(),
                            Text(
                              "No item added to favourite list",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: ScreenUtil().setSp(15),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
