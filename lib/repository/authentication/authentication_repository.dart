import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ordencompra/features/screens/dashboard_screen.dart';
import 'package:ordencompra/features/screens/detalleoc_screen.dart';
import 'package:ordencompra/repository/authentication/exceptions/t_exceptiones.dart';

import '../../features/screens/onboard_screend.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  late final Rx<User?> _firebaseUser;
  final _auth = FirebaseAuth.instance;

  User? get firebaseUser => _firebaseUser.value;
  String get getUserID => firebaseUser?.uid ?? "";
  String get getUserEmail => firebaseUser?.email ?? "";
  String get getDisplayName => firebaseUser?.displayName ?? "";

  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    setInitialScreen(_firebaseUser.value);
  }

  /// Setting initial screen
  setInitialScreen(User? user) async {
    user == null
        ? Get.offAll(() => const OnboardingScreen())
        : user.emailVerified
            ? Get.offAll(() => const DashboardScreen(
                  idUser: '',
                  nameId: '',
                  docUSer: '',
                ))
            : Get.offAll(
                () => const DetalleOCScreen(
                  docUSer: '',
                  idUser: '',
                  nameId: '',
                ),
              );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = TExceptions();
      throw ex.message;
    }
  }
}
