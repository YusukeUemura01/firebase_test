
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/utils/authentication.dart';
import 'package:firebase_test/utils/firestore/users.dart';
import 'package:firebase_test/view/create_account_page.dart';
import 'package:firebase_test/view/screens.dart';
import 'package:firebase_test/view/time_line_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(""),
              Container(
                width: 300,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'メールアドレス'
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'パスワード'
                  ),
                  controller: passController,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: "アカウントを作成していない方は"),
                      TextSpan(
                        text: "こちら",
                        recognizer: TapGestureRecognizer()..onTap=(){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => CreateAccountPage()
                              )
                          );
                        },
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ]
                  ),
              ),
              ElevatedButton(onPressed: ()async{
                var result = await Authentication.emailSingIn(email: emailController.text, pass: passController.text);
                if(result is UserCredential){
                  var _result = await UserFirestore.getUser(result.user!.uid);//uidを送ってその人の情報を得る
                  if(_result == true){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Screen()));
                  }
                }else {
                  print("ログイン失敗");
                }
              },
                child: const Text("ログイン"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
