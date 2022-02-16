import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/utils/authentication.dart';

import '../../model/account.dart';

class UserFirestore{
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users = _firestoreInstance.collection("users");//usersコレクションの値をとってくる

  static Future<dynamic> setUser(Account newAccount)async{//引数にAccount
    try{
      await users.doc(newAccount.id).set({
        "name": newAccount.name,
        "user_id":newAccount.userId,
        "self_introduction":newAccount.selfIntroduction,
        "image_path":newAccount.imagePath,//cloud strageに保存した画像のurl
        "created_time":Timestamp.now(),
        "updated_time":Timestamp.now(),
      });
      print("新規ユーザのデータ保存完了");
      return true;//セットできたらtrueを返す
    }on FirebaseException catch(e){
      print("新規ユーザーのデータ保存エラー$e");
      return false;
    }
  }
  static Future <dynamic> getUser(String uid) async{//ログインした後にユーザ情報をとってくるメソッド
    try{
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();//uidを元に情報をとってくる
      Map<String,dynamic> data =documentSnapshot.data() as Map<String,dynamic>;
      Account myAccount = Account(
        id: uid,
        name: data['name'],
        userId: data['user_id'],
        selfIntroduction: data['self_introduction'],
        imagePath: data['image_path'],
        createdTime: data['created_time'],
        updatedTime: data['updated_time'],
      );
      Authentication.myAccount = myAccount;
      print("ユーザ情報取得完了");
      return true;
    }on FirebaseException catch(e){
      print("ユーザ情報取得失敗 $e");
      return false;
    }
  }
  static Future<dynamic> updateUser(Account updateAccount)async{
    try{
      await users.doc(updateAccount.id).update({
        'name':updateAccount.name,
        'image_path':updateAccount.imagePath,
        'use_id':updateAccount.userId,
        'self_introduction':updateAccount.selfIntroduction,
        'update_time':Timestamp.now(),
      });
      print("更新完了");
      return true;
    }on FirebaseException catch(e){
      print("更新完了エラー$e");
      return false;
    }
  }
  static Future<Map<String,Account>?> getPostUserMap(List<String> accountIds)async{//idを元にそのユーザ情報をとってくる
    Map<String,Account> map = {};//ユーザidとアカウント情報がセット
    try{
      await Future.forEach(accountIds, (String accountId)async{
        var doc = await users.doc(accountId).get();
        Map<String,dynamic> data = doc.data() as Map<String,dynamic>;//オブジェクト型をマップ型に変換
        Account postAccount = Account(
          id: accountId,
          name: data['name'],
          userId: data['user_id'],
          imagePath: data['image_path'],
          selfIntroduction: data['self_introduction'],
          createdTime: data['created_time'],
          updatedTime: data['updated_time'],
        );
        map[accountId] = postAccount;
      });
      print("投稿ユーザの情報取得完了");
      return map;
    }on FirebaseException catch(e){
      print("投稿ユーザの情報取得エラー $e");
      return null;
    }

  }
}