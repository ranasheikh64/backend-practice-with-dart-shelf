import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class CloudinaryService {
  final String cloudName = 'dbmnia6qh';
  final String apiKey = '511784252694518';
  final String apiSecret = '8bWsPY1PL7S_CcC_JwORPYZ3iMg';

  Future<String?> uploadImage(List<int> fileBytes, String filename) async {
    // বর্তমান সময়ের timestamp (সেকেন্ডে)
    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000)
        .toString();

    // Signature তৈরি করা: SHA1("timestamp=xxxAPI_SECRET")
    final signatureString = 'timestamp=$timestamp$apiSecret';
    final signature = sha1.convert(utf8.encode(signatureString)).toString();

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    // Multipart Request তৈরি
    var request = http.MultipartRequest('POST', url)
      ..fields['api_key'] = apiKey
      ..fields['timestamp'] = timestamp
      ..fields['signature'] = signature
      ..files.add(
        http.MultipartFile.fromBytes(
          'file', // Cloudinary 'file' ফিল্ড এক্সপেক্ট করে
          fileBytes,
          filename: filename,
        ),
      );

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        return jsonResponse['secure_url']; // ছবির লিংক রিটার্ন করবে
      } else {
        print('Cloudinary Error: ${jsonResponse['error']['message']}');
        return null;
      }
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }
}
