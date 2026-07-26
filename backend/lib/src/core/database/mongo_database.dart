import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  MongoDatabase._(this.db);

  final Db db;

  static Future<MongoDatabase> connect(String uri) async {
    final db = await Db.create(uri);
    await db.open();
    return MongoDatabase._(db);
  }

  DbCollection get users => db.collection('users');
  DbCollection get technicians => db.collection('technicians');
  DbCollection get bookings => db.collection('bookings');
  DbCollection get services => db.collection('services');
  DbCollection get notifications => db.collection('notifications');
  DbCollection get favorites => db.collection('favorites');

  Future<void> close() => db.close();
}
