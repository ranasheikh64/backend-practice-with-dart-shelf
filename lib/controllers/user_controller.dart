// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'package:dart_backend_demo/utils/jwt_token_generate.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserController {
  final UserRepository _repository = UserRepository();

  // Route: POST /users
  Future<Response> createUser(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      // ১. Validate required fields
      final requiredFields = ['name', 'email', 'age', 'roll', 'password'];
      for (var field in requiredFields) {
        if (data[field] == null || data[field].toString().trim().isEmpty) {
          final fieldName = field[0].toUpperCase() + field.substring(1);
          return Response.badRequest(
            body: jsonEncode({'error': '$fieldName is required'}),
          );
        }
      }

      // ২. ইমেইল চেক করার জন্য getUserByEmail ব্যবহার করতে হবে
      final isEmailExist = await _repository.getUserByEmail(data['email']);
      if (isEmailExist != null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Email already exists'}),
        );
      }

      // ৩. পাসওয়ার্ড হ্যাশ করা হচ্ছে
      final String hashedPassword = BCrypt.hashpw(
        data['password'],
        BCrypt.gensalt(),
      );

      // ৪. ইউজার মডেল তৈরি করা
      final user = UserModel(
        id: ObjectId(),
        name: data['name'],
        email: data['email'],
        age: data['age'],
        roll: data['roll'],
        password: hashedPassword, // হ্যাশ করা পাসওয়ার্ড
      );

      // ৫. ডাটাবেসে সেভ করা
      await _repository.createUser(user);

      return Response.ok(
        jsonEncode({
          'message': 'User created successfully',
          'data': user.toJson(),
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }

  Future<Response> userLogin(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);
      final email = data['email'];
      final password = data['password'];
      if (email == null || password == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Email and password are required'}),
        );
      }
      // getUserById এর বদলে getUserByEmail কল করুন
      final user = await _repository.getUserByEmail(email);
      if (user == null) {
        return Response.notFound(jsonEncode({'error': 'User not found'}));
      }
      // পাসওয়ার্ড চেক করুন (আগে UserModel এ password ফিল্ড না থাকায় এটি এরর দিত)
      final isPasswordCorrect = BCrypt.checkpw(password, user.password!);
      if (!isPasswordCorrect) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Invalid password'}),
        );
      }
      // টোকেন তৈরি করার সময় id টিকে HexString এ কনভার্ট করে দিন
      final token = generateJwtToken(user.id!.toHexString());
      return Response.ok(
        jsonEncode({
          'message': 'User logged in successfully',
          'data': {'token': token, 'user': user.toJson()},
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }

  // Route: GET /users
  Future<Response> getAllUsers(Request request) async {
    try {
      final users = await _repository.getAllUsers();
      final usersJson = users.map((u) => u.toJson()).toList();
      return Response.ok(
        jsonEncode({"Users": "Users fetched successfully", "data": usersJson}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }

  // Route: GET /users/<id>
  Future<Response> getUserById(Request request, String id) async {
    try {
      final user = await _repository.getUserById(id);
      if (user == null) {
        return Response.notFound(jsonEncode({'error': 'User not found'}));
      }
      return Response.ok(
        jsonEncode(user.toJson()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }

  Future<Response> getUserByEmail(Request request, String email) async {
    try {
      final user = await _repository.getUserByEmail(email);
      if (user == null) {
        return Response.notFound(jsonEncode({'error': 'User not found'}));
      }
      return Response.ok(
        jsonEncode(user.toJson()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }

  // Route: PUT /users/<id>
  Future<Response> updateUser(Request request, String id) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      final success = await _repository.updateUser(id, data);
      if (success) {
        return Response.ok(
          jsonEncode({'message': 'User updated successfully'}),
          headers: {'content-type': 'application/json'},
        );
      } else {
        return Response.notFound(
          jsonEncode({'error': 'User not found or update failed'}),
        );
      }
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }

  // Route: DELETE /users/<id>
  Future<Response> deleteUser(Request request, String id) async {
    try {
      final success = await _repository.deleteUser(id);
      if (success) {
        return Response.ok(
          jsonEncode({'message': 'User deleted successfully'}),
          headers: {'content-type': 'application/json'},
        );
      } else {
        return Response.notFound(
          jsonEncode({'error': 'User not found or delete failed'}),
        );
      }
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }
}
