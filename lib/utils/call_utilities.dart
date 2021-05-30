import 'package:flutter/material.dart';
import 'package:skype/Constants/strings.dart';
import 'package:skype/models/call.dart';
import 'package:skype/models/log.dart';
import 'package:skype/models/user.dart';
import 'package:skype/resources/call_methods.dart';
import 'package:skype/resources/local_db/repository/log_repositry.dart';
import 'package:skype/screens/callscreens/call_screen.dart';

class CallUtils{
  static final CallMethods callMethods = CallMethods();
  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: (from.uid+to.uid),
    );
    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );

    bool callMade = await callMethods.makeCall(call);
    if (callMade) {
      LogRepository.addLogs(log);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      );
    }
  }
}
