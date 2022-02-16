import 'package:cloud_firestore/cloud_firestore.dart';

class Account{
  late String id;
  late String name;
  late String imagePath;
  String selfIntroduction ="";
  late String userId; //見えるid
  Timestamp? createdTime;
  Timestamp? updatedTime;

  Account({this.id = "",this.name = "",this.imagePath = "",this.selfIntroduction = "",
     required this.userId, this.createdTime, this.updatedTime});
}

