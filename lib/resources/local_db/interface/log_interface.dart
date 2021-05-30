import 'package:skype/models/log.dart';

abstract class LogInterface {
  init();

  openDb(dbName);

  addLogs(Log log);

  Future<List<Log>> getLogs();

  deleteLogs(int logId);

  close();
}