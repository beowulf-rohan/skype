import 'package:flutter/material.dart';
import 'package:skype/models/log.dart';
import 'package:skype/resources/local_db/repository/log_repositry.dart';
import 'package:skype/utils/universal_variable.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Center(
        child: FlatButton(
          child: Text("click me"),
          onPressed: () {
            LogRepository.init(isSql: true);
            LogRepository.addLogs(Log());
          },
        ),
      ),
    );
  }
}
