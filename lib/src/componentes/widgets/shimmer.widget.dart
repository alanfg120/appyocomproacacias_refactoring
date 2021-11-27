import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  const ShimmerLoading({Key? key,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Shimmer.fromColors(
            baseColor      : Colors.grey.shade300, 
            highlightColor : Colors.grey.shade200,
            direction      : ShimmerDirection.ltr,
            child          : child,
            loop           : 6,
    );
  }
}