import 'package:flutter/material.dart';
import 'package:skype/Constants/strings.dart';
import 'package:skype/models/call.dart';
import 'package:skype/models/log.dart';
import 'package:skype/resources/call_methods.dart';
import 'package:skype/resources/local_db/repository/log_repositry.dart';
import 'package:skype/screens/callscreens/call_screen.dart';
import 'package:skype/utils/permissions.dart';
import 'package:skype/widgets/cached_image.dart';

class PickUpScreen extends StatefulWidget {
  final Call call;

  PickUpScreen({@required this.call});

  @override
  _PickUpScreenState createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  final CallMethods callMethods = CallMethods();
  bool isCallMissed = true;
  addToLocalStorage({@required String callStatus}) {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      callStatus: callStatus,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now().toString(),
    );
    LogRepository.addLogs(log);
  }


  @override
  void dispose() {
    super.dispose();
    if(isCallMissed) {
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            SizedBox(height: 50.0),
            CachedImage(
              widget.call.callerPic,
              isRound: true,
              radius: 180.0,
            ),
            SizedBox(height: 15.0),
            Text(
              widget.call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 75.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    setState(() {
                      isCallMissed = false;
                    });
                    addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                SizedBox(width: 25.0),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async {
                    setState(() {
                      isCallMissed = false;
                    });
                    addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) =>
                                CallScreen(call: widget.call)),
                        )
                        : () {};
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
