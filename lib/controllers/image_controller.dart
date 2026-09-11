import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/shelf_multipart.dart';
import '../services/cloudinary_service.dart';

class ImageController {
  final CloudinaryService _cloudinary = CloudinaryService();

  Future<Response> uploadImage(Request request) async {
    // নতুন Dart 3 সিনট্যাক্স দিয়ে চেক করা হচ্ছে রিকোয়েস্টটি form-data কি না
    if (request.formData() case var form?) {
      try {
        List<int> fileBytes = [];
        String filename = 'upload.png';
        String? name;
        String? email;
        String? age;

        // ফর্মের প্রতিটি ডেটা (পার্ট) চেক করা
        await for (final formData in form.formData) {
          // আমরা আশা করছি ইউজার 'image' ফিল্ডে ছবি পাঠাবে
          if (formData.name == 'image') {
            filename = formData.filename ?? 'upload.png';

            // Stream থেকে বাইটগুলো রিড করে List<int> এ কনভার্ট করা
            final bytesList = await formData.part.toList();
            fileBytes = bytesList.expand((x) => x).toList();
          } else if (formData.name == 'name') {
            name = await formData.part.readString();
          } else if (formData.name == 'email') {
            email = await formData.part.readString();
          } else if (formData.name == 'age') {
            age = await formData.part.readString();
          }
        }

        if (fileBytes.isEmpty) {
          return Response.badRequest(
            body: jsonEncode({
              'error': 'No image provided in form-data key "image"',
            }),
            headers: {'content-type': 'application/json'},
          );
        }

        // Cloudinary তে আপলোড করা
        final imageUrl = await _cloudinary.uploadImage(fileBytes, filename);

        if (imageUrl != null) {
          return Response.ok(
            jsonEncode({
              'message': 'Image uploaded successfully',
              'data': {
                'url': imageUrl,
                'name': name,
                'email': email,
                'age': age,
              },
            }),
            headers: {'content-type': 'application/json'},
          );
        } else {
          return Response.internalServerError(
            body: jsonEncode({'error': 'Failed to upload image'}),
            headers: {'content-type': 'application/json'},
          );
        }
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}),
          headers: {'content-type': 'application/json'},
        );
      }
    } else {
      // যদি রিকোয়েস্টটি multipart/form-data না হয়
      return Response.badRequest(
        body: jsonEncode({'error': 'Request must be multipart/form-data'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }
}
