import 'package:flutter/material.dart';
import 'package:skype/models/call.dart';
import 'package:skype/resources/call_methods.dart';
import 'package:skype/screens/callscreens/call_screen.dart';
import 'package:skype/utils/permissions.dart';
import 'package:skype/widgets/cached_image.dart';

class PickUpScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();
  PickUpScreen({@required this.call});

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
              call.callerPic,
              isRound: true,
              radius: 180.0,
            ),
            SizedBox(height: 15.0),
            Text(
              call.callerName,
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
                    await callMethods.endCall(call: call);
                  },
                ),
                SizedBox(width: 25.0),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async => await Permissions.cameraAndMicrophonePermissionsGranted()
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CallScreen(call: call),
                          ),
                        )
                      : {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
