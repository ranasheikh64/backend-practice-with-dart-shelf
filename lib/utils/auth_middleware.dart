import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

// একটি কাস্টম মিডলওয়্যার ফাংশন
Middleware checkAuthMiddleware() {
  return createMiddleware(
    // রিকোয়েস্ট রাউটারে পৌঁছানোর আগে এই অংশটি কাজ করবে
    requestHandler: (Request request) {
      // ক্লায়েন্টের পাঠানো হেডার থেকে Authorization টোকেনটি নেওয়া হচ্ছে
      final authHeader = request.headers['authorization'];

      // চেক করা হচ্ছে টোকেনটি 'Bearer ' দিয়ে শুরু হয়েছে কি না
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.forbidden(jsonEncode({'error': 'Token is missing!'}));
      }

      final token = authHeader.substring(7);
      try {
        final jwt = JWT.verify(token, SecretKey('amar_secret_key_12345'));
        print(jwt.payload);
      } on JWTExpiredException {
        return Response.forbidden(jsonEncode({'error': 'Token Expired!'}));
      } catch (e) {
        print(e);
      }

      // উদাহরণস্বরূপ: আমরা চেক করছি টোকেনটি 'my_secret_token' কি না
      if (authHeader == 'my_secret_token') {
        // টোকেন ঠিক থাকলে null রিটার্ন করতে হবে। (এর মানে হলো: সব ঠিক আছে, রিকোয়েস্ট সামনে যেতে দাও)
        return null;
      } else {
        // টোকেন ভুল থাকলে বা না থাকলে আমরা এখান থেকেই 403 Forbidden এরর দিয়ে দেব
        return Response.forbidden(
          jsonEncode({'error': 'Unauthorized access. Invalid token!'}),
          headers: {'content-type': 'application/json'},
        );
      }
    },

    // (অপশনাল) রেসপন্স ক্লায়েন্টের কাছে যাওয়ার ঠিক আগে এই অংশটি কাজ করবে
    responseHandler: (Response response) {
      // আপনি চাইলে রেসপন্সের সাথে গ্লোবালি কোনো কাস্টম হেডার যুক্ত করে দিতে পারেন
      return response.change(headers: {'x-custom-header': 'Dart Backend Team'});
    },
  );
}

// প্যারামিটার (যেমন: <id>) সহ রাউটগুলোর জন্য কাস্টম উইজেট/ফাংশন
Function(Request, String) secureWithId(
  Future<Response> Function(Request, String) handler,
) {
  return (Request request, String id) {
    final pipeline = Pipeline()
        .addMiddleware(checkAuthMiddleware()) // আপনার অথ মিডলওয়্যার
        .addHandler((req) => handler(req, id));

    return pipeline(request);
  };
}
