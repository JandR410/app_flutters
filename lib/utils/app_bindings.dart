import 'package:get/get.dart';
import 'package:ordencompra/repository/orders_repository/orders_repository.dart';

import '../controllers/app_controller.dart';
import '../repository/authentication/authentication_repository.dart';
import '../repository/user_repository/user_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthenticationRepository(), fenix: true);
    Get.lazyPut(() => UserRepository(), fenix: true);
    Get.lazyPut(() => OrdersRepository(), fenix: true);
    Get.put(AppController(), permanent: true);
  }
}
