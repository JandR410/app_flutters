import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ordencompra/controllers/orders_controller.dart';
import 'package:ordencompra/features/screens/informacionoc_screen.dart';
import 'package:ordencompra/features/widgets/cardocpendientes_form.dart';
import 'package:ordencompra/utils/constants/text_strings.dart';
import 'package:ordencompra/utils/theme/theme.dart';

import '../../controllers/stream_controller.dart';
import '../../repository/authentication/authentication_repository.dart';

class PendientesScreen extends GetView<OrdersController> {
  final idUser;
  final nameId;
  final docUSer;

  const PendientesScreen({
    super.key,
    required this.idUser,
    required this.nameId,
    required this.docUSer,
  });

  @override
  Widget build(BuildContext context) {
    var docUserId;
    String name = '';

    return Scrollbar(
      child: Scaffold(
          body: Scrollbar(
        controller: controller.scrollController,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('purchase_orders')
                .orderBy("issued_at", descending: true)
                .where("stakeholders", arrayContains: idUser)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/emptyPendiente.png',
                        width: 254,
                        height: 210,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                activeColor: Colors.black,
                                value: controller.isAprobarMasivo.value,
                                onChanged: (bool? value) {
                                  controller.isAprobarMasivo.value = value!;
                                },
                              ),
                            ),
                            const Text(
                              'Aprobar varias órdenes de compra',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  fontFamily: 'Lato-Regular'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Scrollbar(
                            thumbVisibility:
                                true, // Hace que el Scrollbar sea visible
                            trackVisibility:
                                true, // Hace que el Scrollbar siempre sea visible
                            controller: controller.scrollController,
                            child: ListView.builder(
                              controller: controller.scrollController,
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: false,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final users = snapshot.data?.docs ?? [];
                                var data = snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                                Map<String, dynamic> dataMetadata =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;
                                name = nameId;
                                final user = users[index];
                                var dataU = user.data() as Map<String, dynamic>;
                                final stakeholders = List<String>.from(
                                    dataU['stakeholders'] ?? []);
                                final dataMeta = '';
                                var demo = stakeholders;
                                final status = data['status'];

                                if (status == 'PENDING_APPROVAL') {
                                  if (name.isEmpty) {
                                    final idCollection =
                                        controller.collectionId.value;
                                    final ocTabBar =
                                        data['purchase_order_number'];
                                    final ocId = data['purchase_order_number'];
                                    final documentId = data['id'];
                                    final ocNumber = data['id'];
                                    final ORG = data['organization_id'];
                                    Timestamp fechaC = data['issued_at'] == null
                                        ? Timestamp.now()
                                        : data['issued_at'];

                                    String dataMeta = DateFormat('dd/MM/yyyy')
                                        .format(fechaC.toDate());

                                    var currency = '';

                                    DateTime dt =
                                        (data['issued_at'] as Timestamp)
                                            .toDate();
                                    final now = DateTime.now();
                                    final difference = now.difference(dt);

                                    String timeMessage;
                                    if (difference.inMinutes < 1) {
                                      timeMessage = 'Ahorita';
                                    } else if (difference.inMinutes < 60) {
                                      timeMessage =
                                          'Hace ${difference.inMinutes} minutos';
                                    } else if (difference.inMinutes < 120) {
                                      timeMessage = 'Hace 1 hora';
                                    } else {
                                      timeMessage = DateFormat('dd/MM/yyyy')
                                          .format(fechaC.toDate());
                                    }

                                    if (data['currency'] == 'USD') {
                                      currency = '\$';
                                    } else if (data['currency'] == 'PEN') {
                                      currency = "S/ ";
                                    } else {
                                      currency = 'USD';
                                    }
                                    controller.isCheckedMap
                                        .putIfAbsent(ocNumber, () => false);
                                    return ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(context)
                                          .copyWith(scrollbars: false),
                                      child: Obx(
                                        () => (controller.isAprobarMasivo.value)
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Obx(
                                                    () => Checkbox(
                                                      activeColor: Colors.black,
                                                      value: controller
                                                              .isCheckedMap[
                                                          ocNumber],
                                                      onChanged: (bool? value) {
                                                        controller.isCheckedMap[
                                                            ocNumber] = value!;

                                                        controller
                                                            .validarOrdenCompra(
                                                          ocNumber,
                                                          idCollection,
                                                          ocTabBar,
                                                          idUser,
                                                          docUSer,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Card(
                                                      color: Colors.white,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 20,
                                                              left: 20,
                                                              top: 10),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        InformacionScreen(
                                                                          id: ocNumber,
                                                                          idCollection:
                                                                              idCollection,
                                                                          ocTabBar:
                                                                              ocTabBar,
                                                                          idUser:
                                                                              idUser,
                                                                          docUSer:
                                                                              docUSer,
                                                                        )),
                                                          );
                                                        },
                                                        child:
                                                            ScrollConfiguration(
                                                          behavior:
                                                              ScrollConfiguration
                                                                      .of(
                                                                          context)
                                                                  .copyWith(
                                                                      scrollbars:
                                                                          false),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          1),
                                                              height: 220,
                                                              color:
                                                                  Colors.white,
                                                              child: Container(
                                                                height: 220,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  border:
                                                                      Border(
                                                                    left: BorderSide(
                                                                        width:
                                                                            5.0,
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                ),
                                                                child:
                                                                    ScrollConfiguration(
                                                                  behavior: ScrollConfiguration.of(
                                                                          context)
                                                                      .copyWith(
                                                                          scrollbars:
                                                                              false),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top: 0,
                                                                        right:
                                                                            20,
                                                                        left:
                                                                            20,
                                                                        bottom:
                                                                            20),
                                                                    child:
                                                                        StreamBuilder(
                                                                      stream: FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'purchase_orders') // Replace with your subcollection
                                                                          .snapshots(),
                                                                      builder: (BuildContext
                                                                              context,
                                                                          AsyncSnapshot<QuerySnapshot>
                                                                              snapshot) {
                                                                        var subject =
                                                                            "";
                                                                        var tSubject =
                                                                            (data['subject'].toString());
                                                                        if (tSubject ==
                                                                            " ") {
                                                                          subject =
                                                                              "-------";
                                                                        } else if (tSubject ==
                                                                            "") {
                                                                          subject =
                                                                              "-------";
                                                                        } else {
                                                                          subject =
                                                                              (data['subject'].toString());
                                                                        }
                                                                        return CardocPendientesFormScreen(
                                                                          amount:
                                                                              NumberFormat.currency(symbol: '$currency ').format((data['total_amount'])),
                                                                          id: (data['purchase_order_number']
                                                                              .toString()),
                                                                          subject:
                                                                              subject,
                                                                          aprovador:
                                                                              '',
                                                                          ORG:
                                                                              ORG,
                                                                          dataArriedAt:
                                                                              timeMessage,
                                                                          documentId:
                                                                              documentId,
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Card(
                                                color: Colors.white,
                                                margin: const EdgeInsets.only(
                                                    right: 20,
                                                    left: 20,
                                                    top: 10),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              InformacionScreen(
                                                                id: ocNumber,
                                                                idCollection:
                                                                    idCollection,
                                                                ocTabBar:
                                                                    ocTabBar,
                                                                idUser: idUser,
                                                                docUSer:
                                                                    docUSer,
                                                              )),
                                                    );
                                                  },
                                                  child: ScrollConfiguration(
                                                    behavior:
                                                        ScrollConfiguration.of(
                                                                context)
                                                            .copyWith(
                                                                scrollbars:
                                                                    false),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 1),
                                                        height: 220,
                                                        color: Colors.white,
                                                        child: Container(
                                                          height: 220,
                                                          decoration:
                                                              const BoxDecoration(
                                                            border: Border(
                                                              left: BorderSide(
                                                                  width: 5.0,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                          child:
                                                              ScrollConfiguration(
                                                            behavior: ScrollConfiguration
                                                                    .of(context)
                                                                .copyWith(
                                                                    scrollbars:
                                                                        false),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 0,
                                                                      right: 20,
                                                                      left: 20,
                                                                      bottom:
                                                                          20),
                                                              child:
                                                                  StreamBuilder(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'purchase_orders') // Replace with your subcollection
                                                                    .snapshots(),
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot<
                                                                            QuerySnapshot>
                                                                        snapshot) {
                                                                  var subject =
                                                                      "";
                                                                  var tSubject =
                                                                      (data['subject']
                                                                          .toString());
                                                                  if (tSubject ==
                                                                      " ") {
                                                                    subject =
                                                                        "-------";
                                                                  } else if (tSubject ==
                                                                      "") {
                                                                    subject =
                                                                        "-------";
                                                                  } else {
                                                                    subject = (data[
                                                                            'subject']
                                                                        .toString());
                                                                  }
                                                                  return CardocPendientesFormScreen(
                                                                    amount: NumberFormat.currency(
                                                                            symbol:
                                                                                '$currency ')
                                                                        .format(
                                                                            (data['total_amount'])),
                                                                    id: (data[
                                                                            'purchase_order_number']
                                                                        .toString()),
                                                                    subject:
                                                                        subject,
                                                                    aprovador:
                                                                        '',
                                                                    ORG: ORG,
                                                                    dataArriedAt:
                                                                        timeMessage,
                                                                    documentId:
                                                                        documentId,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    );
                                  }
                                }
                                if (status == 'PENDING_APPROVAL') {
                                  if (name.isNotEmpty) {
                                    if (data['supplier_document_number']
                                        .toString()
                                        .contains(name)) {
                                      final idCollection =
                                          controller.collectionId.value;
                                      final ocTabBar =
                                          data['purchase_order_number'];
                                      final ocId =
                                          data['purchase_order_number'];
                                      final documentId = data['id'];
                                      final ORG = data['organization_id'];
                                      final ocNumber = data['id'];
                                      var currency = '';
                                      if (data['currency'] == 'USD') {
                                        currency = '\$';
                                      } else if (data['currency'] == 'PEN') {
                                        currency = "S/ ";
                                      } else {
                                        currency = 'USD';
                                      }
                                      controller.isCheckedMap
                                          .putIfAbsent(ocNumber, () => false);
                                      return ScrollConfiguration(
                                        behavior:
                                            ScrollConfiguration.of(context)
                                                .copyWith(scrollbars: false),
                                        child: Obx(
                                          () =>
                                              (controller.isAprobarMasivo.value)
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Obx(
                                                          () => Checkbox(
                                                            activeColor:
                                                                Colors.black,
                                                            value: controller
                                                                    .isCheckedMap[
                                                                ocNumber],
                                                            onChanged:
                                                                (bool? value) {
                                                              controller.isCheckedMap[
                                                                      ocNumber] =
                                                                  value!;

                                                              controller
                                                                  .validarOrdenCompra(
                                                                ocNumber,
                                                                idCollection,
                                                                ocTabBar,
                                                                idUser,
                                                                docUSer,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Card(
                                                            color: Colors.white,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 20,
                                                                    left: 20,
                                                                    top: 10),
                                                            child:
                                                                ScrollConfiguration(
                                                              behavior: ScrollConfiguration
                                                                      .of(
                                                                          context)
                                                                  .copyWith(
                                                                      scrollbars:
                                                                          false),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .white,
                                                                  child:
                                                                      Container(
                                                                    height: 220,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      border:
                                                                          Border(
                                                                        left: BorderSide(
                                                                            width:
                                                                                5.0,
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        ScrollConfiguration(
                                                                      behavior: ScrollConfiguration.of(
                                                                              context)
                                                                          .copyWith(
                                                                              scrollbars: false),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            20),
                                                                        child:
                                                                            StreamBuilder(
                                                                          stream: FirebaseFirestore
                                                                              .instance
                                                                              .collection('purchase_orders') // Replace with your subcollection
                                                                              .snapshots(),
                                                                          builder:
                                                                              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                            var subject =
                                                                                "";
                                                                            var tSubject =
                                                                                (data['subject'].toString());
                                                                            if (tSubject ==
                                                                                " ") {
                                                                              subject = "-------";
                                                                            } else if (tSubject ==
                                                                                "") {
                                                                              subject = "-------";
                                                                            } else {
                                                                              subject = (data['subject'].toString());
                                                                            }
                                                                            return CardocPendientesFormScreen(
                                                                              amount: NumberFormat.currency(symbol: '$currency ').format((data['total_amount'])),
                                                                              id: (data['purchase_order_number'].toString()),
                                                                              subject: subject,
                                                                              aprovador: '',
                                                                              ORG: ORG,
                                                                              dataArriedAt: dataMeta,
                                                                              documentId: documentId,
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : Card(
                                                      color: Colors.white,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 20,
                                                              left: 20,
                                                              top: 10),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        InformacionScreen(
                                                                          id: ocNumber,
                                                                          idCollection:
                                                                              idCollection,
                                                                          ocTabBar:
                                                                              ocTabBar,
                                                                          idUser:
                                                                              idUser,
                                                                          docUSer:
                                                                              docUSer,
                                                                        )),
                                                          );
                                                        },
                                                        child:
                                                            ScrollConfiguration(
                                                          behavior:
                                                              ScrollConfiguration
                                                                      .of(
                                                                          context)
                                                                  .copyWith(
                                                                      scrollbars:
                                                                          false),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              child: Container(
                                                                height: 220,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  border:
                                                                      Border(
                                                                    left: BorderSide(
                                                                        width:
                                                                            5.0,
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                ),
                                                                child:
                                                                    ScrollConfiguration(
                                                                  behavior: ScrollConfiguration.of(
                                                                          context)
                                                                      .copyWith(
                                                                          scrollbars:
                                                                              false),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            20),
                                                                    child:
                                                                        StreamBuilder(
                                                                      stream: FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'purchase_orders') // Replace with your subcollection
                                                                          .snapshots(),
                                                                      builder: (BuildContext
                                                                              context,
                                                                          AsyncSnapshot<QuerySnapshot>
                                                                              snapshot) {
                                                                        var subject =
                                                                            "";
                                                                        var tSubject =
                                                                            (data['subject'].toString());
                                                                        if (tSubject ==
                                                                            " ") {
                                                                          subject =
                                                                              "-------";
                                                                        } else if (tSubject ==
                                                                            "") {
                                                                          subject =
                                                                              "-------";
                                                                        } else {
                                                                          subject =
                                                                              (data['subject'].toString());
                                                                        }
                                                                        return CardocPendientesFormScreen(
                                                                          amount:
                                                                              NumberFormat.currency(symbol: '$currency ').format((data['total_amount'])),
                                                                          id: (data['purchase_order_number']
                                                                              .toString()),
                                                                          subject:
                                                                              subject,
                                                                          aprovador:
                                                                              '',
                                                                          ORG:
                                                                              ORG,
                                                                          dataArriedAt:
                                                                              dataMeta,
                                                                          documentId:
                                                                              documentId,
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                        ),
                                      );
                                    }
                                  }
                                }
                                if (status == 'PENDING_APPROVAL') {
                                  if (name.isNotEmpty) {
                                    if (data['organization_name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(name)) {
                                      final idCollection =
                                          controller.collectionId.value;
                                      final ocTabBar =
                                          data['purchase_order_number'];
                                      final ocId =
                                          data['purchase_order_number'];
                                      final documentId = data['id'];
                                      final ORG = data['organization_id'];
                                      final ocNumber = data['id'];
                                      var currency = '';
                                      if (data['currency'] == 'USD') {
                                        currency = '\$';
                                      } else if (data['currency'] == 'PEN') {
                                        currency = "S/ ";
                                      } else {
                                        currency = 'USD';
                                      }
                                      controller.isCheckedMap
                                          .putIfAbsent(ocNumber, () => false);
                                      return ScrollConfiguration(
                                        behavior:
                                            ScrollConfiguration.of(context)
                                                .copyWith(scrollbars: false),
                                        child: Card(
                                            color: Colors.white,
                                            margin: const EdgeInsets.only(
                                                right: 20, left: 20, top: 10),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          InformacionScreen(
                                                              id: ocNumber,
                                                              idCollection:
                                                                  idCollection,
                                                              ocTabBar:
                                                                  ocTabBar,
                                                              idUser: idUser,
                                                              docUSer:
                                                                  docUSer)),
                                                );
                                              },
                                              child: ScrollConfiguration(
                                                behavior:
                                                    ScrollConfiguration.of(
                                                            context)
                                                        .copyWith(
                                                            scrollbars: false),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Container(
                                                      height: 230,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(
                                                          left: BorderSide(
                                                              width: 5.0,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                      child:
                                                          ScrollConfiguration(
                                                        behavior:
                                                            ScrollConfiguration
                                                                    .of(context)
                                                                .copyWith(
                                                                    scrollbars:
                                                                        false),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child: StreamBuilder(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'purchase_orders') // Replace with your subcollection
                                                                .snapshots(),
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        QuerySnapshot>
                                                                    snapshot) {
                                                              var subject = "";
                                                              var tSubject = (data[
                                                                      'subject']
                                                                  .toString());
                                                              if (tSubject ==
                                                                  " ") {
                                                                subject =
                                                                    "-------";
                                                              } else if (tSubject ==
                                                                  "") {
                                                                subject =
                                                                    "-------";
                                                              } else {
                                                                subject = (data[
                                                                        'subject']
                                                                    .toString());
                                                              }
                                                              return CardocPendientesFormScreen(
                                                                amount: NumberFormat.currency(
                                                                        symbol: currency +
                                                                            ' ')
                                                                    .format((data[
                                                                        'total_amount'])),
                                                                id: (data[
                                                                        'purchase_order_number']
                                                                    .toString()),
                                                                subject: (data[
                                                                        'subject']
                                                                    .toString()),
                                                                aprovador: '',
                                                                ORG: ORG,
                                                                dataArriedAt:
                                                                    dataMeta,
                                                                documentId:
                                                                    documentId,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                      );
                                    }
                                  }
                                }
                                if (status == 'PENDING_APPROVAL') {
                                  if (name.isNotEmpty) {
                                    if (data['purchase_order_number']
                                        .toString()
                                        .contains(name)) {
                                      final idCollection =
                                          controller.collectionId.value;
                                      final ocTabBar =
                                          data['purchase_order_number'];
                                      final ocId =
                                          data['purchase_order_number'];
                                      final documentId = data['id'];
                                      final ORG = data['organization_id'];
                                      final ocNumber = data['id'];
                                      var currency = '';
                                      if (data['currency'] == 'USD') {
                                        currency = '\$';
                                      } else if (data['currency'] == 'PEN') {
                                        currency = "S/ ";
                                      } else {
                                        currency = 'USD';
                                      }
                                      controller.isCheckedMap
                                          .putIfAbsent(ocNumber, () => false);
                                      return ScrollConfiguration(
                                        behavior:
                                            ScrollConfiguration.of(context)
                                                .copyWith(scrollbars: false),
                                        child: Card(
                                            color: Colors.white,
                                            margin: const EdgeInsets.only(
                                                right: 20, left: 20, top: 10),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          InformacionScreen(
                                                            id: ocNumber,
                                                            idCollection:
                                                                idCollection,
                                                            ocTabBar: ocTabBar,
                                                            idUser: idUser,
                                                            docUSer: docUSer,
                                                          )),
                                                );
                                              },
                                              child: ScrollConfiguration(
                                                behavior:
                                                    ScrollConfiguration.of(
                                                            context)
                                                        .copyWith(
                                                            scrollbars: false),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Container(
                                                      height: 230,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(
                                                          left: BorderSide(
                                                              width: 5.0,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                      child:
                                                          ScrollConfiguration(
                                                        behavior:
                                                            ScrollConfiguration
                                                                    .of(context)
                                                                .copyWith(
                                                                    scrollbars:
                                                                        false),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child: StreamBuilder(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'purchase_orders') // Replace with your subcollection
                                                                .snapshots(),
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        QuerySnapshot>
                                                                    snapshot) {
                                                              var subject = "";
                                                              var tSubject = (data[
                                                                      'subject']
                                                                  .toString());
                                                              if (tSubject ==
                                                                  " ") {
                                                                subject =
                                                                    "-------";
                                                              } else if (tSubject ==
                                                                  "") {
                                                                subject =
                                                                    "-------";
                                                              } else {
                                                                subject = (data[
                                                                        'subject']
                                                                    .toString());
                                                              }
                                                              return CardocPendientesFormScreen(
                                                                amount: NumberFormat.currency(
                                                                        symbol: currency +
                                                                            ' ')
                                                                    .format((data[
                                                                        'total_amount'])),
                                                                id: (data[
                                                                        'purchase_order_number']
                                                                    .toString()),
                                                                subject: (data[
                                                                        'subject']
                                                                    .toString()),
                                                                aprovador: '',
                                                                ORG: ORG,
                                                                dataArriedAt:
                                                                    dataMeta,
                                                                documentId:
                                                                    documentId,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                      );
                                    }
                                  }
                                }
                                if (status == 'PENDING_APPROVAL') {
                                  if (name.isNotEmpty) {
                                    if (data['supplier_organization_name']
                                        .toString()
                                        .contains(name)) {
                                      final idCollection =
                                          controller.collectionId.value;
                                      final ocTabBar =
                                          data['purchase_order_number'];
                                      final ocId =
                                          data['purchase_order_number'];
                                      final documentId = data['id'];
                                      final ORG = data['organization_id'];
                                      final ocNumber = data['id'];
                                      var currency = '';
                                      if (data['currency'] == 'USD') {
                                        currency = '\$';
                                      } else if (data['currency'] == 'PEN') {
                                        currency = "S/ ";
                                      } else {
                                        currency = 'USD';
                                      }
                                      controller.isCheckedMap
                                          .putIfAbsent(ocNumber, () => false);
                                      return ScrollConfiguration(
                                        behavior:
                                            ScrollConfiguration.of(context)
                                                .copyWith(scrollbars: false),
                                        child: Card(
                                          color: Colors.white,
                                          margin: const EdgeInsets.only(
                                              right: 20, left: 20, top: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        InformacionScreen(
                                                            id: ocNumber,
                                                            idCollection:
                                                                idCollection,
                                                            ocTabBar: ocTabBar,
                                                            idUser: idUser,
                                                            docUSer: docUSer)),
                                              );
                                            },
                                            child: ScrollConfiguration(
                                              behavior: ScrollConfiguration.of(
                                                      context)
                                                  .copyWith(scrollbars: false),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Container(
                                                    height: 230,
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        left: BorderSide(
                                                            width: 5.0,
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                    child: ScrollConfiguration(
                                                      behavior:
                                                          ScrollConfiguration
                                                                  .of(context)
                                                              .copyWith(
                                                                  scrollbars:
                                                                      false),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20),
                                                        child: StreamBuilder(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'purchase_orders') // Replace with your subcollection
                                                              .snapshots(),
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot<
                                                                      QuerySnapshot>
                                                                  snapshot) {
                                                            var subject = "";
                                                            var tSubject =
                                                                (data['subject']
                                                                    .toString());
                                                            if (tSubject ==
                                                                " ") {
                                                              subject =
                                                                  "-------";
                                                            } else if (tSubject ==
                                                                "") {
                                                              subject =
                                                                  "-------";
                                                            } else {
                                                              subject = (data[
                                                                      'subject']
                                                                  .toString());
                                                            }
                                                            return CardocPendientesFormScreen(
                                                              amount: NumberFormat
                                                                      .currency(
                                                                          symbol:
                                                                              '$currency ')
                                                                  .format((data[
                                                                      'total_amount'])),
                                                              id: (data[
                                                                      'purchase_order_number']
                                                                  .toString()),
                                                              subject: (data[
                                                                      'subject']
                                                                  .toString()),
                                                              aprovador: '',
                                                              ORG: ORG,
                                                              dataArriedAt:
                                                                  dataMeta,
                                                              documentId:
                                                                  documentId,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                        Obx(
                          () => (controller.isAprobarMasivo.value)
                              ? Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                  ),
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    left: 30,
                                    right: 30,
                                    bottom: 20,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            controller
                                                .continuarMasivoOrdenCompra();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                lightColorScheme.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Continuar',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton.icon(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10.0), // Define el radio aquí
                                              ),
                                            ),
                                            side: MaterialStateProperty
                                                .resolveWith<BorderSide>(
                                                    (Set<MaterialState>
                                                        states) {
                                              if (states.contains(
                                                  MaterialState.pressed)) {
                                                return BorderSide(
                                                  color: lightColorScheme.error,
                                                );
                                              }
                                              return BorderSide(
                                                color: lightColorScheme.error,
                                              );
                                            }),
                                          ),
                                          onPressed: () {
                                            controller
                                                .rechazarMasivoOrdenCompra();
                                          },
                                          icon: Icon(
                                            Icons.warning_amber_sharp,
                                            color: lightColorScheme.error,
                                          ),
                                          label: Text(
                                            'Rechazar',
                                            style: TextStyle(
                                              color: lightColorScheme.error,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10.0), // Define el radio aquí
                                              ),
                                            ),
                                            side: MaterialStateProperty
                                                .resolveWith<BorderSide>(
                                                    (Set<MaterialState>
                                                        states) {
                                              if (states.contains(
                                                  MaterialState.pressed)) {
                                                return const BorderSide(
                                                  color: Colors.black,
                                                );
                                              }
                                              return const BorderSide(
                                                color: Colors.black,
                                              );
                                            }),
                                          ),
                                          onPressed: () async {
                                            await controller
                                                .cancelarMasivoOrdenCompra();
                                          },
                                          child: const Text(
                                            'Cancelar',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(
                                  height: 20,
                                ),
                        ),
                      ],
                    );
            }),
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
