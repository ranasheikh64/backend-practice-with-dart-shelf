import 'dart:io';
import 'package:dart_backend_demo/routes/image_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
// ignore: depend_on_referenced_packages
import 'package:hotreloader/hotreloader.dart';

// Import local files
import 'package:dart_backend_demo/config/database.dart';
import 'package:dart_backend_demo/routes/user_routes.dart';

void main() async {
  await HotReloader.create(
    onAfterReload: (context) async {
      print('Auto Restered at ${DateTime.now()}');
    },
  );

  // ... your other code

  // cleanup
  // reloader.stop();
  // MongoDB ডাটাবেস কানেক্ট করা
  await Database.connect();

  // মেইন রাউটার তৈরি করা
  final appRouter = Router();

  // বেসিক হোম রাউট
  appRouter.get('/', (Request request) {
    return Response.ok(
      'Dart Backend is Running! on PORT: 8080',
      headers: {'content-type': 'text/plain; charset=utf-8'},
    );
  });

  // ইউজার রাউট মাউন্ট করা (সব /users রিকোয়েস্ট UserRoutes হ্যান্ডেল করবে)
  appRouter.mount('/users', UserRoutes().router.call);
  appRouter.mount('/images', ImageRoutes().router.call);

  // পাইপলাইন সেটআপ (মিডলওয়্যার + রাউটার)
  final handler = Pipeline()
      .addMiddleware(logRequests()) // রিকোয়েস্ট লগ করার জন্য
      .addHandler(appRouter.call);

  // সার্ভার রান করা
  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);

  print('সার্ভার চালু হয়েছে: http://localhost:${server.port}');
}
