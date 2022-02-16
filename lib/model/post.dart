import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  late String id;
  late String content;
  late String postAccountId;
  late Timestamp? createdTime;

  Post({this.id = "", this.content = "", this.postAccountId = "", this.createdTime});
}