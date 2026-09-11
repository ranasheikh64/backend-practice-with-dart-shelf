import 'package:dart_backend_demo/utils/auth_middleware.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controllers/user_controller.dart';

class UserRoutes {
  final UserController _controller = UserController();

  Router get router {
    final router = Router();

    // Create User
    router.post('/', _controller.createUser);
    router.post('/login', _controller.userLogin);

    // Get all Users
    router.get('/', _controller.getAllUsers);

    // Get single User by ID
    router.get('/<id>', _controller.getUserById);
    // Update User by ID
    router.put('/<id>', secureWithId(_controller.updateUser));

    // Delete User by ID (With Middleware)
    router.delete('/<id>', secureWithId(_controller.deleteUser));

    return router;
  }
}
