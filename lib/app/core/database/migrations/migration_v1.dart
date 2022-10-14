import 'package:sqflite/sqflite.dart';
import 'package:todo_list/app/core/database/migrations/migration.dart';

class MigrationV1 implements Migration {
  @override
  void create(Batch batch) {
    batch.execute(''' 
                      CREATE TABLE todo(
                      id Integer primary key autoincrement,
                      descricao varchar(500) not null,
                      data_hora datetime,
                      finalizado Integer
                      )
        ''');
  }
  @override
  void update(Batch batch) {}
}
