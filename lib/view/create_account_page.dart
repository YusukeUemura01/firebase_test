import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_test/model/account.dart';
import 'package:firebase_test/utils/authentication.dart';
import 'package:firebase_test/utils/firestore/users.dart';
import 'package:firebase_test/utils/function_utils.dart';
import 'package:firebase_test/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.CreateAppBar("新規登録"),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  var result = await FunctionUtils.getImageGallery();
                  if (result != null) {
                    setState(() {
                      image = File(result.path);
                    });
                  }
                },
                child: CircleAvatar(
                  foregroundImage: image == null ? null : FileImage(image!),
                  //イメージがnullのときはなし
                  radius: 40,
                  child: Icon(Icons.add),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: "名前"),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: userIdController,
                  decoration: InputDecoration(hintText: "ユーザーID"),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: selfIntroductionController,
                  decoration: InputDecoration(hintText: "自己紹介"),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: "メールアドレス"),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: passController,
                  decoration: InputDecoration(hintText: "パスワード"),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        userIdController.text.isNotEmpty &&
                        selfIntroductionController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        passController.text.isNotEmpty &&
                        image != null) {
                      var result = await Authentication.signUp(
                          //resultにはUserCredential型のユーザ情報を格納
                          email: emailController.text,
                          pass: passController.text); //ログインが成功した場合はtrueが返ってくる

                      if (result is UserCredential) {
                        //resultがUserCredential型ならログイン成功
                        String imagePath = await FunctionUtils.upLoadImage(result.user!.uid,image!); //プロフィール画像をupし、URLを返す
                        Account newAccount = Account(
                          //setUser内でcreatedTimeとupdatetimeは定義しているのでいらない
                          id: result.user!.uid,
                          name: nameController.text,
                          userId: userIdController.text,
                          selfIntroduction: selfIntroductionController.text,
                          imagePath: imagePath,
                        );
                        var _result = await UserFirestore.setUser(
                            (newAccount)); //newAccountの情報をセットできたらtrueが返ってくる
                        if (_result == true) {
                          Navigator.pop(context);
                        }

                        print("アカウント作成成功");
                      } else {
                        //falseが返ってきたらログイン失敗
                        print("登録エラー");
                      }
                    }
                  },
                  child: const Text("登録"))
            ],
          ),
        ),
      ),
    );
  }
}
