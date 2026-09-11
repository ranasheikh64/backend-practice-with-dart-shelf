import 'package:mongo_dart/mongo_dart.dart';

class Database {
  static late Db _db;
  
  // Connect to the database
  static Future<void> connect() async {
    // Local MongoDB URI. Change it to your Atlas URI if you use cloud DB.
    const mongoUri = 'mongodb+srv://rana6424sheikh_db_user:mUYvQtQBvNFW6bZZ@cluster0.ag0s7ku.mongodb.net/?appName=Cluster0';
    
    _db = await Db.create(mongoUri);
    await _db.open();
    print('MongoDB Connected successfully!');
  }

  // Get a specific collection
  static DbCollection getCollection(String collectionName) {
    return _db.collection(collectionName);
  }
}
