import 'package:flutter/material.dart';
import 'package:skype/utils/universal_variable.dart';
import 'package:skype/widgets/floating_column.dart';
import 'package:skype/widgets/log_list_container.dart';
import 'package:skype/widgets/skype_appbar.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: SkypeAppBar(
        title: "Calls ",
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/search_screen');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingColumn(),
      body: Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: LogListContainer(),
      ),
    );
  }
}
