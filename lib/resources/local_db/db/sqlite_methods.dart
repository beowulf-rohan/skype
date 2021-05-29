import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:skype/models/log.dart';
import 'package:skype/resources/local_db/interface/log_interface.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteMethods implements LogInterface {
  Database _db;
  String databaseName = "LogDB";
  String tableName = "Call_Logs";
  //columns
  String id = "log_id", callerName = "caller_name", callerPic = "caller_pic";
  String receiverName = "receiver_name", receiverPic = "receiver_pic";
  String callStatus = "call_status", timestamp = "timestamp";

  Future<Database> get db async {
    if (db != null) {
      return _db;
    }
    print("db was null, created new db");
    _db = await init();
    return _db;
  }

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, databaseName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    String createTableQuery =
        "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, $receiverName TEXT, $receiverPic TEXT, $callStatus TEXT, $timestamp TEXT)";
    await db.execute(createTableQuery);
    print("database created");
  }

  @override
  addLogs(Log log) async {
    var dbClient = await db;
    await dbClient.insert(tableName, log.toMap(log));
  }

  @override
  deleteLogs(int logId) async {
    var dbClient = await db;
    return await dbClient.delete(tableName, where: '$id = ?', whereArgs: [logId]);
  }

  updateLogs(Log log) async {
    var dbClient = await db;
    await dbClient.update(
      tableName,
      log.toMap(log),
      where: '$id = ?',
      whereArgs: [log.logId],
    );
  }

  @override
  Future<List<Log>> getLogs() async {
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient.query(
        tableName,
        columns: [
          id,
          callerName,
          callerPic,
          receiverName,
          receiverPic,
          callStatus,
          timestamp,
        ],
      );

      List<Log> logList = [];
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          logList.add(Log.fromMap(map));
        }
      }

      return logList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
