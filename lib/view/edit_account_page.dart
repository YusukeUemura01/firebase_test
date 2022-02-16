import 'dart:io';

import 'package:firebase_test/model/account.dart';
import 'package:firebase_test/utils/authentication.dart';
import 'package:firebase_test/utils/firestore/users.dart';
import 'package:firebase_test/utils/function_utils.dart';
import 'package:firebase_test/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({Key? key}) : super(key: key);

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  Account? myAccount = Authentication.myAccount!;
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  File? image;

  ImageProvider getImage(){//null⇨画像が変更されていない状態なので元の画像
    if(image == null){
      return NetworkImage(myAccount!.imagePath);//プロフ作成時にimageは絶対nullでないため!をつけてる
    }else {
      return FileImage(image!);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: myAccount?.name);
    userIdController = TextEditingController(text: myAccount?.userId);
    selfIntroductionController = TextEditingController(text: myAccount?.selfIntroduction);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.CreateAppBar("プロフィール編集"),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async{
                  var result = await FunctionUtils.getImageGallery();
                  if (result != null) {
                    setState(() {
                      image = File(result.path);
                    });
                  }
                },
                child: CircleAvatar(
                  foregroundImage: getImage(),
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
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        userIdController.text.isNotEmpty &&
                        selfIntroductionController.text.isNotEmpty) {//イメージを変更してなくてもよいため
                      String imagePath = "";
                      if(image == null){//画像変更がないとき元の画像
                        imagePath = myAccount!.imagePath;
                      }else{
                        var result = FunctionUtils.upLoadImage(myAccount!.id, image!);
                        imagePath = result as String;
                      }
                      Account updateAccount = Account(//新しいユーザー情報を格納
                        id: myAccount!.id,
                        name: nameController.text,
                        userId: userIdController.text,
                        selfIntroduction: selfIntroductionController.text,
                        imagePath: imagePath
                      );
                      Authentication.myAccount = updateAccount;//端末内のアカウント情報を更新

                      var result = UserFirestore.updateUser(updateAccount);//firebaseのアカウント情報を更新
                      if(result == true){
                        Navigator.pop(context ,true);//trueを渡すことによって前の画面を更新
                      }
                    }
                  },
                  child: const Text("更新"))
            ],
          ),
        ),
      ),
    );
  }
}
