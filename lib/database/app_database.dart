import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dao/contact_DAO.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'bytebank.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(ContactDAO.tableSQL);
    },
    version: 1,
    //onDowngrade: onDatabaseDowngradeDelete,
  );
}
