import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OurCarousel extends StatelessWidget {
  const OurCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: ScreenUtil().setSp(150),
        aspectRatio: 16 / 9,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        // onPageChanged: callbackFunction,
        scrollDirection: Axis.horizontal,
      ),
      items: [
        "assets/images/banners/banner_1.jpg",
        "assets/images/banners/banner_2.jpg",
        "assets/images/banners/banner_3.jpg",
        "assets/images/banners/banner_4.jpg",
        "assets/images/banners/banner_5.jpg",
        "assets/images/banners/banner_6.jpg",
      ].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              height: 90.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
              ),
              child: Image.asset(
                i,
                height: ScreenUtil().setSp(160),
                width: ScreenUtil().setSp(160),
                fit: BoxFit.cover,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
