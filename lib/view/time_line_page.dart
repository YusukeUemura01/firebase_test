import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/model/account.dart';
import 'package:firebase_test/model/post.dart';
import 'package:firebase_test/utils/firestore/posts.dart';
import 'package:firebase_test/utils/firestore/users.dart';
import 'package:firebase_test/view/acount_page.dart';
import 'package:firebase_test/view/post_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("タイムライン"),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 1, //アップバーの線を薄くなる
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: PostFirestore.posts.orderBy('created_time',descending: true).snapshots(),
        builder: (context, postSnapshot) {
          if(postSnapshot.hasData){
            List<String> postAccountIds =[];//投稿したユーザの全てのidの一覧
            postSnapshot.data!.docs.forEach((doc){
              Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
              if(!postAccountIds.contains(data['post_account_id'])){//投稿したユーザの全てのidの一覧にそのidが含まれていなかったら
                postAccountIds.add(data['post_account_id']);//投稿したユーザの全てのidの一覧にそのidを追加
              }
            });
            return FutureBuilder<Map<String,Account>?>(
              future: UserFirestore.getPostUserMap(postAccountIds),//投稿したユーザの全てのidの一覧を元に情報をとってくる
              builder: (context, userSnapshot){
                if(userSnapshot.hasData && userSnapshot.connectionState == ConnectionState.done){//情報の聖徳が完了したら
                  return ListView.builder(
                      itemCount: postSnapshot.data!.docs.length, //全体のポストの数だけ
                      itemBuilder: (context, index) {
                        Map<String,dynamic> data = postSnapshot.data!.docs[index].data() as Map<String,dynamic>;
                        Post post = Post(//投稿の情報
                          id: postSnapshot.data!.docs[index].id,
                          content: data['content'],
                          postAccountId: data['post_account_id'],
                          createdTime: data['created_time'],
                        );
                        Account postAccount = userSnapshot.data![post.postAccountId]!;//投稿者の情報
                        return Container(
                          decoration: BoxDecoration(
                            border: index == 0
                                ? Border(
                              top: BorderSide(color: Colors.grey, width: 0),
                              bottom: BorderSide(color: Colors.grey, width: 0),
                            )
                                : Border(bottom: BorderSide(color: Colors.grey, width: 0)),
                          ), //ListTitleを使う
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //TODO アイコンタップでプロフィール遷移
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => AccountPage()
                                      )
                                  );
                                },
                                child: CircleAvatar(
                                  //アイコン
                                  radius: 22,
                                  foregroundImage:
                                  NetworkImage(postAccount.imagePath), //マイアカウントのイメージパス
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        postAccount.name,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "@${postAccount.userId}",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Text(post.content),
                                  //TODO 改行できるようにする
                                  Text(
                                      DateFormat("H時m分 yyyy年 M月d日")
                                          .format(post.createdTime!.toDate()),//.todateでTimeStamp型からDateTime型に
                                      style: TextStyle(color: Colors.grey)),
                                  //intlライブラリdatetime型をstring型に
                                ],
                              ),
                            ],
                          ),
                        );
                      });
                }else{
                  return CircularProgressIndicator();
                }
              }
            );
          }else{
            return Container();
          }
        }
      ),
    );
  }
}
