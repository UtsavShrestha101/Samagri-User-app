import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:myapp/widget/our_spinner.dart';

import '../utils/color.dart';
import 'our_product_grid_loading_widget.dart';
import 'our_product_grid_tile.dart';

class OurCategoryContext extends StatefulWidget {
  final String category;
  const OurCategoryContext({Key? key, required this.category})
      : super(key: key);

  @override
  State<OurCategoryContext> createState() => _OurCategoryContextState();
}

class _OurCategoryContextState extends State<OurCategoryContext> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OurSizedBox(),
          Text(
            "${widget.category}:",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(22.5),
              color: logoColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const OurSizedBox(),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("All")
                .where(
                  "category",
                  arrayContains: widget.category,
                )
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return OurProductGridLoadingScreen();
              } else if (snapshot.hasData) {
                if (snapshot.data!.docs.length > 0) {
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: ScreenUtil().setSp(5),
                      mainAxisSpacing: ScreenUtil().setSp(5),
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      ProductModel productModel =
                          ProductModel.fromMap(snapshot.data!.docs[index]);
                      return ProductGridTile(
                        productModel: productModel,
                        rootContext: context,
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.contain,
                          height: ScreenUtil().setSp(100),
                          width: ScreenUtil().setSp(100),
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
                          "We cannot find any matches",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.contain,
                        height: ScreenUtil().setSp(100),
                        width: ScreenUtil().setSp(100),
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
                        "We cannot find any matches",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Center(
                child: OurSpinner(),
              );

              // return CircularProgressIndicator();
              // rethrow
            },
          )
        ],
      ),
    );
  }
}
