import 'package:firebase_test/model/post.dart';
import 'package:firebase_test/utils/authentication.dart';
import 'package:flutter/material.dart';

import '../utils/firestore/posts.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController contentcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: IconThemeData(color: Colors.black),//これがないと戻るバタンが白になる
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: contentcontroller,
              ),
            ),
            ElevatedButton(
                onPressed: ()async{
                  if(contentcontroller.text.isNotEmpty){
                    Post newpost = Post(
                      content: contentcontroller.text,
                      postAccountId: Authentication.myAccount!.id!,
                    );
                   var result = await  PostFirestore.addPost(newpost);
                   if(result == true){
                     Navigator.pop(context);
                   }
                  }
                },
                child: Text("投稿")),
          ],
        ),
      ),
    );
  }
}
