import 'package:flutter/material.dart';
import 'package:skype/utils/universal_variable.dart';

class FloatingColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: UniversalVariables.fabGradient,
          ),
          child: Icon(
            Icons.dialpad,
            color: Colors.white,
            size: 25.0,
          ),
        ),
        SizedBox(height: 15.0),
        Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: UniversalVariables.blackColor,
            border: Border.all(
              width: 2.0,
              color: UniversalVariables.gradientColorEnd,
            ),
          ),
          child: Icon(
            Icons.add_call,
            color: UniversalVariables.gradientColorEnd,
            size: 25.0,
          ),
        ),
      ],
    );
  }
}
