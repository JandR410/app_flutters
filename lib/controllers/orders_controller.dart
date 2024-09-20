import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordencompra/models/orders_model.dart';
import 'package:ordencompra/repository/authentication/authentication_repository.dart';
import 'package:ordencompra/repository/orders_repository/orders_repository.dart';
import 'package:ordencompra/utils/theme/theme.dart';
import 'package:poapprovalsdk/api.dart';

class OrdersController extends GetxController {
  static OrdersController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(OrdersRepository());

  RxString collectionId = ''.obs;
  RxString docUserId = ''.obs;

  final ScrollController scrollController = ScrollController();

  RxBool isAprobarMasivo = false.obs;
  RxList ordersList = [].obs;
  RxBool isLoading = false.obs;

  RxMap<String, bool> isCheckedMap = <String, bool>{}.obs;

  @override
  void onReady() {
    super.onReady();
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('purchase_orders');
    collectionId.value = collectionReference.id;
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  getOrdersData(idKey) {
    final id = _authRepo.firebaseUser?.uid;
    if (id != null) {
      return _userRepo.getOrdersDetails(idKey);
    } else {
      Get.snackbar("Error", "No Data Orders");
    }
  }

  getItemsData() {
    final id = _authRepo.firebaseUser?.uid;
    if (id != null) {
      return _userRepo.getItems();
    } else {
      Get.snackbar("Error", "No Data Items");
    }
  }

  getApprovalData() {
    final id = _authRepo.firebaseUser?.uid;
    if (id != null) {
      return _userRepo.getApproval();
    } else {
      Get.snackbar("Error", "No Data Approval");
    }
  }

  void getDocumentIds() async {
    final _authRepo = Get.put(AuthenticationRepository());
    final id = _authRepo.firebaseUser?.uid;
    var docUser;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('purchase_orders').get();

    List<String> documentIds = [];

    querySnapshot.docs.forEach((doc) {
      documentIds.add(doc.id);
    });

    var docIdUser =
        (documentIds.toString()).replaceAll("[", "").replaceAll("]", "");
    print(documentIds);

    docUserId.value = docIdUser.replaceAll("[]", "");
  }

  Future<void> cancelarMasivoOrdenCompra() async {
    ordersList.clear();
    isCheckedMap.forEach(
      (key, value) {
        isCheckedMap[key] = false;
      },
    );
  }

  void rechazarMasivoOrdenCompra() {
    if (ordersList.isNotEmpty) {
      print('Todo bien');
    } else {
      Get.snackbar(
        "Error",
        "No hay ordenes de compras seleccionadas",
        backgroundColor: lightColorScheme.error,
        colorText: lightColorScheme.onError,
        icon: Icon(
          Icons.error,
          color: lightColorScheme.onError,
          size: 30,
        ),
      );
    }
  }

  Future<void> continuarMasivoOrdenCompra() async {
    if (ordersList.isNotEmpty) {
      for (var i = 0; i < ordersList.length; i++) {
        String docId = ordersList[i]['id'];
        String responsable = '';

        // QuerySnapshot queryOC = await FirebaseFirestore.instance
        //     .collection('purchase_orders')
        //     .where("id", isEqualTo: docId)
        //     .get();

        // queryOC.docs.map((doc) {
        //   responsable = doc['responsible_id'];
        // });

        // QuerySnapshot queryAprovadores = await FirebaseFirestore.instance
        //     .collection('purchase_orders')
        //     .doc(docId)
        //     .collection('approvers')
        //     .get();

        // queryAprovadores.docs.map((doc) {
        //   if (doc['status'] == 'PENDING_APPROVAL' &&
        //       responsable != doc['approver_id']) {
        //     ordersList[i]['idApprover'] = doc['approver_id'];
        //   }
        // });
      }
      dialogAprobarMasivoOrdenCompra();
    } else {
      Get.snackbar(
        "Error",
        "No hay ordenes de compras seleccionadas",
        backgroundColor: lightColorScheme.error,
        colorText: lightColorScheme.onError,
        icon: Icon(
          Icons.error,
          color: lightColorScheme.onError,
          size: 30,
        ),
      );
    }
  }

  void dialogAprobarMasivoOrdenCompra() {
    Get.defaultDialog(
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.all(20),
      contentPadding: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
      title: "Aprobar Órdenes de Compra",
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      content: Stack(
        children: [
          Column(
            children: [
              const Text(
                'Recuerda evitar el spam al aprobador',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  letterSpacing: 1,
                  decorationThickness: 1,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Define el radio aquí
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      lightColorScheme.primary,
                    ),
                  ),
                  onPressed: () async {
                    await aprobarOrdenCompra();
                  },
                  child: Text(
                    "Si, notificar",
                    style: TextStyle(
                      color: lightColorScheme.onPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Define el radio aquí
                      ),
                    ),
                    side: MaterialStateProperty.resolveWith<BorderSide>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return BorderSide(
                          color: lightColorScheme.error,
                        );
                      }
                      return BorderSide(
                        color: lightColorScheme.error,
                      );
                    }),
                  ),
                  child: Text(
                    "No, cancelar",
                    style: TextStyle(
                      color: lightColorScheme.error,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(() => (isLoading.value)
              ? Center(
                  child: CircularProgressIndicator(
                    color: lightColorScheme.primary,
                  ),
                )
              : const SizedBox())
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> aprobarOrdenCompra() async {
    isLoading.value = true;
    try {
      final api = ApiClient(
          basePath: 'https://po-approvals-api-dev-t5mqaxgq2q-uc.a.run.app');
      IdTokenResult? tokenResult =
          await FirebaseAuth.instance.currentUser?.getIdTokenResult();
      api.addDefaultHeader('Authorization', "Bearer ${tokenResult?.token}");
      final apiNotify = PurchaseOrdersApi(api);

      for (var i = 0; i < ordersList.length; i++) {
        String docId = ordersList[i]['id'];
        String idApprover = ordersList[i]['idApprover'];

        await apiNotify.notifyPurchaseOrderReview(docId, idApprover);
      }

      await cancelarMasivoOrdenCompra();

      Get.snackbar(
        "Exito",
        "Orden de compra aprobada",
        backgroundColor: lightColorScheme.primary,
        colorText: lightColorScheme.onPrimary,
        icon: Icon(
          Icons.check_circle,
          color: lightColorScheme.onPrimary,
          size: 30,
        ),
      );
      isLoading.value = false;
      Get.back();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Error al aprobar orden de compra ${e.toString()}",
        backgroundColor: lightColorScheme.error,
        colorText: lightColorScheme.onError,
        icon: Icon(
          Icons.error,
          color: lightColorScheme.onError,
          size: 30,
        ),
      );
    }
  }

  void validarOrdenCompra(
    ocNumber,
    idCollection,
    ocTabBar,
    idUser,
    docUSer,
  ) {
    Map<String, dynamic> data = {
      "id": ocNumber,
      "idCollection": idCollection,
      "ocTabBar": ocTabBar,
      "idUser": idUser,
      "docUSer": docUSer,
      "idApprover": "",
    };
    if (isCheckedMap[ocNumber] == true) {
      ordersList.add(data);
    } else {
      ordersList.removeWhere((element) => element['id'] == ocNumber);
    }

    print(ordersList);
  }
}
