import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skype/models/log.dart';
import 'package:skype/resources/local_db/interface/log_interface.dart';

class HiveMethods implements LogInterface {

  String hive_box = "";

  @override
  openDb(dbName) => (hive_box = dbName);


  @override
  init() async{
    print("initialised hive db");
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  @override
  addLogs(Log log) async{
    print("Adding values to hive db");
    var box = await Hive.openBox(hive_box);
    var logMap = log.toMap(log);
    int idOfInput = await box.add(logMap);
    close();
    print("Addition complete");
    return idOfInput;
  }

  updateLogs(int i, Log log) async{
    var box = await Hive.openBox(hive_box);
    var logMap = log.toMap(log);
    box.putAt(i, logMap);
    close();
  }

  @override
  Future<List<Log>> getLogs() async{
    var box = await Hive.openBox(hive_box);

    List<Log> logList = [];
    for(int i = 0; i < box.length; i++)
      {
        var logMap = box.getAt(i);
        logList.add(Log.fromMap(logMap));
      }
    return logList;
  }

  @override
  deleteLogs(int logId) async{
    var box = await Hive.openBox(hive_box);
    await box.deleteAt(logId);
  }

  @override
  close() {
    close() => Hive.close();
  }
}
