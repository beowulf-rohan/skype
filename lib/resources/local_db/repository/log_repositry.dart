import 'package:flutter/cupertino.dart';
import 'package:skype/models/log.dart';
import 'package:skype/resources/local_db/db/hive_methods.dart';
import 'package:skype/resources/local_db/db/sqlite_methods.dart';

class LogRepository {
  static var dbObject;
  static bool isSql;

  static init({@required bool isSql}) {
    dbObject = isSql ? SqliteMethods() : HiveMethods();
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);
  static deleteLogs(int logId) => dbObject.deleteLogs(logId);
  static getLogs() => dbObject.getLogs();
  static close() => dbObject.close();
}
