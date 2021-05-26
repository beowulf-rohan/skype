import 'package:flutter/material.dart';
import 'package:skype/screens/search_screen.dart';
import 'package:skype/utils/universal_variable.dart';

class QuietBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric( horizontal: 25.0, vertical: 35.0),
          child: Column(
            children: [
              Text(
                "contacts are listed here",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0
                ),
              ),
              SizedBox(height: 25.0),
              Text(
                "Search for your friends and family to start calling or chatting with them",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0
                ),
              ),
              SizedBox(height: 25.0),
              FlatButton(
                color: UniversalVariables.lightBlueColor,
                child: Text("Start Searching"),
                onPressed: () => MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}