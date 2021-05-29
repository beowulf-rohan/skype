import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype/utils/universal_variable.dart';

class ShimmeringLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: 50.0,
      child: Shimmer.fromColors(
        child: Image.asset("assets/app_logo.png"),
        baseColor: UniversalVariables.blackColor,
        highlightColor: Colors.white,
      ),
    );
  }
}
