import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final ShapeBorder shapeBorder;

  // ignore: use_key_in_widget_constructors
  ShimmerWidget.rectangular({
    required this.height,
    this.width = double.infinity,
  }) : shapeBorder = RoundedRectangleBorder();
  // ignore: use_key_in_widget_constructors
  //  ShimmerWidget.circular(
  //     {required this.height,
  //     required this.width,
  //     this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 1),
      highlightColor: Colors.grey.shade200,
      baseColor: Colors.grey.shade500,
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          color: Colors.grey.withOpacity(0.7),
          shape: shapeBorder,
        ),
      ),
    );
  }
}
