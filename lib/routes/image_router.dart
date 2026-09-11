import 'package:shelf_router/shelf_router.dart';
import '../controllers/image_controller.dart';

class ImageRoutes {
  final ImageController _controller = ImageController();

  Router get router {
    final router = Router();
    router.post('/upload', _controller.uploadImage);
    return router;
  }
}
