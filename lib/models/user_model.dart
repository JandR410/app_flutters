import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String? firebaseid;
  final String email;
  final String full_name;
  final String id;
  final String? role;

  const UserModel({
    this.firebaseid,
    required this.email,
    required this.full_name,
    required this.id,
    required this.role,
  });

  toJson(){
    return{
      "email": email,
      "firebase_id": firebaseid,
      "full_name": full_name,
      "id": id,
      "role": role,
    };
  }

  static UserModel empty () => const UserModel(email: '', full_name: '', id: '', role: '');

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    if(document.data() == null || document.data()!.isEmpty) return UserModel.empty();
    final data = document.data()!;
    return UserModel(
      firebaseid: document.id, 
      email: data["email"],
      full_name: data["full_name"],
      id: data["id"],
      role: data["role"],
    );
  }
}