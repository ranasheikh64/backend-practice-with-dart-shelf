import 'package:mongo_dart/mongo_dart.dart';
import '../config/database.dart';
import '../models/user_model.dart';

class UserRepository {
  final DbCollection _collection = Database.getCollection('users');

  // Create a new user
  Future<void> createUser(UserModel user) async {
    await _collection.insert(user.toMap());
  }

  // Get all users
  Future<List<UserModel>> getAllUsers() async {
    final usersMapList = await _collection.find().toList();
    return usersMapList.map((map) => UserModel.fromMap(map)).toList();
  }

  // Get a single user by ID
  Future<UserModel?> getUserById(String id) async {
    try {
      final objectId = ObjectId.fromHexString(id);
      final userMap = await _collection.findOne(where.id(objectId));
      if (userMap != null) {
        return UserModel.fromMap(userMap);
      }
      return null;
    } catch (e) {
      return null; // Invalid ID format or not found
    }
  }
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      //final objectId = ObjectId.fromHexString(email);
      final userMap = await _collection.findOne(where.eq('email', email));
      if (userMap != null) {
        return UserModel.fromMap(userMap);
      }
      return null;
    } catch (e) {
      return null; // Invalid ID format or not found
    }
  }

  // Update a user
  Future<bool> updateUser(String id, Map<String, dynamic> updateData) async {
    try {
      final objectId = ObjectId.fromHexString(id);
      
      // Build update modifier based on provided fields
      var modifier = modify;
      if (updateData.containsKey('name')) modifier = modifier.set('name', updateData['name']);
      if (updateData.containsKey('email')) modifier = modifier.set('email', updateData['email']);
      if (updateData.containsKey('age')) modifier = modifier.set('age', updateData['age']);

      final result = await _collection.updateOne(
        where.id(objectId),
        modifier
      );
      return result.nModified == 1; // Returns true if one document was modified
    } catch (e) {
      return false;
    }
  }

  // Delete a user
  Future<bool> deleteUser(String id) async {
    try {
      final objectId = ObjectId.fromHexString(id);
      final result = await _collection.deleteOne(where.id(objectId));
      return result.nRemoved == 1; // Returns true if one document was removed
    } catch (e) {
      return false;
    }
  }
}
