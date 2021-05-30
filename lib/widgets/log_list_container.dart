import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skype/Constants/strings.dart';
import 'package:skype/models/log.dart';
import 'package:skype/resources/local_db/repository/log_repositry.dart';
import 'package:skype/utils/utilities.dart';
import 'package:skype/widgets/cached_image.dart';
import 'package:skype/widgets/customTile.dart';

class LogListContainer extends StatefulWidget {
  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {
  getIcon(String status) {
    Icon icon;
    double iconSize = 15.0;

    switch (status) {
      case CALL_STATUS_DIALLED:
        icon = Icon(
          Icons.call_made,
          size: iconSize,
          color: Colors.green,
        );
        break;
      case CALL_STATUS_RECEIVED:
        icon = Icon(
          Icons.call_received,
          size: iconSize,
          color: Colors.grey,
        );
        break;
      default:
        icon = Icon(
          Icons.call_missed,
          size: iconSize,
          color: Colors.red,
        );
        break;
    }

    return Container(
      margin: EdgeInsets.only(right: 5.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LogRepository.getLogs(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.values) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          List<dynamic> logList = snapshot.data;
          if (logList.isNotEmpty) {
            return ListView.builder(
              itemCount: logList.length,
              itemBuilder: (context, index) {
                Log log = logList[index];
                bool hasDialled = (log.callStatus == CALL_STATUS_DIALLED);
                return CustomTile(
                  leading: CachedImage(
                    hasDialled ? log.receiverPic : log.callerPic,
                    isRound: true,
                    radius: 45.0,
                  ),
                  mini: false,
                  title: Text(
                    hasDialled ? log.receiverName : log.callerName,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: getIcon(log.callStatus),
                  subtitle: Text(
                    Utils.formatDateString(log.timestamp),
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  onLongPress: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Delete this log?"),
                      content: Text("Click on yes to delete this log"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Yes"),
                          onPressed: () async {
                            Navigator.maybePop(context);
                            await LogRepository.deleteLogs(index);
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        ),
                        FlatButton(
                          child: Text("No"),
                          onPressed: () async {
                            Navigator.maybePop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: Text(
              "No call Logs",
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          );
        }
        return Center(
          child: Text(
            "No call Logs",
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
        );
      },
    );
  }
}
