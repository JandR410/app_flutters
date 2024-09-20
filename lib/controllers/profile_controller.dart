
import 'package:get/get.dart';
import 'package:ordencompra/repository/authentication/authentication_repository.dart';
import 'package:ordencompra/repository/user_repository/user_repository.dart';

import '../models/user_model.dart';

class ProfileController extends GetxController{
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  getUserData(){
    final id = _authRepo.firebaseUser?.uid;

    if(id != null){
      return _userRepo.getUserDetails(id);
    } else {
      Get.snackbar("Error", "Login to continue");
    }
  }

  Future<List<UserModel>> getAllUser() async{
    return await _userRepo.allUser();
  }
}