import 'package:mongo_dart/mongo_dart.dart';

class UserModel {
  final ObjectId? id;
  final String name;
  final String email;
  final int age;
  final String roll;
  final String? password; // নতুন অ্যাড করা হলো

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.roll,
    this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as ObjectId?,
      name: map['name'] as String,
      email: map['email'] as String,
      age: map['age'] as int,
      roll: map['roll'] as String,
      password: map['password'] as String?, // ডাটাবেস থেকে নেওয়া
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'email': email,
      'age': age,
      'roll': roll,
      if (password != null) 'password': password,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id?.toHexString(),
      'name': name,
      'email': email,
      'age': age,
      'roll': roll,
      // রেসপন্সে সিকিউরিটির জন্য পাসওয়ার্ড পাঠাবেন না, তাই toJson-এ password বাদ দিলাম
    };
  }
}
