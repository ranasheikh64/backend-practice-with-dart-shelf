import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

String generateJwtToken(String userId) {
  final jwt = JWT({
    'id': userId,
    'role': 'user',
  });

  // expiresIn দিলেই টাইম জেনারেট হয়ে যাবে
  final token = jwt.sign(
    SecretKey('amar_secret_key_12345'),
    expiresIn: Duration(days: 1),
  );

  return token;
}
