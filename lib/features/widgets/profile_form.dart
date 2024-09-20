
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordencompra/models/user_model.dart';
import 'package:ordencompra/utils/constants/sizes.dart';

import '../../controllers/profile_controller.dart';
import '../../utils/constants/text_strings.dart';

class ProfileFormScreen extends StatelessWidget{
  const ProfileFormScreen({
    Key? key,
    required this.uid,
    required this.employee, 
  }) : super(key: key);

  final TextEditingController uid;
  final TextEditingController employee;

@override
  Widget build(BuildContext context) {

    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: uid,
          ),
          const SizedBox(height: tFormHeight - 20),
          TextFormField(
            controller: employee,
          ),
          const SizedBox(height: tFormHeight - 20),
          TextFormField(
          ),
          const SizedBox(height: tFormHeight),

          /// -- Form Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: ()  async{
                final userData = UserModel(
                  email: '', 
                  full_name: '', 
                  id: '', 
                  role: '',
                );

                await (userData);

              },
              child: const Text(tEditProfile),
            ),
          ),
          const SizedBox(height: tFormHeight),

          /// -- Created Date and Delete Button
        ],
      ),
    );
  }
}