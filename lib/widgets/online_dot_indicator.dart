import 'package:flutter/material.dart';
import 'package:skype/enum/user_state.dart';
import 'package:skype/models/user.dart';
import 'package:skype/resources/auth_methods.dart';
import 'package:skype/utils/utilities.dart';

class OnlineDorIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();

  OnlineDorIndicator({@required this.uid});

  @override
  Widget build(BuildContext context) {

    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return StreamBuilder(
        stream: _authMethods.getUserStream(uid: uid),
        builder: (context, snapshot) {
          User user;
          if (snapshot.hasData && snapshot.data.data != null) {
            user = User.fromMap(snapshot.data.data);
          }
          return Container(
            height: 10.0,
            width: 10.0,
            margin: EdgeInsets.only(right: 8.0, top: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getColor(Utils.stateToNum(user?.state)),
            ),
          );
        });
  }
}
