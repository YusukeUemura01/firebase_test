import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/model/account.dart';

class Authentication{
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;
  static Account? myAccount;

  //アカウントを登録するメソッド
  static Future<dynamic> signUp({required String email,required String pass}) async{//引数にemailとpassをつける
    try{
      UserCredential newAccount = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
      print("auth完了");
      return newAccount;//うまくいっている場合はnewAccountを返す、なぜならnewAcoount.user.uidでidがとれる
    }on FirebaseAuthException catch(e){
      print("authエラー $e");
      return false;
    }

  }


  //アカウントをサインインするときのメソッド
  static Future <dynamic> emailSingIn({required String email,required String pass})async{
    try{
      final UserCredential _result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);//UserCredentialは型
      currentFirebaseUser = _result.user;
      print("サイイン完了");
      return _result;  //ユーザ情報を返す

    } on FirebaseAuthException catch(e){
      print("サイインエラー$e");
      return false;
    }

  }
}