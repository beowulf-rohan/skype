import 'package:skype/models/log.dart';
import 'package:skype/resources/local_db/interface/log_interface.dart';

class HiveMethods implements LogInterface {
  @override
  addLogs(Log log) {
    print("Adding values to hive db");
    return null;
  }

  @override
  close() {
    return null;
  }

  @override
  deleteLogs(int logId) {
    return null;
  }

  @override
  Future<List<Log>> getLogs() {

    return null;
  }

  @override
  init() {
    print("initialised hive db");
    return null;
  }
}
