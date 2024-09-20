import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordencompra/controllers/profile_controller.dart';
import 'package:ordencompra/models/user_model.dart';
import 'package:ordencompra/utils/constants/sizes.dart';
import 'package:ordencompra/features/widgets/profile_form.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: iconOC(),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset('assets/images/menu.png'),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSpace),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  UserModel userData = snapshot.data as UserModel;

                  final uid = TextEditingController(text: userData.firebaseid);
                  final employee = TextEditingController(text: userData.email[0]);

                  return Column(
                    children: [
                      const SizedBox(height: 50),

                      ProfileFormScreen(uid: uid, employee: employee,),
                    ],
                  );
                } else if (snapshot.hasError){
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text('Something went wrong'));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )
        ),
      ),
    );
  }
}

Widget iconOC() {
  return Container(
    height: 30.0,
    width: 30.0,
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    child: new Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        new Image.asset(
          'assets/images/icono.png',
          width: 30.0,
          height: 30.0,
        ),
      ],
    ),
  );
}

